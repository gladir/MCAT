(********************************************************)
(*                                                      *)
(*             Malte Catalog/File Extension             *)
(*                      1993/01/26                      *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit MCatFExt;

(********************************************************)
                      INTERFACE
(********************************************************)

Const

       EnglishFileNotFound       = 'File not found!';
       FrenchFileNotFound        = 'Fichier introuvable!';

       EnglishTitleInputDisk     = 'Disk';
       FrenchTitleInputDisk      = 'Disque';
       EnglishTitleDiskStatistic = 'Disk Statistic';
       FrenchTitleDiskStatistic  = 'Statistique du disque';
       EnglishTitleFileStatistic = 'Files Statistic';
       FrenchTitleFileStatistic  = 'Statistique des fichiers';

       EnglishReadDisk           = 'Please wait, reading disk...';
       FrenchReadDisk            = 'S.V.P. attendez, lecture du disque en cours...';

       English0Disk              = 'Get size disk free';
       French0Disk               = 'Lit l''espace disque disponible';
       English20Disk             = '';
       French20Disk              = '';
       English40Disk             = 'Get size disk used';
       French40Disk              = 'Lit l''espace disque utilis‚';
       English60Disk             = 'Get Volume';
       French60Disk              = 'Lecture du volume';
       English80Disk             = 'Search volume if exist in index';
       French80Disk              = 'Recherche l''existance du volume dans l''index';
       English100Disk            = 'Search files';
       French100Disk             = 'Recherche les fichiers';

Procedure GetDiskInfo(Drive:Byte);

(********************************************************)
                    IMPLEMENTATION
(********************************************************)

Uses DOS,OS,Handle,DString,StrTime,Text,LuxeVid,Window,LanWins,
     Level,Sound,KeyBoard,Input,InputExt,
     MCatFile,MCatIn,MCatWin,LanText,LanWin,LanDStr;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetDiskInfo                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure GetDiskInfo(Drive:Byte);
Label _DISKFREE;
Var Pattern      : SearchRec;
    MasterRecord : IndexType;
    _Record      : DiskInfoType;
    P,T,TS       : LongInt;
    Handle,Err   : Word;
    HandleFile   : Word;
    CDrive       : Char;
    CurPos       : LongInt;
    Path         : PathStr;
    Volume       : VolumeStr;
    Line2        : BoxImage;
    Retry        : Boolean;
    W            : LWins;

 Procedure GetMainRecord(Var Rec:IndexType);
 Label _DESCR,_VOLUME,_TIME,_EXIT;
 Const L = 72; H = 5; XP : Byte = 0;
 Var W       : LWins;
     _Record : IndexType;
     K       : Word;
 Begin
  W.LInitCenter(L,H,EnglishTitleInputDisk,FrenchTitleInputDisk,Level.Color.Window.Regular);
  _Record := Rec;
  SetColor(Color.Window.Regular.Msg);
  W.PutTypingXY(2,2,LStr(EnglishDescription + '|' + EnglishVolume + '|' + EnglishTime,
      		         FrenchDescription + '|' + FrenchVolume + '|' + FrenchTime));
  SetColor(Color.Window.Regular.Normal);
  W.PutTextXY(15,2,_Record.Description);
  W.PutTextXY(15,3,_Record.Volume);
  W.PutTextXY(15,4,StringTime(_Record.Time));
_DESCR:
  K := W.InputXY(15,2,_Record.Description);
  If(K = kbUp)Then Goto _TIME;
  If(K = kbEsc)or(K = kbEnter)Then Goto _EXIT;
_VOLUME:
  K := W.InputXY(15,3,_Record.Volume);
  If(K = kbUp)Then Goto _DESCR;
  If(K = kbEsc)or(K = kbEnter)Then Goto _EXIT;
_TIME:
  SetAllColor(Color.Window.Regular.Normal,Color.Window.Regular.Input);
  SetPos(W._X1+15,W._Y1+4);
  _InputTime(_Record.Time,XP,K);
  If(K = kbUp)Then Goto _VOLUME;
_EXIT:
  If(K <> kbEsc)Then Rec := _Record;
  W.Done;
 End;

 Procedure PutBarDisk(N:Byte;English,French:String);
 Var SN : String;
 Begin
  SN := Strg(N) + '%';
  BarSelectHori(5,5,5+Trunc((N * ((GetMaxX-10)/100))),$F0);
  WriteUnColor((GetMaxX-Length(SN)) shr 1,5,SN);
  WriteText(5,7,LStr(English,French)+Space(GetMaxX-(10+Length(
            LStr(English,French)))),Color.Window.Regular.Msg);
 End;

 Procedure PutBarFiles(N:Byte;Title:String);
 Var SN : String;
 Begin
  SN := Strg(N) + '%';
  BarSelectHori(5,12,5+Trunc((N * ((GetMaxX-8)/100))),$F0);
  WriteUnColor((GetMaxX-Length(SN)) shr 1,12,SN);
  WriteText(5,14,Title+Space(GetMaxX-(10+Length(Title))),
            Color.Window.Regular.Msg);
 End;

 Function SetVolume(Drive:Byte;Volume:VolumeStr):Boolean;
 Var S,P : PathStr;
 Begin
  S := FSearch('LABEL.EXE',GetEnv('PATH'));
  If(S = '')Then S := FSearch('LABEL.COM',GetEnv('PATH'));
  If(S = '')Then S := FSearch('VOL.EXE',GetEnv('PATH'));
  If(S = '')Then S := FSearch('VOL.COM',GetEnv('PATH'));
  If(S = '')Then
  Begin
   If(GetEnv('LABEL') <> '')Then
   Begin
    If(S = '')Then S := FSearch('LABEL.EXE',GetEnv('LABEL'));
    If(S = '')Then S := FSearch('LABEL.COM',GetEnv('LABEL'));
    If(S = '')Then S := FSearch('VOL.EXE',GetEnv('LABEL'));
    If(S = '')Then S := FSearch('VOL.COM',GetEnv('LABEL'));
   End;
  End;
  If(S = '')Then
  Begin
   If(GetEnv('VOL') <> '')Then
   Begin
    If(S = '')Then S := FSearch('LABEL.EXE',GetEnv('VOL'));
    If(S = '')Then S := FSearch('LABEL.COM',GetEnv('VOL'));
    If(S = '')Then S := FSearch('VOL.EXE',GetEnv('VOL'));
    If(S = '')Then S := FSearch('VOL.COM',GetEnv('VOL'));
   End;
  End;
  If(S = '')Then
  Begin
   If(GetEnv('VOLUME') <> '')Then
   Begin
    If(S = '')Then S := FSearch('LABEL.EXE',GetEnv('VOLUME'));
    If(S = '')Then S := FSearch('LABEL.COM',GetEnv('VOLUME'));
    If(S = '')Then S := FSearch('VOL.EXE',GetEnv('VOLUME'));
    If(S = '')Then S := FSearch('VOL.COM',GetEnv('VOLUME'));
   End;
  End;
  If(S <> '')Then
  Begin
   S := FExpand(S); P := DriveDOSToChar(Drive)+':'+Volume;
   {$M 8192, 0, 0 }
   Exec(S,P);
   {$M 16384, 32768, 131072 }
  End
   else
  Begin
   SetVolume := False;
   Exit;
  End;
  SetVolume := (DOSError = 0)
 End;

Begin
 Line2.Init;
 If(Line2.GetBox(0,1,GetMaxX,GetMaxY))Then
 Begin
  W._Init(3,3,GetMaxX-3,8,LStr(EnglishTitleDiskStatistic,
          FrenchTitleDiskStatistic),Level.Color.Window.Regular);
  W.BarSelectHori(2,1,W._X2-(W._X1+2),Color.Window.Regular.Input);
  Text.SwitchColor;
  W.LPutTextXY(1,3,English0Disk,French0Disk);
  W.Done;
  SetColor(Level.Color.EndBar.Normal);
  PutLastBar(2,LStr(EnglishReadDisk,FrenchReadDisk));
  Handle := Open(GetNameIndex,Normal);
  If(IsHandleError(Handle))Then Handle := New(GetNameIndex);
  CurPos := (FileSize(Handle) div SizeOf(MasterRecord));
  CDrive := DriveDOSToChar(Drive);
  FillChar(MasterRecord,SizeOf(MasterRecord),0);
_DISKFREE:
  MasterRecord.SizeFree := DiskFree(Drive);
  If(MasterRecord.SizeFree < 0)Then
  Begin
   Retry := LWinRetry('Read Error!','Error de lecture!');
   If(Retry)Then Goto _DISKFREE
    else
   Begin
    Close(Handle);
    Line2.Restore;
    Exit;
   End;
  End;
  PutBarDisk(40,English40Disk,French40Disk);
  MasterRecord.SizeUsed := DiskSize(Drive) - MasterRecord.SizeFree;
  PutBarDisk(60,English60Disk,French60Disk);
  FindFirst(CDrive+':\*.*',VolumeID,Pattern);
  If(DOSERROR = 0)Then
  Begin
   MasterRecord.Volume := Pattern.Name;
   MasterRecord.Time := Pattern.Time;
  End;
  PutBarDisk(80,English80Disk,French80Disk);
  If(SearchVolume(MasterRecord,T))Then { Volume Exist ? }
  Begin
   CurPos := T;
   If Not(LWinOverWrite('Volume Exist! OverWrite ?',
                        'Ce volume existe! Dois-je l''effacer ?'))Then
   Begin
    Line2.Restore;
    Exit;
   End;
  End;
  Volume := MasterRecord.Volume;
  GetMainRecord(MasterRecord);
  If(Volume <> MasterRecord.Volume)Then
  Begin
   If Not(SetVolume(Drive,MasterRecord.Volume))Then Beep;
  End;
  WriteUnColor(1,1,MasterRecord.Volume);
  HandleFile := New(GetNameDiskInfo(CurPos));
  P := 0;
  PutBarDisk(100,English100Disk,French100Disk);
  W._Init(3,10,GetMaxX-3,15,LStr(EnglishTitleFileStatistic,
          FrenchTitleFileStatistic),Level.Color.Window.Regular);
  W.BarSelectHori(2,2,W._X2-2,Color.Window.Regular.Input);
  W.Done;
  TS := 0;
  FindFirst(CDrive+':\*.*',$FFFF-VolumeID,Pattern);
  While (DOSERROR = 0) do
  Begin
    { Initialise les informations }
   FillChar(_Record,SizeOf(_Record),0);
   _Record.Path     := Pattern.Name;
   _Record.Size     := Pattern.Size;
   Inc(TS,_Record.Size);
   _Record.Time     := Pattern.Time;
   _Record.Attr     := Pattern.Attr;
   _Record.Category := 41;
    { Informe l'utilisateur des informations }
   WriteUnColor(GetMaxX-63,1,'³'+_Record.Path+Space(63-Length(_Record.Path)));
   PutBarFiles(Trunc((TS/MasterRecord.SizeUsed)*100),
               _Record.Path+Space(63-Length(_Record.Path)));
   Err := GetDiskInfoRecord(_Record,LStr('Get Technical Information',
                                         'Entrez les informations techniques'));
   SetRecord(HandleFile,P,SizeOf(_Record),_Record);
   FindNext(Pattern);
   Inc(P);
  End;
  If(P = 0)Then
  Begin
   WinNotFound(LStr(EnglishFileNotFound,FrenchFileNotFound));
  End;
  Close(HandleFile);
  MasterRecord.NumberFile := P;
  SetRecord(Handle,CurPos,SizeOf(MasterRecord),MasterRecord);
  Close(Handle);
 End
  else
 Beep;
 Line2.Restore;
End;

BEGIN { Main Unit }
END.