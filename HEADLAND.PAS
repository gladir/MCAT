(********************************************************)
(*                                                      *)
(*                Malte System/Head Land                *)
(*                     1993/03/07                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit HeadLand;

(********************************************************)
                      INTERFACE
(********************************************************)

Const

     _640x400_256_ScreenWidth  = 640;
     _640x400_256_ScreenPitch  = 640;
     _640x400_256_ScreenHeight = 400;
     _640x400_256_ScreenColors = 256;
     _640x400_256_ScreenPages  = 4;
     _640x400_256_GraphicsMode = $66;
     _640x400_256_CanDoRW      = $00;

Procedure ClearScreen(Color:Byte);
Procedure Copy8Bin(X,Y:Word;Value,Background,Foreground:Byte);
Procedure CopyLine(X1,Y,X2:Word;Var Buffer);
Procedure GetLine(X1,Y,X2:Word;Var Buffer);
Procedure PutBox(X1,Y1,X2,Y2:Word;Color:Byte);
Procedure PutLine(X1,Y,X2:Word;Color:Byte);
Procedure PutLineV(X,Y1,Y2:Word;Color:Byte);
Procedure SelectPage(Page:Byte);
Procedure SelectPage2_4(Page:Byte);
Procedure SelectPage16(Page:Byte);
Procedure SelectPage256(Page:Byte);
Procedure SetVideoMode(Mode:Byte);
Procedure WritePixel(X,Y:Word;Color:Byte);

Function ReadPixel(X,Y:Word):Byte;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses NumDirGr,DirectGraphic;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      ClearScreen                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure ClearScreen(Color:Byte);
Var J : Byte;
Begin
 For J := 0 to VG.MaxPage do
 Begin
  SelectPage(J);
  ASM
   {$IFOPT G+}
    PUSH $A000;
    POP  ES;
   {$ELSE}
    MOV AX,$A000;
    MOV ES,AX;
   {$ENDIF}
   XOR DI,DI;
   MOV CX,($FFFF) shr 1;
   MOV AL,Color;
   MOV AH,AL;
   CLD;
   REP STOSW;
  END;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      Copy8Bin                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure Copy8Bin(X,Y:Word;Value,Background,Foreground:Byte);
Var Address1,Address2 : LongInt;
    I                 : Word;
Begin
 Address1 := LongInt(X) + (LongInt(Y) * LongInt(VG.NumXPixels));
 Address2 := Address1 + 7;
 SelectPage(Byte(Address1 shr 16));
 If(Byte(Address1 shr 16) = Byte(Address2 shr 16))Then
 Begin
  ASM
   CLD;
   {$IFOPT G+}
    PUSH $A000;
    POP  ES;
   {$ELSE}
    MOV AX,$A000;
    MOV ES,AX;
   {$ENDIF}
   MOV DI,Word(Address1);
   MOV BH,Value;
   CMP BH,$0;
   JE  @@1;
   MOV AL,Foreground;
   CMP BH,$FF;
   JNE @@2;
   MOV AH,AL;
   MOV CX,4;
   REP STOSW;
   JMP @@6;
@@1:
   MOV CX,4;
   MOV AL,Background;
   MOV AH,AL;
   REP STOSW;
   JMP @@6;
@@2:
   MOV DL,Background;
   MOV DH,AL;
   MOV CX,8;
@@3:
   MOV BL,BH;
   ROR BL,CL;
   JC  @@4;
   MOV AL,DL;
   STOSB;
   LOOP @@3;
   JMP @@6;
@@4:
   MOV AL,DH;
   STOSB;
   LOOP @@3;
@@6:
  END;
 End
  else
 Begin
  For I := 7 downto 0 do
  Begin
   If(((Value shr I) and 1) = 1)Then Mem[$A000:Address1] := Background
                                Else Mem[$A000:Address1] := Foreground;
   Inc(Address1);
   SelectPage(Byte(Address1 shr 16));
  End;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      CopyLine                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure CopyLine(X1,Y,X2:Word;Var Buffer);
Var AddressY,Address1,Address2,AddrTmp2 : LongInt;
    T,Marge,AddrTmp                     : Word;
Begin
 AddressY := (LongInt(Y) * LongInt(VG.NumXPixels));
 Address1 := LongInt(X1) + AddressY;
 Address2 := LongInt(X2) + AddressY;
 SelectPage(Address1 shr 16);
 If(Byte(Address1 shr 16) = Byte(Address2 shr 16))Then
 Begin
  Move(Mem[$A000:Address1],Buffer,(X2-X1+1));
 End
  Else
 Begin
  Marge := $FFFF - Word(AddressY);
  AddrTmp := (Marge-X1)+1;
  Move(Mem[$A000:Word(Address1)],Buffer,AddrTmp);
  T := (X1 + AddrTmp);
  AddrTmp2 := LongInt(T) + AddressY;
  SelectPage(Address2 shr 16);
  Move(Mem[Seg(Buffer):Ofs(Buffer)+Word(Address2)-Word(AddrTmp2)],
       Mem[$A000:Word(AddrTmp2)],(X2-T)+1);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetLine                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure GetLine(X1,Y,X2:Word;Var Buffer);
Var AddressY,Address1,Address2,AddrTmp2 : LongInt;
    T,Marge,AddrTmp                     : Word;
Begin
 AddressY := (LongInt(Y) * LongInt(VG.NumXPixels));
 Address1 := LongInt(X1) + AddressY;
 Address2 := LongInt(X2) + AddressY;
 SelectPage(Address1 shr 16);
 If(Byte(Address1 shr 16) = Byte(Address2 shr 16))Then
 Begin
  Move(Mem[$A000:Address1],Buffer,(X2-X1+1));
 End
  Else
 Begin
  Marge := $FFFF - Word(AddressY);
  AddrTmp := (Marge-X1)+1;
  Move(Mem[$A000:Word(Address1)],Buffer,AddrTmp);
  T := (X1 + AddrTmp);
  AddrTmp2 := LongInt(T) + AddressY;
  SelectPage(Address2 shr 16);
  Move(Mem[$A000:Word(AddrTmp2)],
       Mem[Seg(Buffer):Ofs(Buffer)+Word(Address2)-Word(AddrTmp2)],(X2-T)+1);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       PutBox                         ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure PutBox(X1,Y1,X2,Y2:Word;Color:Byte);
Var J : Word;
Begin
 For J := Y1 to Y2 do PutLine(X1,J,X2,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       PutLine                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure PutLine(X1,Y,X2:Word;Color:Byte);
Var AddressY,Address1,Address2,AddrTmp2 : LongInt;
    T,Marge,AddrTmp                     : Word;
Begin
 AddressY := (LongInt(Y) * LongInt(VG.NumXPixels));
 Address1 := LongInt(X1) + AddressY;
 Address2 := LongInt(X2) + AddressY;
 SelectPage(Address1 shr 16);
 If(Byte(Address1 shr 16) = Byte(Address2 shr 16))Then
 Begin
  FillChar(Mem[$A000:Address1],(X2-X1+1),Color);
 End
  Else
 Begin
  Marge := $FFFF - Word(AddressY);
  AddrTmp := (Marge-X1)+1;
  FillChar(Mem[$A000:Word(Address1)],AddrTmp,Color);
  T := (X1 + AddrTmp);
  AddrTmp2 := LongInt(T) + AddressY;
  SelectPage(Address2 shr 16);
  FillChar(Mem[$A000:Word(AddrTmp2)],(X2-T)+1,Color);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       PutLineV                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure PutLineV(X,Y1,Y2:Word;Color:Byte);
Var Address : LongInt;
    J       : Word;
Begin
 Address := Get8BitAddress(X,Y1);
 For J := Y1 to Y2 do
 Begin
  SelectPage(Byte(Address shr 16));
  Mem[$A000:Word(Address)] := Color;
  Inc(Address,VG.NumXPixels);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     SelectPage2_4                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SelectPage2_4(Page:Byte);
Assembler;
ASM
 MOV AL,Page;
 MOV DX,$3CC;
 IN  AL,DX;
 AND AL,Not($20);
 NOT AH;
 AND AH,1;
 {$IFOPT G+}
  SHL AH,5;
 {$ELSE}
  SHL AH,1;
  SHL AH,1;
  SHL AH,1;
  SHL AH,1;
  SHL AH,1;
 {$ENDIF}
 OR  AL,AH;
 MOV DX,$3C2;
 OUT DX,AL;
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     SelectPage16                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SelectPage16(Page:Byte);
Assembler;
ASM
 MOV AL,Page;
 CMP AL,VG.RW_Page;
 JE  @@2;
 MOV DX,$3C4;
 MOV AL,$F6;
 OUT DX,AL;
 INC DX;
 IN  AL,DX;
 AND AL,$F0;
 MOV BL,VG.RW_Page;
 AND BL,$03;
 MOV BH,BL;
 {$IFOPT G+}
  SHL BL,2;
 {$ELSE}
  SHL BL,1;
  SHL BL,1;
 {$ENDIF}
 OR  AL,BH;
 OR  AL,BL;
 OUT DX,AL;
@@2:
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SelectPage256                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SelectPage256(Page:Byte);
Assembler;
ASM
 MOV AL,Page;
 CMP AL,VG.RW_Page;
 JE  @@2;
 MOV DX,$3CC;
 IN  AL,DX
 AND AL,NOT($20);
 AND AH,2;
 {$IFOPT G+}
  SHL AH,4;
 {$ELSE}
  SHL AH,1;
  SHL AH,1;
  SHL AH,1;
  SHL AH,1;
 {$ENDIF}
 OR  AL,AH;
 MOV DX,$3C2;
 OUT DX,AL;
 MOV DX,$3C4;
 MOV AL,$F9;
 MOV AH,VG.RW_Page;
 AND AH,1;
 OUT DX,AX;
 MOV AL,$F6;
 OUT DX,AL;
 INC DX;
 IN  AL,DX;
 AND AL,$F0;
 MOV BL,VG.RW_Page;
 AND BL,$0C;
 MOV BH,BL;
 {$IFOPT G+}
  SHR BL,2;
 {$ELSE}
  SHR BL,1;
  SHR BL,1;
 {$ENDIF}
 OR  AL,BH;
 OR  AL,BL;
 OUT DX,AL;
@@2:
END;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       SelectPage                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SelectPage(Page:Byte);
Begin
 If(Page <> VG.RW_Page)Then Exit;
 Case VG.NumColors of
  2,4 : SelectPage2_4(Page);
   16 : SelectPage16(Page);
  256 : SelectPage256(Page);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SetVideoMode                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure SetVideoMode(Mode:Byte);
Begin
 ASM
  MOV AL,Mode;
  XOR AH,AH;
  INT $10;
 END;
 Case Mode of
  _640x400_256_GraphicsMode : Begin
                               VG.NumXPixels := 640;
                               VG.MaxPage := (_640x400_256_ScreenPages - 1);
                              End;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      WritePixel                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure WritePixel(X,Y:Word;Color:Byte);
Var Address : LongInt;
Begin
 Address := Get8BitAddress(X,Y);
 SelectPage(Address shr 16);
 Mem[$A000:Word(Address)] := Color;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       ReadPixel                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function ReadPixel(X,Y:Word):Byte;
Var Address : LongInt;
Begin
 Address := Get8BitAddress(X,Y);
 SelectPage(Address shr 16);
 ReadPixel := Mem[$A000:Word(Address)];
End;

BEGIN { Main Unit }
END.