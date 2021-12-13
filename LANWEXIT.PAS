(********************************************************)
(*                                                      *)
(*           Malte System/Language Window Exit          *)
(*                     1993/02/02                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System

  Nom :

   Fenˆtre de langage pour quitter (Language Window Exit).

  Directive de compilation conditionnel :

   __OLDMETHODELEVEL__   Indique qu'il faut utiliser les
                         anciennes m‚thode pour l'utilisation
                         de l'unit‚ Level. Cette m‚thode
                         demande beaucoup plus de m‚moire que
                         la nouvelle m‚thode, mais elle existe
                         que dans un but d'incompatibilit‚
                         avec l'unit‚ LanDStr.
}

Unit LanWExit;

(********************************************************)
                        INTERFACE
(********************************************************)

Const

      EnglishYesKey = 'Yes';
      FrenchYesKey  = 'Oui';
      EnglishNoKey  = 'No';
      FrenchNoKey   = 'Non';

      EnglishExitTitle = 'Warning!';
      FrenchExitTitle = 'Attention!';
      EnglishExitMsg = 'You are sure exit ?';
      FrenchExitMsg  = 'Est-tu bien certain de quitter ?';

Function WinExit(ETitle,EMsg,FTitle,FMsg:String):Boolean;
Function WinExitProgram:Boolean;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses

     Text,Level,LuxeVid,Window,NumWin,VidKey,LanWin,Sound;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       WinExit                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function WinExit(ETitle,EMsg,FTitle,FMsg:String):Boolean;
Const H = 6;
Var X1,Y1,X2,Y2,L,K : Byte;
    MX,MY           : Byte;
    Image           : BoxImage;
    Window          : LWindowType;
Begin
 Case Language of
  lgEnglish : L := Length(EMsg) + 4;
         else L := Length(FMsg) + 4;
 End;
 If(L < 26)Then L := 26;
 GetSizeWindowCenter(L,H,X1,Y1,X2,Y2);
 Image.Init;
 If(Image.GetBox(X1,Y1,X2+2,Y2+1))Then
 Begin
  Window.InitError;
  Window.NoZoom;
  Window.LPutWindow(X1,Y1,X2,Y2,ETitle,FTitle);
  
  SetColor(Color.Window.Error.Msg);
  Case Language of
   lgEnglish : _CenterText(Y1+2,EMsg);
          else _CenterText(Y1+2,FMsg);
  End;
  Case Language of
   lgEnglish : Begin
                Repeat
                 K := KeyHori((GetMaxX-11*2) shr 1,
                              Y2-2,12,EnglishYesKey+'|'+EnglishNoKey);
                 If(K = 252)Then
                 Begin
                  GetVidKeyMsPos(MX,MY);
                  If(((MX >= X1)and(MX < X1 + Length(CloseIcon)))and(MY = Y1))Then
                  Begin
                   Window.Done;
                   Image.Restore;
                   WinExit := False;
                   Exit;
                  End;
                 End;
                Until Not(K in [252,253,254]);
               End;
          else Begin
                Repeat
                 K := KeyHori((GetMaxX-11*2) shr 1,
                              Y2-2,12,FrenchYesKey+'|'+FrenchNoKey);
                 If(K = 252)Then
                 Begin
                  GetVidKeyMsPos(MX,MY);
                  If(((MX >= X1)and(MX < X1 + Length(CloseIcon)))and(MY = Y1))Then
                  Begin
                   Window.Done;
                   Image.Restore;
                   WinExit := False;
                   Exit;
                  End;
                 End;
                Until Not(K in [252,253,254]);
               End;
  End;
  If(K = 255)Then WinExit := False
   else
  Begin
   If(K = 0)Then WinExit := True
            Else WinExit := False;
  End;
  Window.Done;
 End
  else
 Beep;
 Image.Restore;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     WinExitProgram                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function WinExitProgram:Boolean;
Begin
 WinExitProgram := WinExit(EnglishExitTitle,EnglishExitMsg,
                           FrenchExitTitle,FrenchExitMsg);
End;

BEGIN { Main Unit }
END.