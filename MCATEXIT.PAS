(********************************************************)
(*                                                      *)
(*             Malte Catalog/Exit Program               *)
(*                     1993/02/03                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit MCatExit;

(********************************************************)
                        INTERFACE
(********************************************************)

Procedure SpeedHalt;
Procedure Halt;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses VStat2,LuxeVid,LanWExit;

Procedure SpeedHalt;
Begin
 DoneVideoDeluxe;
 VStat2.Done;
 System.Halt;
End;

Procedure Halt;
Begin
 If(WinExitProgram)Then SpeedHalt;
End;

BEGIN { Main Unit }
END.