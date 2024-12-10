unit eval_dlp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfmEval = class(TForm)
    Button1: TButton;
    m: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEval: TfmEval;

implementation

{$R *.dfm}

uses corr;



procedure TfmEval.Button1Click(Sender: TObject);
var ss:TStringlist;     i:Integer;     d:Double;  fs:TFormatSettings;
 psmp:PSample;      drv:Double;      t0:Cardinal;
begin

 ss:=TStringlist.Create;
 ss.LoadFromFile('p_hypoth.d');
 //m.Lines.AddStrings(ss);
 fs.DecimalSeparator:='.';

 GetMem(psmp, sizeof(double)*ss.Count);

 for i := 0 to ss.Count-1 do
   begin

    d:=StrToFloatDef(ss[i],0,fs);
    psmp[i]:=d;
    m.Lines.Add(floattostr(psmp[i]));
   end;

 t0:=GetTickCount;
 drv:=ArrayDerivative_Sophisticated(psmp,0,ss.Count);
 t0:=          GetTickCount-t0;
 m.Lines.Add(floattostr(drv)+' >>> '+floattostr(t0)+' ms');
 freemem(psmp);
 ss.Free;
end;

end.
