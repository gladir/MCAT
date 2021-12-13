(********************************************************)
(*                                                      *)
(*                Malte System/Video Key                *)
(*                     1992/12/19                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Directive de compilation conditionnel :

   __EXTERN__    Indique qu'il faut faire appelle … la
                 bibliotŠque externe.
   __EXTERNAL__  Indique qu'il faut faire appelle … la
                 bibliotŠque externe.

}


Unit VidKey;

(********************************************************)
                       INTERFACE
(********************************************************)

Type

     TKey = Array[0..$FFFE div SizeOf(String)] of Pointer;
     PtrKey = ^TKey;

     VideoKeyRecord = Record
                       ColorKey   : Byte;
                       ColorHigh  : Byte;
                       ColorShade : Byte;
                       LeftChar   : Char;
                       RightChar  : Char;
                       Shade      : Boolean;
                      End;

Var

    VideoKey : VideoKeyRecord;

Procedure __PutKeyVert(X,Y,JY,L:Byte;Key:PtrKey);
Procedure _PutVideoKey(X1,Y,X2:Byte);
Procedure _PutVideoKeyText(X1,Y,X2:Byte;Text:String);
Procedure _PutVideoKeyTextNoShade(X1,Y,X2:Byte;Chn:String);
Procedure GetVidKeyMsPos(Var X,Y:Byte);
Procedure PutKeyHori(X,Y,JK:Byte;KeyStr:String);

Function KeyHori(X,Y,JK:Byte;KeyStr:String):Byte;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses Text,Level,Keyboard,Mouse,Numeric,NumText;

Var

    RX,RY : Byte;

{$IFDEF __EXTERN__ OR __EXTERNAL__}
 {$L KEYVIDEO.OBJ }
{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     __PutKeyVert                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure __PutKeyVert(X,Y,JY,L:Byte;Key:PtrKey);
Var J      : Word;
    KeyStr : ^String;
Begin
 For J := 0 to Numeric.WordMax do
 Begin
  KeyStr := @Key^[J];
  If(KeyStr = NIL)Then Exit;
  _PutVideoKeyText(X,Y+J*JY,X+L-1,KeyStr^);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      _PutVideoKey                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERN__ OR __EXTERNAL__}

 Procedure _PutVideoKey(X1,Y,X2:Byte); external;

{$ELSE}

 Procedure _PutVideoKey(X1,Y,X2:Byte);
 Begin
  If(VideoKey.LeftChar <> ' ')Then
  Begin
   SetCube(X1,Y,VideoKey.LeftChar,VideoKey.ColorKey);
   BarSpaceHori(X1+1,Y,X2-1,VideoKey.ColorKey);
   SetCube(X2,Y,VideoKey.RightChar,VideoKey.ColorKey);
  End
   else
  BarSpaceHori(X1,Y,X2,VideoKey.ColorKey);
  If(VideoKey.Shade)Then
  Begin
   SetCube(X2+1,Y,'Ü',VideoKey.ColorShade);
   BarTextHori(X1+1,Y+1,X2+1,'ß',VideoKey.ColorShade);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    __PutVideoKeyText                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERN__ OR __EXTERNAL__}

 Procedure _PutVideoKeyText(X1,Y,X2:Byte;Text:String); external;

{$ELSE}

 Procedure _PutVideoKeyText(X1,Y,X2:Byte;Text:String);
 Var OldLast,Old : Byte;
 Begin
  If(VideoKey.LeftChar <> ' ')Then
  Begin
   SetCube(X1,Y,VideoKey.LeftChar,VideoKey.ColorKey);
   BarSpaceHori(X1+1,Y,X2-1,VideoKey.ColorKey);
   SetCube(X2,Y,VideoKey.RightChar,VideoKey.ColorKey);
  End
   Else
  BarSpaceHori(X1,Y,X2,VideoKey.ColorKey);
  OldLast := GetLastColor; Old := GetColor;
  SetAllColor(VideoKey.ColorHigh,VideoKey.ColorKey);
  WriteTypingXY(X1+(((X2-X1+1)-LengthTyping(Text)) shr 1),Y,Text);
  SetAllColor(OldLast,Old);
  If(VideoKey.Shade)Then
  Begin
   SetCube(X2+1,Y,'Ü',VideoKey.ColorShade);
   BarTextHori(X1+1,Y+1,X2+1,'ß',VideoKey.ColorShade);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                __PutVideoKeyTextNoShade              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERN__ OR __EXTERNAL__}

 Procedure _PutVideoKeyTextNoShade(X1,Y,X2:Byte;Chn:String); external;

{$ELSE}

 Procedure _PutVideoKeyTextNoShade(X1,Y,X2:Byte;Chn:String);
 Var OldLast,Old : Byte;
 Begin
  If(VideoKey.LeftChar <> ' ')Then
  Begin
   SetCube(X1,Y,VideoKey.LeftChar,VideoKey.ColorKey);
   BarSpaceHori(X1+1,Y,X2-1,VideoKey.ColorKey);
   SetCube(X2,Y,VideoKey.RightChar,VideoKey.ColorKey);
  End
   Else
  BarSpaceHori(X1,Y,X2,VideoKey.ColorKey);
  OldLast := GetLastColor; Old := GetColor;
  SetAllColor(VideoKey.ColorHigh,VideoKey.ColorKey);
  WriteTypingXY(X1+(((X2-X1+1)-LengthTyping(Chn)) shr 1),Y,Chn);
  SetAllColor(OldLast,Old);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetVidKeyMsPos                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure GetVidKeyMsPos(Var X,Y:Byte);
Begin
 X := RX; Y := RY;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       PutKeyHori                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutKeyHori(X,Y,JK:Byte;KeyStr:String);
Var I,LK,NK : Byte;

 Function Search(Position:Byte):String;
 Var I,Start,Len,NC : Byte;
 Begin
  If(NK = 0)Then Search := KeyStr
   else
  Begin
   I := 0; NC := 0;
   While(NC < Position) do
   Begin
    Inc(I);
    If(KeyStr[I] = '|')Then Inc(NC);
   End;
   If(Position > 0)Then Inc(I);
   Start := I;
   While(KeyStr[I] <> '|') do Inc(I);
   If(Position = NK)Then Len := 255 else
   If(Position <> 0)Then Len := I - Start
                    Else Len := I - Start - 1;
   Search := Copy(KeyStr,Start,Len);
  End;
 End;

Begin
 LK := JK - 3; NK := 0;
 For I := 1 to Length(KeyStr) do If(KeyStr[I] = '|')Then Inc(NK);
 For I := 0 to NK do _PutVideoKeyText(X+I*JK,Y,X+I*JK+LK,Search(I));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                         KeyHori                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function KeyHori(X,Y,JK:Byte;KeyStr:String):Byte;
Var I,J,LK,NK           : Byte;
    K,BM,XM,YM,NB,NX,NY : Word;
 
 Function Search(Position:Byte):String;
 Var I,Start,Len,NC : Byte;
 Begin
  If(NK = 0)Then Search := KeyStr
   else
  Begin
   I := 0; NC := 0;
   While(NC < Position) do
   Begin
    Inc(I);
    If(KeyStr[I] = '|')Then Inc(NC);
   End;
   If(Position > 0)Then Inc(I);
   Start := I;
   While(KeyStr[I] <> '|') do Inc(I);
   If(Position = NK)Then Len := 255 else
   If(Position <> 0)Then Len := I - Start
                    Else Len := I - Start - 1;
   Search := Copy(KeyStr,Start,Len);
  End;
 End;

 Procedure PutBar(Colors:Byte);
 Begin
  If Not(Colors = Color.Window.Regular.SelectB)Then
   _PutVideoKeyText(X+I*JK,Y,X+I*JK+LK,Search(I))
  Else
   BarSelectHori(X+I*JK,Y,X+I*JK+LK,Colors);
 End;

Begin
 LK := JK - 3; NK := 0;
 For I := 1 to Length(KeyStr) do If(KeyStr[I] = '|')Then Inc(NK);
 PutKeyHori(X,Y,JK,KeyStr);
 I := 0;
 Repeat
  PutBar(Color.Window.Regular.SelectB);
  {$IFDEF __Mouse__}
   ShowPtr;
   Repeat
    GetButPos(BM,XM,YM);
    If(BM > 0)Then
    Begin
     XM := XM shr 3; YM := YM shr 3;
     HidePtr;
     If(YM = Y)Then
     Begin
      If(XM >= X)and(XM <= (X + ((NK+1) * JK)-1))Then
      Begin
       For J := 0 to NK do
       Begin
        If(XM >= (X + (J * JK)))and(XM <= (X + (J * JK) + LK))Then
        Begin
         PutBar(Color.Window.Regular.Key);
         I := J;
         PutBar(Color.Window.Regular.SelectB);
        End;
       End;
      End
       else
      Begin
       ReleaseKeyMouse;
       RX := XM; RY := YM;
       KeyHori := 252;
       Exit;
      End;
     End
      else
     Begin
      ReleaseKeyMouse;
      RX := XM; RY := YM;
      KeyHori := 252;
      Exit;
     End;
     ShowPtr;
     ReleaseKeyMouse;
     GetButPos(NB,NX,NY);
     NX := NX shr 3;
     If((NY shr 3) = Y)Then
     Begin
      If(NX >= (X + (I * JK)))and(NX <= (X + (I * JK) + LK))Then
      Begin
       KeyHori := I;
       HidePtr;
       Exit;
      End;
     End;
    End;
   Until KeyPressed;
   HidePtr;
  {$ENDIF}
  K := ReadKey;
  Case K of
    kbF1 : Begin
            KeyHori := 253;
            Exit;
           End;
   kbTab : Begin
            PutBar(Color.Window.Regular.Key);
	    If(I < NK)Then Inc(I) else
            Begin
             KeyHori := 254;
             Exit;
            End;
            PutBar(Color.Window.Regular.SelectB);
           End;
   kbEsc : Begin
            KeyHori := 255;
            Exit;
           End;
  kbLeft : If(NK > 0)Then
           Begin
            PutBar(Color.Window.Regular.Key);
            If(I > 0)Then Dec(I) else I := NK;
            PutBar(Color.Window.Regular.SelectB);
	   End;
 kbRight : If(NK > 0)Then
           Begin
            PutBar(Color.Window.Regular.Key);
	    If(I < NK)Then Inc(I) else I := 0;
            PutBar(Color.Window.Regular.SelectB);
	   End;
  End;
 Until (K = kbEnter);
 KeyHori := I;
End;

BEGIN { Main Unit }
 RX := 0; RY := 0;
 VideoKey.ColorKey := $F0;
 VideoKey.ColorHigh := $FC;
 VideoKey.ColorShade := $98;
 VideoKey.LeftChar := ' ';
 VideoKey.RightChar := ' ';
 VideoKey.Shade := True;
END.