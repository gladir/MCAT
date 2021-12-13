(********************************************************)
(*                                                      *)
(*                Malte System/Printer                  *)
(*                     1993/01/26                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit PRNT;

(********************************************************)
                       INTERFACE
(********************************************************)

Procedure Print(Msg:String);
Procedure PrintLn(Msg:String);
Procedure SetPrinter(Number:Word);

Function CheckPrinter:Boolean;
Function GetPrinter:Word;

(********************************************************)
                    IMPLEMENTATION
(********************************************************)

Uses BIOS_PRN;

Procedure Print(Msg:String);
Var Result : Boolean;
Begin
 Result := BIOS_PRN.Print(Msg,BIOS_PRN.PRN);
End;

Procedure PrintLn(Msg:String);
Var Result : Boolean;
Begin
 Result := BIOS_PRN.PrintLn(Msg,BIOS_PRN.PRN);
End;

Procedure SetPrinter(Number:Word);
Begin
 BIOS_PRN.PRN := Number;
End;

Function CheckPrinter:Boolean;
Var Result : Boolean;
Begin
 CheckPrinter := BIOS_PRN.CheckPrinter(BIOS_PRN.PRN);
End;

Function GetPrinter:Word;
Var Result : Boolean;
Begin
 GetPrinter := BIOS_PRN.PRN
End;

BEGIN { Main Unit }
END.