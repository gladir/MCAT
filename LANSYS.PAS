(********************************************************)
(*                                                      *)
(*             Malte System/Language System             *)
(*                     1993/03/04                       *)
(*                                                      *)
(*       Copyright (C) par les Chevaliers de Malte      *)
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

Unit LanSys;

(********************************************************)
                       INTERFACE
(********************************************************)

Procedure Write(EMsg,FMsg:String);
Procedure WriteLn(EMsg,FMsg:String);

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses

    {$IFDEF __OLDMETHODELEVEL__}
     Level;
    {$ELSE}
     LanDStr;
    {$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       WriteLn                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Procedure WriteLn(EMsg,FMsg:String);
 Begin
  Case Language of
   lgEnglish : System.WriteLn(EMsg);
          else System.WriteLn(FMsg);
  End;
 End;

{$ELSE}

 Procedure WriteLn(EMsg,FMsg:String);
 Begin
  System.WriteLn(LStr(EMsg,FMsg));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Write                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Procedure Write(EMsg,FMsg:String);
 Begin
  Case Language of
   lgEnglish : System.Write(EMsg);
          else System.Write(FMsg);
  End;
 End;

{$ELSE}

 Procedure Write(EMsg,FMsg:String);
 Begin
  System.Write(LStr(EMsg,FMsg));
 End;

{$ENDIF}

BEGIN { Main Unit }
END.