(********************************************************)
(*                                                      *)
(*           Malte System/Video Statement Auto          *)
(*                      1993/01/27                      *)
(*                                                      *)
(*     Copyright (C) par les Chevaliers de Malte        *)
(*                                                      *)
(********************************************************)

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

Unit VStat2;

(********************************************************)
			INTERFACE
(********************************************************)

Procedure Done;

(********************************************************)
		     IMPLEMENTATION
(********************************************************)

Uses

    {$IFNDEF __ASSEMBLERSUPPORT__}
     DOS,
    {$ENDIF}

    BiosText,Text;

Var

    Material, BIOS, Registers, Buffer                 : Pointer;
    SizeMaterial, SizeBIOS, SizeRegisters, SizeBuffer : LongInt;
    Ini                                               : Boolean;

Procedure Init;
Begin
 Ini := False;
 Material := NIL; BIOS := NIL; Registers := NIL; Buffer := NIL;
 SizeMaterial := 0; SizeBIOS := 0; SizeRegisters := 0; SizeBuffer := 0;
End;

{$IFDEF __ASSEMBLERSUPPORT__}

 Procedure HaltMsg(Chn:String);
 Var _Seg,_Ofs : Word;
 Begin
  Chn := Chn + '$';
  _Seg := Seg(Chn[1]);
  _Ofs := Ofs(Chn[1]);
  ASM
   MOV AX,DS;
   MOV ES,AX;
   MOV AH,$09;
   MOV DX,_Ofs;
   MOV DS,_Seg;
   INT $21;
   MOV AX,ES;
   MOV DS,AX;
  END;
  Halt;
 End;

{$ELSE}

 Procedure HaltMsg(Chn:String);
 Var Reg : DOS.Registers;
 Begin
  Chn := Chn + '$';
  With Reg do
  Begin
   AH := $09;
   DS := Seg(Chn[1]);
   DX := Ofs(Chn[1]);
   MsDos(Reg);
  End;
  Halt;
 End;

{$ENDIF}

Function SaveMem(Size:LongInt):Pointer;
Var _Buffer : Pointer;
Begin
 If(MaxAvail < Size)Then HaltMsg('Error : Insuffisant memory!'+#13+#10+
				 'Erreur : Memoire insuffisante!')
  else
 Begin
  GetMem(_Buffer,Size);
  SaveMem := _Buffer;
 End;
End;

Procedure Save;
Var Rtn : Boolean;
Begin
 If(BIOS_Info_)Then
 Begin
  Ini := True;
  SizeMaterial := GetSizeMaterialVideo;
  SizeBIOS := GetSizeBIOSVideo;
  SizeRegisters := GetSizeRegistersVideo;
  SizeBuffer := GetSizeBufferVideo;
  Material := SaveMem(SizeMaterial);
  Rtn := SaveMaterialVideo(Material^);
  BIOS := SaveMem(SizeBIOS);
  Rtn := SaveBIOSVideo(BIOS^);
  Registers := SaveMem(SizeRegisters);
  Rtn := SaveRegistersVideo(Registers^);
  Buffer := SaveMem(SizeBuffer);
  Rtn := SaveBufferVideo(Buffer^);
 End;
End;

Procedure Done;
Var Rtn : Boolean;
    {$IFNDEF __ASSEMBLERSUPPORT__}
     Reg : DOS.Registers;
    {$ENDIF}
Begin
 If Not(Ini)Then
 Begin
  {$IFDEF __ASSEMBLERSUPPORT__}
   If(MemW[$0040:$0063] = $3D4)Then
   ASM
    MOV AX,$0003;
    INT $10;
   END
    else
   ASM
    MOV AX,$0007;
    INT $10;
   END;
  {$ELSE}
   If(MemW[$0040:$0063] = $3D4)Then
   Begin
    Reg.AX := 3;
    Intr($10,Reg);
   End
    else
   Begin
    Reg.AX := 7;
    Intr($10,Reg);
   End;
  {$ENDIF}
 End
  else
 Begin
  Rtn := RestoreBIOSVideo(BIOS^);
  Rtn := RestoreMaterialVideo(Material^);
  Rtn := RestoreRegistersVideo(Registers^);
  Rtn := RestoreBufferVideo(Buffer^);
 End;
End;

BEGIN { Main Unit }
 Init;
 Save;
END.
