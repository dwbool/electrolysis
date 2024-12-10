unit frm_chart_prop;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, CheckLst,
  ExtCtrls, Spin, imginf;

type



  TfmChartProp = class(TForm)
    Button1: TButton;
    btApply: TButton;
    cbChartType: TComboBox;
    clbCharts: TCheckListBox;
    ColorDialog: TColorDialog;
    Label6: TLabel;
    seOrder: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    shColor: TShape;
    seWidth: TSpinEdit;
    procedure btApplyClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbChartTypeChange(Sender: TObject);
    procedure clbChartsClick(Sender: TObject);
    procedure clbChartsClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure seOrderChange(Sender: TObject);
    procedure seWidthChange(Sender: TObject);
    procedure shColorChangeBounds(Sender: TObject);
    procedure shColorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    fii:TImageInfo3;
  public


    procedure set_ii(aii:TImageInfo3);
    property ii:TImageInfo3 read fii write set_ii;

    function getOnlyCheckedExtraCount:Integer;
    property OnlyCheckedExtraCount :Integer read    getOnlyCheckedExtraCount ;

    function getOnlyCheckedExtraItem(index:Integer) :  Integer;
    property   OnlyCheckedExtraItem[index:Integer]:integer read getOnlyCheckedExtraItem;

    function getMainChartSelected:Boolean;
    property  MainChartSelected:Boolean read getMainChartSelected;

  end;

var
  fmChartProp: TfmChartProp;

implementation

uses frm_chart;



{$R *.lfm}



procedure TfmChartProp.set_ii(aii:TImageInfo3);
var i:Integer;
begin
 fii:=aii;

 clbCharts.CheckAll(cbUnchecked);;

 cbChartType.ItemIndex:=ii.mainChartType;

 clbCharts.Checked[ii.chart_index]:=true;

 for i:= 0 to length(ii.extras)-1 do
    begin
      self.clbCharts.Checked[  ii.extras[i].chart_index ] :=true;

    end;

 clbCharts.ItemIndex:=ii.chart_index;

 clbChartsClick(nil);
end;

function TfmChartProp.getOnlyCheckedExtraItem(index:Integer) :  Integer;
var i,nAdd:Integer;
begin
 nAdd:=0;
 for i:=0 to clbCharts.Items.Count-1 do
   begin
    //
    if i=  ii.chart_index then continue;
    if clbcharts.Checked[i] then
     begin
      //
      if index=nAdd then
        begin
         result:=i;
         exit;
        end;
      inc(nadd);

     end;


   end;
 result:=nadd;
end;

procedure TfmChartProp.cbChartTypeChange(Sender: TObject);
var ind_found:Integer;
begin
 if getMainChartSelected then
  ii.mainChartType:=  cbChartType.ItemIndex
 else
   begin

    ind_found:=    ii.findExtra( clbCharts.ItemIndex );
    if ind_found<>-1 then
     begin
      ii.extras[ind_found].chartType:=   cbChartType.ItemIndex;


     end;

   end;
 btApplyClick(Sender);
end;

procedure TfmChartProp.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TfmChartProp.btApplyClick(Sender: TObject);
begin
  fmchart.CursorMove2(nil,[],0,0,0,0) ;
end;

procedure TfmChartProp.clbChartsClick(Sender: TObject);
var ind:Integer;
begin

 if clbCharts.ItemIndex= ii.chart_index then
   begin

    cbChartType.ItemIndex:=ii.mainChartType;
    shcolor.Brush.Color:=ii.mainChartInfo.color;
    seWidth.Value:=ii.mainChartInfo.width;
    seOrder.Itemindex:=ii.mainChartInfo.order;
   end
 else
   begin

    if clbCharts.Checked[ clbCharts.ItemIndex ] then
     begin

      ind:= ii.findExtra(clbCharts.ItemIndex);
      if ind<>-1 then
       begin

        cbChartType.ItemIndex:=ii.extras[ind].ChartType;
        shcolor.Brush.Color:=ii.extras[ind].color;
        seWidth.Value:=ii.extras[ind].width;
        seOrder.ItemIndex:=ii.extras[ind].order;

       end
      else
       begin

        cbChartType.ItemIndex:=-1;
       end;


     end
    else
     begin

       cbChartType.ItemIndex:=-1;
       shcolor.Brush.Color:=clWhite;
       seWidth.Value:=0;
       seOrder.Itemindex:=-1;
     end;
   end;
    btApplyClick(Sender);
end;


function TfmChartProp.getOnlyCheckedExtraCount:Integer;
var i,nAdd:Integer;
begin
 nAdd:=0;
 for i:=0 to clbCharts.Items.Count-1 do
   begin
    //
    if i=  ii.chart_index then continue;
    if clbcharts.Checked[i] then
     begin
      //
      inc(nadd);

     end;


   end;
 result:=nadd;
end;



procedure TfmChartProp.clbChartsClickCheck(Sender: TObject);
var i,nAdd:Integer;  extras_copy:array of TChartInfo;  cix: TChartInfo; ind_found:Integer;
begin
  if not   clbCharts.Checked[ii.chart_index] then
   begin
    clbCharts.Checked[ii.chart_index]:=true;
    exit;
   end;

  if clbcharts.Checked[clbcharts.ItemIndex] and (OnlyCheckedExtraCount=4 )then
   begin
    clbcharts.Checked[clbcharts.ItemIndex]:=false;
    exit;
   end;


  SetLength(extras_copy, length(ii.extras));
  for i:= 0 to length( ii.extras  )-1 do
    begin
     extras_copy [i]:=ii.extras[i];
    end;

  SetLength(ii.extras, self.OnlyCheckedExtraCount );
  ii.OVcount:=Length(ii.extras)+1;

  for i:= 0 to self.OnlyCheckedExtraCount-1 do
    begin
     ii.extras[i].chart_index:=self.OnlyCheckedExtraItem[i] ;

     ind_found:=ii.findExtra_onArray(ii.extras[i].chart_index,  extras_copy);
     if ind_found<>-1 then
      begin

       ii.extras[i]:=  extras_copy[ind_found];

      end
     else
      begin

       ii.extras[i].chartType:=0;

       ii.extras[i].width:=DEFAULT_CHART_LINE_WIDTH;
       ii.extras[i].order:=self.OnlyCheckedExtraCount-0 ;

       ii.extras[i].color:=getChartDefaultColor(ii.extras[i].chart_index) ;

       ii.OVnames[i+1]:=clbCharts.Items [ii.extras[i].chart_index] ;
       ii.OVcount:=Length(ii.extras)+1;
      end;
     ii.extras[i].chart_index:=self.OnlyCheckedExtraItem[i] ;


    end;

  clbChartsClick(nil);


    btApplyClick(Sender);
end;

procedure TfmChartProp.FormCreate(Sender: TObject);
begin

 clbCharts.Clear;
 clbCharts.Items.AddStrings  ( fmChart.clbCharts.Items );


end;



procedure TfmChartProp.seOrderChange(Sender: TObject);
var ind_found:Integer;    info:PChartInfo;
begin
 info:=nil;
 if getMainChartSelected then
  begin
  info:= @( ii.mainChartInfo);
  end
 else
   begin

    ind_found:=    ii.findExtra( clbCharts.ItemIndex );
    if ind_found<>-1 then
     begin
      info:= @ (ii.extras[ind_found]);
     end;
   end;
 if info<>nil then
  begin
     info^.order:=seOrder.ItemIndex;
     clbChartsClick(nil);
  end;
end;



procedure TfmChartProp.seWidthChange(Sender: TObject);
var ind_found:Integer;    info:PChartInfo;
begin
 info:=nil;
 if getMainChartSelected then
  begin

  info:= @( ii.mainChartInfo);
  end
 else
   begin

    ind_found:=    ii.findExtra( clbCharts.ItemIndex );
    if ind_found<>-1 then
     begin

      info:= @ (ii.extras[ind_found]);

     end;

   end;
 if info<>nil then
  begin

     info^.width:=seWidth.Value;

     clbChartsClick(nil);

  end;
end;



procedure TfmChartProp.shColorChangeBounds(Sender: TObject);
begin

end;

procedure TfmChartProp.shColorMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var ind_found:Integer;    info:PChartInfo;
begin
 info:=nil;
 if getMainChartSelected then
  begin

  info:= @( ii.mainChartInfo);
  end
 else
   begin

    ind_found:=    ii.findExtra( clbCharts.ItemIndex );
    if ind_found<>-1 then
     begin

      info:= @ (ii.extras[ind_found]);

     end;

   end;
 if info<>nil then
  begin
   if ColorDialog.Execute then
    begin
     info^.color:=ColorDialog .Color ;
     clbChartsClick(nil);
    end;
  end;
end;


function TfmChartProp.getMainChartSelected:Boolean;
begin
  result:= clbCharts.ItemIndex= ii.chart_index;
end;

end.

