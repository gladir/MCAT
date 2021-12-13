(************************************************************)
(*                                                          *)
(*                    Malte System/Text                     *)
(*                       1992/08/30                         *)
(*                                                          *)
(*        Copyright (C) par les Chevaliers de Malte         *)
(*                                                          *)
(************************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System & Borland's Graphics Interface (BGI).

  Nom :

   Texte (Text).

  DerniŠre modification :

   Dimanche, le 9 mai 1993   (Modification des directives de compilations
                              pour l'adaptation … l'assembler;
			      Addition des directives de compilation pour
			      les chaines de caractŠre de type pointeur),
                             (Debug : GetSizeBox).
   Mardi, le 11 mai 1993     (Addition des directives de compilation en
                              mode prot‚g‚ en divers systŠme vid‚o).

  Directive de compilation conditionnel :

   DESQVIEW20            Indique qu'il s'adapter … DesqView 2.0.
   DPMI                  Indique qu'il tourne sous DPMI.
   OS2                   Indique que l'environnement de travaille est OS/2.
   QUICKPASCAL           Indique qu'il s'agit du compilateur QuickPascal.
   VER10                 Indique qu'il s'agit soit du QuickPascal 1.0 ou
                         du Turbo Pascal for Windows 1.0 (Pr‚d‚finit).
   VER60                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 6 (Pr‚d‚finit); si vous d‚finisez cette
                         directive, il faut ˆtre vraiment sur que ce
                         compilateur est compatible … 100%.
   VER70                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 7 (Pr‚d‚finit); si vous d‚finisez cette
                         directive, il faut ˆtre vraiment sur que ce
                         compilateur est compatible … 100%.
   WINDOWS               Indique que l'environnement de travaille est Windows
   __ASSEMBLERSUPPORT__  Indique que le compilateur support l'assembler.
                         (Pr‚d‚finit en fonction des autres variables).
   __EVEREXMICRO__       Indique qu'il doit supporteer les cartes vid‚o Everex.
   __EXTERNAL__          Indique qu'il faut faire appelle … la
                         bibliotŠque externe. Comme par exemple, si vous
                         d‚finis‚ des proc‚dures en Turbo C++, vous devrez
                         faire appelle a cette directive de compilation.
   __MSHERC__            Indique qu'il faut qu'il support le driver Hercule de
                         Microsoft.
   __MINIMIZECONST__     Utilise au minimum les constantes.
   __OPTIMIZESIZE__      Indique qu'il faut faire en sorte que le code
                         langage machine prenne le moin de place possible.
   __STRPTRSUPPORT__     Indique que le compilateur support des variables
                         de caractŠre du mˆme genre que le langage C.
   __TSENG4000__         Indique qu'il doit supporter la carte vid‚o Tseng 4000.
   __VIDEO7VGA__         Indique qu'il doit supporter la carte Video 7 VGA.

  Notes :

	  **** IBM CGA/MDA %100 Compatible ****

   ş Sur les cartes CGA et MDA, les modes texte clignote
     toujours, et il n'y a aucune interruption pour
     changer cela. Mais par contre les port(s)
     d'Entr‚e/Sortie peuvent empˆcher le clignotement
     pour obtenir des couleurs de plaine intensit‚.
     Pour se faire vous devez utiliser la mˆme
     proc‚dure qu'avec les cartes EGA ou post‚rieur.
     Il se nom : 'SetBlink'.

    **** Tseng Labs 4000 HiColor, 32768 couleurs ****

   ş Les modes Tseng Labs 4000 HiColor, 32768 couleurs
     sont support‚ par le BIOS de ces cartes. Par
     cons‚quant la m‚thode courant est d'utiliser le
     BIOS.

   ş Il n'y a aucun fichier externe qui doit ˆtre
     appelle pour acc‚der … celui-ci. Les fonctions
     sont int‚grer par d‚faut lors de la compilation
     a l'aide de la commande '$DEFINE __TSENG4000__'.

	  **** BGI Super VGA, 256 Couleurs ****

   ş Lors du lancement du programme, le prompt DOS doit
     avoir ins‚r‚ (… l'aide de la commande SET) le
     r‚pertoire ou il pourra trouver les drivers Super
     VGA (exemple : SET BGI=\TP\BGI).

   ş Si vous voulez que les modes BGI soit supporter
     par l'unit‚ vous devez sp‚cifier le commande de
     compilation suivante 'DEFINE __BGI__';

   ş Attention de pas oublier qu'il n‚cessite les
     modules : BGI_TEXT, BGI_BOX, BGI_Mode et Graph.
}

Unit Text;

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

{$IFDEF __BGI__}
 {$DEFINE __MINIMIZECONST__}
{$ENDIF}

{$IFDEF __GRAPHDIRECT__}
 {$DEFINE __MINIMIZECONST__}
{$ENDIF}

{$IFDEF __GRAPHDIRECT__}
 {$DEFINE __GRAPH__}
{$ENDIF}

{$IFDEF __BGI__}
 {$DEFINE __GRAPH__}
{$ENDIF}

{$DEFINE __TSENG4000__}
{$DEFINE __VIDEO7VGA__}
{$DEFINE __EVEREXMICRO__}

(*********************************************************************)
			       INTERFACE
(*********************************************************************)

{$IFDEF __GRAPHDIRECT__}
 Uses DOS;
{$ENDIF}

 Const

       Mono            = 0;
       Color           = 1;

       ScrnDirect      = 0; { Pour les 100% compatibles }
       ScrnBIOS        = 1; { Pour les machines tournant sous DOS/Windows }
       ScrnANSI        = 2; { Pour les machines tournant sous DOS, mais incompatible }
       ScrnBGI         = 3; { Pour les modes graphiques }
       ScrnWindows     = 4; { Pour Windows seulement }
       ScrnGraphDirect = 5; { Pour les modes graphiques/gestionnaire Malte }

       Scan200         = 0; { CGA/EGA/MCGA/VGA/SVGA }
       Scan350         = 1; { EGA/MCGA/VGA/SVGA }
       Scan352         = 8; { SVGA }
       Scan364         = 9; { SVGA }
       Scan400         = 2; { VGA/SVGA }
       Scan480         = 3; { SVGA }
       Scan600         = 5; { SVGA }
       Scan768         = 6; { SVGA }

       HomeLine        = 0; { D‚signe le debut de la ligne }
       EndLine         = 255; { D‚signe la fin de la ligne }

        { AllStar Peacock VGA }

       AllStarVGA_CO40x25       = 1;
       AllStarVGA_CO80x25       = 3;
       AllStarVGA_Mono80x25     = 7;
       AllStarVGA_CO132x43      = $22;
       AllStarVGA_CO132x28      = $23;
       AllStarVGA_CO132x25      = $24;
       AllStarVGA_CO80x60       = $26;
       AllStarVGA_CO100x40      = $2A;

        { ATI EGA/VGA/VIP }

       ATIEGAWonder_CO40x25     = 1;
       ATIEGAWonder_CO80x25     = 3;
       ATIEGAWonder_Mono80x25   = 7;
       ATIEGAWonder_CO132x25    = $08;
       ATIEGAWonder_Mono132x25  = $27;
       ATIEGAWonder_CO132x44    = $33;
       ATIEGAWonder_Mono132x44  = $37;
       ATIEGAWonder_CO80x33     = $58;

       ATIVGAWonder_CO40x25     = 1;
       ATIVGAWonder_CO80x25     = 3;
       ATIVGAWonder_Mono80x25   = 7;
       ATIVGAWonder_Mono132x25  = $08;
       ATIVGAWonder_CO80x30     = $5B;

       ATIVIP_CO40x25           = 1;
       ATIVIP_CO80x25           = 3;
       ATIVIP_Mono80x25         = 7;
       ATIVIP_CO132x25          = $23;
       ATIVIP_Mono132x25        = $27;
       ATIVIP_CO132x44          = $33;
       ATIVIP_Mono132x44        = $37;
       ATIVIP_CO80x33           = $58;
       ATIVIP_CO80x66           = $59;

        { Color Graphics Adaptor }

       CGA_BW40x25              = 0;
       CGA_CO40x25              = 1;
       CGA_BW80x25              = 2;
       CGA_CO80x25              = 3;

        { Ahead System EGA2001 }

       EGA2001_CO40x25          = 1;
       EGA2001_CO80x25          = 3;
       EGA2001_Mono80x25        = 7;
       EGA2001_CO132x44         = $22;
       EGA2001_CO132x25         = $23;
       EGA2001_Mono132x25       = $50;
       EGA2001_Mono132x44       = $52;

        { Monochrome Display Adapter }

       MDA_Mono80x25            = 7;
       MDA_80x25                = MDA_Mono80x25;

        { Orchid VGA }

       OrchidVGA_CO40x25        = 1;
       OrchidVGA_CO80x25        = 3;
       OrchidVGA_CO132x44       = $22;
       OrchidVGA_CO132x28       = $23;
       OrchidVGA_CO132x25       = $24;
       OrchidVGA_CO80x60        = $26;
       OrchidVGA_CO100x40       = $2A;

        { Tatung VGA }

       TatungVGA_CO40x25        = 1;
       TatungVGA_CO80x25        = 3;
       TatungVGA_CO80x43        = $40;
       TatungVGA_CO132x25       = $41;
       TatungVGA_CO132x43       = $42;
       TatungVGA_CO80x60        = $43;
       TatungVGA_CO100x60       = $44;
       TatungVGA_CO132x28       = $45;

        { Tecmar VGA }

       TecmarVGA_CO40x25        = 1;
       TecmarVGA_CO80x25        = 3;
       TecmarVGA_CO132x25       = $17;
       TecmarVGA_CO80x43        = $40;

        { Tseng Labs/EVA }

       TsengEVA_CO40x25         = 1;
       TsengEVA_CO80x25         = 3;
       TsengEVA_Mono80x25       = 7;
       TsengEVA_Mono132x44      = $18;
       TsengEVA_Mono132x25      = $19;
       TsengEVA_Mono132x28      = $1A;
       TsengEVA_CO132x44        = $22;
       TsengEVA_CO132x25        = $23;
       TsengEVA_CO132x28        = $24;
       TsengEVA_CO80x60         = $26;

       {$IFDEF __TSENG4000__}

        Tseng4000_CO40x25       = 1;
        Tseng4000_CO80x25       = 3;
        Tseng4000_Mono80x25     = 7;
        Tseng4000_Mono132x44    = $18;
        Tseng4000_Mono132x25    = $19;
        Tseng4000_Mono132x28    = $1A;
        Tseng4000_CO132x44      = $22;
        Tseng4000_CO132x25      = $23;
        Tseng4000_CO132x28      = $24;
        Tseng4000_CO80x60       = $26;
        Tseng4000_CO100x40      = $2A;

       {$ENDIF}

        { VEGA VGA }

       VEGAVGA_CO40x25          = 1;
       VEGAVGA_CO80x25          = 3;
       VEGAVGA_CO120x25         = $4D;
       VEGAVGA_CO120x43         = $4E;
       VEGAVGA_CO132x25         = $4F;

        { Ahead B (Wizard 3270) }

       Wizard3270_CO40x25       = 1;
       Wizard3270_CO80x25       = 3;
       Wizard3270_CO160x50      = $2F;
       Wizard3270_CO80x34       = $32;
       Wizard3270_CO80x66       = $34;
       Wizard3270_CO132x28      = $51;

        { Model de Carte }

       _AllStarVGA          = 0;
       _ATI8514Ultra        = 1;
       _ATICGA              = 2;
       _ATICGASmallWonder   = _ATICGA;
       _ATIEGAWonder        = 3;
       _ATIGraphicsUltra    = 4;
       _ATIGraphicsUltraPro = 5;
       _ATIVGAWonder        = 6;
       _ATIVIP              = 7;
       _CGA                 = 8;
       _EGA                 = 9;
       _EGA2001             = 10;
       _GraphicsSolution    = _ATICGA;
       _Hercule             = 11;
       _IBM8514             = 12;
       _HGC                 = _Hercule;
       _MCGA                = 13;
       _MDA                 = 14;
       _OrchidVGA           = 15;
       _PC3270              = 16;
       _SVGA                = 17;
       _SuperVGA            = _SVGA;
       _TatungVGA           = 18;
       _TecmarVGA           = 19;
       _TsengEVA            = 20;
       _Tseng4000           = 21;
       _VEGAVGA             = 22;
       _VGA                 = 23;
       _VGATweaked          = 24;
       _Wizard3270          = 25;
       _Unknown             = $FF;

        { Malte System/Mode }

       _40x25       = 0;
       _40x28       = 1;
       _40x30       = 2;
       _40x34       = 3;
       _40x43       = 4;
       _40x50       = 5;
       _80x25       = 6;
       _80x28       = 7;
       _80x30       = 8;
       _80x33       = 9;
       _80x34       = 10;
       _80x43       = 11;
       _80x50       = 12;
       _80x60       = 13;
       _80x66       = 14;
       _100x37      = 15;
       _100x40      = 16;
       _100x50      = 17;
       _100x60      = 18;
       _100x66      = 19;
       _100x75      = 20;
       _120x25      = 21;
       _120x43      = 22;
       _132x25      = 23;
       _132x28      = 24;
       _132x43      = 25;
       _132x44      = 26;
       _132x60      = 27;
       _160x50      = 28;

 Type

       BorderType = Array[0..7] of Char;

 Var

       VC : Record
             Border      : BorderType;
	     Memory      : LongInt;
	     TypeMode    : Byte;
	     BitPerPixel : Byte;
	     Methode     : Byte;
	     Graph       : Boolean;
	     Color       : Word;
	     Blink       : Boolean;
	     Mode        : Byte;
	     Line        : Byte;
	     Coln        : Word;
	     MaxLine     : Byte;
	     MaxColn     : Byte;
	     NumY        : Word;
	     NumX        : Word;
             RX,RY       : Byte;
             LastColor   : Byte;
             NorColor    : Byte;
	     EGA         : Boolean;
	     VGA         : Boolean;
             Card        : Byte;
             {$IFDEF __GRAPH__}
              SaveText   : Boolean;
             {$ENDIF}
	    End;

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _BarSelectHori(X1,Y,X2:Byte);
 Procedure _BarSpaceHori(X1,Y,X2:Byte);
 Procedure _BarSpaceVert(X,Y1,Y2:Byte);
 Procedure _BarTextHori(X1,Y,X2:Byte;Chr:Char);
 Procedure _BarTextVert(X,Y1,Y2:Byte;Chr:Char);
 Procedure _CenterText(Y:Byte;Chn:String);
 Procedure _ClearLine(Y:Byte;Chr:Char);
 Procedure _ClearLineAs(Y,X2:Byte;Chr:Char);
 Procedure _ClearLineSpc(Y:Byte);
 Procedure _ClearColumns(X:Byte;Chr:Char);
 Procedure _ClearWindow(X1,Y1,X2,Y2:Byte);
 Procedure _FillBox(X1,Y1,X2,Y2:Byte;Chr:Char);
 Procedure _PutEmptyBorder(X1,Y1,X2,Y2:Byte);
 Procedure _SetAttr(X,Y:Byte);
 Procedure _SetCube(X,Y:Byte;Chr:Char);
 Procedure _SetFillBorder(X1,Y1,X2,Y2:Byte);
 Procedure _SetSpace(X,Y:Byte);
 Procedure _SetVideoModeText(Mode:ShortInt);
 Procedure _WriteText(X,Y:Byte;Chn:String);
 Procedure _WriteTyping(Chn:String);
 Procedure BarCharHori(X1,Y,X2:Byte;Chr:Char);
 Procedure BarCharVert(X,Y1,Y2:Byte;Chr:Char);
 Procedure BarSelectHori(X1,Y,X2,Color:Byte);
 Procedure BarSelectVert(X,Y1,Y2,Color:Byte);
 Procedure BarSpaceHori(X1,Y,X2,Color:Byte);
 Procedure BarSpaceVert(X,Y1,Y2,Color:Byte);
 Procedure BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
 Procedure BarTextVert(X,Y1,Y2:Byte;Chr:Char;Color:Byte);
 Procedure CenterText(Y:Byte;Chn:String;Color:Byte);
 Procedure ClearColumns(X:Byte;Chr:Char;Color:Byte);
 Procedure ClearLine(Y:Byte;Chr:Char;Color:Byte);
 Procedure ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte);
 Procedure ClearLineSpc(Y,Color:Byte);
 Procedure ClearLineUncolor(Y:Byte;Chr:Char);
 Procedure ClearScreen(Color:Byte);
 Procedure ClearWindow(X1,Y1,X2,Y2,Color:Byte);
 Procedure CloseCursor;
 Procedure DoneVideo;
 Procedure FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
 Procedure FullCursor;
 Procedure GetPos(Var X,Y:Byte);
 Procedure InitVideo;
 Procedure MoveTextDown(X1,Y1,X2,Y2:Byte);
 Procedure MoveTextUp(X1,Y1,X2,Y2:Byte);
 Procedure MoveUp(X1,Y1,X2,Y2:Byte);
 Procedure PutBorderUncolor(X1,Y1,X2,Y2:Byte);
 Procedure PutBox(X1,Y1,X2,Y2:Byte;Var Buffer);
 Procedure PutEmptyBorder(X1,Y1,X2,Y2,Color:Byte);
 Procedure PutFillBorder(X1,Y1,X2,Y2,Color:Byte);
 Procedure PutPixel(X,Y:Word;Color:Byte);
 Procedure SaveBox(X1,Y1,X2,Y2:Byte;Var Buffer);
 Procedure ScrollDown_(X1,Y1,X2,Y2,Color:Byte);
 Procedure ScrollUp_(X1,Y1,X2,Y2,Color:Byte);
 Procedure SetAllColor(Last,New:Byte);
 Procedure SetAttr(X,Y,Color:Byte);
 Procedure SetBlink(Etat:Boolean);
 Procedure SetBorderFormat(Format:BorderType);
 Procedure SetBorderShade(Etat:Boolean);
 Procedure SetBorderSimple_;
 Procedure SetBorderSpace(Etat:Boolean);
 Procedure SetBorderSpace_;
 Procedure SetChar(X,Y:Byte;Chr:Char);
 Procedure SetColor(Color:Byte);
 Procedure SetCube(X,Y:Byte;Chr:Char;Color:Byte);
 Procedure SetCursor(Start,Finish:Byte);
 Procedure SetMatrix(Palette:Byte;Start,Number:Word;Height:Byte;Var Buffer);
 Procedure SetMode(Mode,TypeMode:Byte);
 Procedure SetPaletteRGB(Registre:Word;Red,Green,Blue:Byte);
 Procedure SetPos(X,Y:Byte);
 Procedure SetPosCursor(X,Y:Byte);
 Procedure SetScanLine(Format:Byte);
 Procedure SetSpace(X,Y,Color:Byte);
 Procedure SetVideoMethode(Mode:Byte);
 {$IFDEF __EVEREXMICRO__}
  Procedure SetVideoModeEverexMicro(Mode:Byte);
 {$ENDIF}
 Procedure SetVideoModeText(Mode:ShortInt);
 {$IFDEF __TSENG4000__}
  Procedure SetVideoModeTsengLabs4000(Mode:Byte);
 {$ENDIF}
 {$IFDEF __VIDEO7VGA__}
  Procedure SetVideoModeVideo7VGA(Mode:Byte);
 {$ENDIF}
 Procedure SwitchColor;
 Procedure WriteAs(X,Y:Byte;Chn:String;Color:Byte;Stop:Char);
 Procedure WriteOnlyColor(X,Y:Byte;Chn:String;Color:Byte);
 Procedure WriteOnlyColorAnd(X,Y:Byte;Chn:String;Num,Color:Byte);
 Procedure WriteText(X,Y:Byte;Chn:String;Color:Byte);
 Procedure WriteTypingXY(X,Y:Byte;Chn:String);
 Procedure WriteTypingXYBicolor(X,Y:Byte;Chn:String;LastColor,NewColor:Byte);
 Procedure WriteToAs(X,Y:Byte;Chn:String;Pos,Color:Byte;Stop:Char);
 Procedure WriteUncolor(X,Y:Byte;Chn:String);
 Procedure WriteUncolorAs(X,Y:Byte;Chn:String;Stop:Char);
 Procedure WriteUncolorToAs(X,Y:Byte;Chn:String;Pos:Byte;Stop:Char);

 Function DirectTextDetect:Boolean;
 Function GetBlink:Boolean;
 Function GetCharXY(X,Y:Byte):Char;
 Function GetColor:Byte;
 Function GetHeightChar:Byte;
 Function GetLastColor:Byte;
 Function GetMaxX:Byte;
 Function GetMaxY:Byte;
 Function GetPixel(X,Y:Word):Byte;
 Function GetSizeBox(X1,Y1,X2,Y2:Byte):LongInt;
 Function GetSizeBIOSVideo:LongInt;
 Function GetSizeBufferVideo:LongInt;
 Function GetSizeMaterialVideo:LongInt;
 Function GetSizeRegistersVideo:LongInt;
 Function GetVideoMethode:Byte;
 Function GetVideoMode:Byte;
 Function IsEGA:Boolean;
 Function IsGraphic:Boolean;
 Function IsVGA:Boolean;
 Function RestoreBIOSVideo(Var Buffer):Boolean;
 Function RestoreBufferVideo(Var Buffer):Boolean;
 Function RestoreMaterialVideo(Var Buffer):Boolean;
 Function RestoreRegistersVideo(Var Buffer):Boolean;
 Function SaveBIOSVideo(Var Buffer):Boolean;
 Function SaveBufferVideo(Var Buffer):Boolean;
 Function SaveMaterialVideo(Var Buffer):Boolean;
 Function SaveRegistersVideo(Var Buffer):Boolean;

{$ENDIF}

(*********************************************************************)
			    IMPLEMENTATION
(*********************************************************************)

{$IFDEF __DRIVERVIDEO__}

 Uses MVTxtDrv;

{$ELSE}

 Uses

      {$IFDEF __BGI__}
       Graph,     { Unit‚ de gestion des op‚rations vid‚o, basser sur
                    le standard BGI (Borland Graphics Interface). }
       BGI_BOX,   { Module de gestion de op‚ration de boite. }
       BGI_TEXT,  { Module d'affiche de caractŠre … l'‚cran }
       BGI_MODE,  { Module de compatibilit‚ de mode vid‚o. }
      {$ENDIF}

      {$IFDEF __GRAPHDIRECT__}
       DirectGraphic, { Unit‚ de gestion des op‚rations vid‚o, basser
                        sur les modes graphiques du Malte System. }
       DirectGT,  { (Directe Graphique Texte) Emulateur texte basser
                    sur le Malte System. }
       DSRM,
      {$ELSE}
       DOS,       { Unit‚ de gestion des op‚rations du DOS. }
      {$ENDIF}
      BiosText,   { Unit‚ de gestion des op‚rations vid‚o selon les
                    standards du BIOS (Normal/EGA/VGA et PS/2) }
      DirecTxt,   { Unit‚ de gestion d'affichage direct. }
      NumDirGr,   { Module de calcul graphique. }
      Numeric;    { Module des op‚rations num‚rique g‚n‚rale. }

{$ENDIF}

{$IFNDEF __ISDRIVERVIDEO__}

 Function GetDefaultColor:Word; Forward;

{$ENDIF}

 Const

       {$IFNDEF __DRIVERVIDEO__}
        BorderSimple : BorderType = 'ÚÄ¿³³ÀÄÙ';
       {$ENDIF}

       vidMaterial  = 1;
       vidBIOS      = 2;
       vidRegisters = 4;

       TatungVGACO : Array[0..28] of Byte = (
                      TatungVGA_CO40x25,   {  0 }
                      $FF,                 {  1 }
                      $FF,                 {  2 }
                      $FF,                 {  3 }
                      $FF,                 {  4 }
                      $FF,                 {  5 }
                      TatungVGA_CO80x25,   {  6 }
                      $FF,                 {  7 }
                      $FF,                 {  8 }
                      $FF,                 {  9 }
                      $FF,                 { 10 }
                      TatungVGA_CO80x43,   { 11 }
                      $FF,                 { 12 }
                      TatungVGA_CO80x60,   { 13 }
                      $FF,                 { 14 }
                      $FF,                 { 15 }
                      $FF,                 { 16 }
                      $FF,                 { 17 }
                      TatungVGA_CO100x60,  { 18 }
                      $FF,                 { 19 }
                      $FF,                 { 20 }
                      $FF,                 { 21 }
                      $FF,                 { 22 }
                      TatungVGA_CO132x25,  { 23 }
                      TatungVGA_CO132x28,  { 24 }
                      TatungVGA_CO132x43,  { 25 }
                      $FF,                 { 26 }
                      $FF,                 { 27 }
                      $FF                  { 28 }
                     );

       Tseng4000CO : Array[0..28] of Byte = (
                      Tseng4000_CO40x25,   {  0 }
                      $FF,                 {  1 }
                      $FF,                 {  2 }
                      $FF,                 {  3 }
                      $FF,                 {  4 }
                      $FF,                 {  5 }
                      Tseng4000_CO80x25,   {  6 }
                      $FF,                 {  7 }
                      $FF,                 {  8 }
                      $FF,                 {  9 }
                      $FF,                 { 10 }
                      $FF,                 { 11 }
                      $FF,                 { 12 }
                      Tseng4000_CO80x60,   { 13 }
                      $FF,                 { 14 }
                      $FF,                 { 15 }
                      Tseng4000_CO100x40,  { 16 }
                      $FF,                 { 17 }
                      $FF,                 { 18 }
                      $FF,                 { 19 }
                      $FF,                 { 20 }
                      $FF,                 { 21 }
                      $FF,                 { 22 }
                      Tseng4000_CO132x25,  { 23 }
                      Tseng4000_CO132x28,  { 24 }
                      $FF,                 { 25 }
                      Tseng4000_CO132x44,  { 26 }
                      $FF,                 { 27 }
                      $FF                  { 28 }
                     );

       Tseng4000Mono : Array[0..28] of Byte = (
                        $FF,                   {  0 }
                        $FF,                   {  1 }
                        $FF,                   {  2 }
                        $FF,                   {  3 }
                        $FF,                   {  4 }
                        $FF,                   {  5 }
                        Tseng4000_Mono80x25,   {  6 }
                        $FF,                   {  7 }
                        $FF,                   {  8 }
                        $FF,                   {  9 }
                        $FF,                   { 10 }
                        $FF,                   { 11 }
                        $FF,                   { 12 }
                        $FF,                   { 13 }
                        $FF,                   { 14 }
                        $FF,                   { 15 }
                        $FF,                   { 16 }
                        $FF,                   { 17 }
                        $FF,                   { 18 }
                        $FF,                   { 19 }
                        $FF,                   { 20 }
                        $FF,                   { 21 }
                        $FF,                   { 22 }
                        Tseng4000_Mono132x25,  { 23 }
                        Tseng4000_Mono132x28,  { 24 }
                        $FF,                   { 25 }
                        Tseng4000_Mono132x44,  { 26 }
                        $FF,                   { 27 }
                        $FF                    { 28 }
                       );

       TsengEVACO : Array[0..28] of Byte = (
                     TsengEVA_CO40x25,   {  0 }
                     $FF,                {  1 }
                     $FF,                {  2 }
                     $FF,                {  3 }
                     $FF,                {  4 }
                     $FF,                {  5 }
                     TsengEVA_CO80x25,   {  6 }
                     $FF,                {  7 }
                     $FF,                {  8 }
                     $FF,                {  9 }
                     $FF,                { 10 }
                     $FF,                { 11 }
                     $FF,                { 12 }
                     TsengEVA_CO80x60,   { 13 }
                     $FF,                { 14 }
                     $FF,                { 15 }
                     $FF,                { 16 }
                     $FF,                { 17 }
                     $FF,                { 18 }
                     $FF,                { 19 }
                     $FF,                { 20 }
                     $FF,                { 21 }
                     $FF,                { 22 }
                     TsengEVA_CO132x25,  { 23 }
                     TsengEVA_CO132x28,  { 24 }
                     $FF,                { 25 }
                     TsengEVA_CO132x44,  { 26 }
                     $FF,                { 27 }
                     $FF                 { 28 }
                    );

       TsengEVAMono : Array[0..28] of Byte = (
                       $FF,                  {  0 }
                       $FF,                  {  1 }
                       $FF,                  {  2 }
                       $FF,                  {  3 }
                       $FF,                  {  4 }
                       $FF,                  {  5 }
                       TsengEVA_Mono80x25,   {  6 }
                       $FF,                  {  7 }
                       $FF,                  {  8 }
                       $FF,                  {  9 }
                       $FF,                  { 10 }
                       $FF,                  { 11 }
                       $FF,                  { 12 }
                       $FF,                  { 13 }
                       $FF,                  { 14 }
                       $FF,                  { 15 }
                       $FF,                  { 16 }
                       $FF,                  { 17 }
                       $FF,                  { 18 }
                       $FF,                  { 19 }
                       $FF,                  { 20 }
                       $FF,                  { 21 }
                       $FF,                  { 22 }
                       TsengEVA_Mono132x25,  { 23 }
                       TsengEVA_Mono132x28,  { 24 }
                       $FF,                  { 25 }
                       TsengEVA_Mono132x44,  { 26 }
                       $FF,                  { 27 }
                       $FF                   { 28 }
                      );

Var

    Card  : Byte; { Le type de carte vid‚o. }

{$I GRAPHIX.INC  }
{$I BSGSZVID.INC } { BIOS_GetSizeVideo }

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       PutPixel                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure PutPixel(X,Y:Word;Color:Byte);
 Begin
  {$IFDEF __GRAPH__}
  Case VC.Methode of
  {$IFDEF __GRAPHDIRECT__}
   ScrnGraphDirect : DirectGraphic.PutPixel(X,Y,Color);
  {$ENDIF}
          {$IFDEF __BGI__}
           ScrnBGI : Graph.PutPixel(X,Y,Color);
          {$ENDIF}
                Else
  {$ENDIF}
                BIOS_PutPixel(X,Y,Color);
  {$IFDEF __GRAPH__}
   End;
  {$ENDIF}
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetPixel                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function GetPixel(X,Y:Word):Byte;
 Begin
  {$IFDEF __GRAPH__}
   Case VC.Methode of
  {$IFDEF __GRAPHDIRECT__}
   ScrnGraphDirect : GetPixel := DirectGraphic.GetPixel(X,Y);
  {$ENDIF}
  {$IFDEF __BGI__}
    ScrnBGI : GetPixel := Graph.GetPixel(X,Y)
  {$ENDIF}
   Else
  {$ENDIF}
  GetPixel := BIOS_GetPixel(X,Y);
  {$IFDEF __GRAPH__}
   End;
  {$ENDIF}
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     SetVideoMode                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure SetMode(Mode,TypeMode:Byte);
 Begin
  Case TypeMode of
    Mono : Case Card of
            _Tseng4000 : SetVideoModeText(Tseng4000Mono[Mode]);
             _TsengEVA : SetVideoModeText(TsengEVAMono[Mode]);
           End;
   Color : Case Card of
            _TatungVGA : SetVideoModeText(TatungVGACO[Mode]);
            _Tseng4000 : SetVideoModeText(Tseng4000CO[Mode]);
             _TsengEVA : SetVideoModeText(TsengEVACO[Mode]);
           End;
  End;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     _CenterText                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   Syntaxe :

    Procedure _CenterText(Y:Byte;Chn:String);

   D‚finition :

    ş Cette proc‚dure centre un texte au milieu d'une
      ligne Y avec la couleur courant.

   Note :

    ş Cette proc‚dure d‚pend exclusivement de la
      proc‚dure CenterText. R‚f‚rence : Unit‚ texte
      (Text) de Malte System.
 }

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _CenterText(Y:Byte;Chn:String);
 Begin
  CenterText(Y,Chn,VC.NorColor);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     SetAllColor                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   Syntaxe :

    Procedure SetAllColor(Last,New:Byte);

   D‚finition :

    ş Cette proc‚dure change l'ancienne couleur (Last)
      et la couleur courant (New).

   Note :

    ş La proc‚dure SetColor ajuste la couleur courant
      dans l'ancienne couleur et met la couleur courant
      … la valeur d‚sign‚.
 }

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure SetAllColor(Last,New:Byte);
 Begin
  SetColor(Last);
  SetColor(New);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MoveTextUp                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   Syntaxe :

    Procedure MoveTextUp(X1,Y1,X2,Y2:Byte);

   D‚finition :

    ş Cette proc‚dure d‚place l'‚cran d'un ligne de bas
      vers le haut.

   Notes :

    ş La variable VC.Methode d‚finit la m‚thode de gestion
      de l'‚cran (Direct, BIOS, ANSI, BGI, ...).

    ş La proc‚dure MEM_MoveTextUp d‚place l'‚cran d'un ligne
      de bas vers le haut en utilisant la m‚thode direct.

    ş La proc‚dure BIOS_MoveTextUp d‚place l'‚cran d'un ligne
      de bas vers le haut en utilisant la m‚thode BIOS.
 }

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure MoveTextUp(X1,Y1,X2,Y2:Byte);
  Begin
   MVTxtDrv.MoveTextUp(X1,Y1,X2,Y2);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure MoveTextUp(X1,Y1,X2,Y2:Byte);
   Begin
    Case VC.Methode of
     {$IFDEF __GRAPH__}
      {$IFDEF __GRAPHDIRECT__}
       ScrnGraphDirect : Exit;
      {$ENDIF}
              {$IFDEF __BGI__}
               ScrnBGI : Exit;
              {$ENDIF}
      {$ENDIF}
           ScrnDirect : MEM_MoveTextUp(X1,Y1,X2,Y2)
  	          Else BIOS_MoveTextUp(X1,Y1,X2,Y2);
    End;
   End;

  {$ELSE}

   Procedure MoveTextUp(X1,Y1,X2,Y2:Byte);
   Type PMoveTextUp = Procedure(X1,Y1,X2,Y2:Byte);
   Const CMoveTextUp : Array[ScrnDirect..ScrnBIOS] of PMoveTextUp =
                       (MEM_MoveTextUp,BIOS_MoveTextUp);
   Begin
    CMoveTextUp[VC.Methode](X1,Y1,X2,Y2);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        MoveUp                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure MoveUp(X1,Y1,X2,Y2:Byte);
  Begin
   MVTxtDrv.MoveUp(X1,Y1,X2,Y2);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure MoveUp(X1,Y1,X2,Y2:Byte);
   Begin
    Case VC.Methode of
     {$IFDEF __GRAPH__}
      {$IFDEF __GRAPHDIRECT__}
       ScrnGraphDirect : Exit;
      {$ENDIF}
              {$IFDEF __BGI__}
               ScrnBGI : Exit;
              {$ENDIF}
     {$ENDIF}
           ScrnDirect : MEM_MoveUp(X1,Y1,X2,Y2)
  		  Else BIOS_MoveTextUp(X1,Y1,X2,Y2);
    End;
   End;

  {$ELSE}

   Procedure MoveUp(X1,Y1,X2,Y2:Byte);
   Type PMoveUp = Procedure(X1,Y1,X2,Y2:Byte);
   Const CMoveUp : Array[ScrnDirect..ScrnBIOS] of PMoveUp =
                       (MEM_MoveUp,BIOS_MoveTextUp);
   Begin
    CMoveUp[VC.Methode](X1,Y1,X2,Y2);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MoveTextDown                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   Syntaxe :

    Procedure MoveTextDown(X1,Y1,X2,Y2:Byte);

   D‚finition :

    ş Cette proc‚dure d‚place l'‚cran d'un ligne de haut
      vers le bas.

   Notes :

    ş La variable VC.Methode d‚finit la m‚thode de gestion
      de l'‚cran (Direct, BIOS, ANSI, BGI, ...).

    ş La proc‚dure MEM_MoveTextDown d‚place l'‚cran d'un ligne
      de haut vers le bas en utilisant la m‚thode direct.

    ş La proc‚dure BIOS_MoveTextDown d‚place l'‚cran d'un ligne
      de haut vers le bas en utilisant la m‚thode BIOS.
 }

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure MoveTextDown(X1,Y1,X2,Y2:Byte);
  Begin
   MVTxtDrv.MoveTextDown(X1,Y1,X2,Y2);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure MoveTextDown(X1,Y1,X2,Y2:Byte);
   Begin
    Case VC.Methode of
     {$IFDEF __GRAPH__}
      {$IFDEF __GRAPHDIRECT__}
       ScrnGraphDirect : Exit;
      {$ENDIF}
              {$IFDEF __BGI__}
               ScrnBGI : Exit;
              {$ENDIF}
     {$ENDIF}
            ScrnDirect : MEM_MoveTextDown(X1,Y1,X2,Y2)
                    Else BIOS_MoveTextDown(X1,Y1,X2,Y2);
    End;
   End;

  {$ELSE}

   Procedure MoveTextDown(X1,Y1,X2,Y2:Byte);
   Type PMoveTextDown = Procedure(X1,Y1,X2,Y2:Byte);
   Const CMoveTextDown : Array[ScrnDirect..ScrnBIOS] of PMoveTextDown =
                         (MEM_MoveTextUp,BIOS_MoveTextUp);
   Begin
    CMoveTextDown[ScrnDirect](X1,Y1,X2,Y2);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SetParamVideo                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   Syntaxe :

    Procedure SetParamVideo;

   D‚finition :

    ş Cette proc‚dure ajuste les paramŠtres vid‚o correspondant
      … la m‚thode utilis‚.

   Note :

    ş La variable VC.Methode d‚finit la m‚thode de gestion
      de l'‚cran (Direct, BIOS, ANSI, BGI, ...).
 }

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

 {$ELSE}

  Procedure SetParamVideo;
  Begin
   Case VC.Methode of
    {$IFDEF __GRAPHDIRECT__}
     ScrnGraphDirect : Begin
                        VC.Coln     := DirectGT.GetMaxX + 1;
                        VC.MaxColn  := DirectGT.GetMaxX;
                        VC.Line     := DirectGT.GetMaxY + 1;
                        VC.MaxLine  := DirectGT.GetMaxY;
                        VC.Color    := 256;
                        VC.TypeMode := Color;
                        VC.Mode     := DirectGraphic.GetVideoMode;
                        VC.Blink    := False;
                        VC.Graph    := True;
                        VC.NumX     := DirectGraphic.GetMaxX + 1;
                        VC.NumY     := DirectGraphic.GetMaxY + 1;
                        Exit;
                       End;
    {$ENDIF}
    {$IFDEF __BGI__}
             ScrnBGI : Begin
                        VC.Coln     := BGI_TEXT.TextMaxX + 1;
                        VC.MaxColn  := VC.Coln - 1;
                        VC.Line     := BGI_TEXT.TextMaxY + 1;
                        VC.MaxLine  := VC.Line - 1;
                        VC.Color    := 256;
                        VC.TypeMode := Color;
                        VC.Mode     := BGI_MODE.GetVideoMode;
                        VC.Blink    := False;
                        VC.Graph    := True;
                        Exit;
                       End;
    {$ENDIF}
          ScrnDirect : Begin
                        VC.NorColor  := 7;
                        VC.LastColor := 15;
                        VC.RX        := 0;
                        VC.RY        := 0;
                        VC.Coln      := VD.Coln;
                        VC.Line      := VD.Line;
                        VC.MaxColn   := VD.MaxX;
                        VC.MaxLine   := VD.MaxY;
                        VC.Blink     := False;
                        VC.TypeMode  := Byte(MEM_PortVideo = $3D4);
                        VC.Mode      := MEM_GetVideoMode;
                        VC.Color     := 0;
                        If(BIOS_Info_)Then
                        Begin
                         VC.Blink    := BIOS_GetBlink;
                         VC.Color    := BIOS_GetNumColor;
                         If((VC.Color = 0)and(VC.Blink))Then VC.Color := 4;
                        End
                         else
                        VC.Color     := GetDefaultColor;
                       End;
                  Else Begin
                        VC.NorColor  := 7;
                        VC.LastColor := 15;
                        VC.Coln      := VB.Coln;
                        VC.Line      := VB.Line;
                        VC.MaxColn   := VB.MaxX;
                        VC.MaxLine   := VB.MaxY;
                        MEM_InitVideo;
                        VC.RX        := 0;
                        VC.RY        := 0;
                        VC.TypeMode  := Byte(MEM_PortVideo = $3D4);
                        VC.Mode      := BIOS_GetVideoMode;
                        VC.Color     := 0;
                        If(BIOS_Info_)Then
                        Begin
                         VC.Blink     := BIOS_GetBlink;
                         VC.Color     := BIOS_GetNumColor;
                         If((VC.Color = 0)and(VC.Blink))Then VC.Color := 4;
                        End
                         else
                        VC.Color      := GetDefaultColor;
                       End;
   End;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   GetDefaultColor                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   Syntaxe :

    Function GetDefaultColor:Word;

   D‚finition :

    ş Cette fonction retourne le nombre de couleur maximal
      disponible pour ce mode vid‚o.

   Note :

    ş Il ajuste ‚galement les variables apropri‚s par …
      port au mode courant.
 }

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

 {$ELSE}

  Function GetDefaultColor:Word;

   Procedure SetGraphParam;
   Begin
    VC.Blink := False;
    VC.Graph := True;
   End;

  Begin
   Case VC.Mode of
    0..3 : Begin
 	    VC.Blink        := True;
            VC.Graph        := False;
  	    GetDefaultColor := 16;
 	    Exit;
  	   End;
    4..6 : Begin
	    VC.Blink        := False;
            VC.Graph        := True;
            GetDefaultColor := (Byte((VC.Mode or 1) = 5) * 2) + 2;
	    Exit;
	   End;
       7 : Begin
 	    VC.Blink        := True;
            VC.Graph        := False;
 	    GetDefaultColor := 4;
	    Exit;
	   End;
   End;
   If(VC.EGA)or(VC.VGA)Then
   Begin
    Case VC.Mode of
     0..17 : Begin
              SetGraphParam;
 	      Case VC.Mode of
 	       13,14 : GetDefaultColor := 16;
	       15,17 : GetDefaultColor := 2;
	 	  10 : GetDefaultColor := (Byte(VC.Memory <> $10000) * 12) + 4;
	      End;
	      Exit;
	     End;
        12 : Begin
	      If(VC.VGA)Then
	      Begin
               SetGraphParam;
	       GetDefaultColor := 16;
	       Exit;
	      End;
	     End;
        19 : Begin
              SetGraphParam;
	      GetDefaultColor := 256;
	      Exit;
	     End;
    End;
   End;
   VC.Graph        := IsGraphic;
   GetDefaultColor := Byte(VC.Graph) * 16;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   _BarSelectHori                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _BarSelectHori(X1,Y,X2:Byte);
 Begin
  BarSelectHori(X1,Y,X2,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   _BarSpaceHori                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _BarSpaceHori(X1,Y,X2:Byte);
 Begin
  BarSpaceHori(X1,Y,X2,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   _BarSpaceVert                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _BarSpaceVert(X,Y1,Y2:Byte);
 Begin
  BarSpaceVert(X,Y1,Y2,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    _BarTextHori                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _BarTextHori(X1,Y,X2:Byte;Chr:Char);
 Begin
  BarTextHori(X1,Y,X2,Chr,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    _BarTextVert                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _BarTextVert(X,Y1,Y2:Byte;Chr:Char);
 Begin
  BarTextVert(X,Y1,Y2,Chr,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     _ClearLine                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _ClearLine(Y:Byte;Chr:Char);
 Begin
  ClearLine(Y,Chr,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    _ClearLineAs                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _ClearLineAs(Y,X2:Byte;Chr:Char);
 Begin
  ClearLineAs(Y,X2,Chr,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    _ClearColumns                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _ClearColumns(X:Byte;Chr:Char);
 Begin
  ClearColumns(X,Chr,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    _ClearLineSpc                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _ClearLineSpc(Y:Byte);
 Begin
  ClearLineSpc(Y,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    _ClearWindow                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _ClearWindow(X1,Y1,X2,Y2:Byte);
 Begin
  ClearWindow(X1,Y1,X2,Y2,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      _FillBox                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _FillBox(X1,Y1,X2,Y2:Byte;Chr:Char);
 Begin
  FillBox(X1,Y1,X2,Y2,Chr,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   _PutEmptyBorder                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _PutEmptyBorder(X1,Y1,X2,Y2:Byte);
 Begin
  PutEmptyBorder(X1,Y1,X2,Y2,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       _SetAttr                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _SetAttr(X,Y:Byte);
 Begin
  SetAttr(X,Y,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       _SetCube                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _SetCube(X,Y:Byte;Chr:Char);
 Begin
  SetCube(X,Y,Chr,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     _SetFillBorder                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _SetFillBorder(X1,Y1,X2,Y2:Byte);
 Begin
  PutFillBorder(X1,Y1,X2,Y2,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      _SetSpace                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _SetSpace(X,Y:Byte);
 Begin
  SetSpace(X,Y,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    _SetVideoModeText                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure _SetVideoModeText(Mode:ShortInt);
  Begin
   MVTxtDrv.SetVideoMode(Mode);
  End;

 {$ELSE}

  Procedure _SetVideoModeText(Mode:ShortInt);
  Begin
   BIOS_SetVideoMode(Mode);
   MEM_InitVideo;
   BIOS_InitVideo;
   {$IFDEF __GRAPHDIRECT__}
    If(VC.Methode = ScrnGraphDirect)Then
    Begin
     WriteLn('Error : Function not supported with graphic!');
     Halt;
    End;
   {$ENDIF}
   VC.NorColor  := 7;
   VC.LastColor := 15;
   VC.RX := 0;
   VC.RY := 0;
   {$IFDEF __BGI__}
    If(VC.Methode = ScrnBGI)Then
    Begin
     VC.MaxColn := BGI_TEXT.TextMaxX;
     VC.Coln    := VC.MaxColn + 1;
     VC.MaxLine := BGI_TEXT.TextMaxY;
     VC.Line    := VC.MaxLine + 1;
     VC.Mode    := BGI_MODE.GetVideoMode;
     VC.Color   := 256;
     VC.Blink   := False;
     Exit;
    End;
   {$ENDIF}
   VC.Color    := 0;
   VC.TypeMode := Byte(MEM_PortVideo = $3D4);
   If(VC.Methode = ScrnDirect)Then
   Begin
    VC.Coln    := VD.Coln;
    VC.MaxColn := VD.MaxX;
    VC.Line    := VD.Line;
    VC.MaxLine := VD.MaxY;
    VC.Mode    := MEM_GetVideoMode;
   End
    else
   Begin
    VC.Coln    := VB.Coln;
    VC.MaxColn := VB.MaxX;
    VC.Line    := VB.Line;
    VC.MaxLine := VB.MaxY;
    VC.Mode    := BIOS_GetVideoMode;
   End;
   If(BIOS_Info_)Then
   Begin
    VC.Color := BIOS_GetNumColor;
    VC.Blink := BIOS_GetBlink;
    VC.Graph := Not(VC.Blink);
    If((VC.Color = 0)and(VC.Blink))Then VC.Color := 4;
   End
    else
   VC.Color := GetDefaultColor;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      _WriteText                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure _WriteText(X,Y:Byte;Chn:String);
 Begin
  WriteText(X,Y,Chn,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      _WriteTyping                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure _WriteTyping(Chn:String);
  Begin
   MVTxtDrv._WriteTyping(Chn);
  End;

 {$ELSE}

  Procedure _WriteTyping(Chn:String);
  Begin
   Case VC.Methode of
        {$IFDEF __GRAPHDIRECT__}
 ScrnGraphDirect : DirectGT._WriteTyping(Chn);
        {$ENDIF}
        {$IFDEF __BGI__}
         ScrnBGI : BGI_TEXT._WriteTyping(Chn);
        {$ENDIF}
      ScrnDirect : MEM__WriteTyping(Chn);
              Else BIOS_WriteTyping_(Chn);
   End;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BarCharHori                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure BarCharHori(X1,Y,X2:Byte;Chr:Char);
  Begin
   MVTxtDrv.BarCharHori(X1,Y,X2,Chr);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure BarCharHori(X1,Y,X2:Byte;Chr:Char);
   Begin
    Case VC.Methode of
        {$IFDEF __GRAPHDIRECT__}
 ScrnGraphDirect : DirectGT.BarCharHori(X1,Y,X2,Chr);
        {$ENDIF}
        {$IFDEF __BGI__}
         ScrnBGI : BGI_TEXT.BarCharHori(X1,Y,X2,Chr);
        {$ENDIF}
      ScrnDirect : DirecTxt.MEM_BarCharHori(X1,Y,X2,Chr);
    	     Else BiosText.BIOS_BarCharHori(X1,Y,X2,Chr);
    End;
   End;

  {$ELSE}

   Procedure BarCharHori(X1,Y,X2:Byte;Chr:Char);
   Type PBarCharHori = Procedure(X1,Y,X2:Byte;Chr:Char);
   Const CBarCharHori : Array[ScrnDirect..ScrnBIOS] of PBarCharHori =
                        (DirecTxt.MEM_BarCharHori,BiosText.BIOS_BarCharHori);
   Begin
    CBarCharHori[VC.Methode](X1,Y,X2,Chr);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BarCharVert                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure BarCharVert(X,Y1,Y2,Chr);
  Begin
   MVTxtDrv.BarCharVert(X,Y1,Y2,Chr);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure BarCharVert(X,Y1,Y2:Byte;Chr:Char);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.BarCharVert(X,Y1,Y2,Chr);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.BarCharVert(X,Y1,Y2,Chr);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_BarCharVert(X,Y1,Y2,Chr);
               Else BiosText.BIOS_BarCharVert(X,Y1,Y2,Chr);
    End;
   End;

  {$ELSE}

   Procedure BarCharVert(X,Y1,Y2:Byte;Chr:Char);
   Type PBarCharVert = Procedure(X,Y1,Y2:Byte;Chr:Char);
   Const CBarCharVert : Array[ScrnDirect..ScrnBIOS] of PBarCharVert =
                        (DirecTxt.MEM_BarCharVert,BiosText.BIOS_BarCharVert);
   Begin
    CBarCharVert[VC.Methode](X,Y1,Y2,Chr);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BarSelectHori                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure BarSelectHori(X1,Y,X2,Color:Byte);
  Begin
   MVTxtDrv.BarSelectHori(X1,Y,X2,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure BarSelectHori(X1,Y,X2,Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.BarSelectHori(X1,Y,X2,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.BarSelectHori(X1,Y,X2,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_BarSelectHori(X1,Y,X2,Color);
               Else BiosText.BIOS_BarSelectHori(X1,Y,X2,Color);
    End;
   End;

  {$ELSE}

   Procedure BarSelectHori(X1,Y,X2,Color:Byte);
   Type PBarSelectHori = Procedure(X1,Y,X2:Byte;Color:Byte);
   Const CBarSelectHori : Array[ScrnDirect..ScrnBIOS] of PBarSelectHori =
                           (DirecTxt.MEM_BarSelectHori,
  			  BiosText.BIOS_BarSelectHori);
   Begin
    CBarSelectHori[VC.Methode](X1,Y,X2,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    BarSelectVert                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure BarSelectVert(X,Y1,Y2,Color:Byte);
  Begin
   MVTxtDrv.BarSelectVert(X,Y1,Y2,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure BarSelectVert(X,Y1,Y2,Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.BarSelectVert(X,Y1,Y2,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.BarSelectVert(X,Y1,Y2,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_BarSelectVert(X,Y1,Y2,Color);
               Else BiosText.BIOS_BarSelectVert(X,Y1,Y2,Color);
    End;
   End;

  {$ELSE}

   Procedure BarSelectVert(X,Y1,Y2,Color:Byte);
   Type PBarSelectVert = Procedure(X,Y1,Y2,Color:Byte);
   Const CBarSelectVert : Array[ScrnDirect..ScrnBIOS] of PBarSelectVert =
                          (DirecTxt.MEM_BarSelectVert,BiosText.BIOS_BarSelectVert);
   Begin
    CBarSelectVert[VC.Methode](X,Y1,Y2,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BarSpaceHori                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure BarSpaceHori(X1,Y,X2,Color:Byte);
  Begin
   MVTxtDrv.BarSpaceHori(X1,Y,X2,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure BarSpaceHori(X1,Y,X2,Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.BarSpaceHori(X1,Y,X2,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.BarSpaceHori(X1,Y,X2,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_BarSpaceHori(X1,Y,X2,Color);
  	     Else BiosText.BIOS_BarSpaceHori(X1,Y,X2,Color);
    End;
   End;

  {$ELSE}

   Procedure BarSpaceHori(X1,Y,X2,Color:Byte);
   Type PBarSpaceHori = Procedure(X1,Y,X2,Color:Byte);
   Const CBarSpaceHori : Array[ScrnDirect..ScrnBIOS] of PBarSpaceHori =
                         (DirecTxt.MEM_BarSpaceHori,BiosText.BIOS_BarSpaceHori);
   Begin
    CBarSpaceHori[VC.Methode](X1,Y,X2,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     BarSpaceVert                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure BarSpaceVert(X,Y1,Y2,Color:Byte);
  Begin
   MVTxtDrv.BarSpaceVert(X,Y1,Y2,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure BarSpaceVert(X,Y1,Y2,Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.BarSpaceVert(X,Y1,Y2,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.BarSpaceVert(X,Y1,Y2,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_BarSpaceVert(X,Y1,Y2,Color);
 	      Else BiosText.BIOS_BarSpaceVert(X,Y1,Y2,Color);
    End;
   End;

  {$ELSE}

   Procedure BarSpaceVert(X,Y1,Y2,Color:Byte);
   Type PBarSpaceVert = Procedure(X,Y1,Y2,Color:Byte);
   Const CBarSpaceVert : Array[ScrnDirect..ScrnBIOS] of PBarSpaceVert =
                         (DirecTxt.MEM_BarSpaceVert,BiosText.BIOS_BarSpaceVert);
   Begin
    CBarSpaceVert[VC.Methode](X,Y1,Y2,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BarTextHori                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
  Begin
   MVTxtDrv.BarTextHori(X1,Y,X2,Chr,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.BarTextHori(X1,Y,X2,Chr,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
           ScrnBGI : BGI_TEXT.BarTextHori(X1,Y,X2,Chr,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_BarTextHori(X1,Y,X2,Chr,Color);
               Else BiosText.BIOS_BarTextHori(X1,Y,X2,Chr,Color);
    End;
   End;

  {$ELSE}

   Procedure BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
   Type PBarTextHori = Procedure(X1,Y,X2:Byte;Chr:Char;Color:Byte);
   Const CBarTextHori : Array[ScrnDirect..ScrnBIOS] of PBarTextHori =
                        (DirecTxt.MEM_BarTextHori,
  		       BiosText.BIOS_BarTextHori);
   Begin
    CBarTextHori[VC.Methode](X1,Y,X2,Chr,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      BarTextVert                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure BarTextVert(X,Y1,Y2:Byte;Chr:Char;Color:Byte);
  Begin
   MVTxtDrv.BarTextVert(X,Y1,Y2,Chr,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure BarTextVert(X,Y1,Y2:Byte;Chr:Char;Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.BarTextVert(X,Y1,Y2,Chr,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.BarTextVert(X,Y1,Y2,Chr,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_BarTextVert(X,Y1,Y2,Chr,Color)
  	     Else BiosText.BIOS_BarTextVert(X,Y1,Y2,Chr,Color);
    End;
   End;

  {$ELSE}

   Procedure BarTextVert(X,Y1,Y2:Byte;Chr:Char;Color:Byte);
   Type PBarTextVert = Procedure(X,Y1,Y2:Byte;Chr:Char;Color:Byte);
   Const CBarTextVert : Array[ScrnDirect..ScrnBIOS] of PBarTextVert =
                        (DirecTxt.MEM_BarTextVert,BiosText.BIOS_BarTextVert);
   Begin
    CBarTextVert[VC.Methode](X,Y1,Y2,Chr,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      CenterText                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure CenterText(Y:Byte;Chn:String;Color:Byte);
  Begin
   MVTxtDrv.CenterText(Y,Chn,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure CenterText(Y:Byte;Chn:String;Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.CenterText(Y,Chn,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.CenterText(Y,Chn,Color);
          {$ENDIF}
       ScrnDirect : DirecTxt.MEM_CenterText(Y,Chn,Color);
  	       Else BiosText.BIOS_CenterText(Y,Chn,Color);
     End;
    End;

  {$ELSE}

   Procedure CenterText(Y:Byte;Chn:String;Color:Byte);
   Type PCenterText = Procedure(Y:Byte;Chn:String;Color:Byte);
   Const CCenterText : Array[ScrnDirect..ScrnBIOS] of PCenterText =
                       (DirecTxt.MEM_CenterText,BiosText.BIOS_CenterText);
   Begin
    CCenterText[VC.Methode](Y,Chn,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     ClearColumns                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure ClearColumns(X:Byte;Chr:Char;Color:Byte);
  Begin
   MVTxtDrv.ClearColumns(X,Chr,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure ClearColumns(X:Byte;Chr:Char;Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.ClearColumns(X,Chr,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.ClearColumns(X,Chr,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_ClearColumns(X,Chr,Color);
               Else BiosText.BIOS_ClearColumns(X,Chr,Color);
    End;
   End;

  {$ELSE}

   Procedure ClearColumns(X:Byte;Chr:Char;Color:Byte);
   Type PClearColumns = Procedure(X:Byte;Chr:Char;Color:Byte);
   Const CClearColumns : Array[ScrnDirect..ScrnBIOS] of PClearColumns =
                         (DirecTxt.MEM_ClearColumns,
    		          BiosText.BIOS_ClearColumns);
   Begin
    CClearColumns[VC.Methode](X,Chr,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       ClearLine                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure ClearLine(Y:Byte;Chr:Char;Color:Byte);
  Begin
   MVTxtDrv.ClearLine(Y,Chr,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure ClearLine(Y:Byte;Chr:Char;Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.ClearLine(Y,Chr,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.ClearLine(Y,Chr,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_ClearLine(Y,Chr,Color);
     	       Else BiosText.BIOS_ClearLine(Y,Chr,Color);
    End;
   End;

  {$ELSE}

   Procedure ClearLine(Y:Byte;Chr:Char;Color:Byte);
   Type PClearLine = Procedure(Y:Byte;Chr:Char;Color:Byte);
   Const CClearLine : Array[ScrnDirect..ScrnBIOS] of PClearLine =
                      (DirecTxt.MEM_ClearLine,BiosText.BIOS_ClearLine);
   Begin
    CClearLine[VC.Methode](Y,Chr,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      ClearLineAs                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte);
  Begin
   MVTxtDrv.ClearLineAs(Y,X2,Chr,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.ClearLineAs(Y,X2,Chr,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.ClearLineAs(Y,X2,Chr,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_ClearLineAs(Y,X2,Chr,Color);
  	       Else BiosText.BIOS_ClearLineAs(Y,X2,Chr,Color);
    End;
   End;

  {$ELSE}

   Procedure ClearLineAs(Y,X2:Byte;Chr:Char;Color:Byte);
   Type PClearLineAs = Procedure(Y,X2:Byte;Chr:Char;Color:Byte);
   Const CClearLineAs : Array[ScrnDirect..ScrnBIOS] of PClearLineAs =
                        (DirecTxt.MEM_ClearLineAs,BiosText.BIOS_ClearLineAs);
   Begin
    CClearLineAs[VC.Methode](Y,X2,Chr,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   ClearLineUnColor                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure ClearLineUncolor(Y:Byte;Chr:Char);
  Begin
   MVTxtDrv.ClearLineUncolor(Y,Chr);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure ClearLineUncolor(Y:Byte;Chr:Char);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.ClearLineUnColor(Y,Chr);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.ClearLineUnColor(Y,Chr);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_ClearLineUncolor(Y,Chr);
               Else BiosText.BIOS_ClearLineUncolor(Y,Chr);
    End;
   End;

  {$ELSE}

   Procedure ClearLineUncolor(Y:Byte;Chr:Char);
   Type PClearLineUncolor = Procedure(Y:Byte;Chr:Char);
   Const CClearLineUncolor : Array[ScrnDirect..ScrnBIOS] of
                              PClearLineUncolor =
                             (DirecTxt.MEM_ClearLineUncolor,
	  		      BiosText.BIOS_ClearLineUnColor);
   Begin
    CClearLineUnColor[VC.Methode](Y,Chr);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     ClearLineSpc                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure ClearLineSpc(Y,Color:Byte);
  Begin
   MVtxtDrv.ClearLineSpc(Y,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure ClearLineSpc(Y,Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.ClearLine(Y,' ',Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.ClearLineSpc(Y,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_ClearLineSpc(Y,Color)
               Else BiosText.BIOS_ClearLineSpc(Y,Color);
    End;
   End;

  {$ELSE}

   Procedure ClearLineSpc(Y,Color:Byte);
   Type PClearLineSpc = Procedure(Y,Color:Byte);
   Const CClearLineSpc : Array[ScrnDirect..ScrnBIOS] of PClearLineSpc =
                         (DirecTxt.MEM_ClearLineSpc,
  		          BiosText.BIOS_ClearLineSpc);
   Begin
    CClearLineSpc[VC.Methode](Y,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     ClearScreen                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure ClearScreen(Color:Byte);
  Begin
   MVTxtDrv.ClearScreen(Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure ClearScreen(Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.ClearScreen(Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.ClearScreen(Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_ClearScreen(Color);
               Else BiosText.BIOS_ClearScreen(Color);
    End;
   End;

  {$ELSE}

   Procedure ClearScreen(Color:Byte);
   Type PClearScreen = Procedure(Color:Byte);
   Const CClearScreen : Array[ScrnDirect..ScrnBIOS] of PClearScreen =
                        (DirecTxt.MEM_ClearScreen,BiosText.BIOS_ClearScreen);
   Begin
    CClearScreen[VC.Methode](Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     ClearWindow                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure ClearWindow(X1,Y1,X2,Y2,Color:Byte);
  Begin
   MVTxtDrv.ClearWindow(X1,Y1,X2,Y2,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure ClearWindow(X1,Y1,X2,Y2,Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.FillBox(X1,Y1,X2,Y2,' ',Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.ClearTextWindow(X1,Y1,X2,Y2,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_ClearWindow(X1,Y1,X2,Y2,Color);
     	     Else BiosText.BIOS_ClearWindow(X1,Y1,X2,Y2,Color);
    End;
   End;

  {$ELSE}

   Procedure ClearWindow(X1,Y1,X2,Y2,Color:Byte);
   Type PClearWindow = Procedure(X1,Y1,X2,Y2,Color:Byte);
   Const CClearWindow : Array[ScrnDirect..ScrnBIOS] of PClearWindow =
                        (DirecTxt.MEM_ClearWindow,BiosText.BIOS_ClearWindow);
   Begin
    CClearWindow[VC.Methode](X1,Y1,X2,Y2,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     CloseCursor                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure CloseCursor;
  Begin
   MVTxtDrv.CloseCursor;
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure CloseCursor;
   Begin
    Case VC.Methode of
       {$IFDEF __BGI__}
        ScrnBGI : Exit;
       {$ENDIF}
     ScrnDirect : DirecTxt.IO_CloseCursor;
             Else BiosText.BIOS_CloseCursor;
    End;
   End;

  {$ELSE}

   Procedure CloseCursor;
   Type PCloseCursor = Procedure;
   Const CCloseCursor : Array[ScrnDirect..ScrnBIOS] of PCloseCursor =
                       (DirecTxt.IO_CloseCursor,BiosText.BIOS_CloseCursor);
   Begin
    CCloseCursor[VC.Methode];
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      FullCursor                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure FullCursor;
  Begin
   MVTxtDrv.FullCursor;
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure FullCursor;
   Begin
    If(VC.Methode = ScrnDirect)Then IO_FullCursor
                               Else BIOs_FullCursor;
   End;

  {$ELSE}

   Procedure FullCursor;
   Type PFullCursor = Procedure;
   Const CFullCursor : Array[ScrnDirect..ScrnBIOS] of PFullCursor =
                       (DirecTxt.IO_FullCursor,BiosText.BIOS_FullCursor);
   Begin
    CFullCursor[VC.Methode];
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        FillBox                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure FillBox(X1,Y1,X2,Y2,Chr,Color);
  Begin
   MVTxtDrv.FillBox(X1,Y1,X2,Y2,Chr,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.FillBox(X1,Y1,X2,Y2,Chr,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.FillTextBox(X1,Y1,X2,Y2,Chr,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_FillBox(X1,Y1,X2,Y2,Chr,Color);
     	     Else BiosText.BIOS_FillBox(X1,Y1,X2,Y2,Chr,Color);
    End;
   End;

  {$ELSE}

   Procedure FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
   Type PFillBox = Procedure(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
   Const CFillBox : Array[ScrnDirect..ScrnBIOS] of PFillBox =
                    (DirecTxt.MEM_FillBox,BiosText.BIOS_FillBox);
   Begin
    CFillBox[VC.Methode](X1,Y1,X2,Y2,Chr,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetBlink                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function GetBlink:Boolean;
 Begin
  GetBlink := VC.Blink;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetColor                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function GetColor:Byte;
 Begin
  GetColor := VC.NorColor;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    GetHeightChar                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Function GetHeightChar:Byte;
  Begin
    GetHeightChar := MVTxtDrv.GetHeightChar;
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Function GetHeightChar:Byte;
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : GetHeightChar := DirectGT.GetHeightChar;
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : GetHeightChar := BGI_TEXT.GetHeightChar;
         {$ENDIF}
       ScrnDirect : GetHeightChar := DirecTxt.TextHeight;
               Else GetHeightChar := BiosText.BIOS_GetHeightChar;
    End;
   End;

  {$ELSE}

   Function GetHeightChar:Byte;
   Type PGetHeightChar = Function:Byte;
   Const CGetHeightChar : Array[ScrnDirect..ScrnBIOS] of PGetHeightChar =
                          (DirecTxt.TextHeight,BiosText.BIOS_GetHeightChar);
   Begin
    GetHeightChar := CGetHeightChar[VC.Methode];
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                    GetLastColor                      ³Û
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
  ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function GetLastColor:Byte;
 Begin
  GetLastColor := VC.LastColor;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetMaxX                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function GetMaxX:Byte;
 Begin
  GetMaxX := VC.MaxColn;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetMaxY                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function GetMaxY:Byte;
 Begin
  GetMaxY := VC.MaxLine;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetPos                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure GetPos(Var X,Y:Byte);
 Begin
  X := VC.RX;
  Y := VC.RY;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetSizeBox                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Function GetSizeBox(X1,Y1,X2,Y2:Byte):LongInt;
  Begin
   GetSizeBox := MVTxtDrv.GetSizeBox(X1,Y1,X2,Y2);
  End;

 {$ELSE}

  Function GetSizeBox(X1,Y1,X2,Y2:Byte):LongInt;
  Begin
   {$IFDEF __GRAPH__}
    Case VC.Methode of
   {$ENDIF}
    {$IFDEF __GRAPHDIRECT__}
     ScrnGraphDirect : Begin
                        If(VC.SaveText)Then GetSizeBox := (((X2 - X1 + 1) * (Y2 - Y1 + 1)) shl 1)
                                       Else GetSizeBox := LongInt(GetImageSize);
                       End;
    {$ENDIF}
    {$IFDEF __BGI__}
             ScrnBGI : GetSizeBox := Graph.ImageSize(X1*8,Y1*GetHeightChar,
                                                     X2*8+7,(Y2+1)*GetHeightChar-1);
    {$ENDIF}
    {$IFDEF __GRAPH__}
                  Else
    {$ENDIF}
                      GetSizeBox := (((X2 - X1 + 1) * (Y2 - Y1 + 1)) shl 1);
   {$IFDEF __GRAPH__}
    End;
   {$ENDIF}
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  GetVideoMethode                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function GetVideoMethode:Byte;
 Begin
  GetVideoMethode := VC.Methode;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetVideoMode                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function GetVideoMode:Byte;
 Begin
  GetVideoMode := VC.Mode;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        IsEGA                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function IsEGA:Boolean;
 Begin
  IsEGA := VC.EGA;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        IsVGA                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function IsVGA:Boolean;
 Begin
  IsVGA := VC.VGA;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      InitVideo                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure InitVideo;
  Begin
   MVTxtDrv.InitVideo;
  End;

 {$ELSE}

  Procedure InitVideo;
  Begin
   SetBorderFormat(BorderSimple);
   MEM_InitVideo;
   BIOS_InitVideo;
   VC.EGA := BIOS_IsEGA;
   If(VC.EGA)Then VC.Memory := BIOS_EGA_SizeMemory;
   VC.VGA := ((Byte(BIOS_GetVideoCard) in [7,8]));
   VC.TypeMode := Byte(Mem_PortVideo = $3D4);
   Case VC.Methode of
    {$IFDEF __BGI__}
             ScrnBGI : Begin
                        BGI_Mode.InitVideo;
                        VC.Mode    := BGI_MODE.GetVideoMode;
                        VC.MaxColn := BGI_TEXT.TextMaxX;
                        VC.Coln    := VC.MaxColn + 1;
                        VC.MaxLine := BGI_TEXT.TextMaxY;
                        VC.Line    := VC.MaxLine + 1;
                        VC.Color   := 256;
                       End;
    {$ENDIF}
    {$IFDEF __GRAPHDIRECT__}
     ScrnGraphDirect : Begin
                        DirectGraphic.SetVideoEmulText(3);
                        If Not(DirectGT.InitBuffer)Then
                        Begin
                         ASM
                          MOV AX,$0003;
                          INT $10;
                         END;
                         WriteLn('Out of memory!');
                         Halt;
                        End;
                        GetMem(DirectGraphic.GBuffer,VG.NumXPixels);
                        VC.Mode    := DirectGraphic.GetVideoMode;
                        VC.MaxColn := DirectGT.GetMaxX;
                        VC.MaxLine := DirectGT.GetMaxY;
                        VC.Coln    := VC.MaxColn + 1;
                        VC.Line    := VC.MaxLine + 1;
                        VC.Color   := 256;
                        VC.NumX    := VG.NumXPixels;
                        VC.NumY    := VG.NumYPixels;
                       End;
    {$ENDIF}
           ScrnDirect : Begin
                         VC.Mode    := MEM_GetVideoMode;
                         VC.Line    := VD.Line;
                         VC.MaxLine := VD.MaxY;
                         VC.Coln    := VD.Coln;
                         VC.MaxColn := VD.MaxX;
                         VC.Color    := 0;
                         If(BIOS_Info_)Then
                         Begin
                          VC.Blink := BIOS_GetBlink;
                          VC.Color := BIOS_GetNumColor;
                         End
                          else
                         VC.Color := GetDefaultColor;
                        End
                   Else Begin
                         VC.Mode    := BIOS_GetVideoMode;
                         VC.Line    := VB.Line;
                         VC.MaxLine := VB.MaxY;
                         VC.Coln    := VB.Coln;
                         VC.MaxColn := VB.MaxX;
                         VC.Color    := 0;
                         If(BIOS_Info_)Then
                         Begin
                          VC.Blink := BIOS_GetBlink;
                          VC.Color := BIOS_GetNumColor;
                         End
                          else
                         VC.Color := GetDefaultColor;
                        End;
    End;
   End;

  {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    PutBorderUnColor                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure PutBorderUncolor(X1,Y1,X2,Y2:Byte);
  Begin
   MVTxtDrv.PutBorderUncolor(X1,Y1,X2,Y2);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure PutBorderUncolor(X1,Y1,X2,Y2:Byte);
   Begin
    Case VC.Methode of
     {$IFDEF __GRAPHDIRECT__}
      ScrnGraphDirect : Exit;
     {$ENDIF}
             {$IFDEF __BGI__}
              ScrnBGI : Exit;
             {$ENDIF}
           ScrnDirect : MEM_PutBorderUncolor(X1,Y1,X2,Y2);
  		   Else BIOS_PutBorderUncolor(X1,Y1,X2,Y2);
    End;
   End;

 {$ELSE}

   Procedure PutBorderUncolor(X1,Y1,X2,Y2:Byte);
   Type PPutBorderUncolor = Procedure(X1,Y1,X2,Y2:Byte);
   Const CPutBorderUncolor : Array[ScrnDirect..ScrnBIOS] of
                              PPutBorderUncolor =
                              (MEM_PutBorderUncolor,BIOS_PutBorderUncolor);
   Begin
    CPutBorderUncolor[VC.Methode](X1,Y1,X2,Y2);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        PutBox                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure PutBox(X1,Y1,X2,Y2:Byte;Var Buffer);
  Begin
   MVTxtDrv.PutBox(X1,Y1,X2,Y2,Buffer);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure PutBox(X1,Y1,X2,Y2:Byte;Var Buffer);
   Begin
    If(X2 < X1)Then Exit;
    If(Y2 < Y1)Then Exit;
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DSRM.RestoreImageText(X1,Y1,X2,Y2,Buffer);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : Begin
                     If(VC.SaveText)Then BGI_TEXT.PutBox(X1,Y1,X2,Y2,Buffer)
                                    Else BGI_TEXT.PutImageText(X1,Y1,X2,Y2,Buffer);
                    End;
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_PutBox(X1,Y1,X2,Y2,Buffer);
               Else BiosText.BIOS_PutBox(X1,Y1,X2,Y2,Buffer);
    End;
   End;

  {$ELSE}

   Procedure PutBox(X1,Y1,X2,Y2:Byte;Var Buffer);
   Type PPutBox = Procedure(X1,Y1,X2,Y2:Byte;Var Buffer);
   Const CPutBox : Array[ScrnDirect..ScrnBIOS] of PPutBox =
                   (DirecTxt.MEM_PutBox,BiosText.BIOS_PutBox);
   Begin
    CPutBox[VC.Methode](X1,Y1,X2,Y2,Buffer);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   PutEmptyBorder                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure PutEmptyBorder(X1,Y1,X2,Y2,Color:Byte);
  Begin
   MVTxtDrv.PutEmptyBorder(X1,Y1,X2,Y2,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure PutEmptyBorder(X1,Y1,X2,Y2,Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __BGI__}
          ScrnBGI : Exit;
         {$ENDIF}
     {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : Exit;
    {$ENDIF}
       ScrnDirect : MEM_PutEmptyBorder(X1,Y1,X2,Y2,Color);
   	     Else BIOS_PutEmptyBorder(X1,Y1,X2,Y2,Color);
    End;
   End;

  {$ELSE}

   Procedure PutEmptyBorder(X1,Y1,X2,Y2,Color:Byte);
   Type PPutEmptyBorder = Procedure(X1,Y1,X2,Y2,Color:Byte);
   Const CPutEmptyBorder : Array[ScrnDirect..ScrnBIOS] of PPutEmptyBorder =
                           (MEM_PutEmptyBorder,BIOS_PutEmptyBorder);
   Begin
    CPutEmptyBorder[VC.Methode](X1,Y1,X2,Y2,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    PutFillBorder                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure PutFillBorder(X1,Y1,X2,Y2,Color:Byte);
  Begin
   MVTxtDrv.PutFillBorder(X1,Y1,X2,Y2,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure PutFillBorder(X1,Y1,X2,Y2,Color:Byte);
   Begin
    If(X2 < X1)Then Exit;
    If(Y2 < Y1)Then Exit;
    Case VC.Methode of
          {$IFDEF __GRAPHDIRECT__}
   ScrnGraphDirect : DirectGT.PutFillBorder(X1,Y1,X2,Y2,Color);
          {$ENDIF}
          {$IFDEF __BGI__}
           ScrnBGI : BGI_TEXT.PutFillTextBorder(X1,Y1,X2,Y2,Color);
          {$ENDIF}
        ScrnDirect : DirecTxt.MEM_PutFillBorder(X1,Y1,X2,Y2,Color);
  	      Else BiosText.BIOS_PutFillBorder(X1,Y1,X2,Y2,Color);
    End;
   End;

  {$ELSE}

   Procedure PutFillBorder(X1,Y1,X2,Y2,Color:Byte);
   Type PPutFillBorder = Procedure(X1,Y1,X2,Y2,Color:Byte);
   Const CPutFillBorder : Array[ScrnDirect..ScrnBIOS] of PPutFillBorder =
                          (DirecTxt.MEM_PutFillBorder,
  			   BiosText.BIOS_PutFillBorder);
   Begin
    CPutFillBorder[VC.Methode](X1,Y1,X2,Y2,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SaveBox                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SaveBox(X1,Y1,X2,Y2:Byte;Var Buffer);
  Begin
   MVTxtDrv.SaveBox(X1,Y1,X2,Y2,Buffer);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure SaveBox(X1,Y1,X2,Y2:Byte;Var Buffer);
   Begin
    Case VC.Methode of
          {$IFDEF __GRAPHDIRECT__}
   ScrnGraphDirect : DSRM.SaveImageText(X1,Y1,X2,Y2,Buffer);
          {$ENDIF}
          {$IFDEF __BGI__}
           ScrnBGI : Begin
                      If(VC.SaveText)Then BGI_TEXT.SaveBox(X1,Y1,X2,Y2,Buffer)
                                     Else BGI_TEXT.GetImageText(X1,Y1,X2,Y2,Buffer);
                     End;
          {$ENDIF}
        ScrnDirect : DirecTxt.MEM_SaveBox(X1,Y1,X2,Y2,Buffer);
                Else BiosText.BIOS_SaveBox(X1,Y1,X2,Y2,Buffer);
    End;
   End;

  {$ELSE}

   Procedure SaveBox(X1,Y1,X2,Y2:Byte;Var Buffer);
   Type PSaveBox = Procedure(X1,Y1,X2,Y2:Byte;Var Buffer);
   Const CSaveBox : Array[ScrnDirect..ScrnBIOS] of PSaveBox =
                    (DirecTxt.MEM_SaveBox,BiosText.BIOS_SaveBox);
   Begin
    CSaveBox[VC.Methode](X1,Y1,X2,Y2,Buffer);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    ScrollDown_                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure ScrollDown_(X1,Y1,X2,Y2,Color:Byte);
  Begin
  End;

 {$ELSE}

  Procedure ScrollDown_(X1,Y1,X2,Y2,Color:Byte);
  Begin
   BIOS_ScrollDown_(X1,Y1,X2,Y2,Color);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     ScrollUp_                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure ScrollUp_(X1,Y1,X2,Y2,Color:Byte);
  Begin
  End;

 {$ELSE}

  Procedure ScrollUp_(X1,Y1,X2,Y2,Color:Byte);
  Begin
   BIOS_ScrollUp_(X1,Y1,X2,Y2,Color);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetAttr                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetAttr(X,Y,Color:Byte);
  Begin
   MVTxtDrv.SetAttr(X,Y,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure SetAttr(X,Y,Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.SetAttr(X,Y,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.SetAttr(X,Y,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_SetAttr(X,Y,Color);
               Else BiosText.BIOS_SetAttr(X,Y,Color);
    End;
   End;

  {$ELSE}

   Procedure SetAttr(X,Y,Color:Byte);
   Type PSetAttr = Procedure(X,Y,Color:Byte);
   Const CSetAttr : Array[ScrnDirect..ScrnBIOS] of PSetAttr =
                    (DirecTxt.MEM_SetAttr,BiosText.BIOS_SetAttr);
   Begin
    CSetAttr[VC.Methode](X,Y,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetBlink                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetBlink(Etat:Boolean);
  Begin
   MVTxtDrv.SetBlink(Etat);
  End;

 {$ELSE}

  Procedure SetBlink(Etat:Boolean);
  Begin
   {$IFDEF __BGI__}
    If(VC.Methode = ScrnBGI)Then Exit;
   {$ENDIF}
   MEM_SetBlink(Etat);
   VC.Blink := Etat;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   SetBorderFormat                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetBorderFormat(Format:BorderType);
  Begin
   MVTxtDrv.SetBorderFormat(Format);
  End;

 {$ELSE}

  Procedure SetBorderFormat(Format:BorderType);
  Begin
   Numeric.Move(Format,VC.Border,SizeOf(VC.Border))
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   SetBorderSpace_                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetBorderSpace_;
  Begin
   MVTxtDrv.SetBordreSpace;
  End;

 {$ELSE}

  Procedure SetBorderSpace_;
  Const Format : BorderType = '        ';
  Begin
   SetBorderFormat(Format);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   SetBorderSimple_                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetBorderSimple_;
  Begin
   MVTxtDrv.SetBorderSimple;
  End;

 {$ELSE}

  Procedure SetBorderSimple_;
  Begin
   SetBorderFormat(BorderSimple);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   SetBorderShade                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetBorderShade(Etat:Boolean);
  Begin
   MVTxtDrv.SetBorderShade(Etat);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure SetBorderShade(Etat:Boolean);
   Begin
    {$IFDEF __BGI__}
     If(VC.Methode = ScrnBGI)Then Exit;
    {$ENDIF}
    If(VC.Methode = ScrnDirect)Then MEM_SetBorderShade(Etat)
  			       Else BIOS_SetBorderShade(Etat);
   End;

  {$ELSE}

   Procedure SetBorderShade(Etat:Boolean);
   Type PSetBorderShade = Procedure(Etat:Boolean);
   Const CSetBorderShade : Array[ScrnDirect..ScrnBIOS] of PSetBorderShade =
                           (MEM_SetBorderShade,BIOS_SetBorderShade);
   Begin
    CSetBorderShade[VC.Methode](Etat);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   SetBorderSpace                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetBorderSpace(Etat:Boolean);
  Begin
   MVTxtDrv.SetBorderSpace(Etat);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure SetBorderSpace(Etat:Boolean);
   Begin
    {$IFDEF __BGI__}
     If(VC.Methode = ScrnBGI)Then Exit;
    {$ENDIF}
    If(VC.Methode = ScrnDirect)Then MEM_SetBorderSpace(Etat)
	  		       Else BIOS_SetBorderSpace(Etat);
   End;

  {$ELSE}

   Procedure SetBorderSpace(Etat:Boolean);
   Type PSetBorderSpace = Procedure(Etat:Boolean);
   Const CSetBorderSpace : Array[ScrnDirect..ScrnBIOS] of PSetBorderSpace =
                           (MEM_SetBorderSpace,BIOS_SetBorderSpace);
   Begin
    CSetBorderSpace[VC.Methode](Etat);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetChar                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetChar(X,Y:Byte;Chr:Char);
  Begin
   MVTxtDrv.SetChar(X,Y,Chr);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure SetChar(X,Y:Byte;Chr:Char);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.SetChar(X,Y,Chr);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.SetChar(X,Y,Chr);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_SetChar(X,Y,Chr);
               Else BiosText.BIOS_SetChar(X,Y,Chr);
    End;
   End;

  {$ELSE}

   Procedure SetChar(X,Y:Byte;Chr:Char);
   Type PSetChar = Procedure(X,Y:Byte;Chr:Char);
   Const CSetChar : Array[ScrnDirect..ScrnBIOS] of PSetChar =
                    (DirecTxt.MEM_SetChar,BiosText.BIOS_SetChar);
   Begin
    CSetChar[VC.Methode](X,Y,Chr);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetColor                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure SetColor(Color:Byte);
 Begin
  VC.LastColor := VC.NorColor;
  VC.NorColor  := Color;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetCube                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetCube(X,Y:Byte;Chr:Char;Color:Byte);
  Begin
   MVTxtDrv.SetCube(X,Y,Chr,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure SetCube(X,Y:Byte;Chr:Char;Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.SetCube(X,Y,Chr,Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.SetCube(X,Y,Chr,Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_SetCube(X,Y,Chr,Color);
               Else BiosText.BIOS_SetCube(X,Y,Chr,Color);
    End;
   End;

  {$ELSE}

   Procedure SetCube(X,Y:Byte;Chr:Char;Color:Byte);
   Type PSetCube = Procedure(X,Y:Byte;Chr:Char;Color:Byte);
   Const CSetCube : Array[ScrnDirect..ScrnBIOS] of PSetCube =
                    (DirecTxt.MEM_SetCube,BiosText.BIOS_SetCube);
   Begin
    CSetCube[VC.Methode](X,Y,Chr,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetCursor                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetCursor(Start,Finish:Byte);
  Begin
   MVTxtDrv.SetCursor(Start,Finish);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure SetCursor(Start,Finish:Byte);
   Begin
    {$IFDEF __BGI__}
     If(VC.Methode = ScrnBGI)Then Exit;
    {$ENDIF}
    If(VC.Methode = ScrnDirect)Then IO_SetCursor(Start,Finish)
  			       Else BIOS_SetCursor(Start,Finish);
   End;

  {$ELSE}

   Procedure SetCursor(Start,Finish:Byte);
   Type PSetCursor = Procedure(Start,Finish:Byte);
   Const CSetCursor : Array[ScrnDirect..ScrnBIOS] of PSetCursor =
                      (IO_SetCursor,BIOS_SetCursor);
   Begin
    CSetCursor[VC.Methode](Start,Finish);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SetPaletteRGB                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetPaletteRGB(Registre:Word;Red,Green,Blue:Byte);
  Begin
   MVTxtDrv.SetPaletteRGB(Registre,Red,Green,Blue);
  End;

 {$ELSE}

  Procedure SetPaletteRGB(Registre:Word;Red,Green,Blue:Byte);
  Var TmpRed, TmpGreen, TmpBlue : Byte;
  Begin
   {$IFDEF __BGI__}
    If(VC.Methode = ScrnBGI)Then
    Begin
     If(GetDriver = Graph.IBM8514)Then
      Graph.SetRGBPalette(Registre,Red,Green,Blue)
     Else
      Graph.SetRGBPalette(Registre,Red shr 2,Green shr 2,Blue shr 2);
     Exit;
    End;
   {$ENDIF}
   If((VC.EGA)and(VC.VGA = False))Then
   Begin
    TmpRed := Red shr 6; TmpGreen := Green shr 6; TmpBlue := Blue shr 6;
    BIOS_SetPaletteEGA(Registre,((TmpBlue and 1) + ((TmpBlue and 2) shl 2)) +
 			      (((TmpGreen and 1) shl 1) + ((TmpGreen and 2) shl 3)) +
 			      (((TmpRed and 1) shl 2) + ((TmpRed and 2) shl 4)));
   End
    else
   If(VC.VGA)Then
   Begin
    BIOS_SetPaletteVGA(Registre,Red shr 2,Green shr 2,Blue shr 2);
   End;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        SetPos                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure SetPos(X,Y:Byte);
 Begin
  VC.RX := X;
  VC.RY := Y;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SetPosCursor                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetPosCursor(X,Y:Byte);
  Begin
   MVTxtDrv.SetPosCursor(X,Y);
  End;

 {$ELSE}

  Procedure SetPosCursor(X,Y:Byte);
  Begin
   {$IFDEF __BGI__}
    If(VC.Methode = ScrnBGI)Then Exit;
   {$ENDIF}
   If(VC.Methode = ScrnDirect)Then IO_SetPosCursor(X,Y)
   			      Else BIOS_SetPosCursor(X,Y,0);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SetScanLine                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetScanLine(Format:Byte);
  Begin
   MVTxtDrv.SetScanLine(Format:Byte);
  End;

 {$ELSE}

  Procedure SetScanLine(Format:Byte);
  Begin
   {$IFDEF __BGI__}
    If(VC.Methode = ScrnBGI)Then Exit;
   {$ENDIF}
   BIOS_SetScanLine(Format);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetSpace                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetSpace(X,Y,Color:Byte);
  Begin
   MVTxtDrv.SetSpace(X,Y,Color);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure SetSpace(X,Y,Color:Byte);
   Begin
    Case VC.Methode of
         {$IFDEF __GRAPHDIRECT__}
  ScrnGraphDirect : DirectGT.SetCube(X,Y,' ',Color);
         {$ENDIF}
         {$IFDEF __BGI__}
          ScrnBGI : BGI_TEXT.SetCube(X,Y,' ',Color);
         {$ENDIF}
       ScrnDirect : DirecTxt.MEM_SetSpace(X,Y,Color);
               Else BiosText.BIOS_SetSpace(X,Y,Color);
    End;
   End;

  {$ELSE}

   Procedure SetSpace(X,Y,Color:Byte);
   Type PSetSpace = Procedure(X,Y,Color:Byte);
   Const CSetSpace : Array[ScrnDirect..ScrnBIOS] of PSetSpace =
                     (DirecTxt.MEM_SetSpace,BiosText.BIOS_SetSpace);
   Begin
    CSetSpace[VC.Methode](X,Y,Color);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SetVideoMethode                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure SetVideoMethode(Mode:Byte);
 Begin
  VC.Methode := Mode;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   SetVideoModeText                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetVideoModeText(Mode:ShortInt);
  Begin
   MVTxtDrv.SetVideoMode(Mode);
  End;

 {$ELSE}

   Procedure SetVideoModeText(Mode:ShortInt);
   Begin
    Case VC.Methode of
        {$IFDEF __GRAPHDIRECT__}
 ScrnGraphDirect : DirectGraphic.SetVideoEmulText(Mode);
        {$ENDIF}
        {$IFDEF __BGI__}
         ScrnBGI : BGI_MODE.SetVideoMode(Mode);
        {$ENDIF}
      ScrnDirect : DirecTxt.MEM_SetVideoModeText(Mode);
              Else BiosText.BIOS_SetVideoMode_(Mode);
   End;
   SetParamVideo;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SwitchColor                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure SwitchColor;
 Begin
  ChgChr(VC.LastColor,VC.NorColor);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       WriteAs                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure WriteAs(X,Y:Byte;Chn:String;Color:Byte;Stop:Char);
  Begin
   MVTxtDrv.WriteAs(X,Y,Chn,Color,Stop);
  End;

 {$ELSE}

  {$IFDEF __MINIMIZECONST__}

   Procedure WriteAs(X,Y:Byte;Chn:String;Color:Byte;Stop:Char);
   Begin
    {$IFDEF __BGI__}
     If(VC.Methode = ScrnBGI)Then Exit;
    {$ENDIF}
    If(VC.Methode = ScrnDirect)Then MEM_WriteAs(X,Y,Chn,Color,Stop)
  			     Else BIOS_WriteAs(X,Y,Chn,Color,Stop);
   End;

  {$ELSE}

   Procedure WriteAs(X,Y:Byte;Chn:String;Color:Byte;Stop:Char);
   Type PWriteAs = Procedure(X,Y:Byte;Chn:String;Color:Byte;Stop:Char);
   Const CWriteAs : Array[ScrnDirect..ScrnBIOS] of PWriteAs =
                    (MEM_WriteAs,BIOS_WriteAs);
   Begin
    CWriteAs[VC.Methode](X,Y,Chn,Color,Stop);
   End;

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    WriteOnlyColor                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure WriteOnlyColor(X,Y:Byte;Chn:String;Color:Byte);
  Begin
   MVTxtDrv.WriteOnlyColor(X,Y,Chn,Color);
  End;

 {$ELSE}

  Procedure WriteOnlyColor(X,Y:Byte;Chn:String;Color:Byte);
  Begin
   Case VC.Methode of
        {$IFDEF __GraphDirect__}
  ScrnGraphDirect : DirectGT.WriteOnlyColor(X,Y,Chn,Color);
        {$ENDIF}
        {$IFDEF __BGI__}
         ScrnBGI : BGI_TEXT.WriteOnlyColor(X,Y,Chn,Color);
        {$ENDIF}
      ScrnDirect : DirecTxt.MEM_WriteOnlyColor(X,Y,Chn,Color);
 	     Else BiosText.BIOS_WriteOnlyColor(X,Y,Chn,Color);
   End;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  WriteOnlyColorAnd                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure WriteOnlyColorAnd(X,Y:Byte;Chn:String;Num,Color:Byte);
  Begin
   MVTxtDrv.WriteOnlyColorAnd(X,Y,Chn,Num,Color);
  End;

 {$ELSE}

  Procedure WriteOnlyColorAnd(X,Y:Byte;Chn:String;Num,Color:Byte);
  Begin
   Case VC.Methode of
        {$IFDEF __GraphDirect__}
  ScrnGraphDirect : DirectGT.WriteOnlyColorAnd(X,Y,Chn,Num,Color);
        {$ENDIF}
        {$IFDEF __BGI__}
         ScrnBGI : BGI_TEXT.WriteOnlyColorAnd(X,Y,Chn,Num,Color);
        {$ENDIF}
      ScrnDirect : DirecTxt.MEM_WriteOnlyColorAnd(X,Y,Chn,Num,Color);
              Else BiosText.BIOS_WriteOnlyColorAnd(X,Y,Chn,Num,Color);
   End;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      WriteText                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure WriteText(X,Y:Byte;Chn:String;Color:Byte);
  Begin
   MVTxtDrv.WriteText(X,Y,Chn,Color);
  End;

 {$ELSE}

  Procedure WriteText(X,Y:Byte;Chn:String;Color:Byte);
  Begin
   Case VC.Methode of
        {$IFDEF __GRAPHDIRECT__}
 ScrnGraphDirect : DirectGT.WriteText(X,Y,Chn,Color);
        {$ENDIF}
        {$IFDEF __BGI__}
         ScrnBGI : BGI_TEXT.WriteText(X,Y,Chn,Color);
        {$ENDIF}
      ScrnDirect : DirecTxt.MEM_WriteText(X,Y,Chn,Color);
              Else BiosText.BIOS_WriteText(X,Y,Chn,Color);
   End;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     WriteTypingXY                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure WriteTypingXY(X,Y:Byte;Chn:String);
  Begin
   MVTxtDrv.WriteTypingXY(X,Y:Byte;Chn:String);
  End;

 {$ELSE}

  Procedure WriteTypingXY(X,Y:Byte;Chn:String);
  Begin
   Case VC.Methode of
        {$IFDEF __GRAPHDIRECT__}
 ScrnGraphDirect : Begin
                    VC.RX := X; VC.RY := Y;
                    DirectGT._WriteTyping(Chn);
                   End;
        {$ENDIF}
        {$IFDEF __BGI__}
         ScrnBGI : Begin
                    BGI_TEXT.SetPos(X,Y);
                    BGI_TEXT._WriteTyping(Chn);
                   End;
       {$ENDIF}
      ScrnDirect : DirecTxt.MEM_WriteTypingXY(X,Y,Chn);
              Else BiosText.BIOS_WriteTypingXY(X,Y,Chn);
   End;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 WriteTypingXYBiColor                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure WriteTypingXYBicolor(X,Y:Byte;Chn:String;LastColor,NewColor:Byte);
  Begin
   MVTxtDrv.WriteTypingXYBiColor(X,Y,Chn,LastColor,NewColor);
  End;

 {$ELSE}

  Procedure WriteTypingXYBicolor(X,Y:Byte;Chn:String;LastColor,NewColor:Byte);
  Begin
   Case VC.Methode of
        {$IFDEF __GRAPHDIRECT__}
 ScrnGraphDirect : Begin
                    SetAllColor(LastColor,NewColor);
                    VC.RX := X; VC.RY := Y;
                    DirectGT._WriteTyping(Chn);
                   End;
        {$ENDIF}
        {$IFDEF __BGI__}
         ScrnBGI : Begin
                    BGI_TEXT.SetColor(LastColor);
                    BGI_TEXT.SetColor(NewColor);
                    BGI_TEXT.SetPos(X,Y);
                    BGI_TEXT._WriteTyping(Chn);
                   End;
        {$ENDIF}
      ScrnDirect : DirecTxt.MEM_WriteTypingXYBicolor(X,Y,Chn,LastColor,NewColor);
              Else BiosText.BIOS_WriteTypingXYBicolor(X,Y,Chn,LastColor,NewColor);
   End;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      WriteToAs                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure WriteToAs(X,Y:Byte;Chn:String;Pos,Color:Byte;Stop:Char);
  Begin
   MVTxtDrv.WriteToAs(X,Y,Chn,Pos,Color,Stop);
  End;

 {$ELSE}

  Procedure WriteToAs(X,Y:Byte;Chn:String;Pos,Color:Byte;Stop:Char);
  Begin
   {$IFDEF __GRAPHDIRECT__}
    If(VC.Methode = ScrnGraphDirect)Then Exit;
   {$ENDIF}
   {$IFDEF __BGI__}
    If(VC.Methode = ScrnBGI)Then Exit;
   {$ENDIF}
   If(VC.Methode = ScrnDirect)Then MEM_WriteToAs(X,Y,Chn,Pos,Color,Stop)
	 		      Else BIOS_WriteToAs(X,Y,Chn,Pos,Color,Stop);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      WriteUnColor                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure WriteUncolor(X,Y:Byte;Chn:String);
  Begin
   MVTxtDrv.WriteUncolor(X,Y,Chn);
  End;

 {$ELSE}

  Procedure WriteUncolor(X,Y:Byte;Chn:String);
  Begin
   Case VC.Methode of
             {$IFDEF __GRAPHDIRECT__}
      ScrnGraphDirect : DirectGT.WriteUnColor(X,Y,Chn);
             {$ENDIF}
             {$IFDEF __BGI__}
              ScrnBGI : BGI_TEXT.WriteUnColor(X,Y,Chn);
             {$ENDIF}
           ScrnDirect : DirecTxt.MEM_WriteUncolor(X,Y,Chn);
                   Else BiosText.BIOS_WriteUncolor(X,Y,Chn);
   End;
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     WriteUnColorAs                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure WriteUnColorAs(X,Y:Byte;Chn:String;Stop:Char);
  Begin
   MVTxtDrv.WriteUnColorAs(X,Y,Chn,Stop);
  End;

 {$ELSE}

  Procedure WriteUncolorAs(X,Y:Byte;Chn:String;Stop:Char);
  Begin
   {$IFDEF __BGI__}
    If(VC.Methode = ScrnBGI)Then Exit;
   {$ENDIF}
   If(VC.Methode = ScrnDirect)Then MEM_WriteUncolorAs(X,Y,Chn,Stop)
	 		      Else BIOS_WriteUncolorAs(X,Y,Chn,Stop);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   WriteUnColorToAs                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure WriteUnColorToAs(X,Y:Byte;Chn:String;Pos:Byte;Stop:Char);
  Begin
   MVTxtDrv.WriteUnColorToAs(X,Y,Chn,Pos,Stop);
  End;

 {$ELSE}

  Procedure WriteUncolorToAs(X,Y:Byte;Chn:String;Pos:Byte;Stop:Char);
  Begin
   {$IFDEF __BGI__}
    If(VC.Methode = ScrnBGI)Then Exit;
   {$ENDIF}
   If(VC.Methode = ScrnDirect)Then MEM_WriteUncolorToAs(X,Y,Chn,Pos,Stop)
 			     Else BIOS_WriteUncolorToAs(X,Y,Chn,Pos,Stop);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 SetVideoModeEverexMicro              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

 {$ELSE}

  {$IFDEF __EVEREXMICRO__}

   {$IFDEF __ASSEMBLERSUPPORT__}

    Procedure SetVideoModeEverexMicro(Mode:Byte);
    Begin
     {$IFDEF __BGI__}
      If(VC.Methode = ScrnBGI)Then Exit;
     {$ENDIF}
     ASM
      MOV AX,$0070;
      MOV BL,Mode;
      INT $10;
     END;
     SetParamVideo;
    End;

   {$ELSE}

    Procedure SetVideoModeEverexMicro(Mode:Byte);
    Var Reg : Registers;
    Begin
     {$IFDEF __BGI__}
      If(VC.Methode = ScrnBGI)Then Exit;
     {$ENDIF}
     With Reg do
     Begin
      AX := $0070;
      BL := Mode;
      Intr($10,Reg);
     End;
     SetParamVideo;
    End;

   {$ENDIF}

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 SetVideoModeVideo7VGA                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

 {$ELSE}

  {$IFDEF __VIDEO7VGA__}

   {$IFDEF __ASSEMBLERSUPPORT__}

    Procedure SetVideoModeVideo7VGA(Mode:Byte);
    Begin
     {$IFDEF __BGI__}
      If(VC.Methode = ScrnBGI)Then Exit;
     {$ENDIF}
     ASM
      MOV AX,$6905;
      MOV BL,Mode;
      INT $10;
     END;
     SetParamVideo;
    End;

   {$ELSE}

    Procedure SetVideoModeVideo7VGA(Mode:Byte);
    Var Reg : Registers;
    Begin
     {$IFDEF __BGI__}
      If(VC.Methode = ScrnBGI)Then Exit;
     {$ENDIF}
     With Reg do
     Begin
      AX := $6905;
      BL := Mode;
      Intr($10,Reg);
     END;
     SetParamVideo;
    End;

   {$ENDIF}

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                SetVideoModeTsengLabs4000             ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

 {$ELSE}

  {$IFDEF __TSENG4000__}

   {$IFDEF __ASSEMBLERSUPPORT__}

    Procedure SetVideoModeTsengLabs4000(Mode:Byte);
    Begin
     {$IFDEF __BGI__}
      If(VC.Methode = ScrnBGI)Then Exit;
     {$ENDIF}
     ASM
      MOV AX,$10F0;
      MOV BL,Mode;
      INT $10;
     END;
     VC.Methode := ScrnBIOS;
     SetParamVideo;
    End;

   {$ELSE}

    Procedure SetVideoModeTsengLabs4000(Mode:Byte);
    Var Reg : Registers;
    Begin
     {$IFDEF __BGI__}
      If(VC.Methode = ScrnBGI)Then Exit;
     {$ENDIF}
     With Reg do
     Begin
      AX := $10F0;
      BL := Mode;
      Intr($10,Reg);
     End;
     VC.Methode := ScrnBIOS;
     SetParamVideo;
    End;

   {$ENDIF}

  {$ENDIF}

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetMatrix                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Procedure SetMatrix(Palette:Byte;Start,Number:Word;Height:Byte;Var Buffer);
  Begin
   MVTxtDrv.SetMatrix(Palette,Start,Number,Height,Buffer);
  End;

 {$ELSE}

  Procedure SetMatrix(Palette:Byte;Start,Number:Word;Height:Byte;Var Buffer);
  Var Registre : Registers;
  Begin
   {$IFDEF __BGI__}
    If(VC.Methode = ScrnBGI)Then
    Begin
     BGI_TEXT.SetMatrix(Start,Number,Height,Seg(Buffer),Ofs(Buffer));
     Exit;
    End;
   {$ENDIF}
   {$IFDEF __GRAPHDIRECT__}
    If(VC.Methode = ScrnGraphDirect)Then
    Begin
     DirectGT.SetMatrix(Start,Number,Height,Buffer);
     Exit;
    End;
   {$ENDIF}
   Registre.ES := Seg(Buffer);
   Registre.BP := Ofs(Buffer);
   Registre.AX := $1100;
   Registre.BL := Palette;
   Registre.BH := Height;
   Registre.CX := Number;
   Registre.DX := Start;
   Intr($10,Registre);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetMaterial                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Function SaveMaterialVideo(Var Buffer):Boolean;
  Begin
   SaveMaterialVideo := MVTxtDrv.SaveMaterialVideo(Buffer);
  End;

 {$ELSE}

  Function SaveMaterialVideo(Var Buffer):Boolean;
  Var Registre : Registers;
  Begin
   Registre.ES := Seg(Buffer);
   Registre.BX := Ofs(Buffer);
   Registre.AX := $1C01;
   Registre.CX := vidMaterial;
   Intr($10,Registre);
   SaveMaterialVideo := (Registre.AL = $1C);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    GetSizeMaterialVideo              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Function GetSizeMaterialVideo:LongInt;
  Begin
   GetSizeMaterialVideo := MVTxtDrv.GetSizeMaterialVideo;
  End;

 {$ELSE}

  Function GetSizeMaterialVideo:LongInt;
  Begin
   GetSizeMaterialVideo := BIOS_GetSizeVideo(vidMaterial);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    RestoreMaterialVideo              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Function RestoreMaterialVideo(Var Buffer):Boolean;
  Begin
   RestoreMaterialVideo := MVTxtDrv.RestoreMaterialVideo;
  End;

 {$ELSE}

  Function RestoreMaterialVideo(Var Buffer):Boolean;
  Var Registre : Registers;
  Begin
   Registre.ES := Seg(Buffer);
   Registre.BX := Ofs(Buffer);
   Registre.AX := $1C02;
   Registre.CX := vidMaterial;
   Intr($10,Registre);
   RestoreMaterialVideo :=(Registre.AL = $1C);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     SaveBIOSVideo                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Function SaveBIOSVideo(Var Buffer):Boolean;
  Begin
   SaveBIOSVideo := MVTxtDrv.SaveBIOSVideo(Buffer);
  End;

 {$ELSE}

  Function SaveBIOSVideo(Var Buffer):Boolean;
  Var Registre : Registers;
  Begin
   Registre.ES := Seg(Buffer);
   Registre.BX := Ofs(Buffer);
   Registre.AX := $1C01;
   Registre.CX := vidBIOS;
   Intr($10,Registre);
   SaveBIOSVideo := (Registre.AL = $1C);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    GetSizeBIOSVideo                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Function GetSizeBIOSVideo:LongInt;
  Begin
   GetSizeBIOSVideo := MVTxtDrv.GetSizeVideo;
  End;

 {$ELSE}

  Function GetSizeBIOSVideo:LongInt;
  Begin
   GetSizeBIOSVideo := BIOS_GetSizeVideo(vidBIOS);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    RestoreBIOSVideo                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Function RestoreBIOSVideo(Var Buffer):Boolean;
  Begin
   RestoreBIOSVideo := MVTxtDrv.RestoreBIOSVideo(Buffer);
  End;

 {$ELSE}

  Function RestoreBIOSVideo(Var Buffer):Boolean;
  Var Registre : Registers;
  Begin
   Registre.ES := Seg(Buffer);
   Registre.BX := Ofs(Buffer);
   Registre.AX := $1C02;
   Registre.CX := vidBIOS;
   Intr($10,Registre);
   RestoreBIOSVideo := (Registre.AL = $1C);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  SaveRegistersVideo                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Function SaveRegistersVideo(Var Buffer):Boolean;
  Begin
   SaveRegistersVideo := MVTxtDrv.SaveRegistersVideo(Buffer);
  End;

 {$ELSE}

  Function SaveRegistersVideo(Var Buffer):Boolean;
  Var Registre : Registers;
  Begin
   Registre.ES := Seg(Buffer);
   Registre.BX := Ofs(Buffer);
   Registre.AX := $1C01;
   Registre.CX := vidRegisters;
   Intr($10,Registre);
   SaveRegistersVideo := (Registre.AL = $1C);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                GetSizeRegistersVideo                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 {$IFDEF __DRIVERVIDEO__}

  Function GetSizeRegistersVideo:LongInt;
  Begin
   GetSizeRegistersVideo := MVTxtDrv.GetSizeRegistersVideo;
  End;

 {$ELSE}

  Function GetSizeRegistersVideo:LongInt;
  Begin
   GetSizeRegistersVideo := BIOS_GetSizeVideo(vidRegisters);
  End;

 {$ENDIF}

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                RestoreRegistersVideo                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function RestoreRegistersVideo(Var Buffer):Boolean;
 Var Registre : Registers;
 Begin
  Registre.ES := Seg(Buffer);
  Registre.BX := Ofs(Buffer);
  Registre.AX := $1C02;
  Registre.CX := vidRegisters;
  Intr($10,Registre);
  RestoreRegistersVideo := (Registre.AL = $1C);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SaveBufferVideo                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function SaveBufferVideo(Var Buffer):Boolean;
 Var Address : Word;
     Size    : LongInt;
 Begin
  Size := GetSizeBufferVideo;
  If(VC.Graph)Then Address := $A000 + (Byte(VC.Mode in [4,5,6]) * $1800)
	      else Address := $B000 + ((Byte(MemW[$0040:$63] = $3D4)) * $800);
  Move(Mem[Address:0],Buffer,Size);
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  GetSizeBufferVideo                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function GetSizeBufferVideo:LongInt;
 Var Graph : Boolean;
 Begin
  Graph := IsGraphic;
  VC.Graph := Graph;
  If(Graph)Then
  Begin
   Case VC.Mode of
    4,5,6 : GetSizeBufferVideo := $7FFF;
      $13 : GetSizeBufferVideo := 64000;
       Else GetSizeBufferVideo := $FFFF;
   End;
  End
   Else
  GetSizeBufferVideo := MemW[$0040:$4C];
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  RestoreBufferVideo                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function RestoreBufferVideo(Var Buffer):Boolean;
 Var Size : LongInt;
 Begin
  InitVideo;
  Size := GetSizeBufferVideo;
  If(VC.Graph)Then
  Begin
   Case VC.Mode of
    4,5,6 : Move(Buffer,Mem[$B800:0],$7FFF);
      $13 : Move(Buffer,Mem[$A000:0],64000);
       Else Move(Buffer,Mem[$A000:0],$FFFF);
   End;
  End
   else
  Move(Buffer,Mem[$B000 + ((Byte(MemW[$0040:$63] = $3D4)) * $800):0],Size);
  RestoreBufferVideo := True;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetCharXY                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function GetCharXY(X,Y:Byte):Char;
 Begin
  Case VC.Methode of
   ScrnDirect : GetCharXY := DirecTxt.MEM_GetCharXY(X,Y);
           Else GetCharXY := BiosText.BIOS_GetChar(X,Y,0);
  End;
 End;

{$ENDIF}

 {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       DoneVideo                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Procedure DoneVideo;
 Begin
  {$IFDEF __GRAPHDIRECT__}
   If(VC.Methode = ScrnGraphDirect)Then
   Begin
    If(DirectGT.DoneBuffer)Then;
   End;
  {$ENDIF}
  {$IFDEF __BGI__}
   If(VC.Methode = ScrnBGI)Then
   Begin
    CloseGraph;
    If(BGI_TEXT.DoneGraphTxt)Then;
   End;
  {$ENDIF}
 End;

{$ENDIF}

{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                     DirectTextDetect                 ³Û
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
  ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFNDEF __ISDRIVERVIDEO__}

 Function DirectTextDetect:Boolean;
 Begin
  VD.Address := TextSegment;
  DirectTextDetect := (Byte(BIOS_GetChar(0,0,0)) = Mem[VD.Address:0]);
 End;

{$ENDIF}

BEGIN { Main Unit }
 Numeric.MemSet(VC,SizeOf(VC),0);
 VC.LastColor := 15;
 VC.NorColor  := 7;
 Card         := _Unknown;
 {$IFDEF __GRAPH__}
  VC.SaveText := False;
 {$ENDIF}
END.
