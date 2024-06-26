(*******************************************************************)
(*                                                                 *)
(*                       Malte System/Window                       *)
(*                           1992/09/02                            *)
(*                                                                 *)
(*           Copyright (C) par les Chevaliers de Malte             *)
(*                                                                 *)
(*******************************************************************)

Unit Window;

(*******************************************************************)
                             INTERFACE
(*******************************************************************)

Uses LuxeVid;

 Type

      WindowType = Object
                    Color : Record
                             Border   : Byte;
                             Title    : Byte;
                             Icon     : Byte;
                             Msg      : Byte;
                             Key      : Byte;
                             KeyShade : Byte;                 
                             SelectA  : Byte;
                             SelectB  : Byte;
                             Shade    : Byte;
                            End;
                    OldKeyShade:Byte;
                    IconClose:StrIcon;
                    IconZoom:StrIcon;
                    Constructor Init;
                    Constructor InitError;
                    Constructor InitWarning;
                    Constructor InitRegular;
                    Constructor InitHelp;
                    Function RunKey(X,Y,JK:Byte;Key:String):Byte;
                    Procedure NoZoom;
                    Procedure PutMessage(X1,Y1,X2,Y2:Byte;Title,Msg:String);
		    Procedure PutWindow(X1,Y1,X2,Y2:Byte;Title:String);
                    Procedure PutWindowSmallShade(X1,Y1,X2,Y2:Byte;Title:String);
		    Function RunWarningMsg(Len:Byte;Title,Msg,Key:String):Byte;
		    Function RunErrorMsg(Len:Byte;Title,Msg,Key:String):Byte;
                    Destructor Done;
		   End;

	  LastBarType = Object
			 Len:Byte;
			 Size:Word;
			 Buffer:Pointer;
			 Constructor Init;
			 Function Message(Chn:String;Color:Byte):Byte;
			 Destructor Done;
			End;

(*******************************************************************)
                            IMPLEMENTATION
(*******************************************************************)

Uses DirecTxt,BiosText,Text,Message,KeyBoard,DString,Level,VidKey;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                  LastBarType.Init                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Constructor LastBarType.Init;
 Begin
  Size := 0; Len := 0; Buffer := NIL;
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                  LastBarType.Message                 넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Function LastBarType.Message(Chn:String;Color:Byte):Byte;
 Begin
  Len := Length(Chn); Size := GetSizeBox(2,0,2+Len,0);
  If(MaxAvail > Size)Then
  Begin
   GetMem(Buffer,Size);
   SaveBox(2,GetMaxY,2+Len,GetMaxY,Buffer^);
   WriteText(2,GetMaxY,Chn,Color);
   Message := 1;
  End
   else
  Message := 0;
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   LastBarType.Done                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Destructor LastBarType.Done;
 Begin
  If(Buffer <> NIL)Then
  Begin
   PutBox(2,GetMaxY,2+Len,GetMaxY,Buffer^);
   FreeMem(Buffer,Size);
  End;
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   WindowType.Init                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Constructor WindowType.Init;
 Begin
  OldKeyShade := VideoKey.ColorShade;
  If(GetFlagLuxeChar)Then
  Begin
   IconClose := CloseIcon;
   IconZoom  := ZoomIcon;
  End
   else
  Begin
   IconClose := ' - ';
   IconZoom  := ' '+#31+' ';
  End;
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                 WindowType.InitHelp                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Constructor WindowType.InitHelp;
 Begin
  OldKeyShade := VideoKey.ColorShade;
  Color.Border         := $2F;
  Color.Icon           := $0F;
  Color.Title          := $F2;
  Color.Msg            := $2F;
  Color.Key            := $F0;
  Color.SelectA        := $F2;
  Color.SelectB        := $FB;
  Color.Shade          := $28;
  VideoKey.ColorKey    := $F0;
  VideoKey.ColorShade  := $28;
  If(GetFlagLuxeChar)Then
  Begin
   IconClose := CloseIcon;
   IconZoom  := ZoomIcon;
  End
   else
  Begin
   IconClose := ' - ';
   IconZoom  := ' '+#31+' ';
  End;
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                 WindowType.InitError                 넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Constructor WindowType.InitError;
 Begin
  OldKeyShade := VideoKey.ColorShade;
  Color.Border        := Level.Color.Window.Error.Border;
  Color.Icon          := Level.Color.Window.Error.Icon;
  Color.Title         := Level.Color.Window.Error.Title;
  Color.Msg           := Level.Color.Window.Error.Msg;
  Color.Key           := Level.Color.Window.Error.Key;
  Color.SelectA       := Level.Color.Window.Error.SelectA;
  Color.SelectB       := Level.Color.Window.Error.SelectB;
  Color.Shade         := Level.Color.Window.Error.Shade;
  VideoKey.ColorKey   := Level.Color.Window.Error.Key;
  VideoKey.ColorShade := Level.Color.Window.Error.Shade;
  If(GetFlagLuxeChar)Then
  Begin
   IconClose := CloseIcon;
   IconZoom  := ZoomIcon;
  End
   else
  Begin
   IconClose := ' - ';
   IconZoom  := ' '+#31+' ';
  End;
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                 WindowType.InitWarning               넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Constructor WindowType.InitWarning;
 Begin
  OldKeyShade := VideoKey.ColorShade;
  Color.Border  := Level.Color.Window.Warning.Border;
  Color.Icon    := Level.Color.Window.Warning.Icon;
  Color.Title   := Level.Color.Window.Warning.Title;
  Color.Msg     := Level.Color.Window.Warning.Msg;
  Color.Key     := Level.Color.Window.Warning.Key;
  Color.SelectA := Level.Color.Window.Warning.SelectA;
  Color.SelectB := Level.Color.Window.Warning.SelectB;
  Color.Shade   := Level.Color.Window.Warning.Shade;
  VideoKey.ColorKey   := Level.Color.Window.Warning.Key;
  VideoKey.ColorShade := Level.Color.Window.Warning.Shade;
  If(GetFlagLuxeChar)Then
  Begin
   IconClose := CloseIcon;
   IconZoom  := ZoomIcon;
  End
   else
  Begin
   IconClose := ' - ';
   IconZoom  := ' '+#31+' ';
  End;
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                 WindowType.InitRegular               넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Constructor WindowType.InitRegular;
 Begin
  OldKeyShade := VideoKey.ColorShade;
  Color.Border  := Level.Color.Window.Regular.Border;
  Color.Icon    := Level.Color.Window.Regular.Icon;
  Color.Title   := Level.Color.Window.Regular.Title;
  Color.Msg     := Level.Color.Window.Regular.Msg;
  Color.Key     := Level.Color.Window.Regular.Key;
  Color.SelectA := Level.Color.Window.Regular.SelectA;
  Color.SelectB := Level.Color.Window.Regular.SelectB;
  Color.Shade   := Level.Color.Window.Regular.Shade;
  VideoKey.ColorKey   := Level.Color.Window.Regular.Key;
  VideoKey.ColorShade := Level.Color.Window.Regular.Shade;
  If(GetFlagLuxeChar)Then
  Begin
   IconClose := CloseIcon;
   IconZoom  := ZoomIcon;
  End
   else
  Begin
   IconClose := ' - ';
   IconZoom  := ' '+#31+' ';
  End;
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   WindowType.Done                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Destructor WindowType.Done;
 Begin
  VideoKey.ColorShade := OldKeyShade;
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   WindowType.NoZoom                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Procedure WindowType.NoZoom;
 Begin
  IconZoom := '';
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                  WindowType.PutWindow                넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Procedure WindowType.PutWindow(X1,Y1,X2,Y2:Byte;Title:String);
 Begin
  PutFillBorder(X1,Y1,X2,Y2,Color.Border);
  BarSpaceHori(X1+Length(IconClose),Y1,X2-Length(IconZoom),Color.Title);
  WriteText(X1,Y1,IconClose,Color.Icon);
  WriteText(X2+1-Length(IconZoom),Y1,IconZoom,Color.Icon);
  WriteUnColor(X1+Length(IconClose)-Length(IconZoom)+(((X2-X1)-(Length(Title)+
               Length(IconClose)-Length(IconZoom))) shr 1),Y1,Title);
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �            WindowType.PutWindowSmallShade            넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Procedure WindowType.PutWindowSmallShade(X1,Y1,X2,Y2:Byte;Title:String);
 Var OldShade : Boolean;
 Begin
  If(VC.Methode = ScrnDirect)Then OldShade := VD.Shade
                             Else OldShade := VB.Shade;
  SetBorderShade(False);
  PutWindow(X1,Y1,X2,Y2,Title);
  SetCube(X2+1,Y1,'�',Color.Shade);
  BarTextVert(X2+1,Y1+1,Y2,'�',Color.Shade);
  BarTextHori(X1+1,Y2+1,X2+1,'�',Color.Shade);
  SetBorderShade(OldShade);
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                WindowType.PutMessage                 넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Procedure WindowType.PutMessage(X1,Y1,X2,Y2:Byte;Title,Msg:String);
 Begin
  PutWindow(X1,Y1,X2,Y2,Title);
  SetColor(Color.Msg);
  _WMessage(X1+2,Y1+2,X2-2,Msg);
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                WindowType.RunErrorMsg                넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Function WindowType.RunErrorMsg(Len:Byte;Title,Msg,Key:String):Byte;
 Var L,X1,Y1,X2,Y2,MX,MY,LO2 : Byte;
 Begin
  MX  := GetMaxX shr 1; MY := GetMaxY shr 1;
  L   := GetLineWMessage(X1,X2,Msg) + 6;
  LO2 := (Length(Key) shr 1) + 2;
  X1  := MX - (Len shr 1); X2 := X1 + Len;
  Y1  := MY - (L shr 1);   Y2 := Y1 + L;
  PutMessage(X1,Y1,X2,Y2,Title,Msg);
  RunErrorMsg := RunKey(MX-LO2,Y2-2,(LO2 shl 1),Key);
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                  WindowType.RunKey                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Function WindowType.RunKey(X,Y,JK:Byte;Key:String):Byte;
 Var I,LK,NK : Byte;
     K       : Word;

  Function Search(Position:Byte):String;
  Var I,Start,Len,NC : Byte;
  Begin
   If(NK = 0)Then Search := Key
    else
   Begin
    I := 0; NC := 0;
    While(NC < Position) do
    Begin
     Inc(I);
     If(Key[I] = '|')Then Inc(NC);
    End;
    If(Position > 0)Then Inc(I);
    Start := I;
    While(Key[I] <> '|') do Inc(I);
    Len := I - Start - 1;
    Search := Copy(Key,Start,Len);
   End;
  End;

 Begin
  LK := JK - 3; NK := 0;
  For I := 1 to Length(Key) do If(Key[I] = '|')Then Inc(NK);
  For I := 0 to NK do _PutVideoKeyText(X+I*JK,Y,X+I*JK+LK,Search(I));
  I := 0;
  Repeat
   Repeat
    If((Mem[$0040:$6C] and $F) = $4)Then BarSelectHori(X+I*JK,Y,X+I*JK+LK,Color.SelectA) else
    If((Mem[$0040:$6C] and $F) = $D)Then BarSelectHori(X+I*JK,Y,X+I*JK+LK,Color.SelectB);
   Until KeyPressed;
   K := ReadKey;
   Case K of
    kbEsc : Begin
	     RunKey := 255;
	     Exit;
            End;
   kbLeft : If(NK > 0)Then
            Begin
	     BarSelectHori(X+I*JK,Y,X+I*JK+LK,Color.Key);
	     If(I > 0)Then Dec(I) else I := NK;
	     If((Mem[$0040:$6C] and $F) = $4)Then
	     Begin
	      BarSelectHori(X+I*JK,Y,X+I*JK+LK,Color.SelectA);
	     End
              else
             BarSelectHori(X+I*JK,Y,X+I*JK+LK,Color.SelectB);
	    End;
  kbRight : If(NK > 0)Then
            Begin
	     BarSelectHori(X+I*JK,Y,X+I*JK+LK,Color.Key);
	     If(I < NK)Then Inc(I) else I := 0;
	     If((Mem[$0040:$6C] and $F) = $4)Then
	     Begin
	      BarSelectHori(X+I*JK,Y,X+I*JK+LK,Color.SelectA);
	     End
              else
             BarSelectHori(X+I*JK,Y,X+I*JK+LK,Color.SelectB);
	    End;
   End;
  Until (K = kbEnter);
  RunKey := I;
 End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                WindowType.RunWarningMsg              넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

 Function WindowType.RunWarningMsg(Len:Byte;Title,Msg,Key:String):Byte;
 Const HeightBar = 1; LenBarToMsg = 1; LenMsgToKey = 1;
 Var L,X1,Y1,X2,Y2,XS,YS,MX,MY,NK,JK,I : Byte;
 Begin
  MX := GetMaxX shr 1;    MY := GetMaxY shr 1;
  X1 := MX - (Len shr 1); X2 := X1 + Len;
  L  := GetLineWMessage(X1,X2,Msg) + HeightBar + LenBarToMsg + LenMsgToKey + 2;
  Y1 := MY - (L shr 1); Y2 := Y1 + L;
  XS := (X2 - X1) + 1;  YS := L; NK := 0;
  For I := 1 to Length(Key) do If(Key[I] = '|')Then Inc(NK);
  JK := (XS-4) div (NK + 1);
  PutMessage(X1,Y1,X2,Y2,Title,Msg);
  RunWarningMsg := RunKey(X1+2,Y2-2,JK,Key);
 End;

BEGIN
END.