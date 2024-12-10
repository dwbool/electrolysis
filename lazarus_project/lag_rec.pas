unit lag_rec;

interface

uses 
   Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  {SHDocVw,} StdCtrls, {MSHTML, IdBaseComponent, IdComponent}
 dateUtils;

//
type

PCandleInfo=^TCandleInfo;
TCandleInfo= packed record
StartMarker:String[2];
//
st:string[25];
so,sh,sl,sc,sv:string[11];
updown:char;
//
t:TDateTime;
o,h,l,c,v:Double;
sname1,speriod1,sindicator1,sname2,speriod2,sindicator2:string[11];
indicator1,indicator2:Double;
period1,period2:Integer;
point:Double;

//
delim:String[2];
end;


{$define TCandleInfoShell} // TPurokShell - pangkat selection in table
PUNTERO=TCandleInfo; // <array element>
PPUNTERO=PCandleInfo; // <array element ptr>
PCandleInfoShell=^{$i arshname.inc};  { ptr to ARRAY declaration }
{$define NO_DEFINITION_END} // if wanna add extra fields
{$i arshdef.inc}   // class definition
// extra fields
//point:Double;
secw:Double;
procedure ToStrings(ss:TStrings);
function GetMinValInd:Integer;
function GetMaxValInd:Integer;

function GetMinValIndFromTo(ifrom,ito:Integer):Integer;
function GetMaxValIndFromTo(ifrom,ito:Integer):Integer;

function GetMinValIndTo(ito:Integer):Integer;
function GetMaxValIndTo(ito:Integer):Integer;

function GetMinMaxFromTo(ifrom,ito:Integer; var imin,imax:Integer):Double;

function GetO(i:Integer):Double;
function GetH(i:Integer):Double;
function GetL(i:Integer):Double;
function GetC(i:Integer):Double;



property O[i:Integer]:Double read GetO ;
property H[i:Integer]:Double read GetH ;
property L[i:Integer]:Double read GetL ;
property C[i:Integer]:Double read GetC ;
property MinValInd:Integer read GetMinValInd;
property MaxValInd:Integer read GetMaxValInd;
property MinValIndTo[ito:Integer]:Integer read GetMinValIndTo;
property MaxValIndTo[ito:Integer]:Integer read GetMaxValIndTo;
//procedure xCopyMemory(Destination: Pointer; Source: Pointer; Length: DWORD);

function FindNearestCandle(dt:TDateTime; var found:Boolean):Integer;
//
function AttachPast(p:{$i arshname.inc}):Boolean;
end;   // if wanna add extra fields

procedure WriteStr( ci:PCandleInfo);
function GetCandleStr(c:PCandleInfo):String;

implementation

//uses windows;

function TCandleInfoShell.AttachPast(p:{$i arshname.inc}):Boolean;
var i,i0,iAt:Integer;
begin
Result:=false;
if count=0 then
 begin
 Addlist(p);
 exit;
 end;

i0:=-1;
for i :=0  to iLast do
 begin
 if p.z[0]^.t=self.z[i]^.t then
  begin

  i0:=i;
  break;
  end;
 end;

iAt:=-1;
if i0>-1 then
for i:=i0 to iLast do
 begin
 iAt:=i-i0;
 if (iAt<p.Count)and(iAt>0) then
  begin
  self.z[i]:=p.z[iAt];
  Result:=true;
  end;
 end;

if iAt>-1 then
 begin
 for  i:=iAt+1  to p.iLast do
  begin
  self.Add(p.z[i]^);
  end;
 end;

end;

function TCandleInfoShell.FindNearestCandle(dt:TDateTime; var found:Boolean):Integer;
var i,imin:Integer; msmin,ms1cnd:Integer;
begin
msmin:=High(Integer);
imin:=-1;
found:=false;
Result:=-1;
if count>1 then
 ms1cnd:=MilliSecondsBetween(z[1]^.t, z[0]^.t) else ms1cnd:=High(Integer);
for i:=0 to ilast do
 begin
 if MilliSecondsBetween(dt,z[i]^.t)<msmin then
  begin
  msmin:=MilliSecondsBetween(dt,z[i]^.t);
  imin:=i;
  if msmin<ms1cnd then found:=true;
  end;
 end;
Result:=imin;
end;

{procedure TCandleInfoShell.xCopyMemory(Destination: Pointer; Source: Pointer; Length: DWORD);
begin
CopyMemory(Destination, Source, Length);
end;}

{$i arshimp.inc}

procedure WriteStr(ci:PCandleInfo);
begin
{
x.so:=FloatToStr(x.o);
x.sh:=FloatToStr(x.h);
x.sl:=FloatToStr(x.l);
x.sc:=FloatToStr(x.c);
x.st:=DateTimeToStr(t);
 }
with ci^ do
 begin
 ci^.so:=FormatFloat('o=0.00000',o);
 ci^.sh:=FormatFloat('h=0.00000',h);
 ci^.sl:=FormatFloat('l=0.00000',l);
 ci^.sc:=FormatFloat('c=0.00000',c);
 ci^.st:=Datetimetostr(t);
 end;
end;

function TCandleInfoShell.GetO(i:Integer):Double;
begin
Result:=Items[i]^.o;
end;

function TCandleInfoShell.GetH(i:Integer):Double;
begin
Result:=Items[i]^.h;
end;
//
function TCandleInfoShell.GetL(i:Integer):Double;
begin
Result:=Items[i]^.l;
end;
//
function TCandleInfoShell.GetC(i:Integer):Double;
begin
Result:=Items[i]^.c;
end;
//

function TCandleInfoShell.GetMinMaxFromTo(ifrom,ito:Integer; var imin,imax:Integer):Double;
begin
imin:=GetMinValIndFromTo(ifrom,ito);
imax:=GetMaxValIndFromTo(ifrom,ito);
Result:=items[imax]^.h-items[imin]^.l;
end;


function TCandleInfoShell.GetMinValIndTo(ito:Integer):Integer;
begin
Result:=GetMinValIndFromTo(0,ito);
end;

function TCandleInfoShell.GetMaxValIndTo(ito:Integer):Integer;
begin
Result:=GetMaxValIndFromTo(0,ito);
end;


function TCandleInfoShell.GetMinValIndFromTo(ifrom,ito:Integer):Integer;
var i:Integer; e:Double;
begin

if Count=0 then exit;
e:=items[ifrom]^.l;
if ifrom<0 then ifrom:=0;
if ito>(count-1) then ito:=count-1;
Result:=ifrom;
for  i:=ifrom  to ito do
 begin
 if items[i]^.l<e then
  begin
  Result:=i;
  e:=items[i]^.l;
  end;
 end; 
end;

function TCandleInfoShell.GetMaxValIndFromTo(ifrom,ito:Integer):Integer;
var i:Integer; e:Double;
begin

if Count=0 then exit;
e:=items[ifrom]^.h;
if ifrom<0 then ifrom:=0;
if ito>(count-1) then ito:=count-1;
Result:=ifrom;
for  i:=ifrom  to ito do
 begin
 if items[i]^.h>e then
  begin
  Result:=i;
  e:=items[i]^.h;
  end;
 end; 
end;

function TCandleInfoShell.GetMinValInd:Integer;
var i:Integer; e:Double;
begin
Result:=0;
if Count=0 then exit;
e:=items[0]^.l;
for  i:=0  to count-1 do
 begin
 if items[i]^.l<e then
  begin
  Result:=i;
  e:=items[i]^.l;
  end;
 end; 
end;

function TCandleInfoShell.  GetMaxValInd:Integer;
var i:Integer; e:Double;
begin
Result:=0;
if Count=0 then exit;
e:=items[0]^.h;
for  i:=0  to count-1 do
 begin
 if items[i]^.h>e then
  begin
  Result:=i;
  e:=items[i]^.h;
  end;
 end; 
end;


function   GetCandleStr(c:PCandleInfo):String;  //(c:PCandleInfo);
begin
Result:=Format('$$$  %s:  %.5f  %.5f  %.5f  %.5f',[Datetimetostr(c^.t),c^.o,c^.h,c^.l,c^.c]);
end;

procedure TCandleInfoShell.ToStrings(ss:TStrings);
var i:Integer; s:String; c2:pCandleInfo;
begin
//self.xCopyMemory(@self,@self,2);

for i:=0 to ilast do
 begin

 c2:=z[i];
 s:=Format('%d >>  %s:  %.5f  %.5f  %.5f  %.5f',[i,Datetimetostr(c2^.t),c2^.o,c2^.h,c2^.l,c2^.c]);
 ss.Add(s);
 end;

end;

{}

end.










