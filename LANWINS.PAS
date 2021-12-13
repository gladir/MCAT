(********************************************************)
(*                                                      *)
(*            Malte System/Language Windows             *)
(*                     1993/02/07                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System

  DerniŠre modification :

   Jeudi, le 6 mai 1993     (Addition : LWinsSelectObject. [
                             Publique : InitXY, CleanInitXY,
                             Select, Done; Priv‚e : SetBarColor,
                             SetColorTitle]).

   Mardi, le 11 mai 1993    (UpDate StrPtr : KeyToStr).

   Mercredi, le 12 mai 1993 (UpDate : LWinsSelectObject.InitXY).

  Nom :

   Fenˆtres multi-langage (Language Windows).

  Directive de compilation conditionnel :

   DPMI                  Indique qu'il tourne en DPMI.
   OS2                   Indique que l'environnement de travaille est OS/2.
   QUICKPASCAL           Indique qu'il s'agit du compilateur QuickPascal.
   VER10                 Indique qu'il s'agit soit du QuickPascal 1.0 ou
                         du Turbo Pascal for Windows 1.0 (Pr‚d‚finit).
   VER15                 Indique qu'il s'agit du Turbo Pascal for
                         Windows 1.5 (Pr‚d‚finit).
   VER60                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 6 (Pr‚d‚finit); si vous d‚finisez cette
                         directive, il faut ˆtre vraiment sur que ce
                         compilateur est compatible … 100%.
   VER70                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 7 (Pr‚d‚finit); si vous d‚finisez cette
                         directive, il faut ˆtre vraiment sur que ce
                         compilateur est compatible … 100%.
   WINDOWS               Indique que l'environnement de travaille est Windows
   __ASSEMBLERSUPPORT__  Indique que le compilateur support l'assembler.
                         (Pr‚d‚finit en fonction des autres variables).
   __EXTERNAL__          Indique qu'il faut faire appelle … la
                         bibliotŠque externe. Comme par exemple, si vous
                         d‚finis‚ des proc‚dures en Turbo C++, vous devrez
                         faire appelle a cette directive de compilation.
   __OPTIMIZESIZE__      Indique qu'il faut faire en sorte que le code
                         langage machine prenne le moin de place possible.
   __STRPTRSUPPORT__     Indique que le compilateur support des variables
                         de caractŠre du mˆme genre que le langage C.
}

Unit LanWins;

{$IFDEF OS2}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF WINDOWS}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF DPMI}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF VER10}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
  {$X+}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER15}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
  {$X+}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER60}
 {$DEFINE __ASSEMBLERSUPPORT__}
{$ENDIF}

{$IFDEF VER70}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
 {$X+}
{$ENDIF}

{$IFDEF VER80}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
 {$X+}
{$ENDIF}

(********************************************************)
                       INTERFACE
(********************************************************)

Uses TPointer,Level,Windows,KeyBoard;

Const

      KeyHelp    = $01;
      KeyOk      = $02;
      KeyCancel  = $04;
      KeyYes     = $08;
      KeyNo      = $10;
      KeyRetry   = $20;
      KeyAbort   = $40;
      KeyIgnore  = $80;

      _Help_     = $FFF6;
      _Ok_       = kbEnter;
      _Cancel_   = kbEsc;
      _Yes_      = kbEnter;
      _No_       = kbEsc;
      _Retry_    = $FFF9;
      _Abort_    = $FFF8;
      _Ignore_   = $FFF7;

Type

      TSelectPtr = ^TString;

      LWinsSelectObject = Object
                           Colors:WinColor;
                           Constructor CleanInitXY(X,Y,L,H:Byte;Title:String;Choice:TSelectPtr;Color:WinColor);
                           Constructor CCleanInitCenter(L,H:Byte;Title:String;Choice:PCharPtr;Color:WinColor);
                           Constructor CCleanInitXY(X,Y,L,H:Byte;Title:String;Choice:PCharPtr;Color:WinColor);
                           Constructor CInitXY(X,Y,L,H:Byte;Title:String;Choice:PCharPtr;Color:WinColor);
                           Constructor InitXY(X,Y,L,H:Byte;Title:String;Choice:TSelectPtr;Color:WinColor);
                           Function Select(Var Y:Byte;Var P:Word):Word;
                           Destructor Done;
                           PRIVATE
                           CleanPtr:Pointer;
                           IsC:Boolean;
                           _X,_Y,_L,_H:Byte;
                           SizeBuf:Word;
                           _Title:String;
                           ChoicePtr:TSelectPtr;
                           CChoicePtr:PCharPtr;
                           Procedure SetBarColor(Y:Byte;Color:Byte);
                           Procedure SetColorTitle(Color:Byte);
                          End;

      LWins = Object(Wins)
               Constructor LInit(X1,Y1,X2,Y2:Byte;ETitle,FTitle:String;Color:WinColor);
               Constructor LInitCenter(L,H:Byte;ETitle,FTitle:String;Color:WinColor);
               Procedure LPutKeyHori(EMsg,FMsg:String);
               Procedure LPutKeyHoriDown(EMsg,FMsg:String);
               Procedure LPutMsg(EMsg,FMsg:String);
               Procedure LPutText(EMsg,FMsg:String);
               Procedure LPutTextLn(EMsg,FMsg:String);
               Procedure LPutTextXY(X,Y:Byte;EMsg,FMsg:String);
               Procedure LPutTyping(EMsg,FMsg:String);
               Procedure LPutTypingLn(EMsg,FMsg:String);
               Procedure LCenterText(EMsg,FMsg:String);
               Procedure LCenterTextY(Y:Byte;EMsg,FMsg:String);
               Function LKeyOk:Word;
               Function LGetKeyHori(EMsg,FMsg:String):Word;
               Function LGetKeyHoriDown(EMsg,FMsg:String):Word;
               Function LGetNumberLineMsg(EMsg,FMsg:String):Byte;
              End;

Procedure LWinHaltError(EMsg,ESug,FMsg,FSug:String;Key:Byte);

Function KeyToStr(Key:Byte;Var Str:String):Byte;
Function LInitError(EMsg,FMsg:String;Key:Byte):Word;
Function LInitHaltError(EMsg,ESug,FMsg,FSug:String;Key:Byte):Word;
Function LInitWarning(EMsg,FMsg:String;Key:Byte):Word;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses

     {$IFDEF __STRPTRSUPPORT__}
      Strings,
     {$ENDIF}

     Text,LuxeVid,LanDStr,Message,NumWin;

Const

      KeyStrc : Array[0..7] of Word = (_Help_,_Ok_,_Cancel_,_Yes_,
                                       _No_,_Retry_,_Abort_,_Ignore_);

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                LWinsSelectObject.InitXY              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor LWinsSelectObject.InitXY(X,Y,L,H:Byte;Title:String;Choice:TSelectPtr;Color:WinColor);
Var W         : Wins;
    J         : Byte;
    ChoiceStr : ^String;
Begin
 IsC := False;
 CleanPtr := NIL; SizeBuf := 0;
 ChoicePtr := Choice;
 Colors := Color;
 _X := X; _Y := Y; _L := L; _H := H; _Title := Title;
 W._InitXY(X,Y,L,H,Title,Color);
 W.Done;
 For J := 0 to H - 2 do
 Begin
  ChoiceStr := @Choice^[J];
  If(ChoiceStr = NIL)Then Exit;
  Text.WriteText(X+2,Y+1+J,ChoiceStr^,Color.Msg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                LWinsSelectObject.CInitXY             ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor LWinsSelectObject.CInitXY(X,Y,L,H:Byte;Title:String;Choice:PCharPtr;Color:WinColor);
Var W : Wins;
    J : Byte;
Begin
 IsC := True;
 CleanPtr := NIL; SizeBuf := 0;
 CChoicePtr := Choice;
 ChoicePtr := NIL;
 Colors := Color;
 _X := X; _Y := Y; _L := L; _H := H; _Title := Title;
 W._InitXY(X,Y,L,H,Title,Color);
 W.Done;
 For J := 0 to H - 2 do
 Begin
  If(Choice^[J] = NIL)Then Exit;
  Text.WriteText(X+2,Y+1+J,StrPas(Choice^[J]),Color.Msg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³              LWinsSelectObject.CleanInitXY           ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor LWinsSelectObject.CleanInitXY(X,Y,L,H:Byte;Title:String;Choice:TSelectPtr;Color:WinColor);
Begin
 IsC := False;
 SizeBuf := GetSizeBox(X,Y,L+2,H+1);
 CleanPtr := NIL;
 GetMem(CleanPtr,SizeBuf);
 SaveBox(X,Y,L+2,H+1,CleanPtr^);
 InitXY(X,Y,L,H,Title,Choice,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³             LWinsSelectObject.CCleanInitXY           ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor LWinsSelectObject.CCleanInitXY(X,Y,L,H:Byte;Title:String;Choice:PCharPtr;Color:WinColor);
Var W : Wins;
    J : Word;
Begin
 IsC := True;
 SizeBuf := GetSizeBox(X,Y,X+L+2,Y+H+1);
 CleanPtr := NIL;
 GetMem(CleanPtr,SizeBuf);
 SaveBox(X,Y,X+L+2,Y+H+1,CleanPtr^);
 CChoicePtr := Choice;
 ChoicePtr := NIL;
 Colors := Color;
 _X := X; _Y := Y; _L := L; _H := H; _Title := Title;
 W._InitXY(X,Y,L,H,Title,Color);
 W.Done;
 For J := 0 to H - 2 do
 Begin
  If(Choice^[J] = NIL)Then Exit;
  Text.WriteText(X+2,Y+1+J,StrPas(Choice^[J]),Color.Msg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³           LWinsSelectObject.CCleanInitCenter         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor LWinsSelectObject.CCleanInitCenter(L,H:Byte;Title:String;Choice:PCharPtr;Color:WinColor);
Var X1,Y1,X2,Y2 : Byte;
Begin
 GetSizeWindowCenter(L,H,X1,Y1,X2,Y2);
 CCleanInitXY(X1,Y1,X2-X1,Y2-Y1,Title,Choice,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³              LWinsSelectObject.SetColorTitle         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

 Note :

  ş Cette proc‚dure est en mode priv‚.
}

Procedure LWinsSelectObject.SetColorTitle(Color:Byte);
Begin
 Text.WriteText(_X + Length(CloseIcon)-Length(ZoomIcon)+
                ((_L-(Length(_Title)+Length(CloseIcon)-
                Length(ZoomIcon))) shr 1),_Y,_Title,
                Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³               LWinsSelectObject.SetBarColor          ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

 D‚finition :

  ş Cette proc‚dure change la couleur de la bar de la
    fenˆtre sp‚cifier par l'utilisateur.

 Note :

  ş Cette proc‚dure est en mode priv‚.
}

Procedure LWinsSelectObject.SetBarColor(Y:Byte;Color:Byte);
Begin
 Text.BarSelectHori(_X+1,_Y+1+Y,_X+_L-1,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                LWinsSelectObject.Select              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LWinsSelectObject.Select(Var Y:Byte;Var P:Word):Word;
Var K,I                     : Word;
    ChoiceStr,NextChoiceStr : ^String;
    Ok,OkNext               : Boolean;
Begin
 SetColorTitle(Colors.TitleActif);
 SetBarColor(Y,Colors.Input);
 Repeat
  K := Keyboard.ReadKey;
  Case K of
   kbDown : Begin
             If(IsC)Then
             Begin
              Ok := (CChoicePtr^[P] = NIL);
              If Not(Ok)Then Ok := (StrPas(CChoicePtr^[P]) = '');
              OkNext := (CChoicePtr^[P+1] = NIL);
             End
              Else
             Begin
              ChoiceStr := @ChoicePtr^[P];
              Ok := (ChoiceStr = NIL);
              NextChoiceStr := @ChoicePtr^[P+1];
              OkNext := (NextChoiceStr = NIL);
             End;
             If Not(Ok)Then
             Begin
              If Not(OkNext)Then
              Begin
               If(Y < 7)Then
               Begin
                SetBarColor(Y,Colors.Msg);
                Inc(Y); Inc(P);
                SetBarColor(Y,Colors.Input);
               End
                else
               Begin
                Inc(P);
                For I := 0 to _H - 2 do
                Begin
                 If(IsC)Then
                 Begin
                  Text.WriteText(_X+2,_Y+1+_H-2-I,StrPas(CChoicePtr^[P-I]),Colors.Msg);
                 End
                  Else
                 Begin
                  ChoiceStr := @ChoicePtr^[P-I];
                  Text.WriteText(_X+2,_Y+1+_H-2-I,ChoiceStr^,Colors.Msg);
                 End;
                End;
               End;
              End;
             End;
            End;
     kbUp : Begin
             If(IsC)Then
             Begin
              Ok := (CChoicePtr^[P] = NIL);
              If Not(Ok)Then Ok := (StrPas(CChoicePtr^[P]) = '');
             End
              Else
             Begin
              ChoiceStr := @ChoicePtr^[P];
              Ok := (ChoiceStr = NIL);
             End;
             If Not(Ok)Then
             Begin
              If(P > 0)Then
              Begin
               If(Y > 0)Then
               Begin
                SetBarColor(Y,Colors.Msg);
                Dec(Y); Dec(P);
                SetBarColor(Y,Colors.Input);
               End
                else
               Begin
                Dec(P);
                For I := 0 to _H - 2 do
                Begin
                 If(IsC)Then
                 Begin
                  Text.WriteText(_X+2,_Y+1+I,StrPas(CChoicePtr^[P+I]),Colors.Msg);
                 End
                  Else
                 Begin
                  ChoiceStr := @ChoicePtr^[P+I];
                  Text.WriteText(_X+2,_Y+1+I,ChoiceStr^,Colors.Msg);
                 End;
                End;
               End;
              End;
             End;
            End;
       Else Begin
             SetColorTitle(Colors.Title);
             Select := K;
             Exit;
            End;
  End;
 Until (True = False);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                LWinsSelectObject.Done                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Destructor LWinsSelectObject.Done;
Begin
 If(CleanPtr <> NIL)Then
 Begin
  PutBox(_X,_Y,_X+_L+2,_Y+_H+1,CleanPtr^);
  FreeMem(CleanPtr,SizeBuf);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       LWins.LInit                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor LWins.LInit(X1,Y1,X2,Y2:Byte;ETitle,FTitle:String;Color:WinColor);
Begin
 Case Language of
  lgEnglish : Init(X1,Y1,X2,Y2,ETitle,Color);
         else Init(X1,Y1,X2,Y2,FTitle,Color);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   LWins.LInitCenter                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor LWins.LInitCenter(L,H:Byte;ETitle,FTitle:String;Color:WinColor);
Begin
 Case Language of
  lgEnglish : InitCenter(L,H,ETitle,Color);
         else InitCenter(L,H,FTitle,Color);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    LWins.LPutKeyHori                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure LWins.LPutKeyHori(EMsg,FMsg:String);
Begin
 Case Language of
  lgEnglish : PutKeyHori(EMsg);
         Else PutKeyHori(FMsg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 LWins.LPutKeyHoriDown                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure LWins.LPutKeyHoriDown(EMsg,FMsg:String);
Begin
 Case Language of
  lgEnglish : PutKeyHoriDown(EMsg);
         Else PutKeyHoriDown(FMsg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     LWins.LPutMsg                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure LWins.LPutMsg(EMsg,FMsg:String);
Begin
 Case Language of
  lgEnglish : PutMsg(EMsg);
         else PutMsg(FMsg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    LWins.LPutText                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure LWins.LPutText(EMsg,FMsg:String);
Begin
 Case Language of
  lgEnglish : PutText(EMsg);
         else PutText(FMsg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  LWins.LPutTextLn                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure LWins.LPutTextLn(EMsg,FMsg:String);
Begin
 Case Language of
  lgEnglish : PutTextLn(EMsg);
         else PutTextLn(FMsg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  LWins.LPutTextXY                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure LWins.LPutTextXY(X,Y:Byte;EMsg,FMsg:String);
Begin
 Case Language of
  lgEnglish : PutTextXY(X,Y,EMsg);
         else PutTextXY(X,Y,FMsg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  LWins.LPutTyping                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure LWins.LPutTyping(EMsg,FMsg:String);
Begin
 Case Language of
  lgEnglish : PutTyping(EMsg);
         Else PutTyping(FMsg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 LWins.LPutTypingLn                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure LWins.LPutTypingLn(EMsg,FMsg:String);
Begin
 Case Language of
  lgEnglish : PutTypingLn(EMsg);
         Else PutTypingLn(FMsg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  LWins.LCenterText                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure LWins.LCenterText(EMsg,FMsg:String);
Begin
 Case Language of
  lgEnglish : CenterText(EMsg);
         Else CenterText(FMsg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  LWins.LCenterTextY                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure LWins.LCenterTextY(Y:Byte;EMsg,FMsg:String);
Begin
 Case Language of
  lgEnglish : CenterTextY(Y,EMsg);
         Else CenterTextY(Y,FMsg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  LWins.LGetKeyHori                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LWins.LGetKeyHori(EMsg,FMsg:String):Word;
Begin
 Case Language of
  lgEnglish : LGetKeyHori := GetKeyHori(EMsg);
         Else LGetKeyHori := GetKeyHori(FMSg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                LWins.LGetKeyHoriDown                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LWins.LGetKeyHoriDown(EMsg,FMsg:String):Word;
Begin
 Case Language of
  lgEnglish : LGetKeyHoriDown := GetKeyHoriDown(EMsg);
         Else LGetKeyHoriDown := GetKeyHoriDown(FMSg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  LWins.LGetNumberLineMsg             ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LWins.LGetNumberLineMsg(EMsg,FMsg:String):Byte;
Begin
 Case Language of
  lgEnglish : LGetNumberLineMsg := GetNumberLineMsg(EMsg);
         else LGetNumberLineMsg := GetNumberLineMsg(FMsg);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      LWins.LKeyOk                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LWins.LKeyOk:Word;
Var Msg    : String;
    NK,L,X : Byte;
Begin
 NK := KeyToStr(KeyOk,Msg);
 L := Length(Msg) + 4;
 If(L < 10)Then L := 10;
 X := (((_X2-_X1)-L) shr 1);
 LKeyOk := GetKeyHoriXY(X,YP,Msg);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       KeyToStr                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function KeyToStr(Key:Byte;Var Str:String):Byte;
{$IFDEF __STRPTRSUPPORT__}
 Const

      StrKey : Array[lgEnglish..lgFrench,0..7] of PChar =
               (
                 { Anglais }
                ('Help','Ok','Cancel','Yes',
                 'No','Retry','Abort','Ignore'),
                 { Francais }
                ('Aide','Correcte','Annule','Oui',
                'Non','R‚essayer','Abandonne','Ignorer')
               );
{$ELSE}
 Const

       EStrKey : Array[0..7] of String[15] = (
                  'Help','Ok','Cancel','Yes',
                  'No','Retry','Abort','Ignore');
       FStrKey : Array[0..7] of String[15] = (
                 'Aide','Correcte','Annule','Oui',
                 'Non','R‚essayer','Abandonne','Ignorer');
{$ENDIF}
Var I,N : Byte;
Begin
 N := 0; Str := '';
 For I := 0 to 7 do
 Begin
  If(((Key shr I) and 1) = 1)Then
  Begin
   Inc(N);
   If(Str = '')Then
   Begin
    {$IFDEF __STRPTRSUPPORT__}
     Str := Strings.StrPas(StrKey[Language,I]);
    {$ELSE}
     Case Language of
      lgEnglish : Str := EStrKey[I];
             else Str := FStrKey[I];
     End;
    {$ENDIF}
   End
    else
   Begin
    {$IFDEF __STRPTRSUPPORT__}
     Str := Str + '|' + Strings.StrPas(StrKey[Language,I]);
    {$ELSE}
     Case Language of
      lgEnglish : Str := Str + '|' + EStrKey[I];
             else Str := Str + '|' + FStrKey[I];
     End;
    {$ENDIF}
   End;
  End;
 End;
 KeyToStr := N;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      LInitError                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LInitError(EMsg,FMsg:String;Key:Byte):Word;
Var Windows             : LWins;
    X1,Y1,X2,Y2,L,H,N,I : Byte;
    K                   : Word;
    StrKey              : String;
    Buffer              : Array[0..7] of Byte;
Begin
 L := (KeyToStr(Key,StrKey) * 12) + 4;
 If(L < 40)and(Length(LStr(EMsg,FMsg)) > 40)Then L := 40 else
 If(L < 20)and(Length(LStr(EMsg,FMsg)) > 20)Then L := 20;
 H := 2 + GetLineWMessage(0,L,LStr(EMsg,FMsg)) + 2 + 1;
 N := 0;
 For I := 0 to 7 do
 Begin
  If(((Key shr I) and 1) = 1)Then
  Begin
   Buffer[I] := N;
   Inc(N);
  End
   else
  Buffer[I] := 16;
 End;
 GetSizeWindowCenter(L,H,X1,Y1,X2,Y2);
 Windows.LInit(X1,Y1,X2,Y2,'Error','Erreur',Level.Color.Window.Error);
 Windows.SetY(1);
 Windows.LPutMsg(EMsg,FMsg);
 K := Windows.GetKeyHoriDown(StrKey);
 Windows.Done;
 If(K < 8)Then
 Begin
  I := 0;
  While Not(Buffer[I] = K) do Inc(I);
  Case KeyStrc[I] of
_Title_ : Begin
           LInitError := kbF1;
           Exit;
          End;
_Close_ : Begin
           LInitError := kbEsc;
           Exit;
          End;
     else Begin
           LInitError := KeyStrc[I];
           Exit;
          End;
  End;
 End
  else
 If(K = _Title_)Then LInitError := kbF1 else
 If(K = _Close_)Then LInitError := kbEsc
                else LInitError := K;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      LInitWarning                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LInitWarning(EMsg,FMsg:String;Key:Byte):Word;
Var Windows             : LWins;
    X1,Y1,X2,Y2,L,H,N,I : Byte;
    K                   : Word;
    StrKey              : String;
    Buffer              : Array[0..7] of Byte;
Begin
 L := (KeyToStr(Key,StrKey) * 12) + 4;
 If(L < 40)and(Length(LStr(EMsg,FMsg)) > 40)Then L := 40 else
 If(L < 20)and(Length(LStr(EMsg,FMsg)) > 20)Then L := 20;
 H := 2 + GetLineWMessage(0,L,LStr(EMsg,FMsg)) + 2 + 1;
 N := 0;
 For I := 0 to 7 do
 Begin
  If(((Key shr I) and 1) = 1)Then
  Begin
   Buffer[I] := N;
   Inc(N);
  End
   else
  Buffer[I] := 16;
 End;
 GetSizeWindowCenter(L,H,X1,Y1,X2,Y2);
 Windows.LInit(X1,Y1,X2,Y2,'Warning','Attention',Level.Color.Window.Warning);
 Windows.SetY(1);
 Windows.LPutMsg(EMsg,FMsg);
 K := Windows.GetKeyHoriDown(StrKey);
 Windows.Done;
 If(K < 8)Then
 Begin
  I := 0;
  While Not(Buffer[I] = K) do Inc(I);
  Case KeyStrc[I] of
_Title_ : Begin
           LInitWarning := kbF1;
           Exit;
          End;
_Close_ : Begin
           LInitWarning := kbEsc;
           Exit;
          End;
     else Begin
           LInitWarning := KeyStrc[I];
           Exit;
          End;
  End;
 End
  else
 If(K = _Title_)Then LInitWarning := kbF1 else
 If(K = _Close_)Then LInitWarning := kbEsc
                else LInitWarning := K;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     LWinHaltError                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure LWinHaltError(EMsg,ESug,FMsg,FSug:String;Key:Byte);
Var Windows             : LWins;
    X1,Y1,X2,Y2,L,H,N,I : Byte;
    K                   : Word;
    StrKey              : String;
    Buffer              : Array[0..7] of Byte;
Begin
 L := (KeyToStr(Key,StrKey) * 12) + 4;
 If(L < 40)and(Length(LStr(EMsg,FMsg)) > 40)Then L := 40 else
 If(L < 20)and(Length(LStr(EMsg,FMsg)) > 20)Then L := 20;
 H := 2 + GetLineWMessage(0,L,LStr(EMsg,FMsg)) + 1 +
          GetLineWMessage(0,L,LStr(ESug,FSug)) + 2 + 1 + 1;
 N := 0;
 For I := 0 to 7 do
 Begin
  If(((Key shr I) and 1) = 1)Then
  Begin
   Buffer[I] := N;
   Inc(N);
  End
   else
  Buffer[I] := 16;
 End;
 GetSizeWindowCenter(L,H,X1,Y1,X2,Y2);
 Windows.LInit(X1,Y1,X2,Y2,'Error','Erreur',Level.Color.Window.Error);
 Windows.SetY(1);
 Windows.LPutMsg(EMsg,FMsg);
 Windows.Ln;
 Windows.LPutMsg(ESug,FSug);
 K := Windows.GetKeyHoriDown(StrKey);
 Windows.Done;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     LInitHaltError                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LInitHaltError(EMsg,ESug,FMsg,FSug:String;Key:Byte):Word;
Label _EXIT;
Var Windows             : LWins;
    X1,Y1,X2,Y2,L,H,N,I : Byte;
    K                   : Word;
    StrKey              : String;
    Buffer              : Array[0..7] of Byte;
Begin
 L := (KeyToStr(Key,StrKey) * 12) + 4;
 If(L < 40)and(Length(LStr(EMsg,FMsg)) > 40)Then L := 40 else
 If(L < 20)and(Length(LStr(EMsg,FMsg)) > 20)Then L := 20;
 H := 2 + GetLineWMessage(0,L,LStr(EMsg,FMsg)) + 1 +
          GetLineWMessage(0,L,LStr(ESug,FSug)) + 1 + 2 + 1;
 N := 0;
 For I := 0 to 7 do
 Begin
  If(((Key shr I) and 1) = 1)Then
  Begin
   Buffer[I] := N;
   Inc(N);
  End
   else
  Buffer[I] := 16;
 End;
 GetSizeWindowCenter(L,H,X1,Y1,X2,Y2);
 Windows.LInit(X1,Y1,X2,Y2,'Critical Error','Erreur critique',Level.Color.Window.Error);
 Windows.SetY(1);
 Windows.LPutMsg(EMsg,FMsg);
 Windows.Ln;
 Windows.LPutMsg(ESug,FSug);
 K := Windows.GetKeyHoriDown(StrKey);
 If(K < 8)Then
 Begin
  I := 0;
  While Not(Buffer[I] = K) do Inc(I);
  Case KeyStrc[I] of
_Title_ : Begin
           LInitHaltError := kbF1;
           Goto _EXIT;
          End;
_Close_ : Begin
           LInitHaltError := kbEsc;
           Goto _EXIT;
          End;
     else Begin
           LInitHaltError := KeyStrc[I];
           Goto _EXIT;
          End;
  End;
 End
  else
 If(K = _Title_)Then LInitHaltError := kbF1 else
 If(K = _Close_)Then LInitHaltError := kbEsc
                else LInitHaltError := K;
_EXIT:
 Windows.Done;
End;

BEGIN { Main Unit }
END.