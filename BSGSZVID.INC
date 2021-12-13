(********************************************************
 * Nom du fichier : BSGSZVID.INC                        *
 *                                                      *
 * Fonction                                             *
 *   BIOS_GetSizeVideo - VGA/SVGA/PS/2                  *
 ********************************************************)

(*
 *
 *   Malte System/Pascal
 *
 *   Copyright (C) par les Chevaliers de Malte
 *   1992-12-19
 *
 *
 *)

(*------------------------------------------------------*

  Nom              GetSizeVideo - VGA/SVGA/PS/2

  Usage            Function BIOS_GetSizeVideo(Num:Byte):LongInt;

  Prototype dans   TEXT.PAS

  Description      Retourne la taille de la cat‚gorie
		   sp‚cifi‚.

  Retourne         Si la fonction a ‚chou‚, il retourne 0
		   autrement ces la taille exacte, a
		   l'octet prŠs.

  Note             Cette fonction utilise l'interruption
		   10h du BIOS VGA ou PS/2.

 *------------------------------------------------------*)

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetSizeVideo(Num:Word):LongInt;
 Var _AL : Byte;
     _BX : Word;
 Begin
  ASM
   MOV AX,$1C00;
   MOV CX,Num;
   INT $10;
   MOV _AL,AL;
   MOV _BX,BX;
  END;
  If(_AL = $1C)Then BIOS_GetSizeVideo := LongInt(_BX) * 64
	       Else BIOS_GetSizeVideo := 0;
 End;

{$ELSE}

 Function BIOS_GetSizeVideo(Num:Word):LongInt;
 Var Reg : Registers;
 Begin
  With Reg do
  Begin
   AX := $1C00;
   CX := Num;
   Intr($10,Reg);
   If(AL = $1C)Then BIOS_GetSizeVideo := LongInt(BX) * 64
	       Else BIOS_GetSizeVideo := 0;
  End;
 End;

{$ENDIF}
