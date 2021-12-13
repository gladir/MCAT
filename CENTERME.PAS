(********************************************************)
(*                                                      *)
(*              Malte System/Center Menu                *)
(*                      1993/05/10                      *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programeur :

   Sylvain Maltais

  Note :

   ş Cette unit‚ requŠre une version de Turbo Pascal 7 ou
     post‚rieur ou n'importe quel Turbo Pascal for Windows.
}

Unit CenterMenu;

(********************************************************)
                       INTERFACE
(********************************************************)

Uses Strings,Windows;

Type

     CenterMenuRecord = Record
                         Key       : PChar;
			 LongMsg   : PChar;
			 MsgEndBar : PChar;
                         Actived   : Boolean;
                        End;

     CenterMenuStrc   = Array[0..($FFF0 div SizeOf(CenterMenuRecord))] of
                         CenterMenuRecord;

     CenterMenuPtr    = ^CenterMenuStrc;

     WinCenterMnu = Object
                     Constructor Init(L,H:Byte;Title,SubTitle:String;Main:CenterMenuPtr);
                     Function Run(Var Pos:Word):Word;
                     Destructor Done;
                     PRIVATE
                     MainMsg:CenterMenuPtr;
                     W,SW:Wins;
                     LK:Byte;
                     NK:Word;
                     Procedure SetToKey(N:Word);
                     Procedure ResetToKey(N:Word);
                    End;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses Keyboard,Numeric,Level,Text,LuxeVid,VidKey;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 WinCenterMnu.Init                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor WinCenterMnu.Init(L,H:Byte;Title,SubTitle:String;Main:CenterMenuPtr);
Var Str : String;
    J   : Word;
Begin
 MainMsg := Main;
 LK := 0;
 For J := 0 to Numeric.WordMax do
 Begin
  If(Main^[J].Key = NIL)Then Break;
  Str := StrPas(Main^[J].Key);
  If(Length(Str) > LK)Then LK := Length(Str);
 End;
 NK := J;
 Inc(LK,6);
 W.InitCenter(L,H,Title,Level.Color.Window.Regular);
 SW._InitSmallShade(W._X1+LK+2,W._Y1+2,W._X2-2,W._Y2-2,SubTitle,W.Colors);
 For J := 0 to NK-1 do
 Begin
  _PutVideoKeyText(W._X1+2,W._Y1+3*J+2,W._X1+LK-1,StrPas(Main^[J].Key));
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  WinCenterMnu.SetToKey               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure WinCenterMnu.SetToKey(N:Word);
Begin
 BarSelectHori(W._X1+2,W._Y1+3*N+2,W._X1+LK-1,W.Colors.SelectB);
 SW.Clear;
 SW.Ln;
 SetColor(W.Colors.Msg);
 SW.PutMsg(StrPas(MainMsg^[N].LongMsg));
 SetColor(Level.Color.EndBar.Normal);
 PutLastBar(2,StrPas(MainMsg^[N].MsgEndBar));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                WinCenterMnu.ResetToKey               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure WinCenterMnu.ResetToKey(N:Word);
Begin
 _PutVideoKeyText(W._X1+2,W._Y1+3*N+2,W._X1+LK-1,StrPas(MainMsg^[N].Key));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                   WinCenterMnu.Run                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function WinCenterMnu.Run(Var Pos:Word):Word;
Var K       : Word;
    Ok      : Boolean;
    MX,MY,J : Byte;
Begin
 SetToKey(Pos);
 Repeat
  Ok := False;
  K := W.UserAction;
  Case K of
   {$IFDEF __MOUSE__}
    _Mouse_ : Begin
               W.GetPosUserActionInWin(MX,MY);
               If((MX >= 2)and(MX <= 2 + LK))Then
               Begin
                For J := 0 to NK - 1 do
                Begin
                 If(MY = (1 + (J * 3)))Then
                 Begin
                  ResetToKey(Pos);
                  Pos := J;
                  SetToKey(Pos);
                  Run := kbEnter;
                  Exit;
                 End;
                End;
               End;
              End;
    {$ENDIF}
    kbDown : Begin
              ResetToKey(Pos);
              Pos := MaxByte(Pos,NK-1);
              SetToKey(Pos);
             End;
      kbUp : Begin
              ResetToKey(Pos);
              Pos := MinByte(Pos,NK-1);
              SetToKey(Pos);
             End;
    kbHome : Begin
              ResetToKey(Pos);
              Pos := 0;
              SetToKey(0);
             End;
     kbEnd : Begin
              ResetToKey(Pos);
              Pos := NK-1;
              SetToKey(Pos);
             End;
        Else Ok := True;
  End;
 Until Ok;
 Run := K;
 ResetToKey(Pos);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  WinCenterMnu.Done                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Destructor WinCenterMnu.Done;
Begin
 SW.Done;
 W.Done;
End;

BEGIN { Main Unit }
END.