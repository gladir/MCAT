(********************************************************)
(*                                                      *)
(*          Malte System/Language Data String           *)
(*                    1993/04/20                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais
}

Unit LanDStr;

(********************************************************)
                       INTERFACE
(********************************************************)

Function LStr(EStr,FStr:String):String;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses Level;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        LStr                          ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function LStr(EStr,FStr:String):String;
Begin
 Case Language of
  lgEnglish : LStr := EStr;
         Else LStr := FStr;
 End;
End;

BEGIN { Main Unit }
END.