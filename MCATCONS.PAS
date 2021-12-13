(********************************************************)
(*                                                      *)
(*              Malte Catalog/Consultation              *)
(*                      1993/05/10                      *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit MCatConsultation;

(********************************************************)
                        INTERFACE
(********************************************************)

Procedure Consultation;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses
     {$IFDEF __MOUSE__}
      Mouse,
     {$ENDIF}

     Dir,DOS,Sound,KeyBoard,Handle,StrTime,DString,
     LanDStr,Level,Text,LanText,LuxeVid,NumWin,Window,
     Numeric,MCatFile,MCatIn,MCatWin,MCatStr,MCatVFiles,
     MCatPrn;

{$I MCATCML.INC} { Central Message Library }

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     Consulation                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Consultation;
Const L = 68; H = 19; XP : Byte = 0;
Var X1,Y1,X2,Y2        : Byte;
    Image              : BoxImage;
    Window             : WindowType;
    K,P,MB,NB          : Word;
    I,J,YP,MX,MY,NX,NY : Byte;
    Main               : IndexType;
    EndItem            : LongInt;

 Procedure _PutDescr(Main:IndexType);
 Begin
  If(Main.Description = '')Then Main.Description := LStr(MsgEnglishNone,MsgFrenchNone);
  WriteUnColor(2,1,Main.Description+Space(77-Length(Main.Description)));
 End;

 Procedure _PutItem(YP:Byte;Main:IndexType);
 Begin
  Case XP of
   0 : Begin
        _PutDescr(Main);
        WriteUnColor(X1+2,Y1+3+YP,Main.Volume+Space(13-Length(Main.Volume)));
        WriteUnColor(X1+15,Y1+3+YP,Copy(StrgTo(Main.SizeUsed,9),1,9)+'  ');
        WriteUnColor(X1+26,Y1+3+YP,Copy(StrgTo(Main.SizeFree,9),1,9)+'  ');
        WriteUnColor(X1+37,Y1+3+YP,Copy(StrgTo(Main.NumberFile,8),1,8)+'  ');
        WriteUnColor(X1+48,Y1+3+YP,StringTime(Main.Time));
       End;
   1 : Begin
        If(Main.Description = '')Then Main.Description := LStr(MsgEnglishNone,MsgFrenchNone);
        WriteUnColor(X1+2,Y1+3+YP,Copy(Main.Description,1,L-2)+Space(L-2-Length(Main.Description)));
       End;
  End;
 End;

 Procedure PutItem(YP:Byte;P:LongInt);
 Var Err  : Word;
     Main : IndexType;
 Begin
  Err := GetFile(_PathIndex+_FileName,P,SizeOf(Main),Main);
  _PutItem(YP,Main);
 End;

 Procedure PutBar(Y,Color:Byte);
 Begin
  BarSelectHori(X1+1,Y1+3+Y,X2-1,Color);
 End;

 Procedure Home;
 Var Handle : Word;
     I      : Byte;
     Max    : LongInt;
 Begin
  If(IndexEmpty)Then Exit;
  PutBar(YP,Level.Color.Window.Regular.Normal);
  P := 0; YP := 0;
  Handle := Open(GetNameIndex,ReadOnly);
  Max := EndItem;
  If(Max > 15)Then Max := 15;
  For I := 0 to Max do
  Begin
   GetRecord(Handle,I,SizeOf(Main),Main);
   _PutItem(I,Main);
  End;
  Close(Handle);
  ClearWindow(X1+1,Y1+3+Max+1,X2-1,Y2-1,Level.Color.Window.Regular.Normal);
  PutBar(YP,Level.Color.Window.Regular.Input);
 End;

 Procedure PutTo;
 Var Handle  : Word;
     I,Max   : Byte;
 Begin
  Max := 15;
  If(EndItem < 15)Then
  Begin
   PutBar(YP,Level.Color.Window.Regular.Normal);
   YP := P; Max := EndItem;
   PutBar(YP,Level.Color.Window.Regular.Input);
   Handle := Open(GetNameIndex,ReadOnly);
   For I := 0 to Max do
   Begin
    GetRecord(Handle,P+I-YP,SizeOf(Main),Main);
    _PutItem(I,Main);
   End;
   Close(Handle);
  End
   else
  If(EndItem < 15 + P)Then
  Begin
   PutBar(YP,Level.Color.Window.Regular.Normal);
   YP := 15;
   PutBar(YP,Level.Color.Window.Regular.Input);
   Handle := Open(GetNameIndex,ReadOnly);
   For I := 0 to Max do
   Begin
    GetRecord(Handle,P+I-YP,SizeOf(Main),Main);
    _PutItem(I,Main);
   End;
   Close(Handle);
  End;
 End;

 Procedure _End;
 Var Handle : Word;
     I      : Byte;
     Max    : LongInt;
 Begin
  If(EndItem > 15)Then
  Begin
   PutBar(YP,Level.Color.Window.Regular.Normal);
   P := EndItem; YP := 15;
   Handle := Open(GetNameIndex,ReadOnly);
   Max := EndItem;
   If(Max > 15)Then Max := 15;
   For I := 0 to Max do
   Begin
    GetRecord(Handle,EndItem-I,SizeOf(Main),Main);
    _PutItem(15-I,Main);
   End;
   Close(Handle);
   PutBar(YP,Level.Color.Window.Regular.Input);
  End
   else
  Begin
   PutBar(YP,Level.Color.Window.Regular.Normal);
   YP := EndItem; P := EndItem;
   PutBar(YP,Level.Color.Window.Regular.Input);
  End;
 End;

 Procedure Search;
 Var Main,_Main : IndexType;
     I          : LongInt;
     Ok         : Boolean;
     Handle,K   : Word;
     Line2      : BoxImage;
 Begin
  FillChar(Main,SizeOf(Main),0);
  K := GetIndexRecord(Main,LStr('Search','Recherche'));
  If(K = kbEsc)Then Exit;
  I := -1; Ok := False;
  Handle := Open(GetNameIndex,ReadOnly);
  Line2.Init;
  If(Line2.GetLine(0,GetMaxY,GetMaxX))Then
  Begin
   SetAllColor(Level.Color.EndBar.HighLetter,Level.Color.EndBar.Normal);
   LWriteTypingXY(3,GetMaxY,'^Esc^ Cancel ³ Search record...',
    '^Esc^ Annule ³ Recherche l''enregistrement en cours...');
   Repeat
    Inc(I);
    If(I > EndItem)Then
    Begin
     Close(Handle);
     WinNotFound(LStr(errmsgEnglishRecordNotFound,errmsgFrenchRecordNotFound));
     Line2.Restore;
     Exit;
    End;
    FillChar(_Main,SizeOf(_Main),0);
    GetRecord(Handle,I,SizeOf(_Main),_Main);
    If((Main.Description = _Main.Description)and(Main.Description <> ''))or
      ((Main.Volume = _Main.Volume)and(Main.Volume <> ''))or
      ((Main.NumberFile = _Main.NumberFile)and(Main.NumberFile > 0))or
      ((Main.SizeUsed = _Main.SizeUsed)and(Main.SizeUsed > 0))or
      ((Main.SizeFree = _Main.SizeFree)and(Main.SizeFree > 0))or
      ((Main.Time = _Main.Time)and(Main.Time <> 0))Then Ok := True;
    If(KeyPressed)Then
    Begin
     If(ReadKey = kbEsc)Then
     Begin
      If Not(LWinContinue(warmsgEnglishContinueSearch,warmsgFrenchContinueSearch))Then
      Begin
       Close(Handle);
       Line2.Restore;
       Exit;
      End;
     End;
    End;
   Until Ok;
   Close(Handle);
   P := I;
   PutTo;
  End
   else
  Beep;
  Line2.Restore;
 End;

 Procedure Edit;
 Var _Main,Main : IndexType;
     Err        : Word;
 Begin
  FillChar(Main,SizeOf(Main),0);
  FillChar(_Main,SizeOf(_Main),0);
  MCatFile.GetIndexRecord(P,Main);
  _Main := Main;
  If(GetIndexRecord(Main,LStr('Edit','Edite')) = kbEsc)Then Exit;
  If Not(RecordIndexIdentical(_Main,Main))Then
  Begin
   SetIndexRecord(P,Main);
   _PutItem(YP,Main);
  End;
 End;

 Procedure DelIndexRecord(Pos:LongInt);
 Var HandleTmp,Handle,Err : Word;
     PathTmp,Path         : PathStr;
     I,J,Max              : LongInt;
     Index                : IndexType;
 Begin
  Max := GetMaxIndex;
  PathTmp := _PathTmp + PathToName(_FileName) + '.$$$';
  Path := GetNameIndex;
  If(FileExist(PathTmp))Then Err := Del(PathTmp);
  HandleTmp := New(PathTmp);
  Handle := Open(Path,Normal);
  For I := 0 to (Pos - 1) do
  Begin
   GetRecord(Handle,I,SizeOf(Index),Index);
   SetRecord(HandleTmp,I,SizeOf(Index),Index);
  End;
  Err := Del(GetNameDiskInfo(Pos));
  If(Pos < Max)Then
  Begin
   For I := Pos to Max-1 do
   Begin
    Rename(GetNameDiskInfo(I+1),GetNameDiskInfo(I));
    GetRecord(Handle,I+1,SizeOf(Index),Index);
    SetRecord(HandleTmp,I,SizeOf(Index),Index);
   End;
  End;
  Close(Handle);
  Close(HandleTmp);
  Err := Del(Path);
  Rename(PathTmp,Path);
 End;

 Procedure Header;
 Begin
  Case XP of
   0 : Begin
        LWriteText(X1+2,Y1+1,'Volume        Used       Free       File      Time',
                             'Volume        Utilis‚    Libre      Fichier   Temps',$9E);
        WriteText(X1+1,Y1+2,'ÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',
                  Level.Color.Window.Regular.Normal);
       End;
   1 : Begin
        WriteText(X1+2,Y1+1,'Description'+Space(L-2-Length('Description')),$9E);
        WriteText(X1+2,Y1+2,MultChar(Byte('Ä'),L-2),Level.Color.Window.Regular.Normal);
       End;
  End;
 End;

Begin
 If(IndexEmpty)Then { Index vide ? }
 Begin
  WinNotFound(LStr(errmsgEnglishIndexEmpty,errmsgFrenchIndexEmpty));
  Exit;
 End;
 EndItem := GetMaxIndex;
 GetSizeWindowCenter(L,H,X1,Y1,X2,Y2); P := 0;
 If(Image.GetBox(X1,Y1,X2+2,Y2+1))Then
 Begin
  Window.InitRegular;
  Window.NoZoom;
  Window.PutWindow(X1,Y1,X2,Y2,'Consultation (Index)');
  Window.Done;
  SetAllColor(Level.Color.EndBar.HighLetter,Level.Color.EndBar.Normal);
  LWriteTypingXY(3,GetMaxY,
   '^F3^ View files  ^F4^ Edit  ^F7^ Search  ^F8^ Delete  ^Ctrl-F5^ Print List',
   '^F3^ Regarde fichiers ^F4^ Edite  ^F7^ Recherche  ^F8^ Efface  ^Ctrl-F5^ Imprime liste');
  Header;
  Home;
  Repeat
   {$IFDEF __MOUSE__}
    ShowPtr;
    Repeat
     GetButTPos(MB,MX,MY);
     If(MB > 0)Then
     Begin
      If(MY = GetMaxY)Then
      Begin
       If(MX >= 3)and(MX < 3 + Length('F3 View files'))Then
       Begin
        ReleaseKeyMouse;
        HidePtr;
        ViewFiles(P);
        ShowPtr;
       End;
      End;
      If IsCloseIcon(X1,Y1,MX,MY)Then
      Begin
       HidePtr;
       ReleaseKeyMouse;
       Image.Restore;
       Exit;
      End;
      If IsExitIcon(MX,MY)Then
      Begin
       HidePtr;
       ReleaseKeyMouse;
       Halt;
       ShowPtr;
      End;
      If(MX >= (X1+2))and(MX <= (X2-2))Then
      Begin
      End;
     End;
    Until KeyPressed;
    HidePtr;
   {$ENDIF}
   K := ReadKey;
   Case K of
  kbLeft : If(XP = 1)Then
           Begin
            XP := 0;
            Header;
            PutTo;
           End;
 kbRight : If(XP = 0)Then
           Begin
            XP := 1;
            Header;
            PutTo;
           End;
   kbTab : Begin
            XP := MaxByte(XP,1);
            Header;
            PutTo;
           End;
    kbF3 : ViewFiles(P);
    kbF4 : Edit;
    kbF7 : Search;
    kbF8 : Begin
            DelIndexRecord(P);
            Dec(EndItem);
            Home;
           End;
kbCtrlF5 : PrintListIndex;
  kbHome : If(P > 0)Then Home;
   kbEnd : If(P < EndItem)Then _End;
    kbUp : Begin
            If(EndItem > 0)Then
            Begin
             If(P > 0)Then
             Begin
              If(YP > 0)Then
              Begin
               PutBar(YP,Level.Color.Window.Regular.Normal);
               Dec(YP); Dec(P);
               PutBar(YP,Level.Color.Window.Regular.Input);
               MCatFile.GetIndexRecord(P,Main);
               _PutDescr(Main);
              End
               else
              Begin
               Dec(P);
               MoveTextDown(X1+2,Y1+3,X2-2,Y2-1);
               PutItem(YP,P);
              End;
             End;
            End;
           End;
  kbDown : Begin
            If(EndItem > 0)Then
            Begin
             If(P < EndItem)Then
             Begin
              If(YP < 15)Then
              Begin
               If(YP < EndItem)Then
               Begin
                PutBar(YP,Level.Color.Window.Regular.Normal);
                Inc(YP); Inc(P);
                PutBar(YP,Level.Color.Window.Regular.Input);
                MCatFile.GetIndexRecord(P,Main);
                _PutDescr(Main);
               End;
              End
               else
              Begin
               Inc(P);
               MoveTextUp(X1+2,Y1+3,X2-2,Y2-1);
               PutItem(YP,P);
              End;
             End;
            End;
           End;
   End;
  Until (K = kbEsc);
 End
  else
 Beep;
 Image.Restore;
End;

BEGIN { Main Unit }
END.