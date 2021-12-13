(********************************************************)
(*                                                      *)
(*              Malte Catalog/Parameters                *)
(*                     1993/01/28                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit MCatParm;

(********************************************************)
                       INTERFACE
(********************************************************)

Const

      _VideoMethode : Byte = 0;
      _Joystick     : Boolean = False;
      _Mouse        : Boolean = True;

Procedure SetParameter;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses DString,Level,Text,MCatFile,
     StringParameter;

Procedure SetParameter;
Var I   : Word;
    Chn : String;
Begin
 If(ParamCount > 0)Then
 Begin
  For I := 1 to ParamCount do
  Begin
   Chn := StrUpper(DelBarParam(ParamStr(I)));
   If(IsStrHelp(Chn))Then
   Begin
    WriteLn;
    Case Language of
     lgEnglish : Begin
                  WriteLn('Malte Catalog  Version 1.1  Copyright (C) 1993 par les Chevaliers de Malte');
                  WriteLn;
                  WriteLn('MCAT [/MS|/NOMS][/BIOSVID|/DIRECTVID][/FRA|/ENG] [drive:] [index:]');
                  WriteLn;
                  WriteLn(' drive:       Is a default disk your catalog');
                  WriteLn(' index:       Is a index file name');
                  WriteLn;
                  WriteLn(' /BIOSVID     Use BIOS for put info in screen');
                  WriteLn(' /DIRECTVID   Write directly in screen');
                  WriteLn;
                  WriteLn(' /MS          Use mouse');
                  WriteLn(' /NOMS        Not use mouse');
                  WriteLn;
                  WriteLn(' /FRA         Use french language');
                  WriteLn(' /ENG         Use english language');
                  WriteLn;
                  WriteLn(' /SET         Put help the prompt SET in DOS');
                 End;
            else Begin
                  WriteLn('Catalogue Malte  Version 1.1  Copyright (C) 1993 par les Chevaliers de Malte');
                  WriteLn;
                  WriteLn('MCAT [/MS|/NOMS][/BIOSVID|/DIRECTVID][/FRA|/ENG] [drive:] [index:]');
                  WriteLn;
                  WriteLn(' drive:       Est le disque par d‚faut de cataloguage');
                  WriteLn(' index:       Est le nom de le nom du fichier d''index');
                  WriteLn;
                  WriteLn(' /BIOSVID     Utilise le BIOS pour l''affichage … l''‚cran');
                  WriteLn(' /DIRECTVID   Ecrit directement dans le tampon vid‚o');
                  WriteLn;
                  WriteLn(' /MS          Utilise la souris');
                  WriteLn(' /NOMS        N''utilise pas la souris');
                  WriteLn;
                  WriteLn(' /FRA         Utilise la langue francaise');
                  WriteLn(' /ENG         Utilise la langue anglaise');
                  WriteLn;
                  WriteLn(' /SET         Affiche l''aide des SET du prompt');
                 End;
    End;
    WriteLn;
    Halt;
   End
    else
   If(Chn = 'SET')Then
   Begin
    WriteLn;
    Case Language of
     lgEnglish : Begin
                  WriteLn('Malte Catalog  Version 1.1  Copyright (C) 1993 par les Chevaliers de Malte');
                  WriteLn;
                  WriteLn(' SET  TMP               Path of tempory file');
                  WriteLn('      MCATPATHDISKINFO  Path of DiskInfo');
                  WriteLn('      MCATPATHINDEX     Path of index');
                  WriteLn('      MCATPATHMAIN      Path of main program');
                 End;
            else Begin
                  WriteLn('Catalogue Malte  Version 1.1  Copyright (C) 1993 par les Chevaliers de Malte');
                  WriteLn;
                  WriteLn(' SET  TMP               R‚pertoire des fichiers temporaires');
                  WriteLn('      MCATPATHDISKINFO  R‚pertoire des fichiers DiskInfo');
                  WriteLn('      MCATPATHINDEX     R‚pertoire du fichier index');
                  WriteLn('      MCATPATHMAIN      R‚pertoire du programme principal');
                 End;
    End;
    WriteLn;
    Halt;
   End
    else
   If(IsStrSetEnglish(Chn))Then Language := lgEnglish else
   If(IsStrSetFrench(Chn))Then Language := lgFrench else
   If(IsStrSetBIOSScrn(Chn))Then _VideoMethode := ScrnBIOS else
   If(IsStrSetDirectScrn(Chn))Then _VideoMethode := ScrnDirect else
   If(Chn = 'JOYSTICK')Then _Joystick := True else
   If(Chn = 'MOUSE')Then _Mouse := True else
   If(Chn = 'MS')Then _Mouse := True else
   If(Chn = 'NOJOY')Then _Joystick := False else
   If(Chn = 'NOJOYSTICK')Then _Joystick := False else
   If(Chn = 'NOMOUSE')Then _Mouse := False else
   If(Chn = 'NOMS')Then _Mouse := False else
   If(IsStrDrive(Chn))Then _Drive := Byte(CharUpper(Chn[1])) - 64
    Else
   _FileName := ParamStr(I);
  End;
 End;
End;

BEGIN { Main Unit }
END.