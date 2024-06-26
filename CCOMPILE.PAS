(********************************************************)
(*                                                      *)
(*                Malte System/C Compiler               *)
(*                     1993/05/25                       *)
(*                                                      *)
(*       Copyright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit CCompiler;

(********************************************************)
                      INTERFACE
(********************************************************)

Function IsC(Str:String):Boolean;

(********************************************************)
                    IMPLEMENTATION
(********************************************************)

Uses DString;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                         IsC                          넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function IsC(Str:String):Boolean;
Begin
 Str := DelAllSpcLeft(Str);
 IsC := ((CmpLeft(Str,'#'))or(CmpLeft(Str,'//')or(CmpLeft(Str,'/*'))));
End;

BEGIN { Main Unit }
END.