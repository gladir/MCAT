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

{ ������������������������������������������������������Ŀ
  �                   ViewerFiles.Init                   ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Constructor ViewerFiles.Init;
Begin
 P := 0; L := 0;
 SizeBuffer := DefaultSizeBuffer;
 Buffer := NIL;
 GetMem(Buffer,SizeBuffer);
End;

{ ������������������������������������������������������Ŀ
  �                   ViewerFiles.Load                   ��
  ���������������������������������������������������������
   ��������������������������������������������������������

  D�finition :

   � Cette proc�dure inialise l'objet tous en lisant le
     premier secteur du fichier (R�gle g�n�rale : 2048
     octet (sois 2K)).

  Note :

   � Cette proc�dure n'a pas besoin d'�tre pr�c�d� par une
     la proc�dure d'initialisation.
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

{ ������������������������������������������������������Ŀ
  �               ViewerFiles.PrevLine                   ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Procedure ViewerFiles.PrevLine;
Begin
 If(P = 0)Then Exit;
End;

{ ������������������������������������������������������Ŀ
  �               ViewerFiles.NextLine                   ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Procedure ViewerFiles.NextLine;
Begin
End;

{ ������������������������������������������������������Ŀ
  �                ViewerFiles.GetLine                   ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Procedure ViewerFiles.GetLine(Var _Buffer);
Begin
End;

{ ������������������������������������������������������Ŀ
  �              ViewerFiles.GetLengthLine               ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Function ViewerFiles.GetLengthLine:Word;
Begin
End;

{ ������������������������������������������������������Ŀ
  �                ViewerFiles.SearchLine                ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Function ViewerFiles.SearchLine(L:LongInt):Boolean;
Begin
End;

{ ������������������������������������������������������Ŀ
  �                   ViewerFiles.Done                   ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Destructor ViewerFiles.Done;
Begin
 FreeMem(Buffer,SizeBuffer);
End;

BEGIN { Main Unit }
END.