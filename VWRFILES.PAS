(********************************************************)
(*                                                      *)
(*               Malte System/Viewer Files              *)
(*                     1993/04/05                       *)
(*                                                      *)
(*       Copyright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit VwrFiles;

(********************************************************)
                        INTERFACE
(********************************************************)

Uses DOS,TPointer;

Const

      DefaultSizeBuffer    = 2048;
      DefaultSizeBufferEMS = 16384;

Type

     ViewerFiles = Object
                    Buffer:^TByte;
                    SizeBuffer:Word;
                    P,L:LongInt;
                    _Path:PathStr;
                    Constructor Init;
                    Constructor Load(Path:PathStr);
                    Procedure PrevLine;
                    Procedure NextLine;
                    Procedure GetLine(Var _Buffer);
                    Function GetLengthLine:Word;
                    Function SearchLine(L:LongInt):Boolean;
                    Destructor Done;
                   End;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses Handle;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   ViewerFiles.Init                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Constructor ViewerFiles.Init;
Begin
 P := 0; L := 0;
 SizeBuffer := DefaultSizeBuffer;
 Buffer := NIL;
 GetMem(Buffer,SizeBuffer);
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   ViewerFiles.Load                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽

  D괽inition :

   � Cette proc괺ure inialise l'objet tous en lisant le
     premier secteur du fichier (R둮le g굈굍ale : 2048
     octet (sois 2K)).

  Note :

   � Cette proc괺ure n'a pas besoin d'늯re pr괹괺� par une
     la proc괺ure d'initialisation.
}

Constructor ViewerFiles.Load(Path:PathStr);
Var _Handle : Word;
Begin
 Init;
 _Path := Path;
 _Handle := Handle.Open(_Path,ReadOnly);
 Handle.GetRecord(_Handle,0,SizeBuffer,Buffer^);
 Handle.Close(_Handle);
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �               ViewerFiles.PrevLine                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Procedure ViewerFiles.PrevLine;
Begin
 If(P = 0)Then Exit;
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �               ViewerFiles.NextLine                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Procedure ViewerFiles.NextLine;
Begin
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                ViewerFiles.GetLine                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Procedure ViewerFiles.GetLine(Var _Buffer);
Begin
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �              ViewerFiles.GetLengthLine               넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function ViewerFiles.GetLengthLine:Word;
Begin
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                ViewerFiles.SearchLine                넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function ViewerFiles.SearchLine(L:LongInt):Boolean;
Begin
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   ViewerFiles.Done                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Destructor ViewerFiles.Done;
Begin
 FreeMem(Buffer,SizeBuffer);
End;

BEGIN { Main Unit }
END.