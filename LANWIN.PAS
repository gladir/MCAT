(********************************************************)
(*                                                      *)
(*             Malte System/Language Window             *)
(*                      1993/01/26                      *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Directive de compilation conditionnel :

   __OLDMETHODELEVEL__   Indique qu'il faut utiliser les
                         anciennes m‚thode pour l'utilisation
                         de l'unit‚ Level. Cette m‚thode
                         demande beaucoup plus de m‚moire que
                         la nouvelle m‚thode, mais elle existe
                         que dans un but d'incompatibilit‚
                         avec l'unit‚ LanDStr.
}

Unit LanWin;

(********************************************************)
                       INTERFACE
(********************************************************)

Uses Window;

Type

     LWindowType = Object(WindowType)
                    Procedure LPutWindow(X1,Y1,X2,Y2:Byte;English,French:String);
                   End;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses

     {$IFNDEF __OLDMETHODELEVEL__}
      Level;
     {$ELSE}
      LanDStr;
     {$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  LWindowType.LPutWindow              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFNDEF __OLDMETHODELEVEL__}

 Procedure LWindowType.LPutWindow(X1,Y1,X2,Y2:Byte;English,French:String);
 Begin
  Case Language of
   lgEnglish : PutWindow(X1,Y1,X2,Y2,English);
          else PutWindow(X1,Y1,X2,Y2,French);
  End;
 End;

{$ELSE}

 Procedure LWindowType.LPutWindow(X1,Y1,X2,Y2:Byte;English,French:String);
 Begin
  PutWindow(X1,Y1,X2,Y2,LStr(English,French));
 End;

{$ENDIF}

BEGIN { Main Unit }
END.