{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit RS232PortPackage;

interface

uses
  RS232Port, RS232Except, RS232Names, RS232Thread, RS232Write, RS232Read, 
  RS232Signals, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('RS232Port', @RS232Port.Register);
end;

initialization
  RegisterPackage('RS232PortPackage', @Register);
end.
