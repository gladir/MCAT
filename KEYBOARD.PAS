(**********************************************************************)
(*                                                                    *)
(*                        Malte System/Keyboard                       *)
(*                            1992/08/14                              *)
(*                                                                    *)
(*              Copyright (C) par les Chevaliers de Malte             *)
(*                                                                    *)
(**********************************************************************)

Unit KeyBoard;

(**********************************************************************)
                               INTERFACE
(**********************************************************************)

 {$I KEY_CST.INC } { Constante des touches }

 Const 

       kbDirect = $00; { 100% compatible }
       kbBIOS   = $01; { M‚thode normal }
       kbDOS    = $02; { (Windows mode/Non-compatible) }

       Extended : Boolean = False;

 Procedure PushKey(Key:Word);
 Procedure SetKeyboardMethode(Methode:Byte);

 Function GetKeyboardMethode:Byte;
 Function GetModeInsert:Boolean;
 Function KeyFlags:Byte;
 Function KeyFlagsAT:Byte;
 Function KeyPressed:Boolean;
 Function NextKey:Word;
 Function ReadKey:Word;

(**********************************************************************)
                             IMPLEMENTATION
(**********************************************************************)

Uses DirctKbd,BIOSKbd;

Const

      KeyboardMethode : Byte = kbBIOS;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      PushKey                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure PushKey(Key:Word);
Begin
 If(Extended)and(KeyBoardMethode = kbBIOS)Then
  BIOSKbd.PushKey(Key)
 Else
  DirctKbd.PushKey(Key);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 SetKeyboardMethode                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetKeyboardMethode(Methode:Byte);
Begin
 KeyboardMethode := Methode;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 GetKeyboardMethode                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetKeyboardMethode:Byte;
Begin
 GetKeyboardMethode := KeyboardMethode;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   GetModeInsert                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetModeInsert:Boolean;
Begin
 Case KeyboardMethode of
  kbDirect : GetModeInsert := DirctKbd.GetModeInsert;
        Else GetModeInsert := BIOSKbd.GetModeInsert;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     KeyFlags                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function KeyFlags:Byte;
Begin
 Case KeyboardMethode of
  kbDirect : KeyFlags := DirctKbd.KeyFlags;
        Else KeyFlags := BIOSKbd.KeyFlags;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    KeyFlagsAT                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function KeyFlagsAT:Byte;
Begin
 KeyFlagsAT := DirctKbd.KeyFlagsAT;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    KeyPressed                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function KeyPressed:Boolean;
Begin
 KeyPressed := DirctKbd.KeyPressed;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     NextKey                          ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function NextKey:Word;
Var K : Word;
Begin
 Case KeyBoardMethode of
  kbDirect : K := DirctKbd.NextKey;
        Else K := BIOSKbd.NextKey;
 End;
 If(Lo(K) = $E0)or
   (Hi(K) = Hi(kbF11))or
   (Hi(K) = Hi(kbF12))Then K := K and $FF00;
 NextKey := K;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     ReadKey                          ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function ReadKey:Word;
Var K : Word;
Begin
 Case Extended of
  True : Begin
          K := BIOSKbd.ReadKeyAT;
          If(Lo(K) = $E0)or
            (Hi(K) = Hi(kbF11))or
            (Hi(K) = Hi(kbF12))Then K := K and $FF00;
          ReadKey := K;
         End;
    Else ReadKey := BIOSKbd.ReadKey;
 End;
End;

BEGIN { Main Unit }
 If(Mem[$FFFF:$0E] = 252)Then Extended := True;
END.