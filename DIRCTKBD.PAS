(********************************************************)
(*                                                      *)
(*              Malte System/Direct Keyboard            *)
(*                     1993/03/28                       *)
(*                                                      *)
(*       Copyright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Derni�re modification :

   Samedi, le 8 mai 1993     (Modification des directives de compilations
                              pour l'adaptation � l'assembler;
			      Addition des directives de compilation pour
			      les chaines de caract�re de type pointeur).
   Mercredi, le 19 mai 1993  (Adaptation au instruction du 286).

  Directive de compilation conditionnel :

   QUICKPASCAL           Indique qu'il s'agit d'un compilateur
                         QuickPascal.
   VER10                 Indique que la version du compilateur
                         est 1.0 (Pr�d�finit).
   VER15                 Indique que la version du compilateur
                         est 1.5 (Pr�d�finit).
   VER60                 Indique que la version du compilateur
                         est 6.0 (Pr�d�finit).
   VER70                 Indique que la version du compilateur
                         est 7.0 (Pr�d�finit).
   VER80                 Indique que la version du compilateur
                         est 8.0 (Pr�d�finit).
   __ASSEMBLERSUPPORT__  Indique que le compilateur support l'assembler.
                         (Pr�d�finit en fonction des autres variables).
   __OPTIMIZESIZE__      Indique qu'il faut faire en sorte que le code
                         langage machine prenne le moin de place possible.
   __STRPTRSUPPORT__     Indique que le compilateur support des variables
                         de caract�re du m�me genre que le langage C.
}

{$IFDEF VER10}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER15}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER60}
 {$DEFINE __ASSEMBLERSUPPORT__}
{$ENDIF}

{$IFDEF VER70}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
{$ENDIF}

{$IFDEF VER80}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
{$ENDIF}

Unit DirctKbd;

(********************************************************)
                      INTERFACE
(********************************************************)

Const

      FlagShiftLeftIsSet    = $01;
      FlagShiftRightIsSet   = $02;
      FlagCtrlIsSet         = $04;
      FlagAltIsSet          = $08;
      FlagScrollLockOpen    = $10;
      FlagNumLockOpen       = $20;
      FlagCapsLockOpen      = $40;
      FlagInsertOpen        = $80;

      ATFlagCtrlLeftIsSet   = $01;
      ATFlagAltLeftIsSet    = $02;
      ATFlagSysRqIsSet      = $04;
      ATFlagPauseIsSet      = $08;
      ATFlagScrollLockIsSet = $10;
      ATFlagNumLockIsSet    = $20;
      ATFlagCapsLockIsSet   = $40;
      ATFlagInsertIsSet     = $80;

      ATFlagCtrlLeft        = ATFlagCtrlLeftIsSet;
      ATFlagAltLeft         = ATFlagAltLeftIsSet;
      ATFlagSysRq           = ATFlagSysRqIsSet;
      ATFlagPause           = ATFlagPauseIsSet;
      ATFlagScrollLock      = ATFlagScrollLockIsSet;
      ATFlagNumLock         = ATFlagNumLockIsSet;
      ATFlagCapsLock        = ATFlagCapsLockIsSet;
      ATFlagInsert          = ATFlagInsertIsSet;

Procedure PushKey(Key:Word);
Procedure PushKeyXTPhoenix(Key:Word);

Function GetModeInsert:Boolean;
Function KeyFlags:Byte;
Function KeyFlagsAT:Byte;
Function KeyPressed:Boolean;
Function NextKey:Word;

(********************************************************)
                    IMPLEMENTATION
(********************************************************)

{ ������������������������������������������������������Ŀ
  �                       PushKey                        ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Procedure PushKey(Key:Word);
Var KeyTail : Word Absolute $0040:$001C;
    KeyMin  : Word Absolute $0040:$0080;
    KeyMax  : Word Absolute $0040:$0082;
Begin
 InLine($FA);
 MemW[$0040:KeyTail] := Key;
 Inc(KeyTail,2);
 If(KeyTail=KeyMax)Then KeyTail := KeyMin;
 InLine($FB);
End;

{ ������������������������������������������������������Ŀ
  �                      PushKeyXT                       ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Procedure PushKeyXTPhoenix(Key:Word);
Var KeyTail : Word Absolute $0040:$001C;
    KeyMin  : Word Absolute $0040:$0080;
    KeyMax  : Word Absolute $0040:$0082;
Begin
 InLine($FA);
 MemW[$0040:KeyTail] := Key;
 KeyTail := (((KeyTail - KeyMin) + 6) and 31) + KeyMin;
 InLine($FB);
End;

{ ������������������������������������������������������Ŀ
  �                     GetModeInsert                    ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

{$IFDEF __ASSEMBLERSUPPORT__}

 Function GetModeInsert:Boolean;
 Assembler;
 ASM
  {$IFOPT G+}
   PUSH $0000;
   POP  ES;
  {$ELSE}
   XOR AX,AX;
   MOV ES,AX;
  {$ENDIF}
  MOV AL,ES:[$0417];
  {$IFOPT G+}
   SHR AL,7;
  {$ELSE}
   ROL AL,1;
   AND AL,1;
  {$ENDIF}
 END;

{$ELSE}

 fFunction GetModeInsert:Boolean;
 Begin
  GetModeInsert := Boolean(Mem[$0040:$0017] shr 7);
 End;

{$ENDIF}

{ ������������������������������������������������������Ŀ
  �                      KeyFlags                        ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

{$IFDEF __ASSEMBLERSUPPORT__}

 Function KeyFlags:Byte;
 Assembler;
 ASM
  {$IFOPT G+}
   PUSH $0000;
   POP  ES;
  {$ELSE}
   XOR  AX,AX;
   MOV  ES,AX;
  {$ENDIF}
  MOV AL,ES:[$0417];
 END;

{$ELSE}

 Function KeyFlags:Byte;
 Begin
  KeyFlags := Mem[$0040:$0017];
 End;

{$ENDIF}

{ ������������������������������������������������������Ŀ
  �                     KeyFlagsAT                       ��
  ���������������������������������������������������������
   ��������������������������������������������������������

 D�finition :

 � Cette fonction retourne les drapeaux du clavier d'un AT ou
   compatible.

 Note :

  � Bien que cette fonction soit adapter au compilateur de
    Turbo Pascal pour Windows 1.0 et 1.5, il n'est pas
    conseiller d'utiliser cette fonction au risque
    d'incompatibilit�. Cela dit, il est tr�s rare qu'il ne
    fonctionne pas.
}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function KeyFlagsAT:Byte;
 Assembler;
 ASM
  {$IFOPT G+}
   PUSH $0000;
   POP  ES;
  {$ELSE}
   XOR AX,AX;
   MOV ES,AX;
  {$ENDIF}
  MOV AL,ES:[$0418];
 END;

{$ELSE}

 Function KeyFlagsAT:Byte;
 Begin
  KeyFlagsAT := Mem[$0040:$18];
 End;

{$ENDIF}

{ ������������������������������������������������������Ŀ
  �                      KeyPressed                      ��
  ���������������������������������������������������������
   ��������������������������������������������������������

 Syntaxe :

  Function KeyPressed:Boolean;

 D�finition :

  � Indique si une touche est en attente dans le tampon
    clavier. Ce m�thode n'utilise pas le BIOS, mais prend
    directement les informations en m�moire.

 Note :

  � Bien que cette fonction soit adapter au compilateur de
    Turbo Pascal pour Windows 1.0 et 1.5, il n'est pas
    conseiller d'utiliser cette fonction au risque
    d'incompatibilit�.
}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function KeyPressed:Boolean;
 Assembler;
 ASM
  {$IFOPT G+}
   PUSH $0000;
   POP  ES;
  {$ELSE}
   XOR AX,AX;
   MOV ES,AX;
  {$ENDIF}
  MOV DX,ES:[$041A];
  CMP DX,ES:[$041C];
  JE  @@1;
  MOV AL,Byte(True);
  JMP @@2;
 @@1:
  MOV AL,Byte(False);
 @@2:
 END;

{$ELSE}

 Function KeyPressed:Boolean;
 Begin
  KeyPressed := (MemW[$0040:$001A] = MemW[$0040:$001C]);
 End;

{$ENDIF}

{ ������������������������������������������������������Ŀ
  �                        NextKey                       ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

{$IFDEF __ASSEMBLERSUPPORT__}

 Function NextKey:Word;
 Assembler;
 ASM
  MOV AX,$0040;
  MOV ES,AX;
  MOV DI,ES:[$001A];
  MOV AX,ES:[DI];
 END;

{$ELSE}

 Function NextKey:Word;
 Begin
  NextKey := MemW[$0040:MemW[$0040:$1A]];
 End;

{$ENDIF}

BEGIN { Main Unit }
END.