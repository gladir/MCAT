(********************************************************)
(*                                                      *)
(*         Malte System/Direct Graphic Save             *)
(*                   1993/03/10                         *)
(*                                                      *)
(*     Copyright (C) par les Chevaliers de Malte        *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Directive de compilation conditionnel :

   __BITPERPIXEL__    Indique qu'il faut dire le nombre de Bit par
                      pixel plutot qu'un nombre indiquant le nombre
                      total de couleurs disponible. Donc pour
                      obtenir le nombre de couleur il suffit de
                      faire : (1 shl x).
   __DISKSUPPORT__    Autorise l'utilisation du disque si
                      le besoin de m‚moire se fait sentir.
                      S'il n'est pas d‚finit il n'utilise
                      pas le Module DiskSwap, mais un nouveau
                      fichier a chaque fois.
   __EMSSUPPORT__     Autorise l'utilisation de l'EMS si
                      le besoin de m‚moire se fait sentir.
   __ONLYPC100VGA__   Indique qu'il s'agit seulement des cartes 100%
                      compatible … VGA.
   __SWITCHPAGERW__   Indique qu'il autorise le changement de page
                      strictement en Lecture ou Ecriture.
}

Unit DirectSV;

(********************************************************)
                      INTERFACE
(********************************************************)

Uses DOS;

Const

      _Error = 0;
      _Disk  = 1;
      _VRAM  = 2;
      _EMS   = 3;
      _XMS   = 4;

Type

     TImageRecord = Record
                     Path      : PathStr;
                     L,H,Color : Word;
                     Methode   : Byte;
                     _Handle_  : Word;
                    End;

Function GetSizeImage:Word;
Function LoadImage(X1,Y1,X2,Y2:Word;Var T:TImageRecord):Boolean;
Function SaveImage(X1,Y1,X2,Y2:Word;Var T:TImageRecord):Boolean;

{$IFNDEF __DISKSUPPORT__}
 Function CheckFreeDisk(T:TImageRecord):Boolean;
{$ENDIF}

(********************************************************)
                    IMPLEMENTATION
(********************************************************)

Uses

     {$IFDEF __DISKSUPPORT__}
      DiskSwap,
     {$ELSE}
      Handle,
     {$ENDIF}

     {$IFDEF __GRAPHDIRECT__}
      VRAMDisk,
      DirectGraphic,
     {$ENDIF}

     Memory,
     Numeric,
     NumDirGr,
     DString,
     TPointer,
     Dir;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    CheckFreeDisk                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function CheckFreeDisk(T:TImageRecord):Boolean;

  D‚finition :

   ş Calcul … partir des donn‚es fournient dans le tableau
     'T' si l'espace disque est suffisant. }

{$IFNDEF __DISKSUPPORT__}

 Function CheckFreeDisk(T:TImageRecord):Boolean;
 Begin
  {$IFDEF __BITPERPIXEL__}
   CheckFreeDisk := ((DiskFree(PathToDriveDOS(T.Path))) >
       ((LongInt(T.L) * LongInt(T.H) * LongInt(1 shr T.Color));
  {$ELSE}
   CheckFreeDisk := ((DiskFree(PathToDriveDOS(T.Path))) >
       ((LongInt(T.L) * LongInt(T.H) * LongInt(T.Color)) shr 8));
  {$ENDIF}
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    GetSizeImage                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  Syntaxe :

   Function GetSizeImage:Word;

  D‚finition :

   ş Indique l'espace m‚moire n‚cessaire … la sauvegarde de
     l'image.

  Note :

   ş Attention!!! Cette fonction ne s'occupe en aucun facon
     de l'espace disque n‚cessaire … l'ex‚cution des
     fonctions 'SaveImage' et 'LoadImage'.
}

Function GetSizeImage:Word;
Begin
 GetSizeImage := SizeOf(TImageRecord);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      LoadImage                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LoadImage(X1,Y1,X2,Y2:Word;Var T:TImageRecord):Boolean;
Var _Handle,J,_T,Marge,AddrTmp,L1,L     : Word;
    AddressY,Address1,Address2,AddrTmp2 : LongInt;
    Addr                                : Pointer;
Begin
 LoadImage := False;
 Case T.Methode of
  {$IFDEF __GRAPHDIRECT__}
   _VRAM : Begin
            For J := 0 to (T.H-1) do
            Begin
             VRAMDisk.GetRecord(T._Handle_,J,T.L,GBuffer^);
             DirectGraphic.PutImageLine(X1,Y1+J,X2,GBuffer^);
            End;
            LoadImage := True;
           End;
 {$ENDIF}
 {$IFDEF __DISKSUPPORT__}
  _Disk : Begin
           _Handle := T._Handle_;
           For J := 0 to (T.H-1) do
           Begin
            AddressY := (LongInt(Y1+J) * LongInt(VG.NumXPixels));
            Address1 := LongInt(X1) + AddressY;
            Address2 := LongInt(X2) + AddressY;
            If(Byte(Address1 shr 16) = Byte(Address2 shr 16))Then
            Begin
             {$IFDEF __SWITCHPAGERW__}
              Addr := GetAddrWriteXY(X1,Y1+J);
             {$ELSE}
              Addr := GetAddrXY(X1,Y1+J);
             {$ENDIF}
             DiskSwap.GetRecord(_Handle,J,T.L,Addr^);
            End
             else
            Begin
             L1 := (Numeric.WordMax - Word(Address1))+1;
             {$IFDEF __SWITCHPAGERW__}
              DirectGraphic.SetPhysicalWritePage(Byte(Address1 shr 16));
             {$ELSE}
              DirectGraphic.SetPhysicalPage(Byte(Address1 shr 16));
             {$ENDIF}
             DiskSwap.SetPos(_Handle,J*T.L);
             DiskSwap._GetRecord(_Handle,L1,Mem[VG.AddrSegment:Word(Address1)]);
             {$IFDEF __SWITCHPAGERW__}
              DirectGraphic.SetPhysicalWritePage(Byte(Address2 shr 16));
             {$ELSE}
              DirectGraphic.SetPhysicalPage(Byte(Address2 shr 16));
             {$ENDIF}
             DiskSwap.SetPos(_Handle,(J*T.L)+L1);
             DiskSwap._GetRecord(_Handle,T.L-L1,Mem[VG.AddrSegment:0]);
            End;
           End;
           LoadImage := True;
          End;
 {$ELSE}
  _Disk : Begin
           _Handle := Handle.Open(T.Path,ReadOnly);
           If(Handle.IsHandleError(_Handle))Then
           Begin
            LoadImage := False;
            Exit;
           End;
           For J := 0 to (T.H-1) do
           Begin
            AddressY := (LongInt(Y1+J) * LongInt(DirectGraphic.GetMaxX+1));
            Address1 := LongInt(X1) + AddressY;
            Address2 := LongInt(X2) + AddressY;
            If(Byte(Address1 shr 16) = Byte(Address2 shr 16))Then
            Begin
             {$IFDEF __SWITCHPAGERW__}
              Addr := GetAddrWriteXY(X1,Y1+J);
             {$ELSE}
              Addr := GetAddrXY(X1,Y1+J);
             {$ENDIF}
             Handle.GetRecord(_Handle,J,T.L,Addr^);
            End
             else
            Begin
             {$IFDEF __SWITCHPAGERW__}
              DirectGraphic.SetPhysicalWritePage(Byte(Address1 shr 16));
             {$ELSE}
              DirectGraphic.SetPhysicalPage(Byte(Address1 shr 16));
             {$ENDIF}
             Marge := Numeric.WordMax - Word(AddressY);
             AddrTmp := (Marge-X1)+1;
             Handle.SetFilePos(_Handle,J*T.L);
             Handle._GetRecord(_Handle,AddrTmp,Mem[SegVid:Word(Address1)]);
             _T := (X1 + AddrTmp);
             AddrTmp2 := LongInt(_T) + AddressY;
             {$IFDEF __SWITCHPAGERW__}
              DirectGraphic.SetPhysicalWritePage(Byte(Address2 shr 16));
             {$ELSE}
              DirectGraphic.SetPhysicalPage(Byte(Address2 shr 16));
             {$ENDIF}
             Handle.SetFilePos(_Handle,(J*T.L)+(Address2-AddrTmp2));
             Handle._GetRecord(_Handle,(X2-_T)+1,Mem[SegVid:0]);
            End;
           End;
           Handle.Close(_Handle);
           LoadImage := (FileError = 0);
          End;
 {$ENDIF}
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      SaveImage                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function SaveImage(X1,Y1,X2,Y2:Word;Var T:TImageRecord):Boolean;
Var _Handle,J,L,L1                  : Word;
    Addr                            : Pointer;
    AddressY,Address1,Address2,Size : LongInt;
Begin
 SaveImage  := False;
 If(X2 < X1)or(Y2 < Y1)Then Exit;
 T.Methode  := _Error;
 T._Handle_ := $FFFF;
 L := (X2-X1+1);
 Size := LongInt(L) * LongInt(Y2-Y1+1);

                    (**** Sauve en Video RAM ****)

 If(VRAMDisk.IsActif)Then
 Begin
  _Handle := VRAMDisk.New(T.Path,Size);
  If Not(VRAMDisk.IsHandleError(_Handle))Then
  Begin
   T.L := L; T.H := (Y2-Y1+1);
   {$IFDEF __BITPERPIXEL__}
    T.Color := 8;
   {$ELSE}
    T.Color := 256;
   {$ENDIF}
   T.Methode  := _VRAM;
   T._Handle_ := _Handle;
   For J := 0 to (T.H-1) do
   Begin
    DirectGraphic.GetImageLine(X1,Y1+J,X2,GBuffer^);
    VRAMDisk.SetRecord(_Handle,J,T.L,GBuffer^);
   End;
   SaveImage := True;
   Exit;
  End;
 End;

                       (**** Sauve sur Disque ****)

 {$IFDEF __DISKSUPPORT__}
  If(DiskSwap.IsActif)Then
  Begin
   _Handle := DiskSwap.New(T.Path,Size);
   If Not(DiskSwap.IsHandleError(_Handle))Then
   Begin
    T.L := L; T.H := (Y2-Y1+1);
    {$IFDEF __BITPERPIXEL__}
     T.Color := 8;
    {$ELSE}
     T.Color := 256;
    {$ENDIF}
    T.Methode := _Disk; T._Handle_ := _Handle;
    For J := 0 to (T.H-1) do
    Begin
     AddressY := (LongInt(Y1+J) * LongInt(DirectGraphic.GetMaxX+1));
     Address1 := LongInt(X1) + AddressY;
     Address2 := LongInt(X2) + AddressY;
     If(Byte(Address1 shr 16) = Byte(Address2 shr 16))Then
     Begin
      {$IFDEF __SWITCHPAGERW__}
       Addr := NumDirGr.GetAddrReadXY(X1,Y1+J);
      {$ELSE}
       Addr := NumDirGr.GetAddrXY(X1,Y1+J);
      {$ENDIF}
      DiskSwap.SetRecord(_Handle,J,T.L,Addr^);
     End
      else
     Begin
      {$IFDEF __SWITCHPAGERW__}
       DirectGraphic.SetPhysicalReadPage(Byte(Address1 shr 16));
      {$ELSE}
       DirectGraphic.SetPhysicalPage(Byte(Address1 shr 16));
      {$ENDIF}
      L1 := (Numeric.WordMax - Word(Address1)) + 1;
      DiskSwap.SetPos(_Handle,J*T.L);
      DiskSwap._SetRecord(_Handle,L1,Mem[VG.AddrSegment:Word(Address1)]);
      {$IFDEF __SWITCHPAGERW__}
       DirectGraphic.SetPhysicalReadPage(Byte(Address2 shr 16));
      {$ELSE}
       DirectGraphic.SetPhysicalReadPage(Byte(Address2 shr 16));
      {$ENDIF}
      DiskSwap.SetPos(_Handle,(LongInt(J)*LongInt(T.L))+LongInt(L1));
      DiskSwap._SetRecord(_Handle,L-L1,Mem[VG.AddrSegment:0]);
     End;
    End;
    SaveImage := True;
   End;
  End;
 {$ELSE}
  If Not(CheckFreeDisk(T))Then
  Begin
   SaveImage := False;
   Exit;
  End;
  _Handle := Handle.New(T.Path);
  T.L := L; T.H := (Y2-Y1+1);
  {$IFDEF __BITPERPIXEL__}
   T.Color := 8;
  {$ELSE}
   T.Color := 256;
  {$ENDIF}
  T.Methode := _Disk; T._Handle_ := 0;
  For J := 0 to (T.H-1) do
  Begin
   AddressY := (LongInt(Y1+J) * LongInt(DirectGraphic.GetMaxX+1));
   Address1 := LongInt(X1) + AddressY;
   Address2 := LongInt(X2) + AddressY;
   If(Byte(Address1 shr 16) = Byte(Address2 shr 16))Then
   Begin
    {$IFDEF __SWITCHPAGERW__}
     Addr := NumDirGr.GetAddrReadXY(X1,Y1+J);
    {$ELSE}
     Addr := NumDirGr.GetAddrXY(X1,Y1+J);
    {$ENDIF}
    Handle.SetRecord(_Handle,J,T.L,Addr^);
   End
    else
   Begin
    {$IFDEF __SWITCHPAGERW__}
     DirectGraphic.SetPhysicalReadPage(Byte(Address1 shr 16));
    {$ELSE}
     DirectGraphic.SetPhysicalPage(Byte(Address1 shr 16));
    {$ENDIF}
    Marge := Numeric.WordMax - Word(AddressY);
    AddrTmp := (Marge-X1)+1;
    Handle.SetFilePos(_Handle,J*T.L);
    Handle._SetRecord(_Handle,AddrTmp,Mem[SegVid:Word(Address1)]);
    _T := (X1 + AddrTmp);
    AddrTmp2 := LongInt(_T) + AddressY;
    {$IFDEF __SWITCHPAGERW__}
     DirectGraphic.SetPhysicalReadPage(Byte(Address2 shr 16));
    {$ELSE}
     DirectGraphic.SetPhysicalReadPage(Byte(Address2 shr 16));
    {$ENDIF}
    Handle.SetFilePos(_Handle,(J*T.L)+Word(Address2)-Word(AddrTmp2));
    Handle._SetRecord(_Handle,(X2-_T)+1,Mem[SegVid:0]);
   End;
  End;
  Handle.Close(_Handle);
  SaveImage := Boolean(FileError = 0);
 {$ENDIF}
End;

BEGIN { Main Unit }
END.