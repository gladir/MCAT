(********************************************************)
(*                                                      *)
(*              Malte Catalog/Get Manual                *)
(*                      1993/05/10                      *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit MCatGetManual;

(********************************************************)
                        INTERFACE
(********************************************************)

Procedure GetManually;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses Handle,Keyboard,LanDStr,MCatFile,MCatIn;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetManually                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure GetManually;
Var Index    : IndexType;
    DiskInfo : DiskInfoType;
    K,Err    : Word;
    P,Pos    : LongInt;
Begin
 P := 0; Pos := GetMaxIndex+1;
 FillChar(Index,SizeOf(Index),0);
 K := GetIndexRecord(Index,LStr('Get Manually','Entrez manuellement'));
 If(K = kbEsc)Then Exit;
 Err := SetFile(GetNameIndex,Pos,SizeOf(Index),Index);
 Repeat
  FillChar(DiskInfo,SizeOf(DiskInfo),0);
  K := MCatIn.GetDiskInfoRecord(DiskInfo,LStr('Get Manually File','Entrez manuellement le fichier'));
  If(K <> kbEsc)Then
  Begin
   MCatFile.SetDiskInfoRecord(Pos,P,DiskInfo);
  End;
  Inc(P);
 Until (K = kbEsc);
End;

BEGIN
END.