(**********************************************************************)
(*                                                                    *)
(*                     Malte System/BIOS Printer                      *)
(*                            1992/11/15                              *)
(*                                                                    *)
(*             Copyright (C) par les Chevaliers de Malte              *)
(*                                                                    *)
(**********************************************************************)

Unit BIOS_PRN;

(**********************************************************************)
                              INTERFACE
(**********************************************************************)

Const

      LPT1   = 0;
      LPT2   = 1;
      LPT3   = 2;
      LPT4   = 3;

      ACK    = #06;
      BEL    = #07;
      BELL   = BEL;
      BS     = #08;
      CAN    = #24;
      CR     = #13;
      CRLF   = CR + #10;
      DC1    = #17;
      DC2    = #18;
      DC3    = #19;
      DC4    = #20;
      DLE    = #16;
      EM     = #25;
      ENQ    = #05;
      EOT    = #04;
      ESC    = #27;
      ESCAPE = #27;
      ETB    = #23;
      ETX    = #03;
      FF     = #12;
      FS     = #28;
      GS     = #29;
      HT     = #09;
      LF     = #10;
      NAK    = #21;
      NUL    = #00;
      RS     = #30;
      SI     = #15;
      SO     = #14;
      SOH    = #01;
      SPC    = #32; 
      STX    = #02;
      SUB    = #26;
      SYN    = #22;
      US     = #31;
      VT     = #11;

Var

    PrinterError : Byte;
    PRN          : Byte;

Function Print(Chaine:String;Numero:Word):Boolean;
Function PrintChar(Chr:Char;Numero:Word):Boolean;
Function PrintLn(Chaine:String;Numero:Word):Boolean;
Function CheckPrinter(Numero:Word):Boolean;

(**********************************************************************)
                            IMPLEMENTATION
(**********************************************************************)

Function PrintChar(Chr:Char;Numero:Word):Boolean;
Var Stool : Byte;
Begin
 ASM
  XOR AH,AH;
  MOV AL,Chr;
  MOV DX,Numero;
  INT $17;
  MOV Stool,AH;
 END;
 If((Stool and $21) <> 0)Then
 Begin
  PrinterError := Stool;
  PrintChar := False;
 End
  else
 PrintChar := True;
End;

Function Print(Chaine:String;Numero:Word):Boolean;
Var I  : Byte;
    Ok : Boolean;
Begin
 I := 1;
 Repeat
  Ok := PrintChar(Chaine[I],Numero);
  Inc(I);
 Until Not(Ok) or (I > Length(Chaine));
 Print := Ok;
End;

Function PrintLn(Chaine:String;Numero:Word):Boolean;
Begin
 PrintLn := Print(Chaine + CRLF,Numero);
End;

Function CheckPrinter(Numero:Word):Boolean;
Var Stool : Byte;
Begin
 ASM
  MOV AH,$02;
  MOV DX,Numero;
  INT $17;
  MOV Stool,AH;
 END;
 If(Stool <> $90)Then
 Begin
  PrinterError := Stool;
  CheckPrinter := False;
 End
  else
 CheckPrinter := True;
End;

BEGIN { Main Unit }
 PrinterError := 0;
 PRN          := LPT1;
END.