unit grphk;

interface


uses
    Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, {pairsdf,} dateutils,   ComCtrls, Grids,//corr,
    math;



const Forecast2_REQUIRED_COUNT=10;

SCRUTABLE_MIN=0 ;
SCRUTABLE_MAX=10000;

type
TFragmentInfo=record
Direct,MainBowBuy:Boolean;
corDir,corRev,DirPart{*},RevPart:Double;
TestDir,TestRev:array [0..20] of Double;
TestBendDepth:Integer;
end;
  PSample=^TSample;
  TSample=array [0..High(word)] of Double;
  PTimes=^TTimes;
  TTimes=array [0..High(word)] of TDateTime;

  TBowInfo=record
  dx,dxx,past0:Double;
  end;


//@@2024    @YAYVA
  procedure DrawCandles_hyst(canvas:TCanvas; mWidth,mHeight,GraphicCount:Integer;    close:PSample;   Base,Count:Integer ; DrawCandles_min,  DrawCandles_max:Double ; barColor:TColor );
      ///////////


  procedure DrawCandles(canvas:TCanvas; mWidth,mHeight,GraphicCount:Integer; open,high,low,close:PSample; Times:PTimes; Base,Count:Integer; detectMinMax:Boolean);
  procedure DrawCandlesAsFuture(canvas:TCanvas; mWidth,mHeight,GraphicCount:Integer; open,high,low,close:PSample; Times:PTimes; Base,Count:Integer; min,max:Double);
  PROCEDURE DrawCandlesHighlight(canvas:TCanvas; mWidth,mHeight,GraphicCount:Integer; open,high,low,close:PSample; Times:PTimes; Base,Count:Integer; detectMinMax:Boolean; hl:array of Double);

  procedure DrawCandlesFuture( // for STRONG_LEVEL project
 canvas:TCanvas;
 mWidth,mHeight,
 GraphicCount:Integer; // to calculate X in pixels
 open,high,low,close:PSample;
 Times:PTimes;
 Base,Count:Integer; // to stride array
 DrawCandles_min,
 DrawCandles_max:Double
 );


procedure PaintArray(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; pen_width:Integer);
procedure PaintArray_hyst(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; pen_width:Integer);

procedure PaintArrayFuture(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
procedure PaintArrayStraight(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
procedure PaintArrayStraightPS(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer; PS:TPenStyle);
procedure PaintArrayFutureStraight(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
procedure PaintArrayPoints(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
procedure PaintArrayOnGraphicCandle(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer; CandleIndex:Integer);


procedure PaintArrayFutureBase(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; base,c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
procedure PaintArrayFutureBaseStraight(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; base,c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);


procedure PaintLine(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
function GetXFuture(i,c,mWidth:Integer):Integer;

function GetY(price:Double; mHeightFull:Integer; PriceMin,PriceMax:Double):Integer;
function GetPrice(Y:Double; mHeightFull:Integer; PriceMin,PriceMax:Double):Double;
function GetX(i,c,mWidth:Integer):Integer;

function InconspiciousColor(c:TColor):TColor;

////////
function GetCandleIndex(X,c,mWidth:Integer):Integer;
function GetCandleIndexMayMinus(X,c,mWidth:Integer):Integer; // oct 21 2011
/////^

var DrawCandles_minG,DrawCandles_maxG:Double;  //for Polygon form

const clGreen255:TColor=$00FF00; //in Meta trader
const clCandles:TColor=$00FF00;
clVerticalWall=clWhite;

implementation

//function GetX(i,c,mWidth:Integer):Integer;

//@new   reverse to GetX
function GetCandleIndex(X,c,mWidth:Integer):Integer;
var i:Double;
begin
Result:=0;
i:=0;
if c=0 then exit;
if (x<0) then exit;
mWidth:=mWidth-10;
//        to work better
//        v
if ((mWidth * c)<>0) then
i:=((-(X -3 )+ 2+mWidth) / (mWidth / c));
Result:=trunc(i);
end;
//^

function GetCandleIndexMayMinus(X,c,mWidth:Integer):Integer;   // 2011 oct 21
var i:Double;
begin
Result:=0;
i:=0;
if c=0 then exit;
//if (x<0) then exit;
mWidth:=mWidth-10;
//        to work better
//        v
if ((mWidth * c)<>0) then
i:=((-(X -3 )+ 2+mWidth) / (mWidth / c));
Result:=trunc(i);
end;

function InconspiciousColor(c:TColor):TColor;
var x,r,g,b,d1,d2:Integer;
begin
x:=ColorToRGB(c);
r:=x and $00FF;    //r is r
g:=(x shr 8) and $FF;    // g is g
b:=(x shr 16) and $FF;   //b is b

if (r>g)and(r>=b) then
 begin
 r:=trunc(r*1.0);   // 255,150,150
 d1:=r-g;
 d2:=r-b;
 g:=trunc(g+d1*150.0/255.0);
 b:=trunc(b+d2*150.0/255.0);
 end
else if (g>r)and(g>=b) then
 begin
 g:=trunc(g*(220.0/128.0));   // 192,220,192 - clMoneyGreen    0,128,0-clGreen
 d1:=g-r;
 d2:=g-b;
 //r:=trunc(r+d1*192.0/220.0);//1
 //b:=trunc(b+d2*192.0/220.0);
 r:=trunc(r+d1*140.0/220.0);//1
 b:=trunc(b+d2*140.0/220.0);
 end
else if (b>g)and(b>=r) then
 begin
 b:=trunc(b*1.0);   // 255,150,150
 d1:=b-g;
 d2:=b-r;
 g:=trunc(g+d1*150.0/255.0);
 r:=trunc(r+d2*150.0/255.0);
 end;
if r>255 then r:=255;
if g>255 then g:=255;
if b>255 then b:=255;
Result:=clred; //RGB(r,g,b);
end;



function GetX(i,c,mWidth:Integer):Integer;
begin
Result:=0;
if c=0 then exit;
mWidth:=mWidth-10;
result:= 2+trunc(mWidth-((mWidth / c) * i));
end;

function GetXFuture(i,c,mWidth:Integer):Integer;
begin
Result:=0;
if c=0 then exit;
mWidth:=mWidth-10;
result:= 2+trunc(mWidth+((mWidth / c) * i));
end;

function GetXFutureForCandles(i,c,mWidth,Base:Integer):Integer;
begin
Result:=0;
if c=0 then exit;
mWidth:=mWidth-10;
result:= 2+trunc(mWidth+((mWidth / c) * (Base-1-i+1) ));
end;


function GetY(price:Double; mHeightFull:Integer; PriceMin,PriceMax:Double):Integer;
var v,dp,dppart:double;    mHeight,HFullResidual:Integer;
begin
Result:=0;
if MHeightFull>10000 then exit;
if MHeightFull<0 then exit;
mHeight:=trunc(MHeightFull*0.8);
HFullResidual:= mHeightFull-mHeight;

v:=price-PriceMin;
dp:=PriceMax  -  PriceMin;
//if dp=0 then dp:=1;
if dp=0 then exit;
if dp<0.000001 then {dp:=1;}exit;
if v>1000000 then exit;
if dp>0 then
dppart:=v/dp else dppart:=0;

Result:=HFullResidual div 2 + trunc(mHeight   -  (mHeight) * dppart );

end;


function GetPrice(Y:Double; mHeightFull:Integer; PriceMin,PriceMax:Double):Double;
var v,dp,dppart:double;    mHeight,HFullResidual:Integer;
begin
Result:=0;
if MHeightFull>10000 then exit;
if MHeightFull<0 then exit;
mHeight:=trunc(MHeightFull*0.8);
HFullResidual:= mHeightFull-mHeight;

dp:=( Y-HFullResidual / 2 )/(mHeight);
Result:=(PriceMax-(PriceMax-PriceMin)*dp);

//Result:=HFullResidual div 2 + trunc(mHeight   -  (mHeight) * dppart );


end;


procedure DrawCandlesFuture(
 canvas:TCanvas;
 mWidth,mHeight,
 GraphicCount:Integer;
 open,high,low,close:PSample;
 Times:PTimes;
 Base,Count:Integer;
 DrawCandles_min,
 DrawCandles_max:Double
 );

var i:Integer;
 x:Integer;  yop,ycl, yhi, ylo, candleW:Integer;
begin
CandleW:=2;
canvas.Pen.Color:=clGray;
canvas.Pen.Width:=1;

for i :=0  to  Count-1  do
 begin

 x:=GetX(-i-1,GraphicCount,mWidth);

 yop:=GetY(Open^[base+i] ,mHeight, DrawCandles_min,DrawCandles_max);
 ycl:=GetY(Close^[base+i],mHeight, DrawCandles_min,DrawCandles_max);
 yhi:=GetY(High^[base+i] ,mHeight, DrawCandles_min,DrawCandles_max);
 ylo:=GetY(Low^[base+i]  ,mHeight, DrawCandles_min,DrawCandles_max);

 if yop=ycl then
  begin
  Canvas.MoveTo(x-candleW,yop);
  Canvas.lineTo(x+candleW,yop);
  end;
 Canvas.MoveTo(x,yhi);
 Canvas.lineTo(x,ylo);

 Canvas.Brush.Style:=bsSolid;
 
 if yop<ycl then Canvas.Brush.Color:=clGray else  Canvas.Brush.Color:=clBlack;
 Canvas.Rectangle(x-candleW,yop,x+candleW,ycl);
 end;

end;


//procedure DrawCandles(canvas:TCanvas; mWidth,mHeight,GraphicCount:Integer; open,high,low,close:PSample; Times:PTimes; Base,Count:Integer; detectMinMax:Boolean);


procedure DrawCandles(canvas:TCanvas; mWidth,mHeight,GraphicCount:Integer; open,high,low,close:PSample; Times:PTimes; Base,Count:Integer; detectMinMax:Boolean);
var aver_,aver:Double;i,ya,ya_,x,x_:Integer;  yop,ycl, yhi, ylo, candleW:Integer;
min,max:Double;
begin

canvas.Pen.Color:=clCandles;
canvas.Pen.Width:=1;

aver_:=-1;

if detectMinMax then
 begin
 //GetPriceMinMaxPtr(open,high,low,close, base,{count}GraphicCount ,min,max);

 DrawCandles_minG:=min;
 DrawCandles_maxG:=max;
 end
else
 begin
 min:=DrawCandles_minG;
 max:=DrawCandles_maxG;
 end; 

//candleW:=trunc(mWidth / count * 0.47);
//candleW:=trunc(mWidth / GraphicCount * 0.57);
candleW:=2;

for i:=0 to {count}GraphicCount-1 do
 begin
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 x:=GetX(i,GraphicCount,mWidth);

 yop:=GetY(Open^[base+i] ,mHeight, min,max);
 ycl:=GetY(Close^[base+i],mHeight, min,max);
 yhi:=GetY(High^[base+i] ,mHeight, min,max);
 ylo:=GetY(Low^[base+i]  ,mHeight, min,max);

 if yop=ycl then
  begin
  Canvas.MoveTo(x-candleW,yop);
  Canvas.lineTo(x+candleW,yop);
  end;
 Canvas.MoveTo(x,yhi);
 Canvas.lineTo(x,ylo);

 Canvas.Brush.Style:=bsSolid;
 
 if yop<ycl then Canvas.Brush.Color:=clWhite else  Canvas.Brush.Color:=clGreen;
 Canvas.Rectangle(x-candleW,yop,x+candleW,ycl);

 end;

end;





procedure DrawCandles_hyst(canvas:TCanvas; mWidth,mHeight,GraphicCount:Integer;    close:PSample;   Base,Count:Integer ; DrawCandles_min,  DrawCandles_max:Double ; barColor:TColor );
var aver_,aver:Double;i,ya,ya_,x,x_:Integer;  yop,ycl, yhi, ylo, candleW:Integer;
min,max:Double;
begin

canvas.Pen.Color:=clCandles;
canvas.Pen.Width:=1;

aver_:=-1;


 min:=DrawCandles_min;
 max:=DrawCandles_max;

//candleW:=trunc(mWidth / count * 0.47);
//candleW:=trunc(mWidth / GraphicCount * 0.57);
//@@@@@@@@@@
candleW:=2;

for i:=0 to {count}GraphicCount-1 do
 begin
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 x:=GetX(i,GraphicCount,mWidth);

 yop:=  GetY( DrawCandles_min ,mHeight, min,max);     //DrawCandles_min;  //GetY(Open^[base+i] ,mHeight, min,max);     // bar bottom
 ycl:=  GetY(Close^[base+i],mHeight, min,max);                       // bar top


 //yhi:=GetY(High^[base+i] ,mHeight, min,max);
 //ylo:=GetY(Low^[base+i]  ,mHeight, min,max);

 {
 if yop=ycl then
  begin
  Canvas.MoveTo(x-candleW,yop);
  Canvas.lineTo(x+candleW,yop);
  end;
 Canvas.MoveTo(x,yhi);
 Canvas.lineTo(x,ylo);
 }

 Canvas.Brush.Style:=bsSolid;

 //if yop<ycl then Canvas.Brush.Color:=clWhite else  Canvas.Brush.Color:=clGreen;

 Canvas.Brush.Color:=barColor;
 Canvas.Rectangle(x-candleW, yop, x+candleW, ycl);

 end;

end;





PROCEDURE DrawCandlesHighlight(canvas:TCanvas; mWidth,mHeight,GraphicCount:Integer; open,high,low,close:PSample; Times:PTimes; Base,Count:Integer; detectMinMax:Boolean; hl:array of Double);
var aver_,aver:Double;i,ya,ya_,x,x_:Integer;  yop,ycl, yhi, ylo, candleW:Integer;
min,max:Double;
begin

canvas.Pen.Color:=clCandles;
canvas.Pen.Width:=1;

aver_:=-1;

if detectMinMax then
 begin
// GetPriceMinMaxPtr(open,high,low,close, base,{count}GraphicCount ,min,max);

 DrawCandles_minG:=min;
 DrawCandles_maxG:=max;
 end
else
 begin
 min:=DrawCandles_minG;
 max:=DrawCandles_maxG;
 end; 

//candleW:=trunc(mWidth / count * 0.47);
//candleW:=trunc(mWidth / GraphicCount * 0.57);
candleW:=2;

for i:=0 to {count}GraphicCount-1 do
 begin

 if hl[i]=0 then
 canvas.Pen.Color:=clCandles
 else canvas.Pen.Color:=clYellow;

 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 x:=GetX(i,GraphicCount,mWidth);

 yop:=GetY(Open^[base+i] ,mHeight, min,max);
 ycl:=GetY(Close^[base+i],mHeight, min,max);
 yhi:=GetY(High^[base+i] ,mHeight, min,max);
 ylo:=GetY(Low^[base+i]  ,mHeight, min,max);

 if yop=ycl then
  begin
  Canvas.MoveTo(x-candleW,yop);
  Canvas.lineTo(x+candleW,yop);
  end;
 Canvas.MoveTo(x,yhi);
 Canvas.lineTo(x,ylo);

 Canvas.Brush.Style:=bsSolid;
 
 if yop<ycl then Canvas.Brush.Color:=clWhite else  Canvas.Brush.Color:=clGreen;
 Canvas.Rectangle(x-candleW,yop,x+candleW,ycl);

 end;

end;
                            //count=6 - no sense here
                            //         base - zero candle in Past of ImgInf
                            //          v   future..v
                            //  5,  4,  3,  2,  1,  0
                            //

procedure DrawCandlesAsFuture(canvas:TCanvas; mWidth,mHeight,GraphicCount:Integer; open,high,low,close:PSample; Times:PTimes; Base,Count:Integer; min,max:Double);
var aver_,aver:Double;i,ya,ya_,x,x_:Integer;  yop,ycl, yhi, ylo, candleW:Integer;
//min,max:Double;
begin

canvas.Pen.Color:=clGray;
canvas.Pen.Width:=1;

aver_:=-1;

//GetPriceMinMaxPtr(open,high,low,close, base,{count}GraphicCount ,min,max);

//DrawCandles_minG:=min;
//DrawCandles_maxG:=max;

//candleW:=trunc(mWidth / count * 0.47);
//candleW:=trunc(mWidth / GraphicCount * 0.57);
candleW:=2;

for i:=base-1 downto 0 do
 begin
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 x:=GetXfutureForCandles(i,GraphicCount,mWidth,Base);

 yop:=GetY(Open^[0+i] ,mHeight, min,max);
 ycl:=GetY(Close^[0+i],mHeight, min,max);
 yhi:=GetY(High^[0+i] ,mHeight, min,max);
 ylo:=GetY(Low^[0+i]  ,mHeight, min,max);

 if yop=ycl then
  begin
  Canvas.MoveTo(x-candleW,yop);
  Canvas.lineTo(x+candleW,yop);
  end;
 Canvas.MoveTo(x,yhi);
 Canvas.lineTo(x,ylo);

 Canvas.Brush.Style:=bsSolid;
 
 if yop<ycl then Canvas.Brush.Color:=clWhite else  Canvas.Brush.Color:=clGreen;
 Canvas.Rectangle(x-candleW,yop,x+candleW,ycl);

 end;

end;



procedure PaintArray(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; pen_width:Integer);     //@@29.05.2024 @@yayva
var aver_,aver:Double;i,ya,ya_,x,x_:Integer;
 firstTact:Boolean;    ymin:integer;
begin
firstTact:=true;
aver_:=-1;
x_:=GetX(0,FullCount,mWidth);

for i:=0 to c-1 do
 begin
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 aver:= ma_shifted[i];
 x:=GetX(i,FullCount,mWidth); //trunc(mWidth-((mWidth / c) * (i)));
 //GetPriceMinMax2(ma_shifted,0,c,min,max);
 //y:=GetY(aver,mHeight,Pricemin,Pricemax);

 //if (aver_>-1) then   //to paint diff
 if not firstTact then
  try
  Canvas.pen.Color:=color;
  Canvas.pen.Width:=pen_width;     //@@err takes Image width

  ya:=  GetY(aver,mHeight,Pricemin,Pricemax);    //@err
  ya_:= GetY(aver_,mHeight,Pricemin,Pricemax);

  ymin:=  GetY(Pricemin,mHeight,Pricemin,Pricemax);
  {if ya<ymin then
   begin
    ya:=ymin;
   end;
  if ya_<ymin then
   begin
    ya_:=ymin;
   end;}

  Canvas.MoveTo(x,ya);
  Canvas.lineTo(x_,ya_);

  except
  end;

 aver_:=aver;
 x_:=x;
 firstTact:=False;
 end;
end;





procedure PaintArray_hyst(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; pen_width:Integer);     //@@29.05.2024 @@yayva
var aver_,aver:Double;i,ya,ya_,x,x_:Integer;
 firstTact:Boolean;    ymin:integer;
begin
firstTact:=true;
aver_:=-1;
x_:=GetX(0,FullCount,mWidth);

for i:=0 to c-1 do
 begin
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 aver:= ma_shifted[i];
 x:=GetX(i,FullCount,mWidth); //trunc(mWidth-((mWidth / c) * (i)));
 //GetPriceMinMax2(ma_shifted,0,c,min,max);
 //y:=GetY(aver,mHeight,Pricemin,Pricemax);

 //if (aver_>-1) then   //to paint diff
 if not firstTact then
  try
  Canvas.pen.Color:=color;
  Canvas.pen.Width:=pen_width;     //@@err takes Image width

  ya:=  GetY(aver,mHeight,Pricemin,Pricemax);    //@err
  ya_:= GetY(aver_,mHeight,Pricemin,Pricemax);

  ymin:=  GetY(Pricemin,mHeight,Pricemin,Pricemax);
  {if ya<ymin then
   begin
    ya:=ymin;
   end;
  if ya_<ymin then
   begin
    ya_:=ymin;
   end;}



  Canvas.MoveTo(x,ya);
  Canvas.lineTo(x_,ya_);

  except
  end;

 aver_:=aver;
 x_:=x;
 firstTact:=False;
 end;
end;



procedure PaintArrayOnGraphicCandle(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer; CandleIndex:Integer);
var aver_,aver:Double;i,ya,ya_,x,x_:Integer;

begin
aver_:=-1;
x_:=GetX(0,FullCount,mWidth);

for i:=0 to c-1 do
 begin
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 aver:= ma_shifted[i];
 x:=GetX(i+CandleIndex,FullCount,mWidth); //trunc(mWidth-((mWidth / c) * (i)));
 //GetPriceMinMax2(ma_shifted,0,c,min,max);
 //y:=GetY(aver,mHeight,Pricemin,Pricemax);

 if (aver_>-1) then
  try
  Canvas.pen.Color:=color;
  Canvas.pen.Width:=width;

  ya:=  GetY(aver,mHeight,Pricemin,Pricemax);    //@err
  ya_:= GetY(aver_,mHeight,Pricemin,Pricemax);
  
  Canvas.MoveTo(x,ya);
  Canvas.lineTo(x_,ya_);

  except
  end;

 aver_:=aver;
 x_:=x;
 end;
end;



procedure PaintArrayPoints(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
var aver_,aver:Double;i,ya,ya_,x,x_:Integer;

begin
aver_:=-1;
x_:=GetX(0,FullCount,mWidth);
Canvas.pen.Color:=color;
Canvas.pen.Width:=1;
canvas.Font.Color:=color;
for i:=0 to c-1 do
 begin
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 aver:= ma_shifted[i];
 x:=GetX(i,FullCount,mWidth); //trunc(mWidth-((mWidth / c) * (i)));
 //GetPriceMinMax2(ma_shifted,0,c,min,max);
 //y:=GetY(aver,mHeight,Pricemin,Pricemax);

 ya:=  GetY(aver,mHeight,Pricemin,Pricemax);
 Canvas.Rectangle(x-width div 2,ya-width div 2,x+width div 2,ya+width div 2);

 Canvas.TextOut(x,ya,inttostr(i));
    {
 if (aver_>-1) then
  try
  Canvas.pen.Color:=color;
  Canvas.pen.Width:=width;

  ya:=  GetY(aver,mHeight,Pricemin,Pricemax);    //@err
  ya_:= GetY(aver_,mHeight,Pricemin,Pricemax);

  Canvas.MoveTo(x,ya);
  Canvas.lineTo(x_,ya_);

  except
  end;
     }
 aver_:=aver;
 x_:=x;
 end;
end;





procedure PaintArrayStraight(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
var aver_,aver:Double;i,k,ya,ya_,x,x_:Integer;

begin
Canvas.pen.Style:=psSolid;
aver_:=-1;
x_:=GetX(0,FullCount,mWidth);

for k:=0 to {c-1}1 do
 begin
 if k=0 then i:=0 else i:=c-1;
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 aver:= ma_shifted[i];
 x:=GetX(i,FullCount,mWidth); //trunc(mWidth-((mWidth / c) * (i)));
 //GetPriceMinMax2(ma_shifted,0,c,min,max);
 //y:=GetY(aver,mHeight,Pricemin,Pricemax);

 if (aver_>-1) then
  try
  Canvas.pen.Color:=color;
  Canvas.pen.Width:=width;

  ya:=  GetY(aver,mHeight,Pricemin,Pricemax);    //@err
  ya_:= GetY(aver_,mHeight,Pricemin,Pricemax);
  
  Canvas.MoveTo(x,ya);
  Canvas.lineTo(x_,ya_);

  except
  end;

 aver_:=aver;
 x_:=x;
 end;
end;

//same with pen style
procedure PaintArrayStraightPS(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer; PS:TPenStyle);
var aver_,aver:Double;i,k,ya,ya_,x,x_:Integer;

begin
aver_:=-1;
x_:=GetX(0,FullCount,mWidth);
Canvas.pen.Style:=PS;
for k:=0 to {c-1}1 do
 begin
 if k=0 then i:=0 else i:=c-1;
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 aver:= ma_shifted[i];
 x:=GetX(i,FullCount,mWidth); //trunc(mWidth-((mWidth / c) * (i)));
 //GetPriceMinMax2(ma_shifted,0,c,min,max);
 //y:=GetY(aver,mHeight,Pricemin,Pricemax);

 if (aver_>-1) then
  try
  Canvas.pen.Color:=color;
  Canvas.pen.Width:=width;

  ya:=  GetY(aver,mHeight,Pricemin,Pricemax);    //@err
  ya_:= GetY(aver_,mHeight,Pricemin,Pricemax);
  
  Canvas.MoveTo(x,ya);
  Canvas.lineTo(x_,ya_);

  except
  end;

 aver_:=aver;
 x_:=x;
 end;
end;


procedure PaintArrayFuture(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
var aver_,aver:Double;i,ya,ya_,x,x_:Integer;

begin
Canvas.pen.Style:=psSolid;
aver_:=-1;
x_:=GetX(0,FullCount,mWidth);

for i:=0 to c-1 do
 begin
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 aver:= ma_shifted[i];
 x:=GetXFuture(i,FullCount,mWidth); //trunc(mWidth-((mWidth / c) * (i)));
 //GetPriceMinMax2(ma_shifted,0,c,min,max);
 //y:=GetY(aver,mHeight,Pricemin,Pricemax);

 if (aver_>-1) then
  begin
  Canvas.pen.Color:=color;
  Canvas.pen.Width:=width;

  ya:=  GetY(aver,mHeight,Pricemin,Pricemax);
  ya_:= GetY(aver_,mHeight,Pricemin,Pricemax);
 
  
  begin
  Canvas.MoveTo(x,ya);
  Canvas.lineTo(x_,ya_);
  end;


  end;

 aver_:=aver;
 x_:=x;
 end;
end;



procedure PaintArrayFutureStraight(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
var aver_,aver:Double;i,k,ya,ya_,x,x_:Integer;

begin
Canvas.pen.Style:=psSolid;
aver_:=-1;
x_:=GetX(0,FullCount,mWidth);

for k:=0 to {c-1}1 do
 begin
 if k=0 then i:=0 else i:=c-1;
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 aver:= ma_shifted[i];
 x:=GetXFuture(i,FullCount,mWidth); //trunc(mWidth-((mWidth / c) * (i)));
 //GetPriceMinMax2(ma_shifted,0,c,min,max);
 //y:=GetY(aver,mHeight,Pricemin,Pricemax);

 if (aver_>-1) then
  begin
  Canvas.pen.Color:=color;
  Canvas.pen.Width:=width;

  if (aver>SCRUTABLE_MIN) and (aver<SCRUTABLE_Max) and
  (aver_>SCRUTABLE_MIN) and (aver_<SCRUTABLE_Max) then
   begin
   ya:=  GetY(aver,mHeight,Pricemin,Pricemax);
   ya_:= GetY(aver_,mHeight,Pricemin,Pricemax);

   Canvas.MoveTo(x,ya);
   Canvas.lineTo(x_,ya_);
   end;


  end;

 aver_:=aver;
 x_:=x;
 end;
end;




procedure PaintArrayFutureBase(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; base,c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
var aver_,aver:Double;i,ya,ya_,x,x_:Integer;

begin
Canvas.pen.Style:=psSolid;
aver_:=-1;
x_:=GetX(0,FullCount,mWidth);

for i:=0 to c-1 do
 begin
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 aver:= ma_shifted[base+i];
 x:=GetXFuture(i,FullCount,mWidth); //trunc(mWidth-((mWidth / c) * (i)));
 //GetPriceMinMax2(ma_shifted,0,c,min,max);
 //y:=GetY(aver,mHeight,Pricemin,Pricemax);

 if (aver_>-1) then
  begin
  Canvas.pen.Color:=color;
  Canvas.pen.Width:=width;

  ya:=  GetY(aver,mHeight,Pricemin,Pricemax);
  ya_:= GetY(aver_,mHeight,Pricemin,Pricemax);
 
  
  begin
  Canvas.MoveTo(x,ya);
  Canvas.lineTo(x_,ya_);
  end;


  end;

 aver_:=aver;
 x_:=x;
 end;
end;



procedure PaintArrayFutureBaseStraight(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted:array of Double; base,c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
var aver_,aver:Double;i,k,ya,ya_,x,x_:Integer;

begin
Canvas.pen.Style:=psSolid;
aver_:=-1;
x_:=GetX(0,FullCount,mWidth);

for k:=0 to {c-1}1 do
 begin
 if k=0 then i:=0 else i:=c-1;
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 aver:= ma_shifted[base+i];
 x:=GetXFuture(i,FullCount,mWidth); //trunc(mWidth-((mWidth / c) * (i)));
 //GetPriceMinMax2(ma_shifted,0,c,min,max);
 //y:=GetY(aver,mHeight,Pricemin,Pricemax);

 if (aver_>-1) then
  begin
  Canvas.pen.Color:=color;
  Canvas.pen.Width:=width;

  ya:=  GetY(aver,mHeight,Pricemin,Pricemax);
  ya_:= GetY(aver_,mHeight,Pricemin,Pricemax);
 
  
  begin
  Canvas.MoveTo(x,ya);
  Canvas.lineTo(x_,ya_);
  end;


  end;

 aver_:=aver;
 x_:=x;
 end;
end;





procedure PaintLine(canvas:TCanvas; mWidth,mHeight,FullCount:Integer; ma_shifted: Double; c:Integer; Pricemin,Pricemax:Double; Color:TColor; Width:Integer);
var aver_,aver:Double;i,ya,ya_,x,x_:Integer;

begin
Canvas.pen.Style:=psSolid;
aver_:=-1;
x_:=GetX(0,FullCount,mWidth);

for i:=0 to c-1 do
 begin
 {$ifdef DO_PROCESS_MESSAGES}Application.ProcessMessages;{$endif}
 aver:= ma_shifted;
 x:=GetX(i,FullCount,mWidth); //trunc(mWidth-((mWidth / c) * (i)));
 //GetPriceMinMax2(ma_shifted,0,c,min,max);
 //y:=GetY(aver,mHeight,Pricemin,Pricemax);

 if (aver_>-1) then
  begin
  Canvas.pen.Color:=color;
  Canvas.pen.Width:=width;

  ya:=  GetY(aver,mHeight,Pricemin,Pricemax);
  ya_:= GetY(aver_,mHeight,Pricemin,Pricemax);
 
  
  begin
  Canvas.MoveTo(x,ya);
  Canvas.lineTo(x_,ya_);
  end;


  end;

 aver_:=aver;
 x_:=x;
 end;
end;


end.
