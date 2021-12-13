(********************************************************)
(*                                                      *)
(*             Malte System/Language Error              *)
(*                    1993/03/11                        *)
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

Unit LanErr;

(********************************************************)
                      INTERFACE
(********************************************************)

Procedure LHaltMsg(EMsg,FMsg:String);

(********************************************************)
                    IMPLEMENTATION
(********************************************************)

Uses

     {$IFDEF __OLDMETHODELEVEL__}
      Level,
     {$ELSE}
      LanDStr,
     {$ENDIF}

     Error;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     LHaltMsg                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Procedure LHaltMsg(EMsg,FMsg:String);
 Begin
  Case Language of
   lgEnglish : HaltMsg(EMsg);
          ELse HaltMsg(FMsg);
  End;
 End;

{$ELSE}

 Procedure LHaltMsg(EMsg,FMsg:String);
 Begin
  HaltMsg(LStr(EMsg,FMsg));
 End;

{$ENDIF}

BEGIN { Main Unit }
END.