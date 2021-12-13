(********************************************************)
(*                                                      *)
(*                 Malte System/Main Menu               *)
(*                      1993/02/10                      *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System

  Nom :

   Menu principal (Main Menu).

  DerniŠre modification :

   Dimanche, le 16 mai 1993 (Addition : MnuObject.Init,
                             MnuObject.Run, MnuObject.Done).

  Description :

   ş Gestionnaire de menu principal. Il rassemble les
     fonctions de basse d'un menu principal.

  Notes :

   ş Il suppose que vous travaillez sont le module vid‚o
     de luxe (LuxeVid).

   ş Ce module est support‚ par les versions de Turbo
     Pascal 4 ou post‚rieur et aux Quick Pascal de toutes
     versions. A l'exeption de fonction de avec PChar qui
     ne sont support‚ qu'a partir de la version 7 de Turbo
     Pascal.

 Directive de compilation conditionnel :

   DPMI                  Indique qu'il tourne sous DPMI.
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
   __386__               Indique qu'il faut compiler les instructions pour un
                         processeur 80386 ou post‚rieur.
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

{$IFDEF __STRPTRSUPPORT__}
 {$DEFINE PCHARSUPPORT}
{$ENDIF}

Unit MainMenu;

(********************************************************)
                        INTERFACE
(********************************************************)

Uses

     {$IFDEF __STRPTRSUPPORT__}
       Strings,
     {$ENDIF}

     LuxeVid,
     TPointer;

Type

     {$IFDEF PCHARSUPPORT}

      MnuRecord = Record
                   Title:PChar;
                   Mnu:PChar;
                   MsgEndBar:PChar;
                  End;

      MnuStruct = Array[0..($FFF0 div SizeOf(MnuRecord))] of MnuRecord;

      MnuPtr    = ^MnuStruct;

      MnuObject = Object
                   Constructor Init(Mnu:MnuPtr);
                   Function Run(Var _Mnu,Option:Byte):Word;
                   Destructor Done;
                   PRIVATE
                   Bar:BoxImage;
                   SubPos:^TByte;
                   MnuBuffer:MnuPtr;
                   NM:Byte;
                  End;

     {$ENDIF}

Var

    Space, YMenu : Byte;

Procedure PutMenu(Option:String);
Procedure SetDefault;
Procedure SetJumpSpace(Spc:Byte);
Procedure SetLineMenu(Y:Byte);

Function GetJumpSpace:Byte;
Function GetLineMenu:Byte;
Function GetMenu(X:Byte;Title,Msg:String;Var Pos:Byte):Word;
Function GetPosMenu(Msg:String;K:Word):Byte;
Function GetXPosMenu(Msg:String;Pos:Byte):Byte;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses

     {$IFDEF __MOUSE__}
      Mouse,
     {$ENDIF}

     Numeric,Keyboard,DString,NumText,Text,Mnu,Level,
     EmuInt15;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MnuObject.Init                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF PCHARSUPPORT}

 Constructor MnuObject.Init(Mnu:MnuPtr);
 Var I,XP : Byte;
 Begin
  SubPos := NIL;
  MnuBuffer := Mnu;
  NM := 0;
  While Not(MnuBuffer^[NM].Title = NIL) do Inc(NM);
  GetMem(SubPos,NM);
  FillChar(SubPos^,NM,0);
  Bar.Init;
  Bar.GetLine(0,YMenu,Text.GetMaxX);
  SetAllColor(Color.Menu.HighLetter,Color.Menu.Normal);
  XP := 3;
  For I := 0 to (NM - 1) do
  Begin
   WriteTypingXY(XP,YMenu,StrPas(MnuBuffer^[I].Title));
   Inc(XP,CLengthTyping(MnuBuffer^[I].Title)+Space);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MnuObject.Run                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF PCHARSUPPORT}

 Function MnuObject.Run(Var _Mnu,Option:Byte):Word;
 Var K,I    : Word;
     Ok,OkM : Boolean;
     KC     : Char;
     Max,XP : Byte;
 Begin
  _Mnu := 255; Option := 255;
  Repeat
   Ok := False;
   {$IFDEF __MOUSE__}
    ShowPtr;
    Repeat
    Until KeyPressed;
    HidePtr;
   {$ENDIF}
   K := ReadKey;
   _Mnu := 255;
   Max := (NM - 1);
   If(Lo(K) = 0)Then KC := AltCodeToASCII(K)
                Else KC := CharUpper(Char(Lo(K)));
   If(KC > #0)Then
   Begin
    For I := 0 to Max do
    Begin
     If(CSearchHigh(MnuBuffer^[I].Title) = KC)Then
     Begin
      _Mnu := I;
      Break;
     End;
    End;
   End;
   Ok := Not(_Mnu < 255);
   If Not(Ok)Then
   Begin
    Ok := False;
    Repeat
     XP := 2;
     For I := 0 to Max do
     Begin
      If(_Mnu = I)Then Break;
      Inc(XP,CLengthTyping(MnuBuffer^[I].Title)+Space);
     End;
     K := CExecMenu(XP,YMenu,MnuBuffer^[_Mnu].Title,
 		   MnuBuffer^[_Mnu].Mnu,MnuBuffer^[_Mnu].MsgEndBar,SubPos^[_Mnu]);
     Case K of
       kbLeft : _Mnu := MinByte(_Mnu,NM-1);
      kbRight : _Mnu := MaxByte(_Mnu,NM-1);
           Else Ok := True;
     End;
    Until Ok;
    Option := SubPos^[_Mnu];
   End;
  Until Ok;
  Run := K;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MnuObject.Done                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF PCHARSUPPORT}

 Destructor MnuObject.Done;
 Begin
  Bar.Restore;
  If(SubPos <> NIL)Then FreeMem(SubPos,NM);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        PutMenu                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure PutMenu(Option:String);
Var I,NK,XP,L : Byte;
    Str       : String;
Begin
 SetAllColor(Color.Menu.HighLetter,Color.Menu.Normal);
 XP := 3; NK := GetMaxWord(Option);
 For I := 0 to NK do
 Begin
  Str := SearchWord(Option,I);
  L := LengthTyping(Str);
  WriteTypingXY(XP,YMenu,Str);
  Inc(XP,L+Space);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetJumpSpace                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetJumpSpace(Spc:Byte);
Begin
 Space := Spc;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetLineMenu                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetLineMenu(Y:Byte);
Begin
 YMenu := Y;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetJumpSpace                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetJumpSpace:Byte;
Begin
 GetJumpSpace := Space;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetLineMenu                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetLineMenu:Byte;
Begin
 GetLineMenu := YMenu;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                         GetMenu                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetMenu(X:Byte;Title,Msg:String;Var Pos:Byte):Word;
Begin
 GetMenu := ExecMenu(X,YMenu,Title,Msg,Pos);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetPosMenu                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetPosMenu(Msg:String;K:Word):Byte;
Var I,Max : Byte;
    KC    : Char;
    WC,HC : String;
Begin
 Max := GetMaxWord(Msg);
 If(Lo(K) = 0)Then KC := AltCodeToASCII(K)
              Else KC := CharUpper(Char(Lo(K)));
 If(KC = #0)Then
 Begin
  GetPosMenu := 255;
  Exit;
 End;
 For I := 0 to Max do
 Begin
  WC := SearchWord(Msg,I);
  HC := SearchHigh(WC);
  If(HC = KC)Then
  Begin
   GetPosMenu := I;
   Exit;
  End;
 End;
 GetPosMenu := 255;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetXPosMenu                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetXPosMenu(Msg:String;Pos:Byte):Byte;
Var I,NK,XP,L : Byte;
    Str       : String;
Begin
 XP := 2; NK := GetMaxWord(Msg);
 For I := 0 to NK do
 Begin
  If(Pos = I)Then
  Begin
   GetXPosMenu := XP;
   Exit;
  End;
  Str := SearchWord(Msg,I);
  L := LengthTyping(Str);
  Inc(XP,L+Space);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetDefault                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetDefault;
Begin
 Space := 2; YMenu := 1;
End;

BEGIN { Main Unit }
 SetDefault;
END.