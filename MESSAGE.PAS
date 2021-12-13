(*****************************************************************)
(*                                                               *)
(*                  Malte System/Put Message                     *)
(*                       1992/09/25                              *)
(*                                                               *)
(*         Copyright (C) par les Chevaliers de Malte             *)
(*                                                               *)
(*****************************************************************)

{ Programmeur :

   Sylvain Maltais

  DerniŠre modification :

   Mercredi, le 26 mai 1993 (Maintenant il peut s‚parer une phrase
                             … la position d'un tiret!).
}

Unit Message;

(*****************************************************************)
                                INTERFACE
(*****************************************************************)

Procedure _WMessage(X1,Y1,X2:Byte;Chn:String);
Procedure _WMessageTyping(X1,Y1,X2:Byte;Chn:String);

Function GetLineWMessage(X1,X2:Byte;Chn:String):Byte;

(****************************************************************)
                              IMPLEMENTATION
(****************************************************************)

Uses Text;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetLineWMessage                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function GetLineWMessage(X1,X2:Byte;Chn:String):Byte;
Var XS, AX, AY, Len, I : Byte;
Begin
 XS := (X2-X1)+1; Len := Length(Chn); AY := 0; AX := 0;
 While ((Len - AX) >= XS) do
 Begin
  I := AX + XS;
  While (((Chn[I-1] > ' ')and(Not(Chn[I-1] = '-')))and(I > AX)) do Dec(I);
  AX := I-1; Inc(AY);
 End;
 GetLineWMessage := AY + 1;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        _WMessage                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure _WMessage(X1,Y1,X2:Byte;Chn:String);
Var XS, AX, AY, Len, I, J : Byte;
Begin
 XS := (X2-X1)+1; Len := Length(Chn); AY := Y1; AX := 0;
 While ((Len - AX) >= XS) do
 Begin
  I := AX + XS;
  While (((Chn[I-1] > ' ')and(Not(Chn[I-1] = '-')))and(I > AX)) do Dec(I);
  For J := AX to I-2 do _SetCube(X1+J-AX,AY,Chn[J+1]);
  AX := J+1; Inc(AY);
 End;
 For J := AX to Len-1 do _SetCube(X1+J-AX,AY,Chn[J+1]);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     _WMessageTyping                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure _WMessageTyping(X1,Y1,X2:Byte;Chn:String);
Var XS, AX, AY, Len, I, NC : Byte;
Begin
 XS := (X2-X1)+2; Len := Length(Chn); AY := Y1; AX := 0;
 While ((Len - AX) >= XS) do
 Begin
  I := AX + XS; NC := 0;
  While ((Not(Chn[I-1] in [#0..' ','-','|']))and((I-NC) > AX)) do
  Begin
   If(Chn[I] = '^')Then Inc(NC);
   Dec(I);
  End;
  WriteTypingXY(X1,AY,Copy(Chn,AX,I-2-AX+1));
  AX := I; Inc(AY);
 End;
 WriteTypingXY(X1,AY,Copy(Chn,AX,Len-AX+1));
End;

BEGIN { Main Unit }
END.