(***********************************************************)
(*                                                         *)
(*                  Malte System/Numeric                   *)
(*                       1992/07/02                        *)
(*                                                         *)
(*        Copyright (C) par les Chevaliers de Malte        *)
(*                                                         *)
(***********************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System

  DerniŠre modification :

   Mercredi, le 5 mai 1993   (Addition : _Val, _XVal).
   Jeudi, le 6 mai 1993      (Modification pour l'adaptation … l'
                              assembler du Turbo Pascal 6 ou post‚rieur :
                              Bin15Chn, Bin15Chn_, BinByteChn,
                              BinByteChn_, BinWordChn, BinWordChn_).
   Samedi, le 8 mai 1993     (Modification des directives de compilations
                              pour l'adaptation … l'assembler;
			      Addition des directives de compilation pour
			      les chaines de caractŠre de type pointeur).
   Mardi, le 11 mai 1993     (Addition des directives de compilation en
                              mode prot‚g‚).
   Vendredi, le 14 mai 1993  (Adaptation au 80386 : AbsMaxX).
   Dimanche le 23 mai 1993   (Addition : ByteToStrDec99).

  D‚finition :

   ş Module de gestion des op‚rations relative au math‚matique de base.
     Ce qui signifie qu'il traite des valeur numerique binaire,
     hexad‚cimal, d‚cimal,... et des les transformers en chaine de
     caractŠre utilisable et vis-versa.

   ş Il est programmable en fonction des besoins. Exemple, si vous
     souhaiter que la valeur de base de chiffre commence par A plut“t
     que 0, cela est maintenant possible.

  Exemple de fichier :

   DEMONUM.PAS

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

Unit Numeric;

(***********************************************************)
			  INTERFACE
(***********************************************************)

Const

      LongIntMax  =  2147483647;
      LongIntMin  = -2147483647;
      LongMax     = LongIntMax;
      LongMin     = LongIntMin;
      WordMax     = 65535;
      WordMin     = 0;
      IntegerMax  = 32767;
      IntegerMin  = -32768;
      IntMax      = IntegerMax;
      IntMin      = IntegerMin;
      ShortIntMin = -128;
      ShortIntMax = 127;
      ByteMax     = 255;
      ByteMin     = 0;

Type

     StrByte = String[8];
     StrWord = String[16];
     StrLong = String[31];

Procedure _Dec15Chn(X:Byte;Var Str:StrByte);
Procedure _Dec15Chn_(X:Byte;Var Str:StrByte);
Procedure _DecByteChn(X:Byte;Var Str:StrByte);
Procedure _DecByteChn_(X:Byte;Var Str:StrByte);
Procedure _DecWordChn_(X:Word;Var Str:StrWord);
Procedure Bin15Chn(X:Byte;Var Str:StrByte);
Procedure Bin15Chn_(X:Byte;Var Str:StrByte);
Procedure BinByteChn(X:Byte;Var Str:StrByte);
Procedure BinByteChn_(X:Byte;Var Str:StrByte);
Procedure BinWordChn(X:Word;Var Str:StrWord);
Procedure BinWordChn_(X:Word;Var Str:StrWord);
Procedure ChgByte(Var A,B:Byte);
Procedure ChgChar(Var A,B:Char);
Procedure ChgChr(Var A,B:Byte);
Procedure ChgWord(Var A,B:Word);
Procedure ChgDWord(Var A,B:LongInt);
Procedure DecByteChn(X:Byte;Var Str:StrByte);
Procedure DecByteChn_(X:Byte;Var Str:StrByte);
Procedure DecWordChn(X:Word;Var Str:StrWord);
Procedure FillNotByte(Var X;Len:Word);
Procedure FillNotWord(Var X;Len:Word);
Procedure FillWord(Var X;Len,Value:Word);
Procedure FillWordWithByte(Var X;Len:Word;Value:Byte);
Procedure HexByteChn(X:Byte;Var Str:StrByte);
Procedure HexWordChn(X:Word;Var Str:StrWord);
Procedure MemSet(Var X;Len:Word;Value:Byte);
Procedure Move(Var Source,Dest;Count:Word);
Procedure Move2(Var Source,Target;Len:Byte);
Procedure OctByteChn(X:Byte;Var Str:StrByte);
Procedure OctByteChn_(X:Byte;Var Str:StrByte);
Procedure SetBaseHex(X:Char);
Procedure SetBaseNumeric(X:Char);
Procedure SetHexDownCase;
Procedure SetHexUpCase;

Function _Val(Str:String):LongInt;
Function _XVal(Str:String):LongInt;
Function AbsMaxX(Value,X:LongInt):LongInt;
Function AbsMin(Value:LongInt):LongInt;
Function AbsMin1(Value:LongInt):LongInt;
Function ByteToStrDec(X,Size:Byte):StrByte;
Function ByteToStrDec99(X:Byte):StrByte;
Function ByteToHexStr(X:Byte):StrByte;
Function GetBaseNumeric:Char;
Function LongIntToHexStr(X:LongInt):StrLong;
Function Max1Word(Num,Max:Word):Word;
Function MaxByte(Num,Max:Byte):Byte;
Function MaxWord(Num,Max:Word):Word;
Function Min1Word(Num,Max:Word):Word;
Function MinByte(Num,Max:Byte):Byte;
Function MinWord(Num,Max:Word):Word;
Function WhatIsMaxWord(X,Y:Word):Word;
Function WhatIsMinWord(X,Y:Word):Word;
Function WordToStrDec(Num:Word;Size:Byte):StrWord;

(***********************************************************)
		       IMPLEMENTATION
(***********************************************************)

Uses
      {$IFDEF __386__}
       Asm386,
      {$ENDIF}

      TPointer;

{$IFDEF __EXTERNAL__}
 {$L NUMERIC.OBJ }
 {$L TRANSLTR.OBJ }
{$ENDIF}

{$IFDEF __386__}
 {{$L ABSMAXX.OBJ}
 {{$L MEMSET.OBJ}
{$ENDIF}

{PRIVATE:}

Const

      BaseChar : Char = '0';
      DataHex  : Array[$00..$0F] of Char = '0123456789ABCDEF';

{PUBLIC:}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    WhatIsMinWord                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function WhatIsMinWord(X,Y:Word):Word;
 Assembler;
 ASM
  MOV AX,X;
  CMP AX,Y;
  JBE @@1;
  MOV AX,Y;
@@1:
 END;

{$ELSE}

 Function WhatIsMinWord(X,Y:Word):Word;
 Begin
  If(X < Y)Then WhatIsMinWord := X
           Else WhatIsMinWord := Y;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    WhatIsMaxWord                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function WhatIsMaxWord(X,Y:Word):Word;
 Assembler;
 ASM
  MOV AX,X;
  CMP AX,Y;
  JAE @@1;
  MOV AX,Y;
@@1:
 END;

{$ELSE}

 Function WhatIsMaxWord(X,Y:Word):Word;
 Begin
  If(X > Y)Then WhatIsMaxWord := X
           Else WhatIsMaxWord := Y;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Dec99ToStr                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function ByteToStrDec99(X:Byte):StrByte;
Var Str : String;
Begin
 Str[0] := #2;
 Str[1] := Char(Byte(BaseChar) + ((X div 10) mod 10));
 Str[2] := Char(Byte(BaseChar) + (X mod 10));
 ByteToStrDec99 := Str;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                         _Val                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  D‚finition :

   ş Cette fonction retourne la valeur d‚cimal renfermer
     dans la chaine de caractŠre.

  Note :

   ş Cette fonction ne teste pas les valeurs incorrecte ou
     ill‚gale (Z,x,?,...) en plus, elle n'est en aucune fa‡on
     intelligente et par cons‚qu‚quant les valeurs ('h','$',...)
     ne se pas trait‚ correctement.

}

Function _Val(Str:String):LongInt;
Var Err : Word;
    X   : LongInt;
Begin
 Val(Str,X,Err);
 _Val := X;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        _XVal                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  D‚finition :

   ş Cette fonction retourne la valeur hexad‚cimal renfermer
     dans la chaine de caractŠre.

  Note :

   ş Cette fonction ne teste pas les valeurs incorrecte ou
     ill‚gale (Z,x,?,...) en plus, elle n'est en aucune fa‡on
     intelligente et par cons‚quant les valeurs ('h','$',...)
     ne se pas trait‚ correctement.

}

Function _XVal(Str:String):LongInt;
Var I : Byte;
    X : LongInt;
Begin
 X := 0;
 For I := 1 to Length(Str) do
 Begin
  If(Str[I] < Char(Byte('9') + 1))Then
   X := X + ((Byte(Str[I]) - Byte('0')) shl ((Length(Str) - I) * 4)) else
  If(Str[I] < Char(Byte('F') + 1))Then
   X := X + ((Byte(Str[I]) - (Byte('A') + 10)) shl ((Length(Str) - I) * 4))
  Else
   X := X + ((Byte(Str[I]) - (Byte('a') + 10)) shl ((Length(Str) - I) * 4));
 End;
 _XVal := X;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       AbsMaxX                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function AbsMaxX(Value,X:LongInt):LongInt;

  Description :

   ş Retourne une valeur dont est le ne peut ˆtre plus ‚lev‚
     que l'argument X. Si la valeur est plus ‚lev‚ alors la
     valeur est ‚gale … l'argument X.

  Notes :

   ş Si vous choisiez l'option __386__. Vous devez compiler
     vous mˆme le fichier ABSMAXX.CAS ‚crit en langage C++.
}

(*{$IFDEF __386__}

 Function AbsMaxX(Value,X:LongInt):LongInt; external;

{$ELSE}*)

 Function AbsMaxX(Value,X:LongInt):LongInt;
 Begin
  If(Value > X)Then AbsMaxX := X
               Else AbsMaxX := Value;
 End;

{{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       AbsMin                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function AbsMin(Value:LongInt):LongInt;
Begin
 If(Value < 1)Then AbsMin := 0
              Else AbsMin := Value;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       AbsMin1                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function AbsMin1(Value:LongInt):LongInt;
Begin
 If(Value < 1)Then AbsMin1 := 1
              Else AbsMin1 := Value;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   ByteToHexStr                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function ByteToHexStr(X:Byte):StrByte;
Var Str : StrByte;
Begin
 HexByteChn(X,Str);
 ByteToHexStr := Str;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   LongIntToHexStr                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LongIntToHexStr(X:LongInt):StrLong;
Var Str : StrLong;
Begin
 Str[0] := #8;
 Str[1] := DataHex[(X shr 28) and $F];
 Str[2] := DataHex[(X shr 24) and $F];
 Str[3] := DataHex[(X shr 20) and $F];
 Str[4] := DataHex[(X shr 16) and $F];
 Str[5] := DataHex[(X shr 12) and $F];
 Str[6] := DataHex[(X shr 8) and $F];
 Str[7] := DataHex[(X shr 4) and $F];
 Str[8] := DataHex[(X shr 0) and $F];
 LongIntToHexStr := Str;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        MinByte                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function MinByte(Num,Max:Byte):Byte;
Begin
 If(Num > 0)Then MinByte := Num-1
            Else MinByte := Max;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        MinWord                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function MinWord(Num,Max:Word):Word;
Begin
 If(Num > 0)Then MinWord := Num-1
            Else MinWord := Max;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       Min1Word                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Min1Word(Num,Max:Word):Word;
Begin
 If(Num > 1)Then Min1Word := Num-1
            Else Min1Word := Max;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MaxByte                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function MaxByte(Num,Max:Byte):Byte;
Begin
 If(Num < Max)Then MaxByte := Num+1
              Else MaxByte := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MaxWord                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function MaxWord(Num,Max:Word):Word;
Begin
 If(Num < Max)Then MaxWord := Num+1
              Else MaxWord := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       Max1Word                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function Max1Word(Num,Max:Word):Word;
Begin
 If(Num < Max)Then Max1Word := Num+1
              Else Max1Word := 1;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Move2                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Move2(Var Source,Target;Len:Byte);
Var I   : Byte;
    S,T : ^TByte;
Begin
 S := @Source; T := @Target;
 For I := 0 to (Len-1) do T^[I shl 1] := S^[I shl 1];
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   ByteToStrDec                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function ByteToStrDec(X,Size:Byte):StrByte;
Var Str : StrByte;
    Pos : Byte;
Begin
 DecByteChn(X,Str);
 Pos := Length(Str)-Size+1;
 If(Pos = 0)Then Pos := 1;
 ByteToStrDec := Copy(Str,Pos,Size);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   WordToStrDec                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function WordToStrDec(Num:Word;Size:Byte):StrWord;
Var Chn : Strword;
    Pos : Byte;
Begin
 DecWordChn(Num,Chn);
 Pos := Length(Chn)-Size+1;
 If(Pos = 0)Then Pos := 1;
 WordToStrDec := Copy(Chn,Pos,Size);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      ChgByte                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure ChgByte(Var A,B:Byte);
Var T : Byte;
Begin
 T := A; A := B; B:= T;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      ChgChar                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure ChgChar(Var A,B:Char);
 Var T : Char;
 Begin
  T := A; A := B; B:= T;
 End;

{$ELSE}

 Procedure ChgChar(Var A,B:Char);
 Assembler;
 ASM
  PUSH DS;
   LES  DI,A;
   LDS  SI,B;
   MOV  AL,ES:[DI];
   XCHG AL,DS:[SI];
   MOV  ES:[DI],AL;
  POP DS;
 END;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      ChgChr                          ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

 Note :

  ş Cette fonction n'existe que dans un but de compatibilit‚
    avec l'ancien version de Malte System, maintenant, il est
    pr‚f‚rable d'utiliser la procedure ChgByte.

}

{$IFDEF __EXTERNAL__}

 Procedure ChgChr(Var A,B:Byte); external;

{$ELSE}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure ChgChr(Var A,B:Byte);
  Assembler;
  ASM
   PUSH DS;
    LES  DI,A;
    LDS  SI,B;
    MOV  AL,ES:[DI];
    XCHG AL,DS:[SI];
    MOV  ES:[DI],AL;
   POP DS;
  END;

 {$ELSE}

  Procedure ChgChr(Var A,B:Byte);
  Var T : Byte;
  Begin
   T := A; A := B; B := T;
  End;

 {$ENDIF}

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      ChgWord                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure ChgWord(Var A,B:Word); external;

{$ELSE}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure ChgWord(Var A,B:Word);
  Assembler;
  ASM
   PUSH DS;
    LES  DI,A;
    LDS  SI,B;
    MOV  AX,ES:[DI];
    XCHG AX,DS:[SI];
    MOV  ES:[DI],AX;
   POP DS;
  END;

 {$ELSE}

  Procedure ChgWord(Var A,B:Word);
  Var T : Word;
  Begin
   T := A; A := B; B := T;
  End;

 {$ENDIF}

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      ChgDWord                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure ChgDWord(Var A,B:LongInt); external;

{$ELSE}

 {$IFDEF __ASSEMBLERSUPPORT__}

  {$IFDEF __386__}

   Procedure ChgDWord(Var A,B:LongInt);
   Assembler;
   ASM
    PUSH DS;
     LES  DI,A;
     LDS  SI,B;
     DD __MOV_EAX_ES_DI;
     DD __XCHG_EAX_DS_SI;
     DD __MOV_ES_DI_EAX;
    POP  DS;
   END;

  {$ELSE}

   Procedure ChgDWord(Var A,B:LongInt);
   Assembler;
   ASM
    PUSH DS;
     LES  DI,A;
     LDS  SI,B;
     MOV  AX,ES:[DI];
     XCHG AX,DS:[SI];
     MOV  ES:[DI],AX;
     MOV  AX,ES:[DI+2];
     XCHG AX,DS:[SI+2];
     MOV  ES:[DI+2],AX;
    POP  DS;
   END;

  {$ENDIF}

 {$ELSE}

  Procedure ChgDWord(Var A,B:LongInt);
  Var T : LongInt;
  Begin
   T := A; A := B; B := T;
  End;

 {$ENDIF}

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      _Dec15Chn                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure _Dec15Chn(X:Byte;Var Str:StrByte); external;

{$ELSE}

 Procedure _Dec15Chn(X:Byte;Var Str:StrByte);
 Begin
  If(X > 9)Then
  Begin
   Str[0] := #2;
   Str[1] := Char(Byte(BaseChar) + (X div 10));
   Str[2] := Char(Byte(BaseChar) + (X mod 10));
  End
   else
  Begin
   Str[0] := #1;
   Str[1] := Char(Byte(BaseChar) + X);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      _Dec15Chn_                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure _Dec15Chn_(X:Byte;Str:StrByte); external;

{$ELSE}

 Procedure _Dec15Chn_(X:Byte;Var Str:StrByte);
 Begin
  If(X > 9)Then
  Begin
   Str[0] := #2;
   Str[1] := Char(Byte('0') + (X div 10));
   Str[2] := Char(Byte('0') + (X mod 10));
  End
   else
  Begin
   Str[0] := #1;
   Str[1] := Char(Byte('0') + X);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      _DecByteChn                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure _DecByteChn(X:Byte;Var Str:StrByte); external;

{$ELSE}

 Procedure _DecByteChn(X:Byte;Var Str:StrByte);
 {$IFDEF __OPTIMIZESIZE__}
  Var I  : Byte;
      TW : Word;
 {$ENDIF}
 Begin
  If(X > 99)Then
  Begin
   Str[0] := #3;
   {$IFDEF __OPTIMIZESIZE__}
    TW := 100;
    For I := 1 to 3 do
    Begin
     Str[I] := Char(Byte(BaseChar) + ((X div TW) mod 10));
     TW := TW div 10;
    End;
   {$ELSE}
    Str[1] := Char(Byte(BaseChar) + (X div 100));
    Str[2] := Char(Byte(BaseChar) + ((X div 10) mod 10));
    Str[3] := Char(Byte(BaseChar) + (X mod 10));
   {$ENDIF}
  End
   else
  If(X > 9)Then
  Begin
   Str[0] := #2;
   Str[1] := Char(Byte(BaseChar) + (X div 10));
   Str[2] := Char(Byte(BaseChar) + (X mod 10));
  End
   else
  Begin
   Str[0] := #1;
   Str[1] := Char(Byte(BaseChar) + X);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     _DecByteChn_                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure _DecByteChn_(X:Byte;Var Str:StrByte); external;

{$ELSE}

 Procedure _DecByteChn_(X:Byte;Var Str:StrByte);
 {$IFDEF __OPTIMIZESIZE__}
  Var I  : Byte;
      TW : Word;
 {$ENDIF}
 Begin
  If(X > 99)Then
  Begin
   Str[0] := #3;
   {$IFDEF __OPTIMIZESIZE__}
    TW := 100;
    For I := 1 to 3 do
    Begin
     Str[I] := Char(Byte('0') + ((X div TW) mod 10));
     TW := TW div 10;
    End;
   {$ELSE}
    Str[1] := Char(Byte('0') + (X div 100));
    Str[2] := Char(Byte('0') + ((X div 10) mod 10));
    Str[3] := Char(Byte('0') + (X mod 10));
   {$ENDIF}
  End
   else
  If(X > 9)Then
  Begin
   Str[0] := #2;
   Str[1] := Char(Byte('0') + (X div 10));
   Str[2] := Char(Byte('0') + (X mod 10));
  End
   else
  Begin
   Str[0] := #1;
   Str[1] := Char(Byte('0') + X);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     _DecWordChn_                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure _DecWordChn_(X:Word;Var Str:StrWord); external;

{$ELSE}

 Procedure _DecWordChn_(X:Word;Var Str:StrWord);
 {$IFDEF __OPTIMIZESIZE__}
  Var I  : Byte;
      TW : Word;
 {$ENDIF}
 Begin
  If(X > 9999)Then
  Begin
   Str[0] := #5;
   {$IFDEF __OPTIMIZESIZE__}
    TW := 10000;
    For I := 1 to 5 do
    Begin
     Str[I] := Char(Byte('0') + ((X div TW) mod 10));
     TW := TW div 10;
    End;
   {$ELSE}
    Str[1] := Char(Byte('0') + (X div 10000));
    Str[2] := Char(Byte('0') + ((X div 1000) mod 10));
    Str[3] := Char(Byte('0') + ((X div 100) mod 10));
    Str[4] := Char(Byte('0') + ((X div 10) mod 10));
    Str[5] := Char(Byte('0') + (X mod 10));
   {$ENDIF}
  End
   else
  If(X > 999)Then
  Begin
   Str[0] := #4;
   {$IFDEF __OPTIMIZESIZE__}
    TW := 1000;
    For I := 1 to 4 do
    Begin
     Str[I] := Char(Byte('0') + ((X div TW) mod 10));
     TW := TW div 10;
    End;
   {$ELSE}
    Str[1] := Char(Byte('0') + (X div 1000));
    Str[2] := Char(Byte('0') + ((X div 100) mod 10));
    Str[3] := Char(Byte('0') + ((X div 10) mod 10));
    Str[4] := Char(Byte('0') + (X mod 10));
   {$ENDIF}
  End
   else
  If(X > 99)Then
  Begin
   Str[0] := #3;
   {$IFDEF __OPTIMIZESIZE__}
    TW := 100;
    For I := 1 to 3 do
    Begin
     Str[I] := Char(Byte('0') + ((X div TW) mod 10));
     TW := TW div 10;
    End;
   {$ELSE}
    Str[1] := Char(48 + (X div 100));
    Str[2] := Char(48 + ((X div 10) mod 10));
    Str[3] := Char(48 + (X mod 10));
   {$ENDIF}
  End
   else
  If(X > 9)Then
  Begin
   Str[0] := #2;
   Str[1] := Char(48 + (X div 10));
   Str[2] := Char(48 + (X mod 10));
  End
   else
  Begin
   Str[0] := #1;
   Str[1] := Char(48 + X);
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       Bin15Chn                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure Bin15Chn(X:Byte;Var Str:StrByte); external;

{$ELSE}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure Bin15Chn(X:Byte;Var Str:StrByte);
  Assembler;
  ASM
   LES DI,Str;
   MOV CX,4;
   MOV ES:[DI],CL;
   ADD DI,5;
   MOV AL,Byte(BaseChar);
   MOV DH,X;
@@1:
   MOV  BX,DI;
   SUB  BX,CX;
   MOV  AH,DH;
   SAR  AH,CL;
   MOV  AH,0; { Attention! Ne jamais changer cette instruction!!! }
   ADC  AH,AL;
   MOV  ES:[BX],AH;
   LOOP @@1;
  END;

 {$ELSE}

  Procedure Bin15Chn(X:Byte;Var Str:StrByte);
  Var J : Byte;
  Begin
   For J := 0 to 3 do Str[4-J] := Char(Byte(BaseChar) + (X shr J) and 1);
   Str[0] := #4;
  End;

 {$ENDIF}

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       Bin15Chn_                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure Bin15Chn_(X:Byte;Var Str:StrByte); external;

{$ELSE}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure Bin15Chn_(X:Byte;Var Str:StrByte);
  Assembler;
  ASM
   MOV CX,4;
   LES DI,Str;
   MOV ES:[DI],CL;
   ADD DI,5;
   MOV AL,Byte('0');
   MOV DH,X;
@@1:
   MOV  BX,DI;
   SUB  BX,CX;
   MOV  AH,DH;
   SAR  AH,CL;
   MOV  AH,0; { Attention! Ne jamais changer cette instruction!!! }
   ADC  AH,AL;
   MOV  ES:[BX],AH;
   LOOP @@1;
  END;

 {$ELSE}

  Procedure Bin15Chn_(X:Byte;Var Str:StrByte);
  Var J : Byte;
  Begin
   For J := 0 to 3 do Str[4-J] := Char(Byte('0') + ((X shr J) and 1));
   Str[0] := #4;
  End;

 {$ENDIF}

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BinByteChn                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure BinByteChn(X:Byte;Var Str:StrByte); external;

{$ELSE}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure BinByteChn(X:Byte;Var Str:StrByte);
  Assembler;
  ASM
   LES  DI,Str;
   MOV  CX,8;
   MOV  ES:[DI],CL;
   ADD  DI,9;
   MOV  AL,Byte(BaseChar);
   MOV  DH,X;
@@1:
   MOV  BX,DI;
   SUB  BX,CX;
   MOV  AH,DH;
   SAR  AH,CL;
   MOV  AH,0; { Attention! Ne jamais changer cette instruction!!! }
   ADC  AH,AL;
   MOV  ES:[BX],AH;
   LOOP @@1;
  END;

 {$ELSE}

  Procedure BinByteChn(X:Byte;Var Str:StrByte);
  Var J : Byte;
  Begin
   For J := 0 to 7 do Str[8-J] := Char((Byte(BaseChar) + ((X shr J) and 1)));
   Str[0] := #8;
  End;

 {$ENDIF}

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BinByteChn_                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure BinByteChn_(X:Byte;Var Str:StrByte); external;

{$ELSE}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Procedure BinByteChn_(X:Byte;Var Str:StrByte);
  Assembler;
  ASM
   LES DI,Str;
   MOV CX,8;
   MOV ES:[DI],CL;
   ADD DI,9;
   MOV AL,Byte('0');
   MOV DH,X;
@@1:
   MOV  BX,DI;
   SUB  BX,CX;
   MOV  AH,DH;
   SAR  AH,CL;
   MOV  AH,0; { Attention! Ne jamais changer cette instruction!!! }
   ADC  AH,AL;
   MOV  ES:[BX],AH;
   LOOP @@1;
  END;

 {$ELSE}

  Procedure BinByteChn_(X:Byte;Var Str:StrByte);
  Var J : Byte;
  Begin
   For J := 0 to 7 do Str[8-J] := Char(Byte('0') + ((X shr J) and 1));
   Str[0] := #8;
  End;

 {$ENDIF}

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BinWordChn                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure BinWordChn(X:Word;Var Str:StrWord); external;

{$ELSE}

 Procedure BinWordChn(X:Word;Var Str:StrWord);
 Var J : Byte;
 Begin
  For J := 0 to 15 do Str[16-J] := Char(Byte(BaseChar) + ((X shr J) and 1));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BinWordChn_                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure BinWordChn_(X:Word;Var Str:StrWord); external;

{$ELSE}

 Procedure BinWordChn_(X:Word;Var Str:StrWord);
 Var J : Byte;
 Begin
  For J := 0 to 15 do Str[16-J] := Char(48 + ((X shr J) and 1));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      DecByteChn                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure DecByteChn(X:Byte;Var Str:StrByte); external;

{$ELSE}

 Procedure DecByteChn(X:Byte;Var Str:StrByte);
 Begin
  Str[0] := #3;
  Str[1] := Char(Byte(BaseChar) + (X div 100));
  Str[2] := Char(Byte(BaseChar) + ((X div 10) mod 10));
  Str[3] := Char(Byte(BaseChar) + (X mod 10));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     DecByteChn_                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure DecByteChn_(X:Byte;Var Str:StrByte); external;

{$ELSE}

 Procedure DecByteChn_(X:Byte;Var Str:StrByte);
 Begin
  Str[0] := #3;
  Str[1] := Char(Byte('0') + (X div 100));
  Str[2] := Char(Byte('0') + ((X div 10) mod 10));
  Str[3] := Char(Byte('0') + (X mod 10));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     DecWordChn                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure DecWordChn(X:Word;Var Str:String); external;

{$ELSE}

 Procedure DecWordChn(X:Word;Var Str:StrWord);
 Begin
  Str[0] := #5;
  Str[1] := Char(Byte(BaseChar) + (X div 10000));
  Str[2] := Char(Byte(BaseChar) + ((X div 1000) mod 10));
  Str[3] := Char(Byte(BaseChar) + ((X div 100) mod 10));
  Str[4] := Char(Byte(BaseChar) + ((X div 10) mod 10));
  Str[5] := Char(Byte(BaseChar) + (X mod 10));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     HexByteChn                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure HexByteChn(X:Byte;Var Str:StrByte); external;

{$ELSE}

 Procedure HexByteChn(X:Byte;Var Str:StrByte);
 Begin
  Str[0] := #2;
  Str[1] := DataHex[X shr 4];
  Str[2] := DataHex[X and 15];
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     HexWordChn                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure HexWordChn(X:Word;Var Str:StrWord); external;

{$ELSE}

 Procedure HexWordChn(X:Word;Var Str:StrWord);
 Begin
  Str[0] := #4;
  Str[1] := DataHex[X shr 12];
  Str[2] := DataHex[(X shr 8) and 15];
  Str[3] := DataHex[(X shr 4) and 15];
  Str[4] := DataHex[X and 15];
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     OctByteChn                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure OctByteChn(X:Byte;Var Str:StrByte); external;

{$ELSE}

 Procedure OctByteChn(X:Byte;Var Str:StrByte);
 Begin
  Str[0] := #3;
  Str[1] := Char(Byte(BaseChar) + (X shr 6));
  Str[2] := Char(Byte(BaseChar) + ((X and 56) shr 3));
  Str[3] := Char(Byte(BaseChar) + (X and 7));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    OctByteChn_                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure OctByteChn_(X:Byte;Var Str:StrByte); external;

{$ELSE}

 Procedure OctByteChn_(X:Byte;Var Str:StrByte);
 Begin
  Str[0] := #3;
  Str[1] := Char(Byte('0') + (X shr 6));
  Str[2] := Char(Byte('0') + ((X and 56) shr 3));
  Str[3] := Char(Byte('0') + (X and 7));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SetBaseHex                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure SetBaseHex(X:Char); external;

{$ELSE}

 Procedure SetBaseHex(X:Char);
 Var I : Byte;
 Begin
  For I := 0 to 5 do DataHex[$0A + I] := Char(Byte(X) + I);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SetBaseNumeric                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure SetBaseNumeric(X:Char); external;

{$ELSE}

 Procedure SetBaseNumeric(X:Char);
 Var I : Byte;
 Begin
  BaseChar := X;
  For I := 0 to 9 do DataHex[I] := Char(Byte(X) + I);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SetHexDownCase                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure SetHexDownCase; external;

{$ELSE}

 Procedure SetHexDownCase;
 Begin
  DataHex[$0A] := 'a';
  DataHex[$0B] := 'b';
  DataHex[$0C] := 'c';
  DataHex[$0D] := 'd';
  DataHex[$0E] := 'e';
  DataHex[$0F] := 'f';
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     SetHexUpCase                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Procedure SetHexUpCase; external;

{$ELSE}

 Procedure SetHexUpCase;
 Begin
  DataHex[$0A] := 'A';
  DataHex[$0B] := 'B';
  DataHex[$0C] := 'C';
  DataHex[$0D] := 'D';
  DataHex[$0E] := 'E';
  DataHex[$0F] := 'F';
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   GetBaseNumeric                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __EXTERNAL__}

 Function GetBaseNumeric:Byte; external;

{$ELSE}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Function GetBaseNumeric:Char;
  Assembler;
  ASM
   MOV AL,BaseChar;
  END;

 {$ELSE}

  Function GetBaseNumeric:Char;
  Begin
   GetBaseNumeric := BaseChar;
  End;

 {$ENDIF}

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      FillWord                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure FillWord(Var X;Len,Value:Word);
 Assembler;
 ASM
  CLD;
  LES DI,X;
  MOV CX,Len;
  MOV AX,Value;
  {$IFDEF __386__}
   DB __PUSH_AX, __PUSH_AX;
   DW __POP__EAX;
   SHR CX,1;
   DB __REP; DW __STOSD;
   ADC CX,CX;
   REP STOSW;
  {$ELSE}
   REP STOSW;
  {$ENDIF}
 END;

{$ELSE}

 Procedure FillWord(Var X;Len,Value:Word);
 Var I  : Word;
     TX : ^TWord;
 Begin
  TX := @X;
  For I := 0 to (Len-1) do TX^[I] := Value;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 FillWordWithByte                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure FillWordWithByte(Var X;Len:Word;Value:Byte);
 Assembler;
 ASM
  LES DI,X;
  MOV CX,Len;
  MOV AL,Value;
  MOV AH,AL;
  CLD
  REP STOSW;
 END;

{$ELSE}

 Procedure FillWordWithByte(Var X;Len:Word;Value:Byte);
 Var I  : Word;
     TX : ^TWord;
     V  : Word;
 Begin
  V := Value + (Value shl 8); TX := @X;
  For I := 0 to (Len-1) do TX^[I] := Value;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     FillNotByte                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure FillNotByte(Var X;Len:Word);
 Assembler;
 ASM
  CLD;
  LES DI,X;
  MOV CX,Len;
@@1:
  MOV AL,ES:[DI];
  NOT AL;
  STOSB;
  LOOPNZ @@1;
 END;

{$ELSE}

 Procedure FillNotByte(Var X;Len:Word);
 Var I  : Byte;
     TX : ^TByte;
 Begin
  TX := @X;
  For I := 0 to (Len-1) do TX^[I] := Not(TX^[I]);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     FillNotWord                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure FillNotWord(Var X;Len:Word);
 Assembler;
 ASM
  CLD;
  LES DI,X;
  MOV CX,Len;
@@1:
  MOV AX,ES:[DI];
  NOT AX;
  STOSW;
  LOOPNZ @@1;
 END;

{$ELSE}

 Procedure FillNotWord(Var X;Len:Word);
 Var I  : Byte;
     TX : ^TWord;
 Begin
  TX := @X;
  For I := 0 to (Len-1) do TX^[I] := Not(TX^[I]);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Move                          ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Move(Var Source,Dest;Count:Word);
Assembler;
ASM
 CLD;
 PUSH DS;
  LDS SI,Source;
  LES DI,Dest;
  MOV CX,Count;
  {$IFDEF __386__}
   MOV BX,CX;
   AND BX,3;
   SHR CX,2;
   DB  __REP; DW __MOVSD;
   MOV CX,BX;
   REP MOVSB;
  {$ELSE}
   {$IFOPT G+}
    SHR CX,1;
    REP MOVSW;
    ADC CX,CX;
    REP MOVSB;
   {$ELSE}
    REP MOVSB;
   {$ENDIF}
  {$ENDIF}
 POP  DS;
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MemSet                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure MemSet(Var X;Len:Word;Value:Byte);
 Assembler;
 ASM
  CLD;
  LES DI,X;
  MOV CX,Len;
  MOV AL,Value;
  {$IFDEF __386__}
   MOV AH,AL;
   DB  __PUSH_AX,__PUSH_AX;
   DW  __POP__EAX;
   MOV BX,CX;
   AND BX,3;
   SHR CX,2;
   DB  __REP; DW __STOSD;
   MOV CX,BX;
   REP STOSB;
  {$ELSE}
   {$IFOPT G+}
    MOV AH,AL;
    SHR CX,1;
    REP STOSW;
    ADC CX,CX;
    REP STOSB;
   {$ELSE}
    REP STOSB;
   {$ENDIF}
  {$ENDIF}
 END;

{$ELSE}

 Procedure MemSet(Var X;Len:Word;Value:Byte);
 Begin
  FillChar(X,Len,Value);
 End;

{$ENDIF}

BEGIN { Main Unit }
END.