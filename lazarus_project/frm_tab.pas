unit frm_tab;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,    sockets ;

type



  TForm2 = class(TForm)
    btRequest: TButton;
    Button2: TButton;
    m: TMemo;
    procedure btRequestClick(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;
  ctr:byte;



  const
  Buf_req: array [0..11] of byte  =($00 ,$8F ,$00 ,$00 ,$00 ,$06 ,$01 ,$03 ,$00 ,$00 ,$00 ,$15 );
  const  buf_read_coils:array [0..11] of byte= ($09 ,$4F ,$00 ,$00 ,$00 ,$06 ,$01    ,$01    ,$00 ,$00 ,$00 ,  $40  );


  var
     buf_recv: array [0..999] of byte;
     recv_size:integer;

     s_ains, s_coils : String;

implementation     uses unit1, hydr_utils;

{$R *.lfm}



procedure TForm2.btRequestClick(Sender: TObject);



  procedure PError(const S: string);
  var
    ErrorMsg: string;
  begin
    case socketerror of
      EsockADDRINUSE: ErrorMsg := 'Error number when socket address is already in use';
      EsockEACCESS: ErrorMsg := 'Access forbidden error';
      EsockEBADF: ErrorMsg := 'Alias: bad file descriptor';
      EsockEFAULT: ErrorMsg := 'Alias: an error occurred';
      EsockEINTR: ErrorMsg := 'Alias : operation interrupted';
      EsockEINVAL: ErrorMsg := 'Alias: Invalid value specified';
      EsockEMFILE: ErrorMsg := 'Error code ?';
      EsockEMSGSIZE: ErrorMsg := 'Wrong message size error';
      EsockENOBUFS: ErrorMsg := 'No buffer space available error';
      EsockENOTCONN: ErrorMsg := 'Not connected error';
      EsockENOTSOCK: ErrorMsg := 'File descriptor is not a socket error';
      EsockEPROTONOSUPPORT: ErrorMsg := 'Protocol not supported error';
      EsockEWOULDBLOCK: ErrorMsg := 'Operation would block error';
      else
        ErrorMsg := 'Undescribed error : ' + IntToStr(socketerror);
    end;
    writeln(S, ErrorMsg);
  end;

var

  SockDesc: longint;

  SockAddr: TInetSockAddr;

  i: longint;
  Result, RecvSize: longint;
   s:string;
   bhi,blo:byte;
   val:integer;
   fval:Double;
   lb:TLabel;

   s10:string;

   const buf:array [0..11] of byte=(   00 ,$B0 ,$00 ,$00 ,$00 ,$06 ,$01 ,$05 ,$00 ,$00 ,$FF ,$00);
     Buffer: array [0..11] of byte  =($00 ,$8F ,$00 ,$00 ,$00 ,$06 ,$01 ,$03 ,$00 ,$00 ,$00 ,$15 );  //char;

begin

  RecvSize:=0;
  m.Lines.Clear;
  try
  ctr:=ctr+1;
  buffer[1]:=ctr;
  buf[1]:=ctr;

  SockDesc := fpSocket(AF_INET, SOCK_STREAM, 0);
  if SockDesc = -1 then
    Perror('[Client] Socket : ');
  SockAddr.sin_family := AF_INET;

  SockAddr.sin_port := htons(502);

  SockAddr.sin_addr := StrToNetAddr('10.0.6.10');

  if fpconnect(SockDesc, @SockAddr, SizeOf(SockAddr)) = -1 then
     PError('[Client] Connect : ');

  begin

    if sender=btRequest then
     begin

       Move(buf_req,buffer,sizeof(buffer));
     Result := fpsend(SockDesc, @Buffer, 12,0);


     end
    else
     begin
       if sender=nil then
        begin
          buf[9]:=0;
     Result := fpsend(SockDesc, @Buf, 13 ,1)
        end
       else if sender = tobject(1) then
        begin
          buf[9]:=1;
          Result := fpsend(SockDesc, @Buf, 13 ,1);
        end
       else if sender = tobject(2) then
        begin
          buf[9]:=2;
          Result := fpsend(SockDesc, @Buf, 13 ,1);
        end
       else if sender = tobject(3) then
        begin
          buf[9]:=3;
          Result := fpsend(SockDesc, @Buf, 13 ,1);
        end
       else if sender = tobject(30) then
        begin
            Move(buf_read_coils ,buffer,sizeof(buffer));
            Result := fpsend(SockDesc, @Buffer, 12,0);

        end;



     end;

    if Result <> SizeOf(Buffer) then
      PError('[Client] Send : ');
    sleep(5);

    RecvSize := fprecv(SockDesc, @Buffer, 255, 0);
    recv_size:=recvSize ;
    Move(buffer,buf_recv, recv_size);
  end;

  m.Lines.Add(inttostr(recvSize));
  s:='';
  for i:=0 to recvSize-1 do
   begin
    s:=s+IntToHex(integer(buffer[i]),2)+' ';


   end;
  m.Lines.Add('received: ');
  m.Lines.Add(s);





  if sender=btRequest then
   begin

  s_ains:=    buf_to_archstr(buffer,RecvSize);


  s10:=s_ains;
  m.Lines.Add('arc '+ s10);
   for i:=0 to 20 do
    begin
    bhi:=byte(buffer[9+i*2]);
    blo:=byte(buffer[10+i*2]);

    if (bhi and $80)=0 then
     begin
     val:= ((bhi shl 8) and $ff00) or blo;

     end
    else
     begin
     val:= (((bhi and $7F) shl 8) and $ff00) or blo  ;
     val:= val -  32768;
     end;


    fval:=val *factors[i+1]  /10.0;
    m.Lines.Add(inttostr(i+1)+' : '+inttostr(val));

    lb:=tlabel(gettagcontrol(TLabel, 100+i+1));
    lb.Caption:=  formatfloat(formats[i+1] ,fval);

    end;

   end;

  if fpshutdown(SockDesc, 2) = -1 then
    PError('[Client] Shutdown : ');

  if CloseSocket(SockDesc) = -1 then
    PError('[Client] Close : ');


  except
  end;

  if recvSize>0 then
    begin


    end;



end;


end.

