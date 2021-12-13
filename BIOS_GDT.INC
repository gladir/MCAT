(****************************************************************)
(*                                                              *)
(*                   Malte System/BIOS Text Gadget              *)
(*                           1992/08/24                         *)
(*                                                              *)
(*           Copyright (C) par les Chevaliers de Malte          *)
(*                                                              *)
(****************************************************************)

{$IFNDEF __BIOSGADGET__}
 {$DEFINE __BIOSGADGET__}

 {$F+}

 {$L BIOS_GDT.OBJ }

 Procedure BIOS_BiWriteDescr_(Lan:Byte;Chn0,Chn1:String;Num:Byte;Chr:Char;Value:Word); external;
 Procedure BIOS_BiWriteDescrB_(Lan:Byte;Chn0,Chn1:String;Num:Byte;Chr:Char;Value:Byte); external;
 Procedure BIOS_BiWriteDescrLn(Lan:Byte;Chn0,Chn1:String;Chr:Char;Value:Word); external;
 Procedure BIOS_BiWriteDescrLn_(Lan:Byte;Chn0,Chn1:String;Num:Byte;Chr:Char;Value:Word); external;
 Procedure BIOS_BiWriteDescrLnB(Lan:Byte;Chn0,Chn1:String;Chr:Char;Value:Byte); external;
 Procedure BIOS_BiWriteDescrLnB_(Lan:Byte;Chn0,Chn1:String;Num:Byte;Chr:Char;Value:Byte); external;
 Procedure BIOS_BiWriteDescrLnH_(Lan:Byte;Chn0,Chn1:String;Num:Byte;Chr:Char;Value:Word); external;
 Procedure BIOS_BiWriteText(Lan:Byte;Chn0,Chn1:String); external;
 Procedure BIOS_BiWriteTextLn(Lan:Byte;Chn0,Chn1:String); external;
 Procedure BIOS_WriteDescr_(Chn:String;Num:Byte;Chr:Char;Value:Word); external;
 Procedure BIOS_WriteDescrB_(Chn:String;Num:Byte;Chr:Char;Value:Byte); external;
 Procedure BIOS_WriteDescrLn(Chn:String;Chr:Char;Value:Word); external;
 Procedure BIOS_WriteDescrLn_(Chn:String;Num:Byte;Chr:Char;Value:Word); external;
 Procedure BIOS_WriteDescrLnB(Chn:String;Chr:Char;Value:Byte); external;
 Procedure BIOS_WriteDescrLnB_(Chn:String;Num:Byte;Chr:Char;Value:Byte); external;
 Procedure BIOS_WriteDescrLnH_(Chn:String;Num:Byte;Chr:Char;Value:Word); external;

{$ENDIF}
