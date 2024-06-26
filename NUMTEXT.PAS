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

   Le texte num�rique (Numeric Text).

  Derni�re modification :

   Dimanche, le 16 mai 1993 (Addition : CLengthTyping,
                             CSearchHigh,CSearchWord).
   Lundi, le 17 mai 1993    (Debug : CSearchWord).

  Description :

   � Ce module est un gestionnaire des chaines de
     caract�re typ�e.

   � Il indique la longueur des chaines de caract�re
     (sans compter les caract�res types).

   � Il recherche des chaines de caract�re (Les Zones
     Haute, Les s�parateurs de phrase).

   � Modifie les chaines de caract�re (les gonfles �
     bloque).

  Note :

   � Ce module est support� par les versions de Turbo
     Pascal 4 ou post�rieur et aux Quick Pascal de toutes
     versions.

  Directive de compilation conditionnel :

   DPMI                  Indique qu'il tourne sous DPMI.
   OS2                   Indique que l'environnement de travaille est OS/2.
   QUICKPASCAL           Indique qu'il s'agit du compilateur QuickPascal.
   VER10                 Indique qu'il s'agit soit du QuickPascal 1.0 ou
                         du Turbo Pascal for Windows 1.0 (Pr�d�finit).
   VER15                 Indique qu'il s'agit du Turbo Pascal for
                         Windows 1.5 (Pr�d�finit).
   VER60                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 6 (Pr�d�finit); si vous d�finisez cette
                         directive, il faut �tre vraiment sur que ce
                         compilateur est compatible � 100%.
   VER70                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 7 (Pr�d�finit); si vous d�finisez cette
                         directive, il faut �tre vraiment sur que ce
                         compilateur est compatible � 100%.
   WINDOWS               Indique que l'environnement de travaille est Windows
   __386__               Indique qu'il faut compiler les instructions pour un
                         processeur 80386 ou post�rieur.
   __ASSEMBLERSUPPORT__  Indique que le compilateur support l'assembler.
                         (Pr�d�finit en fonction des autres variables).
   __EXTERNAL__          Indique qu'il faut faire appelle � la
                         bibliot�que externe. Comme par exemple, si vous
                         d�finis� des proc�dures en Turbo C++, vous devrez
                         faire appelle a cette directive de compilation.
   __OPTIMIZESIZE__      Indique qu'il faut faire en sorte que le code
                         langage machine prenne le moin de place possible.
   __STRPTRSUPPORT__     Indique que le compilateur support des variables
                         de caract�re du m�me genre que le langage C.
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

{ ������������������������������������������������������Ŀ
  �                     CLengthTyping                    ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

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

{ ������������������������������������������������������Ŀ
  �                       CSearchHigh                    ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

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

{ ������������������������������������������������������Ŀ
  �                      CSearchWord                     ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

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

{ ������������������������������������������������������Ŀ
  �                       GetMaxWord                     ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function GetMaxWord(Str:String):Byte;

  D�finition :

   � Cette fonction retourne le nombre - 1 de phrase
     dans la chaine de caract�re.

  Notes :

   � Les phrases sont s�par�s par des '|'.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.

   � La fonction Length indique la longueur de la chaine
     de caract�re. R�f�rence, l'unit� Syst�me (System)
     de Turbo Pascal 4 ou post�rieur et QuickPascal de
     toutes versions.

   � La fonction Inc est simplement une incr�mentation
     (variable = variable + 1). R�f�rence, l'unit�
     Syst�me (System) de Turbo Pascal 4 ou post�rieur
     et QuickPascal de toutes versions.
}

Function GetMaxWord(Str:String):Byte;
Var I,NK : Byte;
Begin
 NK := 0;
 For I := 1 to Length(Str) do If(Str[I] = '|')Then Inc(NK);
 GetMaxWord := NK;
End;

{ ������������������������������������������������������Ŀ
  �                      LengthTyping                    ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function LengthTyping(Str:String):Byte;

  Description :

   � Cette fonction retourne la longueur d'une chaine
     de caract�re sans compter les caract�res typ�s (les
     codes de 0 � 31, '|', '~' et '^').

  Notes :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.

   � La fonction Inc est simplement une incr�mentation
     (variable = variable + 1). R�f�rence, l'unit�
     Syst�me (System) de Turbo Pascal 4 ou post�rieur
     et QuickPascal de toutes versions.

   � La fonction Length retourne la longueur de la chaine
     de caract�re. R�f�rence, l'unit� Syst�me (System)
     de Turbo Pascal 4 ou post�rieur et QuickPascal de
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

{ ������������������������������������������������������Ŀ
  �                    StrTypToTypSpc                    ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function StrTypToTypSpc(Str:String;Max:Byte):String;

  Description :

   � Cette fonction gonfle � la quantit�e d�sign�e
     (Max) une chaines de caract�re typ�e.

 Notes :

   � La fonction Space retourne le nombre d'espace
     demand�. R�f�rence, l'unit� Chaine de Caract�re
     (DString) de Malte System.

   � La fonction LengthTyping retourne la longueur
     d'une chaine de caract�re sans compter les
     caract�res typ�s (les codes de 0 � 31, '|', '~'
     et '^').

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function StrTypToTypSpc(Str:String;Max:Byte):String;
Begin
 StrTypToTypSpc := Str + Space(Max - LengthTyping(Str));
End;

{ ������������������������������������������������������Ŀ
  �                      SearchWord                      ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function SearchWord(Str:String;Pos:Byte):String;

  Description :

   � Recherche telle chaine de caract�re dans une
     chaine de caract�re. Le s�parateur de chaine
     de caract�re est '|'.

  Notes :

   � La fonction Inc est simplement une incr�mentation
     (variable = variable + 1). R�f�rence, l'unit�
     Syst�me (System) de Turbo Pascal 4 ou post�rieur
     et QuickPascal de toutes versions.

   � La fonction Copy copie tant de caract�re a partir
     de tel caract�re. R�f�rence, l'unit� Syst�me
     (System) de Turbo Pascal 4 ou post�rieur et
     QuickPascal de toutes versions.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
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

{ ������������������������������������������������������Ŀ
  �                      SearchHigh                      ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function SearchHigh(Str:String):String;

  Description :

   � Cette fonction recherche la premi�re chaine
     de caract�re situ� entre les '^'.

  Notes :

   � S'il n'y a pas de '^' ou s'il n'y a qu'un seul
     '^', la fonction rien.

   � La fonction Inc est simplement une incr�mentation
     (variable = variable + 1). R�f�rence, l'unit�
     Syst�me (System) de Turbo Pascal 4 ou post�rieur
     et QuickPascal de toutes versions.

   � La fonction Copy copie tant de caract�re a partir
     de tel caract�re. R�f�rence, l'unit� Syst�me
     (System) de Turbo Pascal 4 ou post�rieur et
     QuickPascal de toutes versions.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
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