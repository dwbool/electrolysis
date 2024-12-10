{
 ******************************************************************************
  Copyright (c) 2018, Alex (ModRW.ru). All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************
  SPDX-License-Identifier: BSD-1-Clause
 ******************************************************************************
}

unit RS232Names;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF LINUX}
  BaseUnix, termio,
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Windows, registry,
  {$ENDIF}
  Classes, SysUtils, FileUtil, LazUTF8;

function RS232LongName(PortName: string): string;
function RS232ShortName(PortName: string): string;
function RS232PortExists(PortName: string): boolean;
function RS232NamesListSystem(CheckExist: boolean = True): string;
function RS232NamesListForce: string;

implementation

{$IFDEF LINUX}
const
  PrefixPortName = '/dev/';{$ENDIF}
{$IFDEF MSWINDOWS}
const
  PrefixPortName = '\\.\';{$ENDIF}

function CompareAlphabetAndNumber(List: TStringList;
  Index1, Index2: integer): integer;
var
  Item1, Item2, S1, S2: string;
  I, N1, N2: integer;
begin
  Item1 := List[Index1];
  Item2 := List[Index2];
  S1 := '';
  N1 := 0;
  for I := UTF8Length(Item1) downto 1 do
  begin
    if Item1[I] in ['0'..'9'] then
      S1 := Item1[I] + S1
    else
    begin
      N1 := StrToInt(S1);
      S1 := UTF8Copy(Item1, 1, I);
      Break;
    end;
  end;
  S2 := '';
  N2 := 0;
  for I := UTF8Length(Item2) downto 1 do
  begin
    if Item2[I] in ['0'..'9'] then
      S2 := Item2[I] + S2
    else
    begin
      N2 := StrToInt(S2);
      S2 := UTF8Copy(Item2, 1, I);
      Break;
    end;
  end;
  if S1 > S2 then
    Exit(1)
  else if S1 < S2 then
    Exit(-1)
  else
  begin
    if N1 > N2 then
      Exit(1)
    else if N1 < N2 then
      Exit(-1)
    else
      Exit(0);
  end;
end;

function RS232LongName(PortName: string): string;
begin
  if UTF8Pos(PrefixPortName, PortName) = 1 then
    Result := PortName
  else
    Result := PrefixPortName + PortName;
end;

function RS232ShortName(PortName: string): string;
begin
  if UTF8Pos(PrefixPortName, PortName) = 1 then
    Result := UTF8Copy(PortName, Succ(UTF8Length(PrefixPortName)),
      UTF8Length(PortName))
  else
    Result := PortName;
end;

function RS232PortExists(PortName: string): boolean;
var
  H: THandle;
  {$IFDEF MSWINDOWS}
  DCB: TDCB;
  {$ENDIF}
  SysErrCode: longint;
begin
  Result := False;
  {$IFDEF LINUX}
  H := FpOpen(RS232LongName(PortName), O_RDWR or O_NONBLOCK or O_NOCTTY);
  if H > 0 then
  begin
    if boolean(IsATTY(H)) then
      Result := True;
    FpClose(H);
  end
  else
  begin
    SysErrCode := fpgeterrno;
    if SysErrCode = ESysEBUSY then
      Result := True;
  end;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  H := CreateFile(PChar(RS232LongName(PortName)), GENERIC_READ or
    GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
  if (H <> INVALID_HANDLE_VALUE) then
  begin
    if GetCommState(H, DCB{%H-}) then
      Result := True;
    CloseHandle(H);
  end
  else
  begin
    SysErrCode := GetLastError;
    if (SysErrCode = ERROR_ACCESS_DENIED) or
      (SysErrCode = ERROR_SHARING_VIOLATION) then
      Result := True;
  end;
  {$ENDIF}
end;

function RS232NamesListSystem(CheckExist: boolean = True): string;
{$IFDEF LINUX}
const
  TtyClassPath = '/sys/class/tty/';
  DriverPath = '/device/driver/';
{$ENDIF}
var
  Names, Devices: TStringList;
  {$IFDEF MSWINDOWS}
  Reg: TRegistry;
  {$ENDIF}
  I: integer;
  S: string;
begin
  Names := TStringList.Create;
  Devices := TStringList.Create;
  {$IFDEF MSWINDOWS}
  Reg := TRegistry.Create;
  {$ENDIF}
  try
    {$IFDEF LINUX}
    FindAllDirectories(Devices, TtyClassPath, False);
    for I := 0 to Pred(Devices.Count) do
    begin
      if DirectoryExists(Devices[I] + DriverPath) then
      begin
        S := ExtractFileName(Devices[I]);
        if CheckExist then
        begin
          if RS232PortExists(S) then
            Names.Add(S);
        end
        else
          Names.Add(S);
      end;
    end;
    Names.Sorted := False;
    Names.CustomSort(@CompareAlphabetAndNumber);
    Result := Names.CommaText;
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM');
    Reg.GetValueNames(Devices);
    for I := 0 to Pred(Devices.Count) do
    begin
      S := RS232ShortName(Reg.ReadString(Devices[I]));
      if CheckExist then
      begin
        if RS232PortExists(S) then
          Names.Add(S);
      end
      else
        Names.Add(S);
    end;
    Reg.CloseKey;
    Names.Sorted := False;
    Names.CustomSort(@CompareAlphabetAndNumber);
    Result := WinCPToUTF8(Names.CommaText);
    {$ENDIF}
  finally
    {$IFDEF MSWINDOWS}
    Reg.Free;
    {$ENDIF}
    Devices.Free;
    Names.Free;
  end;
end;

function RS232NamesListForce: string;
const
  {$IFDEF LINUX}
  CheckNames = 'ttyS*;ttyUSB*;ttyACM*';
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  CheckName = 'COM';
  {$ENDIF}
var
  Names: TStringList;
  {$IFDEF LINUX}
  TtyDev: TStringList;
  {$ENDIF}
  I: integer;
  S: string;
begin
  Names := TStringList.Create;
  {$IFDEF LINUX}
  TtyDev := TStringList.Create;
  {$ENDIF}
  try
    {$IFDEF LINUX}
    FindAllFiles(TtyDev, PrefixPortName, CheckNames, False);
    for I := 0 to Pred(TtyDev.Count) do
    begin
      S := ExtractFileName(TtyDev[I]);
      if RS232PortExists(S) then
        Names.Add(S);
    end;
    Names.Sorted := False;
    Names.CustomSort(@CompareAlphabetAndNumber);
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    for I := 1 to 256 do
    begin
      S := CheckName + IntToStr(I);
      if RS232PortExists(S) then
        Names.Add(S);
    end;
    {$ENDIF}
    Result := Names.CommaText;
  finally
    Names.Free;
    {$IFDEF LINUX}
    TtyDev.Free;
    {$ENDIF}
  end;
end;

end.

