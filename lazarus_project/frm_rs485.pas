unit frm_rs485;



{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  serial, synaser, RS232Port, RS232Names, inifiles;

type

  { TfmRS485 }
  TRS232ReadWriteEventBinary = procedure(Sender: TObject; Status, NBytes: integer;
    Data: array of byte ) of object;

  TfmRS485 = class(TForm)
    btClear: TButton;
    btPortClose: TButton;
    btListPorts: TButton;
    btPortOpen: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    cbBaud: TComboBox;
    cbPorts: TComboBox;
    chHex: TCheckBox;
    chPrintCons: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbLastTime: TLabel;
    m: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    RS: TRS232Port;
    procedure btClearClick(Sender: TObject);
    procedure btPortCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btListPortsClick(Sender: TObject);
    procedure btPortOpenClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure cbBaudChange(Sender: TObject);
    procedure cbPortsChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RSAfterClose(Sender: TObject; NoError: boolean);
    procedure RSReadingProcess(Sender: TObject; Status, NBytes: integer;
      Data: ShortString);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    OnDataReceived: TRS232ReadWriteEventBinary;
  end;

var
  fmRS485: TfmRS485;

var
  serialhandle : LongInt;
  ComPortName  : String;
  s,tmpstr,txt : String;
  ComIn        : String;
  ComPortNr    : Integer;
  writecount   : Integer;
  status       : LongInt;
  Flags        : TSerialFlags;
  ErrorCode    : Integer;
  s2: array [0..255]of char;

  dbin:array of byte;

  inicom:TIniFile;

  var_income : array of byte;

implementation

uses Unit1;

{$R *.lfm}

procedure TfmRS485.Button1Click(Sender: TObject);
begin

  ComPortNr:= 5;
  tmpstr:= '';
  txt:= '';

  writeln('Parameters: ', ParamCount);
  if (ParamCount>0) then
  begin
    tmpstr:= ParamStr(1);
    val(tmpstr, ComPortNr, ErrorCode);

    if (ParamCount>1) then
      txt:= ParamStr(2);
  end;

  str(ComPortNr, tmpstr);

  ComPortName:= '/dev/ttyUSB0';
  writeln('Using: '+ComPortname);

  serialhandle := SerOpen(ComPortName);
  Flags:= [];
  SerSetParams(serialhandle, 19200, 8, NoneParity, 1, Flags);

  s:= txt;
  writeln('Output: '+s);
  s:= s+#13+#10;
  writecount:= length(s);

  status:= SerWrite(serialhandle, s[1], writecount);


  writeln('Status: ', status, ', WriteCount: ', writecount);

  sleep(100);
  status:= SerRead(serialhandle, s2, 100);
          m.lines.add(s2);


  SerSync(serialhandle);

  SerFlushOutput(serialhandle);

  SerClose(serialhandle);

end;

procedure TfmRS485.btPortCloseClick(Sender: TObject);
begin
  rs.Close;
  m.Lines.Add('Порт '+ rs.Device +' звкрыт');
end;

procedure TfmRS485.btClearClick(Sender: TObject);
begin
  m.Lines.Clear;
end;

procedure TfmRS485.Button2Click(Sender: TObject);

var
  ser: TBlockSerial;  sx:String;
begin
  ser:=TBlockSerial.Create;
  try
       ser.config(19200, 8, 'N', SB1, False, False);
    ser.Connect( '/dev/ttyUSB0');

    sx:=ser.Recvstring(10);
    caption:=sx;
  finally
    ser.free;
  end;
end;

procedure TfmRS485.btListPortsClick(Sender: TObject);
var s,pname:string;i:Integer;
begin

  s:=RS232NamesListForce;
  cbPorts.Items.CommaText:=s;
  m.Lines.Add('Обнаружены установленные последовательные порты: '+s);

  pname:=inicom.ReadString('port','name','/dev/ttyUSB0');
  i:= cbPorts.Items.IndexOf(pname);
  if i=-1 then
   begin
     i:=0;
     if cbPorts.Items.Count>0 then
       begin
        cbPorts.ItemIndex:=0;
        inicom.WriteString('port','name',cbPorts.Items[0]);
       end;
   end
  else
   begin
     cbPorts.ItemIndex:=i;
   end;



end;

procedure TfmRS485.btPortOpenClick(Sender: TObject);
begin
  if rs.Active then
   begin
    rs.Close;
   end;

  FormCreate(nil);

  rs.Open;
  m.Lines.Add('Порт '+ rs.Device +' oткрыт и готов к приему данных на скорости '+cbBaud.Text);
end;

procedure TfmRS485.Button3Click(Sender: TObject);
begin
  close;
end;

procedure TfmRS485.cbBaudChange(Sender: TObject);
begin
  inicom.WriteInteger('port','baudrate',strtointdef(cbbaud.Items[cbbaud.ItemIndex],19200)  );
end;

procedure TfmRS485.cbPortsChange(Sender: TObject);
begin
  inicom.WriteString('port','name',cbports.Items[cbports.ItemIndex]);
end;

procedure TfmRS485.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  chPrintCons.Checked:=false;
end;

procedure TfmRS485.FormCreate(Sender: TObject);
var b,i:Integer;  sDev, s1 :string;
begin
  btListPorts.Click;



  b:=inicom.ReadInteger('port','baudrate',19200);
  i:=cbBaud.Items.IndexOf(inttostr(b));
  if i<>-1 then
   cbBaud.ItemIndex:=i
  else
    cbbaud.ItemIndex:=4;


  s1:='';
  if cbports.ItemIndex>-1 then s1:=cbports.Items[cbports.ItemIndex];
  sDev:= '/dev/'+  s1;
  m.Lines.Add('Выбран порт: '+sdev);
  rs.device:=  sdev;
end;

procedure TfmRS485.FormShow(Sender: TObject);
begin
   chPrintCons.Checked:=true;
end;

procedure TfmRS485.RSAfterClose(Sender: TObject; NoError: boolean);
begin

end;


function crc_my(const a:array of byte):Byte;
var i:Integer;
begin
  //
  result:=0;
  for i:= 0 to length(a)-3-1 do
   begin
    result:=result xor a[i];
   end;


end;

procedure TfmRS485.RSReadingProcess(Sender: TObject; Status, NBytes: integer;
  Data: ShortString);
var i, var_ind, var_len :integer; s:string; crc:Byte;
begin
  lbLastTime.Caption:=dateTimeToStr(Now);
  if assigned(OnDataReceived) then
   begin

    setLength(dbin,nbytes);

    for i:=0 to nbytes-1 do
        begin
          dbin[i]:=byte(data[i+1]);
        end;

    var_ind:= dbin[1];
    var_len:= dbin[2];
    crc:=crc_my(dbin);
    setLength( var_income,  NBytes-6);
    for i:=0 to var_len-1 do
      begin
       var_income[i]:= dbin[3+i];
      end;


    //////////


    OnDataReceived(TObject(pointer(var_ind)) , status, Length(var_income), var_income);
    Form1.lbUpdateTime.caption:=DateTimetostr(now);
    Form1.lbUpdateTime1.caption:=DateTimetostr(now);
    with form1 do
    if shp.Width>=150 then shp.Width:=0 else shp.Width:=shp.Width+10;
   end;

  s:='';

  if chPrintCons.Checked then
   begin
    if m.Lines.Count>10000 then m.Lines.Clear;

    if not chHex.Checked then
     begin

     s:=data;
     end
    else
     begin

       for i:=0 to nbytes-1 do
        begin
          s:=s+IntTohex( byte( data[i+1] ),2)+',';
        end;


     end;
     m.Lines.Add( timetostr(now)+' < '+inttostr(nbytes)+' bytes > '+s);
   end;
end;

procedure TfmRS485.Timer1Timer(Sender: TObject);
begin

end;


initialization

inicom:= TIniFile.Create('com_port.ini');

end.

