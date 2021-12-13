(********************************************************)
(*                                                      *)
(*                 Malte Catalog/Input                  *)
(*                     1993/01/24                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit MCatIn;

(********************************************************)
                        INTERFACE
(********************************************************)

Uses MCatFile;

Const

      EnglishTitleChoiceCategory = 'Category';        { Max 60 caractŠre! }
      FrenchTitleChoiceCategory  = 'Categorie';       { Max 60 caractŠre! }
      EnglishTitleHelpAttribut   = 'Help (Attribut)'; { Max 45 caractŠre! }
      FrenchTitleHelpAttribut    = 'Aide (Attribut)'; { Max 45 caractŠre! }
      EnglishDescription         = 'Description';     { Max 11 caractŠre! }
      FrenchDescription          = 'Description';     { Max 11 caractŠre! }
      EnglishVolume              = 'Volume';          { Max 11 caractŠre! }
      FrenchVolume               = 'Volume';          { Max 11 caractŠre! }
      EnglishNumberFile          = 'Number File';     { Max 11 caractŠre! }
      FrenchNumberFile           = 'Nombre';          { Max 11 caractŠre! }
      EnglishSizeUsed            = 'Size Used';       { Max 11 caractŠre! }
      FrenchSizeUsed             = 'Utilis‚';         { Max 11 caractŠre! }
      EnglishSizeFree            = 'Size Free';       { Max 11 caractŠre! }
      FrenchSizeFree             = 'Libre';           { Max 11 caractŠre! }
      EnglishTime                = 'Time';            { Max 11 caractŠre! }
      FrenchTime                 = 'Temps';           { Max 11 caractŠre! }
      EnglishPath                = 'Path';            { Max 11 caractŠre! }
      FrenchPath                 = 'R‚pertoire';      { Max 11 caractŠre! }
      EnglishSize                = 'Size';            { Max 11 caractŠre! }
      FrenchSize                 = 'Taille';          { Max 11 caractŠre! }
      EnglishAttr                = 'Attribut';        { Max 11 caractŠre! }
      FrenchAttr                 = 'Attribut';        { Max 11 caractŠre! }
      EnglishCategory            = 'Category';        { Max 11 caractŠre! }
      FrenchCategory             = 'Categorie';       { Max 11 caractŠre! }

       { Attribut }

      EnglishChoiceReadOnly      = '^R^ead Only';     { Max 14 caractŠre! }
      FrenchChoiceReadOnly       = '^P^rot‚g‚';       { Max 14 caractŠre! }
      EnglishChoiceHidden        = '^H^idden';        { Max 14 caractŠre! }
      FrenchChoiceHidden         = '^C^ach‚';         { Max 14 caractŠre! }
      EnglishChoiceVolume        = '^V^olume';        { Max 14 caractŠre! }
      FrenchChoiceVolume         = '^V^olume';        { Max 14 caractŠre! }
      EnglishChoiceSystem        = '^S^ystem';        { Max 14 caractŠre! }
      FrenchChoiceSystem         = '^S^ystŠme';       { Max 14 caractŠre! }
      EnglishChoiceDirectory     = '^D^irectory';     { Max 14 caractŠre! }
      FrenchChoiceDirectory      = '^R^‚pertoire';    { Max 14 caractŠre! }
      EnglishChoiceArchive       = '^A^rchive';       { Max 14 caractŠre! }
      FrenchChoiceArchive        = '^A^rchive';       { Max 14 caractŠre! }

Function GetCategory(Pos:Byte):Byte;
Function GetDiskInfoRecord(Var Rec:DiskInfoType;Title:String):Word;
Function GetIndexRecord(Var _Main:IndexType;Title:String):Word;
Function GetNewCategory:Byte;
Function GetNewDiskInfoRecord(Var _Record:DiskInfoType;Title:String):Word;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses DOS,Numeric,DString,StrTime,LanDOS,
     Text,LuxeVid,Window,Mouse,
     KeyBoard,Input,InputExt,Sound,Level,
     MCatStr,LanWin,LanText;

Function GetNewDiskInfoRecord(Var _Record:DiskInfoType;Title:String):Word;
Begin
 FillChar(_Record,SizeOf(_Record),0);
 _Record.Category := 41;
 GetNewDiskInfoRecord := GetDiskInfoRecord(_Record,Title);
End;

Function GetNewCategory:Byte;
Const Pos : Byte = 0;
Begin
 GetNewCategory := GetCategory(Pos);
End;

Function GetCategory(Pos:Byte):Byte;
Const

      LX     = 66; LY = 16;
      XMsg   = 4;  YMsg = 2;
      XMarge = 20;

Var

    Window                : LWindowType;
    Image                 : BoxImage;
    X1,Y1,X2,Y2,I,J,TX,TY : Byte;
    K,MB,MX,MY            : Word;

 Procedure PutBar(Color:Byte);
 Var X,Y,T : Byte;
 Begin
  If(Pos = 0)Then
  Begin
   X := 0; Y := 0;
  End
   else
  Begin
   X := Pos div 14; Y := Pos mod 14;
  End;
  BarSelectHori(X1+XMsg-2+(X*XMarge),Y1+YMsg+Y,
                X1+XMsg+XMarge-1+(X*XMarge),Color);
 End;

Begin
 X1 := (GetMaxX-LX) shr 1; X2 := X1 + LX;
 Y1 := ((GetMaxY-LY) shr 1)+1; Y2 := Y1 + LY;
 Image.Init;
 If(Image.GetBox(X1,Y1,X2+2,Y2+2))Then
 Begin
  Window.InitRegular;
  Window.NoZoom;
  Window.LPutWindow(X1,Y1,X2,Y2,EnglishTitleChoiceCategory,FrenchTitleChoiceCategory);
  Window.Done;
  SetColor(Color.Window.Regular.Msg);
  For I := 0 to 2 do For J := 0 to 13 do
  Begin
   _WriteText(X1+XMsg+I*XMarge,Y1+YMsg+J,StrCategory((I*14)+J));
  End;
  PutBar(Color.Window.Regular.Input);
  Repeat
   ShowPtr;
   Repeat
    GetButPos(MB,MX,MY);
    If(MB > 0)Then
    Begin
     MX := MX shr 3; MY := MY shr 3;
     If((MX >= X1)and(MX < X1 + Length(CloseIcon)))and(MY = Y1)Then
      Begin
       ReleaseKeyOrMoveMouse;
       HidePtr;
       Image.Restore;
       GetCategory := 254;
       Exit;
      End;
     If((MX >= (X1 + XMsg))and(MX <= (X2 - 4)))and
       ((MY >= (Y1 + 2))and(MY <= (Y2 - 1)))Then
     Begin
      HidePtr;
      PutBar(Color.Window.Regular.Msg);
      TX := (MX - (X1 + XMsg)) div XMarge;
      TY := MY - (Y1 + YMsg);
      Pos := TY + (TX * 14);
      PutBar(Color.Window.Regular.Input);
      ShowPtr;
      ReleaseKeyMouse;
      GetButPos(MB,MX,MY);
      MX := MX shr 3; MY := MY shr 3;
      If((MX >= (X1 + XMsg))and(MX <= (X2 - 4)))and
        ((MY >= (Y1 + 2))and(MY <= (Y2 - 1)))Then
      Begin
       TX := (MX - (X1 + XMsg)) div XMarge;
       TY := MY - (Y1 + YMsg);
       If(Pos = TY + (TX * 14))Then
       Begin
        HidePtr;
        Image.Restore;
        GetCategory := Pos;
        Exit;
       End
        else
       Begin
        HidePtr;
        Image.Restore;
        GetCategory := Pos or $80;
        Exit;
       End;
      End;
     End;
    End;
   Until KeyPressed;
   HidePtr;
   K := ReadKey;
   Case K of
      kbUp : Begin
              PutBar(Color.Window.Regular.Msg);
              If(Pos > 0)Then Dec(Pos) Else Pos := 41;
              PutBar(Color.Window.Regular.Input);
             End;
    kbDown : Begin
              PutBar(Color.Window.Regular.Msg);
              If(Pos < 41)Then Inc(Pos) Else Pos := 0;
              PutBar(Color.Window.Regular.Input);
             End;
    kbLeft : Begin
              PutBar(Color.Window.Regular.Msg);
              If(Pos > 13)Then Dec(Pos,14) Else Pos := 28 + (Pos mod 14);
              PutBar(Color.Window.Regular.Input);
             End;
   kbRight : Begin
              PutBar(Color.Window.Regular.Msg);
              If(Pos < 41-13)Then Inc(Pos,14) Else Pos := Pos mod 14;
              PutBar(Color.Window.Regular.Input);
             End;
    kbHome : Begin
              PutBar(Color.Window.Regular.Msg);
              Pos := 0;
              PutBar(Color.Window.Regular.Input);
             End;
     kbEnd : Begin
              PutBar(Color.Window.Regular.Msg);
              Pos := 41;
              PutBar(Color.Window.Regular.Input);
             End;
   End;
  Until (K = kbEsc)or(K = kbEnter)or(K = kbTab);
  If(K = kbEsc)Then GetCategory := 254 else
  If(K = kbTab)Then GetCategory := Pos or $80
               Else GetCategory := Pos;
 End
  else
 Begin
  GetCategory := 255;
  Beep;
 End;
 Image.Restore;
End;

Function GetIndexRecord(Var _Main:IndexType;Title:String):Word;
Label _DESCR,_VOLUME,_NUMBERFILE,_SIZEUSED,_SIZEFREE,_TIME,_EXIT;
Const

      L = 76; H = 8;
      XP : Byte = 0;

Var

    Image       : BoxImage;
    Window      : WindowType;
    X1,Y1,X2,Y2 : Byte;
    K           : Word;
    Key         : KeyInputType;
    Main        : IndexType;

Begin
 Main := _Main;
 X1 := (GetMaxX-L) shr 1; X2 := X1 + L;
 Y1 := (GetMaxY-H) shr 1; Y2 := Y1 + H;
 FillChar(Key,SizeOf(Key),0);
 Image.Init;
 If(Image.GetBox(X1,Y1,X2+2,Y2+1))Then
 Begin
  Window.InitRegular;
  Window.NoZoom;
  Window.PutWindow(X1,Y1,X2,Y2,Title);
  Window.Done;
  SetColor(Color.Window.Regular.Normal);
  LWriteTypingXY(X1+2,Y1+2,EnglishDescription + '|' + EnglishVolume + '|' +
                           EnglishNumberFile + '|' + EnglishSizeUsed + '|' +
                           EnglishSizeFree + '|' + EnglishTime,
                           FrenchDescription + '|' + FrenchVolume + '|' +
                           FrenchNumberFile + '|' + FrenchSizeUsed + '|' +
                           FrenchSizeFree + '|' + FrenchTime);
  _WriteText(X1+15,Y1+2,Main.Description);
  _WriteText(X1+15,Y1+3,Main.Volume);
  If(Main.NumberFile > 0)Then _WriteText(X1+15,Y1+4,Strg(Main.NumberFile));
  If(Main.SizeUsed > 0)Then _WriteText(X1+15,Y1+5,Strg(Main.SizeUsed));
  If(Main.SizeFree > 0)Then _WriteText(X1+15,Y1+6,Strg(Main.SizeFree));
  _WriteText(X1+15,Y1+7,StringTime(Main.Time));
_DESCR:
  SetAllColor(Color.Window.Regular.Normal,Color.Window.Regular.Input);
  _InputExtraXY(X1+15,Y1+2,Main.Description,60,Key,True,K);
  If(K = kbEnter)or(K = kbEsc)Then Goto _EXIT;
  If(K = kbUp)Then Goto _TIME;
_VOLUME:
  SetAllColor(Color.Window.Regular.Normal,Color.Window.Regular.Input);
  _InputExtraXY(X1+15,Y1+3,Main.Volume,12,Key,True,K);
  If(K = kbEnter)or(K = kbEsc)Then Goto _EXIT;
  If(K = kbUp)Then Goto _DESCR;
_NUMBERFILE:
  SetColor(Color.Window.Regular.Input);
  _InputSizeByteXY(X1+15,Y1+4,Main.NumberFile,True,K);
  BarSelectHori(X1+15,Y1+4,X1+15+59,Color.Window.Regular.Normal);
  If(K = kbEnter)or(K = kbEsc)Then Goto _EXIT;
  If(K = kbUp)Then Goto _VOLUME;
_SIZEUSED:
  SetColor(Color.Window.Regular.Input);
  _InputSizeByteXY(X1+15,Y1+5,Main.SizeUsed,True,K);
  BarSelectHori(X1+15,Y1+5,X1+15+59,Color.Window.Regular.Normal);
  If(K = kbEnter)or(K = kbEsc)Then Goto _EXIT;
  If(K = kbUp)Then Goto _NUMBERFILE;
_SIZEFREE:
  SetColor(Color.Window.Regular.Input);
  _InputSizeByteXY(X1+15,Y1+6,Main.SizeFree,True,K);
  BarSelectHori(X1+15,Y1+6,X1+15+59,Color.Window.Regular.Normal);
  If(K = kbEnter)or(K = kbEsc)Then Goto _EXIT;
  If(K = kbUp)Then Goto _SIZEUSED;
_TIME:
  SetPos(X1+15,Y1+7);
  SetAllColor(Color.Window.Regular.Normal,Color.Window.Regular.Input);
  _InputTime(Main.Time,XP,K);
  If(K = kbEnter)or(K = kbEsc)Then Goto _EXIT;
  If(K = kbUp)Then Goto _SIZEFREE;
  Goto _DESCR;
 End
  else
 Beep;
_EXIT:
 If(K <> kbEsc)Then _Main := Main;
 Image.Restore;
 GetIndexRecord := K;
End;

Function GetDiskInfoRecord(Var Rec:DiskInfoType;Title:String):Word;
Label _DESCR,_PATH,_SIZE,_TIME,_ATTRIBUT,_CATEGORY,_EXIT;
Const

      L = 72; H = 8;
      XInput = 15;
      XP : Byte = 0;

Var

    Image,ImageHelp  : BoxImage;
    Window           : WindowType;
    X1,Y1,X2,Y2,Attr : Byte;
    Key              : KeyInputType;
    K                : Word;
    Chn              : String;
    _Record          : DiskInfoType;

 Procedure PutHelpAttr(X,Y:Byte);
 Const L = 49; H = 4;
 Var Window : LWindowType;
 Begin
  SetAllColor($2B,$2F);
  Window.InitHelp;
  Window.NoZoom;
  Window.LPutWindow(X,Y,X+L,Y+H,EnglishTitleHelpAttribut,FrenchTitleHelpAttribut);
  Window.Done;
  Case Language of
    lgEnglish : WriteTypingXY(X+2,Y+2,EnglishChoiceReadOnly +
                                      Space(15-Length(EnglishChoiceReadOnly)) +
                                      EnglishChoiceHidden +
                                      Space(15-Length(EnglishChoiceHidden)) +
                                      EnglishChoiceSystem + '|' +
                                      EnglishChoiceVolume +
                                      Space(15-Length(EnglishChoiceVolume)) +
                                      EnglishChoiceDirectory +
                                      Space(15-Length(EnglishChoiceDirectory)) +
                                      EnglishChoiceArchive);
           else WriteTypingXY(X+2,Y+2,FrenchChoiceReadOnly +
                                      Space(15-Length(FrenchChoiceReadOnly)) +
                                      FrenchChoiceHidden +
                                      Space(15-Length(FrenchChoiceHidden)) +
                                      FrenchChoiceSystem + '|' +
                                      FrenchChoiceVolume +
                                      Space(15-Length(FrenchChoiceVolume)) +
                                      FrenchChoiceDirectory +
                                      Space(15-Length(FrenchChoiceDirectory)) +
                                      FrenchChoiceArchive);
  End;
 End;

Begin
 FillChar(Key,SizeOf(Key),0);
 _Record := Rec;
 X1 := (GetMaxX-(L+4)) shr 1; X2 := X1 + (L+4);
 Y1 := (GetMaxY-H) shr 1; Y2 := Y1 + H;
 If(Image.GetBox(X1,Y1,X2+2,Y2+1))Then
 Begin
  Window.InitRegular;
  Window.NoZoom;
  Window.PutWindow(X1,Y1,X2,Y2,Title);
  Window.Done;
  SetColor(Color.Window.Regular.Msg);
  LWriteTypingXY(X1+2,Y1+2,EnglishDescription + '|' +
                           EnglishPath + '|' +
                           EnglishSize + '|' +
                           EnglishTime + '|' +
                           EnglishAttr + '|' +
                           EnglishCategory,
                           FrenchDescription + '|' +
                           FrenchPath + '|' +
                           FrenchSize + '|'+
                           FrenchTime + '|' +
                           FrenchAttr + '|' +
                           FrenchCategory);
  SetColor(Color.Window.Regular.Normal);
  _WriteText(X1+XInput,Y1+2,_Record.Description);
  _WriteText(X1+XInput,Y1+3,_Record.Path);
  If(_Record.Size > 0)Then _WriteText(X1+XInput,Y1+4,Strg(_Record.Size));
  _WriteText(X1+XInput,Y1+5,StringTime(_Record.Time));
  _WriteText(X1+XInput,Y1+6,StrAttribut(_Record.Attr));
  _WriteText(X1+XInput,Y1+7,StrCategory(_Record.Category));
_DESCR:
  SetAllColor(Color.Window.Regular.Normal,Color.Window.Regular.Input);
  _InputExtraXY(X1+XInput,Y1+2,_Record.Description,60,Key,True,K);
  If(K = kbUp)Then Goto _CATEGORY;
  If(K = kbEsc)or(K = kbEnter)Then Goto _EXIT;
_PATH:
  SetAllColor(Color.Window.Regular.Normal,Color.Window.Regular.Input);
  _InputExtraXY(X1+XInput,Y1+3,_Record.Path,60,Key,True,K);
  If(K = kbUp)Then Goto _DESCR;
  If(K = kbEsc)or(K = kbEnter)Then Goto _EXIT;
_SIZE:
  SetColor(Color.Window.Regular.Input);
  _InputSizeByteXY(X1+XInput,Y1+4,_Record.Size,True,K);
  BarSelectHori(X1+XInput,Y1+4,X1+XInput+60-1,Color.Window.Regular.Normal);
  If(K = kbUp)Then Goto _PATH;
  If(K = kbEsc)or(K = kbEnter)Then Goto _EXIT;
_TIME:
  SetAllColor(Color.Window.Regular.Normal,Color.Window.Regular.Input);
  _InputTimeXY(X1+XInput,Y1+5,_Record.Time,XP,K);
  If(K = kbUp)Then Goto _SIZE;
  If(K = kbEsc)or(K = kbEnter)Then Goto _EXIT;
_ATTRIBUT:
  BarSelectHori(X1+XInput,Y1+6,X2-2,Color.Window.Regular.Input);
  ImageHelp.Init;
  If(ImageHelp.GetBox(X1+15,Y2+2,X1+15+51,Y2+2+5))Then
  Begin
   PutHelpAttr(X1+15,Y2+2);
  End;
  Repeat
   K := ReadKey;
   Attr := _Record.Attr;
   Case Language of
    lgEnglish : Case CharUpper(Char(Lo(K))) of
                 'R' : _Record.Attr := _Record.Attr xor DOS.ReadOnly;
                 'H' : _Record.Attr := _Record.Attr xor Hidden;
                 'S' : _Record.Attr := _Record.Attr xor SysFile;
                 'V' : _Record.Attr := _Record.Attr xor VolumeID;
                 'D' : _Record.Attr := _Record.Attr xor Directory;
                 'A' : _Record.Attr := _Record.Attr xor Archive;
                End;
           else Case CharUpper(Char(Lo(K))) of
                 'P' : _Record.Attr := _Record.Attr xor DOS.ReadOnly;
                 'C' : _Record.Attr := _Record.Attr xor Hidden;
                 'S' : _Record.Attr := _Record.Attr xor SysFile;
                 'V' : _Record.Attr := _Record.Attr xor VolumeID;
                 'R' : _Record.Attr := _Record.Attr xor Directory;
                 'A' : _Record.Attr := _Record.Attr xor Archive;
                End;
   End;
   If(_Record.Attr <> Attr)Then
   Begin
    Chn := StrAttribut(_Record.Attr);
    WriteUnColor(X1+XInput,Y1+6,Chn+Space(60-Length(Chn)));
   End;
  Until (K = kbEnter)or(K = kbEsc)or(K = kbDown)or
        (K = kbUp)or(K = kbTab);
  ImageHelp.Restore;
  BarSelectHori(X1+XInput,Y1+6,X2-2,Color.Window.Regular.Normal);
  If(K = kbUp)Then Goto _TIME;
  If(K = kbEnter)or(K = kbEsc)Then Goto _EXIT;
_CATEGORY:
  K := GetCategory(_Record.Category);
  If(K = 254)Then Goto _EXIT;
  If((K and $80) = $80)Then
  Begin
   _Record.Category := K xor $80;
   WriteText(X1+XInput,Y1+7,StrCategory(_Record.Category),Color.Window.Regular.Normal);
   Goto _DESCR;
  End;
  _Record.Category := K;
  K := kbEnter;
 End
  else
 Begin
  K := 0;
  Beep;
 End;
_EXIT:
 If(K = kbEnter)Then Rec := _Record;
 Image.Restore;
 GetDiskInfoRecord := K;
End;

BEGIN { Main Unit }
END.