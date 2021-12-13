(********************************************************)
(*                                                      *)
(*            Malte System/String Parameter             *)
(*                    1993/05/07                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  DerniŠre modification :

   Vendredi, le 7 mai 1993 (Addition : IsStrDrive, IsStrHelp,
                            IsStrFrenchHelp, IsStrSetEnglish, 
                            IsStrSetFrench, IsStrSetBIOSScrn,
                            IsStrSetDirectScrn, DelBarParam).

  Directive de compilation conditionnel :

   Aucune
}

Unit StringParameter;

(********************************************************)
                        INTERFACE
(********************************************************)

Function DelBarParam(Str:String):String;
Function IsStrDrive(Str:String):Boolean;
Function IsStrFrenchHelp(Str:String):Boolean;
Function IsStrHelp(Str:String):Boolean;
Function IsStrSetBIOSScrn(Str:String):Boolean;
Function IsStrSetDirectScrn(Str:String):Boolean;
Function IsStrSetEnglish(Str:String):Boolean;
Function IsStrSetFrench(Str:String):Boolean;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses DString;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      DelBarParam                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function DelBarParam(Str:String):String;
Begin
 If(Str[1] in ['-','/','_'])Then Str := DeleteStr(Str,1,1);
 DelBarParam := Str;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      IsStrDrive                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function IsStrDrive(Str:String):Boolean;
Begin
 IsStrDrive := ((Length(Str) = 2)and(Str[2] = ':')and
                (IsLetterRegular(Str[1])));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  IsStrFrenchHelp                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function IsStrFrenchHelp(Str:String):Boolean;
Begin
 If(Str[1] in ['-','/','_'])Then Str := DeleteStr(Str,1,1);
 Str := StrUpper(Str);
 IsStrFrenchHelp := ((Str = 'AIDE')or(Str = 'AIDES')or
                     (Str = 'HLPFRA')or(Str = 'HLPFRENCH'));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       IsStrHelp                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function IsStrHelp(Str:String):Boolean;
Begin
 If(Str[1] in ['-','/','_'])Then Str := DeleteStr(Str,1,1);
 Str := StrUpper(Str);
 IsStrHelp := ((Str = '?')or(Str = 'HLP')or(Str = 'HELP')or
               (Str = 'AIDE')or(Str = 'AIDES')or(Str = 'HLPFRA')or
               (Str = 'HLPFRENCH'));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     IsStrSetBIOSScrn                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function IsStrSetBIOSScrn(Str:String):Boolean;
Begin
 If(Str[1] in ['-','/','_'])Then Str := DeleteStr(Str,1,1);
 Str := StrUpper(Str);
 IsStrSetBIOSScrn := ((Str = 'BIOSSCRN')or(Str = 'BIOSVIDEO')or
                      (Str = 'BIOSVID')or(Str = 'VIDBIOS')or
                      (Str = 'VIDEOBIOS')or(Str = 'BIOSSCR')or
                      (Str = 'BIOSCR')or(Str = 'BIOSCRN')or
                      (Str = 'BIOSSCRN'));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    IsStrSetDirectScrn                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function IsStrSetDirectScrn(Str:String):Boolean;
Begin
 If(Str[1] in ['-','/','_'])Then Str := DeleteStr(Str,1,1);
 Str := StrUpper(Str);
 IsStrSetDirectScrn := ((Str = 'DIRECTSCRN')or(Str = 'DIRECTSCR')or
                        (Str = 'DIRECTSCREEN')or(Str = 'DIRECTVID')or
                        (Str = 'DIRECTVIDEO')or(Str = 'SCRNDIRECT')or
                        (Str = 'VIDDIRECT')or(Str = 'VIDIRECT')or
                        (Str = 'VDIRECT')or(Str = 'VIDEODIRECT'));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     IsStrSetEnglish                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function IsStrSetEnglish(Str:String):Boolean;
Begin
 If(Str[1] in ['-','/','_'])Then Str := DeleteStr(Str,1,1);
 Str := StrUpper(Str);
 IsStrSetEnglish := ((Str = 'ANG')or(Str = 'ANGLAIS')or
                     (Str = 'ENG')or(Str = 'ENGLISH'));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     IsStrSetFrench                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function IsStrSetFrench(Str:String):Boolean;
Begin
 If(Str[1] in ['-','/','_'])Then Str := DeleteStr(Str,1,1);
 Str := StrUpper(Str);
 IsStrSetFrench := ((Str = 'FR')or(Str = 'FRA')or(Str = 'FRE')or
                    (Str = 'FRENCH')or(Str = 'FRANCAIS'));
End;

BEGIN { Main Unit }
END.