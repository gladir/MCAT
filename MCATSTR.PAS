(********************************************************)
(*                                                      *)
(*               Malte Catalog/String                   *)
(*                     1993/01/24                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit MCatStr;

(********************************************************)
                      INTERFACE
(********************************************************)

Function StrCategory(Pos:Byte):String;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses Level;

Function StrCategory(Pos:Byte):String;
Begin
 Case Language of
  lgEnglish : Case Pos of
                0 : StrCategory := 'Anti-Virus';
                1 : StrCategory := 'Compression';
                2 : StrCategory := 'Conversion';
                3 : StrCategory := 'Demo';
                4 : StrCategory := 'Document';
                5 : StrCategory := 'Draw';
                6 : StrCategory := 'Draw Viewer';
                7 : StrCategory := 'Editor';
                8 : StrCategory := 'Emulator';
                9 : StrCategory := 'Games';
               10 : StrCategory := 'Graphic GIF';
               11 : StrCategory := 'Graphic JPG';
               12 : StrCategory := 'Graphic PCX';
               13 : StrCategory := 'Graphic PIC';
               14 : StrCategory := 'Language Assembler';
               15 : StrCategory := 'Language Basic';
               16 : StrCategory := 'Language C';
               17 : StrCategory := 'Language Cobol';
               18 : StrCategory := 'Language Forth';
               19 : StrCategory := 'Language Fortran';
               20 : StrCategory := 'Language Pascal';
               21 : StrCategory := 'Modem';
               22 : StrCategory := 'Modem BBS';
               23 : StrCategory := 'Modem Games';
               24 : StrCategory := 'Modem Protocol';
               25 : StrCategory := 'Modem Terminal';
               26 : StrCategory := 'Mouse';
               27 : StrCategory := 'Music';
               28 : StrCategory := 'School';
               29 : StrCategory := 'System';
               30 : StrCategory := 'Utility Disk';
               31 : StrCategory := 'Utility DOS';
               32 : StrCategory := 'Utility Floppy-Disk';
               33 : StrCategory := 'Utility Hard-Disk';
               34 : StrCategory := 'Utility Keyboard';
               35 : StrCategory := 'Utility Memory';
               36 : StrCategory := 'Utility System';
               37 : StrCategory := 'Utility Tools';
               38 : StrCategory := 'Utility Video';
               39 : StrCategory := 'Windows Games';
               40 : StrCategory := 'Windows Utility';
               41 : StrCategory := 'Other';
              End;
         else Case Pos of
                0 : StrCategory := 'Anti-Virus';
                1 : StrCategory := 'Compression';
                2 : StrCategory := 'Conversion';
                3 : StrCategory := 'DÇmo';
                4 : StrCategory := 'Document';
                5 : StrCategory := 'Dessin';
                6 : StrCategory := 'Dessin/Regard';
                7 : StrCategory := 'Editeur';
                8 : StrCategory := 'Emulateur';
                9 : StrCategory := 'Jeux';
               10 : StrCategory := 'Graphique GIF';
               11 : StrCategory := 'Graphique JPG';
               12 : StrCategory := 'Graphique PCX';
               13 : StrCategory := 'Graphique PIC';
               14 : StrCategory := 'Langage Assembler';
               15 : StrCategory := 'Langage Basic';
               16 : StrCategory := 'Langage C';
               17 : StrCategory := 'Langage Cobol';
               18 : StrCategory := 'Langage Forth';
               19 : StrCategory := 'Langage Fortran';
               20 : StrCategory := 'Langage Pascal';
               21 : StrCategory := 'Modem';
               22 : StrCategory := 'Modem BBS';
               23 : StrCategory := 'Modem Games';
               24 : StrCategory := 'Modem Protocole';
               25 : StrCategory := 'Modem Terminal';
               26 : StrCategory := 'Souris';
               27 : StrCategory := 'Musique';
               28 : StrCategory := 'êcole';
               29 : StrCategory := 'Systäme';
               30 : StrCategory := 'Utile disque';
               31 : StrCategory := 'Utile DOS';
               32 : StrCategory := 'Utile Disquette';
               33 : StrCategory := 'Utile Disque Dur';
               34 : StrCategory := 'Utile Clavier';
               35 : StrCategory := 'Utile MÇmoire';
               36 : StrCategory := 'Utile Systäme';
               37 : StrCategory := 'Utile Outils';
               38 : StrCategory := 'Utile VidÇo';
               39 : StrCategory := 'Windows Jeux';
               40 : StrCategory := 'Windows Utile';
               41 : StrCategory := 'Autre';
              End;
 End;
End;

BEGIN
END.