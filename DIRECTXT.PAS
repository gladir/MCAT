(****************************************************************)
(*                                                              *)
(*                  Malte System/Direct Text                    *)
(*                        1992/06/30                            *)
(*                                                              *)
(*          Copyright (C) par les Chevaliers de Malte           *)
(*                                                              *)
(****************************************************************)

{ Programmeur :

   Sylvain Maltais

  DerniŠre modification :

   Samedi, le 8 mai 1993   (Modification des directives de compilations
                            pour l'adaptation … l'assembler;
			    Addition des directives de compilation pour
			    les chaines de caractŠre de type pointeur).

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

Unit DirecTxt;

(****************************************************************)
				INTERFACE
(****************************************************************)

Uses Numeric,BiosText;

Var

       VD : Record
	     Shade      : Boolean;
	     SpaceBorde : Boolean;
	     Address    : Word;
	     ColnDouble : Word;
	     Page       : Byte;
	     Coln       : Byte;
	     Line       : Byte;
	     MaxX       : Byte;
	     MaxY       : Byte;
	     HalfMaxX   : Byte;
	    End;

Procedure IO_Blink(Etat:Boolean);
Procedure IO_CloseCursor;
Procedure IO_FullCursor;
Procedure IO_SetCursor(Start,Finish:Byte);
Procedure IO_SetPosCursor(X,Y:Byte);
Procedure IO_SetPosCursorHome;

Procedure MEM__BarSelectHori(X1,Y,X2:Byte);
Procedure MEM__BarSpaceHori(X1,Y,X2:Byte);
Procedure MEM__BarSpaceVert(X,Y1,Y2:Byte);
Procedure MEM__BarTextHori(X1,Y,X2:Byte;Chr:Char);
Procedure MEM__BarTextVert(X,Y1,Y2:Byte;Chr:Char);
Procedure MEM__ClearLine(Y:Byte;Chr:Char);
Procedure MEM__ClearLineAs(Y,X2:Byte;Chr:Char);
Procedure MEM__ClearLineSpc(Y:Byte);
Procedure MEM__ClearColumns(Column:Byte;Chr:Char);
Procedure MEM__ClearScreen;
Procedure MEM__ClearWindow(X1,Y1,X2,Y2:Byte);
Procedure MEM__FillBox(X1,Y1,X2,Y2:Byte;Chr:Char);
Procedure MEM__PutEmptyBorder(X1,Y1,X2,Y2:Byte);
Procedure MEM__PutFillBorder(X1,Y1,X2,Y2:Byte);
Procedure MEM__SetAttr(X,Y:Byte);
Procedure MEM__SetCube(X,Y:Byte;Chr:Char);
Procedure MEM__SetSpace(X,Y:Byte);
Procedure MEM__WriteText(X,Y:Byte;Chn:String);
Procedure MEM__WriteTyping(Chn:String);

Procedure MEM_BarCharHori(X1,Y,X2:Byte;Chr:Char);
Procedure MEM_BarCharVert(X,Y1,Y2:Byte;Chr:Char);
Procedure MEM_BarSelectHori(X1,Y,X2,Color:Byte);
Procedure MEM_BarSelectVert(X,Y1,Y2,Color:Byte);
Procedure MEM_BarSpaceHori(X1,Y,X2,Color:Byte);
Procedure MEM_BarSpaceVert(X,Y1,Y2,Color:Byte);
Procedure MEM_BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
Procedure MEM_BarTextVert(X,Y1,Y2:Byte;Chr:Char;Color:Byte);
Procedure MEM_CenterText(Y:Byte;Chn:String;Color:Byte);
Procedure MEM_ClearColumns(Column:Byte;Chr:Char;Color:Byte);
Procedure MEM_ClearLine(Y:Byte;Chr:Char;Color:Byte);
Procedure MEM_ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte);
Procedure MEM_ClearLineUncolor(Line:Byte;Chr:Char);
Procedure MEM_ClearLineSpc(Y,Color:Byte);
Procedure MEM_ClearScreen(Color:Byte);
Procedure MEM_ClearWindow(X1,Y1,X2,Y2,Color:Byte);
Procedure MEM_FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
Procedure MEM_InitVideo;
Procedure MEM_PutBorderUncolor(X1,Y1,X2,Y2:Byte);
Procedure MEM_PutBox(X1,Y1,X2,Y2:Byte;Var Buffer);
Procedure MEM_PutEmptyBorder(X1,Y1,X2,Y2,Color:Byte);
Procedure MEM_PutFillBorder(X1,Y1,X2,Y2,Color:Byte);
Procedure MEM_SaveBox(X1,Y1,X2,Y2:Byte;Var Buffer);
Procedure MEM_SetAttr(X,Y,Color:Byte);
Procedure MEM_SetBlink(Nombre:Boolean);
Procedure MEM_SetBorderShade(Autorise:Boolean);
Procedure MEM_SetBorderSpace(Autorise:Boolean);
Procedure MEM_SetChar(X,Y:Byte;Chr:Char);
Procedure MEM_SetCube(X,Y:Byte;Chr:Char;Color:Byte);
Procedure MEM_SetSpace(X,Y,Color:Byte);
Procedure MEM_SetVideoModeText(Mode:ShortInt);
Procedure MEM_MoveTextDown(X1,Y1,X2,Y2:Byte);
Procedure MEM_MoveTextUp(X1,Y1,X2,Y2:Byte);
Procedure MEM_MoveUp(X1,Y1,X2,Y2:Byte);
Procedure MEM_WriteAs(X,Y:Byte;Chn:String;Color:Byte;Stop:Char);
Procedure MEM_WriteOnlyColor(X,Y:Byte;Chn:String;Color:Byte);
Procedure MEM_WriteOnlyColorAnd(X,Y:Byte;Chn:String;Num,Color:Byte);
Procedure MEM_WriteText(X,Y:Byte;Chn:String;Color:Byte);
Procedure MEM_WriteTypingXY(X,Y:Byte;Chn:String);
Procedure MEM_WriteTypingXYBicolor(X,Y:Byte;Chn:String;Color1,Color2:Byte);
Procedure MEM_WriteToAs(X,Y:Byte;P:String;Pos:Word;Color:Byte;Stop:Char);
Procedure MEM_WriteUncolor(X,Y:Byte;P:String);
Procedure MEM_WriteUncolorAs(X,Y:Byte;P:String;Stop:Char);
Procedure MEM_WriteUncolorToAs(X,Y:Byte;P:String;Pos:Word;Stop:Char);

Function MEM_GetCharXY(X,Y:Byte):Char;
Function MEM_GetPage:Byte;
Function MEM_PortVideo:Word;
Function MEM_SizePageVideo:Word;
Function MEM_GetVideoMode:Byte;
Function TextHeight:Byte;
Function TextSegment:Word;
Function XPixelNum:Word;
Function XTextNum:Byte;
Function YPixelNum:Word;
Function YTextNum:Byte;

(*****************************************************************)
			   IMPLEMENTATION
(*****************************************************************)

Uses Text,TPointer;

Const EOL = 255;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      IO_FullCursor                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure IO_FullCursor;
 Assembler;
 ASM
  {$IFOPT G+}
    PUSH $0000;
    POP  ES;
   {$ELSE}
    XOR AX,AX;
    MOV ES,AX;
   {$ENDIF}
   MOV DX,ES:[$0463];
   {$IFOPT G+}
    MOV AX,$000A;
   {$ELSE}
    MOV AL,$0A;
   {$ENDIF}
   OUT DX,AX;
   INC AL;
   MOV AH,ES:[$0485];
   CMP AH,0;
   JNE @@3;
   CMP DX,$3D4;
   JNE @@1;
   MOV AH,$07;
   JMP @@3;
@@1:
   MOV AH,$0C;
@@3:
   OUT DX,AX;
 END;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     IO_CloseCursor                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Nom :

   IO_CloseCursor - Video MDA,CGA,EGA,MCGA,VGA,SVGA

  Syntaxe :

   Procedure IO_CloseCursor;

  Prototype dans :

   MEM_TXT.PAS

  Description :

   ş Fait disparaitre le curseur des modes vid‚o texte.

  Note :

   ş Cette m‚thode ne fonctionne que sur des cartes vid‚o
     100% compatible.

 }

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure IO_CloseCursor;
  Assembler;
  ASM
   {$IFOPT G+}
    PUSH $0000;
    POP  ES;
   {$ELSE}
    XOR AX,AX;
    MOV ES,AX;
   {$ENDIF}
   MOV DX,ES:[$0463];
   MOV AX,$200A;
   OUT DX,AX;
   INC AL;
   OUT DX,AX;
  END;

 {$ELSE}

  Procedure IO_CloseCursor;
  Begin
   PortW[MemW[$0040:$0063]] := $200A;
   PortW[MemW[$0040:$0063]] := $200B;
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      IO_SetCursor                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure IO_SetCursor(Start,Finish:Byte);
  Assembler;
  ASM
   {$IFOPT G+}
    PUSH $0000;
    POP  ES;
   {$ELSE}
    XOR AX,AX;
    MOV ES,AX;
   {$ENDIF}
   MOV DX,ES:[$0463];
   MOV AL,$0A;
   MOV AH,Start;
   OUT DX,AX;
   INC AL;
   MOV AH,Finish;
   OUT DX,AX;
  END;

 {$ELSE}

  Procedure IO_SetCursor(Start,Finish:Byte);
  Begin
   PortW[MemW[$0040:$0063]] := $0A + (Start shl 8);
   PortW[MemW[$0040:$0063]] := $0B + (Finish shl 8);
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    IO_SetPosCursor                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure IO_SetPosCursor(X,Y:Byte);
  Assembler;
  ASM
   {$IFOPT G+}
    PUSH $0000;
    POP  ES;
   {$ELSE}
    XOR AX,AX;
    MOV ES,AX;
   {$ENDIF}
   MOV AL,Y;
   MOV AH,VD.Coln;
   MUL AH;
   XOR DH,DH;
   MOV DL,X;
   ADD AX,DX;
   MOV DX,ES:[$0463];
   MOV BX,AX;
   MOV AL,$0E;
   OUT DX,AX;
   INC AL;
   MOV AH,BL;
   OUT DX,AX;
  END;

 {$ELSE}

  Procedure IO_SetPosCursor(X,Y:Byte);
  Var Base : Word;
  Begin
   Base := (Y * VD.Coln) + X;
   PortW[MemW[$0040:$0063]] := $0E + (Base and $FF00);
   PortW[MemW[$0040:$0063]] := $0F + (Base shl 8);
  END;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   IO_SetPosCursorHome                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure IO_SetPosCursorHome;
  Assembler;
  ASM
   {$IFOPT G+}
    PUSH $0000;
    POP  ES;
   {$ELSE}
    XOR AX,AX;
    MOV ES,AX;
   {$ENDIF}
   MOV DX,ES:[$0463];
   {$IFOPT G+}
    MOV AX,$000E;
   {$ELSE}
    MOV AL,$0E;
   {$ENDIF}
   OUT DX,AX;
   INC AL;
   OUT DX,AX;
  END;

 {$ELSE}

  Procedure IO_SetPosCursorHome;
  Begin
   PortW[MemW[$0040:$0063]] := $0E;
   PortW[MemW[$0040:$0063]] := $0F;
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      IO_Blink                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure IO_Blink(Etat:Boolean);
  Assembler;
  ASM
   {$IFOPT G+}
    PUSH $0000;
    POP  ES;
   {$ELSE}
    XOR AX,AX;
    MOV ES,AX;
   {$ENDIF}
   MOV DX,ES:[$0463];
   ADD DX,4;
   MOV AL,Etat;
   {$IFOPT G+}
    ROR AL,2;
   {$ELSE}
    ROR AL,1;
    ROR AL,1;
   {$ENDIF}
   ADD AL,$09;
   OUT DX,AL;
  END;

 {$ELSE}

  Procedure IO_Blink(Etat:Boolean);
  Begin
   PortW[MemW[$0040:$0063] + 4] := (Byte(Etat) shl 6) + $09;
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      TextHeight                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function TextHeight:Byte;
 Var T : Byte;
 Begin
  T := Mem[$0040:$0085];
  If(T = 0)Then T := 8;
  TextHeight := T;
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       XTextNum                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function XTextNum:Byte;
 Begin
  XTextNum := Mem[$0040:$004A];
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       YTextNum                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function YTextNum:Byte;
 Var T : Byte;
 Begin
  T := Mem[$0040:$0084];
  If(T = 0)Then T := 25 Else Inc(T);
  YTextNum := T;
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       XPixelNum                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function XPixelNum:Word;
 Begin
  XPixelNum := XTextNum shl 3;
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       YPixelNum                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function YPixelNum:Word;
 Begin
  YPixelNum := YTextNum * TextHeight;
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       TextSegment                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function TextSegment:Word;
 Begin
  TextSegment := $B000 + (Byte(MemW[$0040:$0063] = $3D4) * $800);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_GetVideoMode                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function MEM_GetVideoMode:Byte;
 Begin
  MEM_GetVideoMode := Mem[$0040:$0049];
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MEM_GetPage                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function MEM_GetPage:Byte;
 Begin
  MEM_GetPage := Mem[$0040:$0062];
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MEM_GetCharXY                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function MEM_GetCharXY(X,Y:Byte):Char;
 Begin
  MEM_GetCharXY := Char(Mem[VD.Address:(X + (Y * VD.ColnDouble))]);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MEM_SizePageVideo                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function MEM_SizePageVideo:Word;
 Begin
  MEM_SizePageVideo := Mem[$0040:$004C];
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MEM_PortVideo                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function MEM_PortVideo:Word;
 Begin
  MEM_PortVideo := Mem[$0040:$0063];
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MEM_MoveTextUp                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM_MoveTextUp(X1,Y1,X2,Y2:Byte);
 Var J : Byte;
 Begin
  For J := Y1 + 1 to Y2 do
  Begin
   Move2(Mem[VD.Address:(J*VD.Coln+X1) shl 1],
	 Mem[VD.Address:((J-1)*VD.Coln+X1) shl 1],
	 (X2-X1+1));
  End;
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MEM_MoveUp                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM_MoveUp(X1,Y1,X2,Y2:Byte);
 Var J : Byte;
 Begin
  For J := Y1 + 1 to Y2 do
  Begin
   Move(Mem[VD.Address:(J*VD.Coln+X1) shl 1],
	Mem[VD.Address:((J-1)*VD.Coln+X1) shl 1],
	((X2-X1+1) shl 1));
  End;
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_MoveTextDown                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM_MoveTextDown(X1,Y1,X2,Y2:Byte);
 Var J : Byte;
 Begin
  For J := Y2 downto Y1+1 do
  Begin
   Move2(Mem[VD.Address:((J-1)*VD.Coln+X1) shl 1],
	 Mem[VD.Address:(J*VD.Coln+X1) shl 1],
	 (X2-X1+1));
  End;
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_BarSelectHori                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__BarSelectHori(X1,Y,X2:Byte);
 Begin
  MEM_BarSelectHori(X1,Y,X2,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_BarSpaceHori                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__BarSpaceHori(X1,Y,X2:Byte);
 Begin
  MEM_BarSpaceHori(X1,Y,X2,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_BarSpaceVert                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__BarSpaceVert(X,Y1,Y2:Byte);
 Begin
  MEM_BarSpaceVert(X,Y1,Y2,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_BarTextHori                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__BarTextHori(X1,Y,X2:Byte;Chr:Char);
 Begin
  MEM_BarTextHori(X1,Y,X2,Chr,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_BarTextVert                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__BarTextVert(X,Y1,Y2:Byte;Chr:Char);
 Begin
  MEM_BarTextVert(X,Y1,Y2,Chr,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM__ClearColumns                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__ClearColumns(Column:Byte;Chr:Char);
 Begin
  MEM_ClearColumns(Column,Chr,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM__ClearLine                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__ClearLine(Y:Byte;Chr:Char);
 Begin
  MEM_ClearLine(Y,Chr,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM__ClearLineAs                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__ClearLineAs(Y,X2:Byte;Chr:Char);
 Begin
  MEM_ClearLineAs(Y,X2,Chr,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM__ClearLineSpc                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__ClearLineSpc(Y:Byte);
 Begin
  MEM__ClearLine(Y,' ');
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM__ClearScreen                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__ClearScreen;
 Begin
  MEM_ClearScreen(VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM__ClearWindow                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__ClearWindow(X1,Y1,X2,Y2:Byte);
 Begin
  MEM_ClearWindow(X1,Y1,X2,Y2,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MEM__FillBox                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__FillBox(X1,Y1,X2,Y2:Byte;Chr:Char);
 Begin
  MEM_FillBox(X1,Y1,X2,Y2,Chr,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM__PutEmptyBorder               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__PutEmptyBorder(X1,Y1,X2,Y2:Byte);
 Begin
  MEM_PutEmptyBorder(X1,Y1,X2,Y2,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MEM__SetAttr                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__SetAttr(X,Y:Byte);
 Begin
  MEM_SetAttr(X,Y,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MEM__SetCube                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__SetCube(X,Y:Byte;Chr:Char);
 Begin
  MEM_SetCube(X,Y,Chr,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MEM__SetSpace                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__SetSpace(X,Y:Byte);
 Begin
  MEM__SetCube(X,Y,' ');
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM__PutFillBorder                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure MEM__PutFillBorder(X1,Y1,X2,Y2:Byte);
 Begin
  MEM_PutFillBorder(X1,Y1,X2,Y2,VC.NorColor);
 End;

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MEM_BarCharHori                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_BarCharHori(X1,Y,X2:Byte;Chr:Char);
  Assembler;
  ASM
   MOV CH,Chr;
   MOV DH,VD.Coln;
   MOV ES,VD.Address;
   MOV CL,X1;
   MOV BL,X2;
   MOV AL,Y;
   MUL DH;
   MOV SI,AX;
   XOR AH,AH;
   MOV AL,CL;
   ADD SI,AX;
   SHL SI,1;
@@1:
   MOV ES:[SI],CH;
   CMP CL,BL;
   JGE @@2;
   INC CL;
   INC SI;
   INC SI;
   JMP @@1;
@@2:
  END;

 {$ELSE}

  Procedure MEM_BarCharHori(X1,Y,X2:Byte;Chr:Char);
  Var I : Byte;
  Begin
   For I := X1 to X2 do Mem[VD.Address:(I+(Y*VD.Coln)) shl 1] := Byte(Chr);
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   MEM_BarSelectHori                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_BarSelectHori(X1,Y,X2,Color:Byte);
  Assembler;
  ASM
   MOV CH,Color;
   MOV DH,VD.Coln;
   MOV ES,VD.Address;
   MOV CL,X1;
   MOV BL,X2;
   MOV AL,Y;
   MUL DH;
   MOV SI,AX;
   XOR AH,AH;
   MOV AL,CL;
   ADD SI,AX;
   SHL SI,1;
@@1:
   MOV ES:[SI+1],CH;
   CMP CL,BL;
   JGE @@2;
   INC CL;
   INC SI;
   INC SI;
   JMP @@1;
@@2:
  END;

 {$ELSE}

  Procedure MEM_BarSelectHori(X1,Y,X2,Color:Byte);
  Var I : Byte;
  Begin
   For I := X1 to X2 do Mem[VD.Address:((I+(Y*VD.Coln)) shl 1) + 1] := Color;
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   MEM_BarSpaceHori                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_BarSpaceHori(X1,Y,X2,Color:Byte);
  Var Off : Word;
  Begin
   Off := (X1 + (Y * VD.Coln)) shl 1;
   ASM
    MOV ES,VD.Address;
    MOV DI,Off;
    XOR CH,CH;
    MOV CL,X2;
    SUB CL,X1;
    INC CL;
    MOV AH,Color;
    MOV AL,' ';
    CLD;
    REP STOSW;
   END;
  End;

 {$ELSE}

  Procedure MEM_BarSpaceHori(X1,Y,X2,Color:Byte);
  Begin
   FillWord(Mem[VD.Address:(X1+(Y*VD.Coln)) shl 1],X2-X1+1,Byte(' ') + (Color shl 8));
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_BarTextHori                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
  Var Off : Word;
  Begin
   Off := (X1 + (Y * VD.Coln)) shl 1;
   ASM
    MOV ES,VD.Address;
    MOV DI,Off;
    XOR CH,CH;
    MOV CL,X2;
    SUB CL,X1;
    INC CL;
    MOV AH,Color;
    MOV AL,Chr;
    CLD;
    REP STOSW;
   END;
  End;

 {$ELSE}

  Procedure MEM_BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
  Begin
   FillWord(Mem[VD.Address:(X1+(Y*VD.Coln)) shl 1],X2-X1+1,Byte(Chr) + (Color shl 8));
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_ClearLine                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_ClearLine(Y:Byte;Chr:Char;Color:Byte);
  Assembler;
  ASM
   MOV ES,VD.Address;
   MOV AL,Y;
   MUL VD.Coln;
   SHL AX,1;
   MOV DI,AX;
   XOR CH,CH;
   MOV CL,VD.Coln;
   MOV AH,Color;
   MOV AL,Chr;
   CLD;
   REP STOSW;
  END;

 {$ELSE}

  Procedure MEM_ClearLine(Y:Byte;Chr:Char;Color:Byte);
  Begin
   FillWord(Mem[VD.Address:(Y*VD.Coln) shl 1],VD.Coln,Byte(Chr) + (Color shl 8));
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_ClearLineAs                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte);
  Assembler;
  ASM
   MOV ES,VD.Address;
   MOV AL,Y;
   MUL VD.Coln;
   SHL AX,1;
   MOV DI,AX;
   XOR CH,CH;
   MOV CL,X2;
   INC CL;
   MOV AH,Color;
   MOV AL,Chr;
   CLD;
   REP STOSW;
  END;

 {$ELSE}

  Procedure MEM_ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte);
  Begin
   FillWord(Mem[VD.Address:(Y*VD.Coln) shl 1],X2+1,Byte(Chr) + (Color shl 8));
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_ClearLineSpc                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_ClearLineSpc(Y,Color:Byte);
  Assembler;
  ASM
   MOV ES,VD.Address;
   MOV AL,Y;
   MUL VD.Coln;
   SHL AX,1;
   MOV DI,AX;
   XOR CH,CH;
   MOV CL,VD.Coln;
   MOV AH,Color;
   MOV AL,' ';
   CLD;
   REP STOSW;
  END;

 {$ELSE}

  Procedure MEM_ClearLineSpc(Y,Color:Byte);
  Begin
   FillWord(Mem[VD.Address:(Y*VD.Coln) shl 1],VD.Coln,Byte(' ') + (Color shl 8));
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_ClearScreen                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_ClearScreen(Color:Byte);
  Assembler;
  ASM
   MOV ES,VD.Address;
   XOR DI,DI;
   MOV AL,VD.Coln;
   MUL VD.Line;
   MOV CX,AX;
   MOV AH,Color;
   MOV AL,' ';
   CLD;
   REP STOSW;
  END;

 {$ELSE}

  Procedure MEM_ClearScreen(Color:Byte);
  Begin
   FillWord(Mem[VD.Address:0],VD.Coln*VD.Line,Byte(' ') + (Color shl 8));
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MEM_ClearWindow                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_ClearWindow(X1,Y1,X2,Y2,Color:Byte);
  Assembler;
  ASM
   MOV DL,' ';
   MOV DH,Color;
   MOV DI,DX;
   MOV DL,X1;
   MOV DH,VD.Coln;
   MOV ES,VD.Address;
   MOV BL,X2;
   MOV BH,Y2;
   MOV CH,Y1;
@@1:
   MOV CL,DL;
   MOV AL,CH;
   MUL DH;
   MOV SI,AX;
   XOR AH,AH;
   MOV AL,CL;
   ADD SI,AX;
   SHL SI,1;
@@2:
   MOV ES:[SI],DI;
   CMP CL,BL;
   JGE @@3;
   INC CL;
   INC SI;
   INC SI;
   JMP @@2;
@@3:
   CMP CH,BH;
   JGE @@4;
   INC CH;
   JMP @@1;
@@4:
  END;

 {$ELSE}

  Procedure MEM_ClearWindow(X1,Y1,X2,Y2,Color:Byte);
  Var J : Byte;
  Begin
   For J := Y1 to Y2 do
   Begin
    FillWord(Mem[VD.Address:((J*VD.Coln)+X1) shl 1],X2-X1+1,Byte(' ') + (Color shl 8));
   End;
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MEM_FillBox                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
  Assembler;
  ASM
   MOV DL,Chr;
   MOV DH,Color;
   MOV DI,DX;
   MOV DL,X1;
   MOV DH,VD.Coln;
   MOV ES,VD.Address;
   MOV BL,X2;
   MOV BH,Y2;
   MOV CH,Y1;
@@1:
   MOV CL,DL;
   MOV AL,CH;
   MUL DH;
   MOV SI,AX;
   XOR AH,AH;
   MOV AL,CL;
   ADD SI,AX;
   SHL SI,1;
@@2:
   MOV ES:[SI],DI;
   CMP CL,BL;
   JGE @@3;
   INC CL;
   INC SI;
   INC SI;
   JMP @@2;
@@3:
   CMP CH,BH;
   JGE @@4;
   INC CH;
   JMP @@1;
@@4:
  END;

 {$ELSE}

  Procedure MEM_FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
  Var J : Byte;
  Begin
   For J := Y1 to Y2 do
   Begin
    FillWord(Mem[VD.Address:((J*VD.Coln)+X1) shl 1],X2-X1+1,Byte(Chr) + (Color shl 8));
   End;
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MEM_SetAttr                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_SetAttr(X,Y,Color:Byte);
  Assembler;
  ASM
   MOV AL,Y;
   MOV AH,VD.Coln;
   MUL AH;
   MOV DI,AX;
   XOR AH,AH;
   MOV AL,X;
   ADD DI,AX;
   SHL DI,1;
   INC DI;
   MOV AL,Color;
   MOV ES,VD.Address;
   STOSB;
  END;

 {$ELSE}

  Procedure MEM_SetAttr(X,Y,Color:Byte);
  Begin
   Mem[VD.Address:(((Y * VD.Coln) + X) shl 1) + 1] := Color;
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MEM_SetChar                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_SetChar(X,Y:Byte;Chr:Char);
  Assembler;
  ASM
   MOV AL,Y;
   MOV AH,VD.Coln;
   MUL AH;
   MOV DI,AX;
   XOR AH,AH;
   MOV AL,X;
   ADD DI,AX;
   SHL DI,1;
   MOV AL,Chr;
   MOV ES,VD.Address;
   STOSB;
  END;

 {$ELSE}

  Procedure MEM_SetChar(X,Y:Byte;Chr:Char);
  Begin
   Mem[VD.Address:((Y * VD.Coln) + X) shl 1] := Byte(Chr);
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MEM_SetCube                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_SetCube(X,Y:Byte;Chr:Char;Color:Byte);
  Assembler;
  ASM
   MOV AL,Y;
   MOV AH,VD.Coln;
   MUL AH;
   MOV DI,AX;
   XOR AH,AH;
   MOV AL,X;
   ADD DI,AX;
   SHL DI,1;
   MOV AL,Chr;
   MOV AH,Color;
   MOV ES,VD.Address;
   STOSW;
  END;

 {$ELSE}

  Procedure MEM_SetCube(X,Y:Byte;Chr:Char;Color:Byte);
  Begin
   MemW[VD.Address:((Y * VD.Coln) + X) shl 1] := Byte(Chr) + (Color shl 8);
  End;

 {$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MEM_WriteText                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure MEM_WriteText(X,Y:Byte;Chn:String;Color:Byte);
  Var Buffer : Array[0..511] of Byte;
      S,O    : Word;
      I,L    : Byte;
  Begin
   L := Length(Chn);
   S := Seg(Buffer); O := Ofs(Buffer);
   ASM
    MOV ES,S;
    MOV DI,O;
    MOV CL,L;
    XOR CH,CH;
    MOV AH,Color;
    CLD
    REP STOSW;
   END;
   For I := 1 to L do Buffer[(I-1) shl 1] := Byte(Chn[I]);
   Move(Buffer,Mem[VD.Address:(X+(Y*VD.Coln)) shl 1],L shl 1);
  End;

 {$ELSE}

  Procedure MEM_WriteText(X,Y:Byte;Chn:String;Color:Byte);
  Var I : Byte;
  Begin
   For I := 1 to Length(Chn) do
   Begin
    MemW[VD.Address:((Y*VD.Coln) + X + I-1) shl 1] := Byte(Chn[I]) + (Color shl 8);
   End;
  End;

 {$ENDIF}

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                   MEM_BarCharVert                    ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_BarCharVert(X,Y1,Y2:Byte;Chr:Char);
 Var I : Byte;
 Begin
  For I := Y1 to Y2 do MEM_SetChar(X,I,Chr);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                 MEM_BarSelectVert                    ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_BarSelectVert(X,Y1,Y2,Color:Byte);
 Var I : Byte;
 Begin
  For I := Y1 to Y2 do MEM_SetAttr(X,I,Color);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                  MEM_BarSpaceVert                    ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_BarSpaceVert(X,Y1,Y2,Color:Byte);
 Var I : Byte;
 Begin
  For I := Y1 to Y2 do MEM_SetCube(X,I,' ',Color);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                   MEM_BarTextVert                    ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_BarTextVert(X,Y1,Y2:Byte;Chr:Char;Color:Byte);
 Var I : Byte;
 Begin
  For I := Y1 to Y2 do MEM_SetCube(X,I,Chr,Color);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                   MEM_ClearColumns                   ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_ClearColumns(Column:Byte;Chr:Char;Color:Byte);
 Var I : Byte;
 Begin
  For I := 0 to VD.MaxY do MEM_SetCube(Column,I,Chr,Color);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                   MEM_ClearLineUnColor               ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_ClearLineUncolor(Line:Byte;Chr:Char);
 Var I : Byte;
 Begin
  For I := 0 to VD.MaxX do MEM_SetChar(I,Line,Chr);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                    MEM_InitVideo                     ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_InitVideo;
 Begin
  VD.Coln       := XTextNum;
  VD.Line       := YTextNum;
  VD.Address    := TextSegment;
  VD.ColnDouble := VD.Coln shl 1;
  VD.HalfMaxX   := (VD.Coln shr 1) - 1;
  VD.MaxX       := VD.Coln - 1;
  VD.MaxY       := VD.Line - 1;
  VD.Page       := MEM_GetPage;
  VC.RX         := 0;
  VC.RY         := 0;
  {$IFDEF __ISDRIVERVIDEO__}
   VC.Coln    := VD.Coln;
   VC.Line    := VD.Line;
   VC.MaxColn := VD.Coln - 1;
   VC.MaxLine := VD.Line - 1;
   VC.NumX    := XPixelNum;
   VC.NumY    := YPixelNum;
   VC.Methode := ScrnDirect;
  {$ENDIF}
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                  MEM_PutBorderUnColor                ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_PutBorderUncolor(X1,Y1,X2,Y2:Byte);
 Begin
  MEM_BarCharVert(X1,Y1+1,Y2-1,VC.Border[3]);
  MEM_BarCharVert(X2,Y1+1,Y2-1,VC.Border[4]);
  MEM_BarCharHori(X1+1,Y1,X2-1,VC.Border[1]);
  MEM_BarCharHori(X1+1,Y2,X2-1,VC.Border[6]);
  MEM_SetChar(X1,Y1,VC.Border[0]);
  MEM_SetChar(X1,Y2,VC.Border[5]);
  MEM_SetChar(X2,Y1,VC.Border[2]);
  MEM_SetChar(X2,Y2,VC.Border[7]);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                  MEM_PutEmptyBorder                  ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_PutEmptyBorder(X1,Y1,X2,Y2,Color:Byte);
 Begin
  MEM_BarTextVert(X1,Y1+1,Y2-1,VC.Border[3],Color);
  MEM_BarTextVert(X2,Y1+1,Y2-1,VC.Border[4],Color);
  MEM_BarTextHori(X1+1,Y1,X2-1,VC.Border[1],Color);
  MEM_BarTextHori(X1+1,Y2,X2-1,VC.Border[6],Color);
  MEM_SetCube(X1,Y1,VC.Border[0],Color);
  MEM_SetCube(X1,Y2,VC.Border[5],Color);
  MEM_SetCube(X2,Y1,VC.Border[2],Color);
  MEM_SetCube(X2,Y2,VC.Border[7],Color);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                   MEM_PutFillBorder                  ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_PutFillBorder(X1,Y1,X2,Y2,Color:Byte);
 Begin
  If((X1 <> X2)and(Y1 <> Y2))Then
  Begin
   MEM_ClearWindow(X1,Y1,X2,Y2,Color);
   If(VD.Shade)Then
   Begin
    If(X2+1 <= VD.MaxX)Then
    Begin
     MEM_BarSelectHori(X1+2,Y2+1,X2+2,7);
     MEM_BarSelectVert(X2+1,Y1+1,Y2+1,7);
     MEM_BarSelectVert(X2+2,Y1+1,Y2+1,7);
    End;
   End;
   If(VD.SpaceBorde)Then MEM_PutBorderUncolor(X1+2,Y1+1,X2-2,Y2-1)
		    else MEM_PutBorderUncolor(X1,Y1,X2,Y2);
  End;
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                    MEM_SetBlink                      ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_SetBlink(Nombre:Boolean);
 Begin
  BIOS_EGA_Blink(Nombre);
  IO_Blink(Nombre);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                  MEM_SetBorderShade                  ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_SetBorderShade(Autorise:Boolean);
 Begin
  VD.Shade := Autorise;
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                  MEM_SetBorderSpace                  ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_SetBorderSpace(Autorise:Boolean);
 Begin
  VD.SpaceBorde := Autorise;
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                    MEM_SetSpace                      ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_SetSpace(X,Y,Color:Byte);
 Begin
  MEM_SetCube(X,Y,' ',Color);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                  MEM_SetVideoModeText                ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_SetVideoModeText(Mode:ShortInt);
 Begin
  BIOS_SetVideoMode(Mode);
  MEM_InitVideo;
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                   MEM_CenterText                     ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_CenterText(Y:Byte;Chn:String;Color:Byte);
 Begin
  MEM_WriteText((VD.Coln - Length(Chn)) shr 1,Y,Chn,Color);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                    MEM__WriteText                    ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM__WriteText(X,Y:Byte;Chn:String);
 Var I : Byte;
 Begin
  For I := 1 to Length(Chn) do MEM_SetCube(X+I-1,Y,Chn[I],VC.NorColor);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                  MEM__WriteTyping                    ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM__WriteTyping(Chn:String);
 Var I    : Word;
     J, X : Byte;
     FC   : Boolean;
 Begin
  X := VC.RX; FC := True;
  For J := 1 to Length(Chn) do
  Begin
   If((Chn[J] > #31)and Not(Chn[J] in ['^','|','~']))Then
   Begin
    If(FC)Then MEM__SetCube(VC.RX,VC.RY,Chn[J])
	  else MEM_SetChar(VC.RX,VC.RY,Chn[J]);
    Inc(VC.RX);
   End
    else
   Case Chn[J] of
    '|': Begin
	  VC.RX := X; Inc(VC.RY);
	 End;
     #2: Dec(VC.RY);
    '~': Begin
	  Inc(J); FC := True;
          {$IFNDEF __ISDRIVERVIDEO__}
	   SetColor(Byte(Chn[J]));
          {$ELSE}
           VC.LastColor := VC.NorColor;
           VC.NorColor  := Byte(Chn[J]);
          {$ENDIF}
	 End;
     #4: Begin
	  Inc(J);
	  If(Boolean(Chn[J]))Then
	  Begin
	   If(FC)Then MEM__BarSpaceHori(VC.RX,VC.RY,VC.RX+Length(Chn[J])-1)
		 else MEM_BarCharHori(VC.RX,VC.RY,VC.RX+Length(Chn[J])-1,' ');
	  End;
	 End;
     #5: Inc(VC.RY);
     #6: Dec(VC.RX);
     #8: Inc(VC.RX);
     #9: Begin
	  If(FC)Then MEM__BarSpaceHori(VC.RX,VC.RY,VC.RX+7)
		else MEM_BarCharHori(VC.RX,VC.RY,VC.RX+7,' ');
	  Inc(VC.RX,7);
	 End;
    #10: Begin
	  Inc(VC.RX); Inc(VC.RY);
	 End;
    #11: Begin
	  Dec(VC.RX); Inc(VC.RY);
	 End;
    #12: Begin
	  Inc(VC.RX); Dec(VC.RY);
	 End;
     #1: Begin
	  Dec(VC.RX); Dec(VC.RY);
	 End;
    #14: Begin
	  Dec(VC.RX,2); Dec(VC.RY);
	 End;
    #15: Begin
	  Dec(VC.RX,2); Inc(VC.RY);
	 End;
    #16: Begin
	  Inc(J); VC.RX := Byte(Chn[J]);
	  Inc(J); VC.RY := Byte(Chn[J]);
	 End;
    '^': Begin
	  FC := True;
          {$IFNDEF __ISDRIVERVIDEO__}
           SwitchColor;
          {$ELSE}
           ChgChr(VC.LastColor,VC.NorColor);
          {$ENDIF}
	 End;
    #28: FC := False;
    #29: MEM__ClearLine(VC.RY,' ');
    #30: Begin
	  Inc(J);
	  MEM_SetChar(VC.RX,VC.RY,Chn[J]);
	  Inc(VC.RX);
	 End;
    #31: Begin
	  MEM__SetAttr(VC.RX,VC.RY);
	  Inc(VC.RX);
	 End;
   End;
  End;
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                    MEM_WriteAs                       ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_WriteAs(X,Y:Byte;Chn:String;Color:Byte;Stop:Char);
 Var I : Byte;
 Begin
  I := 0;
  Repeat
   MEM_SetCube(X+I,Y,Chn[I+1],Color);
   Inc(I);
  Until ((Chn[I+1] <> Stop)and(I < Length(Chn)));
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                   MEM_WriteOnlyColor                 ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_WriteOnlyColor(X,Y:Byte;Chn:String;Color:Byte);
 Var I : Byte;
 Begin
  For I := 1 to Length(Chn) do MEM_SetAttr(X+I-1,Y,Color);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                  MEM_WriteOnlyColorAnd               ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_WriteOnlyColorAnd(X,Y:Byte;Chn:String;Num,Color:Byte);
 Var I : Byte;
 Begin
  For I := 1 to Num + Length(Chn) do MEM_SetAttr(X+I-1,Y,Color);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                    MEM_WriteToAs                     ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_WriteToAs(X,Y:Byte;P:String;Pos:Word;Color:Byte;Stop:Char);
 Var I : Byte;
 Begin
  I := Pos;
  Repeat
   MEM_SetCube(X+I,Y,P[I+1],Color);
   Inc(I);
  Until (P[I] <> Stop)and(I < Length(P));
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                   MEM_WriteTypingXY                  ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_WriteTypingXY(X,Y:Byte;Chn:String);
 Begin
  VC.RX := X; VC.RY := Y;
  MEM__WriteTyping(Chn);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³               MEM_WriteTypingXYBiColor               ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_WriteTypingXYBicolor(X,Y:Byte;Chn:String;Color1,Color2:Byte);
 Var T1,T2 : Byte;
 Begin
  T1 := VC.LastColor;
  T2 := VC.NorColor;
  VC.LastColor := Color1;
  VC.NorColor  := Color2;
  MEM_WriteTypingXY(X,Y,Chn);
  VC.LastColor := T1;
  VC.NorColor  := T2;
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                   MEM_WriteUnColor                   ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_WriteUncolor(X,Y:Byte;P:String);
 Var I : Byte;
 Begin
  For I := 1 to Length(P) do MEM_SetChar(X+I-1,Y,P[I]);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                  MEM_WriteUnColorAs                  ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_WriteUncolorAs(X,Y:Byte;P:String;Stop:Char);
 Var I : Byte;
 Begin
  I := 0;
  Repeat
   MEM_SetChar(X+I,Y,P[I+1]);
   Inc(I);
  Until (I < Length(P))and(P[I] <> Stop);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                 MEM_WriteUnColorToAs                 ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_WriteUncolorToAs(X,Y:Byte;P:String;Pos:Word;Stop:Char);
 Var I : Byte;
 Begin
  I := Pos;
  Repeat
   MEM_SetChar(X+I,Y,P[I+1]);
   Inc(I);
  Until (I < Length(P))and(P[I] <> Stop);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                     MEM_PutBox                       ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_PutBox(X1,Y1,X2,Y2:Byte;Var Buffer);
 Var J,XS,YS : Byte;
     DXS     : Word;
     TBuffer : ^TByte;
 Begin
  If(X2 = EOL)Then X2 := VD.MaxX;
  XS := (X2 - X1) + 1; DXS := XS shl 1;
  If(Y2 = Y1)Then
  Begin
   Numeric.Move(Buffer,Mem[VD.Address:(X1+(Y1*VD.Coln)) shl 1],DXS);
  End
   else
  Begin
   TBuffer := @Buffer;
   YS := Y2 - Y1;
   For J := 0 to YS do
   Begin
    Numeric.Move(TBuffer^[((XS * J) shl 1)],
                 Mem[VD.Address:(X1+((Y1+J)*VD.Coln)) shl 1],DXS);
   End;
  End;
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                     MEM_SaveBox                      ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure MEM_SaveBox(X1,Y1,X2,Y2:Byte;Var Buffer);
 Var J,XS,YS : Byte;
     DXS     : Word;
     TBuffer : ^TByte;
 Begin
  If(X2 = EOL)Then X2 := VD.MaxX;
  XS := (X2 - X1) + 1; DXS := XS shl 1;
  If(Y2 = Y1)Then
  Begin
   Numeric.Move(Mem[VD.Address:(X1+(Y1*VD.Coln)) shl 1],Buffer,DXS);
  End
   else
  Begin
   TBuffer := @Buffer;
   YS := Y2 - Y1;
   For J := 0 to YS do
   Begin
    Numeric.Move(Mem[VD.Address:(X1+((Y1+J)*VD.Coln)) shl 1],
	         TBuffer^[((XS * J) shl 1)],DXS);
   End;
  End;
 End;

BEGIN { Main Unit }
END.
