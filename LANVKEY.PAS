(********************************************************)
(*                                                      *)
(*            Malte System/Language Video Key           *)
(*                     1993/02/06                       *)
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

Unit LanVKey;

(********************************************************)
                       INTERFACE
(********************************************************)

Procedure _LPutVideoKeyText(X1,Y,X2:Byte;EStr,FStr:String);

Function LKeyHori(X,Y,LK:Byte;EStr,FStr:String):Byte;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses

     {$IFDEF __OLDMETHODELEVEL__}
      Level,
     {$ELSE}
      LanDStr,
     {$ENDIF}

     VidKey;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   _LPutVideoKeyText                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Procedure _LPutVideoKeyText(X1,Y,X2:Byte;EStr,FStr:String);
 Begin
  Case Language of
   lgEnglish : _PutVideoKeyText(X1,Y,X2,EStr);
          else _PutVideoKeyText(X1,Y,X2,FStr);
  End;
 End;

{$ELSE}

 Procedure _LPutVideoKeyText(X1,Y,X2:Byte;EStr,FStr:String);
 Begin
  _PutVideoKeyText(X1,Y,X2,LStr(EStr,FStr));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     LKeyHori                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Function LKeyHori(X,Y,LK:Byte;EStr,FStr:String):Byte;
 Begin
  Case Language of
   lgEnglish : LKeyHori := KeyHori(X,Y,LK,EStr);
          else LKeyHori := KeyHori(X,Y,LK,FStr);
  End;
 End;

{$ELSE}

 Function LKeyHori(X,Y,LK:Byte;EStr,FStr:String):Byte;
 Begin
  LKeyHori := KeyHori(X,Y,LK,LStr(EStr,FStr));
 End;

{$ENDIF}

BEGIN { Main Unit }
END.