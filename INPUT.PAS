(***************************************************************)
(*                                                             *)
(*                       Malte System/Input                    *)
(*                           1991/10/10                        *)
(*                                                             *)
(*          Copyright (C) par les Chevaliers de Malte          *)
(*                                                             *)
(***************************************************************)

{ Programmeur :

  Sylvain Maltais

}

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
  {$DEFINE __PCHARSUPPORT__}
  {$DEFINE PCHARSUPPORT}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER15}
 {$IFNDEF QUICKPASCAL}
  {$DEFINE __ASSEMBLERSUPPORT__}
  {$DEFINE __STRPTRSUPPORT__}
  {$DEFINE __PCHARSUPPORT__}
  {$DEFINE PCHARSUPPORT}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER60}
 {$DEFINE __ASSEMBLERSUPPORT__}
{$ENDIF}

{$IFDEF VER70}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
 {$DEFINE __PCHARSUPPORT__}
 {$DEFINE PCHARSUPPORT}
{$ENDIF}

{$IFDEF VER80}
 {$DEFINE __ASSEMBLERSUPPORT__}
 {$DEFINE __STRPTRSUPPORT__}
 {$DEFINE __PCHARSUPPORT__}
 {$DEFINE PCHARSUPPORT}
{$ENDIF}

Unit Input;

(***************************************************************)
                            INTERFACE
(***************************************************************)

{$IFDEF PCHARSUPPORT}
 Uses Strings;
{$ENDIF}

Const

      inpBeep      = 0;
      inpDelChar   = 2;
      inpDelEOL    = 3;
      inpDelLine   = 4;
      inpDelWord   = 5;
      inpBackSpace = 6;
      inpBS        = 6;
      inpCtrlLeft  = 7;
      inpLeftWord  = 7;
      inpCtrlRight = 8;
      inpRightWord = 8;
      inpLeft      = 9;
      inpRight     = 10;
      inpHome      = 11;
      inpEnd       = 12;
      inpUp        = 13;
      inpInit      = 14;
      inpDown      = 15;

      kbMouse      = $FFFE;

Type

     KeyInputType = Array[1..26] of
                     Record
                      Alt    : String[31];
                      Ctrl   : String[31];
                      Action : Byte;
                     End;

     {$IFDEF PCHARSUPPORT}

      CKeyInputType = Array[1..26] of
                       Record
                        Alt    : PChar;
                        Ctrl   : PChar;
                        Action : Byte;
                       End;

     {$ENDIF}

Procedure _InputExtra(Var Chaine:String;Len:Byte;
                      Key:KeyInputType;UpDown:Boolean;Var Escape:Word);
Procedure _InputExtraXY(X,Y:Byte;Var Chaine:String;Len:Byte;
                        Key:KeyInputType;UpDown:Boolean;Var Escape:Word);
Procedure GetInputMsPos(Var X,Y:Byte);

{$IFDEF PCHARSUPPORT}
 Procedure CInput(Var Chaine:String;Len:Byte;Key:CKeyInputType;
                  UpDown:Boolean;Var Escape:Word);
{$ENDIF}

(***************************************************************)
                          IMPLEMENTATION
(***************************************************************)

Uses

    {$IFDEF __Mouse__}
     Mouse,
    {$ENDIF}

    {$IFDEF __BGI__}
     BGI_Text,
    {$ENDIF}

    EmuInt15,Keyboard,Text,Sound,Level;

Var

    RX,RY : Byte;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    GetInputMsPos                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure GetInputMsPos(Var X,Y:Byte);
Begin
 X := RX; Y := RY;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   _InputExtraXY                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure _InputExtraXY(X,Y:Byte;Var Chaine:String;Len:Byte;
                        Key:KeyInputType;UpDown:Boolean;Var Escape:Word);
Begin
 SetPos(X,Y);
 _InputExtra(Chaine,Len,Key,UpDown,Escape);
 {$IFDEF __BGI__}
  If(VC.Methode = ScrnBGI)Then
   __BarSelectHori(X,Y,X+Len-1,GetLastColor)
  Else
 {$ENDIF}
 BarSelectHori(X,Y,X+Len-1,GetLastColor);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                         CInput                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF PCHARSUPPORT}

 Procedure CInput(Var Chaine:String;Len:Byte;Key:CKeyInputType;
                  UpDown:Boolean;Var Escape:Word);
 Const UpDn : Byte = 0;
 Var P,Temp     : String;
     LenPhr,X,Y : Byte;
     XPos,I     : Integer;
     K          : Word;
     BM,XM,YM   : Word;
     Ok         : Boolean;

  Procedure ClearBoard;
  Begin
   _BarSpaceHori(X,Y,X+Len-1);
  End;

  Procedure ErrorBoard;
  Begin
   BarSelectHori(X,Y,X+Len-1,Color.Input.Error);
  End;

  Procedure NormalBoard;
  Begin
   _BarSelectHori(X,Y,X+Len-1);
  End;

  Procedure AutoInsert;
  Begin
   If(VC.VGA)Then
   Begin
    If(GetModeInsert)Then SetCursor(6,12)
                     Else SetCursor(11,12);
   End
    else
   Begin
    If(GetModeInsert)Then SetCursor(4,7)
                     Else SetCursor(6,7);
   End;
  End;

  Procedure Init;
  Var I,Len : Byte;
      C     : Char;
  Begin
   ClearBoard;
   FillChar(P,SizeOf(P),0);
   Len := Length(Chaine);
   For I := 1 to Len do
   Begin
    C := Chaine[I];
    If(C > #31)Then P := P + C;
   End;
   If(P <> '')Then
   Begin
    _WriteText(X,Y,P);
    LenPhr := Len; XPos := Len;
   End
    else
   Begin
    LenPhr := 0; XPos := 0;
   End;
  End;

  Procedure Delete1;
  Begin
   Delete(P,XPos+1,1);
   Dec(LenPhr);
  End;

  Procedure CtrlLeftKey;
  Begin
   Ok := False; I := XPos;
   Repeat
    Dec(I);
    If(I < 1)Then
    Begin
     XPos := 0; Ok := True;
    End
     else
    If(P[I] in [#0..#41,'[',']'])Then
    Begin
     XPos := I; Ok := True;
    End
     else
    If(I > LenPhr)Then
    Begin
     XPos := LenPhr; Ok := True;
    End;
   Until Ok;
  End;

  Procedure CtrlRightKey;
  Begin
   If(XPos > Integer(LenPhr))Then XPos := Integer(LenPhr);
   Ok := False; I := XPos;
   If(I < 0)Then XPos := 0
    else
   Repeat
    Inc(I);
    If(P[I] in [#0..#41,'[',']'])Then
    Begin
     XPos := I; Ok := True;
    End
     else
    If(I > LenPhr)Then
    Begin
     XPos := LenPhr; Ok := True;
    End;
   Until Ok;
   If(XPos > Integer(LenPhr))Then XPos := Integer(LenPhr);
  End;

  Procedure DeleteLineKey;
  Begin
   ClearBoard;
   FillChar(P,SizeOf(P),0);
   LenPhr := 0; XPos := 0;
  End;

  Procedure BackSpaceKey;
  Begin
   If(Length(P) > 1)Then
   Begin
    Delete(P,XPos,1);
    Dec(XPos);
    _WriteText(X+XPos,Y,Copy(P,XPos+1,255)+ ' ');
    LenPhr := Length(P);
   End
    else
   If(Length(P) = 1)Then DeleteLineKey
    Else
   Begin
    ErrorBoard;
    Sound.Beep;
    NormalBoard;
   End;
  End;

  Procedure DeleteKey;
  Begin
   If(LenPhr > 1)Then
   Begin
    Delete(P,XPos+1,1);
    _WriteText(X+XPos,Y,Copy(P,XPos+1,255) + ' ');
    LenPhr := Length(P);
   End
    else
   If(LenPhr = 1)Then DeleteLineKey
    Else
   Begin
    ErrorBoard;
    Beep;
    NormalBoard;
   End;
  End;

  Procedure DeleteEOLKey;
  Begin
   Delete(P,XPos,255);
   _BarSpaceHori(XPos,Y,LenPhr);
   Len := Length(P);
  End;

  Procedure DeleteWordKey;
  Var OldLen : Byte;
  Begin
   If(XPos+1 > LenPhr)Then
   Begin
    Ok := False;
    OldLen := LenPhr;
    Repeat
     If(P[XPos+1] in [' ','A'..'Z','a'..'z'])and(XPos+1<LenPhr)Then Delete1
                                                               Else Ok := True;
     If(XPos >= LenPhr)Then Ok := True;
    Until Ok;
    If(OldLen = LenPhr)Then Delete1;
   End;
   ClearBoard;
   _WriteText(X,Y,P);
  End;

  Procedure LeftKey;
  Begin
   If(XPos > 0)Then Dec(XPos)
    else
   Begin
    ErrorBoard;
    Beep;
    NormalBoard;
   End;
  End;

  Procedure RightKey;
  Begin
   If(XPos < LenPhr)Then Inc(XPos) else
   Begin
    ErrorBoard;
    Beep;
    NormalBoard;
   End;
  End;

  Procedure InsertChar;
  Begin
   If(Len > LenPhr)Then
   Begin
    If(GetModeInsert)Then
    Begin
     If(XPos < LenPhr)Then
     Begin
      Move(P[XPos],P[XPos+1],LenPhr-XPos+1);
      P[XPos+1] := Char(Lo(K));
      P[0] := Char(LenPhr + 1);
      _WriteText(X,Y,P);
     End
      else
     Begin
      P[XPos+1] := Char(Lo(K));
      P[0] := Char(LenPhr + 1);
     End;
     _SetCube(X+XPos,Y,Char(Lo(K)));
     Inc(XPos);
     LenPhr := Length(P);
    End
     else
    Begin
     If(Length(P) = 0)Then
     Begin
      P[0] := #1; P[1] := Char(Lo(K)); XPos := 1;
      _SetCube(X,Y,P[1]);
     End
      else
     Begin
      P[XPos+1] := Char(Lo(K));
      If(XPos >= LenPhr)Then P[0] := Char(XPos + 1);
      _WriteText(X,Y,P);
      Inc(XPos);
      LenPhr := Length(P);
     End;
    End;
   End;
  End;

  Function InsertStr(K:Word):Boolean; Forward;

  Procedure __UpDown(K:Word);
  Begin
   Begin
    If(UpDown)Then
    Begin
     If(K = kbUp)Then Escape := kbUp Else Escape := kbDown;
     Chaine := P;
     CloseCursor;
     Exit;
    End
     else
    Begin
     If(InsertStr(UpDn))Then
     Begin
      If(K = kbDown)Then
      Begin
       If(UpDn < 25)Then Inc(UpDn) else UpDn := 0;
      End
       else
      Begin
       If(UpDn > 0)Then Dec(UpDn) else UpDn := 25;
      End;
     End;
    End;
   End;
  End;

  Var FE : Boolean;
      KE : Word;

  Function InsertStr(K:Word):Boolean;
  Var Chaine : String;
      LenChr : Byte;
      Return : Boolean;
      ASCII  : Char;
  Begin
   FE := False;
   If(Char(Lo(K)) < ' ')and(Hi(K) < $33)Then
   Begin
    Case (Key[Lo(K)].Action and 15) of
     0 : Beep;
     2 : DeleteKey;
     3 : DeleteEOLKey;
     4 : DeleteLineKey;
     5 : DeleteWordKey;
     6 : BackSpaceKey;
     7 : CtrlLeftKey;
     8 : CtrlRightKey;
     9 : LeftKey;
    10 : RightKey;
    11 : XPos := 0;
    12 : XPos := LenPhr;
    13 : Begin
          __UpDown(kbUp);
          FE := True;
          KE := kbUp;
         End;
    14 : Init;
    15 : Begin
          __UpDown(kbDown);
          FE := True;
          KE := kbDown;
         End
      else
     Chaine := StrPas(Key[Lo(K)].Ctrl);
    End;
    Return := True;
   End
    Else
   Begin
    ASCII := AltCodeToASCII(K);
    If(ASCII = #0)Then Return := False
     else
    Begin
     Chaine := StrPas(Key[Byte(ASCII)-64].Alt);
     Return := True;
    End;
   End;
   InsertStr := Return;
  End;

 Begin
  GetPos(X,Y);
  Init;
  AutoInsert;
  Repeat
   SetPosCursor(X+XPos,Y);
   {$IFDEF __Mouse__}
    ShowPtr;
    Repeat
     GetButPos(BM,XM,YM);
     If(BM > 0)Then
     Begin
      XM := XM shr 3; YM := YM shr 3;
      HidePtr;
      If(YM = Y)Then
      Begin
       If Not((XM < X)or(XM > X+Length(P)))Then
       Begin
        XPos := XM - X;
        SetPosCursor(X+XPos,Y);
       End
        else
       Begin
        CloseCursor;
        RX := XM; RY := YM;
        Chaine := P;
        BarSelectHori(X,Y,X+Len-1,GetLastColor);
        Escape := kbMouse;
        Exit;
       End;
      End
       else
      Begin
       CloseCursor;
       RX := XM; RY := YM;
       Chaine := P;
       BarSelectHori(X,Y,X+Len-1,GetLastColor);
       Escape := kbMouse;
       Exit;
      End;
      ShowPtr;
      ReleaseKeyOrMoveMouse;
     End;
    Until KeyPressed;
    HidePtr;
   {$ENDIF}
   K := ReadKey;
   Case K of
    kbHome : XPos := 0;
 kbUp,kbDown:Begin
              __UpDown(K);
              BarSelectHori(X,Y,X+Len-1,GetLastColor);
              Exit;
             End;
    kbLeft : LeftKey;
   kbRight : RightKey;
     kbEnd : XPos := LenPhr;
     kbIns : AutoInsert;
     kbDel : DeleteKey;
 kbCtrlLeft: CtrlLeftKey;
 kbCtrlRight:CtrlRightKey;
    kbBack : BackSpaceKey;
   kbEnter : Move(P,Chaine,Len);
     else
    Begin
     If(Lo(K) in [32..126,128..255])Then InsertChar else
     If((K = kbTab)and(UpDown))Then
     Begin
      Move(P,Chaine,Len);
      BarSelectHori(X,Y,X+Len-1,GetLastColor);
      Escape := K;
      CloseCursor;
      Exit;
     End
      else
     If(Not(InsertStr(K)))Then
     Begin
      If(FE)Then
      Begin
       BarSelectHori(X,Y,X+Len-1,GetLastColor);
       Escape := KE;
       Exit;
      End;
      Beep;
     End;
    End;
   End;
  Until ((K = kbEsc)or(K = kbEnter));
  BarSelectHori(X,Y,X+Len-1,GetLastColor);
  Escape := K;
  CloseCursor;
 End;

{$ENDIF}

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     _InputExtra                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure _InputExtra(Var Chaine:String;Len:Byte;
                      Key:KeyInputType;UpDown:Boolean;Var Escape:Word);
Const UpDn : Byte = 0;
Var P,Temp     : String;
    LenPhr,X,Y : Byte;
    XPos,I     : Integer;
    K          : Word;
    BM,XM,YM   : Word;
    Ok         : Boolean;

 Procedure ClearBoard;
 Begin
  _BarSpaceHori(X,Y,X+Len-1);
 End;

 Procedure ErrorBoard;
 Begin
  BarSelectHori(X,Y,X+Len-1,Color.Input.Error);
 End;

 Procedure NormalBoard;
 Begin
  _BarSelectHori(X,Y,X+Len-1);
 End;

 Procedure AutoInsert;
 Begin
  If(VC.VGA)Then
  Begin
   If(GetModeInsert)Then SetCursor(6,12)
                    Else SetCursor(11,12);
  End
   else
  Begin
   If(GetModeInsert)Then SetCursor(4,7)
                    Else SetCursor(6,7);
  End;
 End;

 Procedure Init;
 Var I,Len : Byte;
     C     : Char;
 Begin
  ClearBoard;
  FillChar(P,SizeOf(P),0);
  Len := Length(Chaine);
  For I := 1 to Len do
  Begin
   C := Chaine[I];
   If(C > #31)Then P := P + C;
  End;
  If(P <> '')Then
  Begin
   _WriteText(X,Y,P);
   LenPhr := Len; XPos := Len;
  End
   else
  Begin
   LenPhr := 0; XPos := 0;
  End;
 End;

 Procedure Delete1;
 Begin
  Delete(P,XPos+1,1);
  Dec(LenPhr);
 End;

 Procedure CtrlLeftKey;
 Begin
  Ok := False; I := XPos;
  Repeat
   Dec(I);
   If(I < 1)Then
   Begin
    XPos := 0; Ok := True;
   End
    else
   If(P[I] in [#0..#41,'[',']'])Then
   Begin
    XPos := I; Ok := True;
   End
    else
   If(I > LenPhr)Then
   Begin
    XPos := LenPhr; Ok := True;
   End;
  Until Ok;
 End;

 Procedure CtrlRightKey;
 Begin
  If(XPos > Integer(LenPhr))Then XPos := Integer(LenPhr);
  Ok := False; I := XPos;
  If(I < 0)Then XPos := 0
   else
  Repeat
   Inc(I);
   If(P[I] in [#0..#41,'[',']'])Then
   Begin
    XPos := I; Ok := True;
   End
    else
   If(I > LenPhr)Then
   Begin
    XPos := LenPhr; Ok := True;
   End;
  Until Ok;
  If(XPos > Integer(LenPhr))Then XPos := Integer(LenPhr);
 End;

 Procedure DeleteLineKey;
 Begin
  ClearBoard;
  FillChar(P,SizeOf(P),0);
  LenPhr := 0; XPos := 0;
 End;

 Procedure BackSpaceKey;
 Begin
  If(Length(P) > 1)Then
  Begin
   Delete(P,XPos,1);
   Dec(XPos);
   _WriteText(X+XPos,Y,Copy(P,XPos+1,255)+ ' ');
   LenPhr := Length(P);
  End
   else
  If(Length(P) = 1)Then DeleteLineKey
   Else
  Begin
   ErrorBoard;
   Beep;
   NormalBoard;
  End;
 End;

 Procedure DeleteKey;
 Begin
  If(LenPhr > 1)Then
  Begin
   Delete(P,XPos+1,1);
   _WriteText(X+XPos,Y,Copy(P,XPos+1,255) + ' ');
   LenPhr := Length(P);
  End
   else
  If(LenPhr = 1)Then DeleteLineKey
   Else
  Begin
   ErrorBoard;
   Beep;
   NormalBoard;
  End;
 End;

 Procedure DeleteEOLKey;
 Begin
  Delete(P,XPos,255);
  _BarSpaceHori(XPos,Y,LenPhr);
  Len := Length(P);
 End;

 Procedure DeleteWordKey;
 Var OldLen : Byte;
 Begin
  If(XPos+1 > LenPhr)Then
  Begin
   Ok := False;
   OldLen := LenPhr;
   Repeat
    If(P[XPos+1] in [' ','A'..'Z','a'..'z'])and(XPos+1<LenPhr)Then Delete1
                                                              Else Ok := True;
    If(XPos >= LenPhr)Then Ok := True;
   Until Ok;
   If(OldLen = LenPhr)Then Delete1;
  End;
  ClearBoard;
  _WriteText(X,Y,P);
 End;

 Procedure LeftKey;
 Begin
  If(XPos > 0)Then Dec(XPos)
   else
  Begin
   ErrorBoard;
   Beep;
   NormalBoard;
  End;
 End;

 Procedure RightKey;
 Begin
  If(XPos < LenPhr)Then Inc(XPos) else
  Begin
   ErrorBoard;
   Beep;
   NormalBoard;
  End;
 End;

 Procedure InsertChar;
 Begin
  If(Len > LenPhr)Then
  Begin
   If(GetModeInsert)Then
   Begin
    If(XPos < LenPhr)Then
    Begin
     Move(P[XPos],P[XPos+1],LenPhr-XPos+1);
     P[XPos+1] := Char(Lo(K));
     P[0] := Char(LenPhr + 1);
     _WriteText(X,Y,P);
    End
     else
    Begin
     P[XPos+1] := Char(Lo(K));
     P[0] := Char(LenPhr + 1);
    End;
    _SetCube(X+XPos,Y,Char(Lo(K)));
    Inc(XPos);
    LenPhr := Length(P);
   End
    else
   Begin
    If(Length(P) = 0)Then
    Begin
     P[0] := #1; P[1] := Char(Lo(K)); XPos := 1;
     _SetCube(X,Y,P[1]);
    End
     else
    Begin
     P[XPos+1] := Char(Lo(K));
     If(XPos >= LenPhr)Then P[0] := Char(XPos + 1);
     _WriteText(X,Y,P);
     Inc(XPos);
     LenPhr := Length(P);
    End;
   End;
  End;
 End;

 Function InsertStr(K:Word):Boolean; Forward;

 Procedure __UpDown(K:Word);
 Begin
  Begin
   If(UpDown)Then
   Begin
    If(K = kbUp)Then Escape := kbUp Else Escape := kbDown;
    Chaine := P;
    CloseCursor;
    Exit;
   End
    else
   Begin
    If(InsertStr(UpDn))Then
    Begin
     If(K = kbDown)Then
     Begin
      If(UpDn < 25)Then Inc(UpDn) else UpDn := 0;
     End
      else
     Begin
      If(UpDn > 0)Then Dec(UpDn) else UpDn := 25;
     End;
    End;
   End;
  End;
 End;

 Var FE : Boolean;
     KE : Word;

 Function InsertStr(K:Word):Boolean;
 Var Chaine : String;
     LenChr : Byte;
     Return : Boolean;
     ASCII  : Char;
 Begin
  FE := False;
  If(Char(Lo(K)) < ' ')and(Hi(K) < $33)Then
  Begin
   Case (Key[Lo(K)].Action and 15) of
    0 : Beep;
    2 : DeleteKey;
    3 : DeleteEOLKey;
    4 : DeleteLineKey;
    5 : DeleteWordKey;
    6 : BackSpaceKey;
    7 : CtrlLeftKey;
    8 : CtrlRightKey;
    9 : LeftKey;
   10 : RightKey;
   11 : XPos := 0;
   12 : XPos := LenPhr;
   13 : Begin
         __UpDown(kbUp);
         FE := True;
         KE := kbUp;
        End;
   14 : Init;
   15 : Begin
         __UpDown(kbDown);
         FE := True;
         KE := kbDown;
        End
     else
    Chaine := Key[Lo(K)].Ctrl;
   End;
   Return := True;
  End
   Else
  Begin
   ASCII := AltCodeToASCII(K);
   If(ASCII = #0)Then Return := False
    else
   Begin
    Chaine := Key[Byte(ASCII)-64].Alt;
    Return := True;
   End;
  End;
  InsertStr := Return;
 End;

Begin
 GetPos(X,Y);
 Init;
 AutoInsert;
 Repeat
  SetPosCursor(X+XPos,Y);
  {$IFDEF __Mouse__}
   ShowPtr;
   Repeat
    GetButPos(BM,XM,YM);
    If(BM > 0)Then
    Begin
     XM := XM shr 3; YM := YM shr 3;
     HidePtr;
     If(YM = Y)Then
     Begin
      If Not((XM < X)or(XM > X+Length(P)))Then
      Begin
       XPos := XM - X;
       SetPosCursor(X+XPos,Y);
      End
       else
      Begin
       CloseCursor;
       RX := XM; RY := YM;
       Chaine := P;
       Escape := kbMouse;
       Exit;
      End;
     End
      else
     Begin
      CloseCursor;
      RX := XM; RY := YM;
      Chaine := P;
      Escape := kbMouse;
      Exit;
     End;
     ShowPtr;
     ReleaseKeyOrMoveMouse;
    End;
   Until KeyPressed;
   HidePtr;
  {$ENDIF}
  K := ReadKey;
  Case K of
   kbHome : XPos := 0;
kbUp,kbDown:Begin
             __UpDown(K);
             Exit;
            End;
   kbLeft : LeftKey;
  kbRight : RightKey;
    kbEnd : XPos := LenPhr;
    kbIns : AutoInsert;
    kbDel : DeleteKey;
kbCtrlLeft: CtrlLeftKey;
kbCtrlRight:CtrlRightKey;
   kbBack : BackSpaceKey;
  kbEnter : Move(P,Chaine,Len);
    else
   Begin
    If(Lo(K) in [32..126,128..255])Then InsertChar else
    If((K = kbTab)and(UpDown))Then
    Begin
     Move(P,Chaine,Len);
     Escape := K;
     CloseCursor;
     Exit;
    End
     else
    If(Not(InsertStr(K)))Then
    Begin
     If(FE)Then
     Begin
      Escape := KE;
      Exit;
     End;
     Beep;
    End;
   End;
  End;
 Until ((K = kbEsc)or(K = kbEnter));
 Escape := K;
 CloseCursor;
End;

BEGIN { Main Unit }
END.