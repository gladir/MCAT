(********************************************************)
(*                                                      *)
(*             Malte System/Table Pointer               *)
(*                    1993/03/01                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit TPointer;

{$IFDEF OS2}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF WINDOWS}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF DPMI}
 {$DEFINE PROTECTEDMODE}
{$ENDIF}

{$IFDEF VER10}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER15}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER60}
 {$DEFINE __ASSEMBLERSUPPORT__}
{$ENDIF}

{$IFDEF VER70}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
{$ENDIF}

{$IFDEF VER80}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
{$ENDIF}

(********************************************************)
                       INTERFACE
(********************************************************)

Type

     BooleanPtr    = ^TBoolean;
     BytePtr       = ^TByte;
     CharPtr       = ^TChar;
     ShortIntPtr   = ^TShortInt;
     WordPtr       = ^TWord;
     IntegerPtr    = ^TInteger;
     LongIntPtr    = ^TLongInt;
     PointerPtr    = ^TPointer_;
     {$IFDEF __STRPTRSUPPORT__}
      PCharPtr     = ^TPChar;
     {$ENDIF}
     StringPtr     = ^TString;

     TBoolean  = Array[0..$FFFE] of Boolean;
     TChar     = Array[0..$FFFE] of Char;
     TByte     = Array[0..$FFFE] of Byte;
     TShortInt = Array[0..$FFFE] of ShortInt;
     TWord     = Array[0..$7FFE] of Word;
     TInteger  = Array[0..$7FFE] of Integer;
     TLongInt  = Array[0..$3FFE] of LongInt;
     TPointer_ = Array[0..$3FFE] of Pointer;
     {$IFDEF __STRPTRSUPPORT__}
      TPChar   = Array[0..$FF00 div SizeOf(PChar)] of PChar;
     {$ENDIF}
     TString   = Array[0..($FEFF div SizeOf(String))] of String;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

BEGIN { Main Unit }
END.