(********************************************************)
(*                                                      *)
(*                Malte System/Directory                *)
(*                      1992/12/01                      *)
(*                                                      *)
(*     Copyright (C) par les Chevaliers de Malte        *)
(*                                                      *)
(********************************************************)

Unit DIR;

(********************************************************)
                        INTERFACE
(********************************************************)

Uses DOS;

Procedure CopyPath(Var Target:PathStr;Extra:PathStr);

Function NameIdentical(A,B:PathStr):Boolean;
Function ConcatPathToFile(Path,Name:PathStr):PathStr;
Function CurrentPath:PathStr;
Function PathToExt(Path:PathStr):ExtStr;
Function PathToName(Path:PathStr):NameStr;
Function PathToDir(Path:PathStr):DirStr;
Function PathToDirAndName(Path:PathStr):PathStr;
Function PathToDisk(Path:PathStr):Char;
Function PathToDrive(Path:PathStr):Byte;
Function PathToDriveDOS(Path:PathStr):Byte;
Function SelectAllIfNotExt(Path:PathStr):PathStr;
Function SetExtInPath(Path:PathStr;Ext:ExtStr):PathStr;
Function SetPathForAddFile(Path:PathStr):PathStr;
Function SetFullName(Name:PathStr):PathStr;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses DString,OS;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                     SetFullName                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function SetFullName(Name:PathStr):PathStr;
Begin
 If(Name = '..')Then SetFullName := Name
  Else
 SetFullName := BoostStrSpc(PathToName(Name),8) + PathToExt(Name);
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                     NameIdentical                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function NameIdentical(A,B:PathStr):Boolean;
Label _EXT;
Var I     : Byte;
    NA,NB : NameStr;
    EA,EB : ExtStr;
Begin
 NA := PathToName(A); NB := PathToName(B);
 For I := 1 to Length(NA) do
 Begin
  If(NA[I] = '*')or(NB[I] = '*')Then Goto _EXT;
  If Not((NA[I] = NB[I])or(NA[I] = '?')or(NB[I] = '?'))Then
  Begin
   NameIdentical := False;
   Exit;
  End;
 End;
_EXT:
 EA := PathToExt(A); EB := PathToExt(B);
 For I := 1 to Length(EA) do
 Begin
  If(EA[I] = '*')or(EB[I] = '*')Then
  Begin
   NameIdentical := True;
   Exit;
  End;
  If Not((EA[I] = EB[I])or(EA[I] = '?')or(EB[I] = '?'))Then
  Begin
   NameIdentical := False;
   Exit;
  End;
 End;
 NameIdentical := True;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   ConcatPathToFile                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function ConcatPathToFile(Path,Name:PathStr):PathStr;
Begin
 If(Path[Length(Path)] <> '\')Then ConcatPathToFile := Path + '\' + Name
                              Else ConcatPathToFile := Path + Name;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                      CurrentPath                     넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function CurrentPath:PathStr;
Var Dir : PathStr;
Begin
 GetDir(0,Dir);
 CurrentPath := Dir;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                        CopyPath                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Procedure CopyPath(Var Target:PathStr;Extra:PathStr);
Var Dir     : DirStr;
    Name    : NameStr;
    Ext     : ExtStr;
    OldPath : PathStr;
Begin
 GetDir(0,OldPath);
 FSplit(Target,Dir,Name,Ext);
 If(Length(Dir) > 3)and(Dir[Length(Dir)] = '\')Then Dir[0] := Pred(Dir[0]);
 ChDir(Dir);
 While(Extra[Length(Extra)] = ' ') do Extra[0] := Pred(Extra[0]);
 ChDir(Extra);
 FillChar(Target,SizeOf(Target),0);
 GetDir(0,Target);
 If(Target[Length(Target)] <> '\')Then Target := Target + '\';
 Target := Target + Name + Ext;
 ChDir(OldPath);
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                      PathToName                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function PathToName(Path:PathStr):NameStr;
Var D : DirStr;
    N : NameStr;
    E : ExtStr;
Begin
 FSplit(Path,D,N,E);
 PathToName := N;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                       PathToExt                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function PathToExt(Path:PathStr):ExtStr;
Var D : DirStr;
    N : NameStr;
    E : ExtStr;
Begin
 FSplit(Path,D,N,E);
 PathToExt := E;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                       PathToDir                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function PathToDir(Path:PathStr):DirStr;
Var D : DirStr;
    N : NameStr;
    E : ExtStr;
Begin
 FSplit(Path,D,N,E);
 If(E = '')Then
 Begin
  If(D[Length(D)] = '\')Then D := D + E
                        Else D := D + '\' + E;
 End;
 If(D = '')Then PathToDir := '' else
 If(D[Length(D)] = '\')Then PathToDir := D
                       Else PathToDir := D + '\';
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                      PathToDisk                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function PathToDisk(Path:PathStr):Char;
Begin
 If((Path <> '')or(Not(CharUpper(Path[1]) in ['A'..'Z'])))Then
 Begin
  PathToDisk := GetDrive
 End
  Else
 Begin
  PathToDisk := Path[1];
 End;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                     PathToDrive                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function PathToDrive(Path:PathStr):Byte;
Begin
 PathToDrive := Byte(PathToDisk(Path)) - 65;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                     PathToDriveDOS                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function PathToDriveDOS(Path:PathStr):Byte;
Begin
 If(Not(IsDrive(Path[1])))Then
  PathToDriveDOS := 0
 Else
  PathToDriveDOS := Byte(PathToDisk(Path)) - 64;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    SetExtInPath                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function SetExtInPath(Path:PathStr;Ext:ExtStr):PathStr;
Begin
 SetExtInPath := PathToDir(Path) + PathToName(Path) + Ext;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                  PathToDirAndName                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function PathToDirAndName(Path:PathStr):PathStr;
Var D : DirStr;
    N : NameStr;
    E : ExtStr;
Begin
 FSplit(Path,D,N,E);
 If Not(D[Length(D)] = '\')Then D := D + '\';
 PathToDirAndName := D + N;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                  SelectAllIfNotExt                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function SelectAllIfNotExt(Path:PathStr):PathStr;
Begin
 If(PathToExt(Path) = '')Then Path := Path + SetPathForAddFile('*.*');
 SelectAllIfNotExt := Path;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                  SetPathForAddFile                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function SetPathForAddFile(Path:PathStr):PathStr;
Begin
 If Not(Path[Length(Path)] = '\')Then Path := Path + '\';
 SetPathForAddFile := Path;
End;

BEGIN { Main Unit }
END.