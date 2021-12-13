(********************************************************)
(*                                                      *)
(*                     Malte Catalog                    *)
(*                      1993/01/23                      *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{$M 16384,65536,655360 }

Uses

     LuxeVid,KeyBoard,Windows,Level,Dir,MCatFile,MCatStr,
     MCatIn,MCatWin,MCatFExt,MCatParm,MCatExit,MCatPrn,
     LanDStr,Mouse,MCatGetManual,MCatVFiles,MCatConsultation,
     MCatSetup,CenterMenu;

Const

      catDivers              = 41;

Function BaseMenu:Byte;
Const NumberOption = 5;
      Pos : Word = 0;
      Option : Array[lgEnglish..lgFrench,0..NumberOption] of CenterMenuRecord =
       (
        (
         (
	  Key       : 'ReadDisk';
	  LongMsg   : 'This option get information in disk.';
	  MsgEndBar : 'Read in disk';
	  Actived   : True
	 ),
         (
	  Key       : 'Manual';
	  LongMsg   : 'This option get manually the informations.';
	  MsgEndBar : 'Get manually';
	  Actived   : True
	 ),
         (
	  Key       : 'Catalog';
	  LongMsg   : 'This option read information in catalog';
	  MsgEndBar : 'Read catalog';
	  Actived   : True
	 ),
         (
          Key       : 'Setup';
          LongMsg   : 'This option change path, video and other environment program.';
          MsgEndBar : 'For setting program';
          Actived   : True
         ),
         (
	  Key       : 'Exit';
	  LongMsg   : 'This option exiting of the program.';
	  MsgEndBar : 'Exit this program';
	  Actived   : True
	 ),
         (Key:NIL;LongMsg:NIL;MsgEndBar:NIL;Actived:True)
        ),
        (
         (
	  Key       : 'Lie disque';
	  LongMsg   : 'Cette option lis les informations du disque.';
	  MsgEndBar : 'Addition d''un disque';
	  Actived   : True
	 ),
         (
	  Key       : 'Manuel';
	  LongMsg   : 'Cette option entre manuellement les informations.';
	  MsgEndBar : 'Charge manuellement';
	  Actived   : True
	 ),
         (
	  Key       : 'Catalogue';
	  LongMsg   : 'Cette option consulte les informations du catalogue.';
	  MsgEndBar : 'Consulte le catalogue';
	  Actived   : True
	 ),
         (
          Key       : 'Ajustement';
          LongMsg   : 'Cette option d‚finit les r‚pertoires, l''affichage vid‚o, ...';
          MsgEndBar : 'Ajuste les paramŠtres de l''environnement du programme';
          Actived   : True
         ),
         (Key       : 'Quitte';
	  LongMsg   : 'Cette option permet de quitter le programme.';
	  MsgEndBar : 'Quitte ce programme';
	  Actived   : True
	 ),
         (Key:NIL;LongMsg:NIL;MsgEndBar:NIL;Actived:True)
        )
       );
Var W  : WinCenterMnu;
    K  : Word;
    Ok : Boolean;
Begin
 W.Init(40,1+NumberOption*3,LStr('Main Menu','Menu Principal'),
        LStr('Description','Description'),@Option[Language,0]);
 Repeat
  Ok := False;
  K := W.Run(Pos);
  If(K = kbEsc)or(K = _Close_)Then Halt;
  If(K = kbEnter)Then
  Begin
   If(Pos = 4)Then Halt
              Else Ok := True;
  End;
 Until Ok;
 W.Done;
 BaseMenu := Pos;
End;

Procedure Menu;
Var B : Byte;
Begin
 Repeat
  B := BaseMenu;
  Case B of
   0 : Begin
        _Drive := WinSelectFloppyDisk(_Drive);
        If(_Drive < 255)Then GetDiskInfo(_Drive);
       End;
   1 : Begin
        GetManually;
       End;
   2 : Begin
        Consultation;
       End;
   3 : Setup;
   4 : SpeedHalt;
  End;
 Until (B = 4);
End;

Procedure MCatMain;
Begin
 SetParameter;
 SetMouse(_Mouse);
 InitVideoDeluxe;
 InitScreenApplication(LStr('Malte Catalog ','Catalogue Malte')+PathToName(_FileName));
 WinAbout;
 Menu;
 DoneVideoDeluxe;
End;