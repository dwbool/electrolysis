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

unit RS232Except;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

{$I rs232common.inc}

{ ERS232OpenError }

type
  ERS232OpenError = class(Exception)
  private
    FPortName: string;
    FErrorCode: integer;
    FSystemErrorCode: longint;
  public
    constructor Create(PortName: string; ErrCode: integer; SysErrCode: longint);
    property PortName: string read FPortName;
    property ErrorCode: integer read FErrorCode;
    property SystemErrorCode: longint read FSystemErrorCode;
  end;

implementation

{ ERS232OpenError }

constructor ERS232OpenError.Create(PortName: string; ErrCode: integer;
  SysErrCode: longint);
begin
  inherited Create('');
  FPortName := PortName;
  FErrorCode := ErrCode;
  case ErrCode of
    RS232ErrNotExist: Message := 'Port does not exist';
    RS232ErrPermissionDenied: Message := 'Permission denied';
    RS232ErrDeviceBusy: Message := 'Device is busy';
    RS232ErrSettingsNotSupport: Message := 'Port settings are not supported';
    RS232ErrSignalPollNotSupport: Message := 'Signal polling are not supported';
    RS232ErrEventNotCreated: Message := 'Event not being created';
    RS232ErrPipeNotCreated: Message := 'Pipe not being created';
    RS232ErrThreadNotCreated: Message := 'Thread not being created';
    RS232ErrOtherError: Message := 'Other error';
  end;
  FSystemErrorCode := SysErrCode;
end;

end.

