(********************************************************)
(*                                                      *)
(*            Malte System/Language Last Bar            *)
(*                    1993/03/18                        *)
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

Unit LanLastBar;

(********************************************************)
                       INTERFACE
(********************************************************)

Uses Window;

Type

     LLastBar = Object(LastBarType)
                 Constructor LInitMsg(EMsg,FMsg:String);
                End;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses

     {$IFNDEF __OLDMETHODELEVEL__}
      LanDStr,
     {$ENDIF}

     Level;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   LLastBar.LInitMsg                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __OLDMETHODELEVEL__}

 Constructor LLastBar.LInitMsg(EMsg,FMsg:String);
 Begin
  Init;
  Case Language of
   lgEnglish : If(Boolean(Message(EMsg,Level.Color.EndBar.Normal)))Then;
          Else If(Boolean(Message(FMsg,Level.Color.EndBar.Normal)))Then;
  End;
 End;

{$ELSE}

 Constructor LLastBar.LInitMsg(EMsg,FMsg:String);
 Begin
  Init;
  If(Boolean(Message(LStr(EMsg,FMsg),Level.Color.EndBar.Normal)))Then;
 End;

{$ENDIF}

BEGIN { Main Unit }
END.