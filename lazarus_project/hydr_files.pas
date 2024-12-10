unit hydr_files;

{$mode ObjFPC}{$H+}

interface

uses

    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Sockets,  LCLIntf, ComCtrls, dateUtils,
   {$IFDEF UNIX}
    unix,
   {$ENDIF}
    filectrl, hydr_utils, cthreads, fgl;




procedure read_arch_files(ss:TstringList);


procedure DisposeOfArchStructs(ss:TStrings);


procedure add_file_lines_to_ss(fn:String; ss:TStrings );

procedure add_file_lines_to_ss_from_to(fn:String; ss:TStrings;  dt_from, dt_to:TDateTime );



procedure rd_arch_files_from_to(ss:TstringList; dt_from, dt_To:TDateTime );

function strToDate_cust(s:String):TDateTime;

function strToDate(s:String):TDateTime;
function strToDateTime_cust(s:String):TDateTime;

procedure read_recs_from_to(ss_fn_structs:TStrings; dt_from, dt_To:TDateTime ; ss_out: TStrings );

function DateToStr_cust(dt:TDateTime):string;


implementation


procedure read_recs_from_to(ss_fn_structs : TStrings ; dt_from, dt_To:TDateTime; ss_out: TStrings );
var i,k:integer;  parc: pArchRec; dt:tdatetime; b:Boolean; ss_rec:TStringList;  s:string;   arc: tArchRec;    cr: pChartRec;   fs:array[0..AIN_COUNT] of double;
begin

 for i:=0 to  ss_fn_structs.count-1 do
  begin
    //
    parc:=pArchRec(  ss_fn_structs.Objects[i] );
    dt:= parc^.dt   ;



    if dateInRange(dt, dt_from, dt_to) then

     add_file_lines_to_ss_from_to( parc^.dir + parc^.fname, ss_out ,dt_from, dt_To );



  end;


 for i:=0 to ss_out.Count-1 do
   begin
     arch_str_parse(ss_out[i], i, @arc);

     ains_str_to_floats(arc.s_ains, fs);

     s:=datetimetostr(arc.dt)+'> ';
     for k:=0 to AIN_COUNT-1 do
      begin
        s:= s+floatToStr( fs[k] )+', ';

      end;


     new(cr);
     fillchar(cr^,sizeof(cr^),0);

     Move(fs,cr^.a,sizeof(cr^.a));
     cr^.dt:=arc.dt;
     ss_out.Objects[i] := TObject(cr) ;
   end;


end;




procedure add_file_lines_to_ss(fn:String; ss:TStrings );
var ss2:TStringList;
begin
 ss2:=     TStringList.Create;
 ss2.LoadFromFile(fn);
 ss.AddStrings(ss2);
 ss2.Free;

end;



procedure add_file_lines_to_ss_from_to(fn:String; ss:TStrings; dt_from, dt_to:TDateTime );
var ss2:TStringList; i:Integer;   dt:TDatetime;    s:string;  obj: TObject;
begin
 ss2:=     TStringList.Create;
 ss2.LoadFromFile(fn);


 for i:=0 to ss2.Count-1 do
  begin
    //
    s:= trim(ss2[i]);
    if s='' then continue;
    dt:=arch_str_time( s );
    if DateTimeInRange(dt, dt_from, dt_to) then
      begin
       obj:=     tobject( ss2.Objects[i]  );
       ss.AddObject(ss2[i] , obj );
      end;

  end;

 ss2.Free;



end;







procedure DisposeOfArchStructs(ss:TStrings);
var i:Integer; parc: pArchRec;
begin
 for i:=0 to ss.Count-1 do
  begin
    try
      if ss.Objects[i]<>nil then
       begin
         parc:= pArchRec(  ss.Objects[i] );
         Dispose(parc);

       end;
    except
    end;
  end;

end;

function StringListSortCompareDates(List: TStringList; Index1, Index2: Integer): Integer;
var
dt1, dt2 : tdateTime ;
s1,s2:String;
begin
s1 := trim(List[Index1]);
s2 := trim(List[Index2]);
dt1:= strtodate_cust(s1);
dt2:= strtodate_cust(s2);
if dt1=dt2 then result:=0
else if dt1>dt2 then result:=1
else result:=-1;
end;


function strToDate(s:String):TDateTime;
begin
  result:= strToDate_cust(s);
end;


function DateToStr_cust(dt:TDateTime):string;
var s:string;
begin
 s:=FormatDateTime('dd-MM-YY', dt);
 result:=s;
end;

function strToDateTime_cust(s:String):TDateTime;
var d:TDateTime; t:TDateTime;   p:integer;
begin
  result:=0;
  t:=0; d:=0;
  try
  s:=trim(s);
  p:= Pos(' ',s);
  if p>0 then
   begin
     d:=strToDate_cust(s);
     delete(s,1,p);
     s:=trim(s);
     t:=strToTime(s);
   end
  else
   begin
     t:=0;
     d:=strToDate_cust(s);
   end;
  except
  end;
  result:=dateof(d)+timeOf(t);
end;

function strToDate_cust(s:String):TDateTime;
var p,y,m,d:Integer; sd,sm,sy:String;  dt:TDatetime;
begin
 //
 result:=0;
 p:=pos('-', s);
 if p>0 then
  begin
    sd:=trim(copy(s,1,p-1));
    delete(s, 1, p);
    p:=pos('-', s);
    if p>0 then
     begin
       sm:=trim(copy(s,1,p-1));
       delete(s,1,p);
       p:=pos(' ',s);
       if p>0 then     sy:= trim( copy(s,1,p-1) )
       else sy:=trim(s);
       y:=strtointdef(sy,1);
       if y<2000 then y:=y+2000;
       m:=strtointdef(sm,1);
       d:=strtointdef(sd,1);
       dt:=encodeDate(y,m,d);
       result:=dt;
     end;
  end
 else
 begin
     if (pos('.',s)>0)or (pos('/',s)>0) then
    begin
    result:=sysUtils.StrToDateTimeDef(trim(s),0);
    result:=trunc(result);

    end;
 end;

end;


procedure read_arch_files(ss:TstringList);
var fs: TFilestream;
   var s, dir, fn, arc_dir, full_dir :String;    s2:array [0..8] of char;    mode:word;
      r:TSearchRec;
      dt:TDatetime;
      p1:integer;
      y:integer;
      parc: PArchRec;
       cmp:TStringListSortCompare;
begin
 DisposeOfArchStructs(ss);
 ss.Clear;


 dir := Extractfilepath( Application.exename);
 arc_dir:=    'archive/';

 full_dir:= dir+arc_dir;

 if FindFirst(full_dir+'*.txt',  faAnyFile       ,r)=0 then
  begin
   repeat

   if( r.Name<>'.' )and( r.name<>'..') then
    begin

     s:=r.name;
     p1:=pos('.', s);
     if p1>0 then
       begin
       s:=copy(s,1,p1-1);
       dt:= strToDate_cust(s);
       y:=yearof(dt);
       new(parc);
       parc^.dt:=dt;
       parc^.fname:=r.Name;
       parc^.dir:=full_dir;
       ss.AddObject(s,TObject(parc));



       end;

    end;

   until findNext(r)<>0   ;
  end;
 FindClose(r);

 cmp:= TStringListSortCompare(  @ StringListSortCompareDates    );
       ss.CustomSort(cmp);


end;





procedure rd_arch_files_from_to(ss:TstringList; dt_from, dt_To:TDateTime );
var fs: TFilestream;
   var s, dir, fn, arc_dir, full_dir :String;    s2:array [0..8] of char;    mode:word;
      r:TSearchRec;
      dt:TDatetime;
      p1:integer;
      y:integer;
      parc: PArchRec;
       cmp:TStringListSortCompare;
begin
 DisposeOfArchStructs(ss);
 ss.Clear;


 dir := Extractfilepath( Application.exename);
 arc_dir:=    'archive/';

 full_dir:= dir+arc_dir;

 if FindFirst(full_dir+'*.txt',  faAnyFile       ,r)=0 then
  begin
   repeat

   if( r.Name<>'.' )and( r.name<>'..') then
    begin

     s:=r.name;

     p1:=pos('.', s);
     if p1>0 then
       begin
       s:=copy(s,1,p1-1);
       dt:= strToDate_cust(s);
       if not ( (dt>=DateOf(dt_from)) and (  dt<=dateOf(dt_to)  )  ) then continue;

       y:=yearof(dt);
       new(parc);
       parc^.dt:=dt;
       parc^.fname:=r.Name;
       parc^.dir:=full_dir;
       ss.AddObject(s,TObject(parc));



       end;

    end;

   until findNext(r)<>0   ;
  end;
 FindClose(r);

 cmp:= TStringListSortCompare(  @ StringListSortCompareDates    );
       ss.CustomSort(cmp);


end;

end.

