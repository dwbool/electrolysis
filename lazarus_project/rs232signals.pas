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

unit RS232Signals;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF LINUX}
  BaseUnix, termio,
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils, Math,
  RS232Thread, RS232Except;

{$I rs232common.inc}

{ TRS232ThreadSignals }

type
  TRS232ThreadSignals = class(TRS232Thread)
  private
    FOnSignalStatus: TRS232ThreadSignalStatusEvent;
  protected
    FHPort: THandle;
    FFlags: longword;
    FFlagsNew1: longword;
    FFlagsNew2: longword;
    FSignals: TRS232SignalsDCE;
    FSignalsPrev: TRS232SignalsDCE;
    FPin: integer;
    FPinStatus: integer;
    procedure NotifySignalStatus(Pin, Status: integer);
    procedure NotifySignalStatusSync;
    function GetSignalFlags(var Flags: longword): boolean;
    procedure Execute; override;
  public
    constructor Create(HPort: THandle);
    property OnSignalStatus: TRS232ThreadSignalStatusEvent
      read FOnSignalStatus write FOnSignalStatus;
  end;

implementation

{ TRS232ThreadSignals }

constructor TRS232ThreadSignals.Create(HPort: THandle);
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
  FIdThread := RS232IdThreadSignals;
end;

procedure TRS232ThreadSignals.NotifySignalStatus(Pin, Status: integer);
begin
  if not Terminated then
  begin
    FPin := Pin;
    FPinStatus := Status;
    Synchronize(@NotifySignalStatusSync);
  end;
end;

procedure TRS232ThreadSignals.NotifySignalStatusSync;
begin
  if Assigned(FOnSignalStatus) then
  begin
    FOnSignalStatus(FPin, FPinStatus);
  end;
end;

function TRS232ThreadSignals.GetSignalFlags(var Flags: longword): boolean;
begin
  Flags := 0;
  {$IFDEF LINUX}
  Result := (FpIOCtl(FHPort, TIOCMGET, @Flags) <> -1);
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Result := GetCommModemStatus(FHPort, @Flags);
  {$ENDIF}
end;

procedure TRS232ThreadSignals.Execute;
const
  PausePolling = 50;
  PauseReGet = 10;
  NotifyErrCount = 10;
var
  ErrCount: integer;
  IsChange: boolean;
begin
  FillChar(FSignals, SizeOf(FSignals), 0);
  FillChar(FSignalsPrev, SizeOf(FSignals), 0);
  ErrCount := 0;
  FFlags := 0;
  while not Terminated do
  begin
    Sleep(PausePolling);
    IsChange := False;
    if GetSignalFlags(FFlagsNew1) then
    begin
      if FFlagsNew1 <> FFlags then
      begin
        Sleep(PauseReGet);
        if GetSignalFlags(FFlagsNew2) then
        begin
          if FFlagsNew2 <> FFlags then
          begin
            FFlags := FFlagsNew2;
            {$IFDEF LINUX}
            FSignals.DCD := ifthen((FFlags and TIOCM_CD) <> 0, 1, 0);
            FSignals.DSR := ifthen((FFlags and TIOCM_DSR) <> 0, 1, 0);
            FSignals.CTS := ifthen((FFlags and TIOCM_CTS) <> 0, 1, 0);
            FSignals.RI := ifthen((FFlags and TIOCM_RI) <> 0, 1, 0);
            {$ENDIF}
            {$IFDEF MSWINDOWS}
            FSignals.DCD := ifthen((FFlagsNew1 and MS_RLSD_ON) <> 0, 1, 0);
            FSignals.DSR := ifthen((FFlagsNew1 and MS_DSR_ON) <> 0, 1, 0);
            FSignals.CTS := ifthen((FFlagsNew1 and MS_CTS_ON) <> 0, 1, 0);
            FSignals.RI := ifthen((FFlagsNew1 and MS_RING_ON) <> 0, 1, 0);
            {$ENDIF}
            IsChange := True;
          end;
        end;
      end;
      ErrCount := 0;
    end
    else
      Inc(ErrCount);
    if IsChange then
    begin
      if FSignals.DCD <> FSignalsPrev.DCD then
        NotifySignalStatus(RS232PinDCD, FSignals.DCD);
      if FSignals.DSR <> FSignalsPrev.DSR then
        NotifySignalStatus(RS232PinDSR, FSignals.DSR);
      if FSignals.CTS <> FSignalsPrev.CTS then
        NotifySignalStatus(RS232PinCTS, FSignals.CTS);
      if FSignals.RI <> FSignalsPrev.RI then
        NotifySignalStatus(RS232PinRI, FSignals.RI);
      FSignalsPrev := FSignals;
    end;
    if ErrCount = NotifyErrCount then
    begin
      {$IFDEF LINUX}
      NotifySystemFault('FpIOCtl', fpgeterrno, False);
      {$ENDIF}
      {$IFDEF MSWINDOWS}
      NotifySystemFault('GetCommModemStatus', GetLastError, False);
      {$ENDIF}
    end;
  end;
end;

end.

