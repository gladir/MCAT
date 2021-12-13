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

  DerniŠre modification :

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

   Chaine de caractŠre (Data String).

  Description :

   ş Ce module est un gestionnaire de base des chaines de
     caractŠre.

   ş Confirme s'il sagit de tel type de caractŠre (Hexad‚cimal,
     D‚cimal, Octod‚cimal, Majuscule, Minuscule, Espace).

   ş Efface une chaine de caractŠre (une partir, les espaces).

   ş Modifie une chaine (Majuscule, Minuscule).

   ş Cr‚e une chaine de caractŠre (… partir d'un nombre, d'une
     chaine de caractŠre de type du langage C, d'un adresse).
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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BoostStrSpc                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function BoostStrSpc(Chaine:String;Max:Byte):String;

  Description :

   ş Additionne de tant d'espace … la chaine de caractŠre
     Chaine pour attendre la longueur sp‚cifi‚ (Max),
     puis le tout est retourn‚ par la fonction.

  Notes :

   ş La fonction Length retourne la longueur de la chaine
     de caractŠre. R‚f‚rence, l'unit‚ SystŠme (System)
     de Turbo Pascal 4 ou post‚rieur et aux Quick Pascal
     de toutes versions.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function BoostStrSpc(Chaine:String;Max:Byte):String;
Begin
 While (Length(Chaine) < Max) do Chaine := Chaine + ' ';
 BoostStrSpc := Chaine;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      CopyStr                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function CopyStr(Seg,Ofs:Word):String;

  D‚finition :

   ş Copie une chaine de caractŠre de type Pascal …
     partir de l'adresse sp‚cifi‚ (Seg:Ofs). Par la
     suite, la fonction retourne la chaine de
     caractŠre.

  Notes :

   ş La fonction Char retourne la valeur d'un Byte.
     R‚f‚rence, l'unit‚ SystŠme (System) de Turbo
     Pascal 4 ou post‚rieur et aux Quick Pascal de
     toutes versions.

   ş La proc‚dure FillChar fixe tel valeur … partir de
     la zone sp‚cifi‚. R‚f‚rence, l'unit‚ SystŠme
     (System) de Turbo Pascal 4 ou post‚rieur et aux
     Quick Pascal de toutes versions.

   ş La fonction Mem lit la valeur sp‚cifi‚ … tel
     adresse. R‚f‚rence, l'unit‚ SystŠme
     (System) de Turbo Pascal 4 ou post‚rieur et
     aux Quick Pascal de toutes versions.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      CopyStrC                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function CopyStrC(Seg,Ofs:Word):String;

  D‚finition :

   ş Copie une chaine de caractŠre de type C … partir
     de l'adresse sp‚cifi‚ (Seg:Ofs). Puis la fonction
     retourne la chaines de caractŠre.

  Notes :

   ş La fonction Char retourne la valeur d'un Byte.
     R‚f‚rence, l'unit‚ SystŠme (System) de Turbo
     Pascal 4 ou post‚rieur et aux Quick Pascal de
     toutes versions.

   ş La proc‚dure FillChar fixe tel valeur … partir de
     la zone sp‚cifi‚. R‚f‚rence, l'unit‚ SystŠme
     (System) de Turbo Pascal 4 ou post‚rieur et aux
     Quick Pascal de toutes versions.

   ş La fonction Inc est simplement une incr‚mentation
     (variable = variable + 1). R‚f‚rence, l'unit‚
     SystŠme (System) de Turbo Pascal 4 ou post‚rieur
     et QuickPascal de toutes versions.

   ş La fonction Mem lit la valeur sp‚cifi‚ … tel
     adresse. R‚f‚rence, l'unit‚ SystŠme (System)
     de Turbo Pascal 4 ou post‚rieur et aux Quick
     Pascal de toutes versions.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     DelAllSpcLeft                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function DelAllSpcLeft(Str:String):String;

  D‚finition :

   ş Cette fonction retourne une chaine de caractŠre sans
     espace au d‚but de celle-ci.
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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    DelAllSpcRight                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function DelAllSpcRight(Str:String):String;

  D‚finition :

   ş Cette fonction retourne une chaine de caractŠre sans
     espace … la fin de celle-ci.
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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    DelAllZeroLeft                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function DelAllZeroLeft(Str:String):String;

  D‚finition :

   ş Cette fonction retourne une chaine de caractŠre sans
     espace ou z‚ro au d‚but de celle-ci.
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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   DelAllZeroRight                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function DelAllZeroRight(Str:String):String;

  D‚finition :

   ş Cette fonction retourne une chaine de caractŠre sans
     espace ou z‚ro … la fin de celle-ci.
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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      DeleteStr                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function DeleteStr(Chaine:String;Pos,Num:Byte):String;

  D‚finition :

   ş Permet d'effacer une partie d'une chaine de
     caractŠre Chaine. La partie d‚truite est
     constitu‚e de Num caractŠres de la chaine …
     partir du caractŠre Pos. Puis retourne la chaine
     de caractŠre.

  Notes :

   ş La fonction Length retourne la longeur de la
     chaine de caractŠre sp‚cifi‚. R‚f‚rence, l'unit‚
     SystŠme (System) de Turbo Pascal 4 ou post‚rieur
     et aux Quick Pascal de toutes versions.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    DeleteSpace                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function DeleteSpace(Chaine:String):String;

  Description :

   ş Cette fonction enleve les espaces et les codes
     ASCII inf‚rieur … 31 de la chaine de caractŠre
     puis retourne le resultat.

  Notes :

   ş La proc‚dure FillChar fixe tel valeur … partir de
     la zone sp‚cifi‚. R‚f‚rence, l'unit‚ SystŠme
     (System) de Turbo Pascal 4 ou post‚rieur et aux
     Quick Pascal de toutes versions.

   ş La fonction Length retourne la longeur de la
     chaine de caractŠre sp‚cifi‚. R‚f‚rence, l'unit‚
     SystŠme (System) de Turbo Pascal 4 ou post‚rieur
     et aux Quick Pascal de toutes versions.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Space                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function Space(Nombre:Byte):String;

  D‚finition :

   ş Cette fonction retourne le nombre d'espace
     sp‚cifi‚ par Nombre.

  Notes :

   ş La proc‚dure FillChar fixe tel valeur … partir de
     la zone sp‚cifi‚. R‚f‚rence, l'unit‚ SystŠme
     (System) de Turbo Pascal 4 ou post‚rieur et aux
     Quick Pascal de toutes versions.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Left                          ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function Left(Chaine:String;Nombre:Byte):String;

  D‚finition :

   ş Cette fonction retourne les Nombre premier
     caractŠre de la chaine Chaine.

  Notes :

   ş La fonction Copy copie tant de caractŠre a partir
     de tel caractŠre. R‚f‚rence, l'unit‚ SystŠme
     (System) de Turbo Pascal 4 ou post‚rieur et
     QuickPascal de toutes versions.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function Left(Chaine:String;Nombre:Byte):String;
Begin
 Left := Copy(Chaine,1,Nombre);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MultChar                        ³Û      
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function MultChar(Caractere,Nombre:Byte):String;

  D‚finition :

   ş Cette fonction retourne le Nombre de caractŠre
     sp‚cifi‚ par Caractere.

  Notes :

   ş La proc‚dure FillChar fixe tel valeur … partir de
     la zone sp‚cifi‚. R‚f‚rence, l'unit‚ SystŠme
     (System) de Turbo Pascal 4 ou post‚rieur et aux
     Quick Pascal de toutes versions.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function MultChar(Caractere,Nombre:Byte):String;
Var Chaine : String;
Begin
 FillChar(Chaine[1],Nombre,Caractere);
 Chaine[0] := Char(Nombre);
 MultChar := Chaine;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Right                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function Right(Chaine:String;Nombre:Byte):String;

  Description :

   ş Retourne les caractŠres de la chaine Chaine en partant
     de l'extrˆme droite.

  Notes :

   ş La fonction Copy copie tant de caractŠre a partir
     de tel caractŠre. R‚f‚rence, l'unit‚ SystŠme
     (System) de Turbo Pascal 4 ou post‚rieur et
     QuickPascal de toutes versions.

   ş La fonction Length retourne la longeur de la
     chaine de caractŠre sp‚cifi‚. R‚f‚rence, l'unit‚
     SystŠme (System) de Turbo Pascal 4 ou post‚rieur
     et aux Quick Pascal de toutes versions.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function Right(Chaine:String;Nombre:Byte):String;
Begin
 If(Nombre >= Length(Chaine))Then
  Right := Chaine
 Else
  Right := Copy(Chaine,Length(Chaine)-Nombre,Nombre);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       IsDigit                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function IsDigit(Carac:Char):Boolean;

  Definition :

   ş Cette fonction indique si le caractŠre est une
     nombre d‚cimal (0,1,2,3,4,5,6,7,8,9).

  Note :

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function IsDigit(Carac:Char):Boolean;
Begin
 IsDigit := (Carac in ['0'..'9']);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       IsLower                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function IsLower(Carac:Char):Boolean;

  Definition :

   ş Cette fonction indique si le caractŠre est une
     minuscule (a,b,c,d,e,f,g,h,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,
     ‡,,–,—,£,‚,ˆ,‰,Š,ƒ,„,…,†, ,‹,Œ,,¡,“,”,•,¢,§,¤,˜,‘).

  Note :

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function IsLower(Carac:Char):Boolean;
Begin
 IsLower := (Carac in ['a'..'z','‡','','–','—','£','‚','ˆ','‰','Š','ƒ','„',
	     '…','†',' ','‹','Œ','','¡','“','”','•','¢','§','¤','˜','‘']);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       IsUpper                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function IsUpper(Carac:Char):Boolean;

  Definition :

   ş Cette fonction indique si le caractŠre est une
     majuscule (A,B,C,D,E,F,G,H,J,I,K,L,M,N,O,P,Q,R,
     S,T,V,X,Y,Z,€,š,,,,™,¥,’).

  Note :

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function IsUpper(Carac:Char):Boolean;
Begin
 IsUpper := (Carac in ['A'..'Z','€','š','','','','™','¥','’']);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       IsSpace                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function IsSpace(Carac:Char):Boolean;

  Definition :

   ş Cette fonction indique si le caractŠre est un
     espace ( ).

  Note :

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function IsSpace(Carac:Char):Boolean;
Begin
 IsSpace := (Carac = ' ');
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      IsODigit                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function IsODigit(Carac:Char):Boolean;

  Definition :

   ş Cette fonction indique si le caractŠre est une
     nombre octod‚cimal (0,1,2,3,4,5,6,7).

  Note :

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function IsODigit(Carac:Char):Boolean;
Begin
 IsODigit := (Carac in ['0'..'7']);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      IsXDigit                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function IsXDigit(Carac:Char):Boolean;

  Definition :

   ş Cette fonction indique si le caractŠre est une
     nombre hexad‚cimal (0,1,2,3,4,5,6,7,8,9,A,B,C,
     D,E,F).

  Notes :

   ş Il ne fait aucune distinction entre les majuscules
     et les minuscules.

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function IsXDigit(Carac:Char):Boolean;
Begin
 IsXDigit := (Carac in ['0'..'9','A'..'F','a'..'f']);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      CharLower                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function CharLower(Carac:Char):Char;

  D‚finition :

   ş Cette fonction retourne la minuscule d'une lettre.

  Note :

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function CharLower(Carac:Char):Char;
Begin
 If(Carac in ['A'..'Z'])Then CharLower := Char(Ord(Carac) + 32) else
 If(Carac in ['€'])Then CharLower := '‡'
		   Else CharLower := Carac;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      CharUpper                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function CharUpper(Carac:Char):Char;

  D‚finition :

   ş Cette fonction retourne la majuscule d'une lettre.

  Note :

   ş Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.
}

Function CharUpper(Carac:Char):Char;
Begin
 If(Carac in ['a'..'z'])Then CharUpper := Chr(Ord(Carac) - 32) else
 If(Carac in ['€','‡'])Then CharUpper := 'C' else
 If(Carac in ['','–','—','š','£'])Then CharUpper := 'U' else
 If(Carac in ['‚','ˆ','‰','Š',''])Then CharUpper := 'E' else
 If(Carac in ['ƒ','„','…','†','','',' ','¦'])Then CharUpper := 'A' else
 If(Carac in ['‹','Œ','','¡'])Then CharUpper := 'I' else
 If(Carac in ['“','”','•','™','¢','§'])Then CharUpper := 'O' else
 If(Carac in ['¤','¥'])Then CharUpper := 'N' else
 If(Carac = '˜')Then CharUpper := 'Y' else
 If(Carac = '‘')Then CharUpper := '’'
		else CharUpper := Carac;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       StrUpper                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                         Strg                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function Strg(Nombre:LongInt):String;
Var Chaine : String;
Begin
 Str(Nombre,Chaine);
 Strg := Chaine;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       StrgTo                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function StrgTo(Nombre:LongInt;Number:Byte):String;
Var Chaine : String;
Begin
 Str(Nombre:Number,Chaine);
 StrgTo := Chaine;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       RtnChn                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function RtnChn(Seg,Ofs:Word;Nombre:Byte):String;
Var Temp : String;
    I    : Byte;
Begin
 Temp := '';
 For I := 0 to Nombre do Temp := Temp + Chr(Mem[Seg:Ofs+I]);
 RtnChn := Temp;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       CmpLeft                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   IsLetterRegular                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  D‚finition :

   ş Indique s'il s'agit d'un caractŠre standard d'IBM
     (A … Z)

  Note :

   ş Il ne fait pas la distinction entre une majuscule ou
     une minuscule.
}

Function IsLetterRegular(Chr:Char):Boolean;
Begin
 IsLetterRegular := (Chr in ['A'..'Z','a'..'z']);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                          Cmp                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function Cmp(Chn,CmpStr:String;P:Byte):Boolean;
Begin
 Cmp := (Copy(Chn,P,Length(CmpStr)) = CmpStr);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       CmpUpper                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function CmpUpper(Chn,CmpStr:String;P:Byte):Boolean;
Begin
 CmpUpper := (Copy(StrUpper(Chn),P,Length(CmpStr)) = StrUpper(CmpStr));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                         ToPos                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetSpcLeft                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     CopyToPos                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function CopyToPos(Str:String;P:Byte;Search:String):String;
Var TStr : String;
    TP   : Byte;
Begin
 TStr := Copy(Str,P,255);
 TP := Pos(Search,TStr);
 If(TP = 0)Then TP := 255;
 CopyToPos := Copy(TStr,1,TP-1);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     CmpLeftWord                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 IsLetterRegularAtStrPos              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function IsLetterRegularAtStrPos(Str:String;P:Byte):Boolean;
Begin
 IsLetterRegularAtStrPos := (P > 0)and(IsLetterRegular(Str[P]));
End;

BEGIN { Main Unit }
END.