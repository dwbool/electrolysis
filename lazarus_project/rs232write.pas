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

unit RS232Write;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF LINUX}
  BaseUnix, termio,
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils, dateutils,
  RS232Thread, RS232Except;

{$I rs232common.inc}

{ TRS232ThreadWrite }

type
  TRS232ThreadWrite = class(TRS232Thread)
  private
    FOnWritingProcess: TRS232ThreadReadWriteEvent;
  protected
    FHPort: THandle;
    FHComm1: THandle;
    FHComm2: THandle;
    FPBufferForWrite: PShortString;
    FBuffer: ShortString;
    FTimeout: TRS232TimeoutWrite;
    FStartFlag: boolean;
    FCheckCTS: boolean;
    FInProgress: boolean;
    FWritingStatus: integer;
    FWritingNBytes: integer;
    procedure ReceiveBufferForWrite;
    procedure NotifyWritingProcess(Status, NBytes: integer);
    procedure NotifyWritingProcessSync;
    function IsCTSEnabled: boolean;
    procedure Execute; override;
  public
    constructor Create(HPort, HComm1, HComm2: THandle;
      PBuffer: PShortString; Timeout: TRS232TimeoutWrite);
    destructor Destroy; override;
    property CheckCTS: boolean write FCheckCTS;
    property InProgress: boolean read FInProgress;
    property OnWritingProcess: TRS232ThreadReadWriteEvent
      read FOnWritingProcess write FOnWritingProcess;
    procedure WriteBuffer;
  end;

implementation

{ TRS232ThreadWrite }

constructor TRS232ThreadWrite.Create(HPort, HComm1, HComm2: THandle;
  PBuffer: PShortString; Timeout: TRS232TimeoutWrite);
begin
  try
    inherited Create(True);
  except
    {$IFDEF LINUX}
    raise ERS232OpenError.Create('', RS232ErrThreadNotCreated, fpgeterrno);
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    raise ERS232OpenError.Create('', RS232ErrThreadNotCreated, GetLastError);
    {$ENDIF}
  end;
  FHPort := HPort;
  FHComm1 := HComm1;
  FHComm2 := HComm2;
  FPBufferForWrite := PBuffer;
  FTimeout := Timeout;
  FIdThread := RS232IdThreadWrite;
  FStartFlag := False;
  FCheckCTS := False;
  FInProgress := False;
end;

destructor TRS232ThreadWrite.Destroy;
{$IFDEF LINUX}
var
  Msg: char;
{$ENDIF}
begin
  Terminate;
  if FInProgress then
  begin
    {$IFDEF LINUX}
    Msg := RS232MsgBreakWrite;
    FpWrite(FHComm1, Msg, 1);
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    SetEvent(FHComm2);
    {$ENDIF}
  end;
  inherited Destroy;
end;

procedure TRS232ThreadWrite.WriteBuffer;
begin
  FStartFlag := True;
end;

procedure TRS232ThreadWrite.ReceiveBufferForWrite;
begin
  FBuffer := FPBufferForWrite^;
end;

procedure TRS232ThreadWrite.NotifyWritingProcess(Status, NBytes: integer);
begin
  if not Terminated then
  begin
    FWritingStatus := Status;
    FWritingNBytes := NBytes;
    Synchronize(@NotifyWritingProcessSync);
  end;
end;

procedure TRS232ThreadWrite.NotifyWritingProcessSync;
begin
  if Assigned(FOnWritingProcess) then
  begin
    FOnWritingProcess(FWritingStatus, FWritingNBytes, FBuffer);
  end;
end;

function TRS232ThreadWrite.IsCTSEnabled: boolean;
const
  CountRequests = 2;
  PauseReGet = 10;
var
  I: integer;
  Flags: longword;
begin
  for I := 1 to CountRequests do
  begin
    Flags := 0;
    {$IFDEF LINUX}
    if FpIOCtl(FHPort, TIOCMGET, @Flags) = -1 then
      Result := False
    else
      Result := (Flags and TIOCM_CTS) <> 0;
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    if GetCommModemStatus(FHPort, @Flags) then
      Result := (Flags and MS_CTS_ON) <> 0
    else
      Result := False;
    {$ENDIF}
    if not Result then
      Break;
    Sleep(PauseReGet);
  end;
end;

procedure TRS232ThreadWrite.Execute;
const
  WaitingWrite = 10;
  PauseCheckCTS = 50;
var
  {$IFDEF LINUX}
  SysTimeout, NBytes, WriteResult: longint;
  Msg: char;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  SysTimeout, WaitResult, NBytes: longword;
  Overlapped: TOVERLAPPED;
  SysErrCode: longint;
  Events: array[0..1] of THandle;
  {$ENDIF}
  DtStart: TDateTime;
begin
  if FTimeout = RS232Infinite then
  begin
    {$IFDEF LINUX}
    SysTimeout := -1;
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    SysTimeout := INFINITE;
    {$ENDIF}
  end
  else
    SysTimeout := FTimeout;
  while not Terminated do
  begin
    Sleep(WaitingWrite);
    FillChar(FBuffer, SizeOf(FBuffer), 0);
    if FStartFlag then
    begin
      Synchronize(@ReceiveBufferForWrite);
      NBytes := Ord(FBuffer[0]);
      FStartFlag := False;
      FInProgress := True;
      NotifyWritingProcess(RS232WriteBegin, NBytes);
      {$IFDEF LINUX}
      if FCheckCTS then
      begin
        DtStart := Now;
        while True do
        begin
          if IsCTSEnabled then
          begin
            WriteResult := FpWrite(FHPort, FBuffer[1], NBytes);
            if WriteResult = -1 then
            begin
              NotifyWritingProcess(RS232WriteError, 0);
              NotifySystemFault('FpWrite', fpgeterrno, False);
            end
            else
              NotifyWritingProcess(RS232WriteComplete, NBytes);
            Break;
          end;
          Sleep(PauseCheckCTS);
          Msg := #0;
          if (FpRead(FHComm2, Msg, 1) = 1) and
            (Msg = RS232MsgBreakWrite) then
          begin
            NotifyWritingProcess(RS232WriteBreak, 0);
            Break;
          end;
          if (SysTimeout >= 0) and
            (MilliSecondsBetween(Now, DtStart) >= SysTimeout) then
          begin
            NotifyWritingProcess(RS232WriteTimeout, 0);
            Break;
          end;
        end;
      end
      else
      begin
        WriteResult := FpWrite(FHPort, FBuffer[1], NBytes);
        if WriteResult = -1 then
        begin
          NotifyWritingProcess(RS232WriteError, 0);
          NotifySystemFault('FpWrite', fpgeterrno, False);
        end
        else
          NotifyWritingProcess(RS232WriteComplete, NBytes);
      end;
      {$ENDIF}
      {$IFDEF MSWINDOWS}
      if not ResetEvent(FHComm1) then
        NotifySystemFault('ResetEvent', GetLastError, False);
      if not ResetEvent(FHComm2) then
        NotifySystemFault('ResetEvent', GetLastError, False);
      if FCheckCTS then
      begin
        DtStart := Now;
        while True do
        begin
          if IsCTSEnabled then
          begin
            if WriteFile(FHPort, FBuffer[1], NBytes, NBytes, nil) then
              NotifyWritingProcess(RS232WriteComplete, NBytes)
            else
            begin
              NotifyWritingProcess(RS232WriteError, 0);
              NotifySystemFault('WriteFile', GetLastError, False);
            end;
            Break;
          end;
          WaitResult := WaitForSingleObject(FHComm2, PauseCheckCTS);
          case WaitResult of
            WAIT_OBJECT_0:
            begin
              NotifyWritingProcess(RS232WriteBreak, 0);
              Break;
            end;
            WAIT_TIMEOUT: ;
            else
              NotifySystemFault('WaitForSingleObject', GetLastError, False);
          end;
          if MilliSecondsBetween(Now, DtStart) >= SysTimeout then
          begin
            NotifyWritingProcess(RS232WriteTimeout, 0);
            Break;
          end;
        end;
      end
      else
      begin
        FillChar(Overlapped{%H-}, SizeOf(Overlapped), 0);
        Overlapped.hEvent := FHComm1;
        if WriteFile(FHPort, FBuffer[1], NBytes, NBytes, @Overlapped) then
          NotifyWritingProcess(RS232WriteComplete, NBytes)
        else
        begin
          SysErrCode := GetLastError;
          if SysErrCode <> ERROR_IO_PENDING then
          begin
            NotifyWritingProcess(RS232WriteError, 0);
            NotifySystemFault('WriteFile', SysErrCode, False);
          end
          else
          begin
            Events[0] := Overlapped.hEvent;
            Events[1] := FHComm2;
            WaitResult := WaitForMultipleObjects(2, @Events, False, SysTimeout);
            case WaitResult of
              WAIT_OBJECT_0:
              begin
                if GetOverlappedResult(FHPort, Overlapped, NBytes, False) then
                  NotifyWritingProcess(RS232WriteComplete, NBytes)
                else
                begin
                  NotifyWritingProcess(RS232WriteError, 0);
                  NotifySystemFault('GetOverlappedResult', GetLastError, False);
                end;
              end;
              WAIT_OBJECT_0 + 1:
              begin
                NotifyWritingProcess(RS232WriteBreak, 0);
                if not CancelIo(FHPort) then
                  NotifySystemFault('CancelIO', GetLastError, True);
              end;
              WAIT_TIMEOUT:
              begin
                NotifyWritingProcess(RS232WriteTimeout, 0);
                if not CancelIo(FHPort) then
                  NotifySystemFault('CancelIO', GetLastError, True);
              end;
              else
                NotifySystemFault('WaitForMultipleObjects', GetLastError,
                  False);
            end;
          end;
        end;
      end;
      {$ENDIF}
      FInProgress := False;
    end;
  end;
end;

end.

