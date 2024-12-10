unit frm_chart;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  CheckLst, DateTimePicker, dateutils, hydr_files, hydr_utils, imginf, ain_def,
  frm_graph,menus ;

type

  { TfmChart }

  TfmChart = class(TForm)
    btStep3: TButton;
    Button1: TButton;
    Button10: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    btChartsPrepare: TButton;
    btStep1: TButton;
    btStep2: TButton;
    Button6: TButton;
    btStep1_7: TButton;
    btApply: TButton;
    btClose: TButton;
    Button8: TButton;
    Button9: TButton;
    chCur: TCheckBox;
    clbCharts: TCheckListBox;
    ColorDialog: TColorDialog;
    dpFromTime: TDateTimePicker;
    dpToTime: TDateTimePicker;
    dpFrom: TDateTimePicker;
    dpTo: TDateTimePicker;
    im: TImage;
    im1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    m: TMemo;
    shColor: TShape;
    Timer1: TTimer;
    procedure btApplyClick(Sender: TObject);
    procedure btChartsPrepareClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btStep1_5click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure btStep1Click(Sender: TObject);
    procedure btStep2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure btStep1_7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure clbChartsClick(Sender: TObject);
    procedure clbChartsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure imMouseLeave(Sender: TObject);
    procedure shColorChangeBounds(Sender: TObject);
    procedure shColorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    dt_update_charts:TDateTime;
    ii:timageinfo3;
    done:boolean;

    procedure CursorMove2(
            Sender: TObject;      //
            Shift: TShiftState;   //..
            X,Y: Integer;
            CandleIndex:Integer;

            CursorPrice:Double
            ) ;



    procedure CursorUp(
                Sender: TObject;      //
                Shift: TShiftState;   //..
                X,Y: Integer;
                CandleIndex:Integer;

                CursorPrice:Double
                ) ;


    procedure SelectCurveItemClick(Sender:TObject);
  end;

var
  fmChart: TfmChart;
  ss_out:Tstringlist;

  arr_ii:array [0..AIN_COUNT-1] of TImageInfo3;
  arr_im:array [0..AIN_COUNT-1] of TImage;
  chart_parent:    TWincontrol;


  function getChartDefaultColor(chartIndex:Integer):TColor;

  function get_val4(chartIndex_from0:Integer):Double;
  function get_val20(chartIndex_from0:Integer):Double;
  function get_val12(chartIndex_from0:Integer):Double;

implementation

uses unit1;

{$R *.lfm}

{ TfmChart }

function get_val4(chartIndex_from0:Integer):Double;
begin
result:= AIN_DEFS[ chartIndex_from0+1].val4;
end;

function get_val20(chartIndex_from0:Integer):Double;
begin
  result:= AIN_DEFS[ chartIndex_from0+1].val20;
end;

function get_val12(chartIndex_from0:Integer):Double;
begin
  result:=  get_val4(chartIndex_from0) + ( get_val20(chartIndex_from0) - get_val4(chartIndex_from0) ) / 2;
end;


function getChartDefaultColor(chartIndex:Integer):TColor;
begin
  //
  result:= ini_chart.ReadInteger(inttostr(chartIndex+1), 'color', clYellow );
end;


procedure TfmChart.Button1Click(Sender: TObject);
var ss :Tstringlist;  dt_from,dt_to:TDatetime;  k,i:Integer;     parc: tArchRec;       fs:array[0..AIN_COUNT] of double;
  s:string;    cr: pChartRec;
  a:array of double; adt:array of tdatetime;   ncnd:Integer;   nodat:Boolean; x1,y1:integer;
begin
  m.Lines.Clear;
  ii.whole_interval_sec:=1440*60;
  ii.CandleCount:=1440;
  //

  ii.title:='Давление H2';
  ss:=Tstringlist.Create;

  DisposeOfChartStructs(ss_out);
  ss_out.Clear;


  rd_arch_files_from_to( ss, dpFrom.Date, dpTo.Date);
  m.Lines.AddStrings(ss);


  dt_from:=  dateof(dpFrom.Date)+timeof(dpfromTime.Time) ;
  dt_to:=   dateof(dpTo.Date)+timeof(dptoTime.Time);
  read_recs_from_to(ss, dt_from, dt_to,  ss_out );

  m.Lines.AddStrings( ss_out );

  nodat:=false;
  for i:=0 to ss_out.Count-1 do
   begin
     arch_str_parse(ss_out[i], i, @parc);

     ains_str_to_floats(parc.s_ains, fs);

     s:=datetimetostr(parc.dt)+'> ';
     for k:=0 to AIN_COUNT-1 do
      begin
        s:= s+floatToStr( fs[k] )+', ';

      end;

     m.Lines.Add(s);
     new(cr);
     fillchar(cr^,sizeof(cr^),0);
     //cr^.a
     Move(fs,cr^.a,sizeof(cr^.a));
     cr^.dt:=parc.dt;
     ss_out.Objects[i] := TObject(cr) ;
   end;

  //
  ncnd:=1440;
  ii.CandleCount:=ncnd;
  ii.whole_interval_sec:=1440*60;

  setlength(a,ncnd);
  setlength(adt,ncnd);
  extract_chart_channel(ss_out,0,60,dt_to,ncnd, a, adt);

  m.Lines.Clear;

  ii.ClearBitmap;

  //
  ii.vert_line_interval_sec:=3600;
  ii.PaintPhysValChart(a);

  ii.Paint;

  ii.BmpToArray;

  m.Lines.Clear;
  m.Lines.Add(inttostr(ii.CandlesPratum));

  ss.Free;
end;

procedure TfmChart.btChartsPrepareClick(Sender: TObject);
var i:Integer; ain:TAinDef;  iik:TImageInfo3;       imk:TImage;
  a:array of double;
begin


  setlength(a,2);
  a[0]:=10;
  a[1]:=20;

  imk:=form1.im1;
  iik:=TImageInfo3.Create(imk, 60,60,  1440, nil,nil);

  iik.Canvas.Font.Color:=clLime;
  iik.Canvas.TextOut(40,40,'auto');
  iik.Canvas.Pen.Color:=clRed;
  iik.Canvas.Pen.Width:=3;
  iik.Canvas.moveTo(00,00);
  iik.Canvas.LineTo(100,100);
  iik.Paint;





end;

procedure TfmChart.btCloseClick(Sender: TObject);
begin

  close;
end;

procedure TfmChart.btApplyClick(Sender: TObject);
begin
  btStep1.Click;
end;



procedure TfmChart.Button10Click(Sender: TObject);
begin
   m.Lines.Add( datetimetostr( strtodate_cust('27')));
end;

procedure TfmChart.Button2Click(Sender: TObject);
var sains,s:string;  fs:array[0..AIN_COUNT] of double;  i:integer;
begin

  s:='';
  sains:='00,8F,00,00,00,06,01,03,00,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,03,E8,';
  ains_str_to_floats( sains, fs );
  for i:=0 to  AIN_COUNT -1 do
   begin

     s:=s+ floatToStr(fs[i]) + ', ';

   end;

  m.Lines.Add(s);
end;


procedure TfmChart.Button3Click(Sender: TObject);
var i,x,xt:Integer; a:array [0..3600] of double;  dt:TDateTime;  s:String;
begin

  for i:=0 to 3600 do
   begin

     a[i]:=500+ 500*sin(i/57);

   end;
  ii.ClearBitmap;


  ii.Canvas.Pen.Color:=clgreen;
  for i:=0 to ii.whole_interval_sec-1 do
   begin
     dt:=incSecond(ii.dt_present,-i);
     if ii.vert_line_to_display(dt) then
      begin
       //
       ii.DrawLineVertFull_DT(dt);
       x:=ii.dt_X(dt);
       s:=FormatDateTime('hh:nn',dt)   ;

       xt:=  x-ii.Canvas.TextWidth(s) div 2 ;
       if xt<0 then xt:=0;
       ii.Canvas.TextOut(xt,ii.height-20,s);

      end;


   end;

  s:= FormatDateTime('dd.MM.YYYY  hh:nn',ii.dt_present)        ;

  ii.Canvas.TextOut(ii.CandleX(0)-ii.Canvas.TextWidth(s) +20 , 0, s);

  ii.Canvas.TextOut(10 , 0, 'Давление H2');
  ii.BmpToArray;
  ii.Paint;

end;


procedure TfmChart.Button4Click(Sender: TObject);
begin

  ii.BmpToArray;
  ii.ArrayToBmp;

end;

procedure TfmChart.Button5Click(Sender: TObject);
begin
  ii.ClearBitmap;

  ii.ArrayToBmp;
  ii.Paint;
end;


procedure TfmChart.btStep1Click(Sender: TObject);
var i,COUNT, chart_height, visible_index :Integer; is_visible:Boolean;
begin
  COUNT:=0;
  clbCharts.Clear;
  for i:=0 to AIN_COUNT-1 do
   begin
     clbCharts.AddItem( AIN_DEFS[i+1].name ,nil );
     clbCharts.Checked[i]:=ini_chart.ReadBool(inttostr(i+1),'visible',true)  ;
     if ini_chart.ReadBool(inttostr(i+1),'visible',true) then
      begin
       //
       inc(count);


      end;
   end;

  chart_height:=   trunc((chart_parent.Height-5) / COUNT )-2;

   visible_index:=0;

  for i:=0 to AIN_COUNT-1 do
   begin
     //
     is_visible:=  ini_chart.ReadBool(inttostr(i+1),'visible',true) ;
     if arr_im[i]<>nil then
       begin
        FreeAndNil(arr_im[i]);
       end;
     if arr_im[i]=nil then
      arr_im[i]:= TImage.Create(self);
     arr_im[i].Parent:= chart_parent;
     arr_im[i].PopupMenu:=form1.popm;
     arr_im[i].Left:=0;


     arr_im[i].Top:= trunc((chart_parent.Height-5) / COUNT * visible_index);
     arr_im[i].Height:= chart_height;

     arr_im[i].Width:=chart_parent.Width;
     arr_im[i].Hint:=AIN_DEFS_[i+1].name+', '+AIN_DEFS[i+1].units;
     arr_im[i].ShowHint:=true;
     //
     if arr_ii[i]<>nil then
       begin
        FreeAndNil(arr_ii[i]);
       end;
     if arr_ii[i]=nil then
      arr_ii[i]:= TImageInfo3.Create(arr_im[i], 50, 60, 1440, nil,nil);

     arr_ii[i].OVnames[0]:= AIN_DEFS[i+1].name ;
     arr_ii[i].OVcount:=1;
     arr_ii[i].popup:=form1.popm;

     arr_ii[i].ClearBitmap;


     arr_ii[i].whole_interval_sec:=1440*60;

     arr_ii[i].Canvas.Pen.Color:=clLime;

     arr_ii[i].Canvas.Brush.Style:=bsClear;
     arr_ii[i].Canvas.Font.Height:=9;
     arr_ii[i].Canvas.Font.Color:=clLime;




     setlength(arr_ii[i].horz_grid,3);
     arr_ii[i].horz_grid[0]:=get_val12(i);
     arr_ii[i].horz_grid[1]:=get_val4(i);
     arr_ii[i].horz_grid[2]:=get_val20(i);
     arr_ii[i].draw_horz_grid;
     arr_ii[i].dt_present:=now;
     arr_ii[i].vert_line_interval_sec:=3600;

     arr_ii[i].OnCursorMove:=@ CursorMove2;
     arr_ii[i].OnCursorUp:=@ CursorUp;

     arr_ii[i].Paint;
     arr_ii[i].BmpToArray;

     arr_ii[i].m.Visible:=  is_visible;

     arr_ii[i].chart_index:=i;

     arr_ii[i].mainChartInfo.color:=ini_chart.ReadInteger( inttostr( i+1), 'color', clGray );  ;
     arr_ii[i].mainChartInfo.width:=DEFAULT_CHART_LINE_WIDTH;
     arr_ii[i].mainChartInfo.order:=0;

     arr_im[i].Tag:= i;

     if is_visible then inc(visible_index);
   end;

end;





procedure TfmChart.btStep1_5click(Sender: TObject);
var p:tpoint; dt1,dt2, dt_from, dt_to:tdateTime;  ss:Tstringlist ;
  k,i:Integer;     parc: tArchRec;       fs:array[0..AIN_COUNT] of double;
  s:string;    cr: pChartRec;

  ncnd:Integer;   nodat:Boolean; x1,y1:integer;
begin

  dt1:= incsecond(now,-1440*60   );
  dt2:=now;



  dt_from:=dt1;
  dt_to:=  dt2;


  ncnd:=1440;

  for i:=0 to AIN_COUNT-1 do
   begin
    if arr_ii[i]=nil then exit;
    arr_ii[i].dt_present:=now;


    setLength( arr_ii[i].arr_painted,  ncnd );
    setLength( arr_ii[i].arr_painted_dt,  ncnd );


    extract_chart_channel_simple( i,60,dt_to,ncnd, arr_ii[i].arr_painted , arr_ii[i].arr_painted_dt );



   end;


  done:=true;
end;




procedure TfmChart.btStep2Click(Sender: TObject);
var p:tpoint; dt1,dt2, dt_from, dt_to:tdateTime;  ss:Tstringlist ;
  k,i:Integer;     parc: tArchRec;       fs:array[0..AIN_COUNT] of double;
  s:string;    cr: pChartRec;
  a:array of double; adt:array of tdatetime;   ncnd:Integer;   nodat:Boolean; x1,y1:integer;
begin

    dt1:= incsecond(now,-1440*60   );
    dt2:=now;
    dpFrom.Date:=dateof(dt1);
    dpFromTime.Time:=timeof(dt1);

    dpto.Date:=dateof(dt2);
    dpToTime.Time:=timeof(dt2);

    DisposeOfChartStructs(ss_out);
  ss_out.Clear;


  ss:=Tstringlist.Create;
  rd_arch_files_from_to( ss, dpFrom.Date, dpTo.Date);
  m.Lines.AddStrings(ss);


  dt_from:=  dateof(dpFrom.Date)+timeof(dpfromTime.Time) ;
  dt_to:=   dateof(dpTo.Date)+timeof(dptoTime.Time);


  read_recs_from_to(ss, dt_from, dt_to,  ss_out );

  ncnd:=1440;
  setlength(a,ncnd);
  setlength(adt,ncnd);
  for i:=0 to AIN_COUNT-1 do
   begin
    arr_ii[i].dt_present:=now;


    arr_ii[i].ArrayToBmp;
    extract_chart_channel(ss_out,i,60,dt_to,ncnd, a, adt);
    arr_ii[i].PaintPhysValChart(a);
    arr_ii[i].Paint;

   end;
end;

procedure TfmChart.Button6Click(Sender: TObject);
var a,b:array of double;          p:pointer; i:Integer;
begin
  setlength(a,100);
  setlength(b,100);

  for i:=0 to 99 do
   a[i]:= i;


  b:=a;
  a[0]:=2345;

  for i:=0 to 99 do
   m.Lines.Add( floattostr(b[i]));

end;



procedure TfmChart.btStep1_7Click(Sender: TObject);
var p:tpoint; dt1,dt2, dt_from, dt_to:tdateTime;  ss:Tstringlist ;
  k,i,L:Integer;     parc: tArchRec;       fs:array[0..AIN_COUNT] of double;
  s:string;    cr: pChartRec;
  a:array of double; adt:array of tdatetime;   ncnd:Integer;   nodat:Boolean; x1,y1:integer;
begin
  if fmChart=nil then exit;

  for i:=0 to AIN_COUNT-1 do
   begin
    arr_ii[i].dt_present:=now;

    arr_ii[i].ArrayToBmp;

    L:=  length(arr_ii[i].arr_painted);

    arr_ii[i].draw_vert_grid;



    arr_ii[i].Paint;

   end;
end;



procedure TfmChart.Button8Click(Sender: TObject);
begin
  m.lines.add(booltostr(  ii.vert_line_to_display2(dpFromTime.Time)));
end;

procedure TfmChart.Button9Click(Sender: TObject);
var ss:TStringlist;   i:Integer;
begin

  ss:=TStringlist.Create;
  read_arch_files(ss);

  for i:=0 to ss.Count-1 do
   begin
    m.Lines.Add(ss[i]+' : '+PArchRec(ss.Objects[i])^.fname );
   end;


end;


procedure TfmChart.clbChartsClick(Sender: TObject);
var i:Integer;   ch:boolean;
begin


  for i:=0 to AIN_COUNT-1 do
   begin
       ch:= clbCharts.Checked[i];
       ini_chart.writeBool(inttostr(i+1),'visible',ch) ;

   end;

  shColor.Brush.Color:=ini_chart.ReadInteger( inttostr(clbCharts.ItemIndex+1), 'color', clWhite );
end;

procedure TfmChart.clbChartsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TfmChart.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

  btApplyClick(nil);
end;


procedure TfmChart.FormCreate(Sender: TObject);
begin
  chart_parent:= form1.panChart;


  ss_out:=Tstringlist.Create;
  ii:=timageinfo3.create( im,70   ,60,1000,nil,nil);

  ii.CandleCount:=3600;
  ii.Canvas.Pen.Color:=clGreen;
  ii.DrawLine(0,0,1000,1000);
  setlength(ii.horz_grid,3);
  ii.horz_grid[0]:=0;
  ii.horz_grid[1]:=500;
  ii.horz_grid[2]:=1000;
  ii.draw_horz_grid;
  ii.Paint;

  ii.BmpToArray;

  ii.dt_present:=encodeDate(2020,1,1)+ encodetime(0,0,0,0);

  ii.whole_interval_sec:=3600;
  ii.vert_line_interval_sec:=600;



  fillchar(arr_im,sizeof(arr_im),0);
  fillchar(arr_ii,sizeof(arr_ii),0);


  btStep1Click(nil);
end;

procedure TfmChart.imMouseLeave(Sender: TObject);
begin
  ii.ArrayToBmp;
end;

procedure TfmChart.shColorChangeBounds(Sender: TObject);
begin

end;

procedure TfmChart.shColorMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if clbCharts.ItemIndex=-1 then exit;
  if ColorDialog.Execute then
    begin

     ini_chart.WriteInteger( inttostr(clbCharts.ItemIndex+1) ,'color'  ,integer(ColorDialog.Color) );
     clbChartsClick(nil);


    end;
end;

procedure TfmChart.Timer1Timer(Sender: TObject);
var p:tpoint; dt1,dt2:tdateTime;
begin
  p:=
   mouse.CursorPos;
  p:=screentoclient(p);
  if not((p.X>im.Left)and (p.X<im.Left+im.Width)
   and   (p.y>im.top)and (p.y<im.top+im.Height)) then
   begin
    ii.ArrayToBmp;
    ii.Paint;

   end;

  if chcur.Checked then
   begin
    //
    dt1:= incsecond(now,-ii.whole_interval_sec);
    dt2:=now;
    dpFrom.Date:=dateof(dt1);
    dpFromTime.Time:=timeof(dt1);

    dpto.Date:=dateof(dt2);
    dpToTime.Time:=timeof(dt2);

    button1.Click;

   end;

end;





procedure TfmChart.CursorMove2(
            Sender: TObject;
            Shift: TShiftState;
            X,Y: Integer;
            CandleIndex:Integer;

            CursorPrice:Double
            ) ;
var v:double; ntx,i,k,tw, ytxt:Integer;   dt:TDatetime;   s:String;
  iis :TImageInfo3;    info_sel:TChartInfo;   rct:TRect;
begin

  dt_update_charts:=now;

  label4.Caption:=inttostr(arr_ii[0].SelectedCurve_in_self);

  for i:=0 to length(arr_ii)-1 do
  begin
  iis:=   arr_ii[i];




  iis.ArrayToBmp;
  iis.draw_vert_grid;


  iis.Canvas.Brush.Style:=bsClear;
  iis.Canvas.Font.Name:='Arial';
  iis.Canvas.Font.Height:=trunc( iis.Height*0.05);
  if  iis.Canvas.Font.Height<6 then iis.Canvas.Font.Height:=6;
  iis.Canvas.Font.Color:=iis.mainChartInfo.color;
  if iis.SelectedCurve_in_self=0 then iis.Canvas.Font.Style:=[fsBold,fsUnderline] else iis.Canvas.Font.Style:=[] ;

  iis.Canvas.TextOut(10,1, AIN_DEFS_SHORT[i+1].name  );
  s:=AIN_DEFS_SHORT[i+1].name+'___';

  for k:=0 to length(iis.extras)-1 do
   begin
    tw:=    iis.Canvas.TextWidth(s) ;
    if iis.SelectedCurve_in_self=k+1 then iis.Canvas.Font.Style:=[fsBold,fsUnderline] else iis.Canvas.Font.Style:=[] ;
    iis.Canvas.Font.Color:=iis.extras[k].color;
    iis.Canvas.TextOut(10+tw,1, AIN_DEFS_SHORT[ iis.extras[k].chart_index +1].name  );
    s:=s+AIN_DEFS_SHORT[i+1].name+'___';
   end;
  iis.DrawWithExtras(arr_ii);



  iis.Canvas.Pen.Width:=1;
  iis.Canvas.Pen.Color:=clYellow;
  iis.DrawLineVertFull(candleIndex);

  if iis.arr_painted<>nil then;
  if (CandleIndex<length(iis.arr_painted)) and (x<=ii.CandlesPratum) then
   begin

   ntx:= iis.SelectedCurve_in_self;


   if ntx=0 then
    begin
    if iis.get_chart_info(ntx).chartType=0   then
     v:=  arr_ii[ iis.chart_index ].arr_painted[CandleIndex]
    else
     begin
     v:= get_max_in_group(arr_ii[ iis.chart_index ].arr_painted, HYST_GROUP, CandleIndex );
     end;
    end
   else
    begin

    if iis.get_chart_info(ntx).chartType=0   then
     v:=  arr_ii[  iis.extras[ntx-1].chart_index  ].arr_painted[CandleIndex]
    else
     begin
     v:= get_max_in_group(  arr_ii[  iis.extras[ntx-1].chart_index  ].arr_painted , HYST_GROUP, CandleIndex );
     end;

    end;


   iis.Canvas.font.Style:=[];
   iis.Canvas.font.Color:=clYellow;
   iis.Canvas.Brush.Color:=clNone;
   iis.Canvas.Brush.style:=bsClear;
   iis.Canvas.font.Height:= trunc(iis.height*0.05);


   s:=   formatfloat('0.0',v);
    ytxt:= iis.CandleY(v, iis.get_chart_info( iis.SelectedCurve_in_self  ))-iis.Canvas.TextHeight('0') div 2;
   iis.Canvas.TextOut(  iis.CandleX(0)+5, ytxt, s);

   iis.DrawLine(0,v , iis.CandleCount, v);

   dt:=iis.candle_dt( CandleIndex);
   s:= FormatDateTime('dd.MM.YYYY hh:nn', dt);

   iis.Canvas.font.Color:=clYellow;


   iis.Canvas.Brush.Color:=clYellow;
   iis.Canvas.Ellipse( x-4-3, iis.CandleY(v, iis.get_chart_info( iis.SelectedCurve_in_self  ))-4, x+4-3,
    iis.CandleY(v, iis.get_chart_info( iis.SelectedCurve_in_self  ))+4 );
   end;

  iis.Canvas.Brush.Color:=clNone;
   iis.Canvas.Brush.style:=bsClear;

  if iis.arr_painted<>nil then;

   begin
   if iis=sender then
    begin
    iis.Canvas.Pen.Color:=clYellow;
    iis.DrawLine(0,CursorPrice , iis.CandleCount, CursorPrice);



    ytxt:= y-10;
    iis.Canvas.font.Height:= trunc(iis.height*0.05);
    if iis.Canvas.font.Height<10 then iis.Canvas.font.Height:=10;
    iis.Canvas.font.Style:=[];
    iis.Canvas.font.Color:=clYellow;
    iis.Canvas.TextOut(  iis.CandleX(0)+5, ytxt, formatfloat('0.0',CursorPrice));

    rct:=Rect( x-iis.Canvas.TextWidth(s) div 2,
               iis.height-  trunc(iis.height*(1-HEIGHT_DRAW_PART)/2) +2,
               x+iis.Canvas.TextWidth(s) div 2,
               iis.height-  trunc(iis.height*(1-HEIGHT_DRAW_PART)/2) + iis.Canvas.Textheight(s) +2 );
    iis.Canvas.Brush.Color:=clBlack;
    iis.Canvas.Brush.Style:=bsSolid;
    iis.Canvas.FillRect(rct);

    dt:=iis.candle_dt( CandleIndex);
    s:= FormatDateTime('dd.MM.YYYY hh:nn', dt);
    iis.Canvas.TextOut( x-iis.Canvas.TextWidth(s) div 2, iis.height-  trunc(iis.height*(1-HEIGHT_DRAW_PART)/2) +1, s);
    end;
   end;




  iis.Paint;

  label1.Caption:=inttostr(x);
  end;

end;

procedure TfmChart.CursorUp(
            Sender: TObject;
            Shift: TShiftState;
            X,Y: Integer;
            CandleIndex:Integer;

            CursorPrice:Double
            ) ;
var iip:TImageinfo3;
begin
   iip:=TImageinfo3(sender);
end;


procedure TfmChart.SelectCurveItemClick(Sender:TObject);
var mi:TMenuItem absolute sender;   iiClick:TImageInfo3;
  miPar:TMenuItem;

 imClick:TImage;   arr_ii_index :Integer;
 s:String;
begin
  imClick:= TImage(form1.popm.PopupComponent);

  arr_ii_index:= imClick.Tag;
  iiClick:= arr_ii[arr_ii_index];


  s:= iiClick.OVnames[0];
  label3.Caption:=s;

  iiClick.SelectedCurve_in_self:=  mi.tag;
end;



end.

