(*******************************************************************)
(*                                                                 *)
(*                     Malte System/Data String                    *)
(*                           1992/05/26                            *)
(*                                                                 *)
(*            Copyright (C) par les Chevaliers de Malte            *)
(*                                                                 *)
(*******************************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System

  Derni�re modification :

   Mercredi, le 5 mai 1993   (Addition : DelAllSpcLeft, DelAllSpcRight).
   Jeudi, le 6 mai 1993      (Addition : DelAllZeroLeft, DelAllZeroRight).
   Vendredi, le 7 mai 1993   (Addition : IsLetterRegular).
   Vendredi, le 21 mai 1993  (Debug : DelAllSpcLeft).
   Mercredi, le 1 juin 1993  (Addition : Cmp,ToPos).
   Dimanche, le 6 juin 1993  (Addition : GetSpcLeft,CmpUpper).
   Jeudi, le 10 juin 1993    (Addition : CopyToPos).
   Vendredi, le 11 juin 1993 (Addition : CmpLeftWord,
                              IsLetterRegularAtStrPos).

  Nom :

   Chaine de caract�re (Data String).

  Description :

   � Ce module est un gestionnaire de base des chaines de
     caract�re.

   � Confirme s'il sagit de tel type de caract�re (Hexad�cimal,
     D�cimal, Octod�cimal, Majuscule, Minuscule, Espace).

   � Efface une chaine de caract�re (une partir, les espaces).

   � Modifie une chaine (Majuscule, Minuscule).

   � Cr�e une chaine de caract�re (� partir d'un nombre, d'une
     chaine de caract�re de type du langage C, d'un adresse).
}

Unit DString;

(*******************************************************************)
			     INTERFACE
(*******************************************************************)

Function BoostStrSpc(Chaine:String;Max:Byte):String;
Function CharUpper(Carac:Char):Char;
Function Cmp(Chn,CmpStr:String;P:Byte):Boolean;
Function CmpLeft(Chn,Left:String):Boolean;
Function CmpLeftWord(Str,Left:String):Boolean;
Function CmpUpper(Chn,CmpStr:String;P:Byte):Boolean;
Function CopyStr(Seg,Ofs:Word):String;
Function CopyStrC(Seg,Ofs:Word):String;
Function CopyToPos(Str:String;P:Byte;Search:String):String;
Function DelAllSpcLeft(Str:String):String;
Function DelAllSpcRight(Str:String):String;
Function DelAllZeroLeft(Str:String):String;
Function DelAllZeroRight(Str:String):String;
Function DeleteSpace(Chaine:String):String;
Function DeleteStr(Chaine:String;Pos,Num:Byte):String;
Function GetSpcLeft(Chaine:String):String;
Function IsDigit(Carac:Char):Boolean;
Function IsLetterRegular(Chr:Char):Boolean;
Function IsLetterRegularAtStrPos(Str:String;P:Byte):Boolean;
Function IsLower(Carac:Char):Boolean;
Function IsODigit(Carac:Char):Boolean;
Function IsSpace(Carac:Char):Boolean;
Function IsUpper(Carac:Char):Boolean;
Function IsXDigit(Carac:Char):Boolean;
Function Left(Chaine:String;Nombre:Byte):String;
Function StrUpper(Chaine:String):String;
Function MultChar(Caractere,Nombre:Byte):String;
Function Right(Chaine:String;Nombre:Byte):String;
Function RtnChn(Seg,Ofs:Word;Nombre:Byte):String;
Function Space(Nombre:Byte):String;
Function Strg(Nombre:LongInt):String;
Function StrgTo(Nombre:LongInt;Number:Byte):String;
Function ToPos(Search,Str:String;Number:Byte):Byte;

(*******************************************************************)
			 IMPLEMENTATION
(*******************************************************************)

{ ������������������������������������������������������Ŀ
  �                    BoostStrSpc                       ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function BoostStrSpc(Chaine:String;Max:Byte):String;

  Description :

   � Additionne de tant d'espace � la chaine de caract�re
     Chaine pour attendre la longueur sp�cifi� (Max),
     puis le tout est retourn� par la fonction.

  Notes :

   � La fonction Length retourne la longueur de la chaine
     de caract�re. R�f�rence, l'unit� Syst�me (System)
     de Turbo Pascal 4 ou post�rieur et aux Quick Pascal
     de toutes versions.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function BoostStrSpc(Chaine:String;Max:Byte):String;
Begin
 While (Length(Chaine) < Max) do Chaine := Chaine + ' ';
 BoostStrSpc := Chaine;
End;

{ ������������������������������������������������������Ŀ
  �                      CopyStr                         ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function CopyStr(Seg,Ofs:Word):String;

  D�finition :

   � Copie une chaine de caract�re de type Pascal �
     partir de l'adresse sp�cifi� (Seg:Ofs). Par la
     suite, la fonction retourne la chaine de
     caract�re.

  Notes :

   � La fonction Char retourne la valeur d'un Byte.
     R�f�rence, l'unit� Syst�me (System) de Turbo
     Pascal 4 ou post�rieur et aux Quick Pascal de
     toutes versions.

   � La proc�dure FillChar fixe tel valeur � partir de
     la zone sp�cifi�. R�f�rence, l'unit� Syst�me
     (System) de Turbo Pascal 4 ou post�rieur et aux
     Quick Pascal de toutes versions.

   � La fonction Mem lit la valeur sp�cifi� � tel
     adresse. R�f�rence, l'unit� Syst�me
     (System) de Turbo Pascal 4 ou post�rieur et
     aux Quick Pascal de toutes versions.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function CopyStr(Seg,Ofs:Word):String;
Var Chaine : String;
    I      : Byte;
Begin
 FillChar(Chaine,SizeOf(Chaine),0);
 For I := 1 to Mem[Seg:Ofs] do
 Begin
  Chaine := Chaine + Char(Mem[Seg:Ofs+I]);
 End;
 CopyStr := Chaine;
End;

{ ������������������������������������������������������Ŀ
  �                      CopyStrC                        ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function CopyStrC(Seg,Ofs:Word):String;

  D�finition :

   � Copie une chaine de caract�re de type C � partir
     de l'adresse sp�cifi� (Seg:Ofs). Puis la fonction
     retourne la chaines de caract�re.

  Notes :

   � La fonction Char retourne la valeur d'un Byte.
     R�f�rence, l'unit� Syst�me (System) de Turbo
     Pascal 4 ou post�rieur et aux Quick Pascal de
     toutes versions.

   � La proc�dure FillChar fixe tel valeur � partir de
     la zone sp�cifi�. R�f�rence, l'unit� Syst�me
     (System) de Turbo Pascal 4 ou post�rieur et aux
     Quick Pascal de toutes versions.

   � La fonction Inc est simplement une incr�mentation
     (variable = variable + 1). R�f�rence, l'unit�
     Syst�me (System) de Turbo Pascal 4 ou post�rieur
     et QuickPascal de toutes versions.

   � La fonction Mem lit la valeur sp�cifi� � tel
     adresse. R�f�rence, l'unit� Syst�me (System)
     de Turbo Pascal 4 ou post�rieur et aux Quick
     Pascal de toutes versions.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function CopyStrC(Seg,Ofs:Word):String;
Var Chaine : String;
    I      : Word;
Begin
 FillChar(Chaine,SizeOf(Chaine),0);
 I := 0;
 If(Mem[Seg:Ofs] <> 0)Then
 Begin
  Repeat
   Chaine := Chaine + Char(Mem[Seg:Ofs+I]);
   Inc(I);
  Until (Mem[Seg:Ofs+I] = 0)or(I > 255);
 End;
 CopyStrC := Chaine;
End;

{ ������������������������������������������������������Ŀ
  �                     DelAllSpcLeft                    ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function DelAllSpcLeft(Str:String):String;

  D�finition :

   � Cette fonction retourne une chaine de caract�re sans
     espace au d�but de celle-ci.
}

Function DelAllSpcLeft(Str:String):String;
Var I : Byte;
Begin
 If Not(Str = '')Then
 Begin
  If Not(Str[1] > ' ')Then
  Begin
   I := 2;
   While ((Length(Str) > I)and(Not(Str[I] > ' '))) do Inc(I);
   If(I = Length(Str))Then DelAllSpcLeft := Str[I]
    Else
   DelAllSpcLeft := Copy(Str,I,Length(Str)-I+1);
  End
   Else
  DelAllSpcLeft := Str;
 End
  else
 DelAllSpcLeft := '';
End;

{ ������������������������������������������������������Ŀ
  �                    DelAllSpcRight                    ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function DelAllSpcRight(Str:String):String;

  D�finition :

   � Cette fonction retourne une chaine de caract�re sans
     espace � la fin de celle-ci.
}

Function DelAllSpcRight(Str:String):String;
Var I : Byte;
Begin
 If Not(Str = '')Then
 Begin
  If Not(Str[Length(Str)] > ' ')Then
  Begin
   I := Length(Str);
   While ((I > 1)and(Str[I] <= ' ')) do Dec(I);
   If(I = 0)Then DelAllSpcRight := ''
    Else
   DelAllSpcRight := Copy(Str,1,I);
  End
   Else
  DelAllSpcRight := Str;
 End
  Else
 DelAllSpcRight := '';
End;

{ ������������������������������������������������������Ŀ
  �                    DelAllZeroLeft                    ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function DelAllZeroLeft(Str:String):String;

  D�finition :

   � Cette fonction retourne une chaine de caract�re sans
     espace ou z�ro au d�but de celle-ci.
}

Function DelAllZeroLeft(Str:String):String;
Var I : Byte;
Begin
 If Not(Str = '')Then
 Begin
  If(Str[1] <= ' ')or(Str[1] = '0')Then
  Begin
   I := 1;
   While ((Length(Str) < I)and(Str[I] > ' ')and(Not(Str[I] = '0'))) do Inc(I);
   If(I = Length(Str))Then DelAllZeroLeft := ''
    Else
   DelAllZeroLeft := Copy(Str,I,Length(Str)-I);
  End
   Else
  DelAllZeroLeft := Str;
 End
  else
 DelAllZeroLeft := '';
End;

{ ������������������������������������������������������Ŀ
  �                   DelAllZeroRight                    ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function DelAllZeroRight(Str:String):String;

  D�finition :

   � Cette fonction retourne une chaine de caract�re sans
     espace ou z�ro � la fin de celle-ci.
}

Function DelAllZeroRight(Str:String):String;
Var I : Byte;
Begin
 If Not(Str = '')Then
 Begin
  If(Str[Length(Str)] <= ' ')or(Str[Length(Str)] = '0')Then
  Begin
   I := Length(Str);
   While ((I > 1)and(Str[I] > ' ')and(Not(Str[I] = '0'))) do Dec(I);
   If(I = 0)Then DelAllZeroRight := ''
    Else
   DelAllZeroRight := Copy(Str,1,I);
  End
   Else
  DelAllZeroRight := Str;
 End
  Else
 DelAllZeroRight := '';
End;

{ ������������������������������������������������������Ŀ
  �                      DeleteStr                       ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function DeleteStr(Chaine:String;Pos,Num:Byte):String;

  D�finition :

   � Permet d'effacer une partie d'une chaine de
     caract�re Chaine. La partie d�truite est
     constitu�e de Num caract�res de la chaine �
     partir du caract�re Pos. Puis retourne la chaine
     de caract�re.

  Notes :

   � La fonction Length retourne la longeur de la
     chaine de caract�re sp�cifi�. R�f�rence, l'unit�
     Syst�me (System) de Turbo Pascal 4 ou post�rieur
     et aux Quick Pascal de toutes versions.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function DeleteStr(Chaine:String;Pos,Num:Byte):String;
Begin
 If(Chaine <> '')and(Length(Chaine) > 1)Then
 Begin
  If(Pos+Num > Length(Chaine))Then DeleteStr := Copy(Chaine,1,Pos-1)
   else
  Begin
   Delete(Chaine,Pos,Num);
   DeleteStr := Chaine;
  End;
 End
  else
 DeleteStr := '';
End;

{ ������������������������������������������������������Ŀ
  �                    DeleteSpace                       ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function DeleteSpace(Chaine:String):String;

  Description :

   � Cette fonction enleve les espaces et les codes
     ASCII inf�rieur � 31 de la chaine de caract�re
     puis retourne le resultat.

  Notes :

   � La proc�dure FillChar fixe tel valeur � partir de
     la zone sp�cifi�. R�f�rence, l'unit� Syst�me
     (System) de Turbo Pascal 4 ou post�rieur et aux
     Quick Pascal de toutes versions.

   � La fonction Length retourne la longeur de la
     chaine de caract�re sp�cifi�. R�f�rence, l'unit�
     Syst�me (System) de Turbo Pascal 4 ou post�rieur
     et aux Quick Pascal de toutes versions.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function DeleteSpace(Chaine:String):String;
Var I      : Byte;
    Phrase : String;
Begin
 FillChar(Phrase,SizeOf(Phrase),0);
 For I := 1 to Length(Chaine) do
 Begin
  If(Chaine[I] > ' ')Then Phrase := Phrase + Chaine[I];
 End;
 DeleteSpace := Phrase;
End;

{ ������������������������������������������������������Ŀ
  �                        Space                         ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function Space(Nombre:Byte):String;

  D�finition :

   � Cette fonction retourne le nombre d'espace
     sp�cifi� par Nombre.

  Notes :

   � La proc�dure FillChar fixe tel valeur � partir de
     la zone sp�cifi�. R�f�rence, l'unit� Syst�me
     (System) de Turbo Pascal 4 ou post�rieur et aux
     Quick Pascal de toutes versions.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function Space(Nombre:Byte):String;
Var Chaine : String;
Begin
 If(Nombre = 0)Then Space := ''
  else
 Begin
  FillChar(Chaine[1],Nombre,' ');
  Chaine[0] := Char(Nombre);
  Space := Chaine;
 End;
End;

{ ������������������������������������������������������Ŀ
  �                        Left                          ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function Left(Chaine:String;Nombre:Byte):String;

  D�finition :

   � Cette fonction retourne les Nombre premier
     caract�re de la chaine Chaine.

  Notes :

   � La fonction Copy copie tant de caract�re a partir
     de tel caract�re. R�f�rence, l'unit� Syst�me
     (System) de Turbo Pascal 4 ou post�rieur et
     QuickPascal de toutes versions.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function Left(Chaine:String;Nombre:Byte):String;
Begin
 Left := Copy(Chaine,1,Nombre);
End;

{ ������������������������������������������������������Ŀ
  �                      MultChar                        ��      
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function MultChar(Caractere,Nombre:Byte):String;

  D�finition :

   � Cette fonction retourne le Nombre de caract�re
     sp�cifi� par Caractere.

  Notes :

   � La proc�dure FillChar fixe tel valeur � partir de
     la zone sp�cifi�. R�f�rence, l'unit� Syst�me
     (System) de Turbo Pascal 4 ou post�rieur et aux
     Quick Pascal de toutes versions.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function MultChar(Caractere,Nombre:Byte):String;
Var Chaine : String;
Begin
 FillChar(Chaine[1],Nombre,Caractere);
 Chaine[0] := Char(Nombre);
 MultChar := Chaine;
End;

{ ������������������������������������������������������Ŀ
  �                        Right                         ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function Right(Chaine:String;Nombre:Byte):String;

  Description :

   � Retourne les caract�res de la chaine Chaine en partant
     de l'extr�me droite.

  Notes :

   � La fonction Copy copie tant de caract�re a partir
     de tel caract�re. R�f�rence, l'unit� Syst�me
     (System) de Turbo Pascal 4 ou post�rieur et
     QuickPascal de toutes versions.

   � La fonction Length retourne la longeur de la
     chaine de caract�re sp�cifi�. R�f�rence, l'unit�
     Syst�me (System) de Turbo Pascal 4 ou post�rieur
     et aux Quick Pascal de toutes versions.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function Right(Chaine:String;Nombre:Byte):String;
Begin
 If(Nombre >= Length(Chaine))Then
  Right := Chaine
 Else
  Right := Copy(Chaine,Length(Chaine)-Nombre,Nombre);
End;

{ ������������������������������������������������������Ŀ
  �                       IsDigit                        ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function IsDigit(Carac:Char):Boolean;

  Definition :

   � Cette fonction indique si le caract�re est une
     nombre d�cimal (0,1,2,3,4,5,6,7,8,9).

  Note :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function IsDigit(Carac:Char):Boolean;
Begin
 IsDigit := (Carac in ['0'..'9']);
End;

{ ������������������������������������������������������Ŀ
  �                       IsLower                        ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function IsLower(Carac:Char):Boolean;

  Definition :

   � Cette fonction indique si le caract�re est une
     minuscule (a,b,c,d,e,f,g,h,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,
     �,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�).

  Note :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function IsLower(Carac:Char):Boolean;
Begin
 IsLower := (Carac in ['a'..'z','�','�','�','�','�','�','�','�','�','�','�',
	     '�','�','�','�','�','�','�','�','�','�','�','�','�','�','�']);
End;

{ ������������������������������������������������������Ŀ
  �                       IsUpper                        ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function IsUpper(Carac:Char):Boolean;

  Definition :

   � Cette fonction indique si le caract�re est une
     majuscule (A,B,C,D,E,F,G,H,J,I,K,L,M,N,O,P,Q,R,
     S,T,V,X,Y,Z,�,�,�,�,�,�,�,�).

  Note :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function IsUpper(Carac:Char):Boolean;
Begin
 IsUpper := (Carac in ['A'..'Z','�','�','�','�','�','�','�','�']);
End;

{ ������������������������������������������������������Ŀ
  �                       IsSpace                        ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function IsSpace(Carac:Char):Boolean;

  Definition :

   � Cette fonction indique si le caract�re est un
     espace ( ).

  Note :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function IsSpace(Carac:Char):Boolean;
Begin
 IsSpace := (Carac = ' ');
End;

{ ������������������������������������������������������Ŀ
  �                      IsODigit                        ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function IsODigit(Carac:Char):Boolean;

  Definition :

   � Cette fonction indique si le caract�re est une
     nombre octod�cimal (0,1,2,3,4,5,6,7).

  Note :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function IsODigit(Carac:Char):Boolean;
Begin
 IsODigit := (Carac in ['0'..'7']);
End;

{ ������������������������������������������������������Ŀ
  �                      IsXDigit                        ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function IsXDigit(Carac:Char):Boolean;

  Definition :

   � Cette fonction indique si le caract�re est une
     nombre hexad�cimal (0,1,2,3,4,5,6,7,8,9,A,B,C,
     D,E,F).

  Notes :

   � Il ne fait aucune distinction entre les majuscules
     et les minuscules.

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function IsXDigit(Carac:Char):Boolean;
Begin
 IsXDigit := (Carac in ['0'..'9','A'..'F','a'..'f']);
End;

{ ������������������������������������������������������Ŀ
  �                      CharLower                       ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function CharLower(Carac:Char):Char;

  D�finition :

   � Cette fonction retourne la minuscule d'une lettre.

  Note :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function CharLower(Carac:Char):Char;
Begin
 If(Carac in ['A'..'Z'])Then CharLower := Char(Ord(Carac) + 32) else
 If(Carac in ['�'])Then CharLower := '�'
		   Else CharLower := Carac;
End;

{ ������������������������������������������������������Ŀ
  �                      CharUpper                       ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  Syntaxe :

   Function CharUpper(Carac:Char):Char;

  D�finition :

   � Cette fonction retourne la majuscule d'une lettre.

  Note :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.
}

Function CharUpper(Carac:Char):Char;
Begin
 If(Carac in ['a'..'z'])Then CharUpper := Chr(Ord(Carac) - 32) else
 If(Carac in ['�','�'])Then CharUpper := 'C' else
 If(Carac in ['�','�','�','�','�'])Then CharUpper := 'U' else
 If(Carac in ['�','�','�','�','�'])Then CharUpper := 'E' else
 If(Carac in ['�','�','�','�','�','�','�','�'])Then CharUpper := 'A' else
 If(Carac in ['�','�','�','�'])Then CharUpper := 'I' else
 If(Carac in ['�','�','�','�','�','�'])Then CharUpper := 'O' else
 If(Carac in ['�','�'])Then CharUpper := 'N' else
 If(Carac = '�')Then CharUpper := 'Y' else
 If(Carac = '�')Then CharUpper := '�'
		else CharUpper := Carac;
End;

{ ������������������������������������������������������Ŀ
  �                       StrUpper                       ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function StrUpper(Chaine:String):String;
Var I      : Byte;
    Phrase : String;
    Carac  : Char;
Begin
 Phrase := '';
 For I := 1 to Length(Chaine) do
 Begin
  Phrase := Phrase + CharUpper(Chaine[I]);
 End;
 StrUpper := Phrase;
End;

{ ������������������������������������������������������Ŀ
  �                         Strg                         ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function Strg(Nombre:LongInt):String;
Var Chaine : String;
Begin
 Str(Nombre,Chaine);
 Strg := Chaine;
End;

{ ������������������������������������������������������Ŀ
  �                       StrgTo                         ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function StrgTo(Nombre:LongInt;Number:Byte):String;
Var Chaine : String;
Begin
 Str(Nombre:Number,Chaine);
 StrgTo := Chaine;
End;

{ ������������������������������������������������������Ŀ
  �                       RtnChn                         ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function RtnChn(Seg,Ofs:Word;Nombre:Byte):String;
Var Temp : String;
    I    : Byte;
Begin
 Temp := '';
 For I := 0 to Nombre do Temp := Temp + Chr(Mem[Seg:Ofs+I]);
 RtnChn := Temp;
End;

{ ������������������������������������������������������Ŀ
  �                       CmpLeft                        ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function CmpLeft(Chn,Left:String):Boolean;
Var I : Byte;
Begin
 If(Chn[1] <> Left[1])Then
 Begin
  CmpLeft := False;
  Exit;
 End;
 For I := 2 to Length(Left) do
 Begin
  If(Chn[I] <> Left[I])Then
  Begin
   CmpLeft := False;
   Exit;
  End;
 End;
 CmpLeft := True;
End;

{ ������������������������������������������������������Ŀ
  �                   IsLetterRegular                    ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  D�finition :

   � Indique s'il s'agit d'un caract�re standard d'IBM
     (A � Z)

  Note :

   � Il ne fait pas la distinction entre une majuscule ou
     une minuscule.
}

Function IsLetterRegular(Chr:Char):Boolean;
Begin
 IsLetterRegular := (Chr in ['A'..'Z','a'..'z']);
End;

{ ������������������������������������������������������Ŀ
  �                          Cmp                         ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function Cmp(Chn,CmpStr:String;P:Byte):Boolean;
Begin
 Cmp := (Copy(Chn,P,Length(CmpStr)) = CmpStr);
End;

{ ������������������������������������������������������Ŀ
  �                       CmpUpper                       ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function CmpUpper(Chn,CmpStr:String;P:Byte):Boolean;
Begin
 CmpUpper := (Copy(StrUpper(Chn),P,Length(CmpStr)) = StrUpper(CmpStr));
End;

{ ������������������������������������������������������Ŀ
  �                         ToPos                        ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function ToPos(Search,Str:String;Number:Byte):Byte;
Var I,N : Byte;
Begin
 N := 0;
 For I := 1 to Length(Str) do
 Begin
  If(Cmp(Str,Search,I))Then Inc(N);
  If(N = Number)Then
  Begin
   ToPos := I;
   Exit;
  End;
 End;
 ToPos := 0;
End;

{ ������������������������������������������������������Ŀ
  �                     GetSpcLeft                       ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function GetSpcLeft(Chaine:String):String;
Var I,X : Byte;
Begin
 X := 0; { eXtra }
 For I := 1 to Length(Chaine) do
 Begin
  If(Chaine[I] = #9)Then Inc(X)
   Else
  If Not(Chaine[I] = ' ')Then
  Begin
   GetSpcLeft := Space((X*8)+I-1);
   Exit;
  End;
 End;
 GetSpcLeft := Space(I+(X*8));
End;

{ ������������������������������������������������������Ŀ
  �                     CopyToPos                        ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function CopyToPos(Str:String;P:Byte;Search:String):String;
Var TStr : String;
    TP   : Byte;
Begin
 TStr := Copy(Str,P,255);
 TP := Pos(Search,TStr);
 If(TP = 0)Then TP := 255;
 CopyToPos := Copy(TStr,1,TP-1);
End;

{ ������������������������������������������������������Ŀ
  �                     CmpLeftWord                      ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function CmpLeftWord(Str,Left:String):Boolean;
Var RCmp : Boolean;
Begin
 RCmp := CmpLeft(Str,Left);
 If(RCmp)Then
 Begin
  If((Length(Left) + 1) <= Length(Str))Then
  Begin
   RCmp := Not(IsLetterRegular(Str[Length(Left)+1]));
  End;
 End;
 CmpLeftWord := RCmp;
End;

{ ������������������������������������������������������Ŀ
  �                 IsLetterRegularAtStrPos              ��
  ���������������������������������������������������������
   ��������������������������������������������������������}

Function IsLetterRegularAtStrPos(Str:String;P:Byte):Boolean;
Begin
 IsLetterRegularAtStrPos := (P > 0)and(IsLetterRegular(Str[P]));
End;

BEGIN { Main Unit }
END.