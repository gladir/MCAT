(********************************************************)
(*                                                      *)
(*           Malte System/Printer Language              *)
(*                    1993/01/26                        *)
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

Unit LanPrnt;

(********************************************************)
                       INTERFACE
(********************************************************)

Procedure LPrint(English,French:String);
Procedure LPrintLn(English,French:String);

(********************************************************)
                    IMPLEMENTATION
(********************************************************)

Uses

     {$IFDEF __OLDMETHODELEVEL__}
      Level,
     {$ELSE}
      LanDStr,
     {$ENDIF}

     Prnt;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                         LPrint                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Procedure LPrint(English,French:String);
 Begin
  Case Language of
   lgEnglish : Print(English);
          else Print(French);
  End;
 End;

{$ELSE}

 Procedure LPrint(English,French:String);
 Begin
  Print(LStr(English,French));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       LPrintLn                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Procedure LPrintLn(English,French:String);
 Begin
  Case Language of
   lgEnglish : PrintLn(English);
          else PrintLn(French);
  End;
 End;

{$ELSE}

 Procedure LPrintLn(English,French:String);
 Begin
  PrintLn(LStr(English,French));
 End;

{$ENDIF}

BEGIN { Main Unit }
END.