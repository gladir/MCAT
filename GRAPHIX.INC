(********************************************************
 * Nom du fichier : GRAPHIX.PAS                         *
 *                                                      *
 * Fonction                                             *
 *   IsGraphix - Video                                  *
 *   BIOS_GetPixel - Video                              *
 *   BIOS_PutPixel - Video                              *
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

  Nom              IsGraphic - Video

  Usage            Function IsGraphic:Boolean;

  Prototype dans   TEXT.PAS

  Description      Indique s'il s'agit d'un mode
                   graphique.

  Retourne         TRUE si c'est un mode graphique ou
                   FALSE si c'est un mode texte.

  Note             Cette fonction utilise l'interruption
                   10h.

 *------------------------------------------------------*)

{$IFDEF __ASSEMBLERSUPPORT__}

 {$IFDEF __EXTERN__}

  {$L GRAPHIX.OBJ }

  Function IsGraphic:Boolean; external;

 {$ELSE}

  Function IsGraphic:Boolean;
  Assembler;
  Var Accum : Byte;
  ASM
   MOV AH,0Dh;
   XOR BH,BH;
   XOR CX,CX;
   XOR DX,DX;
   INT 10h;
   MOV Accum,AL;
   MOV AX,0C01h;
   INT 10h;
   MOV AH,0Dh;
   INT 10h;
   MOV BL,AL;
   MOV AH,0Ch;
   MOV AL,Accum;
   INT 10h;
   MOV AL,BL;
  END;

 {$ENDIF}

{$ELSE}

 {$L GRAPHIX.OBJ }

 Function IsGraphic:Boolean; external;

{$ENDIF}

{$IFDEF __ASSEMBLERSUPPORT__}

 Function BIOS_GetPixel(X,Y:Word):Byte;
 Assembler;
 ASM
  MOV AH,$0D;
  XOR BH,BH;
  MOV CX,X;
  MOV DX,Y;
  INT $10;
 END;

 Procedure BIOS_PutPixel(X,Y:Word;Color:Byte);
 Assembler;
 ASM
  MOV AH,$0C;
  MOV AL,Color;
  XOR BH,BH;
  MOV CX,X;
  MOV DX,Y;
  INT $10;
 END;

{$ENDIF}