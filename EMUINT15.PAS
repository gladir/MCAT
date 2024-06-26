(***************************************************************)
(*                                                             *)
(*              Malte System/Emulator Interrupt 15h            *)
(*                         1992/10/31                          *)
(*                                                             *)
(*          Copyright (C) par les Chevaliers de Malte          *)
(*                                                             *)
(***************************************************************)

Unit EmuInt15;

(***************************************************************)
                           INTERFACE
(***************************************************************)

Function AltCodeToASCII(Code:Word):Char;
Function ASCIIToAltCode(C:Char):Word;
Function ASCIIToKbdCode(C:Char):Word;
Function GetSwitchJoystick:Byte;
Function IsCtrlLetterCode(Code:Word):Boolean;
Function IsFunctionCode(Code:Word):Boolean;

(***************************************************************)
                         IMPLEMENTATION
(***************************************************************)

Uses Keyboard;

Const ShiftCode : Array['A'..'Z'] of Byte = (
                   30,48,46,32,18,33,34,35,23,36,37,38,50,
                   49,24,25,16,19,31,20,22,47,17,45,21,44
                  );

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   AltCodeToASCII                     넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function AltCodeToASCII(Code:Word):Char;
Var I : Char;
Begin
 If(Lo(Code) = 0)Then
 Begin
  For I := 'A' to 'Z' do
  Begin
   If(ShiftCode[I] = Hi(Code))Then
   Begin
    AltCodeToASCII := I;
    Exit;
   End;
   AltCodeToASCII := #0;
  End;
 End
  else
 AltCodeToASCII := #0;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   ASCIIToAltCode                     넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function ASCIIToAltCode(C:Char):Word;
Begin
 C := UpCase(C);
 If Not(C in ['A'..'Z'])Then
 Begin
  ASCIIToAltCode := 0;
  Exit;
 End;
 ASCIIToAltCode := (ShiftCode[C] shl 8);
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   ASCIIToKbdCode                     넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function ASCIIToKbdCode(C:Char):Word;
Begin
 Case UpCase(C) of
  'A'..'Z' : ASCIIToKbdCode := Byte(C) + (ShiftCode[UpCase(C)] shl 8);
   else
  ASCIIToKbdCode := 0;
 End;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    IsCtrlLetter                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function IsCtrlLetterCode(Code:Word):Boolean;
Begin
 IsCtrlLetterCode := (Lo(Code) in [1..26])and
                     (Hi(Code) = ShiftCode[Char(Lo(Code)+64)]);
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    IsFunctionCode                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function IsFunctionCode(Code:Word):Boolean;
Const Stack : Array[1..48] of Word = (
               kbF1,kbF2,kbF3,kbF4,kbF5,kbF6,kbF7,kbF8,kbF9,kbF10,kbF11,
               kbF12,kbAltF1,kbAltF2,kbAltF3,kbAltF4,kbAltF5,kbAltF6,
               kbAltF7,kbAltF8,kbAltF9,kbAltF10,kbAltF11,kbAltF12,
               kbCtrlF1,kbCtrlF2,kbCtrlF3,kbCtrlF4,kbCtrlF5,kbCtrlF6,
               kbCtrlF7,kbCtrlF8,kbCtrlF9,kbCtrlF10,kbCtrlF11,kbCtrlF12,
               kbShiftF1,kbShiftF2,kbShiftF3,kbShiftF4,kbShiftF5,kbShiftF6,
               kbShiftF7,kbShiftF8,kbShiftF9,kbShiftF10,kbShiftF11,kbShiftF12
              );
Var I : Byte;
Begin
 For I := 1 to 48 do
 Begin
  If(Stack[I] = Code)Then
  Begin
   IsFunctionCode := True;
   Exit;
  End;
 End;
 IsFunctionCode := False;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                  GetSwitchJoystick                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function GetSwitchJoystick:Byte;
Begin
 GetSwitchJoystick := Port[$201];
End;

BEGIN { Main Unit }
END.
