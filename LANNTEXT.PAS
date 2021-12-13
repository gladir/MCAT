(********************************************************)
(*                                                      *)
(*           Malte System/Language Numeric Text         *)
(*                     1993/02/05                       *)
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

Unit LanNText;

(********************************************************)
                       INTERFACE
(********************************************************)

Function LLengthTyping(EStr,FStr:String):Byte;
Function LStrTypToTypSpc(EStr,FStr:String;Max:Byte):String;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses

     {$IFDEF __OLDMETHODELEVEL__}
      Level,
     {$ELSE}
      LanDStr,
     {$ENDIF}
     NumText;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   LLengthTyping                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Function LLengthTyping(EStr,FStr:String):Byte;
 Begin
  Case Language of
   lgEnglish : LLengthTyping := LengthTyping(EStr);
          else LLengthTyping := LengthTyping(FStr);
  End;
 End;

{$ELSE}

 Function LLengthTyping(EStr,FStr:String):Byte;
 Begin
  LLengthTyping := LengthTyping(LStr(EStr,FStr));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   LStrTypToTypSpc                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Function LStrTypToTypSpc(EStr,FStr:String;Max:Byte):String;
 Begin
  Case Language of
   lgEnglish : LStrTypToTypSpc := StrTypToTypSpc(EStr,Max);
          else LStrTypToTypSpc := StrTypToTypSpc(FStr,Max);
  End;
 End;

{$ELSE}

 Function LStrTypToTypSpc(EStr,FStr:String;Max:Byte):String;
 Begin
  LStrTypToTypSpc := StrTypToTypSpc(LStr(EStr,FStr),Max);
 End;

{$ENDIF}

BEGIN { Main Unit }
END.