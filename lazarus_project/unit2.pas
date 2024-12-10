unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Sockets,  LCLIntf, ComCtrls, dateUtils,
    {$IFDEF UNIX}
      unix,
    {$ENDIF}

    filectrl, hydr_utils, cthreads,
    hydr_files ;

type
  TMyThread = class (TThread)
    pr:TThreadMethod;

    ss_files:TstringList;
    ss_inputs:TstringList;
    ss_alerts:TStringList;

    out_dir:String;

    procedure Execute; override;
    procedure do_job; register;
    procedure do_job_nosync; register;
  end;

implementation
uses frm_chart;

procedure     TMyThread    . do_job_nosync;

begin

  if fmChart<>nil then
   begin
   if fmChart.done then exit;
   fmChart.btStep1_5click(nil);

   end;
end;

procedure     TMyThread    . do_job;
var  s1,s2:String;   ss1,ss2:TStringlist;  parc1,parc2:PArchRec;
begin


  read_arch_files(ss_files);

  s1:=''; s2:='';
  if ss_files.Count>0 then
   begin
   s1:=  ss_files[ ss_files.Count-1 ] ;
   parc1:=   PArchRec (  ss_files.Objects[ ss_files.Count-1 ] );
   end;
  if ss_files.Count>1 then
   begin
   s2:=  ss_files[ ss_files.Count-2 ] ;
   parc2:=   PArchRec (  ss_files.Objects[ ss_files.Count-2 ] );
   end;

  ss_inputs.Clear;;

  if s2>'' then
   begin
    add_file_lines_to_ss(parc2^.dir+parc2^.fname, ss_inputs );

   end;
  if s1>'' then
   begin
    add_file_lines_to_ss(parc1^.dir+parc1^.fname, ss_inputs );
   end;

  scan_alerts( ss_inputs, ss_alerts);

  ss_alerts.SaveToFile( out_dir+'alerts.txt' );


end;


procedure     TMyThread    . Execute;
begin

  ss_files:=TstringList.Create;
  ss_inputs:=     TstringList.Create;
  ss_alerts   :=     TstringList.Create;
  pr:= TThreadMethod( @do_job);
  while not terminated do
   begin
     do_job_nosync;
     synchronize(pr);

   end;
end;

end.

