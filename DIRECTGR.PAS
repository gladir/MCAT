(********************************************************)
(*                                                      *)
(*            Malte System/Direct Graphics              *)
(*                    1993/03/07                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit DirectGraphic;

(********************************************************)
                       INTERFACE
(********************************************************)

Uses TPointer;

Const

      _CGA              = 1;
      _Hercule          = 2;
      _GS               = 3;
      _PC3270           = 4;
      _EGA              = 5;
      _MCGA             = 6;
      _PGA              = 7;
      _VGA              = 8;
      _VESA             = 9;
      _AHead            = 10;
      _ATI              = 11;
      _Everex           = 12;
      _Genoa            = 13;
      _HeadLand         = 14;
      _STB              = 15;
      _Trident          = 16;
      _Tseng            = 17;
      _Tseng4000        = 18;
      _Video7           = 19;

      _DefaultMode      = -1;  { Restore to original mode. }
      _MaxResMode       = -2;  { Highest resolution. }
      _MaxColorMode     = -3;  { Maximum colors. }
      _MinRes4Color     = -4;  { 320x200, 4 colors. }
      _MinResNoColor    = -5;  { 320x200, 4 gray. }

      _DefaultSVGAMode  = -31; { 640x480, 256 colors }
      _MinSVGAMode      = -32; { 640x400, 256 colors, uses _DefaultSVGAMode
                                 if mode not exist. }
      _EnhSVGAMode      = -33; { 800x600, 256 colors, uses _DefaultSVGAMode
                                 if mode not exist. }
      _MaxSVGAMode      = -34; { 1024x768, 256 colors, uses _EnhancedSVGAMode
                                 if not exist. }

Var

    GBuffer : ^TByte;

    VG : Record
          {PUBLIC:}
          NumXPixels    : Word;
          NumYPixels    : Word;
          MaxXPixels    : Word;
          MaxYPixels    : Word;
          NumColors     : LongInt;
          BitsPerPixel  : Word;
          NumVideoPages : Byte;
          Mode          : Integer;
          Adaptor       : Byte;
          Monitor       : Byte;
          Memory        : LongInt;
          {PRIVATE:}
          BytesPerScanLine : Word;
          AddrSegment      : Word;
          MaxPage          : Byte;
          {$IFNDEF __OPTIMIZESIZE__}
           R_Page       : Byte;
           W_Page       : Byte;
           RW_Page      : Byte;
          {$ENDIF}
         End;

Procedure ClearScreen(Color:Byte);
Procedure GetImageLine(X1,Y,X2:Word;Var Buffer);
Procedure PutBinByte(X,Y:Word;Value,Background,Foreground:Byte);
Procedure PutBinByteTo(X,Y:Word;Var Value;Num,Background,Foreground:Byte);
Procedure PutBinByteAToB(X,Y:Word;Var Value;A,B,Background,Foreground:Byte);
Procedure PutChar8x8(X,Y:Word;Chr:Char;Background,Foreground:Byte);
Procedure PutFillBox(X1,Y1,X2,Y2:Word;Color:Byte);
Procedure PutImageLine(X1,Y,X2:Word;Var Buffer);
Procedure PutLine(X1,Y1,X2,Y2:Word;Color:Byte);
Procedure PutLineHori(X1,Y,X2:Word;Color:Byte);
Procedure PutLineNot(X1,Y1,X2,Y2:Word);
Procedure PutLineVert(X,Y1,Y2:Word;Color:Byte);
Procedure PutPixel(X,Y:Word;Color:Byte);
Procedure PutRectangle(X1,Y1,X2,Y2:Word;Color:Byte);
Procedure PutRectangleNot(X1,Y1,X2,Y2:Word);
Procedure SetPhysicalPage(Page:Byte);
Procedure SetPhysicalReadPage(Page:Byte);
Procedure SetPhysicalWritePage(Page:Byte);
Procedure SetVideoCard(Card:Byte);
Procedure SetVideoEmulText(Mode:Byte);

Function AutoDetectAdaptor:Byte;
Function GetMaxColor:Word;
Function GetMaxX:Word;
Function GetMaxY:Word;
Function GetMemory:LongInt;
Function GetPixel(X,Y:Word):Byte;
Function GetVideoCard:Byte;
Function GetVideoMode:Byte;
Function GetVideoSeg:Word;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses

     AHead,     { Super VGA }
     ATI,       { EGA/VGA Wonder }
     Everex,    { Super VGA }
     Genoa,     { Super VGA }
     HeadLand,  { Super VGA }
     PC3270,    { IBM PC 3270 }
     Trident,   { Super VGA }
     Tseng,     { Super VGA }
     VESA,      { La Norme VESA (Super VGA) }
     Video7,    { Super VGA }
     NumDirGr,Mtx8x8,ChkVideo,BiosText;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetVideoSeg                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetVideoSeg:Word;
Begin
 GetVideoSeg := VG.AddrSegment;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      ClearScreen                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure ClearScreen(Color:Byte);
Begin
 Case VG.Adaptor of
      _AHead : AHead.ClearScreen(Color);
     _Everex : Everex.ClearScreen(Color);
      _Genoa : Genoa.ClearScreen(Color);
   _HeadLand : HeadLand.ClearScreen(Color);
    _Trident : Trident.ClearScreen(Color);
      _Tseng : Tseng.ClearScreen(Color);
  _Tseng4000 : Tseng4000ClearScreen(Color);
       _VESA : VESA.ClearScreen(Color);
     _Video7 : Video7.ClearScreen(Color);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetImageLine                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure GetImageLine(X1,Y,X2:Word;Var Buffer);
Begin
 Case VG.Adaptor of
      _AHead : AHead.GetLine(X1,Y,X2,Buffer);
     _Everex : Everex.GetLine(X1,Y,X2,Buffer);
      _Genoa : Genoa.GetLine(X1,Y,X2,Buffer);
   _HeadLand : HeadLand.GetLine(X1,Y,X2,Buffer);
    _Trident : Trident.GetLine(X1,Y,X2,Buffer);
      _Tseng : Tseng.GetLine(X1,Y,X2,Buffer);
  _Tseng4000 : Tseng4000GetLine(X1,Y,X2,Buffer);
       _VESA : VESA.GetLine(X1,Y,X2,Buffer);
     _Video7 : Video7.GetLine(X1,Y,X2,Buffer);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       PutBinByte                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutBinByte(X,Y:Word;Value,Background,Foreground:Byte);
Begin
 Case VG.Adaptor of
      _AHead : AHead.Copy8Bin(X,Y,Value,Background,Foreground);
     _Everex : Everex.Copy8Bin(X,Y,Value,Background,Foreground);
      _Genoa : Genoa.Copy8Bin(X,Y,Value,Background,Foreground);
   _HeadLand : HeadLand.Copy8Bin(X,Y,Value,Background,Foreground);
    _Trident : Trident.Copy8Bin(X,Y,Value,Background,Foreground);
      _Tseng : Tseng.Copy8Bin(X,Y,Value,Background,Foreground);
  _Tseng4000 : Tseng4000Copy8Bin(X,Y,Value,Background,Foreground);
       _VESA : VESA.Copy8Bin(X,Y,Value,Background,Foreground);
     _Video7 : Video7.Copy8Bin(X,Y,Value,Background,Foreground);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     PutBinByteAToB                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutBinByteAToB(X,Y:Word;Var Value;A,B,Background,Foreground:Byte);
Var J : Byte;
    P : ^TByte;
Begin
 P := @Value; Dec(A); Dec(B);
 Case VG.Adaptor of
      _AHead : For J := A to B do
                AHead.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
     _Everex : For J := A to B do
                Everex.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
      _Genoa : For J := A to B do
                Genoa.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
   _HeadLand : For J := A to B do
                HeadLand.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
    _Trident : For J := A to B do
                Trident.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
      _Tseng : For J := A to B do
                Tseng.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
  _Tseng4000 : For J := A to B do
                Tseng4000Copy8Bin(X,Y+J,P^[J],Background,Foreground);
       _VESA : For J := A to B do
                VESA.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
     _Video7 : For J := A to B do
                Video7.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     PutBinByteTo                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutBinByteTo(X,Y:Word;Var Value;Num,Background,Foreground:Byte);
Var J : Byte;
    P : ^TByte;
Begin
 P := @Value; Dec(Num);
 Case VG.Adaptor of
      _AHead : For J := 0 to Num do
                AHead.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
     _Everex : For J := 0 to Num do
                Everex.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
      _Genoa : For J := 0 to Num do
                Genoa.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
   _HeadLand : For J := 0 to Num do
                HeadLand.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
    _Trident : For J := 0 to Num do
                Trident.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
      _Tseng : For J := 0 to Num do
                Tseng.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
  _Tseng4000 : For J := 0 to Num do
                Tseng4000Copy8Bin(X,Y+J,P^[J],Background,Foreground);
       _VESA : For J := 0 to Num do
                VESA.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
     _Video7 : For J := 0 to Num do
                Video7.Copy8Bin(X,Y+J,P^[J],Background,Foreground);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      PutChar8x8                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutChar8x8(X,Y:Word;Chr:Char;Background,Foreground:Byte);
Var P : ^TByte;
Begin
 P := @Matrix8x8;
 PutBinByteTo(X,Y,P^[Byte(Chr)*8],8,Background,Foreground);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      PutFillBox                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutFillBox(X1,Y1,X2,Y2:Word;Color:Byte);
Begin
 Case VG.Adaptor of
      _AHead : AHead.PutBox(X1,Y1,X2,Y2,Color);
     _Everex : Everex.PutBox(X1,Y1,X2,Y2,Color);
      _Genoa : Genoa.PutBox(X1,Y1,X2,Y2,Color);
   _HeadLand : HeadLand.PutBox(X1,Y1,X2,Y2,Color);
    _Trident : Trident.PutBox(X1,Y1,X2,Y2,Color);
      _Tseng : Tseng.PutBox(X1,Y1,X2,Y2,Color);
  _Tseng4000 : Tseng4000PutBox(X1,Y1,X2,Y2,Color);
       _VESA : VESA.PutBox(X1,Y1,X2,Y2,Color);
     _Video7 : Video7.PutBox(X1,Y1,X2,Y2,Color);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     PutImageLine                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutImageLine(X1,Y,X2:Word;Var Buffer);
Begin
 Case VG.Adaptor of
      _AHead : AHead.CopyLine(X1,Y,X2,Buffer);
     _Everex : Everex.CopyLine(X1,Y,X2,Buffer);
      _Genoa : Genoa.CopyLine(X1,Y,X2,Buffer);
   _HeadLand : HeadLand.CopyLine(X1,Y,X2,Buffer);
    _Trident : Trident.CopyLine(X1,Y,X2,Buffer);
      _Tseng : Tseng.CopyLine(X1,Y,X2,Buffer);
  _Tseng4000 : Tseng4000CopyLine(X1,Y,X2,Buffer);
       _VESA : VESA.CopyLine(X1,Y,X2,Buffer);
     _Video7 : Video7.CopyLine(X1,Y,X2,Buffer);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       PutLine                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutLine(X1,Y1,X2,Y2:Word;Color:Byte);
Var M,IR : Real;
    I : Word;
Begin
 If(VG.Adaptor = _Tseng4000)Then
 Begin
  Tseng4000Line(X1,Y1,X2,Y2,Color);
 End
  Else
 Begin
  If(X1 = X2)Then PutLineVert(X1,Y1,Y2,Color) else
  If(Y1 = Y2)Then PutLineHori(X1,Y1,X2,Color)
   else
  Begin
   M := (Y2-Y1) / (X2-X1);
   For I := X1 to X2 do
   Begin
    IR := I;
    PutPixel(I,Trunc(M * IR),Color);
   End;
  End;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     PutLineNot                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutLineNot(X1,Y1,X2,Y2:Word);
Var M,IR : Real;
    I : Word;
Begin
 If(VG.Adaptor = _Tseng4000)Then
 Begin
  Tseng4000LineNot(X1,Y1,X2,Y2);
 End
  Else
 Begin
  If((X2-X1) > 0)Then M := (Y2-Y1) / (X2-X1) Else M := 0.0;
  For I := X1 to X2 do
  Begin
   IR := I;
   PutPixel(I,Trunc(M * IR),Not(GetPixel(I,Trunc(M * IR))));
  End;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     PutLineHori                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutLineHori(X1,Y,X2:Word;Color:Byte);
Begin
 Case VG.Adaptor of
      _AHead : AHead.PutLine(X1,Y,X2,Color);
     _Everex : Everex.PutLine(X1,Y,X2,Color);
      _Genoa : Genoa.PutLine(X1,Y,X2,Color);
   _HeadLand : HeadLand.PutLine(X1,Y,X2,Color);
    _Trident : Trident.PutLine(X1,Y,X2,Color);
      _Tseng : Tseng.PutLine(X1,Y,X2,Color);
  _Tseng4000 : Tseng4000PutLine(X1,Y,X2,Color);
       _VESA : VESA.PutLine(X1,Y,X2,Color);
     _Video7 : Video7.PutLine(X1,Y,X2,Color);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     PutLineVert                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutLineVert(X,Y1,Y2:Word;Color:Byte);
Begin
 Case VG.Adaptor of
      _AHead : AHead.PutLineV(X,Y1,Y2,Color);
     _Everex : Everex.PutLineV(X,Y1,Y2,Color);
      _Genoa : Genoa.PutLineV(X,Y1,Y2,Color);
   _HeadLand : HeadLand.PutLineV(X,Y1,Y2,Color);
    _Trident : Trident.PutLineV(X,Y1,Y2,Color);
      _Tseng : Tseng.PutLineV(X,Y1,Y2,Color);
  _Tseng4000 : Tseng4000PutLineV(X,Y1,Y2,Color);
       _VESA : VESA.PutLineV(X,Y1,Y2,Color);
     _Video7 : Video7.PutLineV(X,Y1,Y2,Color);
 End;
End;
{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       PutPixel                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutPixel(X,Y:Word;Color:Byte);
Var Address : LongInt;
Begin
 Address := Get8BitAddress(X,Y);
 SetPhysicalPage(Byte(Address shr 16));
 Mem[VG.AddrSegment:Word(Address)] := Color;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     PutRectangle                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutRectangle(X1,Y1,X2,Y2:Word;Color:Byte);
Begin
 PutLineHori(X1,Y1,X2,Color);
 PutLineVert(X1,Y1+1,Y2-1,Color);
 PutLineVert(X2,Y1+1,Y2-1,Color);
 PutLineHori(X1,Y2,X2,Color);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   PutRectangleNot                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure PutRectangleNot(X1,Y1,X2,Y2:Word);
Var I,J : Word;

 Procedure PutPixelNot(X,Y:Word);
{ Var Address : LongInt;}
 Begin
{  Address := Tseng.GetAddress(X,Y);
  SetPhysicalPage(Byte(Address shr 16));
  ASM
   MOV ES,_SEGVIDEO;
   MOV DI,Word(Address);
   MOV AL,ES:[DI];
   NOT AL;
   STOSB;
  END;}
  PutPixel(X,Y,Not(GetPixel(X,Y)));
 End;

Begin
 For I := X1 to X2 do PutPixelNot(I,Y1);
 For J := (Y1 + 1) to (Y2 - 1) do
 Begin
  PutPixelNot(X1,J);
  PutPixelNot(X2,J);
 End;
 For I := X1 to X2 do PutPixelNot(I,Y2);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   SetPhysicalPage                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure SetPhysicalPage(Page:Byte);
Begin
 Case VG.Adaptor of
      _AHead : AHead.SelectPage(Page);
     _Everex : Everex.SelectPage(Page);
      _Genoa : Genoa.SelectPage(Page);
   _HeadLand : HeadLand.SelectPage(Page);
    _Trident : Trident.SelectPage(Page);
      _Tseng : Tseng.SelectPage(Page);
  _Tseng4000 : Tseng4000SelectPage(Page);
       _VESA : VESA.SelectPage(Page);
     _Video7 : Video7.SelectPage(Page);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 SetPhysicalReadPage                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure SetPhysicalReadPage(Page:Byte);
Begin
 Case VG.Adaptor of
      _AHead : AHead.SelectReadPage(Page);
     _Everex : Everex.SelectPage(Page);
      _Genoa : Genoa.SelectReadPage(Page);
   _HeadLand : HeadLand.SelectPage(Page);
    _Trident : Trident.SelectPage(Page);
      _Tseng : Tseng.SelectReadPage(Page);
  _Tseng4000 : Tseng4000SelectPage(Page);
       _VESA : VESA.SelectPage(Page);
     _Video7 : Video7.SelectPage(Page);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 SetPhysicalWritePage                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure SetPhysicalWritePage(Page:Byte);
Begin
 Case VG.Adaptor of
      _AHead : AHead.SelectWritePage(Page);
     _Everex : Everex.SelectPage(Page);
      _Genoa : Genoa.SelectWritePage(Page);
   _HeadLand : HeadLand.SelectPage(Page);
    _Trident : Trident.SelectPage(Page);
      _Tseng : Tseng.SelectWritePage(Page);
  _Tseng4000 : Tseng4000SelectWritePage(Page);
       _VESA : VESA.SelectPage(Page);
     _Video7 : Video7.SelectPage(Page);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    SetVideoCard                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure SetVideoCard(Card:Byte);
Begin
 VG.Adaptor := Card;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  SetVideoEmulText                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Procedure SetVideoEmulText(Mode:Byte);

 Procedure SetSVGAPalette;
 Var Palette : Array[0..255] of Record
                                 R,G,B : Byte;
                                End;
     I       : Byte;
     S,O     : Word;
 Begin
  Numeric.MemSet(Palette,SizeOf(Palette),0);
  For I := 0 to 14 do
  Begin
   Palette[I+32].R  := 0;
   Palette[I+32].G  := 0;
   Palette[I+32].B  := (I+1) shl 2;
   Palette[I+241].R := (I+1) shl 2;
   Palette[I+241].G := (I+1) shl 2;
   Palette[I+241].B := (I+1) shl 2;
  End;
  S := Seg(Palette[32]); O := Ofs(Palette[32]);
  ASM
   MOV AX,$1012;
   MOV BX,32;
   MOV CX,15;
   MOV ES,S;
   MOV DX,O;
   INT $10;
  END;
  S := Seg(Palette[241]); O := Ofs(Palette[241]);
  ASM
   MOV AX,$1012;
   MOV BX,241;
   MOV CX,15;
   MOV ES,S;
   MOV DX,O;
   INT $10;
  END;
 End;

Begin
 If(VG.Adaptor = $FF)Then { Carte Inconnu ? }
 Begin
  VG.Adaptor := AutoDetectAdaptor;
 End;
 Case VG.Adaptor of
      _AHead : Case Mode of
                2,3,7 : Begin
                         AHead.SetVideoMode(AHead._640x400_256_GraphicsMode);
                         VG.NumColors := 256;
                         SetSVGAPalette;
                        End;
               End;
      _Genoa : Case Mode of
                2,3,7 : Begin
                         Genoa.SetVideoMode(Genoa._640x480_256_GraphicsMode);
                         VG.NumColors := 256;
                         SetSVGAPalette;
                        End;
               End;
   _HeadLand : Case Mode of
                2,3,7 : Begin
                         HeadLand.SetVideoMode(HeadLand._640x400_256_GraphicsMode);
                         VG.NumColors := 256;
                         SetSVGAPalette;
                        End;
               End;
    _Trident : Case Mode of
                2,3,7 : Begin
                         Trident.SetVideoMode(Trident._640x480_256_GraphicsMode);
                         VG.NumColors := 256;
                         SetSVGAPalette;
                        End;
               End;
      _Tseng : Case Mode of
                2,3,7 : Begin
                         Tseng.SetVideoMode($2E);
                         SetSVGAPalette;
                        End;
               End;
  _Tseng4000 : Case Mode of
                2,3,7 : Begin
                         Tseng.SetVideoMode($2F);
                         SetSVGAPalette;
                        End;
               End;
     _Video7 : Case Mode of
                2,3,7 : Begin
                         Video7.SetVideoMode(Video7._640x400_256_GraphicsMode);
                         VG.NumColors := 256;
                         SetSVGAPalette;
                        End;
               End;
 End;
 VG.MaxXPixels       := VG.NumXPixels - 1;
 VG.MaxYPixels       := VG.NumYPixels - 1;
 VG.MaxPage          := NumDirGr.GetMaxPage;
 VG.BytesPerScanLine := NumDirGr.GetBytesPerScanLine;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  AutoDetectAdaptor                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function AutoDetectAdaptor:Byte;
Var _Card : Byte;
    _Tmp  : Word;
Begin
 _Card := $FF;
 If(ATI.InstallCheck)Then _Card := _ATI else
 If(Everex.CheckInstalled)Then _Card := _Everex else
 If(ChkVideo.ChkITVGA2)Then _Card := _Tseng4000 else
 If(ChkVideo.ChkVideo7VGA)Then _Card := _Video7 else
 If(VESA.CheckInstalled)Then _Card := _VESA else
 If(BiosText.BIOS_GetVideoCard < $FF)Then
 Begin
  _Tmp := BiosText.BIOS_GetVideoCard;
  If(_Tmp = 1)Then
  Begin
   If(ChkVideo.ChkHercule)Then _Card := _Hercule;
  End;
  If(_Tmp = 2)Then _Card := _CGA;
  If(_Tmp in [4,5])Then _Card := _EGA;
  If(_Tmp = 6)Then _Card := _PGA;
  If(_Tmp in [7,8])Then _Card := _VGA;
  If(_Tmp in [$A,$B,$C])Then _Card := _MCGA;
 End
  else
 If(BiosText.BIOS_IsEGA)Then _Card := _EGA else
 If(PC3270.CheckInstalled)Then _Card := _PC3270 else
 If(ChkVideo.ChkHercule)Then _Card := _Hercule else
 If(MemW[$0040:$63] = $3D4)Then
 Begin
  If(ChkVideo.Chk6845($3D4))Then _Card := _CGA;
 End;
 AutoDetectAdaptor := _Card;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetMaxColor                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetMaxColor:Word;
Begin
 GetMaxColor := (VG.NumColors - 1);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetMaxX                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetMaxX:Word;
Begin
 GetMaxX := VG.MaxXPixels;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetMaxY                        ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetMaxY:Word;
Begin
 GetMaxY := VG.MaxYPixels;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      GetMemory                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetMemory:LongInt;
Begin
 Case VG.Adaptor of
        _CGA : VG.Memory := 16384;
  _MCGA,_EGA : VG.Memory := BiosText.BIOS_EGA_SizeMemory;
        _VGA : VG.Memory := 262144;
     _Everex : VG.Memory := Everex.GetSizeMemory;
     _Video7 : VG.Memory := Video7.GetSizeMemory;
          Else Begin
                If(GetScreenSize >= 524288)Then VG.Memory := 1048576 else
                If(GetScreenSize >= 262144)Then VG.Memory := 524288
                 else
                VG.Memory := BiosText.BIOS_EGA_SizeMemory;
               End;
 End;
 GetMemory := VG.Memory;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       GetPixel                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetPixel(X,Y:Word):Byte;
Begin
 Case VG.Adaptor of
      _AHead : GetPixel := AHead.ReadPixel(X,Y);
     _Everex : GetPixel := Everex.ReadPixel(X,Y);
      _Genoa : GetPixel := Genoa.ReadPixel(X,Y);
   _HeadLand : GetPixel := HeadLand.ReadPixel(X,Y);
    _Trident : GetPixel := Trident.ReadPixel(X,Y);
      _Tseng : GetPixel := Tseng.ReadPixel(X,Y);
  _Tseng4000 : GetPixel := Tseng4000ReadPixel(X,Y);
       _VESA : GetPixel := VESA.ReadPixel(X,Y);
     _Video7 : GetPixel := Video7.ReadPixel(X,Y);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetVideoCard                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetVideoCard:Byte;
Begin
 GetVideoCard := VG.Adaptor;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     GetVideoMode                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß}

Function GetVideoMode:Byte;
Begin
 GetVideoMode := 3;
End;

BEGIN { Main Unit }
 VG.MaxPage     := 3;
 VG.Adaptor     := $FF;
 If(ChkITVGA2)Then VG.Adaptor := _Tseng4000 else
 If(ChkATI)Then VG.Adaptor := _ATI;
 VG.MaxXPixels       := 0;
 VG.MaxYPixels       := 0;
 VG.NumXPixels       := 0;
 VG.NumYPixels       := 0;
 VG.BytesPerScanLine := 0;
 VG.AddrSegment      := $A000;
 {$IFNDEF __OPTIMIZESIZE__}
  VG.R_Page     := $FF;
  VG.W_Page     := $FF;
  VG.RW_Page    := $FF;
 {$ENDIF}
END.