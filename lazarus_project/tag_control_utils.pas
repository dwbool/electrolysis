unit tag_control_utils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Sockets, LCLIntf, ComCtrls, Buttons,
   dateUtils,

  {$IFDEF UNIX}
  unix,
  {$ENDIF}
  inifiles, Types;

type
tSomeclass =       class of TObject;

  function  getTagControlOf(tp: tSomeclass  ; tag2:Integer; parent:TWinControl ):TControl;
  procedure writeln(S:string; ErrorMsg:string);

implementation



function  getTagControlOf(tp: tSomeclass  ; tag2:Integer; parent:TWinControl ):TControl;
var i:Integer;
begin
  result:=  nil;
  for i:=0 to parent.ControlCount-1 do
    begin
     if parent.Controls[i] is tp then
       begin
         if  parent.Controls[i].Tag=tag2 then
           begin
             result:=   parent.Controls[i];
             exit;
           end;
       end;

    end;

end;


procedure writeln(S:string; ErrorMsg:string);
begin

end;


end.

