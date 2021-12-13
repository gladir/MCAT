(********************************************************)
(*                                                      *)
(*               Malte System/Numeric Text              *)
(*                     1993/02/06                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System

  Nom :

   Le texte num‚rique (Numeric Text).

  DerniŠre modification :

   Dimanche, le 16 mai 1993 (Addition : CLengthTyping,
                             CSearchHigh,CSearchWord).
   Lundi, le 17 mai 1993    (Debug : CSearchWord).

  Description :

   ş Ce module est un gestionnaire des chaines de
     caractŠre typ‚e.

   ş Il indique la longueur des chaines de caractŠre
     (sans compter les caractŠres types).

   ş Il recherche des chaines de caractŠre (Les Zones
     Haute, Les s‚parateurs de phrase).

   ş Modifie les chaines de caractŠre (les gonfles …
     bloque).

  Note :

   ş Ce module est support‚ par les versions de Turbo
     Pascal 4 ou post‚rieur et aux Quick Pascal de toutes
     versions.

  Directive de compilation conditionnel :

   DPMI                  Indique qu'il tourne sous DPMI.
   OS2                   Indique que l'environnement de travaille est OS/2.
   QUICKPASCAL           Indique qu'il s'agit du compilateur QuickPascal.
   VER10                 Indique qu'il s'agit soit du QuickPascal 1.0 ou
                         du Turbo Pascal for Windows 1.0 (Pr‚d‚finit).
   VER15                 Indique qu'il s'agit du Turbo Pascal for
                         Windows 1.5 (Pr‚d‚finit).
   VER60                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 6 (Pr‚d‚finit); si vous d‚finisez cette
                         directive, il faut ˆtre vraiment sur que ce
                         compilateur est compatible … 100%.
   VER70                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 7 (Pr‚d‚finit); si vous d‚finisez cette
                         directive, il faut ˆtre vraiment sur que ce
                         compilateur est compatible … 100%.
   WINDOWS               Indique que l'environnement de travaille est Windows
   __386__               Indique qu'il faut compiler les instructions pour un
                         processeur 80386 ou post‚rieur.
   __ASSEMBLERSUPPORT__  Indique que le compilateur support l'assembler.
                         (Pr‚d‚finit en fonction des autres variables).
   __EXTERNAL__          Indique qu'il faut faire appelle … la
                         bibliotŠque externe. Comme par exemple, si vous
                         d‚finis‚ des proc‚dures en Turbo C++, vous devrez
                         faire appelle a cette directive de compilation.
   __OPTIMIZESIZE__      Indique qu'il faut faire en sorte que le code
                         langage machine prenne le moin de place possible.
   __STRPTRSUPPORT__     Indique que le compilateur support des variables
                         de caractŠre du mˆme genre que le langage C.
}

{$IFDEF OS2}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF WINDOWS}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF DPMI}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF VER10}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER15}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER60}
 {$DEFINE __ASSEMBLERSUPPORT__}
{$ENDIF}

{$IFDEF VER70}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
{$ENDIF}

{$IFDEF VER80}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
{$ENDIF}

{$IFDEF __STRPTRSUPPORT__}
 {$DEFINE PCHARSUPPORT}
{$ENDIF}

Unit NumText;

(********************************************************)
                       INTERFACE
(********************************************************)

{$IFDEF PCHARSUPPORT}

 Uses Strings;

 Function CLengthTyping(Msg:PChar):Word;
 Function CSearchHigh(Msg:PChar):String;
 Function CSearchWord(Str:PChar;Pos:Byte):String;

{$ENDIF}

Function GetMaxWord(Str:String):Byte;
Function LengthTyping(Str:String):Byte;
Function SearchHigh(Str:String):String;
Function SearchWord(Str:String;Pos:Byte):String;
Function StrTypToTypSpc(Str:String;Max:Byte):String;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses DString; { Data String }

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     CLengthTyping                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF PCHARSUPPORT}

 Function CLengthTyping(Msg:PChar):Word;
 Var I,P : Word;
 Begin
  I := 0; P := 0;
  While Not(Msg[I] = #0) do
  Begin
   If Not(Msg[I] in [#1..#31,'|','^','~'])Then Inc(P);
   Inc(I);
  End;
  CLengthTyping := P;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       CSearchHigh                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF PCHARSUPPORT}

 Function CSearchHigh(Msg:PChar):String;
 Var I,L : Byte;
 Begin
  L := 0; I := 0;
  While Not(Msg[I] = #0) do
  Begin
   If(Msg[I] = '^')Then Inc(L);
   Inc(I);
  End;
  If(L >= 2)Then
  Begin
   I := 0;
   While Not(Msg[I] in [#0,'^']) do Inc(I);
   Inc(I); L := 0;
   While Not(Msg[I+L] in [#0,'^']) do Inc(L);
   CSearchHigh := Copy(StrPas(Msg),I+1,L);
  End
   else
  CSearchHigh := '';
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      CSearchWord                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF PCHARSUPPORT}

 Function CSearchWord(Str:PChar;Pos:Byte):String;
 Var I,Start,Len,NC,NK : Word;
 Begin
  If(Str = NIL)Then
  Begin
   CSearchWord := '';
   Exit;
  End;
  NK := 0; I := 0;
  While Not(Str[I] = #0) do
  Begin
   If(Str[I] = '|')Then Inc(NK);
   Inc(I);
  End;
  If(NK = 0)Then CSearchWord := StrPas(Str)
   else
  Begin
   I := 0; NC := 0;
   While(NC < Pos) do
   Begin
    If(Str[I] = '|')Then Inc(NC);
    Inc(I);
   End;
   If(Pos > 0)Then Inc(I);
   Start := I;
   While Not(Str[I] in [#0,'|']) do Inc(I);
   If(Word(Pos) = NK)Then Len := $FFFF else
   Len := I - Start + 1;
   CSearchWord := Copy(StrPas(Str),Byte(Start),Byte(Len));
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetMaxWord                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function GetMaxWord(Str:String):Byte;

  D‚finition :

   ş Cette fonction retourne le nombre - 1 de phrase
     dans la chaine de caractŠre.

  Notes :

   ş Les phrases sont s‚par‚s par des '|'.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.

   ş La fonction Length indique la longueur de la chaine
     de caractŠre. R‚f‚rence, l'unit‚ SystŠme (System)
     de Turbo Pascal 4 ou post‚rieur et QuickPascal de
     toutes versions.

   ş La fonction Inc est simplement une incr‚mentation
     (variable = variable + 1). R‚f‚rence, l'unit‚
     SystŠme (System) de Turbo Pascal 4 ou post‚rieur
     et QuickPascal de toutes versions.
}

Function GetMaxWord(Str:String):Byte;
Var I,NK : Byte;
Begin
 NK := 0;
 For I := 1 to Length(Str) do If(Str[I] = '|')Then Inc(NK);
 GetMaxWord := NK;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      LengthTyping                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function LengthTyping(Str:String):Byte;

  Description :

   ş Cette fonction retourne la longueur d'une chaine
     de caractŠre sans compter les caractŠres typ‚s (les
     codes de 0 … 31, '|', '~' et '^').

  Notes :

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.

   ş La fonction Inc est simplement une incr‚mentation
     (variable = variable + 1). R‚f‚rence, l'unit‚
     SystŠme (System) de Turbo Pascal 4 ou post‚rieur
     et QuickPascal de toutes versions.

   ş La fonction Length retourne la longueur de la chaine
     de caractŠre. R‚f‚rence, l'unit‚ SystŠme (System)
     de Turbo Pascal 4 ou post‚rieur et QuickPascal de
     toutes versions.

}

Function LengthTyping(Str:String):Byte;
Var I,P : Byte;
Begin
 P := 0;
 For I := 0 to Length(Str) do
 Begin
  If Not(Str[I] in [#0..#31,'|','^','~'])Then Inc(P);
 End;
 LengthTyping := P;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    StrTypToTypSpc                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function StrTypToTypSpc(Str:String;Max:Byte):String;

  Description :

   ş Cette fonction gonfle … la quantit‚e d‚sign‚e
     (Max) une chaines de caractŠre typ‚e.

 Notes :

   ş La fonction Space retourne le nombre d'espace
     demand‚. R‚f‚rence, l'unit‚ Chaine de CaractŠre
     (DString) de Malte System.

   ş La fonction LengthTyping retourne la longueur
     d'une chaine de caractŠre sans compter les
     caractŠres typ‚s (les codes de 0 … 31, '|', '~'
     et '^').

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function StrTypToTypSpc(Str:String;Max:Byte):String;
Begin
 StrTypToTypSpc := Str + Space(Max - LengthTyping(Str));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SearchWord                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function SearchWord(Str:String;Pos:Byte):String;

  Description :

   ş Recherche telle chaine de caractŠre dans une
     chaine de caractŠre. Le s‚parateur de chaine
     de caractŠre est '|'.

  Notes :

   ş La fonction Inc est simplement une incr‚mentation
     (variable = variable + 1). R‚f‚rence, l'unit‚
     SystŠme (System) de Turbo Pascal 4 ou post‚rieur
     et QuickPascal de toutes versions.

   ş La fonction Copy copie tant de caractŠre a partir
     de tel caractŠre. R‚f‚rence, l'unit‚ SystŠme
     (System) de Turbo Pascal 4 ou post‚rieur et
     QuickPascal de toutes versions.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function SearchWord(Str:String;Pos:Byte):String;
Var I,Start,Len,NC,NK : Byte;
Begin
 NK := 0;
 For I := 1 to Length(Str) do If(Str[I] = '|')Then Inc(NK);
 If(NK = 0)Then SearchWord := Str
  else
 Begin
  I := 0; NC := 0;
  While(NC < Pos) do
  Begin
   Inc(I);
   If(Str[I] = '|')Then Inc(NC);
  End;
  If(Pos > 0)Then Inc(I);
  Start := I;
  While(Str[I] <> '|') do Inc(I);
 If(Pos = NK)Then Len := 255 else
 If(Pos <> 0)Then Len := I - Start
             Else Len := I - Start - 1;
  SearchWord := Copy(Str,Start,Len);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SearchHigh                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function SearchHigh(Str:String):String;

  Description :

   ş Cette fonction recherche la premiŠre chaine
     de caractŠre situ‚ entre les '^'.

  Notes :

   ş S'il n'y a pas de '^' ou s'il n'y a qu'un seul
     '^', la fonction rien.

   ş La fonction Inc est simplement une incr‚mentation
     (variable = variable + 1). R‚f‚rence, l'unit‚
     SystŠme (System) de Turbo Pascal 4 ou post‚rieur
     et QuickPascal de toutes versions.

   ş La fonction Copy copie tant de caractŠre a partir
     de tel caractŠre. R‚f‚rence, l'unit‚ SystŠme
     (System) de Turbo Pascal 4 ou post‚rieur et
     QuickPascal de toutes versions.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function SearchHigh(Str:String):String;
Var I,L : Byte;
Begin
 L := 0;
 For I := 1 to Length(Str) do If(Str[I] = '^')Then Inc(L);
 If(L >= 2)Then
 Begin
  I := 1;
  While(Str[I] <> '^') do Inc(I);
  Inc(I); L := 0;
  While(Str[I+L] <> '^') do Inc(L);
  SearchHigh := Copy(Str,I,L);
 End
  else
 SearchHigh := '';
End;

BEGIN { Main Unit }
END.