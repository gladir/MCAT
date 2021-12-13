(********************************************************************)
(*                                                                  *)
(*                   Malte System/File Handle                       *)
(*                         1992/09/13                               *)
(*                                                                  *)
(*            Copyright (C) par les Chevaliers de Malte             *)
(*                                                                  *)
(********************************************************************)

{ Programmeur :

   Sylvain Maltais

  DerniŠre modification :

   Dimanche, le 9 mai 1993 (Debug  : FileSize),
                           (UpDate : Open).
   Lundi, le 17 mai 1993   (Addition : OpenSearchPath,
                            OpenSearchPathAndDOS).
   Samedi, le 29 mai 1993  (UpDate : FileSize, SetFilePos,
                            GetTime).
   Jeudi, le 3 juin 1993   (Addition : PushAll, PopAll,
                            PushOutput, ReDirHandle,
                            DuplicateHandle).
}

{$IFDEF OS2}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF WINDOWS}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF DPMI}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF VER10}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER15}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER60}
 {$DEFINE __ASSEMBLERSUPPORT__}
{$ENDIF}

{$IFDEF VER70}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
{$ENDIF}

{$IFDEF VER80}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
{$ENDIF}

Unit Handle;

(********************************************************************)
                               INTERFACE
(********************************************************************)

Uses DOS;

Const

       { M‚thode ouverture de handle }

      ReadOnly          = 0;
      WriteOnly         = 1;
      Normal            = 2;

       { Handle pr‚d‚finie }

      HandleInput       = 0; { Clavier }
      HandleOutput      = 1; { Ecran }
      HandleOutputError = 2; { Ecran }
      HandleAux         = 3; { Modem }
      HandlePrinter     = 4; { Imprimante }

      FileError : Word = 0;

Procedure AdditionRecord(Handle,Size:Word;Var Buffer);
Procedure Close(Handle:Word);
Procedure GetRecord(Handle:Word;P:LongInt;Size:Word;Var Buffer);
Procedure OutputToHandle(Handle:Word);
Procedure PopAll;
Procedure PushAll;
Procedure PushOutput;
Procedure Rename(Source,Target:PathStr);
Procedure ReDirHandle(ModelHandle,OtherHandle:Word);
Procedure SetFilePos(Handle:Word;P:LongInt);
Procedure SetFirstRecord(Handle,Size:Word;Var Buffer);
Procedure SetRecord(Handle:Word;P:LongInt;Size:Word;Var Buffer);
Procedure _GetRecord(Handle,Size:Word;Var Buffer);
Procedure _SetRecord(Handle,Size:Word;Var Buffer);

Function Del(Name:PathStr):Word;
Function DirExist(Dir:DirStr):Boolean;
Function DuplicateHandle(Handle:Word):Word;
Function New(Name:PathStr):Word;
Function NewTmp(Name:PathStr):Word;
Function New_(Name:PathStr;Attr:Word):Word;
Function NewAttr(Name:PathStr;Attr:Word):Boolean;
Function Open(Name:PathStr;Mode:Byte):Word;
Function OpenSearchPath(Path,Name:PathStr;Mode:Byte):Word;
Function OpenSearchPathAndDOS(Path,Name:PathStr;Mode:Byte):Word;
Function OpenAux:Word;
Function OpenPrn:Word;
Function OpenScrn:Word;
Function FileExist(Name:PathStr):Boolean;
Function FileSize(Handle:Word):LongInt;
Function GetFile(Name:PathStr;P:LongInt;Size:Word;Var Buffer):Word;
Function GetTime(Handle:Word;Var Time:LongInt):Word;
Function IsHandleError(Handle:Word):Boolean;
Function SearchFile(Path:PathStr;Var Name:PathStr;Var Size,Time:LongInt):Boolean;
Function SetFile(Name:PathStr;P:LongInt;Size:Word;Var Buffer):Word;
Function _GetFile(Name:PathStr;Size:Word;Var Buffer):Word;
Function _Open(Name:PathStr):Word;

(********************************************************************)
                             IMPLEMENTATION
(********************************************************************)

Uses Numeric;

{$IFDEF __EXTERNAL__}
 {$L CLOSEP.OBJ }
{$ENDIF}

Const

      _FileAttribut = Numeric.WordMax - (VolumeID + Directory);
      _HandleError  = Numeric.WordMax;

Var

    SaveInput,SaveOutput,SaveOutputError,SaveAux,SavePrinter : Word;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     OutputToHandle                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure OutputToHandle(Handle:Word);
Begin
 ReDirHandle(Handle,HandleOutput);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                         PopAll                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure PopAll;
Begin
 If(SaveInput < $FFFF)Then
  ReDirHandle(SaveInput,HandleInput);
 If(SaveOutput < $FFFF)Then
  ReDirHandle(SaveOutput,HandleOutput);
 If(SaveOutputError < $FFFF)Then
  ReDirHandle(SaveOutputError,HandleOutputError);
 If(SaveAux < $FFFF)Then
  ReDirHandle(SaveAux,HandleAux);
 If(SavePrinter < $FFFF)Then
  ReDirHandle(SavePrinter,HandlePrinter);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        PushAll                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure PushAll;
Begin
 If(SaveInput = $FFFF)Then
  SaveInput := DuplicateHandle(HandleInput);
 If(SaveOutput = $FFFF)Then
  SaveOutput := DuplicateHandle(HandleOutput);
 If(SaveOutputError = $FFFF)Then
  SaveOutputError := DuplicateHandle(HandleOutputError);
 If(SaveAux = $FFFF)Then
  SaveAux := DuplicateHandle(HandleAux);
 If(SavePrinter = $FFFF)Then
  SavePrinter := DuplicateHandle(HandlePrinter);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       PushOutput                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure PushOutput;
Begin
 If(SaveOutput = $FFFF)Then
  SaveOutput := DuplicateHandle(HandleOutput);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      ReDirHandle                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure ReDirHandle(ModelHandle,OtherHandle:Word);
Assembler;
ASM
 MOV AH,$46;
 MOV BX,ModelHandle;
 MOV CX,OtherHandle;
 INT $21;
 JC  @@2;
 XOR AX,AX;
@@2:
 MOV FileError,AX;
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  DuplicateHandle                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function DuplicateHandle(Handle:Word):Word;
Assembler;
ASM
 MOV AH,$45;
 MOV BX,Handle;
 INT $21;
 JNC @@2;
 MOV FileError,AX;
 XOR AX,AX;
@@2:
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     SearchFile                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function SearchFile(Path:PathStr;Var Name:PathStr;Var Size,Time:LongInt):Boolean;
Var Rec : SearchRec;
Begin
 FindFirst(Path,_FileAttribut,Rec);
 If(DOSError = 0)Then
 Begin
  Name       := Rec.Name;
  Size       := Rec.Size;
  Time       := Rec.Time;
  SearchFile := True;
 End
  Else
 SearchFile := False;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    IsHandleError                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function IsHandleError(Handle:Word):Boolean;
Begin
 IsHandleError := (Handle = _HandleError);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        NewAttr                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function NewAttr(Name:PathStr;Attr:Word):Boolean;
Begin
 NewAttr := Not(New_(Name,Attr) = _HandleError);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       Rename                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure Rename(Source,Target:PathStr);
 Assembler;
 ASM
  PUSH DS;
   LDS  SI,Source;
   MOV  BL,DS:[SI];
   INC  SI; { Set Source[1] }
   MOV  BH,0;
   MOV  DS:[SI+BX],BH; { Source := Source + #0 }
   MOV  DX,SI;
   LES  DI,Target;
   MOV  BL,ES:[DI];
   INC  DI; { Set Target[1] }
   MOV  ES:[DI+BX],BH; { Target := Target + #0 }
   MOV  AH,$56;
   INT  $21;
  POP DS;
  JC  @@2;
  XOR AX,AX;
@@2:
  MOV FileError,AX;
 END;

{$ELSE}

 Procedure Rename(Source,Target:PathStr);
 Var Reg : Registers;
 Begin
  Source := Source + #0;
  Target := Target + #0;
  Reg.AH := $56;
  Reg.DS := Seg(Source[1]);
  Reg.DX := Ofs(Source[1]);
  Reg.ES := Seg(Target[1]);
  Reg.DI := Ofs(Target[1]);
  MsDos(Reg);
  If((Reg.Flags and 1) = 1)Then FileError := Reg.AX
                           Else FileError := 0;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       Rename                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  D‚finition :

  ş Cette proc‚dure d‚place le pointeur du fichier Handle …
    la position sp‚cifi‚. Pour savoir si l'op‚ration c'est
    bien d‚rouler, il faut v‚rifier la valeur de "FileError"
    soit ‚gale … 0.
}

Procedure SetFilePos(Handle:Word;P:LongInt);
Assembler;
Const SizeOfWord = SizeOf(Word);
ASM
 LEA DI,P;
 MOV AX,$4200;
 MOV BX,Handle;
 MOV CX,SS:[DI+SizeOfWord];
 MOV DX,SS:[DI];
 INT $21;
 JC  @@1;
 XOR AX,AX;
@@1:
 MOV FileError,AX;
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       FileSize                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  D‚finition :

  ş Cette proc‚dure calcul la taille d'un fichier … partir
    de son num‚ro de Handle. Pour savoir si l'op‚ration
    c'est bien d‚roul‚, il faut tester la valeur de
    "FileError" soit ‚gale … -1.
}

Function FileSize(Handle:Word):LongInt;
Assembler;
ASM
 MOV AX,$4202;
 MOV BX,Handle;
 XOR CX,CX;
 XOR DX,DX;
 INT $21;
 JC  @@1;
 MOV BX,DX;
 MOV FileError,0;
 JMP @@2;
@@1:
 MOV FileError,AX;
 MOV AX,$FFFF;
 MOV BX,AX;
@@2:
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Close                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __EXTERNAL__}

 Procedure Close(Handle:Word); external;

{$ELSE}

 Procedure Close(Handle:Word);
 Assembler;
 ASM
  MOV AX,$3E00;
  MOV BX,Handle;
  INT $21;
  JNC @@1;
  XOR AX,AX;
@@1:
  MOV FileError,AX;
 END;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetTime                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetTime(Handle:Word;Var Time:LongInt):Word;
Assembler;
Const SizeOfWord = SizeOf(Word);
ASM
 MOV AX,$5700;
 MOV BX,Handle;
 INT $21;
 JC  @@1;
 MOV Word Ptr Time[0],CX;
 MOV Word Ptr Time[SizeOfWord],DX;
 XOR AX,AX;
@@1:
 MOV FileError,AX;
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Open                          ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function Open(Name:PathStr;Mode:Byte):Word;
Assembler;
ASM
 PUSH DS;
  MOV  AX,$3D40;
  OR   AL,Mode;
  LDS  DI,Name;
  MOV  BL,DS:[DI];
  INC  DI; { Set Name[1] }
  MOV  BH,0;
  MOV  DS:[DI+BX],BH; { Name := Name + #0 }
  MOV  DX,DI;
  INT  $21;
 POP  DS;
 JC   @@1;
 MOV  FileError,0;
 JMP  @@2;
@@1:
 MOV  FileError,AX;
 MOV  AX,_HandleError;
@@2:
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   OpenSearchPath                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function OpenSearchPath(Path,Name:PathStr;Mode:Byte):Word;
Var Dir : PathStr;
Begin
 Dir := FSearch(Name,Path);
 OpenSearchPath := Open(FExpand(Dir),Mode);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   OpenSearchPath                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function OpenSearchPathAndDOS(Path,Name:PathStr;Mode:Byte):Word;
Var Dir : PathStr;
Begin
 Dir := FSearch(Name,Path);
 If(Dir = '')Then FSearch(Name,GetEnv('PATH'));
 OpenSearchPathAndDOS := Open(FExpand(Dir),Mode);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       _Open                          ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function _Open(Name:PathStr):Word;
Begin
 _Open := Open(Name,Normal);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     OpenScrn                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function OpenScrn:Word;
Begin
 OpenScrn := HandleOutput;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      OpenAux                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function OpenAux:Word;
Begin
 OpenAux := HandleAux;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      OpenPrn                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function OpenPrn:Word;
Begin
 OpenPrn := HandlePrinter;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      NewTmp                          ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function NewTmp(Name:PathStr):Word;
Assembler;
ASM
 PUSH DS;
  LDS DI,Name;
  MOV BL,DS:[DI];
  INC DI;
  MOV BH,0;
  MOV DS:[DI+BX],BH; { Name := Name + #0 }
  MOV DX,DI;
  MOV AH,$5A;
  XOR CX,CX;
  INT $21;
 POP DS;
 JC  @@1;
 MOV FileError,0;
 JMP @@2;
@@1:
 MOV FileError,AX;
 MOV AX,_HandleError;
@@2:
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        New                           ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function New(Name:PathStr):Word;
Assembler;
ASM
 PUSH DS;
  LDS DI,Name;
  MOV BL,DS:[DI];
  INC DI;
  MOV BH,0;
  MOV DS:[DI+BX],BH; { Name := Name + #0 }
  MOV DX,DI;
  MOV AH,$3C;
  XOR CX,CX;
  INT $21;
 POP DS;
 JC  @@1;
 MOV FileError,0;
 JMP @@2;
@@1:
 MOV FileError,AX;
 MOV AX,_HandleError;
@@2:
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        New_                          ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function New_(Name:PathStr;Attr:Word):Word;
Assembler;
ASM
 PUSH DS;
  MOV CX,Attr;
  LDS DI,Name;
  MOV BL,DS:[DI];
  INC DI; { Set Name[1] }
  MOV BH,0;
  MOV DS:[DI+BX],BH; { Name := Name + #0 }
  MOV DX,DI;
  MOV AH,$3C;
  INT $21;
 POP DS;
 JC  @@1;
 MOV FileError,0;
 JMP @@2;
@@1:
 MOV FileError,AX;
 MOV AX,_HandleError;
@@2:
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        Del                           ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function Del(Name:PathStr):Word;
Assembler;
ASM
 PUSH DS;
  LDS DI,Name;
  MOV BL,DS:[DI];
  INC DI;
  MOV BH,0;
  MOV DS:[DI+BX],BH;
  MOV DX,DI;
  MOV AX,$4100;
  INT $21;
 POP DS;
 JC  @@2;
 XOR AX,AX;
@@2:
 MOV FileError,AX;
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    GetRecord                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure GetRecord(Handle:Word;P:LongInt;Size:Word;Var Buffer);
Begin
 SetFilePos(Handle,P*LongInt(Size));
 _GetRecord(Handle,Size,Buffer);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    _GetRecord                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

 Note :

  ş Avant de copier les informations dans le Tampon, il fixe
    les donn‚es de ce tampon … 0 (FillChar(Buffer,Size,0)).
}

Procedure _GetRecord(Handle,Size:Word;Var Buffer);
Assembler;
ASM
 CLD;
 MOV AX,$3F00;
 MOV CX,Size;
 LES DI,Buffer;
 REP STOSB;
 PUSH DS;
  MOV BX,Handle;
  MOV CX,Size;
  LDS DX,Buffer;
  INT $21;
 POP DS;
 JC  @@1;
 XOR AX,AX;
@@1:
 MOV FileError,AX;
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     SetRecord                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure SetRecord(Handle:Word;P:LongInt;Size:Word;Var Buffer);
Begin
 SetFilePos(Handle,P*LongInt(Size));
 _SetRecord(Handle,Size,Buffer);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  SetFirstRecord                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure SetFirstRecord(Handle,Size:Word;Var Buffer);
Begin
 SetRecord(Handle,0,Size,Buffer);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      _SetRecord                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure _SetRecord(Handle,Size:Word;Var Buffer);
Assembler;
ASM
 PUSH DS;
  MOV BX,Handle;
  MOV CX,Size;
  LDS DX,Buffer;
  MOV AX,$4000;
  INT $21;
 POP DS;
 JC  @@1;
 XOR AX,AX;
@@1:
 MOV FileError,AX;
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  AdditionRecord                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure AdditionRecord(Handle,Size:Word;Var Buffer);
Begin
 SetRecord(Handle,LongInt(FileSize(Handle) div Size),Size,Buffer);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      _GetFile                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function _GetFile(Name:PathStr;Size:Word;Var Buffer):Word;
Var Handle : Word;
Begin
 Handle := Open(Name,ReadOnly);
 If(IsHandleError(Handle))Then
 Begin
  _GetFile := Handle;
  Exit;
 End;
 GetRecord(Handle,0,Size,Buffer);
 Close(Handle);
 _GetFile := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetFile                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetFile(Name:PathStr;P:LongInt;Size:Word;Var Buffer):Word;
Var Handle : Word;
Begin
 Handle := Open(Name,ReadOnly);
 If(IsHandleError(Handle))Then
 Begin
  GetFile := Handle;
  Exit;
 End;
 GetRecord(Handle,P,Size,Buffer);
 Close(Handle);
 GetFile := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SetFile                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function SetFile(Name:PathStr;P:LongInt;Size:Word;Var Buffer):Word;
Var Handle : Word;
Begin
 Handle := Open(Name,WriteOnly);
 If(IsHandleError(Handle))Then
 Begin
  SetFile := Handle;
  Exit;
 End;
 SetRecord(Handle,P,Size,Buffer);
 Close(Handle);
 SetFile := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       FileExist                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function FileExist(Name:PathStr):Boolean;
Var Rec : SearchRec;
Begin
 FindFirst(Name,_FileAttribut,Rec);
 FileExist := (DOSError = 0);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        DirExist                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function DirExist(Dir:DirStr):Boolean;
Var Rec   : SearchRec;
Begin
 FindFirst(Dir,Directory,Rec);
 DirExist := (DOSError = 0);
End;

BEGIN { Main Unit }
 SaveInput       := $FFFF;
 SaveOutput      := $FFFF;
 SaveOutputError := $FFFF;
 SaveAux         := $FFFF;
 SavePrinter     := $FFFF;
END.