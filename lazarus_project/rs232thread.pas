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

unit RS232Thread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

{$I rs232common.inc}

{ TRS232Thread }

type
  TRS232Thread = class(TThread)
  private
    FOnSystemFault: TRS232ThreadSystemFaultEvent;
  protected
    FIdThread: char;
    FSysFaultFuncName: string;
    FSysFaultErrCode: longint;
    FSysFaultOnlyWarning: boolean;
    procedure NotifySystemFault(FuncName: string; SysErrCode: longint;
      OnlyWarning: boolean);
    procedure NotifySystemFaultSync;
  public
    property OnSystemFault: TRS232ThreadSystemFaultEvent
      read FOnSystemFault write FOnSystemFault;
  end;

implementation

{ TRS232Thread }

procedure TRS232Thread.NotifySystemFault(FuncName: string; SysErrCode: longint;
  OnlyWarning: boolean);
begin
  if not Terminated then
  begin
    FSysFaultFuncName := FuncName;
    FSysFaultErrCode := SysErrCode;
    FSysFaultOnlyWarning := OnlyWarning;
    if not OnlyWarning then
      Terminate;
    Synchronize(@NotifySystemFaultSync);
  end;
end;

procedure TRS232Thread.NotifySystemFaultSync;
begin
  if Assigned(FOnSystemFault) then
  begin
    FOnSystemFault(FIdThread, FSysFaultFuncName, FSysFaultErrCode,
      FSysFaultOnlyWarning);
  end;
end;

end.

