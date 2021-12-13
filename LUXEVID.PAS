(****************************************************************)
(*                                                              *)
(*                   Malte System/Luxe Video                    *)
(*                          1992/11/03                          *)
(*                                                              *)
(*          Copyright (C) par les Chevaliers de Malte           *)
(*                                                              *)
(****************************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System

  Nom :

   Vid‚o de luxe (Luxe Video).
}

Unit LuxeVid;

(****************************************************************)
			    INTERFACE
(****************************************************************)

Uses Text;

Const

      BorderSimple     : BorderType = 'ÚÄ¿³³ÀÄÙ';
      BorderLuxe       : BorderType = 'ÛÛÛ'#1#2#5#4#6;
      BorderLuxeSimple : BorderType = #31#3#7#1#2#5#4#6;

      Black        = 0;
      Blue         = 1;
      Green        = 2;
      Cyan         = 3;
      Red          = 4;
      Magenta      = 5;
      Brown        = 6;
      LightGray    = 7;
      DarkGray     = 8;
      LightBlue    = 9;
      LigntGreen   = 10;
      LightCyan    = 11;
      LightRed     = 12;
      LightMagenta = 13;
      Yellow       = 14;
      White        = 15;

Type

     StrIcon = String[7];

     ScreenImage = Object
		    Buffer:Pointer;
		    Size:Word;
    	            Constructor Init;
		    Destructor Restore;
		    Function GetScreen:Boolean;
		   End;

    BoxImage = Object
		Buffer:Pointer;
		Size:Word;
		TX1,TY1,TX2,TY2:Byte;
		Constructor Init;
		Destructor Restore;
		Function GetBox(X1,Y1,X2,Y2:Byte):Boolean;
		Function GetLine(X1,Y,X2:Byte):Boolean;
	       End;

Var

    SelectIcon   : StrIcon;
    UnSelectIcon : StrIcon;
    CloseIcon    : StrIcon;
    ZoomIcon     : StrIcon;
    UpIcon       : StrIcon;
    LeftIcon     : StrIcon;
    RightIcon    : StrIcon;
    DownIcon     : StrIcon;
    Border       : BorderType;

Procedure InitVideoDeluxe;
Procedure DoneVideoDeluxe;
Procedure ClearLastLine(Character:Char;Color:Byte);
Procedure InitScreenApplication(Title:String);
Procedure PutLastBar(X:Byte;Msg:String);
Procedure RestoreScreen(Var Buffer);
Procedure SaveScreen(Var Buffer);
Procedure SetBackground(Background:Byte);
Procedure SetForeground(Foreground:Byte);
Procedure SetLuxeBorderSimple;
Procedure WriteTextHome(Chn:String;Color:Byte);
Procedure _ClearLastLine(Character:Char);
Procedure _SetColor(Foreground,Background:Byte);

Function GetFlagLuxeVid:Boolean;
Function GetFlagLuxeChar:Boolean;
Function GetSizeScreen:Word;

(****************************************************************)
			  IMPLEMENTATION
(****************************************************************)

Uses Mtx8x8,Mtx8x14,Mtx8x16, { Matrix 8x8, 8x14 et 8x16 }
     DirecTxt,                { Gestionnaire vid‚o direct }
     BiosText,               { Gestionnaire vid‚o … partir du BIOS. }
     Level;                  { Chef d'orchestre de la structure
                               anatomique du Malte System. }

Const

      IsInit : Boolean = False; { Drapeau indiquant si l'unit‚ … d‚ja
                                  ‚t‚ initialis‚. }
      Luxe   : Boolean = False; { Drapeau indiquant si l'unit‚ travaille
                                  en environnement de luxe. }

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    GetFlagLuxeVid                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function GetFlagLuxeVid:Boolean;

  D‚finition :

   ş Cette fonction retourne la valeur officiel du drapeau
     d'intialisation du module.
}

Function GetFlagLuxeVid:Boolean;
Begin
 GetFlagLuxeVid := IsInit;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   GetFlagLuxeChar                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function GetFlagLuxeChar:Boolean;

  D‚finition :

   ş Cette fonction retourne la valeur officiel du drapeau
     de l'environnement de luxe.
}

Function GetFlagLuxeChar:Boolean;
Begin
 GetFlagLuxeChar := Luxe;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     _SetColor                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Procedure _SetColor(Foreground,Background:Byte);

  D‚finition :

   ş S‚lectionne la couleur de fond et le couleur d'‚criture
     courante.

  Notes :

   ş Les couleurs doivent ˆtre comprit entre 0 et 15. Le 0
     est le noir, 1 pour le bleu, ..., 15 pour le blanc.

   ş Les couleurs de fond entre 8 et 15 sont brillant par
     d‚faut, mais il arrive qu'il soit clignotant si vous
     lui demander et ce fonction est affecter par celui-ci.
}

Procedure _SetColor(Foreground,Background:Byte);
Begin
 SetColor(Foreground + (Background shl 4));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   SetForeground                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure SetForeground(Foreground:Byte);
Begin
 _SetColor(Foreground,(GetColor shr 4));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   SetBackground                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure SetBackground(Background:Byte);
Begin
 _SetColor((GetColor and 15),Background);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   InitVideoDeluxe                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure InitVideoDeluxe;
Var Mtx8x16Luxe : Pointer;
    Mtx8x14Luxe : Pointer;
    Mtx8x8Luxe  : Pointer;
Begin
 Mtx8x8Luxe  := @Matrix8x8Luxe;
 Mtx8x14Luxe := @Matrix8x14Luxe;
 Mtx8x16Luxe := @Matrix8x16Luxe;
 SetBorderShade(True);
 SetBorderSpace(False);
 UnselectIcon := '( )';
 SelectIcon := '(' + #7 + ')';
 CloseIcon := ' - ';
 ZoomIcon := ' ' + #31 + ' ';
 LeftIcon := '<';
 RightIcon := '>';
 UpIcon := #18;
 DownIcon := #19;
 Border := BorderSimple;
 InitVideo;
 {$IFDEF __GRAPHDIRECT__}
  If(VC.Methode = ScrnGraphDirect)Then
  Begin
   Luxe := True;
   Border := BorderLuxe;
   SetBorderFormat(Border);
   SetMatrix(0,0,32,16,Mtx8x16Luxe^);
   UnselectIcon := #19+#20;
   SelectIcon := #21+#22;
   CloseIcon := #8+#9;
   ZoomIcon := #12+#13;
   UpIcon := #10+#11;
   DownIcon := #12+#13;
   LeftIcon := #17+#9;
   RightIcon := #8+#16;
   IsInit := True;
   Exit;
  End;
 {$ENDIF}
 {$IFDEF __BGI__}
  If(VC.Methode = ScrnBGI)Then
  Begin
   Luxe := True;
   Border := BorderLuxe;
   SetBorderFormat(Border);
   SetMatrix(0,0,32,16,Mtx8x16Luxe^);
   UnselectIcon := #19+#20;
   SelectIcon := #21+#22;
   CloseIcon := #8+#9;
   ZoomIcon := #12+#13;
   UpIcon := #10+#11;
   DownIcon := #12+#13;
   LeftIcon := #17+#9;
   RightIcon := #8+#16;
   IsInit := True;
   Exit;
  End
   else
 {$ENDIF}
 If(VC.Coln > 80)or(VC.Line > 25)Then
 Begin
  If(VC.EGA)or(VC.VGA)Then
  Begin
   If(GetHeightChar = 8)Then
   Begin
    Luxe := True;
    Border := BorderLuxe;
    SetBorderFormat(Border);
    SetMatrix(0,0,32,8,Mtx8x8Luxe^);
    CloseCursor;
    UnselectIcon := #19+#20;
    SelectIcon := #21+#22;
    CloseIcon := #8+#9;
    ZoomIcon := #12+#13;
    UpIcon := #10+#11;
    DownIcon := #12+#13;
    LeftIcon := #17+#9;
    RightIcon := #8+#16;
   End;
  End;
  SetBlink(False);
  IsInit := True;
  Exit;
 End;
 If(VC.EGA)or(VC.VGA)Then
 Begin
  Luxe := True;
  Border := BorderLuxe;
  SetBorderFormat(Border);
  SetScanLine(Scan350);
  SetVideoModeText(3);
  If(BIOS_GetScanLine_ = 350)Then
   SetMatrix(0,0,32,14,Mtx8x14Luxe^)
  Else
   SetMatrix(0,0,32,8,Mtx8x8Luxe^);
  CloseCursor;
  UnselectIcon := #19+#20;
  SelectIcon := #21+#22;
  CloseIcon := #8+#9;
  ZoomIcon := #12+#13;
  UpIcon := #10+#11;
  DownIcon := #12+#13;
  LeftIcon := #17+#9;
  RightIcon := #8+#16;
 End;
 SetBlink(False);
 IsInit := True;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   DoneVideoDeluxe                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure DoneVideoDeluxe;
Begin
 If(IsInit)Then
 Begin
  Text.DoneVideo;
  VC.Methode := ScrnBIOS;
  If(Luxe)Then
  Begin
   If(VC.VGA)Then SetScanLine(Scan400) else
   If(VC.EGA)Then SetScanLine(Scan350);
   SetVideoModeText(3);
  End;
  IsInit := False;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 InitScreenApplication                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure InitScreenApplication(Title:String);
Const

      CharA = #29;
      CharB = #30;
Var

    LeftDown,RightUp,RightDown : String;

 Procedure PutTapisDirect(Y1,Y2:Byte);
 Var I,J,JD,ID,Y1M,Y2M,MHX : Byte;
     JDC,JDC1              : Word;
     TA,TB                 : Array[0..3] of Byte;
 Begin
  TA[0] := Byte(CharA); TA[1] := Color.Base.Background;
  TA[2] := Byte(CharB); TA[3] := Color.Base.Background;
  TB[0] := Byte(CharB); TB[1] := Color.Base.Background;
  TB[2] := Byte(CharA); TB[3] := Color.Base.Background;
  Y1M := Y1 shr 1; Y2M := Y2 shr 1;
  MHX := (GetMaxX shr 1);
  For J := Y1M to Y2M do
  Begin
   JD := J shl 1;
   JDC := JD * VD.Coln;
   JDC1 := (1+JD) * VD.Coln;
   For I := 0 to MHX do
   Begin
    ID := I shl 1;
    Move(TA,Mem[VD.Address:(ID+JDC) shl 1],SizeOf(TA));
    Move(TB,Mem[VD.Address:(ID+JDC1) shl 1],SizeOf(TB));
   End;
  End;
 End;

 Procedure PutTapis(Y1,Y2:Byte);
 Label 10;
 Var I,J,JD,ID,Y1M,Y2M,MX,MY : Byte;
     Chn1,Chn2               : String;
 Begin
  MX := VC.MaxColn shr 1; MY := VC.MaxLine;
  Y1M := Y1 shr 1; Y2M := Y2 shr 1;
  Chn1 := ''; Chn2 := '';
  For I := 0 to MX do
  Begin
   Chn1 := Chn1 + (CharA + CharB);
   Chn2 := Chn2 + (CharB + CharA);
  End;
  J := Y1;
10:
  WriteText(0,J,Chn1,Color.Base.Background);
  WriteText(0,J+1,Chn2,Color.Base.Background);
  Inc(J,2);
  If(J < Y2)Then Goto 10;
 End;

Begin
 If(Luxe)Then
 Begin
  If(VC.EGA)or(VC.VGA)Then
  Begin
   LeftDown := #26;
   RightUp := #27+#24;
   RightDown := #28+#25;
  End
   else
  Begin
   LeftDown := '';
   RightUp := '';
   RightDown := '';
  End;
 End;
 WriteTextHome(CloseIcon,Color.Base.Icon);
 BarSpaceHori(2,0,GetMaxX,Color.Base.Title);
 If(RightUp <> '')Then WriteText(GetMaxX+1-Length(RightUp),0,RightUp,Color.Base.Title shr 4);
 If(Title <> '')Then WriteText((GetMaxX-Length(Title)) shr 1,0,Title,Color.Base.Title);
 BarSpaceHori(0,1,GetMaxX,Color.Menu.Normal);
 If(VC.EGA)or(VC.VGA)Then
 Begin
  If(VC.Methode = ScrnDirect)Then PutTapisDirect(2,GetMaxY-1)
			     Else PutTapis(2,GetMaxY-1);
 End
  else
 Begin
  ClearWindow(0,2,GetMaxX,GetMaxY-1,Color.Base.Background);
 End;
 BarSpaceHori(0,GetMaxY,GetMaxX,Color.EndBar.Normal);
 If(LeftDown <> '')Then WriteText(0,GetMaxY,LeftDown,Color.Base.Icon);
 If(RightDown <> '')Then WriteText(GetMaxX-1,GetMaxY,RightDown,Color.Base.Icon);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     ClearLastLine                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure ClearLastLine(Character:Char;Color:Byte);
Begin
 ClearLine(GetMaxY,Character,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    _ClearLastLine                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure _ClearLastLine(Character:Char);
Begin
 ClearLastLine(Character,GetColor);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    WriteTextHome                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure WriteTextHome(Chn:String;Color:Byte);
Begin
 WriteText(0,0,Chn,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     PutLastBar                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutLastBar(X:Byte;Msg:String);
Var I,L : Byte;
Begin
 L := 0;
 For I := 1 to Length(Msg) do
 Begin
  If((Msg[I] > #31)and (Not(Msg[I] in ['~','^','|'])))Then Inc(L);
 End;
 WriteTypingXY(X,GetMaxY,Msg);
 BarCharHori(X+L,GetMaxY,GetMaxX-2,' ');
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    GetSizeScreen                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetSizeScreen:Word;
Begin
 GetSizeScreen := GetSizeBox(0,0,GetMaxX,GetMaxY);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    RestoreScreen                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure RestoreScreen(Var Buffer);
Begin
 PutBox(0,0,GetMaxX,GetMaxY,Buffer);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SaveScreen                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure SaveScreen(Var Buffer);
Begin
 SaveBox(0,0,GetMaxX,GetMaxY,Buffer);
End;

                 (*** Object --> Screen Image ***)

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   ScreenImage.Init                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Constructor ScreenImage.Init;
Begin
 Size := 0; Buffer := Nil;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³               ScreenImage.GetScreen                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function ScreenImage.GetScreen:Boolean;
Begin
 Size := GetSizeScreen;
 If(MaxAvail < Size)Then GetScreen := False
  else
 Begin
  GetMem(Buffer,Size);
  SaveScreen(Buffer^);
  GetScreen := True;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                ScreenImage.Restore                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Destructor ScreenImage.Restore;
Begin
 If(Buffer <> NIL)Then
 Begin
  RestoreScreen(Buffer^);
  FreeMem(Buffer,Size);
 End;
End;

                    (*** Object --> Box Image ***)

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  BoxImage.BoxImage                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Constructor BoxImage.Init;
Begin
 Size := 0; Buffer := Nil;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BoxImage.GetBox                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function BoxImage.GetBox(X1,Y1,X2,Y2:Byte):Boolean;
Begin
 TX1 := X1; TY1 := Y1; TX2 := X2; TY2 := Y2;
 Size := GetSizeBox(X1,Y1,X2,Y2);
 If(MaxAvail < Size)Then GetBox := False
  else
 Begin
  GetMem(Buffer,Size);
  SaveBox(TX1,TY1,TX2,TY2,Buffer^);
  GetBox := True;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BoxImage.GetLine                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function BoxImage.GetLine(X1,Y,X2:Byte):Boolean;
Begin
 TX1 := X1; TY1 := Y; TX2 := X2; TY2 := Y;
 Size := GetSizeBox(X1,Y,X2,Y);
 If(MaxAvail < Size)Then GetLine := False
  else
 Begin
  GetMem(Buffer,Size);
  SaveBox(TX1,TY1,TX2,TY2,Buffer^);
  GetLine := True;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   BoxImage.Restore                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Destructor BoxImage.Restore;
Begin
 If(Buffer <> NIL)Then
 Begin
  PutBox(TX1,TY1,TX2,TY2,Buffer^);
  FreeMem(Buffer,Size);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  SetLuxeBorderSimple                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure SetLuxeBorderSimple;
Begin
 If(VC.EGA)or(VC.VGA)Then SetBorderFormat(BorderLuxeSimple)
		     Else SetBorderFormat(BorderSimple);
End;

BEGIN { Main Unit }
 FillChar(CloseIcon,SizeOf(CloseIcon),0);
 FillChar(ZoomIcon,SizeOf(ZoomIcon),0);
 FillChar(Border,SizeOf(Border),0);
END.
