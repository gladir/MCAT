(**********************************************************************)
(*                                                                    *)
(*                         Malte System/Mouse                         *)
(*                             1992/07/07                             *)
(*                                                                    *)
(*            Copyright (C) par les Chevaliers de Malte               *)
(*                                                                    *)
(**********************************************************************)

{$IFDEF VER10}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
 {$ELSE}
  {$DEFINE __EXTERNAL__}
  {$DEFINE __OPTIMIZESIZE__}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER40}
 {$DEFINE __EXTERNAL__}
 {$DEFINE __OPTIMIZESIZE__}
{$ENDIF}

{$IFDEF VER50}
 {$DEFINE __EXTERNAL__}
 {$DEFINE __OPTIMIZESIZE__}
{$ENDIF}

{$IFDEF VER55}
 {$DEFINE __EXTERNAL__}
 {$DEFINE __OPTIMIZESIZE__}
{$ENDIF}

{$IFDEF VER60}
 {$DEFINE __ASSEMBLERSUPPORT__}
{$ENDIF}

{$IFDEF VER70}
 {$DEFINE __ASSEMBLERSUPPORT__}
{$ENDIF}

{$IFDEF VER80}
 {$DEFINE __ASSEMBLERSUPPORT__}
{$ENDIF}

{$IFNDEF __TINY__}
 {$IFNDEF __SMALL__}
  {$IFNDEF __MEDIUM__}
   {$IFNDEF __COMPACT__}
    {$IFNDEF __LARGE__}
     {$IFNDEF __HUGE__}
      {$DEFINE __LARGE__}
     {$ENDIF}
    {$ENDIF}
   {$ENDIF}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

Unit Mouse;

(**********************************************************************)
                              INTERFACE
(**********************************************************************)

Procedure ExcludeZone(X1,Y1,X2,Y2:Word);
Procedure GetButPos(Var Button,X,Y:Word);
Procedure GetButPress(But:Word;Var Butt,Num,X,Y:Word);
Procedure GetButRelease(But:Word;Var Butt,Num,X,Y:Word);
Procedure GetButTPos(Var Button:Word;Var X,Y:Byte);
Procedure GetMickeyPixelRatio(Var X,Y:Integer);
Procedure GetMotionCounters(Var X,Y:Word);
Procedure GetSetupMouse(Var HiVer,LoVer,Typed,IRQ:Byte);
Procedure HidePtr;
Procedure LightPenEmulOff;
Procedure LightPenEmulOn;
Procedure MouseResetStat(Var Flags,Button:Word);
Procedure MouseSoftwareReset;
Procedure ReleaseKeyMouse;
Procedure ReleaseKeyOrMoveMouse;
Procedure RestoreMouseBuffer(Var Buffer);
Procedure SaveMouseBuffer(Var Buffer);
Procedure SetDisableMouseDriver(Var S,O:Word);
Procedure SetEnableMouseDriver;
Procedure SetGraphPtrBlock(Hori,Vert:Word;Var Buffer);
Procedure SetMickeyRatio(X,Y:Integer);
Procedure SetMinMaxHoriPtrPos(X1,X2:Word);
Procedure SetMinMaxVertPtrPos(Y1,Y2:Word);
Procedure SetMouse(Mode:Boolean);
Procedure SetMouseLanguage(Langue:Word);
Procedure SetMouseSpeed(Speed:Word);
Procedure SetPageMouse(Page:Word);
Procedure SetPtrPos(X,Y:Word);
Procedure SetSubCenterPress(Var Buffer);
Procedure SetSubCenterRelease(Var Buffer);
Procedure SetSubMouse(Num:Word;Var Buffer);
Procedure SetSubMove(Var Buffer);
Procedure SetSubLeftPress(Var Buffer);
Procedure SetSubLeftRelease(Var Buffer);
Procedure SetSubRightPress(Var Buffer);
Procedure SetSubRightRelease(Var Buffer);
Procedure SetTextMouse(Mode,A,B:Word);
Procedure SetTextMouseHard(A,B:Word);
Procedure SetTextMouseSoft(A,B:Word);
Procedure ShowPtr;

Function GetMouse:Boolean;
Function GetMouseLanguage:Word;
Function GetPageMouse:Word;
Function GetSizeMouseBuffer:Word;
Function GetTextMouse:Word;
Function IsButtonPress(Button:Word):Boolean;

(**********************************************************************)
                            IMPLEMENTATION
(**********************************************************************)

Uses KeyBoard;

{$IFDEF __EXTERNAL__}
 {$L MOUSEM.OBJ }
{$ENDIF}

{PRIVATE:}

Const

      MON  : Byte    = 0;
      MPRX : Integer = 16;
      MPRY : Integer = 8;
      Msk  : Word    = 0;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                     IsButtonPress                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Function IsButtonPress(Button:Word):Boolean;
Begin
 IsButtonPress := (Button > 0);
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                       GetButTPos                     넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __OPTIMIZESIZE__}

 Procedure GetButTPos(Var Button:Word;Var X,Y:Byte);
 Var TX, TY : Word;
 Begin
  GetButPos(Button,TX,TY);
  X := TX shr 3; Y := TY shr 3;
 End;

{$ELSE}

 Procedure GetButTPos(Var Button:Word;Var X,Y:Byte);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0003;
  INT $33;
  LES DI,Button;
  MOV ES:[DI],BX;
  {$IFOPT G+}
   SHR CX,3;
  {$ELSE}
   SHR CX,1;
   SHR CX,1;
   SHR CX,1;
  {$ENDIF}
  LES DI,X;
  MOV ES:[DI],CL;
  {$IFOPT G+}
   SHR DX,3;
  {$ELSE}
   SHR DX,1;
   SHR DX,1;
   SHR DX,1;
  {$ENDIF}
  LES DI,Y;
  MOV ES:[DI],DL;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                  ReleaseKeyOrMoveMouse               넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

Procedure ReleaseKeyOrMoveMouse;
Var BM,XM,YM,OBM,OXM,OYM : Word;
Begin
 GetButPos(OBM,OXM,OYM);
 Repeat
  GetButPos(BM,XM,YM);
 Until (KeyPressed)or(OBM <> BM)or(OXM <> XM)or(OYM <> YM);
End;

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                       ExcludeZone                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure ExcludeZone(X1,Y1,X2,Y2:Word); external;

{$ELSE}

 Procedure ExcludeZone(X1,Y1,X2,Y2:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0010;
  MOV CX,X1;
  MOV DX,Y1;
  MOV SI,X2;
  MOV DI,Y2;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                       GetButPos                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure GetButPos(Var Button,X,Y:Word); external;

{$ELSE}

 Procedure GetButPos(Var Button,X,Y:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0003;
  INT $33;
  LES DI,Button;
  MOV ES:[DI],BX;
  LES DI,X;
  MOV ES:[DI],CX;
  LES DI,Y;
  MOV ES:[DI],DX;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                      GetButPress                     넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure GetButPress(But:Word;Var Butt,Num,X,Y:Word); external;

{$ELSE}

 Procedure GetButPress(But:Word;Var Butt,Num,X,Y:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0005;
  MOV BX,But;
  INT $33;
  LES DI,Butt;
  MOV ES:[DI],AX;
  LES DI,Num;
  MOV ES:[DI],BX;
  LES DI,X;
  MOV ES:[DI],CX;
  LES DI,Y;
  MOV ES:[DI],DX;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                     GetButRelease                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure GetButRelease(But:Word;Var Butt,Num,X,Y:Word); external;

{$ELSE}

 Procedure GetButRelease(But:Word;Var Butt,Num,X,Y:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0006;
  MOV BX,But;
  INT $33;
  LES DI,Butt;
  MOV ES:[DI],AX;
  LES DI,Num;
  MOV ES:[DI],BX;
  LES DI,X;
  MOV ES:[DI],CX;
  LES DI,Y;
  MOV ES:[DI],DX;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   GetMickeyPixelRatio                넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure GetMickeyPixelRatio(Var X,Y:Integer); external;

{$ELSE}

 Procedure GetMickeyPixelRatio(Var X,Y:Integer);
 Assembler;
 ASM
  LES DI,X;
  MOV AX,MPRX;
  MOV ES:[DI],AX;
  LES DI,Y;
  MOV AX,MPRY;
  MOV ES:[DI],AX;
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   GetMotionCounters                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure GetMotionCounters(Var X,Y:Word); external;

{$ELSE}

 Procedure GetMotionCounters(Var X,Y:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$000B;
  INT $33;
  LES DI,X;
  MOV ES:[DI],CX;
  LES DI,Y;
  MOV ES:[DI],DX;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                       GetMouse                       넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Function GetMouse:Boolean; external;

{$ELSE}

 Function GetMouse:Boolean;
 Assembler;
 ASM
  MOV AL,MON;
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                     GetMouseLanguage                 넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Function GetMouseLanguage:Word; external;

{$ELSE}

 Function GetMouseLanguage:Word;
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@1;
  MOV AX,$0023;
  INT $33;
  MOV BX,AX;
  JMP @@2;
@@1:
  XOR AX,AX;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                      GetPageMouse                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Function GetPageMouse:Word; external;

{$ELSE}

 Function GetPageMouse:Word;
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@1;
  MOV AX,$001E;
  INT $33;
  MOV AX,BX;
  JMP @@2;
@@1:
  XOR AX,AX;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                     GetSetupMouse                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure GetSetupMouse(Var HiVer,LoVer,Typed,IRQ:Byte); external;

{$ELSE}

 Procedure GetSetupMouse(Var HiVer,LoVer,Typed,IRQ:Byte);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0024;
  INT $33;
  LES DI,HiVer;
  MOV ES:[DI],BH;
  LES DI,LoVer;
  MOV ES:[DI],BL;
  LES DI,Typed;
  MOV ES:[DI],CL;
  LES DI,IRQ;
  MOV ES:[DI],CH;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    GetSizeMouseBuffer                넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Function GetSizeMouseBuffer:Word; external;

{$ELSE}

 Function GetSizeMouseBuffer:Word;
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0015;
  INT $33;
  MOV AX,BX;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                      GetTextMouse                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Function GetTextMouse:Word; external;

{$ELSE}

 Function GetTextMouse:Word;
 Assembler;
 ASM
  MOV AX,Msk;
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                        HidePtr                       넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure HidePtr; external;

{$ELSE}

 Procedure HidePtr;
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0002;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    LightPenEmulOff                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure LightPenEmulOff; external;

{$ELSE}

 Procedure LightPenEmulOff;
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$000E;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    LightPenEmulOn                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure LightPenEmulOn; external;

{$ELSE}

 Procedure LightPenEmulOn;
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$000D;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    MouseResetStat                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure MouseResetStat(Var Flags,Button:Word); external;

{$ELSE}

 Procedure MouseResetStat(Var Flags,Button:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  XOR AX,AX;
  INT $33;
  LES DI,Flags;
  MOV ES:[DI],AX;
  LES DI,Button;
  MOV ES:[DI],BX;
  MOV MPRX,8;
  MOV MPRY,16;
  MOV Msk,0;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   MouseSoftwareReset                 넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure MouseSoftwareReset; external;

{$ELSE}

 Procedure MouseSoftwareReset;
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0021;
  INT $33;
  MOV MPRX,8;
  MOV MPRY,16;
  MOV Msk,0;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                     ReleaseKeyMouse                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure ReleaseKeyMouse; external;

{$ELSE}

 Procedure ReleaseKeyMouse;
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
@@1:
  MOV AX,$0003;
  INT $33;
  CMP BX,0;
  JE  @@1;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    RestoreMouseBuffer                넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure RestoreMouseBuffer(Var Buffer); external;

{$ELSE}

 Procedure RestoreMouseBuffer(Var Buffer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  LES DX,Buffer;
  MOV AX,$0017;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                     SaveMouseBuffer                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SaveMouseBuffer(Var Buffer); external;

{$ELSE}

 Procedure SaveMouseBuffer(Var Buffer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  LES DX,Buffer;
  MOV AX,$0016;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                  SetDisableMouseDriver               넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetDisableMouseDriver(Var S,O:Word); external;

{$ELSE}

 Procedure SetDisableMouseDriver(Var S,O:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@1;
  MOV AX,$001F;
  INT $33;
  CMP AX,$001F;
  JNE @@1;
  MOV AX,ES;
  LES DI,S;
  MOV ES:[DI],AX;
  LES DI,O;
  MOV ES:[DI],BX;
  JMP @@2;
@@1:
  XOR AX,AX;
  LES DI,S;
  MOV ES:[DI],AX;
  LES DI,O;
  MOV ES:[DI],AX;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   SetEnableMouseDriver               넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetEnableMouseDriver; external;

{$ELSE}

 Procedure SetEnableMouseDriver;
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0020;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    SetGraphPtrBlock                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetGraphPtrBlock(Hori,Vert:Word;Var Buffer); external;

{$ELSE}

 Procedure SetGraphPtrBlock(Hori,Vert:Word;Var Buffer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  LES DX,Buffer;
  MOV AX,$0009;
  MOV BX,Hori;
  MOV CX,Vert;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    SetMickeyRatio                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetMickeyRatio(X,Y:Integer); external;

{$ELSE}

 Procedure SetMickeyRatio(X,Y:Integer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$000F;
  MOV CX,X;
  MOV MPRX,CX;
  MOV DX,Y;
  MOV MPRY,DX;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                 SetMinMaxHoriPtrPos                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetMinMaxHoriPtrPos(X1,X2:Word); external;

{$ELSE}

 Procedure SetMinMaxHoriPtrPos(X1,X2:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0007;
  MOV CX,X1;
  MOV DX,X2;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                 SetMinMaxVertPtrPos                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetMinMaxVertPtrPos(Y1,Y2:Word); external;

{$ELSE}

 Procedure SetMinMaxVertPtrPos(Y1,Y2:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0008;
  MOV CX,Y1;
  MOV DX,Y2;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                        SetMouse                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetMouse(Mode:Boolean); external;

{$ELSE}

 Procedure SetMouse(Mode:Boolean);
 Assembler;
 ASM
  MOV AL,Mode;
  MOV MON,AL;
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   SetMouseLanguage                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetMouseLanguage(Langue:Word); external;

{$ELSE}

 Procedure SetMouseLanguage(Langue:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0022;
  MOV BX,Langue;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                      SetMouseSpeed                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetMouseSpeed(Speed:Word); external;

{$ELSE}

 Procedure SetMouseSpeed(Speed:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$0013;
  MOV DX,Speed;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                      SetPageMouse                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetPageMouse(Page:Word); external;

{$ELSE}

 Procedure SetPageMouse(Page:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$001D;
  MOV BX,Page;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                       SetPtrPos                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetPtrPos(X,Y:Word); external;

{$ELSE}

 Procedure SetPtrPos(X,Y:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,4;
  MOV CX,X;
  MOV DX,Y;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   SetSubCenterPress                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetSubCenterPress(Var Buffer); external;

{$ELSE}

 Procedure SetSubCenterPress(Var Buffer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  LES DX,Buffer;
  MOV AX,$0018;
  MOV CX,5;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   SetSubCenterRelease                넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetSubCenterRelease(Var Buffer); external;

{$ELSE}

 Procedure SetSubCenterRelease(Var Buffer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  LES DX,Buffer;
  MOV AX,$0018;
  MOV CX,6;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                      SetSubMouse                     넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetSubMouse(Num:Word;Var Buffer); external;

{$ELSE}

 Procedure SetSubMouse(Num:Word;Var Buffer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  LES DX,Buffer;
  MOV AX,$0018;
  MOV CX,Num;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                      SetSubMove                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetSubMove(Var Buffer); external;

{$ELSE}

 Procedure SetSubMove(Var Buffer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  LES DX,Buffer;
  MOV AX,$18;
  XOR CX,CX;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   SetSubLeftPress                    넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetSubLeftPress(Var Buffer); external;

{$ELSE}

 Procedure SetSubLeftPress(Var Buffer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  LES DX,Buffer;
  MOV AX,$18;
  MOV CX,1;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   SetSubLeftRelease                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetSubLeftRelease(Var Buffer); external;

{$ELSE}

 Procedure SetSubLeftRelease(Var Buffer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  LES DX,Buffer;
  MOV AX,$0018;
  MOV CX,2;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    SetSubRightPress                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetSubRightPress(Var Buffer); external;

{$ELSE}

 Procedure SetSubRightPress(Var Buffer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  LES DX,Buffer;
  MOV AX,$0018;
  MOV CX,3;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                   SetSubRightRelease                 넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetSubRightRelease(Var Buffer); external;

{$ELSE}

 Procedure SetSubRightRelease(Var Buffer);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  LES DX,Buffer;
  MOV AX,$0018;
  MOV CX,4;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                       SetTextMouse                   넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetTextMouse(Mode,A,B:Word); external;

{$ELSE}

 Procedure SetTextMouse(Mode,A,B:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$000A;
  MOV BX,Mode;
  MOV CX,A;
  MOV DX,B;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    SetTextMouseHard                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetTextMouseHard(A,B:Word); external;

{$ELSE}

 Procedure SetTextMouseHard(A,B:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$000A;
  MOV BX,1;
  MOV CX,A;
  MOV DX,B;
  INT $33;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                    SetTextMouseSoft                  넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure SetTextMouseSoft(A,B:Word); external;

{$ELSE}

 Procedure SetTextMouseSoft(A,B:Word);
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,$000A;
  XOR BX,BX;
  MOV CX,A;
  MOV DX,B;
  INT $33;
  MOV Msk,0;
@@2:
 END;

{$ENDIF}

{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �                         ShowPtr                      넴
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$IFDEF __EXTERNAL__}

 Procedure ShowPtr; external;

{$ELSE}

 Procedure ShowPtr;
 Assembler;
 ASM
  CMP MON,Byte(True);
  JNE @@2;
  MOV AX,1;
  INT $33;
@@2:
 END;

{$ENDIF}

BEGIN { Main Unit }
END.