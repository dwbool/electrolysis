
//uses windows;

const INITIAL_LENGTH=10;
const PLUS_LENGTH=5;

var Buf: array[0..7] of Integer;  NumRead:Integer; pRead:PUNTERO;

DefaultSweep:TSweepProc=nil;


function {$i arshname.inc}.  GetFirst:PPuntero;
begin
Result:=z[0];
end;

function {$i arshname.inc}.GetLast:PPuntero;
begin
Result:=z[iLast];
end;

procedure {$i arshname.inc}.ToMem(p:Pointer; Size:Integer);
var i,N:Integer;  marker:Integer;   ip:Integer absolute p;
begin
marker:=0;
FillChar(buf,sizeof(buf),0);
buf[0]:=$4C454853  ;
N:=Size div sizeof(PUNTERO);
if N>self.Count then N:=self.Count;
buf[1]:=N;
buf[2]:=sizeof(PUNTERO);
//Stream.Write(buf,sizeof(buf));

xCopyMemory(p,@buf,sizeof(buf));
marker:=marker+sizeof(buf);
for i :=0  to N-1 do
       begin
       PRead:=x_[i];
       if (marker+sizeof(PUNTERO))>size then break;
       xCopyMemory( Pointer(ip+marker), @pread, sizeof(PUNTERO) );
       marker:=marker+sizeof(PUNTERO);
//       Stream.Write(PRead,sizeof(PRead));
       end;

end;

procedure {$i arshname.inc}.FromMem(p:Pointer; Size:Integer);
var i,recCount,marker:Integer; ip:Integer absolute p;
begin
Clear;
marker:=0;
xCopyMemory(@buf,p,sizeof(buf));
if buf[0]<>$4C454853  then exit;
recCount:=buf[1];
marker:=marker+sizeof(buf);
for i :=0  to recCount-1 do
       begin
       xCopyMemory(@PRead,Pointer(ip+marker),sizeof(PUNTERO));
       marker:=marker+sizeof(PUNTERO);
       Add(PRead);
       end;

end;


type TBytes=array[0..high(Word)] of Byte;
PBytes=^TBytes;

procedure {$i arshname.inc}.xCopyMemory(Destination: Pointer; Source: Pointer; Length: integer);
var p1,p2:PBytes;i:Integer;
begin
//CopyMemory(Destination, Source, Length);
//memcpy(Destination,Source,Length);
p1:=Destination;
p2:=Source;
for  i:=0  to Length-1 do
 begin
 p1[i]:=p2[i];
 end;
end;





procedure {$i arshname.inc}.  ToStream(stream:TStream);
var i:Integer;
begin
FillChar(buf,sizeof(buf),0);
buf[0]:=$4C454853  ;
buf[1]:=self.Count;
buf[2]:=sizeof(PUNTERO);
Stream.Write(buf,sizeof(buf));
for i :=0  to Count-1 do
       begin
       PRead:=x_[i];
       Stream.Write(PRead,sizeof(PRead));
       end;

end;


procedure {$i arshname.inc}.  FromStream(stream:TStream);
var i,recCount:Integer;
begin
Clear;
Stream.Read(buf,sizeof(buf));
if buf[0]<>$4C454853  then exit;
recCount:=buf[1];
for i :=0  to recCount-1 do
       begin
       Stream.Read(PRead,sizeof(PRead));
       Add(PRead);
       end;

end;

procedure {$i arshname.inc}.SaveToFile(f:String);
var
  ToF: file;
  NumRead, NumWritten,i: Integer;
  Buf: array[0..7] of Integer;
begin

      AssignFile(ToF, f);	{ Open output file }
      Rewrite(ToF, 1);	{ Record size = 1 }
      FillChar(buf,sizeof(buf),0);
      buf[0]:=$4C454853  ;
      //$53 72 69 76//76 69 72 53        ;
      buf[1]:=self.Count;
      buf[2]:=sizeof(PUNTERO);
      BlockWrite(ToF, buf, sizeof(buf), NumWritten);
      for i :=0  to Count-1 do
       begin
       PRead:=x_[i];
       BlockWrite(Tof, PRead, sizeof(PRead), NumWritten);
       end;
      CloseFile(ToF);

end;


procedure {$i arshname.inc}.LoadFromFile(f:String);
var
  ToF: file;
  NumRead, NumWritten,i: Integer;
  Buf: array[0..7] of Integer;
    recCount:Integer;
begin

      AssignFile(ToF, f);	{ Open output file }
      Reset(ToF, 1);	{ Record size = 1 }
      FillChar(buf,sizeof(buf),0);

      Clear;
      BlockRead(ToF, buf, sizeof(buf), NumRead);

      //buf[0]:=$4C454853  ;
      if buf[0]<>$4C454853  then exit;
      recCount:=buf[1];

      for i :=0  to recCount-1 do
       begin
       BlockRead(Tof, pRead, sizeof(pRead), NumRead);
       Add(PRead);
       end;
      CloseFile(ToF);

end;


///////////////////
//////////////////
{$i-}

procedure {$i arshname.inc}.OutputToFile(var ToF: file);
var
  //ToF: file;
  NumRead, NumWritten,i: Integer;
  Buf: array[0..7] of Integer;
begin

      //AssignFile(ToF, f);	{ Open output file }
      //Rewrite(ToF, 1);	{ Record size = 1 }
      FillChar(buf,sizeof(buf),0);
      buf[0]:=$4C454853  ;
      //$53 72 69 76//76 69 72 53        ;
      buf[1]:=self.Count;
      BlockWrite(ToF, buf, sizeof(buf), NumWritten);
      for i :=0  to Count-1 do
       begin
       PRead:=x_[i];
       BlockWrite(Tof, PRead, sizeof(PRead), NumWritten);
      
       writeln((i),': ',(Ioresult));
       end;
      //CloseFile(ToF);

end;



procedure {$i arshname.inc}.InputFromFile(var ToF: file);
var
  //ToF: file;
   NumWritten,i: Integer;

    recCount:Integer;
begin

      //AssignFile(ToF, f);	{ Open output file }
      //Reset(ToF, 1);	{ Record size = 1 }
      FillChar(buf,sizeof(buf),0);

      Clear;
      BlockRead(ToF, buf, sizeof(buf), NumRead);

      //buf[0]:=$4C454853  ;
      if buf[0]<>$4C454853  then exit;
      recCount:=buf[1];

      for i :=0  to recCount-1 do
       begin
       BlockRead(Tof, pRead, sizeof(pRead), NumRead);
       Add(PRead);
       end;
      //CloseFile(ToF);

end;


///////////////////
///////////////////
function {$i arshname.inc}.  Getilast:Integer;
begin
Result:=fCount-1;
end;


function {$i arshname.inc}.ForEach(proc:TItemProcessProc; extData:Pointer):Boolean;//if true stop
var i:Integer;
begin
Result:=False;
for i :=0  to Count-1 do
 begin
 if proc(Items[i],extData) then
  begin
  Result:=True;
  exit;
  end;
 end;
end;



function {$i arshname.inc}.HasItems(func:TValueFunc; List:{$i arshname.inc}):Boolean;
var i,j:Integer; has:Boolean;
begin
Result:=False;
for i :=0  to List.Count-1 do
 begin
 Has:=False;
 for j :=0  to self.Count-1 do
  begin
  if func(List.Items[i])=func(Self.Items[i]) then
   begin
   has:=True;
   Break;
   end;
  end;
 if not Has then exit;
 end;
Result:=True; 
end;

procedure {$i arshname.inc}.  Sort(func:TValueFunc; WriteValFunc:TWriteValFunc);
var i:Integer;a1,a2:Double;chg:Boolean;
begin
repeat
chg:=False;
for i :=0  to Count-1-1 do
 begin
 a1:=func(@(x_[i]));
 if Assigned(WriteValFunc) then WriteValFunc(@(x_[i]),a1);
 a2:=func(@(x_[i+1]));
 if Assigned(WriteValFunc) then WriteValFunc(@(x_[i+1]),a2);
 if (a1<a2) then
  begin
  Swap(i,i+1);
  chg:=True;
  end;
 end;
until not chg;
end;


procedure {$i arshname.inc}.  Traversal(func:TValueFunc; WriteValFunc:TWriteValFunc);
var i:Integer;a1:Double;
begin

for i :=0  to Count-1 do
 begin
 a1:=func(@(x_[i]));
 if Assigned(WriteValFunc) then WriteValFunc( @(x_[i]), a1 );
 end;

end;

function {$i arshname.inc}.  FindMin(func:TValueFunc):PPuntero;
var i,iMin:Integer;aMin,ai:Double;chg:Boolean;
begin
Result:=nil;
if Count<=0 then exit;
aMin:=func(@(x_[0]));
Result:=Items[0];
iMin:=0;
for i :=0  to Count-1 do
 begin
 ai:=func(@(x_[i]));
 if ai<aMin then
  begin
  aMin:=ai;
  iMin:=i;
  end;
 end;
Result:=Items[iMin];
end;

function {$i arshname.inc}.FindMax(func:TValueFunc):PPuntero;
var i,iMax:Integer;aMax,ai:Double;chg:Boolean;
begin
Result:=nil;
if Count<=0 then exit;
aMax:=func(@(x_[0]));
Result:=Items[0];
iMax:=0;
for i :=0  to Count-1 do
 begin
 ai:=func(@(x_[i]));
 if ai>aMax then
  begin
  aMax:=ai;
  iMax:=i;
  end;
 end;
Result:=Items[iMax];
end;


procedure {$i arshname.inc}.Insert(Ind:Integer;P:PUNTERO);
var  i:Integer;    A:PUNTERO;
begin
Add(A);
for i:=Count-1-1 downto Ind do
 begin
 x_[i+1]:=x_[i];
 end;
x_[ind]:=p;
end;

procedure {$i arshname.inc}.Delete(Ind:Integer);
var  i:Integer;    A:PUNTERO;
begin
if Assigned(SweepProc) then SweepProc(Items[ind]);
for i:=Ind+1 to Count-1 do
 begin
 x_[i-1]:=x_[i];
 end;
fcount:=fcount-1;
end;

procedure {$i arshname.inc}.Remove(P:PUNTERO; PunteroValue:TValueFunc);
var  i:Integer;    A:PUNTERO; 
begin
for i:=Count-1 downto 0 do
 begin
 if PunteroValue(@(x_[i]))=PunteroValue(@p) then
  begin
  Delete(i);
  end;
 end;
end;

procedure {$i arshname.inc}.SetItem(Index_:Integer; v:PPUNTERO);
begin
if Index_<fCount then
 x_[Index_]:=v^;
end;

function {$i arshname.inc}.GetItem(Index_:Integer):PPUNTERO;
var A:PUNTERO;
begin
FillChar(A,sizeof(A),0);
Result:=@A;
if (Index_<fCount)and(Index_>=0) then
 Result:=@(x_[Index_]);
end;

procedure {$i arshname.inc}.Clear;
var i:Integer;
begin
fCount:=0;
if Assigned(SweepProc) then
 for i :=0  to iLast do
  begin
  SweepProc(Items[i]);
  end;
SetLength(x_,INITIAL_LENGTH);
end;

function {$i arshname.inc}.GetCount:Integer;
begin
if FirstTact then
 begin
 FirstTact:=false;
 if (Assigned(DefaultSweep))and(not Assigned(SweepProc)) then SweepProc:=DefaultSweep;
 clear;
 end;
Result:=fCount;
end;

function {$i arshname.inc}.Add(const P:PUNTERO):Integer; //(P:PUNTERO);
var b:array of PUNTERO; i:Integer;
begin
if FirstTact then
 begin
 FirstTact:=false;
 if (Assigned(DefaultSweep))and(not Assigned(SweepProc)) then SweepProc:=DefaultSweep;
 clear;
 end;
if fCount>High(x_) then
 begin
 SetLength(b,High(x_)+1);
 for i:=0 to High(b) do b[i]:=x_[i];
 SetLength(x_,High(x_)+1+PLUS_LENGTH);
 for i:=0 to High(b) do x_[i]:=b[i];
 SetLength(b,1);
 end;
x_[fCount]:=P;
fCount:=fCount+1;
Result:=fCount;
end;

procedure {$i arshname.inc}.AddList(Same:{$i arshname.inc});//(P:PUNTERO);
var  i:Integer;
begin
for i :=0  to Same.Count-1 do
 begin
 self.Add(Same.Items[i]^);
 end;

end;

procedure {$i arshname.inc}.  Swap(i,j:Integer);
var p:PUNTERO;
begin

p:=Items[i]^;
Items[i]:=Items[j];
Items[j]:=@p;
swapped:=true;
end;



procedure {$i arshname.inc}.ClearSwapped;
begin
swapped:=false;
end;

function {$i arshname.inc}.Ptr:{$i arshname.inc};
begin
Result:={$i arshname.inc}(@Self);
end;

constructor {$i arshname.inc}.create;
begin
inherited;
Excluded:=False;
Clear;
//SetLength(x_,INITIAL_LENGTH);
//FillChar(x_,sizeof(x_),0);
end;


