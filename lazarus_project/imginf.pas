unit imginf;



interface
uses
   Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,   dateutils,
   ComCtrls, Grids, math,grphk,
  lag_rec   ,bmparr   ,menus

  ;


const
  DEFAULT_CHART_LINE_WIDTH = 2;

  HEIGHT_DRAW_PART = 0.8;

  HYST_GROUP = 60;

type


PChartInfo =^TChartInfo;
TChartInfo = object


  chart_index:Integer;

  chartType :Integer;
  width, order:Integer;

       // MAIN chart


  color:tcolor;

  function getfDrawCandles_min :Double;
  function getfDrawCandles_max :Double;
  property fDrawCandles_min :double  read  getfDrawCandles_min  ;
  property fDrawCandles_max :double  read  getfDrawCandles_max  ;
end;


TImageInfo3=class;

TIP=class(TImage)
function info:TImageInfo3;
//procedure Refine;
end;

 TPointInfo=record
 found:Boolean;
 sec:Extended;
 price,delta:Double;
        //Extended;

 end;
TCrossesStorage=record
a:array[0..255] of TPointInfo;
Count:Integer;
end;
PCrossesStorage=^TCrossesStorage;

//@new
TCursorMove=procedure(
            Sender: TObject;      //
            Shift: TShiftState;   //..
            X,Y: Integer;         // standard mouse MOve proc
            CandleIndex:Integer;  //
                                  //                           mouse right left
            CursorPrice:Double
            ) of object;

TImageInfo3=class
private
 fSelectedCurve:Integer;
public


popup:TPopupMenu;
//fmainChartType:Integer;
mainChartInfo:TChartInfo;
//extras
extras:array of TChartInfo;
///////////

fToolsAfterChartMoved:TNotifyEvent;

barr:TBitmap;

FormIndex:Integer;
Tools:Pointer;
OV:array[0..20] of Double;
OVnames:array [0..20] of String;
OVcount:Integer;

Point:Double;

CandleCount:Integer;


secw:Integer;

m:TImage;

b:TBitmap;
//a:PColorArray;
SecondsWidth,PolygonStock:Integer;

fOnCursorMove,fOnCursorDown,fOnCursorUp:TCursorMove;
NoCandlesMinMax:Boolean;



cis,cisFut:PCandleInfoShell;

dt_present:TDateTime;
vert_line_interval_sec:Integer;
whole_interval_sec:Integer;
title:String;
horz_grid:array of double;

arr_painted:array of double;          // MAIN chart
arr_painted_dt:array of TDatetime;



function get_chart_info(ntx_in_self:Integer):TChartInfo;

procedure setSelectedCurve(index:Integer);
property SelectedCurve_in_self {main or extras} :Integer read fSelectedCurve write  setSelectedCurve ;

property chart_index:Integer read mainChartInfo.chart_index write mainChartInfo.chart_index;

procedure setMainChartType(val:Integer);
property MainChartType    :Integer read  mainChartInfo.chartType  write  setMainChartType ;

procedure saveVerticalBounds;
procedure restoreVerticalBounds;
procedure DrawLineOrHyst(info:TChartInfo; const arr_ii:array of TImageInfo3);
procedure DrawWithExtras(const arr_ii:array of TImageInfo3 );
function findExtra(arr_ii_index:Integer):Integer;
class function findExtra_onArray(arr_ii_index:Integer; const a_extras: array of TChartInfo):Integer;
//////////

procedure PaintPhysValChart(arr:array of double);
function candle_dt(cnd:Integer ):TDateTime;
function vert_line_to_display(dt:TDateTime):Boolean;
function vert_line_to_display2(dt:TDateTime):Boolean;



procedure draw_horz_grid;
procedure draw_vert_grid;

function dt_X(dt:TDateTime):Integer;
 ////////////////
function GetCandleIndex(x:Integer):Integer;
function GetCandleIndexMayMinus(x:Integer):Integer;
procedure ImageCursorMove(     
            Sender: TObject;      //
            Shift: TShiftState;   //..
            X,Y: Integer         // standard mouse MOve proc
            );
procedure ImageCursorDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
procedure ImageCursorUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
procedure SetOnCursorMove(P:TCursorMove);
procedure SetOnCursorDown(P:TCursorMove);
procedure SetOnCursorUp(P:TCursorMove);
property OnCursorMove :TCursorMove read fOnCursorMove write SetOnCursorMove;
property OnCursorDown :TCursorMove read fOnCursorDown write SetOnCursorDown;
property OnCursorUp :TCursorMove read fOnCursorUp write SetOnCursorUp;

procedure Refine;
constructor Create(am:TImage;aPolygonStock,{AtimeType}Asecw,aCandleCount:Integer;aCis,acisfut:PCandleInfoShell);
function Canvas:TCanvas;
function Width:Integer;
function height:Integer;
procedure Paint;

procedure DrawWallArrays;
procedure ClearBitmap;
procedure DrawCrosses;

function CandlesPratum:Integer;


procedure PaintArray( ma_shifted:array of Double; c:Integer; Color:TColor; aWidth:Integer; const info:TChartInfo );
//procedure PaintArray_hyst( ma_shifted:array of Double; cnt :Integer; Color:TColor; aWidth:Integer);
procedure DrawCandles_hyst(   close:array of double  ; const  info:TChartInfo    {;  Base,Count:Integer}  );

function CandleX(i:Integer):Integer;
function CandleY(Price:Double; const info:TChartInfo {coz must recalc for ech curve }):Integer;

procedure FreeWallArrays;
//procedure AddProbe(wl:TWall);
procedure FreeProbes;
procedure DrawProbes;

procedure DrawLine(cnd0:Integer; prc0:Double; cnd1:Integer; prc1:Double  );
//procedure DrawLine_y_recalc(cnd0:Integer; prc0:Double; cnd1:Integer; prc1:Double; info:TChartInfo ); //@@displ @@extra
procedure DrawLineOnArray(cnd0:Integer; prc0:Double; cnd1:Integer; prc1:Double; col:TColor; Solidness:Double);


procedure DrawRay(cnd0:Integer;prc0:Double; cnd1:Integer; derUSDH:Double);
procedure DrawRay2(cnd0:Integer;prc0:Double; cnd1:Integer; der:Double);
procedure DrawLineVert(cnd:Integer;prc0:Double;prc1:Double);
procedure DrawLineVertFull(cnd:Integer);
procedure DrawLineVertFull_DT(dt:tdatetime);


procedure Circle(cnd:Integer; prc:Double; r:Integer; Color:TColor; aWidth:Integer);

procedure ArrayToBmp;
procedure BmpToArray;

end;



function get_max_in_group(close:array of double; grp_w:Integer; i_candle:Integer):Double;



implementation uses frm_chart;


function TChartInfo.getfDrawCandles_min :Double;
begin
  result:=get_val4(self.chart_index);
end;

function TChartInfo.getfDrawCandles_max :Double;
begin
 result:=get_val20(self.chart_index);
end;

procedure TImageInfo3.draw_vert_grid;
var i,x,xt:Integer;   dt,dt0:TDateTime;  s:String;
  ii:TImageInfo3;     nvert_drawn:Integer;
begin
  ii:=self;




  ii.Canvas.Pen.Width:=1;
  ii.Canvas.Pen.Color:=clgreen;
  ii.Canvas.Font.Color:=cllime;
  ii.Canvas.Font.Height:=7;
  nvert_drawn:=0;

  dt0:=recodesecond(dt_present,0);
  //for i:=0 to ii.whole_interval_sec-1 do
  for i:=0 to ii.CandleCount-1 do
   begin
     //dt:=incSecond(ii.dt_present,-i);
     dt:= incsecond(dt0, -i*ii.secw);
     if ii.vert_line_to_display2(dt) then
      begin
       //
       ii.DrawLineVertFull_DT(dt);
       x:=ii.dt_X(dt);
       //@@with min  //s:=FormatDateTime('hh:nn',dt)   ;
       s:=FormatDateTime('hh',dt)   ;


       //timetostr(dt)  ;
       xt:=  x-ii.Canvas.TextWidth(s) div 2 ;
       if xt<0 then xt:=0;

       ii.Canvas.Font.Style:=[];
       ii.Canvas.Font.Height:=trunc( ii.height * 0.05 );
       //if ii.Canvas.Font.Height<7 then ii.Canvas.Font.Height:=7;
       //to avoid overlap of times//   if nvert_drawn mod 2 = 0 then
       ii.Canvas.TextOut(xt,ii.height-{20} ii.Canvas.Textheight(s) +1 ,s);

       inc(nvert_drawn);
      end;


   end;
  //s:= FormatDateTime('YYYY-MM-dd hh:nn',ii.dt_present)        ;
  // @@with date  //s:= FormatDateTime('dd.MM.YYYY  hh:nn:ss',ii.dt_present)        ;
  s:= FormatDateTime('hh:nn:ss',ii.dt_present)        ;


end;



procedure TImageInfo3.PaintPhysValChart(arr:array of double);
var i,x,xt:Integer;   dt,dt0:TDateTime;  s:String;
  ii:TImageInfo3;     nvert_drawn:Integer;
begin
  ii:=self;


  //ii.ClearBitmap;
  //ii.draw_horz_grid;  // done before
  ii.ArrayToBmp;






  ii.Canvas.Pen.Color:=clgreen;
  ii.Canvas.Font.Color:=cllime;
  ii.Canvas.Font.Height:=7;
  nvert_drawn:=0;

  dt0:=recodesecond(dt_present,0);
  //for i:=0 to ii.whole_interval_sec-1 do
  for i:=0 to ii.CandleCount-1 do
   begin
     //dt:=incSecond(ii.dt_present,-i);
     dt:= incsecond(dt0, -i*ii.secw);
     if ii.vert_line_to_display2(dt) then
      begin
       //
       ii.DrawLineVertFull_DT(dt);
       x:=ii.dt_X(dt);
       //@@with min  //s:=FormatDateTime('hh:nn',dt)   ;
       s:=FormatDateTime('hh',dt)   ;


       //timetostr(dt)  ;
       xt:=  x-ii.Canvas.TextWidth(s) div 2 ;
       if xt<0 then xt:=0;

       //to avoid overlap of times//   if nvert_drawn mod 2 = 0 then
       ii.Canvas.TextOut(xt,ii.height-{20} ii.Canvas.Textheight(s) +1 ,s);

       inc(nvert_drawn);
      end;


   end;
  //s:= FormatDateTime('YYYY-MM-dd hh:nn',ii.dt_present)        ;
  // @@with date  //s:= FormatDateTime('dd.MM.YYYY  hh:nn:ss',ii.dt_present)        ;
  s:= FormatDateTime('hh:nn:ss',ii.dt_present)        ;
  //datetimetostr( ii.dt_present );


  ii.Canvas.TextOut({ii.CandleX(0)} {ii.Width}  ii.CandleX(0)-ii.Canvas.TextWidth(s)+5{-10} {+20} , 0-2, s);

  ii.Canvas.TextOut(10 , 0, title);


 // ii.PaintArray(arr,length(arr),clRed,2);  //@@rrr

  ii.BmpToArray;
  ii.Paint;

end;


function TImageInfo3.candle_dt(cnd:Integer ):TDateTime;
var n:Integer; part,per_cnd:Double; x, past_x,pres_x:Integer; dt:TDatetime;
begin
 result:= dt_present;
 //if dt<dt_present then
  begin
   //n:=
   //secondsBetween(dt,dt_present);
   part:= cnd / CandleCount;
   per_cnd:= whole_interval_sec / CandleCount;
    //n / whole_interval_sec;
   dt:= IncSecond(dt_present, trunc(-per_cnd*cnd));

   result:=dt;


  end;


end;


function TImageInfo3.dt_X(dt:TDateTime):Integer;
var n:Integer; part:Double; x, past_x,pres_x:Integer;
begin
 result:= CandleX(0);
 if dt<dt_present then
  begin
   n:=secondsBetween(dt,dt_present);
   part:=n / whole_interval_sec;
   past_x:=CandleX(CandleCount-1);
   pres_x:=CandleX(0);
   x:=pres_x - trunc((pres_x-past_x)*part);
   result:=x;


  end;


end;


function TImageInfo3.vert_line_to_display(dt:TDateTime):boolean;
var t:TDateTime; sec:Integer; md:integer;
begin
 //t:=timeof(dt);
 sec:= secondsBetween( trunc(dt_present) , dt )+1;
 //secondOfTheDay(  t);
 if vert_line_interval_sec=0 then
   vert_line_interval_sec:=600;
 md:=  (sec mod self.vert_line_interval_sec) ;
 result:= md= 0 ;

end;


function TImageInfo3.vert_line_to_display2(dt:TDateTime):boolean;
var t:TDateTime; sec,min:Integer; md:integer;
begin
 //t:=timeof(dt);
 sec:= secondsBetween( 0, timeof(dt) )+0;
 //secondOfTheDay(  t);
 if vert_line_interval_sec=0 then
   vert_line_interval_sec:=600;
 md:=  (sec mod self.vert_line_interval_sec) ;
 result:= md= 0 ;

end;

procedure TImageInfo3.draw_horz_grid;
var i,y:Integer; v:double;  s:string;
begin

 canvas.Font.Color:=clLime;
 canvas.Pen.Color:=clGreen;
 canvas.Pen.Width:=1;
 for i:=0 to length(horz_grid)-1 do
  begin
   v:= horz_grid[i];
   y:=CandleY(v, get_chart_info(SelectedCurve_in_self) );
   DrawLine(0,v,CandleCount,v);
   s:=   Formatfloat('0.0',v);
   canvas.TextOut( width-canvas.TextWidth(s), y-canvas.TextHeight('0') div 2, s  );

  end;


end;


procedure TImageInfo3.DrawRay2(cnd0:Integer;prc0:Double; cnd1:Integer; der:Double);
var x0,y0,x1,y1:Integer;  prc1:Double;
begin

x0:=CandleX(cnd0);
y0:=CandleY(prc0, get_chart_info(SelectedCurve_in_self));
x1:=CandleX(cnd1);

prc1:=prc0+der * (cnd1-cnd0);
y1:=CandleY(prc1, get_chart_info(SelectedCurve_in_self));

///////////
Canvas.MoveTo(x0,y0);
Canvas.LineTo(x1,y1);


end;

procedure TImageInfo3.ArrayToBmp;
begin
//ArrayToBitmap(a,b);

if barr<>nil then
 begin
 b.Canvas.Draw(0,0,barr);

 end;
end;

procedure TImageInfo3.BmpToArray;
begin
//BitmapToArray(a,b);   //@@yayva     @@arr

if barr=nil then barr:=TBitmap.Create;
barr.Width:=b.Width;
barr.Height:=b.Height;
barr.Canvas.Draw(0,0,b);

end;

procedure TImageInfo3.Circle(cnd:Integer; prc:Double; r:Integer; Color:TColor; aWidth:Integer);
var x,y:Integer;
begin

x:=CandleX(cnd);
y:=CandleY(prc, get_chart_info(SelectedCurve_in_self));

b.Canvas.Brush.Style:=bsClear;
b.Canvas.Pen.Color:=Color;
b.Canvas.Pen.Width:=Width;
b.Canvas.Ellipse(x-r,y-r,x+r,y+r);

end;



procedure TImageInfo3.DrawLine(cnd0:Integer; prc0:Double; cnd1:Integer; prc1:Double  );
var x0,y0,x1,y1:Integer;
begin
x0:=CandleX(cnd0);
y0:=CandleY(prc0, get_chart_info(SelectedCurve_in_self));
x1:=CandleX(cnd1);
y1:=CandleY(prc1, get_chart_info(SelectedCurve_in_self));
///////////
Canvas.MoveTo(x0,y0);
Canvas.LineTo(x1,y1);
end;

procedure TImageInfo3.DrawLineOnArray(cnd0:Integer; prc0:Double; cnd1:Integer; prc1:Double; col:TColor; Solidness:Double);
var x1,y1,x2,y2:Integer;
begin
x1:=Candlex(cnd0);
x2:=Candlex(cnd1);
y1:=Candley(prc0, get_chart_info(SelectedCurve_in_self));
y2:=Candley(prc1, get_chart_info(SelectedCurve_in_self));
//bmparr.LineOnArray(a,b.Width,b.Height,x1,y1,x2,y2,col,Solidness);

end;

procedure TImageInfo3.DrawLineVert(cnd:Integer;prc0:Double;prc1:Double);
var x0,y0,y1:Integer;
begin
x0:=CandleX(cnd);
y0:=CandleY(prc0, get_chart_info(SelectedCurve_in_self));
y1:=CandleY(prc1, get_chart_info(SelectedCurve_in_self));
///////////
Canvas.MoveTo(x0,y0);
Canvas.LineTo(x0,y1);
end;

procedure TImageInfo3.DrawLineVertFull(cnd:Integer);
var x0,y0,y1:Integer;
begin
x0:=CandleX(cnd);

//y0:=CandleY(self.DrawCandles_min, get_chart_info(SelectedCurve_in_self));
//y1:=CandleY(self.DrawCandles_max, get_chart_info(SelectedCurve_in_self));

y0:=height - trunc(height * (1.0-HEIGHT_DRAW_PART) / 2);
y1:=  trunc(height * (1.0-HEIGHT_DRAW_PART) / 2);

///////////
Canvas.MoveTo(x0,y0);
Canvas.LineTo(x0,y1);
end;


procedure TImageInfo3.DrawLineVertFull_DT(dt:tdatetime);
var x0,y0,y1:Integer;
begin
x0:=dt_x(dt);

y0:=height - trunc(height * (1.0-HEIGHT_DRAW_PART) / 2);
y1:=  trunc(height * (1.0-HEIGHT_DRAW_PART) / 2);

///////////
Canvas.MoveTo(x0,y0);
Canvas.LineTo(x0,y1);
end;

procedure TImageInfo3.DrawRay(cnd0:Integer;prc0:Double; cnd1:Integer; derUSDH:Double);
var x0,y0,x1,y1:Integer;  der,prc1:Double;
begin

end;

//@new
function TImageInfo3.GetCandleIndex(x:Integer):Integer;
begin
//coded for schemes - left-right
Result:=CandleCount-grphk.GetCandleIndex(x,CandleCount,CandlesPratum)-1;
//function GetCandle(X,c,mWidth:Integer):Integer;
end;

function TImageInfo3.GetCandleIndexMayMinus(x:Integer):Integer;
begin
//coded for schemes - left-right
Result:=CandleCount-grphk.GetCandleIndexMayMinus(x,CandleCount,CandlesPratum)-1;
//function GetCandle(X,c,mWidth:Integer):Integer;
end;

procedure TImageInfo3.SetOnCursorMove(P:TCursorMove);
begin
fOnCursorMove:=p;
m.OnMouseMove:=TMouseMoveEvent(@ImageCursorMove);
end;

procedure TImageInfo3.SetOnCursorDown(P:TCursorMove);
begin
fOnCursorDown:=p;
m.OnMouseDown:=TMouseEvent(@ImageCursorDown);
end;

procedure TImageInfo3.SetOnCursorUp(P:TCursorMove);
begin
fOnCursorUp:=p;
m.OnMouseUp:=TMouseEvent(@ImageCursorUp);
end;

procedure TImageInfo3.  ImageCursorMove(
            Sender: TObject;      //
            Shift: TShiftState;   //..
            X,Y: Integer         // standard mouse MOve proc
            );
begin
//function
//GetPrice(Y:Double; mHeightFull:Integer; PriceMin,PriceMax:Double):Double;

if assigned(fOnCursorMove) then
 fOnCursorMove(
            Self, //Sender,
            Shift  ,
            X,Y, GetCandleIndex(CandlesPratum-x),
            GetPrice(Y,Height,
             get_chart_info(SelectedCurve_in_self).fDrawCandles_min, get_chart_info(SelectedCurve_in_self).fDrawCandles_max               )      //fDrawCandles_min,fDrawCandles_max)

             );

if assigned(Tools) then
 begin

 end;

end;

procedure TImageInfo3.  ImageCursorDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if assigned(fOnCursorDown) then
 fOnCursorDown(
            Self, //Sender,
            Shift  ,
            X,Y, GetCandleIndex(CandlesPratum-x),
            GetPrice(Y,Height,get_chart_info(SelectedCurve_in_self).fDrawCandles_min,get_chart_info(SelectedCurve_in_self).fDrawCandles_max            ) //fDrawCandles_min,fDrawCandles_max)

            );



end;

procedure TImageInfo3.  ImageCursorUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

if button=mbRight then
 begin
  //
  if popup<>nil then
   begin
    popup.Tag:= integer( pointer(self));
   end;

 end;

if assigned(fOnCursorUp) then
 fOnCursorUp(
            Self, //Sender,
            Shift  ,
            X,Y, GetCandleIndex(CandlesPratum-x),
            GetPrice(Y,Height,get_chart_info(SelectedCurve_in_self).fDrawCandles_min,get_chart_info(SelectedCurve_in_self).fDrawCandles_max   )//fDrawCandles_min,fDrawCandles_max)
            );
if assigned(Tools) then
 begin

 end;
end;

/////////////


procedure TImageInfo3.DrawProbes;

begin

end;


 
procedure TImageInfo3.FreeProbes;
var  i:Integer;
begin

end;



procedure TImageInfo3.FreeWallArrays;
var  i:Integer;
begin

end;





procedure TImageInfo3.PaintArray( ma_shifted:array of Double; c:Integer; Color:TColor; aWidth:Integer; const info:TChartInfo);
var i:Integer;
begin

grphk.PaintArray(
 Canvas,
 CandlesPratum,
 Height,
 CandleCount,
 ma_shifted,
 c,


 info.fDrawCandles_min,   // get_chart_info(SelectedCurve_in_self).fDrawCandles_min,    //WRONG!!!!!!!!!!
 info.fDrawCandles_max,   // get_chart_info(SelectedCurve_in_self).fDrawCandles_max,            //DrawCandles_min,DrawCandles_max,

 Color,
 aWidth);


end;



/////////////////////////



function TImageInfo3.CandleX(i:Integer):Integer;
begin
Result:=GetX(i,CandleCount,CandlesPratum);
end;

function TImageInfo3.CandleY(Price:Double;  const info:TChartInfo ):Integer;
begin
//Result:=GetY(Price,Height,DrawCandles_min,DrawCandles_max);
 Result:=GetY(Price,Height,info.fDrawCandles_min,info.fDrawCandles_max);
end;





function get_max_in_group(close:array of double; grp_w:Integer; i_candle:Integer):Double;
var igrp,i, i_arr :Integer;   gmax:Double;
begin
 gmax:=-1e99;
 igrp:=  i_candle div  grp_w;
 for i:=0 to grp_w-1 do
  begin
    i_arr:=  igrp * grp_w + i;

    if close[ i_arr] > gmax then  gmax := close[i_arr];
  end;
 result:=gmax;
end;

procedure TImageInfo3.DrawCandles_hyst(   close:array of double; const  info:TChartInfo     );
var count_close, grp_w ,x1,x2,y1,y2, i,igrp:Integer;  gmax:array of double;
begin
 //
 //canvas.MoveTo(0,0);
 //canvas.Lineto(width,height);

 //
 grp_w:=60;

 setLength(gmax, length(close) div grp_w);    //@@init 0s @@TODO

 for i:=0 to length(close)-1 do
  begin
   //
  igrp:= i div grp_w;
  if close[ i] > gmax[igrp] then  gmax[igrp] := close[i];



  end;

 //canvas.Pen.Color:=clBlue;
 //canvas.Pen.Width:=3;
 for i:=0 to length(gmax)-1 do
 begin
  x1:=candleX(i*grp_w);
  x2:=candleX(i*grp_w+trunc(grp_w*0.8));
  y1:= Height - trunc( Height*(1-HEIGHT_DRAW_PART)/2 ) ; //candleY( fDrawCandles_min, get_chart_info(SelectedCurve_in_self) );
  y2:=candleY(gmax[i],  info          {get_chart_info(SelectedCurve_in_self) }    );
  canvas.Rectangle(x1,y1,x2,y2);
 end;


//if NoCandlesMinMax then
 begin
 //DrawCandles_minG:=self.fDrawCandles_min;
 //DrawCandles_maxG:=self.fDrawCandles_max;
 end;

 //procedure DrawCandles_hyst(canvas:TCanvas; mWidth,mHeight,GraphicCount:Integer;    close:PSample;   Base,Count:Integer ; DrawCandles_min,  DrawCandles_max:Integer ; barColor:TColor );

 count_close:= Length(close);

 //@@ grphk.DrawCandles_hyst(Canvas, CandlesPratum , Height, CandleCount,  @(close),  0,    count_close, fDrawCandles_min, fDrawCandles_max , clGreen );





//if not NoCandlesMinMax then
 begin
 //self.fDrawCandles_min:=grphk.DrawCandles_minG;
 //self.fDrawCandles_max:=grphk.DrawCandles_maxG;
 end;

end;




function TImageInfo3.CandlesPratum:Integer;
begin
Result:=m.Width-PolygonStock;
end;


procedure TImageInfo3.DrawCrosses;
var  i:Integer;
//var y1,y2,x1,x2:Double; w:TWall;
begin

end;

procedure TImageInfo3.ClearBitmap;
begin
Canvas.Brush.Color:=clBlack  ;//clWhite;         //clBlack
Canvas.FillRect(m.ClientRect);
end;

{
procedure TImageInfo3.DrawWalls;
var  i:Integer;
begin

for i:=0 to walls.Count-1 do
 begin
 drawwall(walls[i]);

 end;


end;
 }
procedure TImageInfo3.DrawWallArrays;
var  i:Integer;
begin



end;








function TIP.info:TImageInfo3;
begin
Result:= TImageInfo3(tag);
end;

procedure TImageInfo3.Paint;
begin
m.Canvas.Draw(0,0,b);
m.Update;
end;

function TImageInfo3.Width:Integer;
begin
Result:=m.Width;

end;

function TImageInfo3.height:Integer;
begin
Result:=m.Height;


end;

function TImageInfo3.Canvas:TCanvas;
begin
Result:=b.Canvas;

end;

procedure TImageInfo3.Refine;
begin
if b=nil then b:=TBitmap.Create;
b.Width:=m.Width;
b.Height:=m.Height;

end;



constructor TImageInfo3.  Create(am:TImage;aPolygonStock,{AtimeType}Asecw,aCandleCount:Integer;aCis,acisfut:PCandleInfoShell);
begin
inherited create;
CandleCount:=aCandleCount;
//TimeType:=aTimetype;
secw:=Asecw;

m:=am;
m.Tag:=Integer(pointer(Self));

Refine;
BmpResize(b,m.Width,m.Height);
//a:=bmparr.AllocArrayForBmp(b);  //@@yayva

PolygonStock:=aPolygonStock;

cis:=acis;
cisfut:=aCisfut;

barr:=nil;

setlength(self.extras,0);

self.fSelectedCurve:=0;
end;



procedure TImageInfo3.DrawLineOrHyst(info:TChartInfo; const arr_ii:array of TImageInfo3 );
begin
   saveVerticalBounds;
   // vertical bounds
   //self.fDrawCandles_max:=info.fDrawCandles_max;
   //self.fDrawCandles_min:=info.fDrawCandles_min;

   if    info.chartType=0 then
    PaintArray(arr_ii[ info.chart_index ].arr_painted,
      length(arr_ii[ info.chart_index ].arr_painted),   info.color     ,info.width, info)
   else
   begin
    Canvas.Brush.Style:=bsSolid;
    Canvas.Brush.Color:=info.color;
    Canvas.pen.Color:=info.color;
    Canvas.pen.Width:=info.width;
    DrawCandles_hyst(arr_ii[ info.chart_index ].arr_painted, info);  //@@drw


   end;
   restoreVerticalBounds;
end;


procedure TImageInfo3.saveVerticalBounds;
begin
 //self.mainChartInfo.fDrawCandles_max:=self.DrawCandles_max;
 //self.mainChartInfo.fDrawCandles_min:=self.DrawCandles_min;
end;


procedure TImageInfo3.restoreVerticalBounds;
begin
 //self.fDrawCandles_max:= self.mainChartInfo.fDrawCandles_max;
 //self.fDrawCandles_min:= self.mainChartInfo.fDrawCandles_min;
end;

procedure TImageInfo3.setMainChartType(val:Integer);
begin
  mainChartInfo.chartType:=val;
end;

procedure TImageInfo3.DrawWithExtras(const arr_ii:array of TImageInfo3 );
var i,k:Integer; //iis:TImageInfo3;
  lst_pnt:TStringList;           p:PChartInfo;
     //array of TChartInfo;
begin


 //  seve settings coz we will change them to Draw extra charts
 lst_pnt:=TStringList.Create;

 //self.mainChartInfo.fDrawCandles_max:=self.fDrawCandles_max;
 //self.mainChartInfo.fDrawCandles_min:=self.fDrawCandles_min;
 self.mainChartInfo.chart_index:=self.chart_index;

 lst_pnt.AddObject(formatfloat('00',mainChartInfo.order),  tobject(@( mainChartInfo )));

 for i:=0 to length(self.extras)-1 do
  begin

   //
   //iis:= arr_ii[extras[i].chart_index];
   //lst_pnt.AddObject('',  tobject(@(self.extras[i])));

   //self.extras[i].fDrawCandles_max:=arr_ii[extras[i].chart_index].  fDrawCandles_max;
   //self.extras[i].fDrawCandles_min:=arr_ii[extras[i].chart_index].  fDrawCandles_min;

   lst_pnt.AddObject(formatfloat('00',extras[i].order),  tobject(@( extras[i] )));
   //self.extras[i].fDrawCandles_min;
   // reset bounds on self

  // self.fDrawCandles_max:=self.extras[i].fDrawCandles_max;
  // self.fDrawCandles_min:=self.extras[i].fDrawCandles_min;

   for k:=0 to  length(  arr_ii[ self.extras[i].chart_index ].arr_painted )-1 do
     begin

      //arr_ii[ self.extras[i].chart_index ].arr_painted[k]:=0.25+0.1*sin(k/57);

     end;


   //if arr_ii[ self.extras[i].chart_index ].mainChartType =0 then
       {
   if    self.extras[i].chartType=0 then
   PaintArray(arr_ii[ self.extras[i].chart_index ].arr_painted,
   length(arr_ii[ self.extras[i].chart_index ].arr_painted),   self.extras[i].color     ,2)  else
   begin
   Canvas.Brush.Style:=bsSolid;
   Canvas.Brush.Color:=self.extras[i].color;

   DrawCandles_hyst(arr_ii[ self.extras[i].chart_index ].arr_painted);  //@@drw


   end;   }
  end;



 lst_pnt.Sort();

 for i:=0 to lst_pnt.Count-1 do
   begin
    //
    p:= pchartInfo( lst_pnt. Objects[i] );
    DrawLineOrHyst( p^, arr_ii );

   end;



end;


function TImageInfo3.findExtra(arr_ii_index:Integer):Integer;
var i:Integer;
begin
 for i:=0 to length(extras)-1 do
  begin
   if extras[i]. chart_index=  arr_ii_index then
    begin
    result:=i;
    exit;
    end;
  end;
 result:=-1;
end;


class function TImageInfo3.findExtra_onArray(arr_ii_index:Integer; const a_extras: array of TChartInfo):Integer;
var i:Integer;
begin
 for i:=0 to length(a_extras)-1 do
  begin
   if a_extras[i]. chart_index=  arr_ii_index then
    begin
    result:=i;
    exit;
    end;
  end;
 result:=-1;
end;


procedure TImageInfo3.setSelectedCurve(index:Integer);
begin
 fSelectedCurve:=index;
end;




function TImageInfo3.get_chart_info(ntx_in_self:Integer):TChartInfo;

begin
 if  ntx_in_self=0 then result:=mainChartInfo
 else result:= extras[ntx_in_self-1] ;

end;

initialization

finalization

end.

