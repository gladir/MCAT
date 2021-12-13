(*********************************************************************)
(*                                                                   *)
(*                     Malte System/BIOS by Text                     *)
(*                            1992/08/30                             *)
(*                                                                   *)
(*             Copyright (C) par les Chevaliers de Malte             *)
(*                                                                   *)
(*********************************************************************)

{ Programmeur :

   Sylvain Maltais

  DerniŠre modification :

   Samedi, le 8 mai 1993   (Modification des directives de compilations
                            pour l'adaptation … l'assembler;
			    Addition des directives de compilation pour
			    les chaines de caractŠre de type pointeur).
   Jeudi, le 13 mai 1993   (Restructuration du fichier en format logique).

  Directive de compilation conditionnel :

   QUICKPASCAL           Indique qu'il s'agit d'un compilateur
                         QuickPascal.
   VER10                 Indique que la version du compilateur
                         est 1.0 (Pr‚d‚finit).
   VER15                 Indique que la version du compilateur
                         est 1.5 (Pr‚d‚finit).
   VER60                 Indique que la version du compilateur
                         est 6.0 (Pr‚d‚finit).
   VER70                 Indique que la version du compilateur
                         est 7.0 (Pr‚d‚finit).
   VER80                 Indique que la version du compilateur
                         est 8.0 (Pr‚d‚finit).
   __ASSEMBLERSUPPORT__  Indique que le compilateur support l'assembler.
                         (Pr‚d‚finit en fonction des autres variables).
   __OPTIMIZESIZE__      Indique qu'il faut faire en sorte que le code
                         langage machine prenne le moin de place possible.
   __STRPTRSUPPORT__     Indique que le compilateur support des variables
                         de caractŠre du mˆme genre que le langage C.
}

{$IFDEF VER10}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
 {$ELSE}
  {$DEFINE __EXTERNAL__}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER15}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
 {$ELSE}
  {$DEFINE __EXTERNAL__}
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

Unit BIOSText;

(*********************************************************************)
			       INTERFACE
(*********************************************************************)

Uses Numeric;

Var

       VB : Record
	     Shade      : Boolean;
	     SpaceBorde : Boolean;
	     ColnDouble : Word;
	     Coln       : Byte;
	     Line       : Byte;
	     MaxX       : Byte;
	     MaxY       : Byte;
	     HalfMaxX   : Byte;
	    End;

Procedure BIOS_BarCharHori(X1,Y,X2:Byte;Chr:Char);
Procedure BIOS_BarCharVert(X,Y1,Y2:Byte;Chr:Char);
Procedure BIOS_BarSelectHori(X1,Y,X2,Color:Byte);
Procedure BIOS_BarSelectHori_(X1,Y,X2:Byte);
Procedure BIOS_BarSelectVert(X,Y1,Y2,Color:Byte);
Procedure BIOS_BarSpaceHori(X1,Y,X2,Color:Byte);
Procedure BIOS_BarSpaceHori_(X1,Y,X2:Byte);
Procedure BIOS_BarSpaceVert(X,Y1,Y2,Color:Byte);
Procedure BIOS_BarSpaceVert_(X,Y1,Y2:Byte);
Procedure BIOS_BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
Procedure BIOS_BarTextHori_(X1,Y,X2:Byte;Chr:Char);
Procedure BIOS_BarTextVert(X,Y1,Y2:Byte;Chr:Char;Color:Byte);
Procedure BIOS_BarTextVert_(X,Y1,Y2:Byte;Chr:Char);
Procedure BIOS_CenterText(Y:Byte;Chn:String;Color:Byte);
Procedure BIOS_ClearColumns(X:Byte;Chr:Char;Color:Byte);
Procedure BIOS_ClearColumns_(X:Byte;Chr:Char);
Procedure BIOS_ClearLine(Y:Byte;Chr:Char;Color:Byte);
Procedure BIOS_ClearLine_(Y:Byte;Chr:Char);
Procedure BIOS_ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte);
Procedure BIOS_ClearLineAs_(Y,X2:Byte;Chr:Char);
Procedure BIOS_ClearLineSpc(Y,Color:Byte);
Procedure BIOS_ClearLineSpc_(Y:Byte);
Procedure BIOS_ClearLineUncolor(Y:Byte;Chr:Char);
Procedure BIOS_ClearScreen(Color:Byte);
Procedure BIOS_ClearScreen_;
Procedure BIOS_ClearWindow(X1,Y1,X2,Y2,Color:Byte);
Procedure BIOS_ClearWindow_(X1,Y1,X2,Y2:Byte);
Procedure BIOS_CloseCursor;
Procedure BIOS_EGA_Blink(Blink:Boolean);
Procedure BIOS_FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
Procedure BIOS_FillBox_(X1,Y1,X2,Y2:Byte;Chr:Char);
Procedure BIOS_FullCursor;
Procedure BIOS_GetPosCursor(Var X,Y:Byte;Page:Byte);
Procedure BIOS_InitVideo;
Procedure BIOS_MoveTextDown(X1,Y1,X2,Y2:Byte);
Procedure BIOS_MoveTextUp(X1,Y1,X2,Y2:Byte);
Procedure BIOS_PutBorderUncolor(X1,Y1,X2,Y2:Byte);
Procedure BIOS_PutBox(X1,Y1,X2,Y2:Byte;Var Buffer);
Procedure BIOS_PutChar(X,Y,Page,Char:Byte);
Procedure BIOS_PutCharType(X,Y:Byte;Chr:Char;Color:Byte;Fond:Boolean);
Procedure BIOS_PutEmptyBorder(X1,Y1,X2,Y2,Color:Byte);
Procedure BIOS_PutEmptyBorder_(X1,Y1,X2,Y2:Byte);
Procedure BIOS_PutFillBorder(X1,Y1,X2,Y2,Color:Byte);
Procedure BIOS_SaveBox(X1,Y1,X2,Y2:Byte;Var Buffer);
Procedure BIOS_ScrollUp_(X1,Y1,X2,Y2,Color:Byte);
Procedure BIOS_ScrollUp(X1,Y1,X2,Y2,Num,Color:Byte);
Procedure BIOS_ScrollDown(X1,Y1,X2,Y2,Num,Color:Byte);
Procedure BIOS_ScrollDown_(X1,Y1,X2,Y2,Color:Byte);
Procedure BIOS_SetAttr(X,Y,Color:Byte);
Procedure BIOS_SetAttr_(X,Y:Byte);
Procedure BIOS_SetBorderShade(Etat:Boolean);
Procedure BIOS_SetBorderSpace(Etat:Boolean);
Procedure BIOS_SetChar(X,Y:Byte;Chr:Char);
Procedure BIOS_SetCube(X,Y:Byte;Chr:Char;Color:Byte);
Procedure BIOS_SetCube_(X,Y:Byte;Chr:Char);
Procedure BIOS_SetCursor(Start,Finish:Byte);
Procedure BIOS_SetFillBorder_(X1,Y1,X2,Y2:Byte);
Procedure BIOS_SetMatrix8x8(Table:Byte);
Procedure BIOS_SetMatrix8x14(Table:Byte);
Procedure BIOS_SetMatrix8x16(Table:Byte);
Procedure BIOS_SetPaletteEGA(Register,Color:Byte);
Procedure BIOS_SetPaletteVGA(Registre:Word;R,G,B:Byte);
Procedure BIOS_SetPosCursor(X,Y,Page:Byte);
Procedure BIOS_SetScanLine(Num:Byte);
Procedure BIOS_SetSpace(X,Y,Color:Byte);
Procedure BIOS_SetSpace_(X,Y:Byte);
Procedure BIOS_SetVideoMode(Mode:ShortInt);
Procedure BIOS_SetVideoMode_(Mode:ShortInt);
Procedure BIOS_PutStringCoding(X,Y:Byte;Num:Word;Var Buffer;Page:Byte);
Procedure BIOS_WriteAs(X,Y:Byte;Chn:String;Color:Byte;Stop:Char);
Procedure BIOS_WriteOnlyColor(X,Y:Byte;Chn:String;Color:Byte);
Procedure BIOS_WriteOnlyColorAnd(X,Y:Byte;Chn:String;Num,Color:Byte);
Procedure BIOS_WriteText(X,Y:Byte;Chn:String;Color:Byte);
Procedure BIOS_WriteText_(X,Y:Byte;Chn:String);
Procedure BIOS_WriteToAs(X,Y:Byte;Chn:String;Pos,Color:Byte;Stop:Char);
Procedure BIOS_WriteType(X,Y:Byte;Chn:String;Color:Byte;Fond:Boolean);
Procedure BIOS_WriteTyping_(Chn:String);
Procedure BIOS_WriteTypingLn(Chn:String);
Procedure BIOS_WriteTypingXY(X,Y:Byte;Chn:String);
Procedure BIOS_WriteTypingXYBicolor(X,Y:Byte;Chn:String;C1,C2:Byte);
Procedure BIOS_WriteUncolor(X,Y:Byte;Chn:String);
Procedure BIOS_WriteUncolorAs(X,Y:Byte;Chn:String;Stop:Char);
Procedure BIOS_WriteUncolorToAs(X,Y:Byte;Chn:String;Pos:Byte;Stop:Char);

Function BIOS_EGA_SizeMemory:LongInt;
Function BIOS_GetAttr(X,Y,Page:Byte):Byte;
Function BIOS_GetBlink:Boolean;
Function BIOS_GetBlinkControl:Boolean;
Function BIOS_GetChar(X,Y,Page:Byte):Char;
Function BIOS_GetColums:Byte;
Function BIOS_GetHeightChar:Byte;
Function BIOS_GetLine:Byte;
Function BIOS_GetNumColor:Word;
Function BIOS_GetNumPage:Byte;
Function BIOS_GetPage:Byte;
Function BIOS_GetScanLine:Byte;
Function BIOS_GetScanLine_:Word;
Function BIOS_GetVideoCard:Word;
Function BIOS_GetVideoCardPrim:Word;
Function BIOS_GetVideoCardSec:Word;
Function BIOS_GetVideoMode:Byte;
Function BIOS_Info(Var Buffer):Boolean;
Function BIOS_Info_:Boolean;
Function BIOS_IsEGA:Boolean;
Function BIOS_VGA_PS2_Get_Line:Byte;

(*********************************************************************)
			    IMPLEMENTATION
(*********************************************************************)

Uses

     {$IFNDEF __ASSEMBLERSUPPORT__}
      DOS,
     {$ENDIF}

     Text,TPointer;

Const

      EOL   = $FF;

{$IFDEF __EXTERNAL__}
 {$L BIOS_TXT.OBJ }
{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_MoveTextUp                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure BIOS_MoveTextUp(X1,Y1,X2,Y2:Byte);
Var I,J : Byte;
Begin
 For J := Y1 + 1 to Y2 do
 Begin
  For I := X1 to X2 do BIOS_SetChar(I,J,BIOS_GetChar(I,J-1,0));
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_MoveTextDown                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure BIOS_MoveTextDown(X1,Y1,X2,Y2:Byte);
Var I,J : Byte;
Begin
 For J := Y2 to Y1+1 do
 Begin
  For I := X1 downto X2 do BIOS_SetChar(I,J,BIOS_GetChar(I,J-1,0));
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_PutCharType                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_PutCharType(X,Y:Byte;Chr:Char;Color:Byte;Fond:Boolean);
 Assembler;
 ASM
  MOV AH,$02;
  XOR BH,BH;
  MOV DL,X;
  MOV DH,Y;
  INT $10;
  MOV AH,$0E;
  MOV AL,Fond;
  ROR AL,1;
  OR  AL,Char;
  MOV BL,Color;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_PutCharType(X,Y:Byte;Chr:Char;Color:Byte;Fond:Boolean);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AH := $02;
   BH := 0;
   DL := X;
   DH := Y;
   Intr($10,Reg);
   AH := $0E;
   AL := (Byte(Fond) shl 7) or Byte(Chr);
   BL := Color;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_WriteType                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure BIOS_WriteType(X,Y:Byte;Chn:String;Color:Byte;Fond:Boolean);
Var I : Byte;
Begin
 For I := 1 to Length(Chn) do BIOS_PutCharType(X+I-1,Y,Chn[I],Color,Fond);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_CloseCursor                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure BIOS_CloseCursor;
Begin
 BIOS_SetCursor($20,$20);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_FullCursor                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure BIOS_FullCursor;
Begin
 BIOS_SetCursor(0,7+(7*Byte(BIOS_GetVideoMode = 7)));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_SetCursor                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_SetCursor(Start,Finish:Byte);
 Assembler;
 ASM
  MOV CL,Finish;
  MOV CH,Start;
  MOV AH,$01;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_SetCursor(Start,Finish:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   CL := Finish;
   CH := Start;
   AH := $01;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_SetPosCursor                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_SetPosCursor(X,Y,Page:Byte);
 Assembler;
 ASM
  MOV AH,$02;
  MOV DL,X;
  MOV DH,Y;
  MOV BH,Page;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_SetPosCursor(X,Y,Page:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AH := $02;
   DL := X;
   DH := Y;
   BH := Page;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_GetPosCursor                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_GetPosCursor(Var X,Y:Byte;Page:Byte);
 Assembler;
 ASM
  MOV AH,$03;
  MOV BH,Page;
  INT $10;
  LES DI,X;
  MOV ES:[DI],DL;
  LES DI,Y;
  MOV ES:[DI],DH;
 END;

{$ELSE}

 Procedure BIOS_GetPosCursor(Var X,Y:Byte;Page:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AH := $03;
   BH := Page;
   Intr($10,Reg);
   X := DL;
   Y := DH;
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BIOS_PutChar                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_PutChar(X,Y,Page,Char:Byte);
 Assembler;
 ASM
  MOV AH,$02;
  MOV DL,X;
  MOV DH,Y;
  MOV BH,Page;
  INT $10;
  MOV AH,$0A;
  MOV AL,Char;
  MOV BX,$000F;
  MOV CX,$0001;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_PutChar(X,Y,Page,Char:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   BIOS_SetPosCursor(X,Y,Page);
   AH := $0A;
   AL := Char;
   BX := $0F;
   CX := $01;
   Intr($10,Reg);
  End;
 END;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_SetVideoMode                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_SetVideoMode(Mode:ShortInt);
 Assembler;
 ASM
  XOR AH,AH;
  MOV AL,Mode;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_SetVideoMode(Mode:ShortInt);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AX := Mode;
   Intr($10,Reg);
  End;
 END;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_ScrollUp_                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_ScrollUp_(X1,Y1,X2,Y2,Color:Byte);
 Assembler;
 ASM
  MOV AX,$0601;
  MOV BH,Color;
  MOV CL,X1;
  MOV CH,Y1;
  MOV DL,X2;
  MOV DH,Y2;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_ScrollUp_(X1,Y1,X2,Y2,Color:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AX := $0601;
   BH := Color;
   CL := X1;
   CH := Y1;
   DL := X2;
   DH := Y2;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_ScrollUp                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_ScrollUp(X1,Y1,X2,Y2,Num,Color:Byte);
 Assembler;
 ASM
  MOV AH,$06;
  MOV AL,Num;
  MOV BH,Color;
  MOV CL,X1;
  MOV CH,Y1;
  MOV DL,X2;
  MOV DH,Y2;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_ScrollUp(X1,Y1,X2,Y2,Num,Color:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AH := $06;
   AL := Num;
   BH := Color;
   CL := X1;
   CH := Y1;
   DL := X2;
   DH := Y2;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_ScrollDown                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_ScrollDown(X1,Y1,X2,Y2,Num,Color:Byte);
 Assembler;
 ASM
  MOV AH,$07;
  MOV AL,Num;
  MOV BH,Color;
  MOV CL,X1;
  MOV CH,Y1;
  MOV DL,X2;
  MOV DH,Y2;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_ScrollDown(X1,Y1,X2,Y2,Num,Color:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AH := $07;
   AL := Num;
   BH := Color;
   CL := X1;
   CH := Y1;
   DL := X2;
   DH := Y2;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_ScrollDown_                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_ScrollDown_(X1,Y1,X2,Y2,Color:Byte);
 Assembler;
 ASM
  MOV AX,$0701;
  MOV BH,Color;
  MOV CL,X1;
  MOV CH,Y1;
  MOV DL,X2;
  MOV DH,Y2;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_ScrollDown_(X1,Y1,X2,Y2,Color:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AX := $0701;
   BH := Color;
   CL := X1;
   CH := Y1;
   DL := X2;
   DH := Y2;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BIOS_GetAttr                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetAttr(X,Y,Page:Byte):Byte;
 Assembler;
 Var _AL : Byte;
 ASM
  MOV AH,$03;
  MOV BH,Page;
  INT $10;
  PUSH DX;
   MOV AH,$02;
   MOV DL,X;
   MOV DH,Y;
   INT $10;
   MOV AH,$08;
   INT $10;
   MOV _AL,AH;
   MOV AH,$02;
  POP DX;
  INT $10;
  MOV AL,_AL;
 END;

{$ELSE}

 Function BIOS_GetAttr(X,Y,Page:Byte):Byte;
 Var Reg  : Registers;
     Data : Word;
 Begin
  With Reg do
  Begin
   AH := $03;
   BH := Page;
   Intr($10,Reg);
   Data := DX;
   BIOS_SetPosCursor(X,Y,Page);
   AH := $08;
   Intr($10,Reg);
   BIOS_GetAttr := AH;
   AH := $02;
   DX := Data;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BIOS_GetChar                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetChar(X,Y,Page:Byte):Char;
 Assembler;
 Var _AL : Byte;
 ASM
  MOV AH,$03;
  MOV BH,Page;
  INT $10;
  PUSH DX;
   MOV AH,$02;
   MOV DL,X;
   MOV DH,Y;
   INT $10;
   MOV AH,$08;
   INT $10;
   MOV _AL,AL;
   MOV AH,$02;
  POP DX;
  INT $10;
  MOV AL,_AL;
 END;

{$ELSE}

 Function BIOS_GetChar(X,Y,Page:Byte):Char;
 Var Reg  : Registers;
     Data : Word;
 Begin
  With Reg do
  Begin
   AH := $03;
   BH := Page;
   Intr($10,Reg);
   Data := DX;
   BIOS_SetPosCursor(X,Y,Page);
   AH := $08;
   Intr($10,Reg);
   BIOS_GetChar := Char(AL);
   AH := $02;
   DX := Data;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_GetColumns                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetColums:Byte;
 Assembler;
 ASM
  MOV AH,$0F;
  INT $10;
  MOV AL,AH;
 END;

{$ELSE}

 Function BIOS_GetColums:Byte;
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AH := $0F;
   Intr($10,Reg);
   BIOS_GetColums := AH;
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BIOS_GetPage                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetPage:Byte;
 Assembler;
 ASM
  MOV AH,$0F;
  INT $10;
  MOV AL,BH;
 END;

{$ELSE}

 Function BIOS_GetPage:Byte;
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AH := $0F;
   Intr($10,Reg);
   BIOS_GetPage := BH;
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_GetVideoMode                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetVideoMode:Byte;
 Assembler;
 ASM
  MOV AH,$0F;
  INT $10;
 END;

{$ELSE}

 Function BIOS_GetVideoMode:Byte;
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AH := $0F;
   Intr($10,Reg);
   BIOS_GetVideoMode := AL;
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_EGA_Blink                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_EGA_Blink(Blink:Boolean);
 Assembler;
 ASM
  MOV AX,$1003;
  MOV BL,Blink;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_EGA_Blink(Blink:Boolean);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AX := $1003;
   BL := Byte(Blink);
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_EGA_SizeMemory               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_EGA_SizeMemory:LongInt;
 Assembler;
 ASM
  MOV AH,$12;
  MOV BL,$10;
  INT $10;
  INC BL; { Set 10h --> 11h }
  CMP BL,$11;
  JNE @@1;
  MOV BH,0;
@@1:
  XOR AX,AX;
 END;

{$ELSE}

 Function BIOS_EGA_SizeMemory:LongInt;
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AH := $12;
   BL := $10;
   Intr($10,Reg);
   If(BL = $10)Then BIOS_EGA_SizeMemory := 0
	       Else BIOS_EGA_SizeMemory := ((LongInt(BL)+1)*$10000);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        BIOS_IsEGA                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_IsEGA:Boolean;
 Assembler;
 ASM
  MOV AH,$12;
  MOV BL,$10;
  INT $10;
  {$IFOPT G+}
   SHR BL,4;
  {$ELSE}
   SHR BL,1;
   SHR BL,1;
   SHR BL,1;
   SHR BL,1;
  {$ENDIF}
  NOT BL;
  AND BL,1;
  MOV AL,BL;
 END;

{$ELSE}

 Function BIOS_IsEGA:Boolean;
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AH := $12;
   BL := $10;
   Intr($10,Reg);
   BIOS_IsEGA := Not(BL = $10);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_SetPaletteEGA                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_SetPaletteEGA(Register,Color:Byte);
 Assembler;
 ASM
  MOV AX,$1000;
  MOV BL,Color;
  MOV BH,Register;
  INT $10;
 End;

{$ELSE}

 Procedure BIOS_SetPaletteEGA(Register,Color:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AX := $1000;
   BL := Color;
   BH := Register;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_SetMatrix8x8                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_SetMatrix8x8(Table:Byte);
 Assembler;
 ASM
  MOV AX,$1112;
  MOV BL,Table;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_SetMatrix8x8(Table:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AX := $1112;
   BL := Table;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_SetMatrix8x14                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_SetMatrix8x14(Table:Byte);
 Assembler;
 ASM
  MOV AX,$1111;
  MOV BL,Table;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_SetMatrix8x14(Table:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AX := $1111;
   BL := Table;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_SetScanLine                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_SetScanLine(Num:Byte);
 Assembler;
 ASM
  MOV AH,$12;
  MOV BL,$30;
  MOV AL,Num;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_SetScanLine(Num:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AH := $12;
   BL := $30;
   AL := Num;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_PutStringCoding               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_PutStringCoding(X,Y:Byte;Num:Word;Var Buffer;Page:Byte);
 Assembler;
 ASM
  MOV DL,X;
  MOV DH,Y;
  MOV CX,Num;
  MOV BH,Page;
  LES BP,Buffer;
  MOV AX,$1302;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_PutStringCoding(X,Y:Byte;Num,_Seg,_Off:Word;Page:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   DL := X;
   DH := Y;
   CX := Num;
   BH := Page;
   ES := _Seg;
   BP := _Off;
   AX := $1302;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_SetMatrix8x16                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_SetMatrix8x16(Table:Byte);
 Assembler;
 ASM
  MOV AX,$1114;
  MOV BL,Table;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_SetMatrix8x16(Table:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AX := $1114;
   BL := Table;
   Intr($10,Reg);
  End;
 END;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_SetPaletteVGA                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure BIOS_SetPaletteVGA(Registre:Word;R,G,B:Byte);
 Assembler;
 ASM
  MOV AX,$1010;
  MOV BX,Registre;
  MOV CL,B;
  MOV CH,G;
  MOV DH,R;
  INT $10;
 END;

{$ELSE}

 Procedure BIOS_SetPaletteVGA(Registre:Word;R,G,B:Byte);
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AX := $1010;
   BX := Registre;
   CL := B;
   CH := G;
   DH := R;
   Intr($10,Reg);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                         BIOS_Info                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_Info(Var Buffer):Boolean;
 Assembler;
 ASM
  LES DI,Buffer;
  MOV AH,$1B;
  XOR BX,BX;
  INT $10;
  CMP AL,$1B;
  {$IFOPT G+}
   LAHF;
   SHR AH,6;
   ADC AL,0;
  {$ELSE}
   JE  @@1;
   MOV AL,Byte(False);
   JMP @@2;
@@1:
   MOV AL,Byte(True);
@@2:
  {$ENDIF}
 END;

{$ELSE}

 Function BIOS_Info(Var Buffer):Boolean;
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   ES := Seg(Buffer);
   DI := Ofs(Buffer);
   AH := $1B;
   BX := 0;
   Intr($10,Reg);
   BIOS_Info := (AL = $1B);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_GetBlinkControl              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetBlinkControl:Boolean;
 Var Table : Array[0..31] of Word;
 Begin
  BIOS_Info(Table);
  ASM
   MOV ES,Word Ptr Table[2];
   MOV DI,Word Ptr Table[0];
   ADD DI,$0B;
   MOV AL,ES:[DI];
   {$IFOPT G+}
    SHR AL,3;
    ADC @Result,0;
   {$ELSE}
    SHR AL,1;
    SHR AL,1;
    AND AL,1;
    MOV @Result,AL;
   {$ENDIF}
  END;
 End;

{$ELSE}

 Function BIOS_GetBlinkControl:Boolean;
 Var Table  : Array[0..31] of Word;
     Result : Boolean;
 Begin
  Result := BIOS_Info(Table);
  BIOS_GetBLinkControl := Boolean((Mem[Table[1]:Table[0] + $0B] shr 2) and 1);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_GetVideoCard                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetVideoCard:Word;
 Assembler;
 ASM
  MOV AX,$1A00;
  INT $10;
  CMP AL,$1A;
  JNE @@1;
  XOR AH,AH;
  MOV AL,BL;
  JMP @@2;
@@1:
  MOV AX,$FFFF;
@@2:
 END;

{$ELSE}

 Function BIOS_GetVideoCard:Word;
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AX := $1A00;
   Intr($10,Reg);
   If Not(AL = $1A)Then BIOS_GetVideoCard := $FFFF
	           Else BIOS_GetVideoCard := BX;
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  BIOS_GetVideoCardPrim               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetVideoCardPrim:Word;
 Assembler;
 ASM
  MOV AX,$1A00;
  INT $10;
  CMP AL,$1A;
  JNE @@1;
  XOR AH,AH;
  MOV AL,BL;
  JMP @@2;
@@1:
  MOV AX,$FFFF;
@@2:
 END;

{$ELSE}

 Function BIOS_GetVideoCardPrim:Word;
 Begin
  BIOS_GetVideoCardPrim := Lo(BIOS_GetVideoCard);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  BIOS_GetVideoCardSec                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetVideoCardSec:Word;
 Assembler;
 ASM
  MOV AX,$1A00;
  INT $10;
  CMP AL,$1A;
  JNE @@1;
  XOR AH,AH;
  MOV AL,BH;
  JMP @@2;
@@1:
  MOV AX,$FFFF;
@@2:
 END;

{$ELSE}

 Function BIOS_GetVideoCardSec:Word;
 Begin
  BIOS_GetVideoCardSec := Hi(BIOS_GetVideoCard);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_ClearScreen                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure BIOS_ClearScreen(Color:Byte);
Begin
 BIOS_ClearWindow(0,0,VB.MaxX,VB.MaxY,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_ClearScreen_                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure BIOS_ClearScreen_;
Begin
 BIOS_ClearScreen(VC.NorColor);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BIOS_SetSpace                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure BIOS_SetSpace(X,Y,Color:Byte);
Begin
 BIOS_SetCube(X,Y,' ',Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BIOS_SetSpace_                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure BIOS_SetSpace_(X,Y:Byte);
Begin
 BIOS_SetCube_(X,Y,' ');
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_ClearLineSpc                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure BIOS_ClearLineSpc(Y,Color:Byte);
Begin
 BIOS_ClearLine(Y,' ',Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_ClearLineSpc_                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure BIOS_ClearLineSpc_(Y:Byte);
Begin
 BIOS_ClearLine_(Y,' ');
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_GetHeightChar                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetHeightChar:Byte;
 Var Table : Array[0..63] of Byte;
 Begin
  If(BIOS_Info(Table))Then
  ASM
   MOV AX,Word Ptr Table[$23];
   MOV @Result,AL;
  END
   Else
  BIOS_GetHeightChar := 0;
 End;

{$ELSE}

 Function BIOS_GetHeightChar:Byte;
 Var Table : Array[0..63] of Byte;
 Begin
  If(BIOS_Info(Table))Then BIOS_GetHeightChar := (Table[$24] shl 8) + Table[$23]
 	              Else BIOS_GetHeightChar := 0
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_GetNumColor                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetNumColor:Word;
 Var Table : Array[0..63] of Byte;
 Begin
  If(BIOS_Info(Table))Then
  ASM
   MOV AX,Word Ptr Table[$27];
   MOV @Result,AX;
  END
   Else
  BIOS_GetNumColor := 0
 End;

{$ELSE}

 Function BIOS_GetNumColor:Word;
 Var Table : Array[0..63] of Byte;
 Begin
  If(BIOS_Info(Table))Then BIOS_GetNumColor := (Table[$28] shl 8) + Table[$27]
 	             Else BIOS_GetNumColor := 0
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_GetNumPage                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetNumPage:Byte;
 Var Table : Array[0..63] of Byte;
 Begin
  If(BIOS_Info(Table))Then
  ASM
   MOV AL,Byte Ptr Table[$29];
   MOV @Result,AL;
  END
   Else
  BIOS_GetNumPage := 0;
 End;

{$ELSE}

 Function BIOS_GetNumPage:Byte;
 Var Table : Array[0..63] of Byte;
 Begin
  If(BIOS_Info(Table))Then BIOS_GetNumPage := Table[$29]
 		      Else BIOS_GetNumPage := 0
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_GetScanLine                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function BIOS_GetScanLine:Byte;
Var Table : Array[0..63] of Byte;
Begin
 If(BIOS_Info(Table))Then BIOS_GetScanLine := Table[$2A]
		     Else BIOS_GetScanLine := 0
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_GetScanLine_                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetScanLine_:Word;
 Const Line : Array[0..9] of Word = (200,350,400,480,0,600,768,0,352,364);
 Begin
  If(BIOS_Info_)Then
  ASM
   Call BIOS_GetScanLine;
   MOV AH,0;
   MOV BX,AX;
   SHL BX,1;
   MOV AX,Word Ptr Line[BX];
   MOV @Result,AX;
  END
   Else
  BIOS_GetScanLine_ := 0;
 End;

{$ELSE}

 Function BIOS_GetScanLine_:Word;
 Begin
  If(BIOS_Info_)Then
  Begin
   Case BIOS_GetScanLine of
     0 : BIOS_GetScanLine_ := 200;
     1 : BIOS_GetScanLine_ := 350;
     2 : BIOS_GetScanLine_ := 400;
     3 : BIOS_GetScanLine_ := 480;
     5 : BIOS_GetScanLine_ := 600;
     6 : BIOS_GetScanLine_ := 768;
     8 : BIOS_GetScanLine_ := 352;
     9 : BIOS_GetScanLine_ := 364;
    else BIOS_GetScanLine_ := 0;
   End;
  End
   else
  BIOS_GetScanLine_ := 0;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BIOS_Info_                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function BIOS_Info_:Boolean;
Var Table : Array[0..63] of Byte;
Begin
 BIOS_Info_ := BIOS_Info(Table);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_GetBlink                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetBlink:Boolean;
 Var Table : Array[0..63] of Byte;
 Begin
  If(BIOS_Info(Table))Then
  ASM
   MOV AL,Byte Ptr Table[$2D];
   {$IFOPT G+}
    SHR AL,6;
    ADC @Result,0;
   {$ELSE}
    SHL AL,1;
    SHL AL,1;
    SHL AL,1;
    ADC @Result,0;
   {$ENDIF}
  END
   Else
  BIOS_GetBlink := False;
 End;

{$ELSE}

 Function BIOS_GetBlink:Boolean;
 Var Table : Array[0..63] of Byte;
 Begin
  If(BIOS_Info(Table))Then BIOS_GetBlink := Boolean((Table[$2D] shr 5) and 1)
 	              Else BIOS_GetBlink := False;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_VGA_PS2_Get_Line              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function BIOS_VGA_PS2_Get_Line:Byte;
Var Table : Array[0..63] of Byte;
Begin
 If(BIOS_Info(Table))Then BIOS_VGA_PS2_Get_Line := Table[$22]
	             Else BIOS_VGA_PS2_Get_Line := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_SetCube                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_SetCube(X,Y:Byte;Chr:Char;Color:Byte); external;

{$ELSE}

 Procedure BIOS_SetCube(X,Y:Byte;Chr:Char;Color:Byte);
 Assembler;
 ASM
  MOV AH,$02;
  XOR BH,BH;
  MOV DL,X;
  MOV DH,Y;
  INT $10;
  MOV AH,9;
  MOV AL,Char;
  MOV BL,Color;
  MOV CX,1;
  INT $10;
 END;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_SetBorderShade               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_SetBorderShade(Etat:Boolean); external;

{$ELSE}

 Procedure BIOS_SetBorderShade(Etat:Boolean);
 Begin
  VB.Shade := Etat;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_SetBorderSpace               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_SetBorderSpace(Etat:Boolean); external;

{$ELSE}

 Procedure BIOS_SetBorderSpace(Etat:Boolean);
 Begin
  VB.SpaceBorde := Etat;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BIOS_SaveBox                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_SaveBox(X1,Y1,X2,Y2:Byte;Var Buffer); external;

{$ELSE}

  Procedure BIOS_SaveBox(X1,Y1,X2,Y2:Byte;Var Buffer);
  Var I,J,XS,YS : Byte;
      TBuffer   : ^TByte;
  Begin
   If(X2 = EOL)Then X2 := VB.MaxX;
   XS := (X2 - X1); YS := (Y2 - Y1);
   TBuffer := @Buffer;
   For J := 0 to YS do
   Begin
    For I := 0 to XS do
    Begin
     TBuffer^[(((XS+1) * J) + I) shl 1]     := Byte(BIOS_GetChar(X1+I,Y1+J,0));
     TBuffer^[((((XS+1) * J) + I) shl 1)+1] := BIOS_GetAttr(X1+I,Y1+J,0);
    End;
   End;
  End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       BIOS_PutBox                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_PutBox(X1,Y1,X2,Y2:Byte;Var Buffer); external;

{$ELSE}

 Procedure BIOS_PutBox(X1,Y1,X2,Y2:Byte;Var Buffer);
 Var I,J,XS,YS : Byte;
     TBuffer   : ^TByte;
 Begin
  If(X2 = EOL)Then X2 := VB.MaxX;
  XS := (X2 - X1); YS := (Y2 - Y1);
  TBuffer := @Buffer;
  For J := 0 to YS do
  Begin
   For I := 0 to XS do
   Begin
    BIOS_SetCube(X1+I,Y1+J,Char(TBuffer^[(((XS+1)*J)+I) shl 1]),
                           TBuffer^[((((XS+1)*J)+I) shl 1)+1]);
   End;
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       BIOS_SetAttr                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_SetAttr(X,Y,Color:Byte); external;

{$ELSE}

 Procedure BIOS_SetAttr(X,Y,Color:Byte);
 Begin
  BIOS_SetCube(X,Y,BIOS_GetChar(X,Y,0),Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BIOS_SetAttr_                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_SetAttr_(X,Y:Byte); external;

{$ELSE}

 Procedure BIOS_SetAttr_(X,Y:Byte);
 Begin
  BIOS_SetCube(X,Y,BIOS_GetChar(X,Y,0),VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_BarTextHori                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte); external;

{$ELSE}

 Procedure BIOS_BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
 Assembler;
 ASM
  MOV AL,X1;
  MOV AH,X2;
  CMP AH,AL;
  JNL @@1;
  XCHG AL,AH;
@@1:
  CMP AH,$FF;
  JNE @@2;
  MOV AH,VB.MaxX;
@@2:
  XCHG AL,AH;
  SUB AL,AH;
  INC AL;
  XOR AH,AH;
  MOV CX,AX;
  MOV AH,2;
  XOR BH,BH;
  MOV DL,X1;
  MOV DH,Y;
  INT $10;
  MOV AH,9;
  MOV AL,Char;
  MOV BL,Color;
  INT $10;
 END;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_BarTextHori_                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarTextHori_(X1,Y,X2:Byte;Chr:Char); external;

{$ELSE}

 Procedure BIOS_BarTextHori_(X1,Y,X2:Byte;Chr:Char);
 Begin
  BIOS_BarTextHori(X1,Y,X2,Chr,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_BarSpaceHori                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarSpaceHori(X1,Y,X2,Color:Byte); external;

{$ELSE}

 Procedure BIOS_BarSpaceHori(X1,Y,X2,Color:Byte);
 Begin
  BIOS_BarTextHori(X1,Y,X2,' ',Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_BarSpaceHori_                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarSpaceHori_(X1,Y,X2:Byte); external;

{$ELSE}

 Procedure BIOS_BarSpaceHori_(X1,Y,X2:Byte);
 Begin
  BIOS_BarTextHori(X1,Y,X2,' ',VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_BarCharHori                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarCharHori(X1,Y,X2:Byte;Chr:Char); external;

{$ELSE}

 Procedure BIOS_BarCharHori(X1,Y,X2:Byte;Chr:Char);
 Assembler;
 ASM
  MOV CL,X2;
  SUB CL,X1;
  MOV CH,0;
  INC CX;
  MOV AH,2;
  XOR BH,BH;
  MOV DL,X1;
  MOV DH,Y;
  INT $10;
  MOV AH,$0A;
  MOV AL,Chr;
  MOV BL,15;
  INT $10;
 END;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_BarTextVert                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarTextVert(X,Y1,Y2:Byte;Chr:Char;Color:Byte); external;

{$ELSE}

 Procedure BIOS_BarTextVert(X,Y1,Y2:Byte;Chr:Char;Color:Byte);
 Var I : Byte;
 Begin
  For I := Y1 to Y2 do BIOS_SetCube(X,I,Chr,Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_BarTextVert_                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarTextVert_(X,Y1,Y2:Byte;Chr:Char); external;

{$ELSE}

 Procedure BIOS_BarTextVert_(X,Y1,Y2:Byte;Chr:Char);
 Begin
  BIOS_BarTextVert(X,Y1,Y2,Chr,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_BarSpaceVert                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarSpaceVert(X,Y1,Y2,Color:Byte); external;

{$ELSE}

 Procedure BIOS_BarSpaceVert(X,Y1,Y2,Color:Byte);
 Begin
  BIOS_BarTextVert(X,Y1,Y2,' ',Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  BIOS_BarSpaceVert_                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarSpaceVert_(X,Y1,Y2:Byte); external;

{$ELSE}

 Procedure BIOS_BarSpaceVert_(X,Y1,Y2:Byte);
 Begin
  BIOS_BarTextVert(X,Y1,Y2,' ',VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_BarCharVert                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarCharVert(X,Y1,Y2:Byte;Chr:Char); external;

{$ELSE}

 Procedure BIOS_BarCharVert(X,Y1,Y2:Byte;Chr:Char);
 Var I : Byte;
 Begin
  For I := Y1 to Y2 do BIOS_PutChar(X,I,0,Byte(Chr));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_ClearLine                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_ClearLine(Y:Byte;Chr:Char;Color:Byte); external;

{$ELSE}

 Procedure BIOS_ClearLine(Y:Byte;Chr:Char;Color:Byte);
 Begin
  BIOS_ClearLineAs(Y,VB.MaxX,Chr,Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_ClearLine_                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_ClearLine_(Y:Byte;Chr:Char); external;

{$ELSE}

 Procedure BIOS_ClearLine_(Y:Byte;Chr:Char);
 Begin
  BIOS_ClearLine(Y,Chr,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_ClearLineAs                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte); external;

{$ELSE}

 Procedure BIOS_ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte);
 Assembler;
 ASM
  MOV AH,2;
  XOR BH,BH;
  XOR DL,DL;
  MOV DH,Y;
  INT $10;
  MOV AH,9;
  MOV AL,Char;
  MOV BL,Color;
  MOV CL,X2;
  MOV CH,0;
  INT $10;
 END;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_ClearLineAs_                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_ClearLineAs_(Y,X2:Byte;Chr:Char); external;

{$ELSE}

 Procedure BIOS_ClearLineAs_(Y,X2:Byte;Chr:Char);
 Begin
  BIOS_ClearLineAs(Y,X2,Chr,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_BarSelectHori                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarSelectHori(X1,Y,X2,Color:Byte); external;

{$ELSE}

 Procedure BIOS_BarSelectHori(X1,Y,X2,Color:Byte);
 Var I : Byte;
 Begin
  If(X2 = EOL)Then X2 := VB.MaxX;
  if Not(X1 = X2)Then
  Begin
   For I := X1 to X2 do BIOS_SetAttr(I,Y,Color);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  BIOS_BarSelectHori_                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarSelectHori_(X1,Y,X2:Byte); external;

{$ELSE}

 Procedure BIOS_BarSelectHori_(X1,Y,X2:Byte);
 Begin
  BIOS_BarSelectHori(X1,Y,X2,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  BIOS_BarSelectVert                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_BarSelectVert(X,Y1,Y2,Color:Byte); external;

{$ELSE}

 Procedure BIOS_BarSelectVert(X,Y1,Y2,Color:Byte);
 Var I : Byte;
 Begin
  If Not(Y1 = Y2)Then
  Begin
   For I := Y1 to Y2 do BIOS_SetAttr(X,I,Color);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_ClearWindow                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_ClearWindow(X1,Y1,X2,Y2,Color:Byte); external;

{$ELSE}

 Procedure BIOS_ClearWindow(X1,Y1,X2,Y2,Color:Byte);
 Assembler;
 ASM
  MOV AX,$0600;
  MOV BH,Color;
  MOV CL,X1;
  MOV CH,Y1;
  MOV DL,X2;
  MOV DH,Y2;
  INT $10;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_ClearWindow_                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_ClearWindow_(X1,Y1,X2,Y2:Byte); external;

{$ELSE}

 Procedure BIOS_ClearWindow_(X1,Y1,X2,Y2:Byte);
 Begin
  BIOS_ClearWindow(X1,Y1,X2,Y2,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BIOS_FillBox                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte); external;

{$ELSE}

 Procedure BIOS_FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
 Var I : Byte;
 Begin
  For I := Y1 to Y2 do BIOS_BarTextHori(X1,I,X2,Chr,Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_FillBox_                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_FillBox_(X1,Y1,X2,Y2:Byte;Chr:Char); external;

{$ELSE}

 Procedure BIOS_FillBox_(X1,Y1,X2,Y2:Byte;Chr:Char);
 Begin
  BIOS_FillBox(X1,Y1,X2,Y2,Chr,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_SetChar                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_SetChar(X,Y:Byte;Chr:Char); external;

{$ELSE}

 Procedure BIOS_SetChar(X,Y:Byte;Chr:Char);
 Begin
  BIOS_PutChar(X,Y,0,Byte(Chr));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_SetCube_                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_SetCube_(X,Y:Byte;Chr:Char); external;

{$ELSE}

 Procedure BIOS_SetCube_(X,Y:Byte;Chr:Char);
 Begin
  BIOS_SetCube(X,Y,Chr,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_WriteTypingXY                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteTypingXY(X,Y:Byte;Chn:String); external;

{$ELSE}

 Procedure BIOS_WriteTypingXY(X,Y:Byte;Chn:String);
 Begin
  VC.RX := X; VC.RY := Y;
  BIOS_WriteTyping_(Chn);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  BIOS_WriteTypingXYBicolor           ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteTypingXYBicolor(X,Y:Byte;Chn:String;C1,C2:Byte); external;

{$ELSE}

 Procedure BIOS_WriteTypingXYBicolor(X,Y:Byte;Chn:String;C1,C2:Byte);
 Var T1, T2 : Byte;
 Begin
  T1 := VC.LastColor;
  T2 := VC.NorColor;
  VC.LastColor := C1;
  VC.NorColor  := C2;
  BIOS_WriteTypingXY(X,Y,Chn);
  VC.LastColor := T1;
  VC.NorColor  := T2;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  BIOS_PutEmptyBorder                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_PutEmptyBorder(X1,Y1,X2,Y2,Color:Byte); external;

{$ELSE}

 Procedure BIOS_PutEmptyBorder(X1,Y1,X2,Y2,Color:Byte);
 Begin
  BIOS_BarTextVert(X1,Y1+1,Y2-1,VC.Border[3],Color);
  BIOS_BarTextVert(X2,Y1+1,Y2-1,VC.Border[4],Color);
  BIOS_BarTextHori(X1+1,Y1,X2-1,VC.Border[1],Color);
  BIOS_BarTextHori(X1+1,Y2,X2-1,VC.Border[6],Color);
  BIOS_SetCube(X1,Y1,VC.Border[0],Color);
  BIOS_SetCube(X1,Y2,VC.Border[5],Color);
  BIOS_SetCube(X2,Y1,VC.Border[2],Color);
  BIOS_SetCube(X2,Y2,VC.Border[7],Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  BIOS_PutEmptyBorder_                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_PutEmptyBorder_(X1,Y1,X2,Y2:Byte); external;

{$ELSE}

 Procedure BIOS_PutEmptyBorder_(X1,Y1,X2,Y2:Byte);
 Begin
  BIOS_PutEmptyBorder(X1,Y1,X2,Y2,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 BIOS_PutBorderUncolor                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_PutBorderUncolor(X1,Y1,X2,Y2:Byte); external;

{$ELSE}

 Procedure BIOS_PutBorderUncolor(X1,Y1,X2,Y2:Byte);
 Begin
  BIOS_BarCharVert(X1,Y1+1,Y2-1,VC.Border[3]);
  BIOS_BarCharVert(X2,Y1+1,Y2-1,VC.Border[4]);
  BIOS_BarCharHori(X1+1,Y1,X2-1,VC.Border[1]);
  BIOS_BarCharHori(X1+1,Y2,X2-1,VC.Border[6]);
  BIOS_SetChar(X1,Y1,VC.Border[0]);
  BIOS_SetChar(X1,Y2,VC.Border[5]);
  BIOS_SetChar(X2,Y1,VC.Border[2]);
  BIOS_SetChar(X2,Y2,VC.Border[7]);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_PutFillBorder                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_PutFillBorder(X1,Y1,X2,Y2,Color:Byte); external;

{$ELSE}

 Procedure BIOS_PutFillBorder(X1,Y1,X2,Y2,Color:Byte);
 Var TX1,TY1,TX2,TY2 : Byte;
 Begin
  If((X1 <> X2)and(Y1 <> Y2))Then
  Begin
   If(X2 = EOL)Then X2 := VB.MaxX;
   BIOS_ClearWindow(X1,Y1,X2,Y2,Color);
   If(VB.Shade)Then
   Begin
    If(X2+1 <= VB.MaxX)Then
    Begin
     BIOS_BarSelectHori(X1+2,Y2+1,X2+2,7);
     BIOS_BarSelectVert(X2+1,Y1+1,Y2+1,7);
     BIOS_BarSelectVert(X2+2,Y1+1,Y2+1,7);
    End;
   End;
   If(VB.SpaceBorde)Then
   Begin
    TX1 := X1+2;
    TY1 := Y1+1;
    TX2 := X2-2;
    TY2 := Y2-1;
   End
    else
   Begin
    TX1 := X1;
    TY1 := Y1;
    TX2 := X2;
    TY2 := Y2;
   End;
   BIOS_PutBorderUncolor(TX1,TY1,TX2,TY2);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_SetFillBorder_                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_SetFillBorder_(X1,Y1,X2,Y2:Byte); external;

{$ELSE}

 Procedure BIOS_SetFillBorder_(X1,Y1,X2,Y2:Byte);
 Begin
  BIOS_PutFillBorder(X1,Y1,X2,Y2,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_ClearColumns                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_ClearColumns(X:Byte;Chr:Char;Color:Byte); external;

{$ELSE}

 Procedure BIOS_ClearColumns(X:Byte;Chr:Char;Color:Byte);
 Var I : Byte;
 Begin
  For I := 0 to VB.MaxY do BIOS_SetCube(X,I,Chr,Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_ClearColumns_                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_ClearColumns_(X:Byte;Chr:Char); external;

{$ELSE}

 Procedure BIOS_ClearColumns_(X:Byte;Chr:Char);
 Begin
  BIOS_ClearColumns(X,Chr,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  BIOS_ClearLineUncolor               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_ClearLineUncolor(Y:Byte;Chr:Char); external;

{$ELSE}

 Procedure BIOS_ClearLineUncolor(Y:Byte;Chr:Char);
 Assembler;
 ASM
  MOV DL,Y;
  XOR DH,DH;
  XOR BH,BH;
  MOV AH,$02;
  INT $10;
  MOV AH,$0A;
  MOV AL,Char;
  MOV BL,15;
  MOV CL,VB.MaxX;
  MOV CH,0;
  INT $10;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BIOS_GetLine                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Function BIOS_GetLine:Byte; external;

{$ELSE}

 Function BIOS_GetLine:Byte;
 Var T : Byte;
 Begin
  T := BIOS_VGA_PS2_Get_Line;
  If(T in [0,1])Then T := 25;
  BIOS_GetLine := T;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_InitVideo                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_InitVideo; external;

{$ELSE}

 Procedure BIOS_InitVideo;
 Begin
  VB.Coln       := BIOS_GetColums;
  VB.Line       := BIOS_GetLine;
  VB.ColnDouble := VB.Coln shl 1;
  VB.HalfMaxX   := (VB.Coln shr 1) - 1;
  VB.MaxX       := VB.Coln - 1;
  VB.MaxY       := VB.Line - 1;
  VC.RX         := 0;
  VC.RY         := 0;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_SetVideoMode_               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_SetVideoMode_(Mode:ShortInt); external;

{$ELSE}

 Procedure BIOS_SetVideoMode_(Mode:ShortInt);
 Begin
  BIOS_SetVideoMode(Mode);
  BIOS_InitVideo;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_WriteTyping_                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteTyping_(Chn:String); external;

{$ELSE}

 Procedure BIOS_WriteTyping_(Chn:String);
 Var X,J : Byte;
     NB  : Word;
     FC  : Boolean;
 Begin
  X := VC.RX;
  FC := True;
  For J := 1 to Length(Chn) do
  Begin
   If((Chn[J] > #31)and(Chn[J] in ['^','|','~']))Then
   Begin
    If(FC)Then BIOS_SetCube_(VC.RX,VC.RY,Chn[J])
          Else BIOS_SetChar(VC.RX,VC.RY,Chn[J]);
    Inc(VC.RX);
    If(VC.RX >= VC.Coln)Then
    Begin
     VC.RX := 0;
     Inc(VC.RY);
    End;
    Continue;
   End;
   Case (Chn[J]) of
    '|' : Begin
           VC.RX := X;
           Inc(VC.RY);
          End;
    '~' : Begin
           Inc(J);
           FC := True;
	   VC.LastColor := VC.NorColor;
	   VC.NorColor  := Byte(Chn[J]);
          End;
     #2 : Dec(VC.RY);
     #4 : Begin
           Inc(J);
           If(Byte(Chn[J]) > 0)Then
           Begin
            NB := Word(Chn[J]);
            ASM
             MOV DL,VC.RX;
             MOV DH,VC.RY;
             XOR BH,BH;
             MOV AH,2;
             INT $10;
             MOV AH,FC;
             ADD AH,9;
             MOV AL,' ';
             MOV BL,VC.NorColor;
             MOV CX,NB;
             INT $10;
            END;
            Inc(VC.RX,Byte(Chn[J]));
           End;
          End;
     #5 : Inc(VC.RY);
     #6 : Dec(VC.RX);
     #8 : Inc(VC.RX);
     #9 : Begin
           ASM
            MOV DL,VC.RX;
            MOV DH,VC.RY;
            XOR BH,BH;
            MOV AH,$02;
            INT $10;
            MOV AH,FC;
            ADD AH,9;
            MOV AL,' ';
            MOV BL,VC.NorColor;
            MOV CX,8;
            INT $10;
           END;
           Inc(VC.RX,7);
          End;
    #10 : Begin
           Inc(VC.RX);
           Inc(VC.RY);
          End;
    #11 : Begin
           Dec(VC.RX);
           Inc(VC.RY);
          End;
    #12 : Begin
           Inc(VC.RX);
           Dec(VC.RY);
          End;
     #1 : Begin
           Dec(VC.RX);
           Dec(VC.RY);
          End;
    #14 : Begin
           Dec(VC.RX,2);
           Dec(VC.RY);
          End;
    #15 : Begin
           Dec(VC.RX,2);
           Inc(VC.RY);
          End;
    #16 : Begin
           Inc(J);
           VC.RX := Byte(Chn[J]);
           Inc(J);
	   VC.RY := Byte(Chn[J]);
          End;
    '^' : Begin
           {$IFNDEF __ISDRIVERVIDEO__}
            SwitchColor;
           {$ELSE}
            ChgChr(VC.LastColor,VC.NorColor);
           {$ENDIF}
           FC := True;
          End;
    #28 : FC := False;
    #29 : BIOS_ClearLine_(VC.RY,' ');
    #30 : Begin
           Inc(J);
           BIOS_SetChar(VC.RX,VC.RY,Chn[J]);
           Inc(VC.RX);
          End;
    #31 : Begin
           BIOS_SetAttr_(VC.RX,VC.RY);
           Inc(VC.RX);
          End;
   End;
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_WriteTypingLn                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteTypingLn(Chn:String); external;

{$ELSE}

 Procedure BIOS_WriteTypingLn(Chn:String);
 Begin
  BIOS_WriteTyping_(Chn);
  Inc(VC.RY);
  VC.RX := 0;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_CenterText                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_CenterText(Y:Byte;Chn:String;Color:Byte); external;

{$ELSE}

 Procedure BIOS_CenterText(Y:Byte;Chn:String;Color:Byte);
 Begin
  BIOS_WriteText((VB.Coln - Length(Chn)) shl 1,Y,Chn,Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_WriteText                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteText(X,Y:Byte;Chn:String;Color:Byte); external;

{$ELSE}

 Procedure BIOS_WriteText(X,Y:Byte;Chn:String;Color:Byte);
 Var I : Byte;
 Begin
  For I := 0 to (Length(Chn)-1) do BIOS_SetCube(X+I,Y,Chn[I+1],Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_WriteText_                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteText_(X,Y:Byte;Chn:String); external;

{$ELSE}

 Procedure BIOS_WriteText_(X,Y:Byte;Chn:String);
 Var I : Byte;
 Begin
  For I := 0 to Length(Chn) - 1 do BIOS_SetCube(X+I,Y,Chn[I+1],VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_WriteOnlyColor               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteOnlyColor(X,Y:Byte;Chn:String;Color:Byte); external;

{$ELSE}

 Procedure BIOS_WriteOnlyColor(X,Y:Byte;Chn:String;Color:Byte);
 Var I : Byte;
 Begin
  For I := 0 to Length(Chn) - 1 do BIOS_SetCube(X+I,Y,BIOS_GetChar(X,Y,0),Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  BIOS_WriteOnlyColorAnd              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteOnlyColorAnd(X,Y:Byte;Chn:String;Num,Color:Byte); external;

{$ELSE}

 Procedure BIOS_WriteOnlyColorAnd(X,Y:Byte;Chn:String;Num,Color:Byte);
 Var I : Byte;
 Begin
  For I := 0 to (Length(Chn) + Num - 1) do BIOS_SetCube(X+I,Y,BIOS_GetChar(X,Y,0),Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BIOS_WriteUnColor                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteUncolor(X,Y:Byte;Chn:String); external;

{$ELSE}

 Procedure BIOS_WriteUncolor(X,Y:Byte;Chn:String);
 Var I : Byte;
 Begin
  For I := 0 to (Length(Chn)-1) do BIOS_PutChar(X+I,Y,0,Byte(Chn[I+1]));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BIOS_WriteUncolorAs               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteUncolorAs(X,Y:Byte;Chn:String;Stop:Char); external;

{$ELSE}

 Procedure BIOS_WriteUncolorAs(X,Y:Byte;Chn:String;Stop:Char);
 Var I : Byte;
 Begin
  For I := 0 to (Length(Chn)-1) do
  Begin
   If(Chn[I+1] = Stop)Then Exit;
   BIOS_PutChar(X+I,Y,0,Byte(Chn[I+1]));
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        BIOS_WriteAs                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteAs(X,Y:Byte;Chn:String;Color:Byte;Stop:Char); external;

{$ELSE}

 Procedure BIOS_WriteAs(X,Y:Byte;Chn:String;Color:Byte;Stop:Char);
 Var I : Byte;
 Begin
  For I := 0 to (Length(Chn) - 1) do
  Begin
   If(Chn[I+1] = Stop)Then Exit;
   BIOS_SetCube(X+I,Y,Chn[I+1],Color);
  End;
 End;

{$ENDIF}

{  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                      BIOS_WriteToAs                  ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteToAs(X,Y:Byte;Chn:String;Pos,Color:Byte;Stop:Char); external;

{$ELSE}

 Procedure BIOS_WriteToAs(X,Y:Byte;Chn:String;Pos,Color:Byte;Stop:Char);
 Var I : Byte;
 Begin
  For I := Pos to (Length(Chn) - 1) do
  Begin
   If(Chn[I+1] = Stop)Then Exit;
   BIOS_SetCube(X+I,Y,Chn[I+1],Color);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BIOS_WriteUncolorToAs              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure BIOS_WriteUncolorToAs(X,Y:Byte;Chn:String;Pos:Byte;Stop:Char); external;

{$ELSE}

 Procedure BIOS_WriteUncolorToAs(X,Y:Byte;Chn:String;Pos:Byte;Stop:Char);
 Var I : Byte;
 Begin
  For I := Pos to (Length(Chn) - 1) do
  Begin
   If(Chn[I+1] = Stop)Then Exit;
   BIOS_PutChar(X+I,Y,0,Byte(Chn[I+1]));
  End;
 End;

{$ENDIF}

BEGIN { Main Unit }
 VB.Shade := True;
 VB.SpaceBorde := False;
END.
