(***************************************************************)
(*                                                             *)
(*                 Malte System/Keyboard Info                  *)
(*                         1992/09/30                          *)
(*                                                             *)
(*         Copyright (C) par les Chevaliers de Malte           *)
(*                                                             *)
(***************************************************************)

(***************************************************************)
			  INTERFACE
(***************************************************************)

Function GetKeyboard:Byte;

(***************************************************************)
		  	IMPLEMENTATION
(***************************************************************)

Function GetCompaq386Keyboard:Byte;
Assembler;
ASM MOV AH,$F2;
    INT $16;
End;

Function GetKeyboard:Byte;
Begin
 GetKeyboard := GetCompaq386keyboard;
End;

BEGIN
END.