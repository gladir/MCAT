(********************************************************)
(*                                                      *)
(*         Malte System/Numeric Direct Graphic          *)
(*                   1993/03/10                         *)
(*                                                      *)
(*     Copyright (C) par les Chevaliers de Malte        *)
(*                                                      *)
(********************************************************)

Unit NumDirGr;

(********************************************************)
                       INTERFACE
(********************************************************)

 { PUBLIC: }

Function GetAddrXY(X,Y:Word):Pointer;
Function GetAddrReadXY(X,Y:Word):Pointer;
Function GetAddrWriteXY(X,Y:Word):Pointer;
Function GetBitPerPixel(Color:LongInt):Byte;
Function GetBytesPerScanLine:Word;
Function GetMaxPage:Byte;
Function GetRealAddress(X,Y:Word):LongInt;
Function GetScreenSize:LongInt;

 { PRIVATE: }

{$IFDEF __GRAPHDIRECT__}
 Function Get8BitAddress(X,Y:Word):LongInt;
{$ENDIF}

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

{$IFDEF __GRAPHDIRECT__}
 Uses DirectGraphic;
{$ELSE}
 Uses DirecTxt;
{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetAddrXY                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __GRAPHDIRECT__}

 Function GetAddrXY(X,Y:Word):Pointer;
 Var Address : LongInt;
 Begin
  Address := GetRealAddress(X,Y);
  SetPhysicalPage(Byte(Address shr 16));
  GetAddrXY := Ptr(VG.AddrSegment,Word(Address));
 End;

{$ELSE}

 Function GetAddrXY(X,Y:Word):Pointer;
 Begin
  GetAddrXY := Ptr(VD.Address,((X + (Y * VD.Coln)) shl 1));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   GetAddrReadXY                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __GRAPHDIRECT__}

 Function GetAddrReadXY(X,Y:Word):Pointer;
 Var Address : LongInt;
 Begin
  Address := GetRealAddress(X,Y);
  SetPhysicalReadPage(Byte(Address shr 16));
  GetAddrReadXY := Ptr(VG.AddrSegment,Word(Address));
 End;

{$ELSE}

 Function GetAddrReadXY(X,Y:Word):Pointer;
 Begin
  GetAddrReadXY := Ptr(VD.Address,((X + (Y * VD.Coln)) shl 1));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  GetAddrWriteXY                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __GRAPHDIRECT__}

 Function GetAddrWriteXY(X,Y:Word):Pointer;
 Var Address : LongInt;
 Begin
  Address := GetRealAddress(X,Y);
  SetPhysicalWritePage(Byte(Address shr 16));
  GetAddrWriteXY := Ptr(VG.AddrSegment,Word(Address));
 End;

{$ELSE}

 Function GetAddrWriteXY(X,Y:Word):Pointer;
 Begin
  GetAddrWriteXY := Ptr(VD.Address,((X + (Y * VD.Coln)) shl 1));
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    Get8BitAddress                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __GRAPHDIRECT__}

 {$IFDEF __ASSEMBLERSUPPORT__}

  Function Get8BitAddress(X,Y:Word):LongInt;
  Assembler;
  ASM
   MOV AX,Y;
   MUL VG.NumXPixels;
   ADD AX,X;
   ADC DX,0;
   MOV BX,DX;
  End;

 {$ELSE}

  Function Get8BitAddress(X,Y:Word):LongInt;
  Begin
   Get8BitAddress := LongInt(LongInt(X) + (LongInt(Y) * LongInt(VG.NumXPixels)));
  End;

 {$ENDIF}

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  GetRealAddress                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __GRAPHDIRECT__}

 Function GetRealAddress(X,Y:Word):LongInt;
 Begin
  GetRealAddress := Get8BitAddress(X,Y);
 End;

{$ELSE}

 Function GetRealAddress(X,Y:Word):LongInt;
 Begin
  GetRealAddress := ((X + (Y * VD.Coln)) shl 1);
 End;

{$ENDIF}

{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                   GetBitPerPixel                     ³Û
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
  ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   Syntaxe :

    Function GetBitPerPixel(Color:Word):Byte;

   D‚finition :

    ş Cette proc‚dure calcul combien prend de bit(s) le
      nombre de couleur disponible.

   Note :

    ş Les fonctions shr (shift right) et shl (shift left)
      font un d‚calage des bits dans la direction indiqu‚.
      Les espaces lib‚r‚s sont remplacer par des 0.
 }

Function GetBitPerPixel(Color:LongInt):Byte;
Var I : Byte;
Begin
 For I := 31 downto 0 do
 Begin
  If(((Color shr I) and 1) = 1)Then
  Begin
   GetBitPerPixel := I;
   Exit;
  End;
 End;
 GetBitPerPixel := 0;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetScreenSize                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __GRAPHDIRECT__}

 Function GetScreenSize:LongInt;
 Begin
  GetScreenSize := (LongInt(VG.NumXPixels) * (LongInt(VG.NumYPixels)));
 End;

{$ELSE}

 Function GetScreenSize:LongInt;
 Begin
  GetScreenSize := ((VD.Coln * VD.Line) shl 1);
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetMaxPage                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __GRAPHDIRECT__}

 Function GetMaxPage:Byte;
 Begin
  VG.MaxPage := Byte((LongInt(VG.NumXPixels) * LongInt(VG.NumYPixels)) shr 18);
 End;

{$ELSE}

 Function GetMaxPage:Byte;
 Begin
  GetMaxPage := 0;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    GetBitPerScanLine                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

{$IFDEF __GRAPHDIRECT__}

 Function GetBytesPerScanLine:Word;
 Begin
  Case VG.NumColors of
   256 : GetBytesPerScanLine := VG.NumXPixels;
    Else GetBytesPerScanLine := VG.NumXPixels shr 3;
  End;
 End;

{$ELSE}

 Function GetBytesPerScanLine:Word;
 Begin
  GetBytesPerScanLine := VD.ColnDouble;
 End;

{$ENDIF}

BEGIN { Main Unit }
END.