(********************************************************)
(*                                                      *)
(*             Malte System/Input Extension             *)
(*                     1993/01/21                       *)
(*                                                      *)
(*     Copyright (C) par les Chevaliers de Malte        *)
(*                                                      *)
(********************************************************)

Unit InputExt;

(********************************************************)
                        INTERFACE
(********************************************************)

Procedure _InputSizeByte(Var Value:LongInt;UpDown:Boolean;Var Escape:Word);
Procedure _InputSizeByteXY(X,Y:Byte;Var Value:LongInt;UpDown:Boolean;Var Escape:Word);
Procedure _InputTime(Var Time:LongInt;Var XP:Byte;Var K:Word);
Procedure _InputTimeXY(X,Y:Byte;Var Time:LongInt;Var XP:Byte;Var K:Word);

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses DOS,Input,Keyboard,Sound,DString,Numeric,Text;

Procedure _InputTimeXY(X,Y:Byte;Var Time:LongInt;Var XP:Byte;Var K:Word);
Begin
 SetPos(X,Y);
 _InputTime(Time,XP,K);
End;

Procedure _InputSizeByteXY(X,Y:Byte;Var Value:LongInt;UpDown:Boolean;Var Escape:Word);
Begin
 SetPos(X,Y);
 _InputSizeByte(Value,UpDown,Escape);
End;

Procedure _InputSizeByte(Var Value:LongInt;UpDown:Boolean;Var Escape:Word);
Var Chn   : String;
    Key   : KeyInputType;
    I     : Byte;
    M,K   : Boolean;
    Error : Word;
    T     : LongInt;
Begin
 FillChar(Key,SizeOf(Key),0);
 FillChar(Chn,SizeOf(Chn),0);
 M := False; K := False;
 Key[Byte(^A)].Ctrl := '0';    Key[Byte(^A)].Alt := '420K';
 Key[Byte(^B)].Ctrl := '512';  Key[Byte(^B)].Alt := '3M';
 Key[Byte(^C)].Ctrl := '1K';   Key[Byte(^C)].Alt := '870K';
 Key[Byte(^D)].Ctrl := '2K';
 Key[Byte(^E)].Ctrl := '4K';
 Key[Byte(^F)].Ctrl := '8K';
 Key[Byte(^G)].Ctrl := '20K';
 Key[Byte(^H)].Ctrl := '40K';
 Key[Byte(^I)].Ctrl := '64K';
 Key[Byte(^J)].Ctrl := '80K';
 Key[Byte(^K)].Ctrl := '100K';
 Key[Byte(^L)].Ctrl := '150K';
 Key[Byte(^M)].Ctrl := '200K';
 Key[Byte(^N)].Ctrl := '250K';
 Key[Byte(^O)].Ctrl := '300K';
 Key[Byte(^P)].Ctrl := '360K';
 Key[Byte(^Q)].Ctrl := '400K';
 Key[Byte(^R)].Ctrl := '500K';
 Key[Byte(^S)].Ctrl := '600K';
 Key[Byte(^T)].Ctrl := '800K';
 Key[Byte(^U)].Ctrl := '1M';
 Key[Byte(^V)].Ctrl := '1.5M';
 Key[Byte(^W)].Ctrl := '2.88M';
 Key[Byte(^X)].Ctrl := '1.2M';
 Key[Byte(^Y)].Ctrl := '1.44M';
 Key[Byte(^Z)].Ctrl := '1.6M';
 If(Value = 0)Then Chn := ''
              Else Str(Value,Chn);
 _InputExtra(Chn,30,Key,UpDown,Escape);
 If(Escape = kbEsc)Then Exit;
 If(Chn <> '')Then
 Begin
  Chn := StrUpper(Chn);
  For I := 1 to Length(Chn) do
  Begin
   If(Chn[I] = ',')Then Chn[I] := '.';
  End;
  If((Pos('M',Chn)>0)or(Pos('MEG',Chn)>0)or(Pos('MO',Chn)>0))Then M := True;
  If((Pos('K',Chn)>0)or(Pos('KILO',Chn)>0)or(Pos('KO',Chn)>0))Then K := True;
 End;
 Val(Chn,T,Error);
 If(Error > 0)Then Exit;
 Value := T;
 If(M)Then Value := 1024 * 1024 * Value;
 If(K)Then Value := 1024 * Value;
End;

Procedure _InputTime(Var Time:LongInt;Var XP:Byte;Var K:Word);
Label _TIME,_EXIT;
Var X,Y : Byte;
    DT  : DateTime;
Begin
 UnpackTime(Time,DT);
 GetPos(X,Y);
_TIME:
  Case XP of
   0 : Begin
        _BarSelectHori(X,Y,X+3);
        Repeat
         K := ReadKey;
         Case K of
              kbRight : Begin
                         XP := 1;
                         BarSelectHori(X,Y,X+3,GetLastColor);
                         Goto _TIME;
                        End;
               kbLeft : Begin
                         XP := 5;
                         BarSelectHori(X,Y,X+3,GetLastColor);
                         Goto _TIME;
                        End;
                kbEsc : Goto _EXIT;
               kbBack : Begin
                         If(DT.Year > 0)Then Dec(DT.Year)
                                        Else Beep;
                         WriteUnColor(X,Y,StrgTo(DT.Year,4));
                        End;
                   else Begin
                         If(Char(Lo(K)) in [' ','+'])Then
                         Begin
                          If(DT.Year < 3192)Then Inc(DT.Year)
                                            Else Beep;
                          WriteUnColor(X,Y,StrgTo(DT.Year,4));
                         End;
                        End;
         End;
        Until ((K = kbEnter)or(K = kbUp)or(K = kbDown)or(K = kbTab));
        BarSelectHori(X,Y,X+3,GetLastColor);
       End;
   1 : Begin
        _BarSelectHori(X+5,Y,X+5+1);
        Repeat
         K := ReadKey;
         Case K of
               kbLeft : Begin
                         XP := 0;
                         BarSelectHori(X+5,Y,X+5+1,GetLastColor);
                         Goto _TIME;
                        End;
              kbRight : Begin
                         XP := 2;
                         BarSelectHori(X+5,Y,X+5+1,GetLastColor);
                         Goto _TIME;
                        End;
                kbEsc : Goto _EXIT;
               kbBack : Begin
                         If(DT.Month > 1)Then Dec(DT.Month)
                                         Else Beep;
                         WriteUnColor(X+5,Y,ByteToStrDec(DT.Month,2));
                        End;
                   else Begin
                         If(Char(Lo(K)) in [' ','+'])Then
                         Begin
                          If(DT.Month < 12)Then Inc(DT.Month)
                                           Else Beep;
                          WriteUnColor(X+5,Y,ByteToStrDec(DT.Month,2));
                         End;
                        End;
         End;
        Until ((K = kbEnter)or(K = kbUp)or(K = kbDown)or(K = kbTab));
        BarSelectHori(X+5,Y,X+5+1,GetLastColor);
       End;
   2 : Begin
        _BarSelectHori(X+8,Y,X+8+1);
        Repeat
         K := ReadKey;
         Case K of
               kbLeft : Begin
                         XP := 1;
                         BarSelectHori(X+8,Y,X+8+1,GetLastColor);
                         Goto _TIME;
                        End;
              kbRight : Begin
                         XP := 3;
                         BarSelectHori(X+8,Y,X+8+1,GetLastColor);
                         Goto _TIME;
                        End;
                kbEsc : Goto _EXIT;
               kbBack : Begin
                         If(DT.Day > 1)Then Dec(DT.Day)
                                       Else Beep;
                         WriteUnColor(X+8,Y,ByteToStrDec(DT.Day,2));
                        End;
                   else Begin
                         If(Char(Lo(K)) in [' ','+'])Then
                         Begin
                          If(DT.Day < 31)Then Inc(DT.Day)
                                         Else Beep;
                          WriteUnColor(X+8,Y,ByteToStrDec(DT.Day,2));
                         End;
                        End;
         End;
        Until ((K = kbEnter)or(K = kbUp)or(K = kbDown)or(K = kbTab));
        BarSelectHori(X+8,Y,X+8+1,GetLastColor);
       End;
   3 : Begin
        _BarSelectHori(X+11,Y,X+11+1);
        Repeat
         K := ReadKey;
         Case K of
               kbLeft : Begin
                         XP := 2;
                         BarSelectHori(X+11,Y,X+11+1,GetLastColor);
                         Goto _TIME;
                        End;
              kbRight : Begin
                         XP := 4;
                         BarSelectHori(X+11,Y,X+11+1,GetLastColor);
                         Goto _TIME;
                        End;
                kbEsc : Goto _EXIT;
               kbBack : Begin
                         If(DT.Hour > 0)Then Dec(DT.Hour)
                                        Else DT.Hour := 23;
                         WriteUnColor(X+11,Y,StrgTo(DT.Hour,2));
                        End;
                   else Begin
                         If(Char(Lo(K)) in [' ','+'])Then
                         Begin
                          If(DT.Hour < 23)Then Inc(DT.Hour)
                                          Else DT.Hour := 0;
                          WriteUnColor(X+11,Y,StrgTo(DT.Hour,2));
                         End;
                        End;
         End;
        Until ((K = kbEnter)or(K = kbUp)or(K = kbDown)or(K = kbTab));
        BarSelectHori(X+11,Y,X+11+1,GetLastColor);
       End;
   4 : Begin
        _BarSelectHori(X+14,Y,X+14+1);
        Repeat
         K := ReadKey;
         Case K of
               kbLeft : Begin
                         XP := 3;
                         BarSelectHori(X+14,Y,X+14+1,GetLastColor);
                         Goto _TIME;
                        End;
              kbRight : Begin
                         XP := 5;
                         BarSelectHori(X+14,Y,X+14+1,GetLastColor);
                         Goto _TIME;
                        End;
                kbEsc : Goto _EXIT;
               kbBack : Begin
                         If(DT.Min > 0)Then Dec(DT.Min)
                                       Else DT.Min := 59;
                         WriteUnColor(X+14,Y,ByteToStrDec(DT.Min,2));
                        End;
                   else Begin
                         If(Char(Lo(K)) in [' ','+'])Then
                         Begin
                          If(DT.Min < 59)Then Inc(DT.Min)
                                         Else DT.Min := 0;
                          WriteUnColor(X+14,Y,ByteToStrDec(DT.Min,2));
                         End;
                        End;
         End;
        Until ((K = kbEnter)or(K = kbUp)or(K = kbDown)or(K = kbTab));
        BarSelectHori(X+14,Y,X+14+1,GetLastColor);
       End;
   5 : Begin
        _BarSelectHori(X+17,Y,X+17+1);
        Repeat
         K := ReadKey;
         Case K of
               kbLeft : Begin
                         XP := 4;
                         BarSelectHori(X+17,Y,X+17+1,GetLastColor);
                         Goto _TIME;
                        End;
              kbRight : Begin
                         XP := 0;
                         BarSelectHori(X+17,Y,X+17+1,GetLastColor);
                         Goto _TIME;
                        End;
                kbEsc : Goto _EXIT;
               kbBack : Begin
                         If(DT.Sec > 0)Then Dec(DT.Sec)
                                       Else DT.Sec := 59;
                         WriteUnColor(X+17,Y,ByteToStrDec(DT.Sec,2));
                        End;
                   else Begin
                         If(Char(Lo(K)) in [' ','+'])Then
                         Begin
                          If(DT.Sec < 59)Then Inc(DT.Sec)
                                         Else DT.Sec := 0;
                          WriteUnColor(X+17,Y,ByteToStrDec(DT.Sec,2));
                         End;
                        End;
         End;
        Until ((K = kbEnter)or(K = kbUp)or(K = kbDown)or(K = kbTab));
        BarSelectHori(X+17,Y,X+17+1,GetLastColor);
       End;
  End;
 _EXIT:
 If(K <> kbEsc)Then PackTime(DT,Time);
End;

BEGIN { Main Unit }
END.