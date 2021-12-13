(********************************************************)
(*                                                      *)
(*              Malte System/Gadget Mouse               *)
(*                    1993/05/19                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit GadgetMouse;

(********************************************************)
                        INTERFACE
(********************************************************)

Procedure SetMousePtrText;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses DOS,MEM_TXT,Text,Mouse;

Procedure PtrTextMove(Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP:Word);
Interrupt;
Const IsInit : Boolean = False;
Begin
 IsInit := Not(IsInit);
 MEM_SetAttr((CX div 8),(DX div 8),
             Mem[TextSegment:(((DX div 8)*VD.ColnDouble)+(CX div 8))+1]);
 MOUSE.SetPtrPos(CX,DX);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SetMousePtrText                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetMousePtrText;
Var Reg : Registers;
Begin
{ If(VC.Methode = ScrnDirect)Then}
 With Reg do
 Begin
  {SetSubMove(Seg(PtrTextMove),Ofs(PtrTextMove));}
  AX := $000C;
  CX := $7F;
  ES := Seg(PtrTextMove);
  DX := Ofs(PtrTextMove);
  Intr($33,Reg);
 End;
End;

BEGIN { Main Unit }
END.