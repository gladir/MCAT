(********************************************************)
(*                                                      *)
(*              Malte System/String Time                *)
(*                     1993/01/21                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit StrTime;

(********************************************************)
                      INTERFACE
(********************************************************)

Function StringTime(Time:LongInt):String;

(********************************************************)
                    IMPLEMENTATION
(********************************************************)

Uses Numeric,DString,DOS;

Function StringTime(Time:LongInt):String;
Var DT : DateTime;
Begin
 UnpackTime(Time,DT);
 StringTime := StrgTo(DT.Year,4)+'-'+
               ByteToStrDec(DT.Month,2)+'-'+
               ByteToStrDec(DT.Day,2)+
               StrgTo(DT.Hour,3)+':'+
               ByteToStrDec(DT.Min,2)+':'+
               ByteToStrDec(DT.Sec,2);
End;

BEGIN { Main Unit }
END.