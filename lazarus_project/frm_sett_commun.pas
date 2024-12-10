unit frm_sett_commun;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfmCommun }

  TfmCommun = class(TForm)
    Button2: TButton;
    rgInterface: TRadioGroup;
    procedure Button2Click(Sender: TObject);
    procedure rgInterfaceClick(Sender: TObject);
  private

  public

  end;

var
  fmCommun: TfmCommun;

implementation  uses unit1;

{$R *.lfm}

{ TfmCommun }

procedure TfmCommun.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TfmCommun.rgInterfaceClick(Sender: TObject);
begin
  ini.WriteInteger('program','communication_interface',rgInterface.ItemIndex);
end;

end.

