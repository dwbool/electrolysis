unit bmparr;

interface
uses
   Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TColorArray=array [0..High(Word)] of TColor;
  PColorArray=^TColorArray;

///////////////

function XYtoIndex(w,h,x,y:Integer):Integer;
function BmpArrayByteSize(w,h:Integer):Integer;
function ArrayColor(c1:TColor):TColor;
function MixColor(c1,c2:TColor; c1share:Double):TColor;
procedure ArrayToBitmap(a:PColorArray; b:TBitmap);
procedure BitmapToArray(a:PColorArray; b:TBitmap);
function AllocArrayForBmp(b:TBitmap):PColorArray;
function BmpArrayLength(b:TBitmap):Integer;
procedure ArrayToArray(s,d:PColorArray; b:TBitmap);
procedure BmpArrayFill(a:PColorArray; b:TBitmap; c:TColor);
procedure BmpResize(b:TBitmap; w,h:Integer);

//////////////


implementation


function XYtoIndex(w,h,x,y:Integer):Integer;
begin
Result:=y*w+x;
end;

type
TByteArray=array[0..High(Word)] of Byte;
PByteArray=^TByteArray;

function ArrayColor(c1:TColor):TColor;
var r,g,b:Byte;  c2:Integer;
begin
r:= PByteArray(@c1)^[0];
g:= PByteArray(@c1)^[1];
b:= PByteArray(@c1)^[2];
 PByteArray(@c2)^[0]:=b;
 PByteArray(@c2)^[1]:=g;
 PByteArray(@c2)^[2]:=r;
Result:=c2;
end;

function MixColor(c1,c2:TColor; c1share:Double):TColor;
var b0,b1,b2:Byte; res:Integer; pres:PByteArray;
begin
if c1Share<0 then c1Share:=0;
if c1Share>1 then c1Share:=1;
b0:= trunc((PByteArray(@c1)^[0])*c1Share + (PByteArray(@c2)^[0])*(1-c1share));
b1:= trunc((PByteArray(@c1)^[1])*c1Share + (PByteArray(@c2)^[1])*(1-c1share));
b2:= trunc((PByteArray(@c1)^[2])*c1Share + (PByteArray(@c2)^[2])*(1-c1share));
pres:=@res;
pres^[0]:=b0;
pres^[1]:=b1;
pres^[2]:=b2;
Result:=res;
end;



procedure arrayToBitmap(a:PColorArray; b:TBitmap);
var i,j,len:Integer;p:PColorArray;
begin

p:=b.ScanLine[0];
len:=BmpArrayByteSize(b.Width,b.Height);
//CopyMemory(a,p,10000);
//windows.GetBitmapBits(b.Handle,{1600000}len,a);
//SetBitmapBits(b.Handle,len,a);

for i :=0  to b.Height-1 do
 begin
 p:=b.ScanLine[i];

 for j :=0  to b.Width-1 do
  begin
  p^[j]:=a^[trunc(i*b.width+j)];
  end;
 end;

end;

function BmpArrayByteSize(w,h:Integer):Integer;
var L:Integer;
begin
L:=XYtoIndex(w,h,w-1,h-1)+1;
Result:=L*Sizeof(TColor);
end;

procedure BitmapToArray(a:PColorArray; b:TBitmap);
var i,j,len:Integer;p:PColorArray;
begin

p:=b.ScanLine[0];
len:=BmpArrayByteSize(b.Width,b.Height);
//CopyMemory(a,p,10000);
//GetBitmapBits(b.Handle,{1600000}len,a);



for i :=0  to b.Height-1 do
 begin
 p:=b.ScanLine[i];

 for j :=0  to b.Width-1 do
  begin
  a^[trunc(i*b.width+j)]:=p^[j ];      //@@yayva
  end;
 end;

end;

function AllocArrayForBmp(b:TBitmap):PColorArray;
var p:Pointer;s:Integer;
begin
s:=b.Width*b.Height*sizeof(TColor);
GetMem(p,s);
Result:=p;

end;

function BmpArrayLength(b:TBitmap):Integer;
begin
Result:=b.Width*b.Height*Sizeof(TColor);


end;

procedure ArrayToArray(s,d:PColorArray; b:TBitmap);
begin
//CopyMemory(d,s,BmpArrayLength(b));
end;

procedure BmpArrayFill(a:PColorArray; b:TBitmap; c:TColor);
begin
//FillMemory(a,BmpArrayLength(b),ArrayColor(c));
end;

procedure BmpResize(b:TBitmap; w,h:Integer);
begin
b.Width:=w;
b.Height:=h;
b.PixelFormat:=pf32bit;
end;

end.
