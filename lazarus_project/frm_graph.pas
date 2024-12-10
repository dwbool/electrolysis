unit frm_graph;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons;

type

  { TfmGraph }

  TfmGraph = class(TForm)
    Panel1: TPanel;
    panCharts: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Timer1: TTimer;

    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    dtResize:TDatetime   ;
    resized:Boolean;
    onresizeended:TNotifyEvent;
  end;

var
  fmGraph: TfmGraph;

implementation  uses dateutils, frm_chart, Unit1;

{$R *.lfm}

{ TfmGraph }

procedure TfmGraph.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 caption:= DateTimeToStr(now);
end;

procedure TfmGraph.FormCreate(Sender: TObject);
begin
    fmGraph.onresizeended:= @(fmChart.btStep1Click);
end;

procedure TfmGraph.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  chart_parent:=form1.panChart;
  onresizeended(self);
end;

procedure TfmGraph.FormResize(Sender: TObject);
begin
  dtResize:=now;
  resized:=true;
end;

procedure TfmGraph.SpeedButton1Click(Sender: TObject);
begin
  fmChart.Show;
end;

procedure TfmGraph.SpeedButton2Click(Sender: TObject);
begin
  close
end;

procedure TfmGraph.Timer1Timer(Sender: TObject);
begin
  if (secondsBetween(dtResize,now)>1)and resized then
   begin
     resized:=false;
     if Assigned(onresizeended) then onresizeended(self);
   end;
end;

end.

