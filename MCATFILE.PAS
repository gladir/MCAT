(********************************************************)
(*                                                      *)
(*                 Malte Catalog/File                   *)
(*                    1993/01/24                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit MCatFile;

(********************************************************)
                       INTERFACE
(********************************************************)

Uses

     DOS,OS;

Const

      EnglishSearchVolume = '^Esc^ Cancel ³ Search volume in record...';
      FrenchSearchVolume  = '^Esc^ Annule ³ Recherche du volume dans les enregistrements en cours...';

      _Drive        : Byte = 0;
      _FileName     : PathStr = 'MCAT.TBL';


Type

     IndexType     = Record
                      Volume      : String;
                      NumberFile  : LongInt;
                      SizeUsed    : LongInt;
                      SizeFree    : LongInt;
                      Time        : LongInt;
                      Description : String;
                     End;

     DiskInfoType  = Record
                      Path        : String;
                      Size        : LongInt;
                      Time        : LongInt;
                      Attr        : Byte;
                      Category    : Byte;
                      Description : String;
                     End;

Var

     _PathDiskInfo,
     _PathIndex,
     _PathMain,
     _PathTmp       : PathStr;

Procedure GetDiskInfoRecord(Pos,P:LongInt;Var DiskInfo:DiskInfoType);
Procedure GetIndexRecord(P:LongInt;Var Index:IndexType);
Procedure SetDiskInfoRecord(Pos,P:LongInt;Var DiskInfo:DiskInfoType);
Procedure SetIndexRecord(P:LongInt;Var Index:IndexType);

Function DiskInfoEmpty(Pos:LongInt):Boolean;
Function GetNameDiskInfo(P:LongInt):PathStr;
Function GetNameIndex:PathStr;
Function GetMaxDiskInfo(Pos:LongInt):LongInt;
Function GetMaxIndex:LongInt;
Function IndexEmpty:Boolean;
Function RecordDiskInfoIdentical(A,B:DiskInfoType):Boolean;
Function RecordIndexIdentical(A,B:IndexType):Boolean;
Function SearchVolume(Main:IndexType;Var P:LongInt):Boolean;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses Numeric,Dir,Handle,LanText,Text,LuxeVid,Level,Sound;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    DiskInfoEmpty                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function DiskInfoEmpty(Pos:LongInt):Boolean;
Var Handle  : Word;
    EndItem : LongInt;
Begin
 Handle := Open(GetNameDiskInfo(Pos),ReadOnly);
 If(IsHandleError(Handle))Then
 Begin
  DiskInfoEmpty := True;
  Exit;
 End;
 EndItem := FileSize(Handle);
 Close(Handle);
 DiskInfoEmpty := (EndItem = 0);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  GetDiskInfoRecord                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure GetDiskInfoRecord(Pos,P:LongInt;Var DiskInfo:DiskInfoType);
Var Err : Word;
Begin
 Err := GetFile(GetNameDiskInfo(Pos),P,SizeOf(DiskInfo),DiskInfo);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetIndexRecord                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure GetIndexRecord(P:LongInt;Var Index:IndexType);
Var Err : Word;
Begin
 Err := GetFile(GetNameIndex,P,SizeOf(Index),Index);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetNameDiskInfo                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetNameDiskInfo(P:LongInt):PathStr;
Var NumExt : StrWord;
Begin
 HexWordChn(P,NumExt);
 GetNameDiskInfo := _PathDiskInfo+PathToName(_FileName)+'.'+Copy(NumExt,2,3);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetNameIndex                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetNameIndex:PathStr;
Begin
 If(PathToDir(_FileName) = '')Then GetNameIndex := _PathIndex + _FileName
                              Else GetNameIndex := _FileName;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetMaxIndex                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetMaxIndex:LongInt;
Var Handle  : Word;
    EndItem : LongInt;
Begin
 Handle := Open(GetNameIndex,ReadOnly);
 EndItem := FileSize(Handle);
 If(EndItem > 0)Then EndItem := (EndItem div SizeOf(IndexType)) - 1;
 Close(Handle);
 GetMaxIndex := EndItem;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetMaxDiskInfo                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetMaxDiskInfo(Pos:LongInt):LongInt;
Var Handle  : Word;
    EndItem : LongInt;
Begin
 Handle := Open(GetNameDiskInfo(Pos),ReadOnly);
 EndItem := FileSize(Handle);
 If(EndItem > 0)Then EndItem := (EndItem div SizeOf(DiskInfoType)) - 1;
 Close(Handle);
 GetMaxDiskInfo := EndItem;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       IndexEmpty                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function IndexEmpty:Boolean;
Var Handle  : Word;
    EndItem : LongInt;
Begin
 Handle := Open(GetNameIndex,ReadOnly);
 If(IsHandleError(Handle))Then
 Begin
  IndexEmpty := True;
  Exit;
 End;
 EndItem := FileSize(Handle);
 Close(Handle);
 IndexEmpty := (EndItem = 0)
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 RecordDiskInfoIdentical              ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function RecordDiskInfoIdentical(A,B:DiskInfoType):Boolean;
Begin
 RecordDiskInfoIdentical := ((A.Description = B.Description)and
                             (A.Category = B.Category)and
                             (A.Size = B.Size)and
                             (A.Attr = B.Attr)and
                             (A.Path = B.Path)and
                             (A.Time = B.Time));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   RecordIndexIdentical               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function RecordIndexIdentical(A,B:IndexType):Boolean;
Begin
 RecordIndexIdentical := ((A.Description = B.Description)and
                          (A.Volume = B.Volume)and
                          (A.SizeUsed = B.SizeUsed)and
                          (A.SizeFree = B.SizeFree)and
                          (A.NumberFile = B.NumberFile)and
                          (A.Time = B.Time));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SearchVolume                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function SearchVolume(Main:IndexType;Var P:LongInt):Boolean;
Var _Main     : IndexType;
    I,EndItem : LongInt;
    Ok        : Boolean;
    Handle,K  : Word;
    Line2     : BoxImage;
Begin
 EndItem := GetMaxIndex;
 I := -1; Ok := False;
 Handle := Open(GetNameIndex,ReadOnly);
 Line2.Init;
 If(Line2.GetLine(0,GetMaxY,GetMaxX))Then
 Begin
  SetAllColor(Color.EndBar.HighLetter,Color.EndBar.Normal);
  LWriteTypingXY(3,GetMaxY,EnglishSearchVolume,FrenchSearchVolume);
  Repeat
   Inc(I);
   If(I > EndItem)Then
   Begin
    Close(Handle);
    Line2.Restore;
    SearchVolume := False;
    Exit;
   End;
   FillChar(_Main,SizeOf(_Main),0);
   GetRecord(Handle,I,SizeOf(_Main),_Main);
   If((Main.Volume = _Main.Volume)and(Main.Volume <> ''))Then Ok := True;
  Until Ok;
  Close(Handle);
  P := I;
  SearchVolume := True;
 End
  else
 Beep;
 Line2.Restore;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     SetDiskInfoRecord                ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetDiskInfoRecord(Pos,P:LongInt;Var DiskInfo:DiskInfoType);
Var Err : Word;
Begin
 Err := SetFile(GetNameDiskInfo(Pos),P,SizeOf(DiskInfo),DiskInfo);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetIndexRecord                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetIndexRecord(P:LongInt;Var Index:IndexType);
Var Err : Word;
Begin
 Err := SetFile(GetNameIndex,P,SizeOf(Index),Index);
End;

BEGIN { Main Unit }
  { L'adapte au SET }
 _PathTmp := GetEnv('TMP');
 If(_PathTmp = '')Then _PathTmp := GetEnv('TEMP');
 _PathDiskInfo := GetEnv('MCATPATHDISKINFO');
 If(_PathDiskInfo = '')Then _PathDiskInfo := GetEnv('PATHDISKINFO');
 If(_PathDiskInfo = '')Then _PathDiskInfo := GetEnv('PATHDI');
 _PathIndex    := GetEnv('MCATPATHINDEX');
 If(_PathIndex = '')Then _PathIndex := GetEnv('PATHINDEX');
 If(_PathIndex = '')Then _PathIndex := GetEnv('PATHIND');
 _PathMain     := GetEnv('MCATPATHMAIN');
 If(_PathMain = '')Then _PathMain := GetEnv('MCATPATH');
 If(_PathMain = '')Then _PathMain := GetEnv('PATHMCAT');
 If(_PathDiskInfo[Length(_PathDiskInfo)] <> '\')Then
   _PathDiskInfo := _PathDiskInfo + '\';
 If(_PathIndex[Length(_PathIndex)] <> '\')Then
   _PathIndex := _PathIndex + '\';
 If(_PathMain[Length(_PathMain)] <> '\')Then
   _PathMain := _PathMain + '\';
END.