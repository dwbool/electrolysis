unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Sockets, LCLIntf, ComCtrls, Buttons, Menus, hydr_files, hydr_utils, Unit2,
  frm_settings, extra_defs, dateUtils,

{$IFDEF UNIX}
  unix,
{$ENDIF}

inifiles, Types;


type


  tcls =       class of TObject;

  { TForm1 }

  TGetTagControl =  function   (tp: tcls  ; tag2:Integer):TControl;

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    btArch: TButton;
    btReadAlerts: TButton;
    btRequest: TButton;
    btRequestCoils: TButton;
    btRequestLim4: TButton;
    btRequestLimits2: TButton;
    btRequestLimi3: TButton;
    btScanSound: TToggleBox;
    btSound: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    chContinuous: TCheckBox;
    chSound: TCheckBox;
    im1: TImage;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    lbUser: TLabel;
    lbChartTime: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label6: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label7: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label8: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    lbCoils: TLabel;
    Label9: TLabel;
    lbNow: TLabel;
    lbUpdateTime: TLabel;
    lbUpdateTime1: TLabel;
    lbx_alerts: TListBox;
    m: TMemo;
    m2: TMemo;
    MainMenu1: TMainMenu;
    m3: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    miWriteChart: TMenuItem;
    Separator2: TMenuItem;
    miLogin: TMenuItem;
    miLogout: TMenuItem;
    MenuItem4: TMenuItem;
    panButtons1: TPanel;
    panButtons2: TPanel;
    panButtons0: TPanel;
    Separator1: TMenuItem;
    miProperties: TMenuItem;
    miSelectChart: TMenuItem;
    miSettLimits: TMenuItem;
    miSettingsGeneral: TMenuItem;
    miRS485: TMenuItem;
    miSettings: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    panChart: TPanel;
    pbr: TProgressBar;
    popm: TPopupMenu;
    sbSaveLog: TSpeedButton;
    sd: TSaveDialog;
    Shape1: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    Shape2: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    Shape29: TShape;
    Shape3: TShape;
    Shape30: TShape;
    Shape31: TShape;
    Shape32: TShape;
    Shape33: TShape;
    Shape34: TShape;
    Shape35: TShape;
    Shape36: TShape;
    Shape37: TShape;
    Shape38: TShape;
    Shape39: TShape;
    Shape4: TShape;
    Shape40: TShape;
    Shape41: TShape;
    Shape42: TShape;
    Shape43: TShape;
    Shape44: TShape;
    Shape45: TShape;
    Shape46: TShape;
    Shape47: TShape;
    Shape48: TShape;
    Shape49: TShape;
    Shape5: TShape;
    Shape50: TShape;
    Shape51: TShape;
    Shape52: TShape;
    Shape53: TShape;
    Shape54: TShape;
    Shape55: TShape;
    Shape56: TShape;
    Shape57: TShape;
    Shape58: TShape;
    Shape59: TShape;
    Shape6: TShape;
    Shape60: TShape;
    Shape61: TShape;
    Shape62: TShape;
    Shape63: TShape;
    Shape64: TShape;
    Shape65: TShape;
    Shape66: TShape;
    Shape67: TShape;
    Shape68: TShape;
    Shape69: TShape;
    Shape7: TShape;
    Shape70: TShape;
    Shape71: TShape;
    Shape72: TShape;
    Shape73: TShape;
    Shape74: TShape;
    Shape8: TShape;
    Shape9: TShape;
    shp: TShape;
    SpeedButton1: TSpeedButton;
    btRequestWrite: TToggleBox;
    tsDiag: TTabSheet;
    tsScheme: TTabSheet;
    tsInputs: TTabSheet;
    Timer1: TTimer;
    ToggleBox1: TToggleBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btArchClick(Sender: TObject);
    procedure btReadAlertsClick(Sender: TObject);
    procedure btRequestClick(Sender: TObject);
    procedure btRequestLim4Click(Sender: TObject);
    procedure btRequestLimi3Click(Sender: TObject);
    procedure btRequestLimits2Click(Sender: TObject);
    procedure btRequestWriteChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure btRequestCoilsClick(Sender: TObject);
    procedure btSoundClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure chContinuousChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Label111Click(Sender: TObject);
    procedure Label41Click(Sender: TObject);
    procedure Label81Click(Sender: TObject);
    procedure miLoginClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure miLogoutClick(Sender: TObject);
    procedure miPropertiesClick(Sender: TObject);
    procedure miRS485Click(Sender: TObject);
    procedure miSettingsClick(Sender: TObject);
    procedure miSettingsGeneralClick(Sender: TObject);
    procedure miWriteChartClick(Sender: TObject);
    procedure panChartClick(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure popmPopup(Sender: TObject);
    procedure sbSaveLogClick(Sender: TObject);
    procedure Shape56ChangeBounds(Sender: TObject);
    procedure Shape62ChangeBounds(Sender: TObject);
    procedure Shape62MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure hape62MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape62Paint(Sender: TObject);
    procedure Shape63MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape63MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape64MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape64MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape64Paint(Sender: TObject);
    procedure Shape65MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape65MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape65Paint(Sender: TObject);
    procedure Shape66MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape66MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape67MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape67MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btScanSoundChange(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure tsInputsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private

  public

    blink_shapes:TList;
    dtProgStart:TDateTime;

    blink_hide:Boolean;
    procedure start_blink(sh:TShape);
    procedure stop_blink(sh:TShape);
    procedure perform_blink;

    procedure displayCoils(getTagControl:TGetTagControl ; coils:Int64 ; redColor:TColor);

    procedure displayCoils_high(getTagControl:TGetTagControl ; coils:Int64 ; redColor:TColor);

    procedure displayAnalogValues(getTagControl:TGetTagControl   ; buf_recv:array of byte );

    function request_limits(reg:Integer; var lims:array of double):integer;

    function getCommInterface:Integer;
    property CommInterface:Integer read    getCommInterface;
    procedure RS485TurnOn;
    procedure RS485TurnOff;

    procedure request_display_analog(buf_recv: array  of byte         );
    procedure RS485ReceivedData (Sender: TObject; Status, NBytes: integer;     Data: array of byte )  ;


  end;

var
  Form1: TForm1;
   ctr:byte=0;
   thr:TMyThread;
   var ctr_alerts_read:Integer=9;
   ini,ini_chart :TInifile;



   function coils_from_buff( buf_recv:array of byte):int64;
   function coils_from_buff_high( buf_recv:array of byte):int64;


   function buf_to_archstr(buf:array of byte; len:Integer):String;

   function  getTagControl(tp: tcls  ; tag2:Integer):TControl;







implementation uses frm_chart, frm_login, frm_graph, tag_control_utils,
  frm_rs485, frm_sett_commun, frm_chart_prop, imginf, ctrl_organs,
  frm_change_passw, ain_def;

{$R *.lfm}




procedure TForm1.start_blink(sh:TShape);
begin
  // error is gone
  if blink_shapes.IndexOf(sh)=-1 then
  blink_shapes.Add(sh);
end;


procedure TForm1.stop_blink(sh:TShape);
begin
  // error cleared
  blink_shapes.Remove(sh);
  sh.Visible:=true;
end;


procedure TForm1.perform_blink;
var i:Integer;
begin
  blink_hide:=not blink_hide;
  for i:=0 to blink_shapes.Count-1 do
   begin
    TShape(blink_shapes[i]).Visible:=not blink_hide;
   end;

end;


function TForm1.getCommInterface:Integer;

begin
  //    communication type selection
  if fmCommun<>nil then
   begin
   result:=fmCommun.rgInterface.ItemIndex;

   end
  else
   begin
   result:=0;
   end;



end;



procedure TForm1.RS485TurnOn;
begin
  if not fmRs485.RS.Active then
   begin
    fmrs485.btPortOpenClick(nil);
   end;
end;


procedure TForm1.RS485TurnOff;
begin
  if  fmRs485.RS.Active then
   begin
    fmrs485.btPortCloseClick(nil);
   end;

end;


procedure TForm1.btScanSoundChange(Sender: TObject);
var i:Integer;
begin
  if not chsound.Checked then exit;;
  for i:=0 to scan_frm.ControlCount-1 do
    begin
     if scan_frm.Controls[i] is Tshape then
       begin
         if  tshape(scan_frm.Controls[i]).Brush.Color<>clWhite then
           begin
             btSoundClick(nil);
             exit;
           end;
       end;

    end;

end;


function buf_to_archstr(buf:array of byte; len:Integer):String;
var i:Integer;s:string;
begin
  s:='';   result:=s;
  for i:=0 to len-1 do
     begin

      s:=s+inttohex(buf[i], 2)+',';

     end;
  result:=s;
end;



function  getTagControl_diag(tp: tcls  ; tag2:Integer):TControl;
var i:Integer;
begin
  result:=  nil;
  for i:=0 to form1.tsDiag.ControlCount-1 do
    begin
     if form1.tsDiag.Controls[i] is tp then
       begin
         if  form1.tsDiag.Controls[i].Tag=tag2 then
           begin
             result:=   form1.tsDiag.Controls[i];
             exit;
           end;
       end;

    end;

end;


function  getTagControl(tp: tcls  ; tag2:Integer):TControl;
var i:Integer;
begin
  result:=  nil;
  for i:=0 to form1.tsInputs.ControlCount-1 do
    begin
     if form1.tsInputs.Controls[i] is tp then
       begin
         if  form1.tsInputs.Controls[i].Tag=tag2 then
           begin
             result:=   form1.tsInputs.Controls[i];
             exit;
           end;
       end;

    end;

end;


function getTagControl_(tp: tcls  ;tag:Integer):TControl;
var i:Integer;
begin
    result:=  nil;
  for i:=0 to form1.ControlCount-1 do
    begin
     if form1.Controls[i] is tp then
       begin
         if  form1.Controls[i].Tag=tag then
           begin
             result:=   form1.Controls[i];
             exit;
           end;
       end;

    end;

end;



function getTagControl_2(tp: tcls  ;tag:Integer):TControl;
var i:Integer;
begin
    result:=  nil;
  for i:=0 to application.ComponentCount-1 do
    begin
     if application.Components[i] is tp then
       begin
         if  application.Components[i].Tag=tag then
           begin
             result:=   application.Components[i] as TControl;
             exit;
           end;
       end;

    end;

end;



const
Buf_req: array [0..11] of byte  =($00 ,$8F ,$00 ,$00 ,$00 ,$06 ,$01 ,$03 ,$00 ,$00 ,$00 ,$15 );
const  buf_read_coils:array [0..11] of byte= ($09 ,$4F ,$00 ,$00 ,$00 ,$06 ,$01    ,$01    ,$00 ,$00 ,$00 ,  $40  );

       buf_read_limits2:array [0..11] of byte= ($09 ,$4F ,$00 ,$00 ,$00 ,$06 ,$01    ,$03    ,$00 ,$c8,$00 ,  $15 );




procedure TForm1.RS485ReceivedData (Sender: TObject; Status, NBytes: integer;     Data: array of byte )    ;
var var_ind:Integer;  coils, coils_hi :int64;
begin
  var_ind:= Integer(pointer(sender));
  if var_ind=0 then
    begin
      coils:=  coils_from_buff( data    );
      coils_hi :=  coils_from_buff_high( data    );

      lbcoils.Caption:='   hi='+Inttohex(coils_hi) +'   lo='+Inttohex(coils);

      displayCoils(@getTagControl_diag,  coils, clred);
      displayCoils(@getTagControl,       coils, rgb(255,190,190) );

      displayCoils_high(@getTagControl_diag,  coils_hi, rgb(255,190,190) );
      displayCoils_high(@getTagControl,       coils_hi, rgb(255,190,190) );
    end
  else if var_ind=1 then
    begin

      request_display_analog(data);

    end;


end;

procedure TForm1.request_display_analog(buf_recv: array  of byte         );
begin
  displayAnalogValues(@gettagcontrol ,buf_recv);
  displayAnalogValues(@gettagcontrol_diag,buf_recv);
end;



var
   buf_recv: array [0..999] of byte;
   recv_size:integer;

   s_ains, s_coils : String;

procedure TForm1.btRequestClick(Sender: TObject);



  procedure PError(const S: string);
  var
    ErrorMsg: string;
  begin
    case socketerror of
      EsockADDRINUSE: ErrorMsg := 'Error number when socket address is already in use';
      EsockEACCESS: ErrorMsg := 'Access forbidden error';
      EsockEBADF: ErrorMsg := 'Alias: bad file descriptor';
      EsockEFAULT: ErrorMsg := 'Alias: an error occurred';
      EsockEINTR: ErrorMsg := 'Alias : operation interrupted';
      EsockEINVAL: ErrorMsg := 'Alias: Invalid value specified';
      EsockEMFILE: ErrorMsg := 'Error code ?';
      EsockEMSGSIZE: ErrorMsg := 'Wrong message size error';
      EsockENOBUFS: ErrorMsg := 'No buffer space available error';
      EsockENOTCONN: ErrorMsg := 'Not connected error';
      EsockENOTSOCK: ErrorMsg := 'File descriptor is not a socket error';
      EsockEPROTONOSUPPORT: ErrorMsg := 'Protocol not supported error';
      EsockEWOULDBLOCK: ErrorMsg := 'Operation would block error';
      else
        ErrorMsg := 'Undescribed error : ' + IntToStr(socketerror);
    end;
    writeln(S, ErrorMsg);
  end;

var

  SockDesc: longint;

  SockAddr: TInetSockAddr;

  i: longint;
  Result, RecvSize: longint;
   s:string;
   bhi,blo:byte;
   val:integer;
   fval:Double;
   lb:TLabel;

   s10:string;

   const buf:array [0..11] of byte=(   00 ,$B0 ,$00 ,$00 ,$00 ,$06 ,$01 ,$05 ,$00 ,$00 ,$FF ,$00);

begin

  RecvSize:=0;
  m.Lines.Clear;
  try
  ctr:=ctr+1;

  buf[1]:=ctr;

  SockDesc := fpSocket(AF_INET, SOCK_STREAM, 0);
  if SockDesc = -1 then
    Perror('[Client] Socket : ');
  SockAddr.sin_family := AF_INET;

  SockAddr.sin_port := htons(502);

  SockAddr.sin_addr := StrToNetAddr('10.0.6.10');

  if fpconnect(SockDesc, @SockAddr, SizeOf(SockAddr)) = -1 then
     PError('[Client] Connect : ');

  begin

    if sender=btRequest then
     begin

     Result := fpsend(SockDesc, @buf_req, 12,0);


     end
    else
     begin

       if sender = tobject(30) then
        begin

            Result := fpsend(SockDesc, @buf_read_coils, 12,0);

        end;
       if sender = tobject(41) then
        begin

            Result := fpsend(SockDesc, @buf_read_limits2, 12,0);

        end
       else if integer(pointer(sender)) in [$50..$5F] then
        begin
          prepare_ctrl_organ_array(integer(pointer(sender)));
          Result := fpsend(SockDesc, @arr_ctrl_organ, 12,0);

        end
       else if  integer(pointer(sender)) in [$60] then
        begin
          prepare_ctrl_organ_array(integer(pointer(sender)));
          Result := fpsend(SockDesc, @buf_write_reg_w, 15, 0);

        end


     end;

    sleep(5);

    RecvSize :=
                fprecv(SockDesc, @buf_recv, sizeof(buf_recv) , 0);
    recv_size:=recvSize ;

  end;

  m.Lines.Add(inttostr(recvSize));
  s:='';
  for i:=0 to recvSize-1 do
   begin
    s:=s+IntToHex(integer(buf_recv[i]),2)+' ';


   end;
  m.Lines.Add('received: ');
  m.Lines.Add(s);




  if pbr.Position=pbr.Max then pbr.Position:=0 else  pbr.Position:=pbr.Position+1;
  if shp.Width>=150 then shp.Width:=0 else shp.Width:=shp.Width+10;

  if (sender=btRequest) and (buf_recv[7]=3  ) then
   begin
     label78.Caption:=buf_to_archstr(buf_recv,RecvSize);
  s_ains:=    buf_to_archstr(buf_recv,RecvSize);
  s10:=s_ains;
  m.Lines.Add('arc '+ s10);
   for i:=0 to 20 do
    begin
    bhi:=byte(buf_recv[9+i*2]);
    blo:=byte(buf_recv[10+i*2]);

    if (bhi and $80)=0 then
     begin
     val:= ((bhi shl 8) and $ff00) or blo;

     end
    else
     begin
     val:= (((bhi and $7F) shl 8) and $ff00) or blo  ;
     val:= val -  32768;
     end;


    fval:=val *factors[i+1]  /10.0;
    AIN_DEFS_NOW[i+1].present_value:= fval;
    AINS_FROM_0_NOW[i]:= fval;

    m.Lines.Add(inttostr(i+1)+' : '+inttostr(val));

    lb:=tlabel(gettagcontrol(TLabel, 100+i+1));
    lb.Caption:=  formatfloat(formats[i+1] ,fval);

    end;
    AINS_FROM_0_NOW_written:=true;

   displayAnalogValues(@gettagcontrol_diag,buf_recv);

   if miWriteChart.Checked then
    write_chart_ains_simple(now, AINS_FROM_0_NOW);


   end;

  if fpshutdown(SockDesc, 2) = -1 then
    PError('[Client] Shutdown : ');

  if CloseSocket(SockDesc) = -1 then
    PError('[Client] Close : ');


  except
  end;

  if recvSize>0 then
    begin
    lbUpdateTime.Caption:= DateTimeToStr(now);
    lbUpdateTime1.Caption:= DateTimeToStr(now);
    end;
end;







function TForm1.request_limits(reg:Integer; var lims:array of double):integer;
 var i:Integer;   val:Double;    ed:tedit;
begin
  //
  result:=-1;
  buf_read_limits2[8]:= (reg shr 8) and $000000ff;
  buf_read_limits2[9]:= (reg shr 0) and $000000ff;


  btRequestClick(tobject(41));
  result:= buf_recv[7];

  if  (buf_recv[7]=3  ) then
   begin

     s_ains:=    buf_to_archstr(buf_recv,Recv_Size);
     m3.lines.add(s_ains );

     buf_to_ains(buf_recv,lims,recv_size);
     for i:=0 to AIN_COUNT-1 do
      begin

       ed:= tedit( getTagControlOf(tedit, 1000+i+1, fmSettings));
       if ed<>nil then
        begin

        end;

      end;


   end;

end;


procedure TForm1.btRequestLimits2Click(Sender: TObject);
var i,res:Integer;   val:Double;  lims:array [0..AIN_COUNT-1] of double;  ed:tedit;
begin
  //
  res:=request_limits(200,lims);


  if  ( res=3  ) then
   begin

     for i:=0 to AIN_COUNT-1 do
      begin
       //
       ed:= tedit( getTagControlOf(tedit, 1000+i+1, fmSettings));
       if ed<>nil then
        begin
          ed.Text:= floattostr(lims[i]);
        end;

      end;


   end;

end;

procedure TForm1.btRequestWriteChange(Sender: TObject);
begin

end;


procedure TForm1.btRequestLimi3Click(Sender: TObject);
var i,res:Integer;   val:Double;  lims:array [0..AIN_COUNT-1] of double;  ed:tedit;
begin
  res:= request_limits(300,lims);
  if  (res=3  ) then
   begin
     for i:=0 to AIN_COUNT-1 do
      begin
       ed:= tedit( getTagControlOf(tedit, 2000+i+1, fmSettings));
       if ed<>nil then
        begin
          ed.Text:= floattostr(lims[i]);
        end;
      end;
   end;
end;


procedure TForm1.btRequestLim4Click(Sender: TObject);
var i,res:Integer;   val:Double;  lims:array [0..AIN_COUNT-1] of double;  ed:tedit;
begin
  res:= request_limits(400,lims);
  if  (res=3  ) then
   begin
     for i:=0 to AIN_COUNT-1 do
      begin
       ed:= tedit( getTagControlOf(tedit, 3000+i+1, fmSettings));
       if ed<>nil then
        begin
          ed.Text:= floattostr(lims[i]);
        end;
      end;
   end;
end;




procedure TForm1.btArchClick(Sender: TObject);
var fs: TFilestream;
   var s, dir, fn, arc_dir :String;    s2:array [0..8] of char;    mode:word;


begin


 try
 s:= #13#10+datetimetostr(now)+'>'+s_coils+'|'+s_ains;
 dir := Extractfilepath( Application.exename);
 arc_dir:=    'archive/';
 CreateDir( dir + arc_dir);

 m.lines.add(dir);
 mode:=  fmOpenReadWrite  or fmShareDenyNone ;
 fn:=   dir+arc_dir+  DateToStr_cust(now)+'.txt';
 if not fileexists(   fn) then
  begin
   mode:=mode or fmCreate;;
   m.lines.add('not exists '+fn);
  end
 else
  begin
     m.lines.add('  exists '+fn);
  end;
 fs:= TFilestream.Create(fn,mode);
 fs.Read(s2,9);
 m.lines.add(s2);
 fs.Position:=fs.Size-0 ;
           m.lines.add(inttostr( fs.Position ) );

  m.lines.add(inttostr( length(s) ) );
 fs.Write( pchar(s) ^ , length(s));
 fs.free;

  except
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  btRequestClick(TObject(BUTTON_CLEAR_ALERT_SENDER));
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  if    (sender as tbitbtn).Tag=0 then
   begin
   (sender as tbitbtn).Tag:=1;
   label110.Caption:=('1');
   end;
end;

procedure TForm1.BitBtn2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  label110.Caption:=('0');
end;


procedure TForm1.Shape62MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     //
  label110.Caption:=('1');
  (sender as tshape).Brush.Color:=clGray;
  btRequestClick(TObject(BUTTON_PLUS_1_SENDER));
end;

procedure TForm1.hape62MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //
  label110.Caption:=('0');
  (sender as tshape).Brush.Color:=clAqua;
  btRequestClick(TObject(BUTTON_PLUS_1_SENDER_rel));
end;

procedure TForm1.Shape62Paint(Sender: TObject);
begin
  (Sender as TShape).Canvas.TextOut(10,10,'Ток 1 +');
end;

procedure TForm1.Shape63MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (sender as tshape).Brush.Color:=clgray;
  btRequestClick(TObject(BUTTON_PLUS_2_SENDER));
end;

procedure TForm1.Shape63MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (sender as tshape).Brush.Color:=clAqua;
  btRequestClick(TObject(BUTTON_PLUS_2_SENDER_rel));
end;

procedure TForm1.Shape64MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (sender as tshape).Brush.Color:=clGray;
  btRequestClick(TObject(BUTTON_MINUS_1_SENDER));
end;

procedure TForm1.Shape64MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (sender as tshape).Brush.Color:=clAqua;
  btRequestClick(TObject(BUTTON_MINUS_1_SENDER_rel));
end;

procedure TForm1.Shape64Paint(Sender: TObject);
begin
  (Sender as TShape).Canvas.TextOut(10,10,'Ток 1 -');
end;

procedure TForm1.Shape65MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (sender as tshape).Brush.Color:=clGray;
  btRequestClick(TObject(BUTTON_RESET_1_SENDER));
end;

procedure TForm1.Shape65MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (sender as tshape).Brush.Color:=clAqua;
  btRequestClick(TObject(BUTTON_RESET_1_SENDER_REL));
end;

procedure TForm1.Shape65Paint(Sender: TObject);
begin
 (Sender as TShape).Canvas.TextOut(10,10,'Сброс');
end;

procedure TForm1.Shape66MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (sender as tshape).Brush.Color:=clgray;
  btRequestClick(TObject(BUTTON_minus_2_SENDER));
end;

procedure TForm1.Shape66MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (sender as tshape).Brush.Color:=clAqua;
  btRequestClick(TObject(BUTTON_minus_2_SENDER_rel));
end;

procedure TForm1.Shape67MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (sender as tshape).Brush.Color:=clgray;
  btRequestClick(TObject(BUTTON_RESET_2_SENDER));
end;

procedure TForm1.Shape67MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   (sender as tshape).Brush.Color:=clAqua;
   btRequestClick(TObject(BUTTON_RESET_2_SENDER_rel));
end;



procedure TForm1.btReadAlertsClick(Sender: TObject);
var n:Integer;
begin
  try
  n:= lbx_alerts.ItemIndex;;
  lbx_alerts.Items.LoadFromFile(  thr.out_dir + 'alerts.txt'  );
  lbx_alerts.ItemIndex:=n;
  except
  end;
end;


procedure TForm1.displayAnalogValues(getTagControl:TGetTagControl ; buf_recv:array of byte );
var i,val:Integer; fval:double; bhi,blo:byte;     lb:tlabel;
begin
  for i:=0 to 20 do
    begin
    bhi:=byte(buf_recv[9+i*2]);
    blo:=byte(buf_recv[10+i*2]);

    if (bhi and $80)=0 then
     begin
     val:= ((bhi shl 8) and $ff00) or blo;

     end
    else
     begin
     val:= (((bhi and $7F) shl 8) and $ff00) or blo  ;
     val:= val -  32768;
     end;


    fval:=val *factors[i+1]  /10.0;

    lb:=tlabel(gettagcontrol(TLabel, 100+i+1));
    if lb<>nil then lb.Caption:=  formatfloat(formats[i+1] ,fval);

    end;


end;

procedure TForm1.displayCoils(getTagControl:TGetTagControl ; coils:Int64 ; redColor:TColor);
  var b2,b3:byte;   i   :Integer;        sh:TShape;
begin

  m2.Lines.Clear;
  for i:=0 to  33 do
    begin
     sh:=TShape(getTagControl(tshape,200+i));
     if sh<>nil then
      begin


        if  (coils and (int64(1) shl i)   )<>0 then
         begin

           m2.Lines.Add(sh.Name);
           sh.Brush.Color:= redColor;
           sh.Brush.Style:=bsSolid;

         end  else
         begin

           sh.Brush.Color:=clwhite;



         end;
      end;

    end;

  for i:=34 to   63 do
    begin
     sh:=TShape(getTagControl(tshape,200+i-34+13));
     if sh<>nil then
      begin
        if sh.Brush.Color=clwhite  then
         if  (coils and (int64(1) shl i)   )>0 then    sh.Brush.Color:=clYellow;
      end;
     end;



  for i:=0 to   8 do
    begin
     //
     sh:=TShape(getTagControl(tshape,213+i ));
     if sh<>nil then
      begin
        if sh.Brush.Color=clwhite  then
         if  (coils and (int64(1) shl (i+55))   )<>0 then    sh.Brush.Color:=clGray;
      end;
    end;




  for i:=0 to 63 do
    begin
     sh:=TShape(getTagControl(tshape,200+i));
     if sh<>nil then
      begin

        if sh.Brush.Color=clwhite  then
          begin

          end
        else
          begin
            sh.Brush.Style:=bsSolid;
            if sh.Pen.Style=psClear then
              begin
               sh.Brush.Color:=sh.Pen.Color;
              end;
          end;
      end;

    end;

end;




procedure TForm1.displayCoils_high(getTagControl:TGetTagControl ; coils:Int64 ; redColor:TColor);
  var b2,b3:byte;   i   :Integer;        sh:TShape;
begin

  m2.Lines.Clear;
  for i:=0 to 11 do
    begin
     sh:=TShape(getTagControl(tshape,222+i));
     if sh<>nil then
      begin

        if  (coils and (int64(1) shl i)   )<>0 then
         begin

           m2.Lines.Add(sh.Name);
           sh.Brush.Color:= clGray ;

         end  else
         begin




         end;
      end;

    end;


  for i:=12 to 45  do
    begin
     sh:=TShape(getTagControl(tshape,200+(i-12)));
     if sh<>nil then
      begin
       if  (coils and (int64(1) shl i)   )<>0 then
         begin
          start_blink(sh);
         end
       else
        begin
         stop_blink(sh);
        end;
      end;
    end;

  for i:=0 to 63 do
    begin
     sh:=TShape(getTagControl(tshape,222+i));
     if sh<>nil then
      begin

        if sh.Brush.Color=clwhite  then
          begin

          end
        else
          begin
            sh.Brush.Style:=bsSolid;
            if sh.Pen.Style=psClear then
              begin
               sh.Brush.Color:=sh.Pen.Color;
              end;
          end;
      end;

    end;

end;



function coils_from_buff( buf_recv:array of byte):int64;
var b2,b3:byte;
begin
  b2:= buf_recv[10];
  b3:= buf_recv[11];
  result:=((  int64(buf_recv[17]) shl 56)and $ff00000000000000)  or     ((  int64(buf_recv[16]) shl 48)and $ff000000000000)  or ((  int64(buf_recv[15]) shl 40)and $ff0000000000)  or  ((  int64(buf_recv[14]) shl 32)and $ff00000000)  or        ((buf_recv[13] shl 24)and $ff000000)  or    ((buf_recv[12] shl 16)and $ff0000)  or   ((b3 shl 8)and $ff00) or (b2 and $00ff)   ;

end;



function coils_from_buff_high( buf_recv:array of byte):int64;
var b2,b3:byte;  n:Integer;
begin
   n:=8;
  b2:= buf_recv[10+n];
  b3:= buf_recv[11+n];
  result:=    ((  int64(buf_recv[16+n]) shl 48)and $ff000000000000)  or ((  int64(buf_recv[15+n]) shl 40)and $ff0000000000)  or  ((  int64(buf_recv[14+n]) shl 32)and $ff00000000)  or        ((buf_recv[13+n] shl 24)and $ff000000)  or    ((buf_recv[12+n] shl 16)and $ff0000)  or   ((b3 shl 8)and $ff00) or (b2 and $00ff)   ;

end;


procedure TForm1.btRequestCoilsClick(Sender: TObject);
var   i, coils,coils_hi :Int64;        sh:TShape;
begin

  btRequestClick(tobject(30));

  if buf_recv[7]<>1   then exit;

  s_coils:=    buf_to_archstr(buf_recv , Recv_Size);



  coils:=     coils_from_buff  (buf_recv);
  coils_hi:=  coils_from_buff_high(buf_recv);

  lbcoils.Caption:='   hi='+Inttohex(coils_hi) +'   lo='+Inttohex(coils);

  displayCoils(@getTagControl_diag, coils, clred);
  displayCoils(@getTagControl,coils, rgb(255,190,190) );
  displayCoils_high(@getTagControl,       coils_hi, rgb(255,190,190) );
  displayCoils_high(@getTagControl_diag,       coils_hi, rgb(255,190,190) );

end;





function PlaySoundLnx (fileName: String): Boolean;
begin
 {$IFDEF UNIX}
   fpsystem( 'aplay test.wav');
 {$ENDIF}
end;


procedure TForm1.btSoundClick(Sender: TObject);
var dir,s:string;
begin
  dir := Extractfilepath( Application.exename);
  s:=    'aplay '+dir+'alarm.wav';
  {$IFDEF UNIX}
  Fpsystem(s);
  {$ENDIF}

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  {$IFDEF UNIX}
  Fpsystem('sudo ifconfig eno1  10.0.6.35 netmask 255.255.0.0');
  {$ENDIF}
end;

procedure TForm1.Button7Click(Sender: TObject);
var i:Integer;
begin

  for i:=0 to tsdiag.ControlCount-1 do
    begin
      m2.Lines.Add(tsdiag.Controls[i].Name);
    end;

end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  fmChart.Show;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  shape23.Brush.Color:=clFuchsia;
end;




procedure TForm1.Button1Click(Sender: TObject);
const buf:array [0..11] of byte=(00 ,$FFFFFFB0 ,$00 ,$00 ,$00 ,$06 ,$01 ,$05 ,$00 ,$00 ,$FF ,$00);
begin

  btRequestClick(nil);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Buffer: array [0..255] of char;
begin
  Buffer := 'This is a textstring sent by the client';
  m.Lines.Add(inttostr(strlen(buffer)));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  btRequestClick( tobject(pointer(1)) );
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  btRequestClick( tobject(pointer(2)) );
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  btRequestClick( tobject(pointer(3)) );
end;



procedure TForm1.chContinuousChange(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
var i:integer; c:tcontrol;
begin

  dtProgStart:=now;

  blink_shapes:=TList.Create;


  for i:=0 to form1.ControlCount-1 do
     begin
      c:=form1.Controls[i] ;
      if c is tlabel then
       begin
         tlabel(c).Font.Color:= rgb(0,111,255);
         if   tlabel(c).Tag in [101..121] then tlabel(c).Caption:='0.0';
       end;

     end;
   pbr.Color:=clblue;


   hydr_utils.scan_frm:=tsInputs;

   thr:=TMyThread.Create(true);

   thr.out_dir:= Extractfilepath( Application.exename) ;
   thr.Resume;



end;

procedure TForm1.FormShow(Sender: TObject);
begin
  lbUser.Caption:=  ini.ReadString(inttostr(1),'name','');

end;

procedure TForm1.Image3Click(Sender: TObject);
begin

end;

procedure TForm1.Label111Click(Sender: TObject);
begin

end;

procedure TForm1.Label41Click(Sender: TObject);
begin

end;

procedure TForm1.Label81Click(Sender: TObject);
begin

end;



procedure TForm1.panChartClick(Sender: TObject);
begin

end;

procedure TForm1.Panel3Click(Sender: TObject);
begin

end;



procedure TForm1.sbSaveLogClick(Sender: TObject);
begin
  sd.FileName:='alert_log_'+datetostr(now);
  if sd.Execute then
    begin
     lbx_alerts.Items.SaveToFile(sd.FileName);
    end;
end;

procedure TForm1.Shape56ChangeBounds(Sender: TObject);
begin

end;

procedure TForm1.Shape62ChangeBounds(Sender: TObject);
begin

end;



procedure TForm1.SpeedButton1Click(Sender: TObject);
var i:integer;
begin
  fmGraph.Show;
  chart_parent:=  fmGraph.panCharts;
  for i:=0 to AIN_COUNT-1 do
   begin

    arr_im[i].Parent:=chart_parent;
   end;

  fmChart.btStep1Click(nil);

end;


var timer_n:byte=0;

procedure TForm1.Timer1Timer(Sender: TObject);

begin
  try
  if secondsbetween(dtProgStart,now)< 5 then
   begin

    if fmCommun<>nil then
     begin
      fmCommun.rgInterface.ItemIndex:= ini.readInteger('program','communication_interface',fmCommun.rgInterface.ItemIndex);
     end;
    if fmRS485<>nil then
    fmRS485.OnDataReceived:=@RS485ReceivedData;
    exit;
   end;

  timer_n:=timer_n+1;

  application.ProcessMessages;
  lbNow.Caption:=DateTimetostr(now);
  if chContinuous.Checked then
  begin
  if odd(timer_n) then
   begin


    if CommInterface=0 then
     begin
      RS485TurnOff;
      btRequestClick(btRequest);
     end
    else  if CommInterface=1 then
     begin
      RS485TurnOn;
     end
    else
     begin
      RS485TurnOff;
     end;


   end
  else
   begin



    if CommInterface=0 then
     begin
      RS485TurnOff;
      btRequestCoilsClick(nil);

     end
    else   if CommInterface=1 then
     begin
      RS485TurnOn;
     end
    else
     begin
      RS485TurnOff;
     end;

   end;
    btArchClick(nil);
    btScanSoundChange(nil);
  end;

  ctr_alerts_read:=ctr_alerts_read+1;
  if ctr_alerts_read>=5 then
   begin
    ctr_alerts_read:=0;
    btReadAlertsClick(nil);
    label80.Top:=form1.Height-lbx_alerts.Height-25;
    label80.Font.color:=clBlack;
    label79.Font.color:=clBlack;
    label77.Font.color:=clBlack;
    lbUpdateTime      .Font.color:=clBlack;
    lbNow     .Font.color:=clBlack;
    sbSaveLog.Top:=label80.Top-3;



   end;


  ////////////
  Label104.Visible:=shape59.Brush.style<>bsclear;
    if shape59.Brush.style=bsclear then
     begin

      shape60.Brush.Color:=clLime;

     end else
     begin
      shape60.Brush.Color:=clwhite;

     end;

    Label105.Visible:=shape57.Brush.style<>bsclear;
    if shape57.Brush.style=bsClear then
     begin

      shape61.Brush.Color:=clLime;

     end else shape61.Brush.Color:=clWhite;

   Label106.Visible:= shape56.Brush.style <> bsclear;
   Label107.Visible:= shape58.Brush.style <> bsclear;



   perform_blink;


   if fmChart<>nil then
    begin
     if fmChart.done then
      begin

       fmChart.done:=false;
      end;

    end;
   lbChartTime.Caption:=FormatDateTime('hh:nn:ss',now)   ;  ;

   lbChartTime.Left:=Width - lbChartTime.Width -40;

   if secondsBetween(fmChart.dt_update_charts, now)>10 then
    begin
     fmchart.CursorMove2(nil,[],0,0,0,0) ;
    end;



   panbuttons0.Visible:=fmCommun.rgInterface.ItemIndex=0;
   panbuttons1.Visible:=fmCommun.rgInterface.ItemIndex=0;
   panbuttons2.Visible:=fmCommun.rgInterface.ItemIndex=0;

  except
  end;
end;








procedure TForm1.ToggleBox1Change(Sender: TObject);


  procedure PError(const S: string);
  var
    ErrorMsg: string;
  begin
    case socketerror of
      EsockADDRINUSE: ErrorMsg := 'Error number when socket address is already in use';
      EsockEACCESS: ErrorMsg := 'Access forbidden error';
      EsockEBADF: ErrorMsg := 'Alias: bad file descriptor';
      EsockEFAULT: ErrorMsg := 'Alias: an error occurred';
      EsockEINTR: ErrorMsg := 'Alias : operation interrupted';
      EsockEINVAL: ErrorMsg := 'Alias: Invalid value specified';
      EsockEMFILE: ErrorMsg := 'Error code ?';
      EsockEMSGSIZE: ErrorMsg := 'Wrong message size error';
      EsockENOBUFS: ErrorMsg := 'No buffer space available error';
      EsockENOTCONN: ErrorMsg := 'Not connected error';
      EsockENOTSOCK: ErrorMsg := 'File descriptor is not a socket error';
      EsockEPROTONOSUPPORT: ErrorMsg := 'Protocol not supported error';
      EsockEWOULDBLOCK: ErrorMsg := 'Operation would block error';
      else
        ErrorMsg := 'Undescribed error : ' + IntToStr(socketerror);
    end;
    writeln(S, ErrorMsg);
  end;

var

  SockDesc: longint;

  SockAddr: TInetSockAddr;

  i: longint;
  Result, RecvSize: longint;
   s:string;
   bhi,blo:byte;
   val:integer;
   fval:Double;
   lb:TLabel;

   s10:string;


begin

  RecvSize:=0;
  m.Lines.Clear;
  try
  ctr:=ctr+1;
  Buffer_upr[1]:=ctr;
  buf_upr[1]:=ctr;

  SockDesc := fpSocket(AF_INET, SOCK_STREAM, 0);
  if SockDesc = -1 then
    Perror('[Client] Socket : ');
  SockAddr.sin_family := AF_INET;

  SockAddr.sin_port := htons(502);

  SockAddr.sin_addr := StrToNetAddr('10.0.6.10');

  if fpconnect(SockDesc, @SockAddr, SizeOf(SockAddr)) = -1 then
     PError('[Client] Connect : ');

  begin

    if sender=btRequest then
     begin
        Move(buf_req,Buffer_upr,sizeof(Buffer_upr));
     Result := fpsend(SockDesc, @Buffer_upr, 12,0);


     end
    else
     begin
       if sender=nil then
        begin
          buf_upr[9]:=0;
     Result := fpsend(SockDesc, @buf_upr, 13 ,1)
        end
       else if sender = tobject(1) then
        begin
          buf_upr[9]:=1;
          Result := fpsend(SockDesc, @buf_upr, 13 ,1);
        end
       else if sender = tobject(2) then
        begin
          buf_upr[9]:=2;
          Result := fpsend(SockDesc, @buf_upr, 13 ,1);
        end
       else if sender = tobject(3) then
        begin
          buf_upr[9]:=3;
          Result := fpsend(SockDesc, @buf_upr, 13 ,1);
        end
       else if sender = tobject(30) then
        begin
            Move(buf_read_coils ,Buffer_upr,sizeof(Buffer_upr));
            Result := fpsend(SockDesc, @Buffer_upr, 12,0);

        end;



     end;

    if Result <> SizeOf(Buffer_upr) then
      PError('[Client] Send : ');
    sleep(5);

    RecvSize := fprecv(SockDesc, @Buffer_upr, 255, 0);
    recv_size:=recvSize ;
    Move(Buffer_upr,buf_recv, recv_size);
  end;

  m.Lines.Add(inttostr(recvSize));
  s:='';
  for i:=0 to recvSize-1 do
   begin
    s:=s+IntToHex(integer(Buffer_upr[i]),2)+' ';


   end;
  m.Lines.Add('received: ');
  m.Lines.Add(s);




  if pbr.Position=pbr.Max then pbr.Position:=0 else  pbr.Position:=pbr.Position+1;
  if shp.Width>=150 then shp.Width:=0 else shp.Width:=shp.Width+10;

  if sender=btRequest then
   begin
     label78.Caption:=buf_to_archstr(Buffer_upr,RecvSize);
  s_ains:=    buf_to_archstr(Buffer_upr,RecvSize);
  s10:=s_ains;
  m.Lines.Add('arc '+ s10);
   for i:=0 to 20 do
    begin
    bhi:=byte(Buffer_upr[9+i*2]);
    blo:=byte(Buffer_upr[10+i*2]);

    if (bhi and $80)=0 then
     begin
     val:= ((bhi shl 8) and $ff00) or blo;

     end
    else
     begin
     val:= (((bhi and $7F) shl 8) and $ff00) or blo  ;
     val:= val -  32768;
     end;


    fval:=val *factors[i+1]  /10.0;
    m.Lines.Add(inttostr(i+1)+' : '+inttostr(val));

    lb:=tlabel(gettagcontrol(TLabel, 100+i+1));
    lb.Caption:=  formatfloat(formats[i+1] ,fval);

    end;

   end;

  if fpshutdown(SockDesc, 2) = -1 then
    PError('[Client] Shutdown : ');

  if CloseSocket(SockDesc) = -1 then
    PError('[Client] Close : ');


  except
  end;

  if recvSize>0 then
    begin
    lbUpdateTime.Caption:= DateTimeToStr(now);

    end;


end;

procedure TForm1.tsInputsContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;










procedure TForm1.miLoginClick(Sender: TObject);
var pswcor:string;  n:integer;
begin
  fmLogin.Edit1.Text:='';
  if fmLogin.ShowModal=mrok then
   begin

   if fmlogin.cbName.ItemIndex=-1 then
    begin
      MessageDlg('Необходимо выбрать пользователя',mtinformation,[mbok],0);

    end;

    n:=integer( pointer( fmlogin.cbName.Items.Objects[fmlogin.cbName.ItemIndex] ));
    pswcor:=trim(ini.ReadString(inttostr(n),'spin',''));
    if pswcor=trim(fmLogin.Edit1.Text) then
     begin
      // correct password
      dtProgStart:=now;
      PageControl1.Visible:=true;
      Timer1.Enabled:=True;

      lbUser.Caption:=fmlogin.cbName.Items[fmlogin.cbName.ItemIndex] ;
      if ini.ReadInteger(inttostr(n),'type',2)=1 then
       miSettings.Enabled:=true
      else
       miSettings.Enabled:=false;
     end
    else
     begin
      MessageDlg('Неправильный пароль',mtinformation,[mbok],0);
      miLoginClick(Sender);
     end;



   end;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  //
  if fmChangePassw.ShowModal=mrok then
   begin

   end;
end;

procedure TForm1.miLogoutClick(Sender: TObject);
begin
  //
  Timer1.Enabled:=False;


  PageControl1.Visible:=False;



  lbUser.Caption:='';

  miLoginClick(sender);

end;


procedure TForm1.miRS485Click(Sender: TObject);
begin
  //
  fmRS485.Show;
end;

procedure TForm1.miSettingsClick(Sender: TObject);
begin
  fmSettings.show;
  fmSettings.btReadClick(nil);
end;

procedure TForm1.miSettingsGeneralClick(Sender: TObject);
begin
  //
  fmCommun.ShowModal;
end;

procedure TForm1.miWriteChartClick(Sender: TObject);
begin
 miWriteChart.Checked:=not miWriteChart.Checked;
end;




procedure TForm1.miPropertiesClick(Sender: TObject);
var ii:TImageInfo3;    im:TImage;
begin
  //
  im:= TImage(popm.PopupComponent);

  ii:= arr_ii [  im.Tag ];
  fmChartProp.Caption:=ii.OVnames[0];
  fmChartProp.ii:=ii;

  fmChartProp.Show;


end;



procedure TForm1.popmPopup(Sender: TObject);
var ii:TImageInfo3;    im:TImage;  i:Integer;   mi:TMenuItem;
begin
  //
  im:= TImage(popm.PopupComponent);

  ii:= arr_ii [  im.Tag ];

  miSelectChart.Clear;
  miSelectChart.Tag:=int64( @ (ii ) );



  mi:=TMenuItem.Create(self);
  mi.Caption:=  ii.OVnames[0];

  mi.Tag:=0;
  mi.OnClick:=@(fmChart.SelectCurveItemClick);
  mi.GroupIndex:=1;
  if ii.SelectedCurve_in_self = 0 then mi.Checked:=true;
  miSelectChart.Add(mi);

  for i:=0 to length(ii.extras)-1 do
   begin

   mi:=TMenuItem.Create(self);
   mi.Caption:=  ii.OVnames[I+1];

   mi.Tag:=i+1 ;
   mi.OnClick:=@(fmChart.SelectCurveItemClick);
   mi.GroupIndex:=1;

   if ii.SelectedCurve_in_self = i+1 then mi.Checked:=true;

   miSelectChart.Add(mi);

   end;

end;


initialization
 ini:=TInifile.create('hydr.ini');
 ini.WriteDateTime('program','run',now);
 ini_chart :=TInifile.Create('charts.ini');
end.

