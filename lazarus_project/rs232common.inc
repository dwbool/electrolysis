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

type

  TRS232ThreadReadWriteEvent = procedure(Status, NBytes: integer;
    Data: ShortString) of object;
  TRS232ThreadSystemFaultEvent = procedure(IdThread: char; FuncName: string;
    SysErrCode: longint; OnlyWarning: boolean) of object;
  TRS232ThreadSignalStatusEvent = procedure(Pin, Status: integer) of object;
  TRS232ReadWriteEvent = procedure(Sender: TObject; Status, NBytes: integer;
    Data: ShortString) of object;
  TRS232SystemFaultEvent = procedure(Sender: TObject; IdThread: char;
    FuncName: string; SysErrCode: longint; OnlyWarning: boolean) of object;
  TRS232SignalStatusEvent = procedure(Sender: TObject; Pin, Status: integer)
    of object;
  TRS232AfterCloseEvent = procedure(Sender: TObject; NoError: boolean)
    of object;

  TRS232EnumBaudRate = (
    br001200,
    br002400,
    br004800,
    br009600,
    br019200,
    br038400,
    br057600,
    br115200
    );
  TRS232EnumByteSize = (
    bs7bits,
    bs8bits
    );
  TRS232EnumParity = (
    pNone,
    pOdd,
    pEven,
    pMark,
    pSpace
    );
  TRS232EnumStopBits = (
    sbOne,
    sbTwo
    );
  TRS232EnumFlowControl = (
    fcNone,
    fcRtsCts
    );

  TRS232TimeoutWrite = -1..maxLongint;

  TRS232Settings = record
    Device: string;
    BaudRate: TRS232EnumBaudRate;
    ByteSize: TRS232EnumByteSize;
    Parity: TRS232EnumParity;
    StopBits: TRS232EnumStopBits;
    FlowControl: TRS232EnumFlowControl;
    TimeoutWrite: TRS232TimeoutWrite;
    SignalPolling: boolean;
  end;

  TRS232SignalsDTE = record
    DTR: byte;
    RTS: byte;
  end;

  TRS232SignalsDCE = record
    DCD: byte;
    DSR: byte;
    CTS: byte;
    RI: byte;
  end;

const

  RS232IdThreadPrimary = 'P';
  RS232IdThreadWrite = 'W';
  RS232IdThreadRead = 'R';
  RS232IdThreadSignals = 'S';

  {$IFDEF LINUX}
  RS232MsgBreakWrite = #24;
  RS232MsgBreakRead = #24;
  {$ENDIF}

  RS232WriteBegin = 1;
  RS232WriteComplete = 2;
  RS232WriteTimeout = 3;
  RS232WriteBreak = 4;
  RS232WriteError = 5;

  RS232ReadComplete = 11;
  RS232ReadBreak = 12;

  RS232ErrNotExist = 1;
  RS232ErrPermissionDenied = 2;
  RS232ErrDeviceBusy = 3;
  RS232ErrSettingsNotSupport = 4;
  RS232ErrSignalPollNotSupport = 5;
  RS232ErrEventNotCreated = 6;
  RS232ErrPipeNotCreated = 7;
  RS232ErrThreadNotCreated = 8;
  RS232ErrOtherError = 10;

  RS232Infinite = -1;

  RS232PinDCD = 1;
  RS232PinRxD = 2;
  RS232PinTxD = 3;
  RS232PinDTR = 4;
  RS232PinDSR = 6;
  RS232PinRTS = 7;
  RS232PinCTS = 8;
  RS232PinRI = 9;

