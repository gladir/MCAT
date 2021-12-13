(********************************************************)
(*                                                      *)
(*                 Malte System/Windows                 *)
(*                      1993/01/07                      *)
(*                                                      *)
(*       Copyright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System

  DerniŠre modification :

   Vendredi, le 7 mai 1993  (Optimation : Wins.Init,Wins.Done),
                            (Debug : Wins.InitXY).
   Dimanche, le 9 mai 1993  (Addition : Wins.PutTypingXY,
                             Wins.GetPosUserActionInWin).
   Lundi, le 10 mai 1993    (Adaptation PRIVATE : Object Wins).
   Mercredi, le 2 juin 1993 (Addition Wins : IsEmptyStrXY,
                             IsEmptyStr, GetStrXY).


  D‚finition :

   ş Cette unit‚ est le centre de contr“le de
     l'am‚nagements des fenˆtres dans un mˆme ‚cran.

  Directive de compilation de conditionnel :

   __OLDMETHODEWINDOWS__     Indique qu'il faut travailler avec
                             les anciennes m‚thode (C'est … dire
                             qu'il faut utiliser l'unit‚ Window).
}

Unit Windows;

(********************************************************)
                        INTERFACE
(********************************************************)

Uses Level,LuxeVid,Input;

{$I KEY_CST.INC } { Inclusion des constantes de touche
                    du clavier }

Const

      _Close_   = $FFFA;
      _Exit_    = $FFFB;
      _Title_   = $FFFC;
      _Zoom_    = $FFFD;
      _Mouse_   = $FFFE;
      _Unknown_ = $FFFF;

      MaxWin    = $FF;

Type

     StrKey = String[131];
     WinColor = ColorWindowBaseType;
     Wins = Object
             _X1,_Y1,_X2,_Y2,XP,YP:Byte;
             Colors:WinColor;
             Constructor _Init(X1,Y1,X2,Y2:Byte;Title:String;Color:WinColor);
             Constructor _InitCenter(L,H:Byte;Title:String;Color:WinColor);
             Constructor _InitSmallShade(X1,Y1,X2,Y2:Byte;Title:String;Color:WinColor);
             Constructor _InitXY(X,Y,W,H:Byte;Title:String;Color:WinColor);
             Constructor Init(X1,Y1,X2,Y2:Byte;Title:String;Color:WinColor);
             Constructor InitCenter(L,H:Byte;Title:String;Color:WinColor);
             Constructor InitXY(X,Y,W,H:Byte;Title:String;Color:WinColor);
             Procedure _SetPosCursor;
             Procedure ZoomIcon;
             Procedure Ln;
             Procedure BackJumpX(Num:Byte);
             Procedure BackLn;
             Procedure BarSelectHori(X1,Y,X2,Color:Byte);
             Procedure CenterText(Msg:String);
             Procedure CenterTextY(Y:Byte;Msg:String);
             Procedure Clear;
             Procedure ClearEOF;
             Procedure ClearLineToLine(Y1,Y2:Byte);
             Procedure JumpX(Num:Byte);
             Procedure LineSelectHori(Y,Color:Byte);
             Procedure PutTitle(Title:String);
             Procedure PutMsg(Msg:String);
             Procedure PutCube(Chr:Char;Color:Byte);
             Procedure PutTextLn(Msg:String);
             Procedure PutTyping(Msg:String);
             Procedure PutTypingLn(Msg:String);
             Procedure PutTypingXY(X,Y:Byte;Msg:String);
             Procedure PutText(Msg:String);
             Procedure PutTextXY(X,Y:Byte;Msg:String);
             Procedure PutTextXYUnColor(X,Y:Byte;Str:String);
             Procedure PutKeyHori(Key:StrKey);
             Procedure PutKeyHoriDown(Key:StrKey);
             Procedure PutKeyHoriXY(X,Y:Byte;Key:StrKey);
             Procedure SetColorTitle(Color:Byte);
             Procedure SetPos(X,Y:Byte);
             Procedure SetPosCursor(X,Y:Byte);
             Procedure SetX(X:Byte);
             Procedure SetY(Y:Byte);
             Procedure GetPosUserAction(Var X,Y:Byte);
             Procedure GetPosUserActionInWin(Var X,Y:Byte);
             Function GetNumberLineMsg(Msg:String):Byte;
             Function GetKeyHori(Key:StrKey):Word;
             Function GetKeyHoriDown(Key:StrKey):Word;
             Function GetKeyHoriXY(X,Y:Byte;Key:StrKey):Word;
             Function GetStrXY(X,Y:Byte):String;
             Function GetWriteLengthInWin:Byte;
             Function Input(Var Chn:String):Word;
             Function InputMono(Var Chn:String):Word;
             Function InputMonoXY(X,Y:Byte;Var Chn:String):Word;
             Function InputXY(X,Y:Byte;Var Chn:String):Word;
             Function IsCloseIcon(X,Y:Byte):Boolean;
             Function IsEmptyStr:Boolean;
             Function IsEmptyStrXY(X,Y:Byte):Boolean;
             Function IsExitIcon(X,Y:Byte):Boolean;
             Function IsInWindow(X,Y:Byte):Boolean;
             Function IsKeyHoriDown(Key:StrKey):Word;
             Function IsTitle(X,Y:Byte):Boolean;
             Function IsZoomIcon(X,Y:Byte):Boolean;
             Function UserAction:Word;
             Destructor Done;
             PRIVATE
             OldColor:Byte;
             OldLastColor:Byte;
             OldShadeKeyColor:Byte;
             OldKeyColor:Byte;
             Buffer:Pointer;
             Size:Word;
             HaveZoom:Boolean;
             _Title:String;
             XM,YM:Byte;
             {$IFDEF __KEYBUFFER__}
              KeyBuffer:Pointer;
              KeyPattern:Byte;
              Procedure DestroyKeyBuffer;
              Procedure SourceToKeyBuffer(Source:Pointer);
              Procedure CopyKeyStrToKeyBuffer(Key:StrKey;P:Byte);
              Function GetSizeKeyBuffer:Word;
             {$ENDIF}
            End;

Var

    KeyAction : CKeyInputType;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses

     {$IFDEF __Mouse__}
      Mouse,            { Gestionnaire de base de la souris. }
     {$ENDIF}

     KeyBoard,          { Gestionnaire de base du clavier. }
     Memory,
     BiosText,
     DirecTxt,
     {$IFDEF __GRAPHDIRECT__}
      Graphix,
     {$ENDIF}
     Text,              { Centre de contr“le de l'‚cran en
                          format texte. }
     Message,           { Module de centrage de texte dans une
                          fenˆtre d‚terminer. }
     {$IFDEF __OLDMETHODEWINDOWS__}
      Window,           { Gestionnaire de base des fenˆtres. }
     {$ENDIF}
     VidKey,            { Unit‚ de manipulation des touches
                          vid‚os. }
     NumWin;            { Module math‚matique des fenˆtres. Qui
                          gŠre les calculs de bases des fenˆtres. }

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins._Init                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor Wins._Init(X1,Y1,X2,Y2:Byte;Title:String;Color:WinColor);
Begin
 OldLastColor := GetLastColor;
 OldColor := GetColor;
 OldShadeKeyColor := VideoKey.ColorShade;
 OldKeyColor := VideoKey.ColorKey;
 HaveZoom := False; XM := $FF; YM := $FF; _Title := Title;
 {$IFDEF __KEYBUFFER__}
  KeyPattern := 0;
  KeyBuffer := NIL;
 {$ENDIF}
 _X1 := X1; _Y1 := Y1; _X2 := X2; _Y2 := Y2; XP := 0; YP := 0;
 Size := 0;
 Buffer := NIL;
 Colors := Color;
 PutFillBorder(X1,Y1,X2,Y2,Color.Border);
 BarSpaceHori(X1+Length(CloseIcon),Y1,X2,Color.Title);
 WriteText(X1,Y1,CloseIcon,Color.Icon);
 WriteUnColor(X1+(((X2-X1)-(Length(Title))) shr 1),Y1,Title);
 {$IFDEF __GRAPHDIRECT__}
  If(VC.Methode = ScrnGraphDirect)Then
  Begin
   Graphix.SetColor(7);
   Line((X1+Length(CloseIcon))*8,
        (Y1)*GetHeightChar,
        (X1+Length(CloseIcon))*8,
        ((Y1+1)*GetHeightChar)-1);
   LineHori((X1+Length(CloseIcon))*8,
            (Y1)*GetHeightChar,
            ((X2)*8)+7);
   LineHori((X1+Length(CloseIcon))*8,
            ((Y1)*GetHeightChar)+1,
            ((X2)*8)+7);
   Graphix.SetColor(8);
   Line((X2*8)+7,
        (Y1*GetHeightChar)+1,
        (X2*8)+7,
        ((Y1+1)*GetHeightChar)-1);
   LineHori((X1+Length(CloseIcon))*8+1,
            ((Y1+1)*GetHeightChar)-2,
            (X2*8)+7);
   LineHori((X1+Length(CloseIcon))*8+1,
            ((Y1+1)*GetHeightChar)-1,
            (X2*8)+7);
  End;
 {$ENDIF}
 VideoKey.ColorShade := Colors.Shade;
 VideoKey.ColorKey   := Colors.Key;
 SetAllColor(Color.Msg,Color.Normal);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Wins.SetColorTitle               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.SetColorTitle(Color:Byte);
Begin
 WriteText(_X1+(((_X2-_X1)-(Length(_Title))) shr 1),_Y1,_Title,Color);
 {$IFDEF __GRAPHDIRECT__}
  If(VC.Methode = ScrnGraphDirect)Then
  Begin
   Graphix.SetColor(7);
   Line((_X1+Length(CloseIcon))*8,
        (_Y1)*GetHeightChar,
        (_X1+Length(CloseIcon))*8,
        ((_Y1+1)*GetHeightChar)-1);
   LineHori((_X1+Length(CloseIcon))*8,
            (_Y1)*GetHeightChar,
            ((_X2)*8)+7);
   Graphix.SetColor(8);
   Line((_X2*8)+7,
        (_Y1*GetHeightChar)+1,
        (_X2*8)+7,
        ((_Y1+1)*GetHeightChar)-1);
   LineHori((_X1+Length(CloseIcon))*8+1,
            ((_Y1+1)*GetHeightChar)-1,
            (_X2*8)+7);
  End;
 {$ENDIF}
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   Wins.__InitSmallShade              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor Wins._InitSmallShade(X1,Y1,X2,Y2:Byte;Title:String;Color:WinColor);
Var OldShade : Boolean;
Begin
 If(VC.Methode = ScrnDirect)Then OldShade := VD.Shade
                            Else OldShade := VB.Shade;
 SetBorderShade(False);
 OldLastColor := GetLastColor;
 OldColor := GetColor;
 OldShadeKeyColor := VideoKey.ColorShade;
 OldKeyColor := VideoKey.ColorKey;
 HaveZoom := False; XM := $FF; YM := $FF; _Title := Title;
 {$IFDEF __KEYBUFFER__}
  KeyPattern := 0;
  KeyBuffer := NIL;
 {$ENDIF}
 _X1 := X1; _Y1 := Y1; _X2 := X2; _Y2 := Y2; XP := 0; YP := 0;
 Size := 0;
 Buffer := NIL;
 Colors := Color;
 PutFillBorder(X1,Y1,X2,Y2,Color.Border);
 SetCube(X2+1,Y1,'Ü',Color.Shade);
 BarTextVert(X2+1,Y1+1,Y2,'Û',Color.Shade);
 BarTextHori(X1+1,Y2+1,X2+1,'ß',Color.Shade);
 BarSpaceHori(X1+Length(CloseIcon),Y1,X2,Color.Title);
 WriteText(X1,Y1,CloseIcon,Color.Icon);
 WriteUnColor(X1+(((X2-X1)-(Length(Title))) shr 1),Y1,Title);
 {$IFDEF __GRAPHDIRECT__}
  If(VC.Methode = ScrnGraphDirect)Then
  Begin
   Graphix.SetColor(7);
   Line((X1+Length(CloseIcon))*8,
        (Y1)*GetHeightChar,
        (X1+Length(CloseIcon))*8,
        ((Y1+1)*GetHeightChar)-1);
   LineHori((X1+Length(CloseIcon))*8,
            (Y1)*GetHeightChar,
            ((X2)*8)+7);
   Graphix.SetColor(8);
   Line((X2*8)+7,
        (Y1*GetHeightChar)+1,
        (X2*8)+7,
        ((Y1+1)*GetHeightChar)-1);
   LineHori((X1+Length(CloseIcon))*8+1,
            ((Y1+1)*GetHeightChar)-1,
            (X2*8)+7);
  End;
 {$ENDIF}
 VideoKey.ColorShade := Colors.Shade;
 VideoKey.ColorKey   := Colors.Key;
 SetAllColor(Color.Msg,Color.Normal);
 SetBorderShade(OldShade);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.Init                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor Wins.Init(X1,Y1,X2,Y2:Byte;Title:String;Color:WinColor);
{$IFDEF __OLDMETHODEWINDOWS__}
 Var Window : WindowType;
{$ENDIF}
Begin
 OldLastColor := GetLastColor;
 OldColor := GetColor;
 OldShadeKeyColor := VideoKey.ColorShade;
 OldKeyColor := VideoKey.ColorKey;
 HaveZoom := False; XM := $FF; YM := $FF; _Title := Title;
 {$IFDEF __KEYBUFFER__}
  KeyPattern := 0;
  KeyBuffer := NIL;
 {$ENDIF}
 _X1 := X1; _Y1 := Y1; _X2 := X2; _Y2 := Y2; XP := 0; YP := 0;
 Size := Text.GetSizeBox(X1,Y1,X2+2,Y2+1);
 Buffer := MemAlloc(Size);
 If Not(Buffer = NIL)Then
 Begin
  Text.SaveBox(X1,Y1,X2+2,Y2+1,Buffer^);
  Colors := Color;
  {$IFDEF __OLDMETHODEWINDOWS__}
   Window.Init;
   Window.Color.Border   := Color.Border;
   Window.Color.Title    := Color.Title;
   Window.Color.Icon     := Color.Icon;
   Window.Color.Msg      := Color.Msg;
   Window.Color.Key      := Color.Key;
   Window.Color.KeyShade := Color.KeyShade;
   Window.Color.SelectA  := Color.SelectA;
   Window.Color.SelectB  := Color.SelectB;
   Window.Color.Shade    := Color.Shade;
   Window.NoZoom;
   Window.PutWindow(X1,Y1,X2,Y2,Title);
   Window.Done;
  {$ELSE}
   PutFillBorder(X1,Y1,X2,Y2,Color.Border);
   BarSpaceHori(X1+Length(CloseIcon),Y1,X2,Color.Title);
   WriteText(X1,Y1,CloseIcon,Color.Icon);
   WriteUnColor(X1+(((X2-X1)-(Length(Title))) shr 1),Y1,Title);
   {$IFDEF __GRAPHDIRECT__}
    If(VC.Methode = ScrnGraphDirect)Then
    Begin
     Graphix.SetColor(7);
     Line((X1+Length(CloseIcon))*8,
          (Y1)*GetHeightChar,
          (X1+Length(CloseIcon))*8,
          ((Y1+1)*GetHeightChar)-1);
     LineHori((X1+Length(CloseIcon))*8,
              (Y1)*GetHeightChar,
              ((X2)*8)+7);
     Graphix.SetColor(8);
     Line((X2*8)+7,
          (Y1*GetHeightChar)+1,
          (X2*8)+7,
          ((Y1+1)*GetHeightChar)-1);
     LineHori((X1+Length(CloseIcon))*8+1,
              ((Y1+1)*GetHeightChar)-1,
              (X2*8)+7);
    End;
   {$ENDIF}
  {$ENDIF}
  VideoKey.ColorShade := Colors.Shade;
  VideoKey.ColorKey   := Colors.Key;
  SetAllColor(Color.Msg,Color.Normal);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Wins.InitXY                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor Wins.InitXY(X,Y,W,H:Byte;Title:String;Color:WinColor);
Begin
 HaveZoom := False;
 If(W = MaxWin)Then W := GetMaxX - 6;
 If(H = MaxWin)Then H := GetMaxY - 6;
 Init(X,Y,X+W,Y+H,Title,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Wins._InitXY                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor Wins._InitXY(X,Y,W,H:Byte;Title:String;Color:WinColor);
Begin
 HaveZoom := False;
 If(W = MaxWin)Then W := GetMaxX - 6;
 If(H = MaxWin)Then H := GetMaxY - 6;
 _Init(X,Y,X+W,Y+H,Title,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Wins.InitCenter                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor Wins.InitCenter(L,H:Byte;Title:String;Color:WinColor);
Var X1,Y1,X2,Y2 : Byte;
Begin
 If(L = MaxWin)Then L := GetMaxX - 6;
 If(H = MaxWin)Then H := GetMaxY - 6;
 GetSizeWindowCenter(L,H,X1,Y1,X2,Y2);
 Init(X1,Y1,X2,Y2,Title,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Wins._InitCenter                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor Wins._InitCenter(L,H:Byte;Title:String;Color:WinColor);
Var X1,Y1,X2,Y2 : Byte;
Begin
 If(L = MaxWin)Then L := GetMaxX - 6;
 If(H = MaxWin)Then H := GetMaxY - 6;
 GetSizeWindowCenter(L,H,X1,Y1,X2,Y2);
 _Init(X1,Y1,X2,Y2,Title,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Wins.SetPosCursor                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.SetPosCursor(X,Y:Byte);
Begin
 Text.SetPosCursor(_X1+1+X,_Y1+1+Y);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Wins._SetPosCursor               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins._SetPosCursor;
Begin
 Text.SetPosCursor(_X1+1+XP,_Y1+1+YP);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.Clear                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.Clear;
Begin
 ClearWindow(_X1+1,_Y1+1,_X2-1,_Y2-1,Colors.Border);
 XP := 0; YP := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Wins.PutCube                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutCube(Chr:Char;Color:Byte);
Begin
 SetCube(_X1+1+XP,_Y1+1+YP,Chr,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 Wins.ClearLineToLine                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.ClearLineToLine(Y1,Y2:Byte);
Begin
 ClearWindow(_X1+1,_Y1+1+Y1,_X2-1,_Y1+1+Y2,Colors.Border);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.ClearEOF                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.ClearEOF;
Begin
 BarSpaceHori(_X1+1+XP,_Y1+1+YP,_X2-1,Colors.Normal);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  Wins.PutTextXYUnColor               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutTextXYUnColor(X,Y:Byte;Str:String);
Begin
 WriteUnColor(_X1+1+X,_Y1+1+Y,Str);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   Wins.BarSelectHori                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.BarSelectHori(X1,Y,X2,Color:Byte);
Begin
 Text.BarSelectHori(_X1+1+X1,_Y1+1+Y,_X1+1+X2,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  Wins.LineSelectHori                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.LineSelectHori(Y,Color:Byte);
Begin
 Text.BarSelectHori(_X1+1,_Y1+1+Y,_X2-1,Color);
End;

{$IFDEF __KEYBUFFER__}

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                   Wins.DestroyKeyBuffer              ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure Wins.DestroyKeyBuffer;
 Begin
  FreeMem(KeyBuffer,(SizeOf(KeyBuffer) * KeyPattern));
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                 Wins.SourceToKeyBuffer               ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure Wins.SourceToKeyBuffer(Source:Pointer);
 Begin
  Move(Source^,KeyBuffer^,GetSizeKeyBuffer);
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³               Wins.CopyKeyStrToKeyBuffer             ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure Wins.CopyKeyStrToKeyBuffer(Key:StrKey;P:Byte);
 Begin
  Move(Key,Mem[Seg(KeyBuffer^):Ofs(KeyBuffer^)+(SizeOf(Key) * P)],SizeOf(Key));
 End;

 { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                 Wins.GetSizeKeyBuffer                ³Û
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Function Wins.GetSizeKeyBuffer:Word;
 Begin
  GetSizeKeyBuffer := SizeOf(StrKey) * KeyPattern;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   Wins.PutKeyHori                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutKeyHori(Key:StrKey);
Begin
 PutKeyHoriXY(XP,YP,Key);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  Wins.PutKeyHoriXY                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutKeyHoriXY(X,Y:Byte;Key:StrKey);
Var ML,I,L  : Byte;
    {$IFDEF __KEYBUFFER__}
     TBuffer : Pointer;
    {$ENDIF}
Begin
 {$IFDEF __KEYBUFFER__}
  If(KeyPattern = 0)Then
  Begin
   KeyPattern := 1;
   GetMem(KeyBuffer,GetSizeKeyBuffer);
   Move(Key,KeyBuffer^,SizeOf(Key));
  End
   else
  Begin
   TBuffer := NIL;
   GetMem(TBuffer,KeyPattern * SizeOf(Key));
   Move(KeyBuffer^,TBuffer^,GetSizeKeyBuffer);
   DestroyKeyBuffer;
   GetMem(KeyBuffer,(KeyPattern + 1) * SizeOf(Key));
   SourceToKeyBuffer(TBuffer);
   FreeMem(TBuffer,GetSizeKeyBuffer);
   Inc(KeyPattern);
   CopyKeyStrToKeyBuffer(KeyBuffer,KeyPattern);
  End;
 {$ENDIF}
 ML := 0; L := 0;
 For I := 1 to Length(Key) do
 Begin
  If(Key[I] = '|')Then
  Begin
   If(L > ML)Then ML := L;
   L := 0;
  End
   else
  Begin
   If Not(Key[I] in ['^','~'])Then Inc(L);
  End;
 End;
 If(L > ML)Then ML := L;
 Inc(ML,4);
 VidKey.PutKeyHori(_X1+X,_Y1+Y,ML,Key);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  Wins.GetKeyHoriXY                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.GetKeyHoriXY(X,Y:Byte;Key:StrKey):Word;
Var ML,I,L,RX,RY,K : Byte;
Begin
 ML := 0; L := 0;
 For I := 1 to Length(Key) do
 Begin
  If(Key[I] = '|')Then
  Begin
   If(L > ML)Then ML := L;
   L := 0;
  End
   else
  Begin
   If Not(Key[I] in ['^','~'])Then Inc(L);
  End;
 End;
 If(L > ML)Then ML := L;
 Inc(ML,6);
 If(ML < 10)Then ML := 10;
 K := VidKey.KeyHori(_X1+1+X,_Y1+1+Y,ML,Key);
 {$IFDEF __Mouse__}
  If(K = 252)Then
  Begin
   GetVidKeyMsPos(RX,RY);
   XM := RX; YM := RY;
   If(IsCloseIcon(RX,RY))Then GetKeyHoriXY := _Close_ else
   If(IsExitIcon(RX,RY))Then GetKeyHoriXY := _Exit_ else
   If(IsTitle(RX,RY))Then GetKeyHoriXY := _Title_ else
   If(IsZoomIcon(RX,RY))Then GetKeyHoriXY := _Zoom_
                        else GetKeyHoriXY := _Mouse_;
  End
   else
 {$ENDIF}
 If(K = 253)Then GetKeyHoriXY := kbF1 else
 If(K = 254)Then GetKeyHoriXY := kbTab else
 If(K = 255)Then GetKeyHoriXY := kbEsc
  else
 GetKeyHoriXY := K;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 Wins.PutKeyHoriDown                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutKeyHoriDown(Key:StrKey);
Var ML,I,L,RX,RY,K,NK : Byte;
Begin
 ML := 0; L := 0; NK := 0;
 For I := 1 to Length(Key) do
 Begin
  If(Key[I] = '|')Then
  Begin
   If(L > ML)Then ML := L;
   Inc(NK);
   L := 0;
  End
   else
  Begin
   If Not(Key[I] in ['^','~'])Then Inc(L);
  End;
 End;
 If(L > ML)Then ML := L;
 Inc(ML,4);
 If(ML < 8)Then ML := 8;
 VidKey.PutKeyHori(_X1+(((_X2-_X1+1)-(((NK+1)*ML) - 2)) shr 1),_Y2-2,ML,Key);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 Wins.GetKeyHoriDown                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.GetKeyHoriDown(Key:StrKey):Word;
Var ML,I,L,RX,RY,K,NK : Byte;
Begin
 ML := 0; L := 0; NK := 0;
 For I := 1 to Length(Key) do
 Begin
  If(Key[I] = '|')Then
  Begin
   If(L > ML)Then ML := L;
   Inc(NK);
   L := 0;
  End
   else
  Begin
   If Not(Key[I] in ['^','~'])Then Inc(L);
  End;
 End;
 If(L > ML)Then ML := L;
 Inc(ML,4);
 If(ML < 8)Then ML := 8;
 K := VidKey.KeyHori(_X1+(((_X2-_X1+1)-(((NK+1)*ML) - 2)) shr 1),_Y2-2,ML,Key);
 {$IFDEF __Mouse__}
  If(K = 252)Then
  Begin
   GetVidKeyMsPos(RX,RY);
   XM := RX; YM := RY;
   If(IsCloseIcon(RX,RY))Then GetKeyHoriDown := _Close_ else
   If(IsExitIcon(RX,RY))Then GetKeyHoriDown := _Exit_ else
   If(IsTitle(RX,RY))Then GetKeyHoriDown := _Title_ else
   If(IsZoomIcon(RX,RY))Then GetKeyHoriDown := _Zoom_
                        else GetKeyHoriDown := _Mouse_;
  End
   else
 {$ENDIF}
 If(K = 253)Then GetKeyHoriDown := kbF1 else
 If(K = 254)Then GetKeyHoriDown := kbTab else
 If(K = 255)Then GetKeyHoriDown := kbEsc
  else
 GetKeyHoriDown := K;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  Wins.IsKeyHoriDown                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.IsKeyHoriDown(Key:StrKey):Word;
Var X1,ML,I,L,RX,RY,K,NK : Byte;
Begin
 ML := 0; L := 0; NK := 0;
 For I := 1 to Length(Key) do
 Begin
  If(Key[I] = '|')Then
  Begin
   If(L > ML)Then ML := L;
   Inc(NK);
   L := 0;
  End
   else
  Begin
   If Not(Key[I] in ['^','~'])Then Inc(L);
  End;
 End;
 If(L > ML)Then ML := L;
 Inc(ML,4);
 If(ML < 8)Then ML := 8;
 RX := XM; RY := YM;
 X1 := _X1+(((_X2-_X1+1)-(((NK+1) * ML) - 2)) shr 1);
 For I := 0 to NK do
 Begin
  If(RX >= (X1 + (I * ML)))and(RX <= (X1 + (I * ML) + L))and(RY = (_Y2-2))Then
  Begin
   IsKeyHoriDown := I;
   Exit;
  End;
 End;
 IsKeyHoriDown := _Mouse_;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.GetKeyHori                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.GetKeyHori(Key:StrKey):Word;
Begin
 GetKeyHori := GetKeyHoriXY(XP,YP,Key);
End;

            (**** Windows --> Question (Input) ****)

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.Input                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.Input(Var Chn:String):Word;
Var Len,X,Y,LC,NC : Byte;
    K             : Word;
Begin
 Len := (_X2 - _X1 + 1) - (XP + 2);
 LC := GetLastColor; NC := GetColor;
 SetAllColor(Colors.Msg,Colors.Input);
 Text.SetPos(_X1+1+XP,_Y1+1+YP);
 CInput(Chn,Len,KeyAction,True,K);
 SetAllColor(LC,NC);
 {$IFDEF __Mouse__}
  If(K = kbMouse)Then
  Begin
   GetInputMsPos(X,Y);
   XM := X; YM := Y;
   If(IsCloseIcon(XM,YM))Then Input := _Close_ else
   If(IsExitIcon(XM,YM))Then Input := _Exit_ else
   If(IsTitle(XM,YM))Then Input := _Title_ else
   If(IsZoomIcon(XM,YM))Then Input := _Zoom_
                        else Input := _Mouse_;
  End
   else
 {$ENDIF}
 Input := K;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   Wins.InputMono                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.InputMono(Var Chn:String):Word;
Var Len,X,Y,LC,NC : Byte;
    K             : Word;
Begin
 Len := (_X2 - _X1 + 1) - (XP + 2);
 LC := GetLastColor; NC := GetColor;
 SetAllColor(Colors.Msg,Colors.Input);
 Text.SetPos(_X1+1+XP,_Y1+1+YP);
 CInput(Chn,Len,KeyAction,False,K);
 SetAllColor(LC,NC);
 {$IFDEF __Mouse__}
  If(K = kbMouse)Then
  Begin
   GetInputMsPos(X,Y);
   XM := X; YM := Y;
   If(IsCloseIcon(X,Y))Then InputMono := _Close_ else
   If(IsExitIcon(X,Y))Then InputMono := _Exit_ else
   If(IsTitle(X,Y))Then InputMono := _Title_ else
   If(IsZoomIcon(X,Y))Then InputMono := _Zoom_
                      else InputMono := _Mouse_;
  End
   else
 {$ENDIF}
 InputMono := K;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   Wins.InputMonoXY                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.InputMonoXY(X,Y:Byte;Var Chn:String):Word;
Var Len,RX,RY,LC,NC : Byte;
    K         : Word;
Begin
 Len := (_X2 - _X1 + 1) - (X + 2);
 LC := GetLastColor; NC := GetColor;
 SetAllColor(Colors.Msg,Colors.Input);
 Text.SetPos(_X1+1+X,_Y1+1+Y);
 CInput(Chn,Len,KeyAction,False,K);
 SetAllColor(LC,NC);
 {$IFDEF __Mouse__}
  If(K = kbMouse)Then
  Begin
   GetInputMsPos(RX,RY);
   RX := XM; RY := YM;
   If(IsCloseIcon(RX,RY))Then InputMonoXY := _Close_ else
   If(IsExitIcon(RX,RY))Then InputMonoXY := _Exit_ else
   If(IsTitle(RX,RY))Then InputMonoXY := _Title_ else
   If(IsZoomIcon(RX,RY))Then InputMonoXY := _Zoom_
                        else InputMonoXY := _Mouse_;
  End
   else
 {$ENDIF}
 InputMonoXY := K;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.InputXY                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.InputXY(X,Y:Byte;Var Chn:String):Word;
Var Len,RX,RY,LC,NC : Byte;
    K               : Word;
Begin
 Len := (_X2 - _X1 + 1) - (X + 2);
 LC := GetLastColor; NC := GetColor;
 SetAllColor(Colors.Msg,Colors.Input);
 Text.SetPos(_X1+1+X,_Y1+1+Y);
 CInput(Chn,Len,KeyAction,True,K);
 SetAllColor(LC,NC);
 {$IFDEF __Mouse__}
  If(K = kbMouse)Then
  Begin
   GetInputMsPos(RX,RY);
   RX := XM; RY := YM;
   If(IsCloseIcon(RX,RY))Then InputXY := _Close_ else
   If(IsExitIcon(RX,RY))Then InputXY := _Exit_ else
   If(IsTitle(RX,RY))Then InputXY := _Title_ else
   If(IsZoomIcon(RX,RY))Then InputXY := _Zoom_
                        else InputXY := _Mouse_;
  End
   else
 {$ENDIF}
 InputXY := K;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Wins.ZoomIcon                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.ZoomIcon;
Begin
 HaveZoom := True;
 WriteText(_X2+1-Length(LuxeVid.ZoomIcon),_Y1,LuxeVid.ZoomIcon,Colors.Icon);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Wins.PutTitle                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutTitle(Title:String);
Begin
 _Title := Title;
 BarSpaceHori(_X1+Length(CloseIcon),_Y1,
  _X2-Byte(HaveZoom)*Length(LuxeVid.ZoomIcon),Colors.Title);
 WriteUnColor(_X1+(((_X2-_X1)-Length(Title)) shr 1),_Y1,Title);
 {$IFDEF __GRAPHDIRECT__}
  If(VC.Methode = ScrnGraphDirect)Then
  Begin
   Graphix.SetColor(7);
   Line((_X1+Length(CloseIcon))*8,
        (_Y1)*GetHeightChar,
        (_X1+Length(CloseIcon))*8,
        ((_Y1+1)*GetHeightChar)-1);
   LineHori((_X1+Length(CloseIcon))*8,
            (_Y1)*GetHeightChar,
            ((_X2)*8)+7);
   Graphix.SetColor(8);
   Line((_X2*8)+7,
        (_Y1*GetHeightChar)+1,
        (_X2*8)+7,
        ((_Y1+1)*GetHeightChar)-1);
   LineHori((_X1+Length(CloseIcon))*8+1,
            ((_Y1+1)*GetHeightChar)-1,
            (_X2*8)+7);
  End;
 {$ENDIF}
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.CenterTextY                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.CenterTextY(Y:Byte;Msg:String);
Begin
 _WriteText(_X1+(((_X2-_X1)-Length(Msg)) shr 1),_Y1+1+Y,Msg);
 YP := Y + 1; XP := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.CenterText                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.CenterText(Msg:String);
Begin
 CenterTextY(YP,Msg);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.PutMsg                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutMsg(Msg:String);
Begin
 _WMessage(_X1+1,_Y1+1+YP,_X2-1,Msg);
 XP := 0; Inc(YP,GetLineWMessage(_X1+1,_X2-1,Msg));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.PutText                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutText(Msg:String);
Begin
 _WriteText(XP + (_X1+1),YP + (_Y1 + 1),Msg);
 Inc(XP,Length(Msg));
 If(XP > (_X2-_X1-2))Then
 Begin
  XP := 0;
  Ln;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.PutTextXY                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutTextXY(X,Y:Byte;Msg:String);
Begin
 SetPos(X,Y);
 PutText(Copy(Msg,1,_X2-(_X1+X+1)));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.PutTextLn                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutTextLn(Msg:String);
Begin
 _WriteText(XP + (_X1 + 1),YP + (_Y1 + 1),Msg);
 Inc(YP); XP := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.PutTyping                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutTyping(Msg:String);
Begin
 WriteTypingXY(XP+(_X1 + 1),YP+(_Y1 + 1),Msg);
 GetPos(XP,YP); Dec(XP,(_X1+1)); Dec(YP,(_Y1+1));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  Wins.PutTypingXY                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutTypingXY(X,Y:Byte;Msg:String);
Begin
 SetPos(X,Y);
 PutTyping(Msg);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  Wins.PutTypingLn                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.PutTypingLn(Msg:String);
Begin
 PutTyping(Msg);
 Ln;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   Wins.GetPosUserAction              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.GetPosUserAction(Var X,Y:Byte);
Begin
 X := XM; Y := YM;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 Wins.GetPosUserActionInWin           ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.GetPosUserActionInWin(Var X,Y:Byte);
Begin
 X := XM - (_X1 + 1); Y := YM - (_Y1 + 1);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   Wins.IsCloseIcon                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.IsCloseIcon(X,Y:Byte):Boolean;
Begin
 IsCloseIcon := NumWin.IsCloseIcon(_X1,_Y1,X,Y);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.IsExitIcon                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.IsExitIcon(X,Y:Byte):Boolean;
Begin
 IsExitIcon := NumWin.IsExitIcon(X,Y);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   Wins.IsTitleIcon                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.IsTitle(X,Y:Byte):Boolean;
Begin
 IsTitle := (Y = _Y1)and(X >= (_X1+(((_X2-_X1)-Length(_Title)) shr 1)))and
            (X >= ((_X1+(((_X2-_X1)-Length(_Title)) shr 1)) + Length(_Title)));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.IsZoomIcon                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.IsZoomIcon(X,Y:Byte):Boolean;
Begin
 IsZoomIcon := (HaveZoom)and(X <= _X2)and(X >= (_X2+1-Length(LuxeVid.ZoomIcon)));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.UserAction                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.UserAction:Word;
{$IFDEF __Mouse__}
 Var B : Word;
{$ENDIF}
Begin
 {$IFDEF __Mouse__}
  ShowPtr;
  Repeat
   GetButTPos(B,XM,YM);
   If(B > 0)Then
   Begin
    If(IsCloseIcon(XM,YM))Then
    Begin
     ReleaseKeyMouse;
     GetButTPos(B,XM,YM);
     If(IsCloseIcon(XM,YM))Then
     Begin
      HidePtr;
      UserAction := _Close_;
      Exit;
     End;
    End
     else
    If(IsExitIcon(XM,YM))Then
    Begin
     ReleaseKeyMouse;
     GetButTPos(B,XM,YM);
     If(IsExitIcon(XM,YM))Then
     Begin
      HidePtr;
      UserAction := _Exit_;
      Exit;
     End;
    End
     else
    If(IsTitle(XM,YM))Then
    Begin
     ReleaseKeyMouse;
     GetButTPos(B,XM,YM);
     If(IsTitle(XM,YM))Then
     Begin
      HidePtr;
      UserAction := _Title_;
      Exit;
     End;
    End
     else
    If(IsZoomIcon(XM,YM))Then
    Begin
     ReleaseKeyMouse;
     GetButTPos(B,XM,YM);
     If(IsZoomIcon(XM,YM))Then
     Begin
      HidePtr;
      UserAction := _Zoom_;
      Exit;
     End;
    End
     else
    Begin
     ReleaseKeyMouse;
     HidePtr;
     UserAction := _Mouse_;
     Exit;
    End;
   End;
  Until KeyPressed;
  HidePtr;
 {$ENDIF}
 UserAction := ReadKey;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  Wins.GetNumberLineMsg               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.GetNumberLineMsg(Msg:String):Byte;
Begin
 GetNumberLineMsg := GetLineWMessage(_X1+1,_X2-1,Msg);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Wins.Ln                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.Ln;
Begin
 Inc(YP); XP := 0;
 If(YP > (_Y2-_Y1)-2)Then YP := (_Y2-_Y1)-2;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.BackLn                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.BackLn;
Begin
 If(YP > 0)Then Dec(YP);
 XP := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.SetPos                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.SetPos(X,Y:Byte);
Begin
 XP := X; YP := Y;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       Wins.SetX                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.SetX(X:Byte);
Begin
 XP := X;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.JumpX                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.JumpX(Num:Byte);
Begin
 If(XP + Num > GetWriteLengthInWin)Then XP := GetWriteLengthInWin
                                   Else Inc(XP,Num);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.BackJumpX                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.BackJumpX(Num:Byte);
Begin
 If(XP <= Num)Then XP := 0
              Else Dec(XP,Num);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.SetY                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Wins.SetY(Y:Byte);
Begin
 YP := Y;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.Done                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Destructor Wins.Done;
Begin
 SetAllColor(OldLastColor,OldColor);
 VideoKey.ColorShade := OldShadeKeyColor;
 VideoKey.ColorKey := OldKeyColor;
 {$IFDEF __KEYBUFFER__}
  DestroyKeyBuffer;
 {$ENDIF}
 If Not(Buffer = NIL)Then
 Begin
  PutBox(_X1,_Y1,_X2+2,_Y2+1,Buffer^);
  FreeMem(Buffer,Size);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.IsInWindow                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.IsInWindow(X,Y:Byte):Boolean;
Begin
 IsInWindow := (((X >= _X1)and(X <= _X2))and
                ((Y >= _Y1)and(Y <= _Y2)));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  Wins.GetWriteLengthInWin            ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.GetWriteLengthInWin:Byte;
Begin
 GetWriteLengthInWin := (_X2-(_X1+2));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Wins.IsEmptyStrXY                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.IsEmptyStrXY(X,Y:Byte):Boolean;
Begin
 IsEmptyStrXY := (GetCharXY(_X1+1+X,_Y1+1+Y) = #0);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Wins.IsEmptyStr                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.IsEmptyStr:Boolean;
Begin
 IsEmptyStr := (GetCharXY(_X1+1+XP,_Y1+1+YP) = #0);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Wins.GetStrXY                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Wins.GetStrXY(X,Y:Byte):String;
Var I : Byte;
    S : String;
Begin
 For I := 0 to 255 do
 Begin
  If(Text.GetCharXY(_X1+1+X+I,_Y1+1+Y) = #0)or(_X2 < (_X1 + 1 + I))Then
  Begin
   S[0] := Char(I);
   GetStrXY := S;
   Exit;
  End;
 End;
 S[0] := #255;
 GetStrXY := S;
End;

BEGIN { Main Unit }
 Numeric.MemSet(KeyAction,SizeOf(KeyAction),0);
 KeyAction[Byte(^A)].Action := inpLeftWord;
 KeyAction[Byte(^D)].Action := inpRight;
 KeyAction[Byte(^E)].Action := inpUp;
 KeyAction[Byte(^F)].Action := inpRightWord;
 KeyAction[Byte(^G)].Action := inpDelChar;
 KeyAction[Byte(^H)].Action := inpBackSpace;
 KeyAction[Byte(^O)].Action := inpHome;
 KeyAction[Byte(^P)].Action := inpEnd;
 KeyAction[Byte(^Q)].Action := inpDelEOL;
 KeyAction[Byte(^S)].Action := inpLeft;
 KeyAction[Byte(^T)].Action := inpDelWord;
 KeyAction[Byte(^X)].Action := inpDown;
 KeyAction[Byte(^Y)].Action := inpDelLine;
END.