(***************************************************************)
(*                                                             *)
(*                      Malte System/Sound                     *)
(*                          1992/10/11                         *)
(*                                                             *)
(*          Copyright (C) par les Chevaliers de Malte          *)
(*                                                             *)
(***************************************************************)

Unit Sound;

(***************************************************************)
                           INTERFACE
(***************************************************************)

Type

      BeepType = Record
                  Sound : Word;
                  Delay : Word;
                 End;

Const

      BeepSetup : BeepType = (Sound : 1550; Delay : 20);

Procedure Beep;
Procedure PCSpeakerNoSound;
Procedure PCSpeakerSound(Frequency:Word);

(***************************************************************)
                         IMPLEMENTATION
(***************************************************************)

{$IFDEF __SYSTEMTURBO__}
 Uses Crt;
{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    PCSpeakerSound                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PCSpeakerSound(Frequency:Word);
Assembler;
ASM
 MOV  BX,frequency;
 MOV  AX,34DDh;
 MOV  DX,0012h;
 CMP  DX,BX;
 JNB  @@2;
 DIV  BX;
 MOV  BX,AX;
 IN   AL,$61;
 TEST AL,3;
 JNE  @@1;
 OR   al,3;
 OUT  $61,AL;
 MOV  AL,$B6;
 OUT  $43,AL;
@@1:
 MOV  AL,BL;
 OUT  $42,AL;
 MOV  AL,BH;
 OUT  $42,AL;
@@2:
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    PCSpeakerNoSound                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PCSpeakerNoSound;
Assembler;
ASM
 IN  AL,$61;
 AND AL,$FC;
 OUT $61,AL;
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                          Beep                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure Beep;
Var X : LongInt;
Begin
 {$IFDEF __SYSTEMTURBO__}
  CRT.Sound(BeepSetup.Sound);
  CRT.Delay(BeepSetup.Delay);
  CRT.NoSound;
 {$ELSE}
  PCSpeakerSound(BeepSetup.Sound);
  X := MemL[$0040:$6C];
  Repeat Until ((BeepSetup.Delay + X) >= MemL[$0040:$6C])or(MemL[$0040:$6C] = 0);
  PCSpeakerNoSound;
 {$ENDIF}
End;

BEGIN
END.