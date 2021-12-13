(********************************************************)
(*                                                      *)
(*             Malte System/Language Text               *)
(*                     1993/01/26                       *)
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

Unit LanText;

(********************************************************)
                       INTERFACE
(********************************************************)

Procedure _LCenterText(Y:Byte;EStr,FStr:String);
Procedure LWriteText(X,Y:Byte;English,French:String;Color:Byte);
Procedure LWriteTypingXY(X,Y:Byte;English,French:String);
Procedure LWriteUnColor(X,Y:Byte;English,French:String);

(********************************************************)
                    IMPLEMENTATION
(********************************************************)

Uses

     {$IFDEF __OLDMETHODELEVEL__}
      Level,
     {$ELSE}
      LanDStr,
     {$ENDIF}

     Text;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     _LCenterText                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Procedure _LCenterText(Y:Byte;EStr,FStr:String);
 Begin
  Case Language of
   lgEnglish : _CenterText(Y,EStr);
          else _CenterText(Y,FStr);
  End;
 End;

{$ELSE}

 Procedure _LCenterText(Y:Byte;EStr,FStr:String);
 Begin
  _CenterText(Y,LStr(EStr,FStr));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       LWriteText                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Procedure LWriteText(X,Y:Byte;English,French:String;Color:Byte);
 Begin
  Case Language of
   lgEnglish : WriteText(X,Y,English,Color);
          else WriteText(X,Y,French,Color);
  End;
 End;

{$ELSE}

 Procedure LWriteText(X,Y:Byte;English,French:String;Color:Byte);
 Begin
  WriteText(X,Y,LStr(English,French),Color);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    LWriteTypingXY                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Procedure LWriteTypingXY(X,Y:Byte;English,French:String);
 Begin
  Case Language of
   lgEnglish : WriteTypingXY(X,Y,English);
          else WriteTypingXY(X,Y,French);
  End;
 End;

{$ELSE}

 Procedure LWriteTypingXY(X,Y:Byte;English,French:String);
 Begin
  WriteTypingXY(X,Y,LStr(English,French));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    LWriteUnColor                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Procedure LWriteUnColor(X,Y:Byte;English,French:String);
 Begin
  Case Language of
   lgEnglish : WriteUnColor(X,Y,English);
          else WriteUnColor(X,Y,French);
  End;
 End;

{$ELSE}

 Procedure LWriteUnColor(X,Y:Byte;English,French:String);
 Begin
  WriteUnColor(X,Y,LStr(English,French));
 End;

{$ENDIF}

BEGIN { Main Unit }
END.