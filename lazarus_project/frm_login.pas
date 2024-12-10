unit frm_login;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfmLogin }

  TfmLogin = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cbName: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure cbNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  fmLogin: TfmLogin;

implementation

uses unit1;

{$R *.lfm}

{ TfmLogin }

procedure TfmLogin.FormCreate(Sender: TObject);
var i:integer;   s:String;
begin
  cbname.Clear;
  for i:=1 to 10 do
   begin
     s:=ini.ReadString(inttostr(i),'name','');
     if s>'' then cbName.AddItem(s, tobject( pointer(i))   );
   end;

end;

procedure TfmLogin.cbNameChange(Sender: TObject);
begin
  Edit1.Text:='';
end;





end.

