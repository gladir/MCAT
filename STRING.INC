(****************************************************************)
(*                                                              *)
(*                      Malte System/String                     *)
(*                          1992/08/23                          *)
(*                                                              *)
(*           Copyright (C) par les Chevaliers de Malte          *)
(*                                                              *)
(****************************************************************)

{$IFNDEF __STRING__}
 {$DEFINE __STRING__}

 {$F+}
  
 {$L STRINGP.OBJ }

 Function IsASCII(Chr:Char):Boolean; external;
 Function IsAlpha(Chr:Char):Boolean; external;
 Function IsCntrl(Chr:Char):Boolean; external;
 Function IsDigit(Chr:Char):Boolean; external;
 Function IsLower(Chr:Char):Boolean; external;
 Function IsPrint(Chr:Char):Boolean; external;
 Function IsSpace(Chr:Char):Boolean; external;
 Function IsXDigit(Chr:Char):Boolean; external;

{$ENDIF}