(*******************************************************************)
(*                                                                 *)
(*                  Malte System/Operating System                  *)
(*                          1992/09/01                             *)
(*                                                                 *)
(*           Copyright (C) par les Chevaliers de Malte             *)
(*                                                                 *)
(*******************************************************************)

{ Programmeur :

   Sylvain Maltais

  DerniŠre modification :

   Dimanche, le 9 mai 1993  (UpDate : (GetTable, GetVolumeBuffer)
                             de SetTable),
			    (Debug : GetDiskSerialNumber).
   Jeudi, le 13 mai 1993    (Addition : Sleep).
                            (UpDate for Windows : GetPath).
   Dimanche, le 23 mai 1993 (Addition : GetDriveDOS, GetDriveNumeric).
   Dimanche, le 27 juin 1993 (Addition : GetTimer, DiffTime).

  Directive de compilation coinditionnel :

   WINDOWS                  Indique qu'il tourne sous d'environnement
                            Windows. (Pr‚d‚finit par le Turbno Pascal
			    for Windows).
   WITHPChar                Indique qu'il doit fonction avec des
                            variables PChar.
}

Unit OS;

(*******************************************************************)
                              INTERFACE
(*******************************************************************)

{$IFDEF WITHPChar}
 Uses Strings,WinDOS;

 Type

      PathStr = PChar;
      NameStr = PChar;
      DirStr  = PChar;
      ExtStr  = PChar;

{$ELSE}
 Uses DOS;
{$ENDIF}

 Type
       TimeType = (H12,H24);
       VolumeStr = String[12];
       StrVolume = VolumeStr;

       CountryType = Record
                      CO_DATE      : Word;
                      CO_CURR      : String[5];
                      CO_THSEP     : String[2];
                      CO_DESEP     : String[2];
                      CO_DTSEP     : String[2];
                      CO_TMSEP     : String[2];
                      CO_CURRSTYLE : Byte;
                      CO_DIGITS    : Byte;
                      CO_TIME      : TimeType;
                      CO_DASEP     : String[2];
                     End;

        FileInfoType = Record
                        Size         : LongInt;
                        SizeArchive  : LongInt;
                        SizeHidden   : LongInt;
                        SizeReadOnly : LongInt;
                        SizeSystem   : LongInt;
                        NumberFile   : LongInt;
                        NumberSector : LongInt;
                        ArchiveFile  : LongInt;
                        HiddenFile   : LongInt;
                        ReadOnlyFile : LongInt;
                        SystemFile   : LongInt;
                        Directory    : LongInt;
                       End;

       BootSectorType = Record
                         NameConstructor  : String[8];
                         Media            : Byte;
                         SizeFAT          : LongInt;
                         SizeTrack        : LongInt;
                         SizeCluster      : LongInt;
                         SizeSector       : Word;
                         Sector           : Word;
                         SectorReserved   : Word;
                         SectorByCluster  : Word;
                         SectorByFAT      : Word;
                         SectorByTrack    : Word;
                         FirstSector      : Word;
                         Cluster          : Word;
                         FAT              : Byte;
                         Track            : Word;
                         MaxRoot          : Word;
                         Head             : Word;
                         LengthFAT        : Byte;
                        End;

        LogicalType = Record
                      Volume           : VolumeStr;
                      NameConstructor  : String[8];
                      Media            : Byte;
                      Size             : LongInt;
                      Used             : LongInt;
                      HiddenFileUsed   : LongInt;
                      NumberHiddenFile : LongInt;
                      NumberFile       : LongInt;
                      SizeFile         : LongInt;
                      NumberFileSector : LongInt;
                      Free             : LongInt;
                      SizeFAT          : LongInt;
                      SizeTrack        : LongInt;
                      FreeCluster      : LongInt;
                      SizeCluster      : LongInt;
                      SizeSector       : Word;
                      Sector           : Word;
                      SectorReserved   : Word;
                      SectorByCluster  : Word;
                      SectorByFAT      : Word;
                      SectorByTrack    : Word;
                      FirstSector      : Word;
                      Cluster          : Word;
                      FAT              : Byte;
                      Track            : Word;
                      MaxRoot          : Word;
                      Head             : Word;
                      HiddenSector     : Word;
                      LengthFAT        : Byte;
                     End;


 Procedure _GetDiskLogical(Size,Free:LongInt;NumCluster:Word;Volume:VolumeStr;
                           InfoBoot:BootSectorType;InfoFile:FileInfoType;
                           Var Info:LogicalType);
 Procedure GetCurrCountry(Var Country:CountryType);
 Procedure GetFileInfo(Drive:Byte;Var Info:FileInfoType);
 Procedure SetDrive(Drive:Char);
 Procedure Sleep(Second:Word);

 Function CharToDriveDOS(Drive:Char):Byte;
 Function CharToDriveNumeric(Drive:Char):Byte;
 Function CompleteTargetName(Source,Target:PathStr):PathStr;
 Function DiffTime(Time1,Time2:LongInt):LongInt;
 Function DriveDOSToChar(Drive:Byte):Char;
 Function FileExpand(Path:PathStr):PathStr;
 Function GetDiskBootLogical(Drive:Byte;Var Info:BootSectorType):Byte;
 Function GetDiskSerialNumber(Drive:Byte):LongInt;
 Function GetDrive:Char;
 Function GetDriveDOS:Byte;
 Function GetDriveNumeric:Byte;
 Function GetFat(Drive:Byte;LSN,Num,SegBuf,OfsBuf:Word):Word;
 Function GetDiskLogical(Drive:Byte;Var Info:LogicalType):Byte;
 Function GetNumberFile(Path:PathStr;Attribut:Word):Word;
 Function GetPath:PathStr;
 Function GetTimer:LongInt;
 Function GetVolume(Drive:Byte):VolumeStr;
 Function IsAll(Path:PathStr):Boolean;
 Function IsDrive(Drive:Char):Boolean;
 Function IsWildCard(Path:PathStr):Boolean;
 Function MediaDisk(Drive:Byte):Byte;
 Function NumCluster(Drive:Byte):Word;
 Function SectorCluster(Drive:Byte):Word;
 Function SectorSize(Drive:Byte):Word;
 Function SetVolume(Drive:Byte;Volume:VolumeStr):Boolean;

(*******************************************************************)
                            IMPLEMENTATION
(*******************************************************************)

Uses DString,TPointer,Dir;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       DiffTime                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function DiffTime(Time1,Time2:LongInt):LongInt;
Begin
 DiffTime := (Time2 - Time1);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetTimer                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetTimer:LongInt;
Var T : DateTime;
    H : Word;
    R : LongInt;
Begin
 GetDate(T.Year,T.Month,T.Day,H);
 GetTime(T.Hour,T.Min,T.Sec,H);
 PackTime(T,R);
 GetTimer := R;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    CharToDriveDOS                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function CharToDriveDOS(Drive:Char):Byte;
Begin
 If(IsDrive(Drive))Then CharToDriveDOS := Byte(Drive) - 64
                   Else CharToDriveDOS := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   CharToDriveNumeric                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function CharToDriveNumeric(Drive:Char):Byte;
Begin
 If(IsDrive(Drive))Then CharToDriveNumeric := Byte(Drive) - 65
                   Else CharToDriveNumeric := GetDriveNumeric;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        IsAll                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function IsAll(Path:PathStr):Boolean;
Begin
 IsAll := ((Pos('*.*',Path) > 0)or(Pos('????????.???',Path) > 0));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      FileExpand                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function FileExpand(Path:PathStr):PathStr;
Begin
 If((Length(Path) >= 1)and(Path[1] = '\'))Then
  FileExpand := GetDrive + ':' + Path
 Else
  FileExpand := FExpand(Path);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 CompleteTargetName                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function CompleteTargetName(Source,Target:PathStr):PathStr;
Var D    : DirStr;
    SN,N : NameStr;
    SE,E : ExtStr;
    Path : PathStr;
    I    : Byte;
Begin
 If(Target = '')Then { Destination vide ? }
 Begin
  FSplit(Source,D,N,E);
  Target := (N + E);
  Exit;
 End;
 If(PathToExt(Target) = '')Then { Destination seulement avec R‚pertoire ? }
 Begin
  If((Length(Target) > 0)and(Not(Target[Length(Target)] = '\')))Then
   Target := Target + '\';
  FSplit(Source,D,N,E);
  CompleteTargetName := FileExpand(Target + N + E);
  Exit;
 End;
 SN := PathToName(Source);
 SE := PathToExt(Source);
 FSplit(Target,D,N,E);
 If(E = '*')Then E := PathToExt(Source);
 If(N = '*')Then N := PathToName(Source);
  { Name * }
 I := Pos('*',N);
 If(I > 0)Then N := Copy(N,1,I-1) + Copy(SN,I,255);
  { Name ? }
 Repeat
  I := Pos('?',N);
  If(I > 0)Then N[I] := SN[I];
 Until (I = 0);
  { Extension * }
 I := Pos('*',E);
 If(I > 0)Then N := Copy(E,1,I-1) + Copy(SE,I,255);
  { Extension ? }
 Repeat
  I := Pos('?',E);
  If(I > 0)Then E[I] := SE[I];
 Until (I = 0);
 If((Length(D) > 0)and(Not(D[Length(D)] = '\')))Then D := D + '\';
 Path := D + N + E;
 If((Length(Path) >= 1)and(Path[1] = '\'))Then Path := GetDrive + ':' + Path;
 CompleteTargetName := Path;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      IsWildCard                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function IsWildCard(Path:PathStr):Boolean;
Begin
 IsWildCard := (Pos('*',Path) > 0)or(Pos('?',Path) > 0);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Sleep                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Procedure Sleep(Second:Word);

  Description :

   ş Permet d'int‚rompre l'execution du programme pendant le
     nombre de seconde sp‚cifi‚ par l'argument Seconde.

  Notes :

   ş Cette fonction est supporter par le MS-DOS.

   ş Cette est une ‚quivalence de la proc‚dure Sleep du Turbo
     C/C++ qui se trouve dans le fichier "DOS.H".
}

 Procedure Sleep(Second:Word);
 Var Hour, Min, Sec, Sec100 : Word;
     Hunds, Secs            : Word;
 Begin
  GetTime(Hour,Min,Sec,Sec100);
  If(Sec100 > 90)Then Hunds := 90
                 Else Hunds := Sec100;
  While Not(Second = 0) do
  Begin
   Dec(Second);
   Secs := Sec;
   Repeat
    GetTime(Hour,Min,Sec,Sec100);
   Until (Secs = Sec);
  End;
  Repeat
   GetTime(Hour,Min,Sec,Sec100);
  Until (Hunds > Sec100);
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       IsDrive                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function IsDrive(Drive:Char):Boolean;

  Description :

   ş Indique qu'il s'agit d'un lettre disque th‚orique.

   ş Elle ne teste en aucun la pr‚sence du lecteur, mais
     seulement si c'est une lettre valide.
}

 Function IsDrive(Drive:Char):Boolean;
 Begin
  IsDrive := (CharUpper(Drive) in ['A'..'Z']);
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    DriveDOSToChar                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Function DriveDOSToChar(Drive:Byte):Char;
 Begin
  If(Drive = 0)Then DriveDOSToChar := GetDrive
               Else DriveDOSToChar := Char(Drive + 64);
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetPath                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 {$IFDEF WITHPChar}

  Function GetPath:PathStr;
  Var Str : PChar;
  Begin
   GetCurDir(Str,0);
   GetPath := Str;
  End;

 {$ELSE}

  Function GetPath:PathStr;
  Var Path : String;
  Begin
   GetDir(0,Path);
   GetPath := Path;
  End;

 {$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  GetDiskSerialNumber                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Function GetDiskSerialNumber(Drive:Byte):LongInt;
 Label Error;
 Var Buffer    : Array[0..63] of Byte;
     _Seg,_Ofs : Word;
     TPtr      : ^LongInt;
 Begin
  _Seg := Seg(Buffer); _Ofs := Ofs(Buffer);
  ASM
   MOV AX,DS;
   MOV ES,AX;
   MOV AX,$6900;
   MOV BL,Drive;
   MOV DX,_Ofs;
   MOV DS,_Seg;
   INT $21;
   MOV AX,ES;
   MOV DS,AX;
   JC  Error;
  END;
  TPtr := @Buffer[2];
  GetDiskSerialNumber := TPtr^;
  Exit;
Error:
  GetDiskSerialNumber := 0;
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetFileInfo                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure GetFileInfo(Drive:Byte;Var Info:FileInfoType);
 Label Start,10,20;
 Var
     {$IFDEF WITHPChar}
      FileRec     : TSearchRec;
     {$ELSE}
      FileRec     : SearchRec;
     {$ENDIF}
     OldPath,Path : PathStr;
     TempName     : String[12];
     DriveChar    : Char;
     SizeSector   : Word;
     {$IFDEF WITHPChar}
      TmpPath     : PathStr;
     {$ENDIF}
 Begin
  SizeSector := SectorSize(Drive);
  FillChar(Info,SizeOf(Info),0);
  {$IFDEF WITHPChar}
   OldPath := GetPath;
  {$ELSE}
   GetDir(0,OldPath);
  {$ENDIF}
  If(Drive = 0)Then DriveChar := GetDrive
               Else DriveChar := Char(Drive+64);
  {$IFDEF WITHPChar}
   StrPCopy(Path,DriveChar + ':\');
  {$ELSE}
   Path := DriveChar + ':\';
  {$ENDIF}
 Start:
  {$IFDEF WITHPChar}
   StrCat(TmpPath,'*.*');
   FindFirst(TmpPath,$FFFF-faVolumeID,FileRec);
  {$ELSE}
   FindFirst(Path+'*.*',$FFFF-VolumeID,FileRec);
  {$ENDIF}
 10:While (DOSError = 0) do
  Begin
   {$IFDEF WITHPChar}
    If((FileRec.Attr and faDirectory) = faDirectory)Then
   {$ELSE}
    If((FileRec.Attr and Directory) = Directory)Then
   {$ENDIF}
   Begin
    If(FileRec.Name <> '.')and(FileRec.Name <> '..')Then
    Begin
     Info.Directory := Info.Directory + 1;
     {$IFDEF WITHPChar}
      StrCat(Path,FileRec.Name);
      StrCat(Path,'\');
     {$ELSE}
      Path := Path + FileRec.Name + '\';
     {$ENDIF}
     Goto Start;
    End;
   End
    else
   Begin
    Info.Size := Info.Size + LongInt(FileRec.Size);
    Info.NumberSector := Info.NumberSector +
                         (LongInt(FileRec.Size) div LongInt(SizeSector));
    If((LongInt(FileRec.Size) mod LongInt(SizeSector)) <> 0)Then
    Begin
     Info.NumberSector := Info.NumberSector + 1;
    End;
    Info.NumberFile := Info.NumberFile + 1;
    {$IFDEF WITHPChar}
     If((FileRec.Attr and faArchive) = faArchive)Then
    {$ELSE}
     If((FileRec.Attr and Archive) = Archive)Then
    {$ENDIF}
    Begin
     Info.SizeArchive := Info.SizeArchive + LongInt(FileRec.Size);
     Info.ArchiveFile := Info.ArchiveFile + 1;
    End;
    {$IFDEF WITHPChar}
     If((FileRec.Attr and faHidden) = faHidden)Then
    {$ELSE}
     If((FileRec.Attr and Hidden) = Hidden)Then
    {$ENDIF}
    Begin
     Info.SizeHidden := Info.SizeHidden + LongInt(FileRec.Size);
     Info.HiddenFile := Info.HiddenFile + 1;
    End;
    {$IFDEF WITHPChar}
     If((FileRec.Attr and faReadOnly) = faReadOnly)Then
    {$ELSE}
     If((FileRec.Attr and ReadOnly) = ReadOnly)Then
    {$ENDIF}
    Begin
     Info.SizeReadOnly := Info.SizeReadOnly + LongInt(FileRec.Size);
     Info.ReadOnlyFile := Info.ReadOnlyFile + 1;
    End;
    {$IFDEF WITHPChar}
     If((FileRec.Attr and faSysFile) = faSysFile)Then
    {$ELSE}
     If((FileRec.Attr and SysFile) = SysFile)Then
    {$ENDIF}
    Begin
     Info.SizeSystem := Info.SizeSystem + LongInt(FileRec.Size);
     Info.SystemFile := Info.SystemFile + 1;
    End;
   End;
   FindNext(FileRec);
  End;
  {$IFDEF WITHPChar}
   If(StrLen(Path) > 3)Then
  {$ELSE}
   If(Length(Path) > 3)Then
  {$ENDIF}
  Begin
20:TempName := '';
   Delete(Path,Length(Path),1);
   While (Path[Length(Path)] <> '\') do
   Begin
    TempName := Path[Length(Path)] + TempName;
    Delete(Path,Length(Path),1);
   End;
   FindFirst(Path+'*.*',$FFFF-VolumeID,FileRec);
   If(FileRec.Name <> TempName)Then
   Begin
    Repeat
     FindNext(FileRec);
     If(DOSError <> 0)Then Goto 20;
    Until (FileRec.Name = TempName);
   End;
   FindNext(FileRec);
   Goto 10;
  End;
  ChDir(OldPath);
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   GetCurrCountry                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Procedure GetCurrCountry(Var Country:CountryType);
 Var Buffer    : Array[0..63] of Byte;
     I         : Byte;
     _Seg,_Ofs : Word;
 Begin
  _Seg := Seg(Buffer); _Ofs := Ofs(Buffer);
  ASM
   MOV AX,DS;
   MOV ES,AX;
   MOV AX,$3800;
   MOV DX,_Ofs;
   MOV DS,_Seg;
   INT $21;
   MOV AX,ES;
   MOV DS,AX;
  END;
  With Country do
  Begin
   CO_DATE := MemW[Seg(Buffer):Ofs(Buffer)];
   For I := 2 to 6 do If(Buffer[I] = 0)Then CO_CURR[0] := Char(I-2);
   CO_CURR[1] := Char(Buffer[2]);
   CO_CURR[2] := Char(Buffer[3]);
   CO_CURR[3] := Char(Buffer[4]);
   CO_CURR[4] := Char(Buffer[5]);
   If(Buffer[8] = 0)Then CO_THSEP[0] := #1 else CO_THSEP[0] := #2;
   CO_THSEP[1] := Char(Buffer[7]);
   CO_THSEP[2] := Char(Buffer[8]);
   If(Buffer[10] = 0)Then CO_DESEP[0] := #1 else CO_DESEP[0] := #2;
   CO_DESEP[1] := Char(Buffer[9]);
   CO_DESEP[2] := Char(Buffer[10]);
   If(Buffer[12] = 0)Then CO_DTSEP[0] := #1 else CO_DTSEP[0] := #2;
   CO_DTSEP[1] := Char(Buffer[11]);
   CO_DTSEP[2] := Char(Buffer[12]);
   If(Buffer[14] = 0)Then CO_TMSEP[0] := #1 else CO_TMSEP[0] := #2;
   CO_TMSEP[1] := Char(Buffer[13]);
   CO_TMSEP[2] := Char(Buffer[14]);
   CO_CURRSTYLE := Buffer[15];
   CO_DIGITS := Buffer[16];
   CO_TIME   := TimeType(Buffer[17]);
   If(Buffer[23] = 0)Then CO_DASEP[0] := #1 else CO_DASEP[0] := #2;
   CO_DASEP[1] := Char(Buffer[22]);
   CO_DASEP[2] := Char(Buffer[23]);
  End;
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetNumberFile                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

 Function GetNumberFile(Path:PathStr;Attribut:Word):Word;
 Var Palette : SearchRec;
     Number  : Word;
     Error   : Word;
 Begin
  Number := 0;
  FindFirst(Path,Attribut,Palette);
  Error := DOSError;
  While (Error = 0) do
  Begin
   Inc(Number);
   FindNext(Palette);
   Error := DOSError;
  End;
  GetNumberFile := Number;
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SectorSize                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   Note :

   ş Cette fonction retourne la taille du disque sp‚cifi‚
     (0=Courant, 1=A, 2=B,..) s'il y a erreur, la valeur
     retourn‚ est 0. }

 Function SectorSize(Drive:Byte):Word;
 Assembler;
 ASM MOV AX,DS;
     MOV ES,AX;
     MOV DL,Drive;
     MOV AH,$1C;
     INT $21;
     MOV BX,ES;
     MOV DS,BX;
     CMP AL,$FF;
     JNE @@1;
     XOR AX,AX;
     JMP @@2;
 @@1:MOV AX,CX;
 @@2:
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      NumCluster                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function NumCluster(Drive:Byte):Word;
 Assembler;
 ASM MOV AX,DS;
     MOV ES,AX;
     MOV DL,Drive;
     MOV AH,$1C;
     INT $21;
     MOV BX,ES;
     MOV DS,BX;
     CMP AL,$FF;
     JNE @@1;
     XOR AX,AX;
     JMP @@2;
 @@1:MOV AX,DX;
 @@2:
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MediaDisk                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function MediaDisk(Drive:Byte):Byte;
 Assembler;
 ASM MOV AX,DS;
     MOV ES,AX;
     MOV DL,Drive;
     MOV AH,$1C;
     INT $21;
     MOV AH,DS:[BX];
     MOV BX,ES;
     MOV DS,BX;
     CMP AL,$FF;
     JNE @@1;
     XOR AL,AL;
     JMP @@2;
 @@1:MOV AL,AH;
 @@2:
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SectorCluster                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function SectorCluster(Drive:Byte):Word;
 Assembler;
 ASM MOV DL,Drive;
     MOV AH,$36;
     INT $21;
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetDrive                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function GetDrive:Char;
 Assembler;
 ASM
  MOV AH,$19;
  INT $21;
  ADD AL,65;
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    GetDriveNumeric                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function GetDriveNumeric:Byte;
 Assembler;
 ASM
  MOV AH,$19;
  INT $21;
 END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetDriveDOS                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function GetDriveDOS:Byte;
 Assembler;
 ASM
  MOV AH,$19;
  INT $21;
  INC AL;
 END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetDrive                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure SetDrive(Drive:Char);
 Assembler;
 ASM MOV AH,$0E;
     MOV DL,Drive;
     SUB DL,65;
     INT $21;
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        GetFat                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function GetFat(Drive:Byte;LSN,Num,SegBuf,OfsBuf:Word):Word;
 Assembler;
 ASM MOV AX,DS;
     MOV ES,AX;
     MOV AL,Drive;
     CMP AL,0;
     JE  @@3;
     DEC AL;
     JMP @@2;
 @@3:MOV DL,AL;
     MOV AH,$19;
     INT $21;
 @@2:MOV CX,Num;
     MOV DX,LSN;
     MOV BX,OfsBuf;
     MOV DI,SegBuf;
     MOV DS,DI;
     INT $25;
     JC  @@1;
     XOR AX,AX;
 @@1:POPF;
     MOV BX,ES;
     MOV DS,BX;
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetVolume                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function SetVolume(Drive:Byte;Volume:VolumeStr):Boolean;
 Var Buffer : Array[0..63] of Byte;

  Function GetTable(Drive:Byte;Var Buffer):Boolean;
  Label Error;
  Var _S,_O : Word;
      X     : Boolean;
  Begin
   _S := Seg(Buffer);
   _O := Ofs(Buffer);
   ASM
    MOV AX,DS;
    MOV ES,AX;
    MOV AX,$6900;
    MOV BL,Drive;
    MOV DX,_O;
    MOV DS,_S;
    INT $21;
    MOV AX,ES;
    MOV DS,AX;
    MOV AH,0; { Ne Jamais modifier cette instruction ! }
    ADC AH,AH;
    NOT AH;
    AND AH,1;
    MOV X,AH;
   END;
   GetTable := X;
  End;

  Procedure CopyVolumeBuffer(Var Buffer;Volume:String);
  Var I    : Byte;
      TPtr : ^TChar;
  Begin
   TPtr := @Buffer;
   For I := 0 to 10 do TPtr^[I+6] := #0;
   For I := 0 to Length(Volume) do TPtr^[I+6] := Volume[I+1];
  End;

  Function SetTable(Drive:Byte;Var Buffer):Boolean;
  Label Error;
  Var _Seg,_Ofs : Word;
  Begin
   _Seg := Seg(Buffer); _Ofs := Ofs(Buffer);
   ASM
    MOV AX,DS;
    MOV ES,AX;
    MOV AX,$6901;
    MOV BL,Drive;
    MOV DX,_Ofs;
    MOV DS,_Seg;
    INT $21;
    MOV AX,ES;
    MOV DS,AX;
    JC  Error;
   END;
   SetTable := True;
   Exit;
Error:SetTable := False;
  End;

 Begin
  FillChar(Buffer,SizeOf(Buffer),0);
  If Not(GetTable(Drive,Buffer))Then
  Begin
   SetVolume := False;
   Exit;
  End;
  CopyVolumeBuffer(Buffer,Volume);
  SetVolume := SetTable(Drive,Buffer);
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetVolume                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function GetVolume(Drive:Byte):VolumeStr;
 Label Error;
 Var Info      : SearchRec;
     I         : Byte;
     DriveChar : Char;
     Buffer    : Array[0..63] of Byte;
     Tmp       : String;
     _Seg,_Ofs : Word;
 Begin
  If(Lo(DOSVersion) < 4)Then
  Begin
   If(Drive = 0)Then DriveChar := GetDrive
		Else DriveChar := Char(Drive + 64);
   FindFirst(DriveChar+':\*.*',VolumeID,Info);
   If(DOSError = 0)Then GetVolume := Info.Name
	           Else GetVolume := 'NO NAME';
  End
   else
  Begin
   _Seg := Seg(Buffer); _Ofs := Ofs(Buffer);
   ASM
    MOV AX,DS;
    MOV ES,AX;
    MOV AX,$6900;
    MOV BL,Drive;
    MOV DX,_Ofs;
    MOV DS,_Seg;
    INT $21;
    MOV AX,ES;
    MOV DS,AX;
    JC  Error;
   END;
   FillChar(Tmp,SizeOf(Tmp),0);
   For I := $06 to $06 + 10 do Tmp := Tmp + Char(Buffer[I]);
   GetVolume := Tmp;
   Exit;
Error:GetVolume := '';
  End;
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  GetDiskBootLogical                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   0 = Pas erreur,
   1 = Disque invalide,
   2 = Secteur trop gros,
 }

 Function GetDiskBootLogical(Drive:Byte;Var Info:BootSectorType):Byte;
 Const MaxBuffer = 16383;
 Var Buffer      : Array[0..MaxBuffer] of Byte;
     SSector,Tmp : Word;
     OldDrive    : Char;
     I           : Byte;

  Function GetWord(Var Buffer):Word;
  Begin
   GetWord := MemW[Seg(Buffer):Ofs(Buffer)];
  End;

 Begin
  FillChar(Info,SizeOf(Info),0);
  If(Drive <> 0)Then
  Begin
   OldDrive := GetDrive;
   SetDrive(Char(Drive+64));
   If(OldDrive = GetDrive)Then Begin GetDiskBootLogical := 1; Exit; End;
   SetDrive(OldDrive);
  End;
  SSector := SectorSize(Drive);
  If(SSector > MaxBuffer+1)Then Begin GetDiskBootLogical := 2; Exit; End;
  Tmp := GetFat(Drive,0,1,Seg(Buffer),Ofs(Buffer));
  If(Tmp = 0)Then
  Begin
   Info.NameConstructor[0] := #8;
   For I := 3 to 10 do Info.NameConstructor[I-2] := Char(Buffer[I]);
   Info.Media := Byte(Buffer[21]);
   Info.SizeSector := GetWord(Buffer[11]);
   Info.Sector := GetWord(Buffer[19]);
   Info.SectorReserved := GetWord(Buffer[14]);
   Info.SectorByCluster := Byte(Buffer[13]);
   Info.SectorByFAT := GetWord(Buffer[22]);
   Info.SectorByTrack := GetWord(Buffer[24]);
   Info.Cluster := NumCluster(Drive);
   Info.FAT := Byte(Buffer[16]);
   Info.Head := GetWord(Buffer[26]);
   Info.Track := Info.Sector div (Info.Head * Info.SectorByTrack);
   Info.MaxRoot := GetWord(Buffer[17]);
   Info.SizeCluster := Info.SizeSector * Info.SectorByCluster;
   Info.FirstSector := Info.SectorReserved + (Info.SectorByFAT * Info.FAT) +
                       (Info.MaxRoot+32) div Info.SizeSector;
   Dec(Info.FirstSector);
   If(Info.Sector > 4086)Then Info.LengthFAT := 16
                         Else Info.LengthFAT := 12;
   Info.SizeTrack := LongInt(Info.SectorByTrack) * LongInt(Info.SizeSector);
   Info.SizeFAT := LongInt(Info.SectorByFAT) * LongInt(Info.SizeSector);
   GetDiskBootLogical := 0;
  End
   else
  GetDiskBootLogical := Tmp;
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetDiskLogical                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Function GetDiskLogical(Drive:Byte;Var Info:LogicalType):Byte;
 Const MaxBuffer = 16383;
 Var Buffer      : Array[0..MaxBuffer] of Byte;
     InfoFile    : FileInfoType;
     SSector,Tmp : Word;
     OldDrive    : Char;
     I           : Byte;

  Function GetWord(Var Buffer):Word;
  Var WPtr : ^Word;
  Begin
   WPtr := @Buffer;
   GetWord := WPtr^;
  End;

 Begin
  FillChar(Info,SizeOf(Info),0);
  FillChar(InfoFile,SizeOf(InfoFile),0);
  If(Drive <> 0)Then
  Begin
   OldDrive := GetDrive;
   SetDrive(Char(Drive+64));
   If(OldDrive = GetDrive)Then Begin GetDiskLogical := 1; Exit; End;
   SetDrive(OldDrive);
  End;
  SSector := SectorSize(Drive);
  If(SSector > MaxBuffer+1)Then Begin GetDiskLogical := 2; Exit; End;
  GetFileInfo(Drive,InfoFile);
  Tmp := GetFat(Drive,0,1,Seg(Buffer),Ofs(Buffer));
  If(Tmp = 0)Then
  Begin
   Info.Volume := GetVolume(Drive);
   Info.NameConstructor[0] := #8;
   For I := 3 to 10 do Info.NameConstructor[I-2] := Char(Buffer[I]);
   Info.Media := Byte(Buffer[21]);
   Info.Size := DiskSize(Drive);
   Info.Free := DiskFree(Drive);
   Info.Used := Info.Size - Info.Free;
   Info.SizeSector := GetWord(Buffer[11]);
   Info.Sector := GetWord(Buffer[19]);
   Info.SectorReserved := GetWord(Buffer[14]);
   Info.SectorByCluster := Byte(Buffer[13]);
   Info.SectorByFAT := GetWord(Buffer[22]);
   Info.SectorByTrack := GetWord(Buffer[24]);
   Info.Cluster := NumCluster(Drive);
   Info.FAT := Byte(Buffer[16]);
   Info.Head := GetWord(Buffer[26]);
   Info.Track := Info.Sector div (Info.Head * Info.SectorByTrack);
   Info.MaxRoot := GetWord(Buffer[17]);
   Info.HiddenSector := InfoFile.SizeHidden div Info.SizeSector;
   If(InfoFile.SizeHidden Mod Info.SizeSector <> 0)Then Inc(Info.HiddenSector);
   Info.SizeCluster := Info.SizeSector * Info.SectorByCluster;
   Info.FreeCluster := Info.Free div Info.SizeCluster;
   Info.FirstSector := Info.SectorReserved + (Info.SectorByFAT * Info.FAT) +
                       (Info.MaxRoot+32) div Info.SizeSector;
   Dec(Info.FirstSector);
   If(Info.Sector > 4086)Then Info.LengthFAT := 16
                         Else Info.LengthFAT := 12;
   Info.SizeTrack := LongInt(Info.SectorByTrack) * LongInt(Info.SizeSector);
   Info.SizeFAT := LongInt(Info.SectorByFAT) * LongInt(Info.SizeSector);
   Info.HiddenFileUsed := InfoFile.SizeHidden;
   Info.NumberFile := InfoFile.NumberFile;
   Info.NumberHiddenFile := InfoFile.HiddenFile;
   Info.SizeFile := InfoFile.Size;
   Info.NumberFileSector := InfoFile.NumberSector;
   GetDiskLogical := 0;
  End
   else
  GetDiskLogical := Tmp;
 End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    _GetDiskLogical                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

 Procedure _GetDiskLogical(Size,Free:LongInt;NumCluster:Word;Volume:VolumeStr;
                           InfoBoot:BootSectorType;InfoFile:FileInfoType;
                           Var Info:LogicalType);
 Begin
  Info.Volume := Volume;
  Info.NameConstructor := InfoBoot.NameConstructor;
  Info.Media := InfoBoot.Media;
  Info.Size := Size;
  Info.Free := Free;
  Info.Used := Size - Free;
  Info.SizeSector := InfoBoot.SizeSector;
  Info.Sector := InfoBoot.Sector;
  Info.SectorReserved := InfoBoot.SectorReserved;
  Info.SectorByCluster := InfoBoot.SectorByCluster;
  Info.SectorByFAT := InfoBoot.SectorByFAT;
  Info.SectorByTrack := InfoBoot.SectorByTrack;
  Info.Cluster := NumCluster;
  Info.FAT := InfoBoot.FAT;
  Info.Head := InfoBoot.Head;
  Info.Track := InfoBoot.Sector div (InfoBoot.Head * InfoBoot.SectorByTrack);
  Info.MaxRoot := InfoBoot.MaxRoot;
  Info.HiddenSector := InfoFile.SizeHidden div InfoBoot.SizeSector;
  If(InfoFile.SizeHidden Mod InfoBoot.SizeSector <> 0)Then Inc(Info.HiddenSector);
  Info.SizeCluster := InfoBoot.SizeSector * InfoBoot.SectorByCluster;
  Info.FreeCluster := Free div InfoBoot.SizeCluster;
  Info.FirstSector := InfoBoot.SectorReserved + (InfoBoot.SectorByFAT * InfoBoot.FAT) +
                      (InfoBoot.MaxRoot+32) div InfoBoot.SizeSector;
  Dec(Info.FirstSector);
  If(InfoBoot.Sector > 4086)Then Info.LengthFAT := 16
                            Else Info.LengthFAT := 12;
  Info.SizeTrack := LongInt(InfoBoot.SectorByTrack) * LongInt(InfoBoot.SizeSector);
  Info.SizeFAT := LongInt(InfoBoot.SectorByFAT) * LongInt(InfoBoot.SizeSector);
  Info.HiddenFileUsed := InfoFile.SizeHidden;
  Info.NumberFile := InfoFile.NumberFile;
  Info.NumberHiddenFile := InfoFile.HiddenFile;
  Info.SizeFile := InfoFile.Size;
  Info.NumberFileSector := InfoFile.NumberSector;
 End;

BEGIN { Main Unit }
END.