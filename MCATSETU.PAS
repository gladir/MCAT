(********************************************************)
(*                                                      *)
(*                Malte Catalog/Setup                   *)
(*                    1993/05/15                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  DerniŠre modification :

   Samedi, le 15 mai 1993  (Addition : Setup).
   Lundi, le 17 mai 1993   (Addition : SetVideoMode,
                            SetVideoCtrl).
}

Unit MCatSetup;

(********************************************************)
                       INTERFACE
(********************************************************)

Procedure Setup;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses Keyboard,Level,MainMenu,Strings,
     MalteDOS,
     GadgetVideo,
     GadgetPath,
     GadgetPrinter;

Const MnuOption : Array[lgEnglish..lgFrench,0..4] of
                  Record
                   Title:PChar;
                   Mnu:PChar;
                   MsgEndBar:PChar;
		  End =
                  (
                   (
                    (
                     Title:'^S^etup';
                     Mnu:'^D^efault||^R^ead|^S^ave|Save ^a^s||^D^OS Shell||^E^xit';
                     MsgEndBar:'Set default parameters|'+
		               '|'+
		               'Read setup file|'+
			       'Save setup in file|'+
			       'Save setup in file with different name, directory, ...||'+
			       'Tempory shelling to DOS|'+
			       '|'+
			       'Exit in setup'
                    ),
                    (
                     Title:'S^y^stem';
                     Mnu:'^L^evel|^K^eyboard|^P^rinter|^M^ouse';
                     MsgEndBar:'Set language, category, level, and security option|'+
		               'Set keyboard manager methode|'+
			       'Set printer option|'+
			       'Set mouse option'
                    ),
                    (
                     Title:'^D^isk';
                     Mnu:'^P^ath|^S^torage';
                     MsgEndBar:'Set path of storage information|'+
		               'Set methode of storage (old or new)'
                    ),
                    (
                     Title:'^V^ideo';
                     Mnu:'^V^ideo Mode|C^o^ntrol|^C^olor';
                     MsgEndBar:'Set video mode screen this program running|'+
                               'Set video controle methode|'+
                               'Set screen color'
                    ),
                    (
                     Title:NIL;Mnu:NIL;MsgEndBar:NIL
                    )
                   ),
                   (
                    (
                     Title:'^A^justement';
                     Mnu:'^D^‚faut||^L^ecture|^S^auve|Sauve s^o^us||^D^OS Shell||^Q^uitte';
                     MsgEndBar:'Fixe les paramŠtres par d‚faut de programme|'+
		               '|'+
		               'Lecture du fichier de paramŠtre du programme|'+
			       'Sauvegarde des paramŠtres du programmme|'+
			       'Sauve les paramŠtres setup sous un nom, un r‚pertoire,... diff‚rent|'+
			       '|'+
			       'Quitte temporaire le programme pour aller au prompt du DOS|'+
			       '|'+
			       'Quitte l''ajustement de programme'
                    ),
                    (
                     Title:'^S^ystŠme';
                     Mnu:'^N^iveau|^C^lavier|^I^mprimante|^S^ouris';
                     MsgEndBar:'Fixe la langage, cat‚gorie, niveau et les options de s‚curit‚|'+
		               'Fixe la m‚thode de gestion du clavier|'+
			       'Fixe les options de l''imprimante|'+
			       'Fixe les option de la souris'
                    ),
                    (
                     Title:'^D^isque';
                     Mnu:'^R^‚pertoire|^S^torage';
                     MsgEndBar:'Fixe les r‚pertoires pour les informations,...|'+
                               'D‚finit la m‚thode storage de l''information (Ancien ou nouvelle)'
                    ),
                    (
                     Title:'^V^id‚o';
                     Mnu:'Mode ^V^id‚o|C^o^ntr“le|^C^ouleur';
                     MsgEndBar:'Sp‚cifie le mode vid‚o … lequel le programme fonctionner|'+
                               'D‚finit la m‚thode gestion du vid‚o|'+
                               'Change les couleurs de l''‚cran'
                    ),
                    (
                     Title:NIL;Mnu:NIL;MsgEndBar:NIL
                    )
                   )
		  );

        PathOption : Array[lgEnglish..lgFrench,0..4] of GadgetPathRecord =
                     (
	              (
                       (Msg:'Main Path';DefaultPath:'C:\MALTE\MCAT';NewPath:''),
                       (Msg:'Index path';DefaultPath:'C:\MALTE\MCAT\INDEX';NewPath:''),
                       (Msg:'Disk info path';DefaultPath:'C:\MALTE\MCAT\DISKINFO';NewPath:''),
                       (Msg:'Help path';DefaultPath:'C:\MALTE\MCAT;C:\MALTE\MCAT\HLP';NewPath:''),
                       (Msg:NIL;DefaultPath:NIL;NewPath:'')
		      ),
                      (
                       (Msg:'R‚pertoire principal';DefaultPath:'C:\MALTE\MCAT';NewPath:''),
                       (Msg:'R‚pertoire d''index';DefaultPath:'C:\MALTE\MCAT\INDEX';NewPath:''),
                       (Msg:'R‚pertoire d''info disque';DefaultPath:'C:\MALTE\MCAT\DISKINFO';NewPath:''),
                       (Msg:'R‚pertoire d''aide';DefaultPath:'C:\MALTE\MCAT;C:\MALTE\MCAT\HLP';NewPath:''),
                       (Msg:NIL;DefaultPath:NIL;NewPath:'')
		      )
		     );

        VideoMode : Array[0..8] of VideoModeRecord =
	            (
                     (Mode:'80x25';Actif:True),
                     (Mode:'80x28';Actif:False),
                     (Mode:'80x43';Actif:False),
                     (Mode:'80x50';Actif:False),
                     (Mode:'100x40';Actif:False),
                     (Mode:'132x25';Actif:False),
                     (Mode:'132x28';Actif:False),
                     (Mode:'132x44';Actif:False),
                     (Mode:NIL)
		    );

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        SetLevel                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetLevel;
Begin
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetKeyboard                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetKeyboard;
Begin
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetPrinter                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetPrinter;
Begin
 PrinterSetup;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        SetMouse                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetMouse;
Begin
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        SetPath                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetPath;
Const Title : Array[lgEnglish..lgFrench] of PChar =
              (
	       'Directories','R‚pertoires'
	      );
Begin
 GadgetPath.GetPath(Title[Language],@PathOption[Language,0]);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        SetStorage                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetStorage;
Begin
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetVideoMode                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetVideoMode;
Begin
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetVideoCtrl                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetVideoCtrl;
Begin
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetVideoColor                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetVideoColor;
Begin
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Setup                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Setup;
Var SetupChanged : Boolean;
    MasterSystem : MnuObject;
    Mnu,Option   : Byte;
    K            : Word;
    Ok           : Boolean;
Begin
 SetupChanged := False;
 MasterSystem.Init(@MnuOption[Language,0]);
 Repeat
  Ok := False;
  K := MasterSystem.Run(Mnu,Option);
  Case K of
   kbEnter : Begin
              Case Mnu of
               0 : Case Option of
                    6 : WinMalteDOS;
                    8 : Ok := True;
                   End;
               1 : Case Option of
                    0 : SetLevel;
                    1 : SetKeyboard;
                    2 : SetPrinter;
                    3 : SetMouse;
                   End;
               2 : Case Option of
                    0 : SetPath;
                    1 : SetStorage;
                   End;
               3 : Case Option of
                    0 : SetVideoMode;
                    1 : SetVideoCtrl;
                    2 : SetVideoColor;
                   End;
              End;
             End;
  End;
 Until Ok;
 MasterSystem.Done;
End;

BEGIN { Main Unit }
END.