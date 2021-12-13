(********************************************************)
(*                                                      *)
(*                 Malte Catalog/Window                 *)
(*                     1993/01/25                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System

  Derniere modification :

   Vendredi, le 7 mai 1993 (UpDate : WinAbout).
   Dimanche, le 9 mai 1993 (UpDate : WinSelectFloppyDisk).

  Nom :

   Fenˆtre pour le Malte Catalogue (Malte Catalog Window).
}

Unit MCatWin;

(********************************************************)
                       INTERFACE
(********************************************************)

Const

      EnglishTitleSelectDisk = 'Select Disk';       { Max 15 caractŠre! }
      FrenchTitleSelectDisk  = 'Choisie le disque'; { Max 15 caractŠre! }
      EnglishTitleAbout      = 'About';             { Max 25 caractŠre! }
      FrenchTitleAbout       = 'A propos';          { Max 25 caractŠre! }

Procedure WinAbout;
Procedure WinNotFound(Msg:String);

Function LWinContinue(EMsg,FMsg:String):Boolean;
Function LWinOverWrite(EMsg,FMsg:String):Boolean;
Function LWinRetry(EMsg,FMsg:String):Boolean;
Function WinContinue(Msg:String):Boolean;
Function WinOverWrite(Msg:String):Boolean;
Function WinRetry(Msg:String):Boolean;
Function WinSelectFloppyDisk(Drive:Byte):Byte;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses Windows,LanDStr,LanWins,Text,LuxeVid,NumWin,Window,
     VidKey,Level,OS,KeyBoard,Sound,LanText,LanWin,LanVKey,
     MCatExit,Mouse,DString;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      LWinRetry                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LWinRetry(EMsg,FMsg:String):Boolean;
Begin
 LWinRetry := WinRetry(LStr(EMsg,FMsg));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     LWinOverWrite                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LWinOverWrite(EMsg,FMsg:String):Boolean;
Begin
 LWinOverWrite := WinOverWrite(LStr(EMsg,FMsg));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     LWinContinue                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LWinContinue(EMsg,FMsg:String):Boolean;
Begin
 LWinContinue := WinContinue(LStr(EMsg,FMsg));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     WinOverWrite                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function WinOverWrite(Msg:String):Boolean;
Var K : Word;
Begin
 K := LInitError(Msg,Msg,KeyYes+KeyNo);
 WinOverWrite := (K = _Yes_);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       WinRetry                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function WinRetry(Msg:String):Boolean;
Var K : Word;
Begin
 K := LInitError(Msg,Msg,KeyAbort+KeyRetry);
 WinRetry := Not((K = kbEsc)or(K = _Abort_));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      WinContinue                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function WinContinue(Msg:String):Boolean;
Var K : Word;
Begin
 K := LInitWarning(Msg,Msg,KeyYes+KeyNo);
 WinContinue := ((K = _Yes_)or(K = _Close_));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      WinNotFound                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure WinNotFound(Msg:String);
Begin
 If(LInitError(Msg,Msg,KeyOk) = 0)Then;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        WinAbout                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure WinAbout;
Const L = 30; H = 12;
Var K : Word;
    W : LWins;
Begin
 W.LInitCenter(L,H,EnglishTitleAbout,FrenchTitleAbout,Level.Color.Window.Regular);
 W.Ln;
 W.LCenterText('Malte Catalog','Malte Catalogue');
 W.Ln;
 W.LCenterText('Version 1.1','Version 1.1');
 W.Ln;
 W.LCenterText('Copyright (C) 1993 par','Copyright (C) 1993 par');
 W.Ln;
 W.LCenterText('Les Chevaliers de Malte','Les Chevaliers de Malte');
 W.Ln;
 K := W.LKeyOk;
 W.Done;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    WinSelectFloppyDisk               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function WinSelectFloppyDisk(Drive:Byte):Byte;
Const L = 26; H = 7;
Var W         : LWins;
    K,T       : Word;
    X,Y,Plane : Byte;
    CDrive    : Char;

 Procedure SetDrive(CDrive:Char);
 Begin
  SetColor(Color.Window.Regular.Normal);
  W.PutTextXY(2,1+Byte(CDrive)-65,SelectIcon);
 End;

 Procedure ResetDrive(CDrive:Char);
 Begin
  SetColor(Color.Window.Regular.Normal);
  W.PutTextXY(2,1+Byte(CDrive)-65,UnSelectIcon);
 End;

Begin
 Plane := 0;
 If(Drive > 2)Then Drive := 0;
 CDrive := DriveDOSToChar(Drive);
 If(CDrive > 'B')Then CDrive := 'A';
 W.LInitCenter(L,H,EnglishTitleSelectDisk,FrenchTitleSelectDisk,Level.Color.Window.Regular);
 SetColor(Color.Window.Regular.Msg);
 W.PutTypingXY(10,1,'A:|B:');
 SetColor(Color.Window.Regular.Normal);
 W.PutTextXY(2,1,UnSelectIcon);
 W.PutTextXY(2,2,UnSelectIcon);
 W.PutKeyHoriDown(LStr('Ok|Cancel','Correcte|Annule'));
 SetDrive(CDrive);
 Repeat
  Case Plane of
    0 : K := W.UserAction;
   Else K := W.GetKeyHoriDown(LStr('Ok|Cancel','Correcte|Annule'));
  End;
  Case K of
             {$IFDEF __MOUSE__}
              _Mouse_ : Begin
                         W.GetPosUserActionInWin(X,Y);
                         T := W.IsKeyHoriDown(LStr('Ok|Cancel','Correcte|Annule'));
                         If(T < _Mouse_)Then
                         Begin
                          If(T = 1)Then
                          Begin
                           W.Done;
                           WinSelectFloppyDisk := 255;
                           Exit;
                          End
                           Else
                          If(T = 0)Then
                          Begin
                           W.Done;
                           WinSelectFloppyDisk := Byte(CDrive)-64;
                           Exit;
                          End;
                         End;
                         If(Y = 1)Then
                         Begin
                          ResetDrive(CDrive);
                          CDrive := 'A';
                          SetDrive(CDrive);
                          Plane := 0;
                         End;
                         If(Y = 2)Then
                         Begin
                          ResetDrive(CDrive);
                          CDrive := 'B';
                          SetDrive(CDrive);
                          Plane := 0;
                         End;
                        End;
              _Close_,
             {$ENDIF}
   	     1, kbEsc : Begin
                         W.Done;
                         WinSelectFloppyDisk := 255;
                         Exit;
                        End;
   kbUp,kbDown,kbBack : Begin
                         If(Plane = 0)Then
                         Begin
                          ResetDrive(CDrive);
                          If(CDrive = 'A')Then CDrive := 'B'
                                          Else CDrive := 'A';
                          SetDrive(CDrive);
                         End;
                        End;
                kbTab : Plane := (Plane + 1) and 1;
           0, kbEnter : Begin
                         W.Done;
                         WinSelectFloppyDisk := Byte(CDrive)-64;
                         Exit;
                        End;
  End;
 Until (True = False);
End;

BEGIN { Main Unit }
END.