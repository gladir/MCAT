(********************************************************)
(*                                                      *)
(*                Malte Catalog/View files              *)
(*                      1993/05/11                      *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit MCatVFiles;

(********************************************************)
                        INTERFACE
(********************************************************)

Procedure ViewFiles(Pos:LongInt);

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses
     {$IFDEF __MOUSE__}
      Mouse,
     {$ENDIF}

     Dir,DOS,Sound,KeyBoard,Handle,StrTime,DString,
     LanDStr,Level,Text,LanNText,LanText,LanWin,LuxeVid,
     Numeric,NumWin,Window,MCatStr,MCatFile,MCatIn,
     MCatWin,MCatPrn;

{$I MCATCML.INC} { Central Message Library }

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      ViewFiles                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure ViewFiles(Pos:LongInt);
Const L = 76; H = 14; XP : Byte = 0;
Var Image,Line2          : BoxImage;
    Window               : LWindowType;
    X1,Y1,X2,Y2,YP,MX,MY : Byte;
    K,MB                 : Word;
    P,EndItem            : LongInt;
    _File                : DiskInfoType;

 Procedure _PutItem(YP:Byte;_File:DiskInfoType);
 Begin
  Case XP of
   0 : Begin
        WriteUnColor(X1+2,Y1+3+YP,Copy(_File.Path,1,12)+Space(13-Length(_File.Path)));
        WriteUnColor(X1+15,Y1+3+YP,Copy(StrgTo(_File.Size,9),1,9)+'  ');
        WriteUnColor(X1+26,Y1+3+YP,StringTime(_File.Time)+'  ');
        WriteUnColor(X1+47,Y1+3+YP,StrCategory(_File.Category)+
                     Space(27-Length(StrCategory(_File.Category))));
       End;
   1 : Begin
        WriteUnColor(X1+2,Y1+3+YP,Copy(_File.Description,1,L-2)+
                                   Space(L-2-Length(_File.Description)));
       End;
  End;
 End;

 Procedure PutItem(YP:Byte;P:LongInt);
 Var Err      : Word;
     DiskInfo : DiskInfoType;
 Begin
  Err := GetFile(GetNameDiskInfo(Pos),P,SizeOf(DiskInfo),DiskInfo);
  _PutItem(YP,DiskInfo);
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
  If(EndItem < 0)Then Exit;
  PutBar(YP,Level.Color.Window.Regular.Normal);
  P := 0; YP := 0;
  Handle := Open(GetNameDiskInfo(Pos),ReadOnly);
  Max := EndItem;
  If(Max > 10)Then Max := 10;
  For I := 0 to Max do
  Begin
   GetRecord(Handle,I,SizeOf(_File),_File);
   _PutItem(I,_File);
  End;
  Close(Handle);
  PutBar(YP,Level.Color.Window.Regular.Input);
 End;

 Procedure _End;
 Var Handle : Word;
     I      : Byte;
     Max    : LongInt;
 Begin
  If(EndItem > 10)Then
  Begin
   PutBar(YP,Level.Color.Window.Regular.Normal);
   P := EndItem; YP := 10;
   Handle := Open(GetNameDiskInfo(Pos),ReadOnly);
   Max := EndItem;
   If(Max > 10)Then Max := 10;
   For I := 0 to Max do
   Begin
    GetRecord(Handle,EndItem-I,SizeOf(_File),_File);
    _PutItem(10-I,_File);
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

 Procedure Edit;
 Var A,B : DiskInfoType;
     Err : Word;
 Begin
  FillChar(A,SizeOf(A),0);
  FillChar(B,SizeOf(B),0);
  MCatFile.GetDiskInfoRecord(Pos,P,A);
  B := A;
  If(GetDiskInfoRecord(A,LStr('Edit','Edite')) = kbEsc)Then Exit;
  If Not(RecordDiskInfoIdentical(A,B))Then
  Begin
   SetDiskInfoRecord(Pos,P,A);
   _PutItem(YP,A);
  End;
 End;

 Procedure PutTo;
 Var Handle  : Word;
     I,Max   : Byte;
 Begin
  Max := 10;
  If(EndItem < 10)Then
  Begin
   PutBar(YP,Level.Color.Window.Regular.Normal);
   Max := EndItem; YP := P;
   PutBar(YP,Level.Color.Window.Regular.Input);
   Handle := Open(GetNameDiskInfo(Pos),ReadOnly);
   For I := 0 to Max do
   Begin
    GetRecord(Handle,P+I-YP,SizeOf(_File),_File);
    _PutItem(I,_File);
   End;
   Close(Handle);
  End
   else
  If(EndItem < 10 + P)Then
  Begin
   PutBar(YP,Level.Color.Window.Regular.Normal);
   YP := 10;
   PutBar(YP,Level.Color.Window.Regular.Input);
   Handle := Open(GetNameDiskInfo(Pos),ReadOnly);
   For I := 0 to Max do
   Begin
    GetRecord(Handle,P+I-YP,SizeOf(_File),_File);
    _PutItem(I,_File);
   End;
   Close(Handle);
  End;
 End;

 Procedure Search;
 Var Main,_Main : DiskInfoType;
     I          : LongInt;
     Ok         : Boolean;
     Handle,K   : Word;
     Line2      : BoxImage;
 Begin
  FillChar(Main,SizeOf(Main),0);
  K := GetDiskInfoRecord(Main,LStr('Search','Recherche'));
  If(K = kbEsc)Then Exit;
  I := -1; Ok := False;
  Handle := Open(GetNameDiskInfo(Pos),ReadOnly);
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
      ((NameIdentical(Main.Path,_Main.Path))and(Main.Path <> ''))or
      ((Main.Attr = _Main.Attr)and(Main.Attr > 0))or
      ((Main.Size = _Main.Size)and(Main.Size > 0))or
      (Main.Category = _Main.Category)or
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

 Procedure Header;
 Begin
  Case XP of
   0 : Begin
        LWriteText(X1+2,Y1+1,'Path          Size       Time                Category',
                   'R‚pertoire    Taille     Temps               Categorie',$9E);
        WriteText(X1+1,Y1+2,'ÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',
                  Level.Color.Window.Regular.Normal);
       End;
   1 : Begin
        WriteText(X1+2,Y1+1,'Description'+Space(L-2-Length('Description')),$9E);
        WriteText(X1+2,Y1+2,MultChar(Byte('Ä'),L-2),Level.Color.Window.Regular.Normal);
       End;
  End;
 End;

Begin
 If(DiskInfoEmpty(Pos))Then { Disk info vide ? }
 Begin
  WinNotFound(LStr(errmsgEnglishDiskInfoEmpty,errmsgFrenchDiskInfoEmpty));
  Exit;
 End;
 EndItem := GetMaxDiskInfo(Pos);
 GetSizeWindowCenter(L,H,X1,Y1,X2,Y2);
 Image.Init;
 If(Image.GetBox(X1,Y1,X2+2,Y2+1))Then
 Begin
  Line2.Init;
  If(Line2.GetLine(0,GetMaxY,GetMaxX))Then
  Begin
   Window.InitRegular;
   Window.NoZoom;
   Window.LPutWindow(X1,Y1,X2,Y2,EnglishTitleViewFiles,FrenchTitleViewFiles);
   Window.Done;
   SetAllColor(Level.Color.EndBar.HighLetter,Level.Color.EndBar.Normal);
   WriteTypingXY(3,GetMaxY,LStrTypToTypSpc(
      '^F4^ Edit  ^F7^ Search  ^F8^ Delete  ^Ctrl-F5^ Print list',
      '^F4^ Edite  ^F7^ Recherche  ^F8^ Efface  ^Ctrl-F5^ Imprime liste',
      GetMaxX-3-2));
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
        If(MX >= 3)and(MX < 3 + Length('F4 Edit'))Then
        Begin
         ReleaseKeyMouse;
         HidePtr;
         Edit;
         ShowPtr;
        End;
       End;
       If IsCloseIcon(X1,Y1,MX,MY)Then
       Begin
        HidePtr;
        ReleaseKeyMouse;
        Line2.Restore;
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
kbCtrlF5 : PrintListDiskInfo(Pos);
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
     kbF4 : Edit;
     kbF7 : Search;
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
                MCatFile.GetDiskInfoRecord(Pos,P,_File);
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
               If(YP < 10)Then
               Begin
                If(YP < EndItem)Then
                Begin
                 PutBar(YP,Level.Color.Window.Regular.Normal);
                 Inc(YP); Inc(P);
                 PutBar(YP,Level.Color.Window.Regular.Input);
                 MCatFile.GetDiskInfoRecord(Pos,P,_File);
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
  Line2.Restore;
 End
  else
 Beep;
 Image.Restore;
End;

BEGIN { Main Unit }
END.