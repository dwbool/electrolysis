unit hydr_utils;

{$mode ObjFPC}{$H+}

interface


uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Sockets, LCLIntf, ComCtrls, Buttons, Menus,
  frm_settings, dateUtils,
 {$IFDEF UNIX}
  unix,
  {$ENDIF}

  inifiles, Types;

const
  AIN_COUNT = 21;
  DIN_COUNT= 13;

  NO_DATA=-1e6;

  const factors:array [1..AIN_COUNT] of double =
  (
    0.01  ,
    0.01  ,
    0.1  ,
    1  ,
    1  ,
    1  ,
    1  ,
    1  ,
    1  ,
    1  ,
    1  ,
    1  ,
    1  ,
    1  ,
    0.1  ,
    0.1  ,
    0.1  ,
    0.1  ,
    0.1  ,
    10  ,
    10

  );

    const formats:array [1..AIN_COUNT] of string =
  (
    '0.000'  ,
    '0.000'  ,
    '0.00'  ,
    '0.0'  ,
    '0.0'  ,
    '0.0'  ,
    '0.0'  ,
    '0.0'  ,
    '0.0'  ,
    '0.0'  ,
    '0.0'  ,
    '0.0'  ,
    '0.0'  ,
    '0.0'  ,
    '0.00'  ,
    '0.00'  ,
    '0.00'  ,
    '0.00'  ,
    '0.00'  ,
    '0'  ,
    '0'

  );

type
  pArchRec=^TArchRec;
  TArchRec=record
    line_ind:Integer;
    dt:TDatetime;
    dir,fname,s_ains,s_coils:ShortString;
    coils, c_raised:Int64;
  end;


  PChartRec = ^    TChartRec;
  TChartRec = record
    dt:TDatetime;
    a:array [0..AIN_COUNT-1] of Double;
    d:array [0..DIN_COUNT-1] of Boolean;
  end;

type
  tcls =       class of TObject;



procedure arch_str_parse( s:string; line_ind:Integer; parc: pArchRec );


function arch_str_coils( s:string ):Int64;


function archstr_to_buf(sx:string; var buf:array of byte; len:Integer):integer;


function buf_to_archstr(buf:array of byte; len:Integer):String;


function getTagControl_frm(tp: tcls  ;tag:Integer; frm:TWinControl ):TControl;

function coil_name(bit_index:Integer;   zero_bit_label_tag:Integer):String;


function coil_names(bits :Int64 ;   zero_bit_label_tag:Integer):String;


function arch_str_stime(s:string):String;


function arch_str_time(s:string):TDateTime;


procedure scan_alerts(ss_day, ss_alerts:tStringList);


procedure ains_str_to_floats(  s:String; var ains:array of double);
function hex_to_buf_recv(s:String;  var buf_recv:array of byte; len:Integer ):Integer ;
procedure buf_to_ains(buf_recv:array of byte; var ains:array of double ; len:Integer );


procedure DisposeOfChartStructs(ss:TStrings);


procedure extract_chart_channel(ss:TStrings; chan_ind_from0:Integer ; timeframe:Integer; dt_present:TDateTime; n_cnd:Integer;  var a:array of double; var adt:array of TDateTime );

procedure extract_chart_channel_simple( chan_ind_from0:Integer ; timeframe:Integer; dt_present:TDateTime; n_cnd:Integer;  var a:array of double; var adt:array of TDateTime );



function get_arch_dir:String;



procedure write_chart_ains_simple(   dt_present:TDateTime;   var ains_from0:array of double  );


var scan_frm:TWinControl=nil;

implementation

uses hydr_files;


function get_arch_dir:String;
var dir,arc_dir:String;
begin
 dir := Extractfilepath( Application.exename);
 arc_dir:=    'archive/';
 result:= dir + arc_dir;
end;

function timeframe_secw(i:Integer):Integer;
begin
 result:=60;

end;

function find_2_nearest_dt(ss:TStrings; dt:TDateTime; var ipast,ifut:Integer):integer;
var i:Integer; dt1,dt2   :Tdatetime;   obj:  pchartrec;
begin
 result:=0;
 ipast:=-1;
 ifut:= -1;
 if ss.Count=0 then exit;;
 obj:=  pchartrec(ss.objects[0]);
 if dt < obj^.DT then
  begin
    ifut:=0;
    result:=2;
    exit;
  end;

 for i:=0 to ss.Count-1-1 do
  begin
   //
   dt1:=pchartrec(ss.objects[i])^.DT;
   dt2:=pchartrec(ss.objects[i+1])^.DT;
   if (dt>dt1) and (dt<=dt2) then
    begin
      //
      ipast:=i;
      ifut:=I+1;
      result:=3;
      exit;
    end;


  end;


 if dt > pchartrec(ss.objects[ss.Count-1])^.DT then
  begin
    ipast:=ss.Count-1;
    result:=1;
  end;

end;






function find_2_nearest_dt_step(ss:TStrings; dt:TDateTime; var ipast,ifut  :Integer;  step_pts:Integer):integer;
var i:Integer; dt1,dt2   :Tdatetime;   obj:  pchartrec;
begin
 result:=0;
 ipast:=-1;
 ifut:= -1;
 if ss.Count=0 then exit;;
 obj:=  pchartrec(ss.objects[0]);
 if dt < obj^.DT then
  begin
    ifut:=0;
    result:=2;
    exit;
  end;

 i:=0;

 while i<= ss.Count-1-0 do
  begin
   //
   dt1:=pchartrec(ss.objects[i])^.DT;

   if dateutils.MinuteOfTheYear(dt1)=MinuteOfTheYear(dt)  then

    begin
      //
      ipast:=i;
      ifut:= i;
      result:=3;
      exit;
    end;

   i :=I+ step_pts;

  end;


 if dt > pchartrec(ss.objects[ss.Count-1])^.DT then
  begin
    ipast:=ss.Count-1;
    result:=1;
  end;

end;



procedure extract_chart_channel_simple( chan_ind_from0:Integer ; timeframe:Integer; dt_present:TDateTime; n_cnd:Integer;  var a:array of double; var adt:array of TDateTime );
var i,k:Integer; dt0, dti:tdatetime; dir,fn,fn_full:String; ini:TInifile;   val:double;
begin

 dt0:=RecodeMinute(dt_present,0);
 dt0:=RecodeSecond(dt_present,0);
 ini:=nil;

 for i:=0 to n_cnd-1 do
  begin

   dti:=incminute(dt0, -i);
   dir:=DateToStr_cust(dti);
   fn:=inttostr(hourof(dti));
   fn_full:= get_arch_dir+'minute/'+ dir+ '/' +fn+'.min';
   if ini=nil then
   ini:=TInifile.Create(fn_full)
   else if extractFileName(ini.FileName)<> extractFileName(fn_full) then
      begin
        ini.Free;;
        ini:=TInifile.Create( fn_full )    ;
      end;

   val:=ini.readFloat( inttostr(chan_ind_from0), inttostr(minuteoftheHOUR(dti)),   0 );
   a[i]:=val;
   adt[i]:=dti;



  end;

  if ini<>nil then ini .free;
end;






procedure write_chart_ains_simple(   dt_present:TDateTime;   var ains_from0:array of double  );
var i,k:Integer; dt0, dti:tdatetime; dir,fn,fn_full:String; ini:TInifile;   val:double;

  chan_ind_from0:Integer ;
begin

 dt0:=RecodeSecond(dt_present,0);
 ini:=nil;

 for k:=0 to AIN_COUNT-1 do
  begin
  chan_ind_from0:=k;

  for i:=0 to 0 do
   begin

   dti:=incminute(dt0, -i);
   dir:=DateToStr_cust(dti);
   fn:=inttostr(hourof(dti));
   fn_full:= get_arch_dir+'minute/'+ dir+ '/' +fn+'.min';
   if ini=nil then
   ini:=TInifile.Create(fn_full)
   else if extractFileName(ini.FileName)<> extractFileName(fn_full) then
      begin
        ini.Free;;
        ini:=TInifile.Create( fn_full )    ;
      end;

   val:= ains_from0[k];
   ini.writeFloat( inttostr(chan_ind_from0), inttostr(minuteoftheHOUR(dti)),   val );



   end;

  end;

  if ini<>nil then ini .free;
end;



procedure extract_chart_channel(ss:TStrings; chan_ind_from0:Integer ; timeframe:Integer; dt_present:TDateTime; n_cnd:Integer;  var a:array of double; var adt:array of TDateTime );
var i:Integer; dti,dt1,dt2:TDateTime;      ipast,ifut,ms1,ms2,mss:Integer  ;  v1,v2,v:Double; found:boolean;
begin

 for i:=0 to n_cnd-1 do
  begin

   found:=false;
   dti:=incsecond(dt_present, -timeframe*i);
   adt[i]:=dti;

     find_2_nearest_dt_step( ss, dti,ipast,ifut , 45 );

   if( ipast>-1 )and(ifut>-1) then
    begin
      //
      dt1:= pchartrec(ss.objects[ipast])^.DT;
      dt2:= pchartrec(ss.objects[ifut])^.DT;
      ms1:=millisecondsBetween(dt1,dti);
      ms2:=millisecondsBetween(dti,dt2);
      mss:=ms1+ms2;
      v1:=  pchartrec(ss.objects[ipast])^.a[chan_ind_from0] ;
      v2:=  pchartrec(ss.objects[ifut ])^.a[chan_ind_from0] ;
      v:= v1 + (v2-v1)/mss  * ms1;
      a[i]:=v;
      found:=true;

    end
   else if ipast>-1 then
    begin
      dt1:= pchartrec(ss.objects[ipast])^.DT;

      ms1:=millisecondsBetween(dt1,dti);
      if ms1/1000 <= timeframe*5 then
       begin
       v:=pchartrec(ss.objects[ipast])^.a[chan_ind_from0] ;
       a[i]:=v;
       found:=true;
       end;
    end;

   if not found then
    begin
      a[i]:=No_Data;
    end;

  end;

end;

procedure ains_str_to_floats(  s:String; var ains:array of double);
var b:array [0..2000] of byte; i, n:integer;  bhi,blo:Byte;

begin

  fillchar(b,sizeof(b),0);
  n:=hex_to_buf_recv(s,b,sizeof(b) );
  buf_to_ains( b, ains , sizeof(ains) );


end;



function hex_to_buf_recv(s:String;  var buf_recv:array of byte; len:Integer ):Integer;
var p,i,n:Integer; shi,slo:string; b:Byte;
begin
  n:=0;
  result:=0;
  while length(s)>0 do
   begin
     s:=trim(s);
     p:=pos(',',s);
     if p>0 then
      begin
        shi:=trim(copy( s,1,p-1));
        delete(s,1,p);
        hextobin(pchar(shi),@b,1);
        if n<len then buf_recv[n]:=b;
        s:=trim(s);
        inc(n);
      end
     else if length(s)>0 then
      begin
        hextobin(pchar(s),@b,1);
        if n<len then buf_recv[n]:=b;
        s:='';
        inc(n);
      end;
     if s='' then break;
   end;
  result:=n;
end;



procedure buf_to_ains(buf_recv:array of byte; var ains:array of double; len:Integer );
var i:Integer;  bhi ,blo   :byte;   val:integer; fval:double;
begin

  for i:=0 to AIN_COUNT-1 do
    begin
    bhi:=byte(buf_recv[9+i*2]);
    blo:=byte(buf_recv[10+i*2]);

    if (bhi and $80)=0 then
     begin
     val:= ((bhi shl 8) and $ff00) or blo;

     end
    else
     begin
     val:= (((bhi and $7F) shl 8) and $ff00) or blo  ;
     val:= val -  32768;
     end;


    fval:=val *factors[i+1]  /10.0;

    ains[i]:=fval;



    end;


end;




function StringListSortCompareDates_reverse(List: TStringList; Index1, Index2: Integer): Integer;
var
dt1, dt2 : tdateTime ;
s1,s2:String;
parc1:PArchRec;
parc2:PArchRec;
begin
  parc1:= PArchRec( list.Objects[index1] );
  parc2:= PArchRec( list.Objects[index2] );
s1 := trim(List[Index1]);
s2 := trim(List[Index2]);
dt1:= parc1^.dt ;
dt2:= parc2^.dt;
if dt1=dt2 then result:=0
else if dt1>dt2 then result:=-1
else result:=1;
end;


procedure scan_alerts(ss_day, ss_alerts:tStringList);
   var i,ibit:Integer;  s:String;   coils, coils_, c_raised :Int64;   parc:PArchRec;
begin

  DisposeOfArchStructs(ss_alerts);
  ss_alerts.Clear;

      for i:=0 to  ss_day.Count-1 do
       begin

       application.ProcessMessages;

       if i>0 then coils_:=coils else coils_:=0;
       coils:=arch_str_coils(ss_day[i]);
       c_raised:= (coils xor coils_) and coils;
       if c_raised>0 then
         begin
          s:=coil_names(c_raised,801);
          if s>'' then
            begin
            new(parc);
            fillchar(parc^,sizeof(parc^),0);
            parc^.dt:=  arch_str_time( ss_day[i] );
            parc^.coils:=coils;
            parc^.c_raised:=c_raised;
            ss_alerts.AddObject(arch_str_stime(ss_day[i]) +' > '+s,tobject(parc));
            end;
         end;


       end;


      ss_alerts.CustomSort( TStringListSortCompare( @StringListSortCompareDates_reverse));
end;



function arch_str_stime(s:string):String;
begin
  result:= copy(s,1, pos('>',s)-1);
end;

function arch_str_time(s:string):TDateTime;

begin
  s:= copy(s,1, pos('>',s)-1) ;
  result:=strToDateTime_cust(s );
end;


function getTagControl_frm(tp: tcls  ;tag:Integer; frm:TWinControl ):TControl;
var i:Integer;
begin
  result:=  nil;
  for i:=0 to frm.ControlCount-1 do
    begin
     if frm.Controls[i] is tp then
       begin
         if  frm.Controls[i].Tag=tag then
           begin
             result:=   frm.Controls[i];
             exit;
           end;
       end;

    end;

end;


function coil_names(bits:Int64;   zero_bit_label_tag:Integer):String;
var i:integer;   s:string;
begin
  result:='';
  for i:=0 to 63 do
    begin
     if (bits and (int64(1) shl i))>0 then
       begin
       s:=  coil_name(i, zero_bit_label_tag);
       if s>'' then
        begin
         result:=result+s+',';
        end;

       end;
    end;
end;


function coil_name(bit_index:Integer;   zero_bit_label_tag:Integer):String;
var tg:integer;  lb:tlabel;
begin
  //
  result:='';
  tg:= zero_bit_label_tag +  bit_index;
  lb:=tlabel(getTagControl_frm( tlabel, tg, scan_frm) );
  if lb<>nil then
     begin
       result:=lb.Caption;;
     end;

end;

function arch_str_coils( s:string ):Int64;
var parc: pArchRec   ;
begin
     new(parc);
     arch_str_parse(s,1,parc);



     result:=parc^.coils;

     dispose(parc);
end;

procedure arch_str_parse( s:string; line_ind:Integer; parc: pArchRec );
var p1,p2:Integer;  s_coils,  s_ains ,st:String; dt:TDatetime;     buf_din, buf_ain:array [0..999]of byte;    b2,b3:byte;
  coils:Int64;
begin
     fillchar(parc^,sizeof(parc^),0);
       p1:=pos('>',s);
     if p1>0 then
       begin
       //
       st:= trim(copy(s,1,p1-1));
       delete(s,1,p1);
       p2:= pos('|',s ) ;
       if p2>0 then
        begin
        s_coils:=trim(copy(s,1,p2-1));
        delete(s,1,p2);
        s_ains:=trim(s);


        dt:=strToDateTime_cust(st);

        parc^.s_ains:=s_ains;
        parc^.s_coils:=s_coils;
        parc^.line_ind:=line_ind;
        parc^.dt:=dt;

        archstr_to_buf(parc^.s_coils, buf_din, sizeof(buf_din));

        b2:= buf_din[10];
        b3:= buf_din[11];
        coils:=((  int64(buf_din[14]) shl 32)and $ff00000000)  or        ((buf_din[13] shl 24)and $ff000000)  or    ((buf_din[12] shl 16)and $ff0000)  or   ((b3 shl 8)and $ff00) or (b2 and $00ff)   ;
        parc^.coils:=coils;


        end;
       end;
end;



function buf_to_archstr(buf:array of byte; len:Integer):String;
var i:Integer;s:string;
begin
  s:='';   result:=s;
  for i:=0 to len-1 do
     begin
      //
      s:=s+inttohex(buf[i], 2)+',';

     end;
  result:=s;
end;


function archstr_to_buf(sx:string; var buf:array of byte; len:Integer):integer;
var i,p1,h:Integer;s:string;
begin
  s:='';   result:=0;
  for i:=0 to 9999-1 do
     begin

       p1:=pos(',',sx);
       if boolean(p1) then
         begin
           s:=copy(sx,1,p1-1);
           delete(sx,1,p1);
           h:=0;
           hextobin(pchar(s),@h,1);
           if i<len then
            buf [i]:=h;
         end;
     end;
  result:=i;
end;



procedure DisposeOfChartStructs(ss:TStrings);
var i:Integer; parc: pChartRec;
begin
 for i:=0 to ss.Count-1 do
  begin
    try
      if ss.Objects[i]<>nil then
       begin
         parc:= pChartRec(  ss.Objects[i] );
         Dispose(parc);

       end;
    except
    end;
  end;

end;


end.

