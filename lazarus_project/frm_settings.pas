unit frm_settings;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids, Buttons, extra_defs , tag_control_utils;

type

  { TfmSettings }

  TfmSettings = class(TForm)
    Button2: TButton;
    btRead: TButton;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit2: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit3: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit4: TEdit;
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
    Edit43: TEdit;
    Edit44: TEdit;
    Edit45: TEdit;
    Edit46: TEdit;
    Edit47: TEdit;
    Edit48: TEdit;
    Edit49: TEdit;
    Edit5: TEdit;
    Edit50: TEdit;
    Edit51: TEdit;
    Edit52: TEdit;
    Edit53: TEdit;
    Edit54: TEdit;
    Edit55: TEdit;
    Edit56: TEdit;
    Edit57: TEdit;
    Edit58: TEdit;
    Edit59: TEdit;
    Edit6: TEdit;
    Edit60: TEdit;
    Edit61: TEdit;
    Edit62: TEdit;
    Edit63: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
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
    Label8: TLabel;
    Label9: TLabel;
    m: TMemo;
    btWrite: TSpeedButton;
    procedure btWriteClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btReadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  fmSettings: TfmSettings;

implementation

uses Unit1, hydr_files, hydr_utils;

{$R *.lfm}



procedure TfmSettings.FormCreate(Sender: TObject);
var i:Integer;  ed:TEdit;  lb:TLabel;
begin

  for i:=1 to 21 do
   begin
    ed:= tedit( getTagControlOf(tedit, 3000+i, self));
    lb:= tlabel( getTagControlOf(tlabel, 100+i, self));
    if ed<>nil then
     begin
       ed.Text:=inttostr(i);
     end;
    if lb<>nil then lb.Caption:='';
   end;

end;

procedure TfmSettings.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TfmSettings.btWriteClick(Sender: TObject);
var ed:TEdit;  f:Double;  iAIN,ireg,val:Integer;
begin
  m.Lines.Clear;
  if not (  ActiveControl is tedit ) then exit;
  ed:= TEdit( ActiveControl );
  m.Lines.Add(ed.Text);
  f:= strtofloat(ed.Text);
  iAIN:= ed.Tag mod 1000 -1;
  m.Lines.Add(inttostr(iain));
  ireg :=trunc((ed.tag div 1000)*100) + 100 + iain;
  val:= trunc(  f * 10 / factors[iain+1]  );
  m.Lines.Add( 'reg '+inttostr(ireg)   );
  m.Lines.Add( 'val '+inttostr(val)   );

  buf_write_reg_w := buf_write_reg;
  buf_write_reg_w[8] := (ireg shr 8) and $ff;
  buf_write_reg_w[9] := (ireg shr 0) and $ff;

  buf_write_reg_w[13] := (val shr 8) and $ff;
  buf_write_reg_w[14] := (val shr 0) and $ff;

  Form1.btRequestClick( TObject($60));
end;

procedure TfmSettings.btReadClick(Sender: TObject);
begin
  form1. btRequestLimits2.Click;
  form1. btRequestLimi3Click(nil);
  form1.btRequestLim4Click(nil);
end;

end.

