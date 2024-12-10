program hydr_prod;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, unit1, frm_tab, hydr_files, hydr_utils, Unit2,
  frm_inputs, frm_chart, imginf, ain_def, frm_login, frm_settings,
  tag_control_utils, frm_graph, frm_rs485, frm_sett_commun, frm_chart_prop,
  ctrl_organs, frm_change_passw;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TfmInputs, fmInputs);
  Application.CreateForm(TfmChart, fmChart);
  Application.CreateForm(TfmLogin, fmLogin);
  Application.CreateForm(TfmSettings, fmSettings);
  Application.CreateForm(TfmGraph, fmGraph);
  Application.CreateForm(TfmRS485, fmRS485);
  Application.CreateForm(TfmCommun, fmCommun);
  Application.CreateForm(TfmChartProp, fmChartProp);
  Application.CreateForm(TfmChangePassw, fmChangePassw);
  Application.Run;
end.

