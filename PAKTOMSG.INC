(********************************************************)
(*                                                      *)
(*               Malte System/Pack To Msg               *)
(*                     1993/06/04                       *)
(*                                                      *)
(*       Copyright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

{BEGIN_INCLUDE}

Type

     FileRecord = Record
                   FileName     : PathStr;
                   OriginalSize : LongInt;
		   CompressSize : LongInt;
                   Time,Crc32   : LongInt;
                  End;

{END_INCLUDE}