(********************************************************)
(*                                                      *)
(*          Malte System/Direct Graphic Text            *)
(*                    1993/03/09                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Directive de compilation conditionnel :

   __BACKREAL__   Indique qu'il faut coder l'‚crans en
                  format texte en retenant la valeur
                  exacte de la couleur. S'il n'est pas
                  sp‚cifi‚ le codage se fait comme une
                  ‚cran de texte standard … IBM.
}

Unit DirectGT;

(********************************************************)
                       INTERFACE
(********************************************************)

Procedure _WriteTyping(Chn:String);
Procedure BarCharHori(X1,Y,X2:Byte;Chr:Char);
Procedure BarCharVert(X,Y1,Y2:Byte;Chr:Char);
Procedure BarSelectHori(X1,Y,X2,Color:Byte);
Procedure BarSelectVert(X,Y1,Y2,Color:Byte);
Procedure BarSpaceHori(X1,Y,X2,Color:Byte);
Procedure BarSpaceVert(X,Y1,Y2,Color:Byte);
Procedure BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
Procedure BarTextVert(X,Y1,Y2:Byte;Chr:Char;Color:Byte);
Procedure CenterText(Y:Byte;Str:String;Color:Byte);
Procedure ClearColumns(X:Byte;Chr:Char;Color:Byte);
Procedure ClearLine(Y:Byte;Chr:Char;Color:Byte);
Procedure ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte);
Procedure ClearLineUnColor(Y:Byte;Chr:Char);
Procedure ClearScreen(Color:Byte);
Procedure FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
Procedure PutFillBorder(X1,Y1,X2,Y2,Color:Byte);
Procedure SetAttr(X,Y,Color:Byte);
Procedure SetChar(X,Y:Byte;Chr:Char);
Procedure SetCube(X,Y:Byte;Chr:Char;Color:Byte);
Procedure SetMatrix(Start,Number,Height:Word;Var Buffer);
Procedure SetPosInTo(X,Y:ShortInt);
Procedure WriteOnlyColor(X,Y:Byte;Str:String;Color:Byte);
Procedure WriteOnlyColorAnd(X,Y:Byte;Str:String;Num,Color:Byte);
Procedure WriteText(X,Y:Byte;Str:String;Color:Byte);
Procedure WriteUnColor(X,Y:Byte;Str:String);

Function InitBuffer:Boolean;
Function DoneBuffer:Boolean;
Function GetAttr(X,Y:Byte):Byte;
Function GetHeightChar:Byte;
Function GetMaxX:Byte;
Function GetMaxY:Byte;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses Mtx8x16,DirectGraphic,TPointer,Numeric,Text;

Type

     {$IFDEF __BACKREAL__}

      XZone = Record
               Chr       : Char;
               BackColor : Byte;
               ForeColor : Byte;
              End;

     {$ELSE}

      XZone = Record
               Chr   : Char;
               Color : Byte;
              End;

     {$ENDIF}

     BufferChar = Array[0..21844] of XZone;

Var

    BChar               : ^BufferChar;
    TMtx                : ^TByte;
    HeightChar,LM,MX,MY : Byte;
    SizeBChar,SizeTMtx  : Word;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    _WriteTyping                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   D‚finition :

    ş Cette proc‚dure affiche une chaine de caractŠre de
      fa‡on typ‚e. La position est celui int‚gr‚ dans
      cette unit‚. Donc vous pouvez affecter la couleur et
      la position de celui-ci.
}

Procedure _WriteTyping(Chn:String);
Var I    : Word;
    J, X : Byte;
    FC   : Boolean;
Begin
 X := VC.RX; FC := True;
 For J := 1 to Length(Chn) do
 Begin
  If((Chn[J] > #31)and Not(Chn[J] in ['^','|','~']))Then
  Begin
   If(FC)Then SetCube(VC.RX,VC.RY,Chn[J],VC.NorColor)
         else SetChar(VC.RX,VC.RY,Chn[J]);
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
         SetColor(Byte(Chn[J]));
	End;
    #4: Begin
	 Inc(J);
	 If(Boolean(Chn[J]))Then
	 Begin
	  If(FC)Then BarSpaceHori(VC.RX,VC.RY,VC.RX+Length(Chn[J])-1,VC.NorColor)
		else BarCharHori(VC.RX,VC.RY,VC.RX+Length(Chn[J])-1,' ');
	 End;
	End;
    #5: Inc(VC.RY);
    #6: Dec(VC.RX);
    #8: Inc(VC.RX);
    #9: Begin
	 If(FC)Then BarSpaceHori(VC.RX,VC.RY,VC.RX+7,VC.NorColor)
	       else BarCharHori(VC.RX,VC.RY,VC.RX+7,' ');
	 Inc(VC.RX,7);
	End;
   #10: SetPosInTo(1,1);
   #11: SetPosInTo(-1,1);
   #12: SetPosInTo(1,-1);
    #1: SetPosInTo(-1,-1);
   #14: SetPosInTo(-2,-1);
   #15: SetPosInTo(-2,1);
   #16: Begin
	 Inc(J); VC.RX := Byte(Chn[J]);
	 Inc(J); VC.RY := Byte(Chn[J]);
	End;
   '^': Begin
	 FC := True; SwitchColor;
	End;
   #28: FC := False;
   #29: ClearLine(VC.RY,' ',VC.NorColor);
   #30: Begin
	 Inc(J);
         SetChar(VC.RX,VC.RY,Chn[J]);
	 Inc(VC.RX);
	End;
   #31: Begin
         SetAttr(VC.RX,VC.RY,VC.NorColor);
         Inc(VC.RX);
	End;
  End;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BarCharHori                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Procedure BarCharHori(X1,Y,X2:Byte;Chr:Char);

  D‚finition :

   ş Cette proc‚dure affiche le caractŠre sp‚cifier de X1 …
     X2 sur  Y. La couleur des fonds est celle utilis‚ par
     d‚faut.

  Notes :

   ş Il est possible qu'il affiche la mauvais couleur
     lorsque que vous utilisez des fonctions externes …
     cette unit‚ … la position pr‚ciser.

   ş Cette proc‚dure n'existe que dans un but de
     compatibilit‚ avec l'‚cran de texte. Elle n'acc‚lŠre
     en rien la performance de l'affichage.
}

Procedure BarCharHori(X1,Y,X2:Byte;Chr:Char);
Var I : Byte;
Begin
 For I := X1 to X2 do SetChar(I,Y,Chr);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BarCharVert                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

 Syntaxe :

  Procedure BarCharVert(X,Y1,Y2:Byte;Chr:Char);

 D‚finition :

  Affiche le caractŠre sp‚cifi‚ par Chr de Y1 … Y2 sur X.
  La couleur de fond est celle utilis‚ par d‚faut.

  Notes :

   ş Il est possible qu'il affiche la mauvais couleur
     lorsque que vous utilisez des fonctions externes …
     cette unit‚ … la position pr‚ciser.

   ş Cette proc‚dure n'existe que dans un but de
     compatibilit‚ avec l'‚cran de texte. Elle n'acc‚lŠre
     en rien la performance de l'affichage.
}

Procedure BarCharVert(X,Y1,Y2:Byte;Chr:Char);
Var J : Byte;
Begin
 For J := Y1 to Y2 do SetChar(X,J,Chr);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BarSelectHori                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure BarSelectHori(X1,Y,X2,Color:Byte);
Var I : Byte;
Begin
 For I := X1 to X2 do SetAttr(I,Y,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BarSelectVert                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure BarSelectVert(X,Y1,Y2,Color:Byte);
Var J : Byte;
Begin
 For J := Y1 to Y2 do SetAttr(X,J,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BarSpaceHori                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure BarSpaceHori(X1,Y,X2,Color:Byte);
Var I : Byte;
    B : Word;
Begin
 PutFillBox(X1*8,Y*HeightChar,(X2*8)+7,((Y+1)*HeightChar)-1,(Color shr 4));
 For I := X1 to X2 do
 Begin
  B := I + (Y*LM);
  {$IFDEF __BACKREAL__}
   BChar^[B].Chr := ' ';
   BChar^[B].BackColor := Color shr 4;
   BChar^[B].ForeColor := Color and 15;
  {$ELSE}
   BChar^[B].Chr   := ' ';
   BChar^[B].Color := Color;
  {$ENDIF}
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BarSpaceVert                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure BarSpaceVert(X,Y1,Y2,Color:Byte);
Var J : Byte;
    B : Word;
Begin
 PutFillBox(X*8,Y1*HeightChar,X*8,((Y2+1)*HeightChar)-1,(Color shr 4));
 For J := Y1 to Y2 do
 Begin
  B := X + (J*LM);
  {$IFDEF __BACKREAL__}
   BChar^[B].Chr := ' ';
   BChar^[B].BackColor := Color shr 4;
   BChar^[B].ForeColor := Color and 15;
  {$ELSE}
   BChar^[B].Chr   := ' ';
   BChar^[B].Color := Color;
  {$ENDIF}
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BarTextHori                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
Var I : Byte;
Begin
 If(Chr = ' ')Then BarSpaceHori(X1,Y,X2,Color)
  Else
 For I := X1 to X2 do SetCube(I,Y,Chr,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BarTextVert                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure BarTextVert(X,Y1,Y2:Byte;Chr:Char;Color:Byte);
Var J : Byte;
Begin
 If(Chr = ' ')Then BarSpaceVert(X,Y1,Y2,Color)
  Else
 For J := Y1 to Y2 do SetCube(X,J,Chr,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     CenterText                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure CenterText(Y:Byte;Str:String;Color:Byte);
Begin
 WriteText((MX-Length(Str)) shr 1,Y,Str,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     ClearColumns                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure ClearColumns(X:Byte;Chr:Char;Color:Byte);
Var J : Byte;
Begin
 If(Chr = ' ')Then BarSpaceVert(X,0,MY,Color)
  Else
 For J := 0 to MY do SetCube(X,J,Chr,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       ClearLine                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure ClearLine(Y:Byte;Chr:Char;Color:Byte);
Var I : Byte;
Begin
 If(Chr = ' ')Then BarSpaceHori(0,Y,MX,Color)
  Else
 For I := 0 to MX do SetCube(I,Y,Chr,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      ClearLineAs                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte);
Var I : Byte;
Begin
 If(Chr = ' ')Then BarSpaceHori(0,Y,X2,Color)
  Else
 For I := 0 to X2 do SetCube(I,Y,Chr,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   ClearLineUnColor                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure ClearLineUnColor(Y:Byte;Chr:Char);
Var I : Byte;
Begin
 For I := 0 to MX do SetChar(I,Y,Chr);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     ClearScreen                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure ClearScreen(Color:Byte);
Begin
 DirectGraphic.ClearScreen(Color shr 4);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       FillBox                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
Var I,J : Byte;
    B   : Word;
Begin
 If(Chr = ' ')Then
 Begin
  PutFillBox(X1*8,Y1*HeightChar,(X2*8)+7,(Y2+1)*HeightChar-1,(Color shr 4));
  For J := Y1 to Y2 do For I := X1 to X2 do
  Begin
   B := (J * LM) + I;
   {$IFDEF __BACKREAL__}
    BChar^[B].Chr := ' ';
    BChar^[B].ForeColor := Color and 15;
    BChar^[B].BackColor := Color shr 4;
   {$ELSE}
    BChar^[B].Chr   := ' ';
    BChar^[B].Color := Color;
   {$ENDIF}
  End;
 End
  Else
 For J := Y1 to Y2 do
  For I := X1 to X2 do
   SetCube(I,J,Chr,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetPos                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure GetPos(Var X,Y:Byte);
Begin
 X := VC.RX; Y := VC.RY;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   PutFillBorder                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure PutFillBorder(X1,Y1,X2,Y2,Color:Byte);
Var I,J : Byte;
Begin
 FillBox(X1,Y1,X2,Y2,' ',Color);
 If(VC.Border = 'ÛÛÛ'#1#2#5#4#6)Then
 Begin
  BarSpaceHori(X1,Y1,X2,Color);
  PutLineVert(X1*8,Y1*HeightChar,((Y2+1)*HeightChar)-1,Color and 15);
  PutLineHori((X1*8)+1,((Y2+1)*HeightChar)-1,(X2*8)+6,Color and 15);
  PutLineVert((X2*8)+7,Y1*HeightChar,((Y2+1)*HeightChar)-1,Color and 15);
   { Set Memory Map }
  For J := Y1 + 1 to Y2 - 1 do
  Begin
   BChar^[X1+(J*LM)].Chr := #1;
   BChar^[X1+(J*LM)].Chr := #2;
  End;
  For I := X1 to X2 do
  Begin
   {$IFDEF __BACKREAL__}
    BChar^[I+(Y1*LM)].ForeColor := Color and 15;
    BChar^[I+(Y1*LM)].BackColor := Color shr 4;
   {$ELSE}
    BChar^[I+(Y1*LM)].Color := Color;
   {$ENDIF}
   BChar^[I+(Y1*LM)].Chr := #219;
   BChar^[I+(Y2*LM)].Chr := #4;
  End;
  BChar^[X1+(Y2*LM)].Chr := #5;
  BChar^[X2+(Y2*LM)].Chr := #6;
 End
  else
 If Not(VC.Border = '        ')Then
 Begin
  SetCube(X1,Y1,VC.Border[0],Color);
  BarTextHori(X1+1,Y1,X2-1,VC.Border[1],Color);
  SetCube(X2,Y1,VC.Border[2],Color);
  For J := Y1 + 1 to Y2 - 1 do
  Begin
   SetCube(X1,J,VC.Border[3],Color);
   SetCube(X2,J,VC.Border[4],Color);
  End;
  SetCube(X1,Y2,VC.Border[5],Color);
  BarTextHori(X1+1,Y2,X2-1,VC.Border[6],Color);
  SetCube(X2,Y2,VC.Border[7],Color);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetAttr                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetAttr(X,Y,Color:Byte);
Var B : Word;
Begin
 B := (LM*Y) + X;
 SetCube(X,Y,BChar^[B].Chr,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetChar                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetChar(X,Y:Byte;Chr:Char);
{$IFDEF __BACKREAL__}
 Var B : Word;
 Begin
  B := (LM*Y) + X;
  SetCube(X,Y,Chr,(BChar^[B].BackColor shl 4) + BChar^[B].ForeColor and 15);
{$ELSE}
 Begin
  SetCube(X,Y,Chr,BChar^[(LM*Y) + X].Color);
{$ENDIF}
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetCube                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetCube(X,Y:Byte;Chr:Char;Color:Byte);
Var B : Word;
Begin
 B := (LM*Y) + X;
 If(Chr = ' ')Then
 Begin
  PutFillBox(X*8,Y*HeightChar,X*8+7,((Y+1)*HeightChar)-1,Color shr 4);
  BChar^[B].Chr := ' ';
  {$IFDEF __BACKREAL__}
   BChar^[B].BackColor := Color shr 4;
   BChar^[B].ForeColor := Color and 15;
  {$ELSE}
   BChar^[B].Color := Color;
  {$ENDIF}
 End
  else
 Begin
  PutBinByteTo(X*8,Y*HeightChar,TMtx^[HeightChar*Byte(Chr)],
               HeightChar,Color shr 4,Color and 15);
  BChar^[B].Chr := Chr;
  {$IFDEF __BACKREAL__}
   BChar^[B].BackColor := Color shr 4;
   BChar^[B].ForeColor := Color and 15;
  {$ELSE}
   BChar^[B].Color := Color;
  {$ENDIF}
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetMatrix                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetMatrix(Start,Number,Height:Word;Var Buffer);
Begin
 Numeric.Move(Buffer,TMtx^[Start*Height],Number*Height);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetPosInTo                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetPosInTo(X,Y:ShortInt);
Begin
 VC.RX := (VC.RX + X); VC.RY := (VC.RY + Y);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    WriteOnlyColor                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure WriteOnlyColor(X,Y:Byte;Str:String;Color:Byte);
Var I : Byte;
Begin
 For I := 1 to Length(Str) do SetAttr(X+I-1,Y,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  WriteOnlyColorAnd                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure WriteOnlyColorAnd(X,Y:Byte;Str:String;Num,Color:Byte);
Var I,L : Byte;
Begin
 L := (Length(Str)+Num-1);
 For I := 0 to L do SetAttr(X+I,Y,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      WriteText                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure WriteText(X,Y:Byte;Str:String;Color:Byte);
Var I : Byte;
Begin
 For I := 1 to Length(Str) do SetCube(X+I-1,Y,Str[I],Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     WriteUncolor                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure WriteUnColor(X,Y:Byte;Str:String);
Var I : Byte;
Begin
 For I := 1 to Length(Str) do SetChar(X+I-1,Y,Str[I]);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     InitBuffer                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function InitBuffer:Boolean;
Var Addr : Pointer;
Begin
 If(DoneBuffer)Then;
 MX := (DirectGraphic.GetMaxX + 1) div 8; LM := MX;
 MY := (DirectGraphic.GetMaxY + 1) div HeightChar;
 SizeBChar := (MX * MY * SizeOf(XZone));
 Dec(MX); Dec(MY);
 SizeTMtx  := (256 * 16);
 If(MaxAvail < (SizeBChar + SizeTMtx))Then
 Begin
  InitBuffer := False;
  Exit;
 End;
 GetMem(BChar,SizeBChar);
 MemSet(BChar^,SizeBChar,0);
 GetMem(TMtx,SizeTMtx);
 Addr := @Matrix8x16;
 Move(Addr^,TMtx^,SizeTMtx);
 InitBuffer := True;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     DoneBuffer                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function DoneBuffer:Boolean;
Begin
 If(BChar <> NIL)Then
 Begin
  FreeMem(BChar,SizeBChar);
  SizeBChar  := 0;
  FreeMem(TMtx,SizeTMtx);
  SizeTMtx := 0;
 End;
 DoneBuffer := True;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetAttr                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetAttr(X,Y:Byte):Byte;
{$IFDEF __BACKREAL__}
 Var B : Word;
 Begin
  B := X + (Y * LM);
  GetAttr := (BChar^[B].ForeColor and 15) + (BChar^[B].BackColor shl 4);
{$ELSE}
 Begin
  GetAttr := BChar^[X + (Y * LM)].Color;
{$ENDIF}  
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    GetHeightChar                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetHeightChar:Byte;
Begin
 GetHeightChar := HeightChar;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetMaxX                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetMaxX:Byte;
Begin
 GetMaxX := MX;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetMaxY                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetMaxY:Byte;
Begin
 GetMaxY := MY;
End;

BEGIN { Main Unit }
 BChar := NIL; TMtx := NIL;
 SizeBChar := 0; SizeTMtx := 0;
 MX := 79; MY := 24; LM := 80;
 HeightChar := 16;
 SetPos(0,0);
END.
