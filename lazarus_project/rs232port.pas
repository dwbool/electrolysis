{
 ******************************************************************************
  Copyright (c) 2018-2019, Alex (ModRW.ru). All rights reserved.

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

unit RS232Port;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF LINUX}
  BaseUnix, termio,
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Math, ExtCtrls,
  Interfaces, RS232Names, RS232Except, RS232Write, RS232Read, RS232Signals;

{$I rs232common.inc}

{ TRS232Port }

type
  TRS232Port = class(TComponent)
  private
    { Private declarations }
    FActive: boolean;
    FHandle: THandle;
    FSettingsForOpen: TRS232Settings;
    FClearOnOpen: boolean;
    FDTROnOpen: boolean;
    FRTSOnOpen: boolean;
    FSignalsDTE: TRS232SignalsDTE;
    FSignalsDCE: TRS232SignalsDCE;
    FWorkSettings: TRS232Settings;
    FOnAfterOpen: TNotifyEvent;
    FOnAfterClose: TRS232AfterCloseEvent;
    FOnSignalStatus: TRS232SignalStatusEvent;
    FOnSystemFault: TRS232SystemFaultEvent;
    FOnWritingProcess: TRS232ReadWriteEvent;
    FOnReadingProcess: TRS232ReadWriteEvent;
  protected
    { Protected declarations }
    FWorkProcess: boolean;
    FThreadSignals: TRS232ThreadSignals;
    FThreadWrite: TRS232ThreadWrite;
    FHCommWrite1: THandle;
    FHCommWrite2: THandle;
    FBufferForWrite: ShortString;
    FWriteInProgress: boolean;
    FThreadRead: TRS232ThreadRead;
    FHCommRead1: THandle;
    FHCommRead2: THandle;
    FTimerClose: TTimer;
    FNoError: boolean;
    procedure NotifySignalsDCEStatus;
    procedure NotifySignalStatus(Pin, Status: integer);
    procedure NotifySystemFault(FuncName: string; SysErrCode: longint;
      OnlyWarning: boolean);
    procedure OnThreadSignalStatus(Pin, Status: integer);
    procedure OnThreadSystemFault(IdThread: char; FuncName: string;
      SysErrCode: longint; OnlyWarning: boolean);
    procedure OnThreadWritingProcess(Status, NBytes: integer;
      Data: ShortString);
    procedure OnThreadReadingProcess(Status, NBytes: integer;
      Data: ShortString);
    function GetSysErrCode: longint;
    procedure CloseDescriptor(Descriptor: THandle);
    procedure ClosePortAndThreads;
    procedure OnTimerClose(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Active: boolean read FActive;
    property Handle: THandle read FHandle;
    property TimeoutWrite: TRS232TimeoutWrite
      read FSettingsForOpen.TimeoutWrite write FSettingsForOpen.TimeoutWrite;
    property SignalPolling: boolean read FSettingsForOpen.SignalPolling
      write FSettingsForOpen.SignalPolling;
    property ClearOnOpen: boolean read FClearOnOpen write FClearOnOpen;
    property DTROnOpen: boolean read FDTROnOpen write FDTROnOpen;
    property RTSOnOpen: boolean read FRTSOnOpen write FRTSOnOpen;
    property SignalsDTE: TRS232SignalsDTE read FSignalsDTE;
    property SignalsDCE: TRS232SignalsDCE read FSignalsDCE;
    property WorkSettings: TRS232Settings read FWorkSettings;
    procedure Open;
    procedure Close;
    function BaudRateToInt(BaudRate: TRS232EnumBaudRate): integer;
    function ByteSizeToInt(ByteSize: TRS232EnumByteSize): integer;
    function ParityToChar(Parity: TRS232EnumParity): char;
    function StopBitsToInt(StopBits: TRS232EnumStopBits): integer;
    function InfoPortSettings: string;
    function SetStatusDTR(Enabled: boolean): longint;
    function SetStatusRTS(Enabled: boolean): longint;
    function GetStatusSignalsDCE: longint;
    function IsWriteInProgress: boolean;
    function WriteData(ByteStr: ShortString): boolean;
    procedure BreakWrite;
  published
    { Published declarations }
    property Device: string read FSettingsForOpen.Device
      write FSettingsForOpen.Device;
    property BaudRate: TRS232EnumBaudRate
      read FSettingsForOpen.BaudRate write FSettingsForOpen.BaudRate default
      br009600;
    property ByteSize: TRS232EnumByteSize
      read FSettingsForOpen.ByteSize write FSettingsForOpen.ByteSize default
      bs8bits;
    property Parity: TRS232EnumParity read FSettingsForOpen.Parity
      write FSettingsForOpen.Parity default pNone;
    property StopBits: TRS232EnumStopBits
      read FSettingsForOpen.StopBits write FSettingsForOpen.StopBits default
      sbOne;
    property FlowControl: TRS232EnumFlowControl
      read FSettingsForOpen.FlowControl
      write FSettingsForOpen.FlowControl default fcNone;
    property OnAfterOpen: TNotifyEvent read FOnAfterOpen write FOnAfterOpen;
    property OnAfterClose: TRS232AfterCloseEvent
      read FOnAfterClose write FOnAfterClose;
    property OnSignalStatus: TRS232SignalStatusEvent
      read FOnSignalStatus write FOnSignalStatus;
    property OnSystemFault: TRS232SystemFaultEvent
      read FOnSystemFault write FOnSystemFault;
    property OnWritingProcess: TRS232ReadWriteEvent
      read FOnWritingProcess write FOnWritingProcess;
    property OnReadingProcess: TRS232ReadWriteEvent
      read FOnReadingProcess write FOnReadingProcess;
  end;

  ERS232OpenError = RS232Except.ERS232OpenError;

{$IFDEF LINUX}
const
  ArrBaudRate: array[TRS232EnumBaudRate] of longword = (
    B1200,
    B2400,
    B4800,
    B9600,
    B19200,
    B38400,
    B57600,
    B115200
    );
  ArrByteSize: array[TRS232EnumByteSize] of byte = (
    CS7,
    CS8
    );{$ENDIF}
{$IFDEF MSWINDOWS}
const
  ArrBaudRate: array[TRS232EnumBaudRate] of longword = (
    CBR_1200,
    CBR_2400,
    CBR_4800,
    CBR_9600,
    CBR_19200,
    CBR_38400,
    CBR_57600,
    CBR_115200
    );
  ArrByteSize: array[TRS232EnumByteSize] of byte = (
    7,
    8
    );
  ArrParity: array[TRS232EnumParity] of byte = (
    NOPARITY,
    ODDPARITY,
    EVENPARITY,
    MARKPARITY,
    SPACEPARITY
    );
  ArrStopBits: array[TRS232EnumStopBits] of byte = (
    ONESTOPBIT,
    TWOSTOPBITS
    );{$ENDIF}

procedure Register;

implementation

{ TRS232Port }

constructor TRS232Port.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive := False;
  FWorkProcess := False;
  FSettingsForOpen.BaudRate := br009600;
  FSettingsForOpen.ByteSize := bs8bits;
  FSettingsForOpen.Parity := pNone;
  FSettingsForOpen.StopBits := sbOne;
  FSettingsForOpen.FlowControl := fcNone;
  FSettingsForOpen.TimeoutWrite := RS232Infinite;
  FSettingsForOpen.SignalPolling := False;
  FClearOnOpen := True;
  FDTROnOpen := False;
  FRTSOnOpen := False;
  FTimerClose := TTimer.Create(Self);
  FTimerClose.Enabled := False;
  FTimerClose.Interval := 10;
  FTimerClose.OnTimer := @OnTimerClose;
  FNoError := True;
end;

destructor TRS232Port.Destroy;
begin
  if FActive then
    ClosePortAndThreads;
  FTimerClose.Free;
  inherited Destroy;
end;

procedure TRS232Port.Open;
var
  SysErrCode: longint;
  ErrType: integer;
  Flags: longword;
  AccessSignalsDCE: boolean;
  {$IFDEF LINUX}
  Tios: Termios;
  HPipe: TFilDes;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  DCB: TDCB;
  Timeouts: TCOMMTIMEOUTS;
  HLib: THandle;
  {$ENDIF}
begin
  if not FActive then
  begin
    {$IFDEF LINUX}
    FHandle := FpOpen(RS232LongName(FSettingsForOpen.Device),
      O_RDWR or O_NONBLOCK or O_NOCTTY);
    if FHandle = -1 then
    begin
      SysErrCode := fpgeterrno;
      case SysErrCode of
        ESysENOENT, ESysEISDIR: ErrType := RS232ErrNotExist;
        ESysEACCES: ErrType := RS232ErrPermissionDenied;
        ESysEBUSY: ErrType := RS232ErrDeviceBusy;
        else
          ErrType := RS232ErrOtherError;
      end;
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        ErrType, SysErrCode);
    end;
    if TCGetAttr(FHandle, Tios{%H-}) = -1 then
    begin
      SysErrCode := fpgeterrno;
      FpClose(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrSettingsNotSupport, SysErrCode);
    end;
    if FpIOCtl(FHandle, TIOCEXCL, nil) = -1 then
    begin
      SysErrCode := fpgeterrno;
      FpClose(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrSettingsNotSupport, SysErrCode);
    end;
    Flags := TIOCM_DTR or TIOCM_RTS;
    FpIOCtl(FHandle, TIOCMBIC, @Flags);
    Tios.c_iflag := Tios.c_iflag and not (IGNBRK or BRKINT or
      IGNPAR or PARMRK or INLCR or ICRNL or IXON or IXOFF or IXANY);
    if FSettingsForOpen.Parity <> pNone then
      Tios.c_iflag := Tios.c_iflag or INPCK
    else
      Tios.c_iflag := Tios.c_iflag and not INPCK;
    if FSettingsForOpen.ByteSize <> bs8bits then
      Tios.c_iflag := Tios.c_iflag or ISTRIP
    else
      Tios.c_iflag := Tios.c_iflag and not ISTRIP;
    Tios.c_oflag := Tios.c_oflag and not OPOST;
    Tios.c_cflag := Tios.c_cflag or CREAD or HUPCL or CLOCAL;
    Tios.c_cflag := Tios.c_cflag and not CSIZE;
    Tios.c_cflag := Tios.c_cflag or ArrByteSize[FSettingsForOpen.ByteSize];
    Tios.c_cflag := Tios.c_cflag and not (PARENB or PARODD or CMSPAR);
    case FSettingsForOpen.Parity of
      pOdd: Tios.c_cflag := Tios.c_cflag or PARENB or PARODD;
      pEven: Tios.c_cflag := Tios.c_cflag or PARENB;
      pMark: Tios.c_cflag := Tios.c_cflag or PARENB or PARODD or CMSPAR;
      pSpace: Tios.c_cflag := Tios.c_cflag or PARENB or CMSPAR;
    end;
    if FSettingsForOpen.StopBits = sbTwo then
      Tios.c_cflag := Tios.c_cflag or CSTOPB
    else
      Tios.c_cflag := Tios.c_cflag and not CSTOPB;
    if FSettingsForOpen.FlowControl = fcRtsCts then
      Tios.c_cflag := Tios.c_cflag or CRTSCTS
    else
      Tios.c_cflag := Tios.c_cflag and not CRTSCTS;
    Tios.c_lflag := Tios.c_lflag and not (ISIG or ICANON or ECHO or IEXTEN);
    tios.c_cc[VMIN] := 0;
    tios.c_cc[VTIME] := 0;
    CFSetOSpeed(Tios, ArrBaudRate[FSettingsForOpen.BaudRate]);
    CFSetISpeed(Tios, ArrBaudRate[FSettingsForOpen.BaudRate]);
    if TCSetAttr(FHandle, TCSANOW, Tios{%H-}) = -1 then
    begin
      SysErrCode := fpgeterrno;
      FpClose(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrSettingsNotSupport, SysErrCode);
    end;
    if FClearOnOpen then
      if TCFlush(FHandle, TCIOFLUSH) = -1 then
        NotifySystemFault('TCFlush', fpgeterrno, True);
    if FpIOCtl(FHandle, TIOCMGET, @Flags) = -1 then
    begin
      if FSettingsForOpen.SignalPolling then
      begin
        SysErrCode := fpgeterrno;
        FpClose(FHandle);
        raise ERS232OpenError.Create(FSettingsForOpen.Device,
          RS232ErrSignalPollNotSupport, SysErrCode);
      end
      else
        AccessSignalsDCE := False;
    end
    else
      AccessSignalsDCE := True;
    if (FpPipe(HPipe{%H-}) = -1) or
      (FpFcntl(HPipe[0], F_SetFl, O_NONBLOCK) = -1) or
      (FpFcntl(HPipe[1], F_SetFl, O_NONBLOCK) = -1) then
    begin
      SysErrCode := fpgeterrno;
      FpClose(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrPipeNotCreated, SysErrCode);
    end;
    FHCommWrite1 := HPipe[1];
    FHCommWrite2 := HPipe[0];
    if (FpPipe(HPipe{%H-}) = -1) or
      (FpFcntl(HPipe[0], F_SetFl, O_NONBLOCK) = -1) or
      (FpFcntl(HPipe[1], F_SetFl, O_NONBLOCK) = -1) then
    begin
      SysErrCode := fpgeterrno;
      FpClose(FHCommWrite2);
      FpClose(FHCommWrite1);
      FpClose(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrPipeNotCreated, SysErrCode);
    end;
    FHCommRead1 := HPipe[1];
    FHCommRead2 := HPipe[0];
    try
      FThreadWrite := TRS232ThreadWrite.Create(FHandle, FHCommWrite1,
        FHCommWrite2, @FBufferForWrite, FSettingsForOpen.TimeoutWrite);
    except
      on E: ERS232OpenError do
      begin
        FpClose(FHCommWrite1);
        FpClose(FHCommWrite2);
        FpClose(FHCommRead1);
        FpClose(FHCommRead2);
        FpClose(FHandle);
        raise ERS232OpenError.Create(FSettingsForOpen.Device,
          E.ErrorCode, E.SystemErrorCode);
      end;
    end;
    FThreadWrite.OnSystemFault := @OnThreadSystemFault;
    FThreadWrite.OnWritingProcess := @OnThreadWritingProcess;
    try
      FThreadRead := TRS232ThreadRead.Create(FHandle, FHCommRead1, FHCommRead2);
    except
      on E: ERS232OpenError do
      begin
        FThreadWrite.Free;
        FpClose(FHCommWrite1);
        FpClose(FHCommWrite2);
        FpClose(FHCommRead1);
        FpClose(FHCommRead2);
        FpClose(FHandle);
        raise ERS232OpenError.Create(FSettingsForOpen.Device,
          E.ErrorCode, E.SystemErrorCode);
      end;
    end;
    FThreadRead.OnSystemFault := @OnThreadSystemFault;
    FThreadRead.OnReadingProcess := @OnThreadReadingProcess;
    if FSettingsForOpen.SignalPolling then
    begin
      try
        FThreadSignals := TRS232ThreadSignals.Create(FHandle);
      except
        on E: ERS232OpenError do
        begin
          FThreadWrite.Free;
          FThreadRead.Free;
          FpClose(FHCommWrite1);
          FpClose(FHCommWrite2);
          FpClose(FHCommRead1);
          FpClose(FHCommRead2);
          FpClose(FHandle);
          raise ERS232OpenError.Create(FSettingsForOpen.Device,
            E.ErrorCode, E.SystemErrorCode);
        end;
      end;
      FThreadSignals.OnSystemFault := @OnThreadSystemFault;
      FThreadSignals.OnSignalStatus := @OnThreadSignalStatus;
    end;
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    FHandle := CreateFile(PChar(RS232LongName(FSettingsForOpen.Device)),
      GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING,
      FILE_FLAG_OVERLAPPED, 0);
    if FHandle = INVALID_HANDLE_VALUE then
    begin
      SysErrCode := GetLastError;
      case SysErrCode of
        ERROR_FILE_NOT_FOUND, ERROR_PATH_NOT_FOUND, ERROR_INVALID_NAME,
        ERROR_BAD_PATHNAME: ErrType := RS232ErrNotExist;
        ERROR_ACCESS_DENIED, ERROR_SHARING_VIOLATION: ErrType :=
            RS232ErrDeviceBusy;
        else
          ErrType := RS232ErrOtherError;
      end;
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        ErrType, SysErrCode);
    end;
    if not GetCommState(FHandle, DCB{%H-}) then
    begin
      SysErrCode := GetLastError;
      CloseHandle(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrSettingsNotSupport, SysErrCode);
    end;
    DCB.BaudRate := ArrBaudRate[FSettingsForOpen.BaudRate];
    DCB.flags := 0;
    set_fBinary(DCB, 1);
    if FSettingsForOpen.Parity <> pNone then
    begin
      set_fParity(DCB, 1);
      set_fErrorChar(DCB, 1);
    end;
    if FSettingsForOpen.FlowControl = fcRtsCts then
    begin
      set_fOutxCtsFlow(DCB, 1);
      set_fRtsControl(DCB, RTS_CONTROL_HANDSHAKE);
    end;
    DCB.ByteSize := ArrByteSize[FSettingsForOpen.ByteSize];
    DCB.Parity := ArrParity[FSettingsForOpen.Parity];
    DCB.StopBits := ArrStopBits[FSettingsForOpen.StopBits];
    DCB.ErrorChar := #0;
    if not SetCommState(FHandle, DCB) then
    begin
      SysErrCode := GetLastError;
      CloseHandle(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrSettingsNotSupport, SysErrCode);
    end;
    Timeouts.ReadIntervalTimeout := MAXDWORD;
    Timeouts.ReadTotalTimeoutMultiplier := MAXDWORD;
    Timeouts.ReadTotalTimeoutConstant := MAXLONG;
    Timeouts.WriteTotalTimeoutMultiplier := 0;
    Timeouts.WriteTotalTimeoutConstant := 0;
    if not SetCommTimeouts(FHandle, Timeouts) then
    begin
      SysErrCode := GetLastError;
      CloseHandle(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrSettingsNotSupport, SysErrCode);
    end;
    if FClearOnOpen then
      if not PurgeComm(FHandle, PURGE_TXCLEAR or PURGE_RXCLEAR) then
        NotifySystemFault('PurgeComm', GetLastError, True);
    if not GetCommModemStatus(FHandle, @Flags) then
    begin
      if FSettingsForOpen.SignalPolling then
      begin
        SysErrCode := GetLastError;
        CloseHandle(FHandle);
        raise ERS232OpenError.Create(FSettingsForOpen.Device,
          RS232ErrSignalPollNotSupport, SysErrCode);
      end
      else
        AccessSignalsDCE := False;
    end
    else
      AccessSignalsDCE := True;
    FHCommWrite1 := CreateEvent(nil, True, False, nil);
    if FHCommWrite1 = 0 then
    begin
      SysErrCode := GetLastError;
      CloseHandle(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrEventNotCreated, SysErrCode);
    end;
    FHCommWrite2 := CreateEvent(nil, True, False, nil);
    if FHCommWrite2 = 0 then
    begin
      SysErrCode := GetLastError;
      CloseHandle(FHCommWrite1);
      CloseHandle(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrEventNotCreated, SysErrCode);
    end;
    FHCommRead1 := CreateEvent(nil, True, False, nil);
    if FHCommRead1 = 0 then
    begin
      SysErrCode := GetLastError;
      CloseHandle(FHCommWrite1);
      CloseHandle(FHCommWrite2);
      CloseHandle(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrEventNotCreated, SysErrCode);
    end;
    FHCommRead2 := CreateEvent(nil, True, False, nil);
    if FHCommRead2 = 0 then
    begin
      SysErrCode := GetLastError;
      CloseHandle(FHCommWrite1);
      CloseHandle(FHCommWrite2);
      CloseHandle(FHCommRead1);
      CloseHandle(FHandle);
      raise ERS232OpenError.Create(FSettingsForOpen.Device,
        RS232ErrEventNotCreated, SysErrCode);
    end;
    try
      FThreadWrite := TRS232ThreadWrite.Create(FHandle, FHCommWrite1,
        FHCommWrite2, @FBufferForWrite, FSettingsForOpen.TimeoutWrite);
    except
      on E: ERS232OpenError do
      begin
        CloseHandle(FHCommWrite1);
        CloseHandle(FHCommWrite2);
        CloseHandle(FHCommRead1);
        CloseHandle(FHCommRead2);
        CloseHandle(FHandle);
        raise ERS232OpenError.Create(FSettingsForOpen.Device,
          E.ErrorCode, E.SystemErrorCode);
      end;
    end;
    FThreadWrite.OnSystemFault := @OnThreadSystemFault;
    FThreadWrite.OnWritingProcess := @OnThreadWritingProcess;
    try
      FThreadRead := TRS232ThreadRead.Create(FHandle, FHCommRead1, FHCommRead2);
    except
      on E: ERS232OpenError do
      begin
        FThreadWrite.Free;
        CloseHandle(FHCommWrite1);
        CloseHandle(FHCommWrite2);
        CloseHandle(FHCommRead1);
        CloseHandle(FHCommRead2);
        CloseHandle(FHandle);
        raise ERS232OpenError.Create(FSettingsForOpen.Device,
          E.ErrorCode, E.SystemErrorCode);
      end;
    end;
    FThreadRead.OnSystemFault := @OnThreadSystemFault;
    FThreadRead.OnReadingProcess := @OnThreadReadingProcess;
    if FSettingsForOpen.SignalPolling then
    begin
      try
        FThreadSignals := TRS232ThreadSignals.Create(FHandle);
      except
        on E: ERS232OpenError do
        begin
          FThreadWrite.Free;
          FThreadRead.Free;
          CloseHandle(FHCommWrite1);
          CloseHandle(FHCommWrite2);
          CloseHandle(FHCommRead1);
          CloseHandle(FHCommRead2);
          CloseHandle(FHandle);
          raise ERS232OpenError.Create(FSettingsForOpen.Device,
            E.ErrorCode, E.SystemErrorCode);
        end;
      end;
      FThreadSignals.OnSystemFault := @OnThreadSystemFault;
      FThreadSignals.OnSignalStatus := @OnThreadSignalStatus;
    end;
    {$ENDIF}
    FWorkSettings := FSettingsForOpen;
    FActive := True;
    FNoError := True;
    FWorkProcess := True;
    FillChar(FSignalsDTE, SizeOf(FSignalsDTE), 0);
    if AccessSignalsDCE then
      FillChar(FSignalsDCE, SizeOf(FSignalsDCE), 0)
    else
    begin
      FSignalsDCE.DCD := $FF;
      FSignalsDCE.DSR := $FF;
      FSignalsDCE.CTS := $FF;
      FSignalsDCE.RI := $FF;
    end;
    SetStatusDTR(FDTROnOpen);
    if FSignalsDTE.DTR <> 1 then
      NotifySignalStatus(RS232PinDTR, FSignalsDTE.DTR);
    if FWorkSettings.FlowControl = fcRtsCts then
    begin
      FSignalsDTE.RTS := 2;
      {$IFDEF LINUX}
      FThreadWrite.CheckCTS := True;
      {$ENDIF}
      {$IFDEF MSWINDOWS}
      HLib := LoadLibrary('ntdll.dll');
      if HLib > 0 then
      begin
        if Assigned(GetProcAddress(HLib, 'wine_get_version')) then
          FThreadWrite.CheckCTS := True;
        FreeLibrary(HLib);
      end;
      {$ENDIF}
    end
    else
      SetStatusRTS(FRTSOnOpen);
    if FSignalsDTE.RTS <> 1 then
      NotifySignalStatus(RS232PinRTS, FSignalsDTE.RTS);
    FThreadWrite.Start;
    FThreadRead.Start;
    if FWorkSettings.SignalPolling then
    begin
      NotifySignalsDCEStatus;
      FThreadSignals.Start;
    end;
    if Assigned(FOnAfterOpen) then
      FOnAfterOpen(Self);
  end;
end;

procedure TRS232Port.Close;
begin
  if FActive then
  begin
    FWorkProcess := False;
    ClosePortAndThreads;
    FillChar(FSignalsDTE, SizeOf(FSignalsDTE), 0);
    FillChar(FSignalsDCE, SizeOf(FSignalsDCE), 0);
    NotifySignalStatus(RS232PinDTR, FSignalsDTE.DTR);
    NotifySignalStatus(RS232PinRTS, FSignalsDTE.RTS);
    if FWorkSettings.SignalPolling then
      NotifySignalsDCEStatus;
    if Assigned(FOnAfterClose) then
      FOnAfterClose(Self, FNoError);
  end;
end;

function TRS232Port.BaudRateToInt(BaudRate: TRS232EnumBaudRate): integer;
begin
  case BaudRate of
    br001200: Result := 1200;
    br002400: Result := 2400;
    br004800: Result := 4800;
    br009600: Result := 9600;
    br019200: Result := 19200;
    br038400: Result := 38400;
    br057600: Result := 57600;
    br115200: Result := 115200;
  end;
end;

function TRS232Port.ByteSizeToInt(ByteSize: TRS232EnumByteSize): integer;
begin
  case ByteSize of
    bs7bits: Result := 7;
    bs8bits: Result := 8;
  end;
end;

function TRS232Port.ParityToChar(Parity: TRS232EnumParity): char;
begin
  case Parity of
    pNone: Result := 'N';
    pOdd: Result := 'O';
    pEven: Result := 'E';
    pMark: Result := 'M';
    pSpace: Result := 'S';
  end;
end;

function TRS232Port.StopBitsToInt(StopBits: TRS232EnumStopBits): integer;
begin
  case StopBits of
    sbOne: Result := 1;
    sbTwo: Result := 2;
  end;
end;

function TRS232Port.InfoPortSettings: string;
var
  Settings: TRS232Settings;
begin
  if FActive then
    Settings := FWorkSettings
  else
    Settings := FSettingsForOpen;
  Result := RS232ShortName(Settings.Device) + ' ' + Format('%d/%d-%s-%d',
    [BaudRateToInt(Settings.BaudRate), ByteSizeToInt(Settings.ByteSize),
    ParityToChar(Settings.Parity), StopBitsToInt(Settings.StopBits)]);
  if Settings.FlowControl = fcRtsCts then
    Result := Result + ' RTS/CTS';
end;

function TRS232Port.SetStatusDTR(Enabled: boolean): longint;
{$IFDEF LINUX}
var
  Flag: longword;
{$ENDIF}
begin
  {$IFDEF LINUX}
  Flag := TIOCM_DTR;
  {$ENDIF}
  if FActive then
  begin
    if Enabled then
    begin
      {$IFDEF LINUX}
      if FpIOCtl(FHandle, TIOCMBIS, @Flag) = -1 then
        Result := fpgeterrno
      else
        Result := 0;
      {$ENDIF}
      {$IFDEF MSWINDOWS}
      if EscapeCommFunction(FHandle, SETDTR) then
        Result := 0
      else
        Result := GetLastError;
      {$ENDIF}
    end
    else
    begin
      {$IFDEF LINUX}
      if FpIOCtl(FHandle, TIOCMBIC, @Flag) = -1 then
        Result := fpgeterrno
      else
        Result := 0;
      {$ENDIF}
      {$IFDEF MSWINDOWS}
      if EscapeCommFunction(FHandle, CLRDTR) then
        Result := 0
      else
        Result := GetLastError;
      {$ENDIF}
    end;
    if Result = 0 then
    begin
      if (FSignalsDTE.DTR <> ifthen(Enabled, 1, 0)) then
      begin
        FSignalsDTE.DTR := ifthen(Enabled, 1, 0);
        NotifySignalStatus(RS232PinDTR, FSignalsDTE.DTR);
      end;
    end
    else
      FSignalsDTE.DTR := $FF;
  end
  else
    Result := -1;
end;

function TRS232Port.SetStatusRTS(Enabled: boolean): longint;
{$IFDEF LINUX}
var
  Flag: longword;
{$ENDIF}
begin
  {$IFDEF LINUX}
  Flag := TIOCM_RTS;
  {$ENDIF}
  if FActive and (FWorkSettings.FlowControl = fcNone) then
  begin
    if Enabled then
    begin
      {$IFDEF LINUX}
      if FpIOCtl(FHandle, TIOCMBIS, @Flag) = -1 then
        Result := fpgeterrno
      else
        Result := 0;
      {$ENDIF}
      {$IFDEF MSWINDOWS}
      if EscapeCommFunction(FHandle, SETRTS) then
        Result := 0
      else
        Result := GetLastError;
      {$ENDIF}
    end
    else
    begin
      {$IFDEF LINUX}
      if FpIOCtl(FHandle, TIOCMBIC, @Flag) = -1 then
        Result := fpgeterrno
      else
        Result := 0;
      {$ENDIF}
      {$IFDEF MSWINDOWS}
      if EscapeCommFunction(FHandle, CLRRTS) then
        Result := 0
      else
        Result := GetLastError;
      {$ENDIF}
    end;
    if Result = 0 then
    begin
      if (FSignalsDTE.RTS <> ifthen(Enabled, 1, 0)) then
      begin
        FSignalsDTE.RTS := ifthen(Enabled, 1, 0);
        NotifySignalStatus(RS232PinRTS, FSignalsDTE.RTS);
      end;
    end
    else
      FSignalsDTE.RTS := $FF;
  end
  else
    Result := -1;
end;

function TRS232Port.GetStatusSignalsDCE: longint;
var
  Flags: longword;
begin
  if FActive then
  begin
    Flags := 0;
    {$IFDEF LINUX}
    if FpIOCtl(FHandle, TIOCMGET, @Flags) = -1 then
      Result := fpgeterrno
    else
    begin
      FSignalsDCE.DCD := ifthen((Flags and TIOCM_CD) <> 0, 1, 0);
      FSignalsDCE.DSR := ifthen((Flags and TIOCM_DSR) <> 0, 1, 0);
      FSignalsDCE.CTS := ifthen((Flags and TIOCM_CTS) <> 0, 1, 0);
      FSignalsDCE.RI := ifthen((Flags and TIOCM_RI) <> 0, 1, 0);
      Result := 0;
    end;
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    if GetCommModemStatus(FHandle, @Flags) then
    begin
      FSignalsDCE.DCD := ifthen((Flags and MS_RLSD_ON) <> 0, 1, 0);
      FSignalsDCE.DSR := ifthen((Flags and MS_DSR_ON) <> 0, 1, 0);
      FSignalsDCE.CTS := ifthen((Flags and MS_CTS_ON) <> 0, 1, 0);
      FSignalsDCE.RI := ifthen((Flags and MS_RING_ON) <> 0, 1, 0);
      Result := 0;
    end
    else
      Result := GetLastError;
    {$ENDIF}
    if Result <> 0 then
    begin
      FSignalsDCE.DCD := $FF;
      FSignalsDCE.DSR := $FF;
      FSignalsDCE.CTS := $FF;
      FSignalsDCE.RI := $FF;
    end;
  end
  else
    Result := -1;
end;

function TRS232Port.IsWriteInProgress: boolean;
begin
  Result := FActive and FThreadWrite.InProgress;
end;

function TRS232Port.WriteData(ByteStr: ShortString): boolean;
begin
  Result := FActive and not IsWriteInProgress and (Ord(ByteStr[0]) > 0);
  if Result then
  begin
    FBufferForWrite := ByteStr;
    FThreadWrite.WriteBuffer;
  end;
end;

procedure TRS232Port.BreakWrite;
{$IFDEF LINUX}
var
  Msg: char;
{$ENDIF}
begin
  if IsWriteInProgress then
  begin
    {$IFDEF LINUX}
    Msg := RS232MsgBreakWrite;
    FpWrite(FHCommWrite1, Msg, 1);
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    SetEvent(FHCommWrite2);
    {$ENDIF}
  end;
end;

procedure TRS232Port.NotifySignalsDCEStatus;
begin
  if Assigned(FOnSignalStatus) then
  begin
    FOnSignalStatus(Self, RS232PinDCD, FSignalsDCE.DCD);
    FOnSignalStatus(Self, RS232PinDSR, FSignalsDCE.DSR);
    FOnSignalStatus(Self, RS232PinCTS, FSignalsDCE.CTS);
    FOnSignalStatus(Self, RS232PinRI, FSignalsDCE.RI);
  end;
end;

procedure TRS232Port.NotifySignalStatus(Pin, Status: integer);
begin
  if Assigned(FOnSignalStatus) then
    FOnSignalStatus(Self, Pin, Status);
end;

procedure TRS232Port.NotifySystemFault(FuncName: string; SysErrCode: longint;
  OnlyWarning: boolean);
begin
  if Assigned(FOnSystemFault) then
    FOnSystemFault(Self, RS232IdThreadPrimary, FuncName, SysErrCode,
      OnlyWarning);
end;

procedure TRS232Port.OnThreadSignalStatus(Pin, Status: integer);
begin
  case Pin of
    RS232PinDCD: FSignalsDCE.DCD := Status;
    RS232PinDSR: FSignalsDCE.DSR := Status;
    RS232PinCTS: FSignalsDCE.CTS := Status;
    RS232PinRI: FSignalsDCE.RI := Status;
  end;
  if FWorkProcess and Assigned(FOnSignalStatus) then
    FOnSignalStatus(Self, Pin, Status);
end;

procedure TRS232Port.OnThreadSystemFault(IdThread: char; FuncName: string;
  SysErrCode: longint; OnlyWarning: boolean);
begin
  if FWorkProcess then
  begin
    if Assigned(FOnSystemFault) then
      FOnSystemFault(Self, IdThread, FuncName, SysErrCode, OnlyWarning);
    if not OnlyWarning then
    begin
      FWorkProcess := False;
      FNoError := False;
      FTimerClose.Enabled := True;
    end;
  end;
end;

procedure TRS232Port.OnThreadWritingProcess(Status, NBytes: integer;
  Data: ShortString);
begin
  if FWorkProcess and Assigned(FOnWritingProcess) then
    FOnWritingProcess(Self, Status, NBytes, Data);
end;

procedure TRS232Port.OnThreadReadingProcess(Status, NBytes: integer;
  Data: ShortString);
begin
  if FWorkProcess and Assigned(FOnReadingProcess) then
    FOnReadingProcess(Self, Status, NBytes, Data);
end;

function TRS232Port.GetSysErrCode: longint;
begin
  {$IFDEF LINUX}
  Result := fpgeterrno;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Result := GetLastError;
  {$ENDIF}
end;

procedure TRS232Port.CloseDescriptor(Descriptor: THandle);
begin
  {$IFDEF LINUX}
  FpClose(Descriptor);
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  CloseHandle(Descriptor);
  {$ENDIF}
end;

procedure TRS232Port.ClosePortAndThreads;
begin
  FThreadWrite.Free;
  FThreadRead.Free;
  if FWorkSettings.SignalPolling then
    FThreadSignals.Free;
  CloseDescriptor(FHCommWrite1);
  CloseDescriptor(FHCommWrite2);
  CloseDescriptor(FHCommRead1);
  CloseDescriptor(FHCommRead2);
  CloseDescriptor(FHandle);
  FActive := False;
end;

procedure TRS232Port.OnTimerClose(Sender: TObject);
begin
  FTimerClose.Enabled := False;
  Close;
end;

procedure Register;
begin
  {$I rs232port_icon.lrs}
  RegisterComponents('ModRW', [TRS232Port]);
end;

end.

