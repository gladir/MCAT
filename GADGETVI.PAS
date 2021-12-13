(********************************************************)
(*                                                      *)
(*              Malte System/Gadget Video               *)
(*                    1993/05/17                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais
}

Unit GadgetVideo;

(********************************************************)
                        INTERFACE
(********************************************************)

Type

     VideoModeRecord = Record
                        Mode:PChar;
                        Actif:Boolean
                       End;

     TVideoMode      = Array[0..$FFF0 div SizeOf(VideoModeRecord)] of
                        VideoModeRecord;

     VideoModePtr    = ^TVideoMode;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

BEGIN { Main Unit }
END.