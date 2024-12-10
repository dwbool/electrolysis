
//PPUNTERO=^PUNTERO; // <array element ptr>
//

TValueFunc=function (a:PPUNTERO):Double;
TWriteValFunc=procedure (a:PPUNTERO; Val:Double);
TItemProcessProc= function (a:PPUNTERO; extData:Pointer):Boolean; //if true stop

TSweepProc=procedure (a:PPUNTERO);// sep 2011

PFile=^file;
//PUNTERO=Pointer;
//PSameObject={^}{$i arshname.inc};
{$i arshname.inc}=class
protected
firstTact:Boolean;
fCount:Integer;
public
SweepProc:TSweepProc;
Name:String[20];
//Position:Integer;
Excluded:Boolean;
//Der,Price,Y:Double;
//Owner:Pointer;
Swapped:Boolean;
x_:array of PUNTERO;
Index:Integer;
//r:array of PPUNTERO;
procedure ToStream(stream:TStream);
procedure FromStream(stream:TStream);

//
procedure ToMem(p:Pointer; Size:Integer);
procedure FromMem(p:Pointer; Size:Integer);
procedure xCopyMemory(Destination: Pointer; Source: Pointer; Length: Integer);
//

procedure OutputToFile(var tof:File);
procedure InputFromFile(var tof:File);
procedure SaveToFile(f:String);
procedure LoadFromFile(f:String);
//procedure LoadFromFileBmp(f:String);
procedure SetItem(Index_:Integer; v:PPUNTERO);
function GetItem(Index_:Integer):PPUNTERO;
function Add(const P:PUNTERO):Integer;     
procedure AddList(Same:{$i arshname.inc});//(P:PUNTERO);
procedure Insert(Ind:Integer;P:PUNTERO);
procedure Delete(Ind:Integer);
procedure Remove(P:PUNTERO; PunteroValue:TValueFunc);
procedure Clear;
function Ptr:{$i arshname.inc};
constructor create;
function GetCount:Integer;
function Getilast:Integer;
procedure ClearSwapped;
procedure Swap(i,j:Integer);
//procedure SwPointers(i,j:Integer);
procedure Sort(func:TValueFunc; WriteValFunc:TWriteValFunc);
//procedure SortPointers(func:TValueFunc; WriteValFunc:TWriteValFunc);
procedure Traversal(func:TValueFunc; WriteValFunc:TWriteValFunc); // Same as Sort but doesnt change position
function FindMin(func:TValueFunc):PPuntero;
function FindMax(func:TValueFunc):PPuntero;

function HasItems(func:TValueFunc; List:{$i arshname.inc}):Boolean;
function ForEach(proc:TItemProcessProc; extData:Pointer):Boolean;//if true is stopped by func

function GetFirst:PPuntero;
function GetLast:PPuntero;

//procedure ObjectsToPointers;
//function GetPointerItem(ind:Integer):PPUNTERO;
//property PItems[Index_:Integer]:PPUNTERO read GetPointerItem;
property First:PPUNTERO read GetFirst;
property Last:PPUNTERO read GetLast;
property Items[Index_:Integer]:PPUNTERO read GetItem write SetItem; default;
property Count:Integer read GetCount;
property iLast:Integer read Getilast;
property _[Index_:Integer]:PPUNTERO read GetItem write SetItem;
property z[Index_:Integer]:PPUNTERO read GetItem write SetItem;
public

{$ifndef NO_DEFINITION_END}
// to place extra fields
end;
{$endif}
