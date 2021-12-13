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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     SetFullName                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function SetFullName(Name:PathStr):PathStr;
Begin
 If(Name = '..')Then SetFullName := Name
  Else
 SetFullName := BoostStrSpc(PathToName(Name),8) + PathToExt(Name);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     NameIdentical                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   ConcatPathToFile                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function ConcatPathToFile(Path,Name:PathStr):PathStr;
Begin
 If(Path[Length(Path)] <> '\')Then ConcatPathToFile := Path + '\' + Name
                              Else ConcatPathToFile := Path + Name;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      CurrentPath                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function CurrentPath:PathStr;
Var Dir : PathStr;
Begin
 GetDir(0,Dir);
 CurrentPath := Dir;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        CopyPath                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      PathToName                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function PathToName(Path:PathStr):NameStr;
Var D : DirStr;
    N : NameStr;
    E : ExtStr;
Begin
 FSplit(Path,D,N,E);
 PathToName := N;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       PathToExt                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function PathToExt(Path:PathStr):ExtStr;
Var D : DirStr;
    N : NameStr;
    E : ExtStr;
Begin
 FSplit(Path,D,N,E);
 PathToExt := E;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       PathToDir                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      PathToDisk                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

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

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     PathToDrive                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function PathToDrive(Path:PathStr):Byte;
Begin
 PathToDrive := Byte(PathToDisk(Path)) - 65;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     PathToDriveDOS                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function PathToDriveDOS(Path:PathStr):Byte;
Begin
 If(Not(IsDrive(Path[1])))Then
  PathToDriveDOS := 0
 Else
  PathToDriveDOS := Byte(PathToDisk(Path)) - 64;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SetExtInPath                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function SetExtInPath(Path:PathStr;Ext:ExtStr):PathStr;
Begin
 SetExtInPath := PathToDir(Path) + PathToName(Path) + Ext;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  PathToDirAndName                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function PathToDirAndName(Path:PathStr):PathStr;
Var D : DirStr;
    N : NameStr;
    E : ExtStr;
Begin
 FSplit(Path,D,N,E);
 If Not(D[Length(D)] = '\')Then D := D + '\';
 PathToDirAndName := D + N;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  SelectAllIfNotExt                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function SelectAllIfNotExt(Path:PathStr):PathStr;
Begin
 If(PathToExt(Path) = '')Then Path := Path + SetPathForAddFile('*.*');
 SelectAllIfNotExt := Path;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  SetPathForAddFile                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function SetPathForAddFile(Path:PathStr):PathStr;
Begin
 If Not(Path[Length(Path)] = '\')Then Path := Path + '\';
 SetPathForAddFile := Path;
End;

BEGIN { Main Unit }
END.