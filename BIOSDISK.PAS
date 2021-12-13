(********************************************************************)
(*                                                                  *)
(*                       Malte System/BIOS Disk                     *)
(*                             1992/10/21                           *)
(*                                                                  *)
(*             Copyright (C) par les Chevaliers de Malte            *)
(*                                                                  *)
(********************************************************************)

{ Programmeur :

   Sylvain Maltais

  Derniäre modification :

   Dimanche, le 9 mai 1993 (UpDate 286 instruction).
}

Unit BIOSDISK;

(********************************************************************)
                               INTERFACE
(********************************************************************)

Type

     HardDiskTableType = Record
                          MaxTrack          : Word;
                          MaxHead           : Byte;
                          Reserved          : Word;
                          TrackBegCompWrite : Word;
                          MaxLenVerify      : Byte;
                          Flags             : Byte;
                          TimeOutDelay      : Byte;
                          TimeOutFormat     : Byte;
                          TimeOutCheck      : Byte;
                         End;

Function CheckSectorDisk(Disk:Byte;Num:Byte;Track:Word;
                         Sector,Head:Byte;Var Buffer):Byte;
Function GetHardDiskTable(HardDisk:Byte;Var Table:HardDiskTableType):Boolean;
Function GetSectorDisk(Disk:Byte;Num:Byte;Track:Word;
                       Sector,Head:Byte;Var Buffer):Byte;
Function GetStateDisk(Disk:Byte):Byte;
Function InitDisk(Disk:Byte):Byte;
Function SetSectorDisk(Disk:Byte;Num:Byte;Track:Word;
                       Sector,Head:Byte;Var Buffer):Byte;

(********************************************************************)
                             IMPLEMENTATION
(********************************************************************)

Uses DOS;

Function CheckSectorDisk(Disk:Byte;Num:Byte;Track:Word;
                         Sector,Head:Byte;Var Buffer):Byte;
Assembler;
ASM
 MOV  CX,Track;
 XCHG CL,CH;
 {$IFOPT G+}
  ROR CL,2;
 {$ELSE}
  ROR CL,1;
  ROR CL,1;
 {$ENDIF}
 ADD CL,Sector;
 MOV AL,Num;
 MOV DH,Head;
 MOV DL,Disk;
 LES BX,Buffer;
 MOV AH,$04;
 INT $13;
END;

{ Cette fonction copie la table physique du Hard-Disk. Si l'operation
  s'est bien passer il retourne 'True', sinon 'False'. }

Function GetHardDiskTable(HardDisk:Byte;Var Table:HardDiskTableType):Boolean;
Var Inter : Pointer;
Begin
 Case (HardDisk and $7F) of
  0 : GetIntVec($41,Inter);
  1 : GetIntVec($46,Inter);
  2 : Begin
       GetHardDiskTable := False;
       Exit;
      End;
 End;
 Move(Inter,Table,SizeOf(Table));
 GetHardDiskTable := True;
End;

Function GetSectorDisk(Disk:Byte;Num:Byte;Track:Word;
                       Sector,Head:Byte;Var Buffer):Byte;
Assembler;
ASM
 MOV  CX,Track;
 XCHG CL,CH;
 {$IFOPT G+}
  ROR CL,2;
 {$ELSE}
  ROR CL,1;
  ROR CL,1;
 {$ENDIF}
 ADD CL,Sector;
 MOV AL,Num;
 MOV DH,Head;
 MOV DL,Disk;
 LES BX,Buffer;
 MOV AH,$02;
 INT $13;
END;

Function GetStateDisk(Disk:Byte):Byte;
Assembler;
ASM
 MOV AH,$01;
 MOV DL,Disk;
 INT $13;
END;

Function InitDisk(Disk:Byte):Byte;
Assembler;
ASM
 XOR AX,AX;
 MOV DL,Disk;
 INT $13;
 MOV AL,AH;
END;

Function SetSectorDisk(Disk:Byte;Num:Byte;Track:Word;
                       Sector,Head:Byte;Var Buffer):Byte;
Assembler;
ASM
 MOV CX,Track;
 XCHG CL,CH;
 {$IFOPT G+}
  ROR CL,2;
 {$ELSE}
  ROR CL,1;
  ROR CL,1;
 {$ENDIF}
 ADD CL,Sector;
 MOV AL,Num;
 MOV DH,Head;
 MOV DL,Disk;
 LES BX,Buffer;
 MOV AH,$03;
 INT $13;
END;

BEGIN { Main Unit }
END.