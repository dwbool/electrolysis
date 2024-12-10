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

unit RS232Read;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF LINUX}
  BaseUnix,
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils,
  RS232Thread, RS232Except;

{$I rs232common.inc}

{ TRS232ThreadRead }

type
  TRS232ThreadRead = class(TRS232Thread)
  private
    FOnReadingProcess: TRS232ThreadReadWriteEvent;
  protected
    FHPort: THandle;
    FHComm1: THandle;
    FHComm2: THandle;
    FBuffer: ShortString;
    FReadingStatus: integer;
    procedure NotifyReadindProcess(Status: integer);
    procedure NotifyReadingProcessSync;
    procedure Execute; override;
  public
    constructor Create(HPort, HComm1, HComm2: THandle);
    destructor Destroy; override;
    property OnReadingProcess: TRS232ThreadReadWriteEvent
      read FOnReadingProcess write FOnReadingProcess;
  end;

implementation

{ TRS232ThreadRead }

constructor TRS232ThreadRead.Create(HPort, HComm1, HComm2: THandle);
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
  FIdThread := RS232IdThreadRead;
end;

destructor TRS232ThreadRead.Destroy;
{$IFDEF LINUX}
var
  Msg: char;
{$ENDIF}
begin
  Terminate;
  {$IFDEF LINUX}
  Msg := RS232MsgBreakRead;
  FpWrite(FHComm1, Msg, 1);
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  SetEvent(FHComm2);
  {$ENDIF}
  inherited Destroy;
end;

procedure TRS232ThreadRead.NotifyReadindProcess(Status: integer);
begin
  if not Terminated then
  begin
    FReadingStatus := Status;
    Synchronize(@NotifyReadingProcessSync);
  end;
end;

procedure TRS232ThreadRead.NotifyReadingProcessSync;
begin
  if Assigned(FOnReadingProcess) then
  begin
    FOnReadingProcess(FReadingStatus, Ord(FBuffer[0]), FBuffer);
  end;
end;

procedure TRS232ThreadRead.Execute;
const
  PauseReading = 10;
  MaxBytesInBuffer = Pred(SizeOf(ShortString));
var
  {$IFDEF LINUX}
  Msg: char;
  PollFDs: array[0..1] of tpollfd;
  WaitResult, NBytes: longint;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  NBytes, NBytesForRead, I, WaitResult, ComErr: longword;
  ByteIsRead: boolean;
  Overlapped: TOVERLAPPED;
  SysErrCode: longint;
  Events: array[0..1] of THandle;
  ComStat: TCOMSTAT;
  {$ENDIF}
begin
  {$IFDEF LINUX}
  PollFDs[0].fd := FHPort;
  PollFDs[0].events := POLLIN;
  PollFDs[1].fd := FHComm2;
  PollFDs[1].events := POLLIN;
  {$ENDIF}
  while not Terminated do
  begin
    Sleep(PauseReading);
    FillChar(FBuffer, SizeOf(FBuffer), 0);
    {$IFDEF LINUX}
    Msg := #0;
    PollFDs[0].revents := 0;
    PollFDs[1].revents := 0;
    WaitResult := FpPoll(@PollFDs, 2, -1);
    case WaitResult of
      -1: NotifySystemFault('FpPoll', fpgeterrno, False);
      1, 2:
      begin
        if (PollFDs[0].revents and POLLIN) <> 0 then
        begin
          Sleep(PauseReading);
          NBytes := FpRead(FHPort, FBuffer[1], MaxBytesInBuffer);
          if NBytes = -1 then
            NotifySystemFault('FpRead', fpgeterrno, False)
          else if NBytes > 0 then
          begin
            FBuffer[0] := chr(NBytes);
            NotifyReadindProcess(RS232ReadComplete);
          end;
        end;
        if (PollFDs[1].revents and POLLIN) <> 0 then
        begin
          NBytes := FpRead(FHComm2, Msg, 1);
          if NBytes = -1 then
            NotifySystemFault('FpRead', fpgeterrno, True)
          else if (NBytes = 1) and (Msg = RS232MsgBreakRead) then
            NotifyReadindProcess(RS232ReadBreak);
        end;
      end;
    end;
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    NBytes := 0;
    ByteIsRead := False;
    for I := 1 to 2 do
    begin
      if not ResetEvent(FHComm1) then
        NotifySystemFault('ResetEvent', GetLastError, False);
      if not ResetEvent(FHComm2) then
        NotifySystemFault('ResetEvent', GetLastError, False);
      FillChar(Overlapped{%H-}, SizeOf(Overlapped), 0);
      Overlapped.hEvent := FHComm1;
      if I = 1 then
        NBytesForRead := 1
      else
      begin
        FBuffer[0] := chr(1);
        Sleep(PauseReading);
        FillChar(ComStat{%H-}, SizeOf(ComStat), 0);
        ClearCommError(FHPort, @ComErr, @ComStat);
        NBytesForRead := ComStat.cbInQue;
        if NBytesForRead = 0 then
        begin
          NotifyReadindProcess(RS232ReadComplete);
          Break;
        end;
        if NBytesForRead > Pred(MaxBytesInBuffer) then
          NBytesForRead := Pred(MaxBytesInBuffer);
      end;
      if ReadFile(FHPort, FBuffer[I], NBytesForRead, NBytes, @Overlapped) then
      begin
        if I = 1 then
          ByteIsRead := (NBytes = 1)
        else
        begin
          FBuffer[0] := chr(Succ(NBytes));
          NotifyReadindProcess(RS232ReadComplete);
        end;
      end
      else
      begin
        SysErrCode := GetLastError;
        if SysErrCode <> ERROR_IO_PENDING then
          NotifySystemFault('ReadFile', SysErrCode, False)
        else
        begin
          Events[0] := Overlapped.hEvent;
          Events[1] := FHComm2;
          WaitResult := WaitForMultipleObjects(2, @Events, False, INFINITE);
          case WaitResult of
            WAIT_OBJECT_0:
            begin
              if GetOverlappedResult(FHPort, Overlapped, NBytes, False) then
              begin
                if I = 1 then
                  ByteIsRead := (NBytes = 1)
                else
                begin
                  FBuffer[0] := chr(Succ(NBytes));
                  NotifyReadindProcess(RS232ReadComplete);
                end;
              end
              else
                NotifySystemFault('GetOverlappedResult', GetLastError, False);
            end;
            WAIT_OBJECT_0 + 1:
            begin
              ByteIsRead := False;
              NotifyReadindProcess(RS232ReadBreak);
              if not CancelIo(FHPort) then
                NotifySystemFault('CancelIO', GetLastError, True);
            end;
            else
            begin
              ByteIsRead := False;
              NotifySystemFault('WaitForMultipleObjects', GetLastError, False);
            end;
          end;
        end;
      end;
      if not ByteIsRead then
        Break;
    end;
    {$ENDIF}
  end;
end;

end.

