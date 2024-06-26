(********************************************************)
(*                                                      *)
(*                   Malte System/Menu                  *)
(*                      1992/12/14                      *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System

  Derni�re modification :

   Samedi, le 15 mai 1993 (Mise en place du syst�me de directive
                           conditionnel).

  Directive de compilation conditionnel :

   DPMI                  Indique qu'il tourne sous DPMI.
   OS2                   Indique que l'environnement de travaille est OS/2.
   QUICKPASCAL           Indique qu'il s'agit du compilateur QuickPascal.
   VER10                 Indique qu'il s'agit soit du QuickPascal 1.0 ou
                         du Turbo Pascal for Windows 1.0 (Pr�d�finit).
   VER15                 Indique qu'il s'agit du Turbo Pascal for
                         Windows 1.5 (Pr�d�finit).
   VER60                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 6 (Pr�d�finit); si vous d�finisez cette
                         directive, il faut �tre vraiment sur que ce
                         compilateur est compatible � 100%.
   VER70                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 7 (Pr�d�finit); si vous d�finisez cette
                         directive, il faut �tre vraiment sur que ce
                         compilateur est compatible � 100%.
   WINDOWS               Indique que l'environnement de travaille est Windows
   __386__               Indique qu'il faut compiler les instructions pour un
                         processeur 80386 ou post�rieur.
   __ASSEMBLERSUPPORT__  Indique que le compilateur support l'assembler.
                         (Pr�d�finit en fonction des autres variables).
   __EXTERNAL__          Indique qu'il faut faire appelle � la
                         bibliot�que externe. Comme par exemple, si vous
                         d�finis� des proc�dures en Turbo C++, vous devrez
                         faire appelle a cette directive de compilation.
   __OPTIMIZESIZE__      Indique qu'il faut faire en sorte que le code
                         langage machine prenne le moin de place possible.
   __STRPTRSUPPORT__     Indique que le compilateur support des variables
                         de caract�re du m�me genre que le langage C.
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

{$IFDEF __STRPTRSUPPORT__}
 {$DEFINE PCHARSUPPORT}
{$ENDIF}

Unit MNU;

(********************************************************)
                        INTERFACE
(********************************************************)

Uses

     {$IFDEF PCHARSUPPORT}
      Strings,
     {$ENDIF}

     TPointer;

Type

     LineImage = Object
                  Size:Word;
                  Buffer:Pointer;
                  PX1,PY,PX2:Byte;
                  Constructor Init;
                  Function Save(X1,Y,X2:Byte):Boolean;
                  Procedure ReSave(X1,Y,X2:Byte);
                  Procedure BarSelect(Color:Byte);
                  Procedure Restore;
                  Destructor Done;
                 End;

{$IFDEF PCHARSUPPORT}

 Procedure CMenuMsgTyping(X1,Y,X2:Byte;Msg:PChar);
 Procedure CSetActifLineTyping(Msg:PChar;Buffer:BooleanPtr);

 Function CExecMenu(X,Y:Byte;Title,Msg,Hlp:PChar;Var Pos:Byte):Word;
 Function CGetMaxLengthTyping(Msg:PChar):Word;
 Function CGetNumLineTyping(Msg:PChar):Word;

{$ENDIF}

Procedure MenuMsgTyping(X1,Y,X2:Byte;Msg:String);
Procedure SetActifLineTyping(Msg:String;Buffer:BooleanPtr);

Function ExecMenu(X,Y:Byte;Title,Msg:String;Var Pos:Byte):Word;
Function GetMaxLengthTyping(Msg:String):Byte;
Function GetNumLineTyping(Msg:String):Byte;
Function StrNoTyping(Str:String):String;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses
     {$IFDEF __GRAPHDIRECT__}
      DirectGT,
     {$ENDIF}

     Text,LuxeVid,Level,Keyboard,DString,Mouse,
     NumText,NumWin,Windows;

{ ������������������������������������������������������Ŀ
  �                     LineImage.Init                   ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Constructor LineImage.Init;
Begin
 Size := 0; Buffer := Nil;
End;

{ ������������������������������������������������������Ŀ
  �                     LineImage.Save                   ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Function LineImage.Save(X1,Y,X2:Byte):Boolean;
Var TBuffer : ^TByte;
    I       : Byte;
Begin
 PX1 := X1; PY := Y; PX2 := X2;
 {$IFDEF __GraphDirect__}
  If(VC.Methode = ScrnGraphDirect)Then
  Begin
   Size := (X2-X1+1);
   If(MaxAvail < Size)Then Save := False
    else
   Begin
    GetMem(Buffer,Size);
    TBuffer := Buffer;
    For I := 0 to (Size-1) do TBuffer^[I] := DirectGT.GetAttr(X1+I,Y);
    Save := True;
    Exit;
   End;
  End;
 {$ENDIF}
 Size := GetSizeBox(X1,Y,X2,Y);
 If(MaxAvail < Size)Then Save := False
  else
 Begin
  GetMem(Buffer,Size);
  SaveBox(PX1,PY,PX2,PY,Buffer^);
  Save := True;
 End;
End;

{ ������������������������������������������������������Ŀ
  �                   LineImage.ReSave                   ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Procedure LineImage.ReSave(X1,Y,X2:Byte);
Var TBuffer : ^TByte;
    I       : Byte;
Begin
 If(Buffer <> NIL)Then
 Begin
  {$IFDEF __GraphDirect__}
   If(VC.Methode = ScrnGraphDirect)Then
   Begin
    TBuffer := Buffer;
    For I := 0 to (Size-1) do SetAttr(PX1+I,PY,TBuffer^[I]);
    PX1 := X1; PY := Y; PX2 := X2;
    For I := 0 to (Size-1) do TBuffer^[I] := DirectGT.GetAttr(X1+I,Y);
    Exit;
   End;
  {$ENDIF}
  PutBox(PX1,PY,PX2,PY,Buffer^);
  PX1 := X1; PY := Y; PX2 := X2;
  SaveBox(PX1,PY,PX2,PY,Buffer^);
 End;
End;

{ ������������������������������������������������������Ŀ
  �                   LineImage.BarSelect                ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Procedure LineImage.BarSelect(Color:Byte);
Begin
 BarSelectHori(PX1,PY,PX2,Color);
End;

{ ������������������������������������������������������Ŀ
  �                   LineImage.Restore                  ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Procedure LineImage.Restore;
Var TBuffer : ^TByte;
    I       : Byte;
Begin
 If(Buffer <> NIL)Then
 Begin
  {$IFDEF __GraphDirect__}
   If(VC.Methode = ScrnGraphDirect)Then
   Begin
    TBuffer := Buffer;
    For I := 0 to (Size-1) do SetAttr(PX1+I,PY,TBuffer^[I]);
    FreeMem(Buffer,Size);
    Buffer := NIL;
    Exit;
   End;
  {$ENDIF}
  PutBox(PX1,PY,PX2,PY,Buffer^);
  FreeMem(Buffer,Size);
  Buffer := NIL;
 End;
End;

{ ������������������������������������������������������Ŀ
  �                    LineImage.Done                    ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Destructor LineImage.Done;
Begin
 Restore;
End;

{ ������������������������������������������������������Ŀ
  �                    GetNumLineTyping                  ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Function GetNumLineTyping(Msg:String):Byte;
Var I,L : Byte;
Begin
 L := 1;
 For I := 1 to Length(Msg) do If(Msg[I] = '|')Then Inc(L);
 GetNumLineTyping := L;
End;

{ ������������������������������������������������������Ŀ
  �                   SetActifLineTyping                 ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Procedure SetActifLineTyping(Msg:String;Buffer:BooleanPtr);
Var I,L  : Byte;
    _Ofs : Word;
Begin
 L := 1;
 For I := 1 to Length(Msg) do
 Begin
  If(Msg[I] = '|')Then
  Begin
   Inc(L);
   Buffer^[L-1] := Not(Msg[I+1] = '|');
  End;
 End;
End;

{ ������������������������������������������������������Ŀ
  �                   GetMaxLengthTyping                 ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Function GetMaxLengthTyping(Msg:String):Byte;
Var I,L,ML : Byte;
Begin
 L := 0; ML := 0;
 For I := 1 to Length(Msg) do
 Begin
  If Not(Msg[I] = '|')Then
  Begin
   If Not(Msg[I] in ['^','~'])Then Inc(L);
  End
   Else L := 0;
  If(L > ML)Then ML := L;
 End;
 GetMaxLengthTyping := ML + 1;
End;

{ ������������������������������������������������������Ŀ
  �                      MenuMsgTyping                   ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Procedure MenuMsgTyping(X1,Y,X2:Byte;Msg:String);
Var I,L : Byte;
Begin
 WriteTypingXY(X1+1,Y,Msg);
 L := 0;
 For I := 1 to Length(Msg) do
 Begin
  If(Msg[I] = '|')Then
  Begin
   Inc(L);
   If(Msg[I-1] = '|')Then
   Begin
    BarCharHori(X1,Y+L-1,X2,'�');
    If Not(((VC.EGA)or(VC.VGA))and(GetFlagLuxeVid))Then
    Begin
     SetChar(X1-1,Y,'�');
     SetChar(X2+1,Y,'�');
    End;
   End;
  End;
 End;
End;

{ ������������������������������������������������������Ŀ
  �                      StrNoTyping                     ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Function StrNoTyping(Str:String):String;
Var I   : Byte;
    Chn : String;
Begin
 FillChar(Chn,SizeOf(Chn),0);
 For I := 1 to Length(Str) do
 Begin
  If Not(Str[I] in [#0..#31,'^','|','~'])Then Chn := Chn + Str[I];
 End;
 StrNoTyping := Chn;
End;

{ ������������������������������������������������������Ŀ
  �                       ExecMenu                       ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Function ExecMenu(X,Y:Byte;Title,Msg:String;Var Pos:Byte):Word;
Label Quit;
Var Image                            : BoxImage;
    Line                             : LineImage;
    Actif                            : BooleanPtr;
    Letter                           : CharPtr;
    K,MB                             : Word;
    X1,Y1,X2,Y2,XM,YM,MX,MY,L,I,TP,T : Byte;
    Chr                              : Char;

 Procedure PutBar;
 Begin
  Line.ReSave(X1+1,Y1+2+Pos,X2-1);
  Line.BarSelect(Color.Menu.Select);
 End;

Begin
 X1 := X; Y1 := Y;
 XM := 2 + GetMaxLengthTyping(Msg);
 T := (LengthTyping(Title) + 1);
 If(XM < T)Then XM := T;
 L := GetNumLineTyping(Msg);
 YM := 2 + L;
 X2 := X + XM; Y2 := Y + YM;
 Actif := Nil; Letter := Nil;
 If(MaxAvail < L*2)Then
 Begin
  ExecMenu := $FFFF;
  Exit;
 End;
 GetMem(Actif,L);
 GetMem(Letter,L);
 SetActifLineTyping(Msg,Actif);
 Image.Init;
 If(Image.GetBox(X1,Y1,X2+2,Y2+1))Then
 Begin
  WriteOnlyColorAnd(X1,Y1,StrNoTyping(Title),2,Color.Menu.Select);
  SetLuxeBorderSimple;
  PutFillBorder(X1,Y1+1,X2,Y2,Color.Menu.Normal);
  SetColor(Color.Menu.HighLetter); SetColor(Color.Menu.Normal);
  MenuMsgTyping(X1+1,Y1+2,X2-1,Msg);
  Line.Init;
  If(Line.Save(X1+1,Y1+2+Pos,X2-1))Then
  Begin
   Line.BarSelect(Color.Menu.Select);
   Repeat
    {$IFDEF __Mouse__}
     ShowPtr;
     Repeat
      GetButTPos(MB,MX,MY);
      If(MB > 0)Then
      Begin
       If(IsExitIcon(MX,MY))Then
       Begin
        ReleaseKeyMouse;
        HidePtr;
        K := _Exit_;
        Goto Quit;
       End;
       If(MX > X1)and(MX < X2)Then
       Begin
        If(MY > Y1)and(MY < Y2)Then
        Begin
         TP := MY - Y1 - 1;
         If(Actif^[TP])Then
         Begin
          HidePtr;
          Pos := TP;
          PutBar;
          ShowPtr;
          ReleaseKeyMouse;
          HidePtr;
          K := kbEnter;
          Goto Quit;
         End;
        End;
       End;
      End;
     Until KeyPressed;
     HidePtr;
    {$ENDIF}
    K := ReadKey;
    Case K of
       kbUp : Begin
               If(Pos > 0)Then
               Begin
                Dec(Pos);
                If(Pos > 0)Then
                Begin
                 If Not(Actif^[Pos])Then Dec(Pos);
                End;
               End
                Else
               Pos := L-1;
               PutBar;
              End;
     kbDown : Begin
               If(Pos < L-1)Then
               Begin
                Inc(Pos);
                If Not(Actif^[Pos])Then Inc(Pos);
               End
                Else
               Pos := 0;
               PutBar;
              End;
     kbHome : If(Pos > 0)Then
              Begin
               Pos := 0;
               PutBar;
              End;
      kbEnd : If(Pos < (L-1))Then
              Begin
               Pos := L-1;
               PutBar;
              End;
         else Begin
               Chr := CharUpper(Char(Lo(K)));
               For I := 0 to L-1 do
               Begin
                If(StrUpper(SearchHigh(SearchWord(Msg,I))) = Chr)Then
                Begin
                 Pos := I;
                 K := kbEnter;
                 PutBar;
                End;
               End;
               Goto Quit;
              End;
    End;
   Until False = True;
  End;
Quit:
  Line.Done;
 End
  else
 K := $FFFF;
 Image.Restore;
 FreeMem(Actif,L);
 FreeMem(Letter,L);
 ExecMenu := K;
End;

{ ������������������������������������������������������Ŀ
  �                   CGetMaxLengthTyping                ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

{$IFDEF PCHARSUPPORT}

 Function CGetMaxLengthTyping(Msg:PChar):Word;
 Var I,L,ML : Word;
 Begin
  L := 0; ML := 0; I := 0;
  While Not(Msg[I] = #0) do
  Begin
   If Not(Msg[I] = '|')Then
   Begin
    If Not(Msg[I] in ['^','~'])Then Inc(L);
   End
    Else L := 0;
   If(L > ML)Then ML := L;
   Inc(I);
  End;
  CGetMaxLengthTyping := ML + 1;
 End;

{$ENDIF}

{ ������������������������������������������������������Ŀ
  �                   CGetNumLineTyping                  ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

{$IFDEF PCHARSUPPORT}

 Function CGetNumLineTyping(Msg:PChar):Word;
 Var I,L : Word;
 Begin
  CGetNumLineTyping := GetNumLineTyping(StrPas(Msg));
  L := 1; I := 0;
  While Not(Msg[I] = #0) do
  Begin
   If(Msg[I] = '|')Then Inc(L);
   Inc(I);
  End;
  CGetNumLineTyping := L;
 End;

{$ENDIF}

{ ������������������������������������������������������Ŀ
  �                   CSetActifLineTyping                ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

{$IFDEF PCHARSUPPORT}

 Procedure CSetActifLineTyping(Msg:PChar;Buffer:BooleanPtr);
 Var I,L : Word;
 Begin
  L := 1; I := 0;
  While Not(Msg[I] = #0) do
  Begin
   If(Msg[I] = '|')Then
   Begin
    Inc(L);
    Buffer^[L-1] := Not(Msg[I+1] = '|');
   End;
   Inc(I);
  End;
 End;

{$ENDIF}

{ ������������������������������������������������������Ŀ
  �                     CMenuMsgTyping                   ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

Procedure CMenuMsgTyping(X1,Y,X2:Byte;Msg:PChar);
Var I,L : Byte;
Begin
 {MenuMsgTyping(X1,Y,X2,StrPas(Msg));}
 WriteTypingXY(X1+1,Y,StrPas(Msg));
 L := 0; I := 0;
 While Not(Msg[I] = #0) do
 Begin
  If(Msg[I] = '|')Then
  Begin
   Inc(L);
   If(Msg[I-1] = '|')Then
   Begin
    BarCharHori(X1,Y+L-1,X2,'�');
    If Not(((VC.EGA)or(VC.VGA))and(GetFlagLuxeVid))Then
    Begin
     SetChar(X1-1,Y,'�');
     SetChar(X2+1,Y,'�');
    End;
   End;
  End;
  Inc(I);
 End;
End;

{ ������������������������������������������������������Ŀ
  �                       CExecMenu                      ��
  ���������������������������������������������������������
   �������������������������������������������������������� }

{$IFDEF PCHARSUPPORT}

 Function CExecMenu(X,Y:Byte;Title,Msg,Hlp:PChar;Var Pos:Byte):Word;
 Label Quit;
 Var Image                            : BoxImage;
     Line                             : LineImage;
     Actif                            : BooleanPtr;
     Letter                           : CharPtr;
     K,MB                             : Word;
     X1,Y1,X2,Y2,XM,YM,MX,MY,L,I,TP,T : Byte;
     Chr                              : Char;

  Procedure PutBar;
  Begin
   Line.ReSave(X1+1,Y1+2+Pos,X2-1);
   Line.BarSelect(Color.Menu.Select);
   PutLastBar(2,CSearchWord(Hlp,Pos));
  End;

 Begin
  X1 := X; Y1 := Y;
  XM := 2 + CGetMaxLengthTyping(Msg);
  T := (CLengthTyping(Title) + 1);
  If(XM < T)Then XM := T;
  L := CGetNumLineTyping(Msg);
  YM := 2 + L;
  X2 := X + XM; Y2 := Y + YM;
  Actif := Nil; Letter := Nil;
  If(MaxAvail < L*2)Then
  Begin
   CExecMenu := $FFFF;
   Exit;
  End;
  GetMem(Actif,L);
  GetMem(Letter,L);
  CSetActifLineTyping(Msg,Actif);
  Image.Init;
  If(Image.GetBox(X1,Y1,X2+2,Y2+1))Then
  Begin
   WriteOnlyColorAnd(X1,Y1,StrNoTyping(StrPas(Title)),2,Color.Menu.Select);
   SetLuxeBorderSimple;
   PutFillBorder(X1,Y1+1,X2,Y2,Color.Menu.Normal);
   SetColor(Color.Menu.HighLetter); SetColor(Color.Menu.Normal);
   CMenuMsgTyping(X1+1,Y1+2,X2-1,Msg);
   Line.Init;
   If(Line.Save(X1+1,Y1+2+Pos,X2-1))Then
   Begin
    Line.BarSelect(Color.Menu.Select);
    PutLastBar(2,CSearchWord(Hlp,Pos));
    Repeat
     {$IFDEF __Mouse__}
      ShowPtr;
      Repeat
       GetButTPos(MB,MX,MY);
       If(MB > 0)Then
       Begin
        If(IsExitIcon(MX,MY))Then
        Begin
         ReleaseKeyMouse;
         HidePtr;
         K := _Exit_;
         Goto Quit;
        End;
        If(MX > X1)and(MX < X2)Then
        Begin
         If(MY > Y1)and(MY < Y2)Then
         Begin
          TP := MY - Y1 - 1;
          If(Actif^[TP])Then
          Begin
           HidePtr;
           Pos := TP;
           PutBar;
           ShowPtr;
           ReleaseKeyMouse;
           HidePtr;
           K := kbEnter;
           Goto Quit;
          End;
         End;
        End;
       End;
      Until KeyPressed;
      HidePtr;
     {$ENDIF}
     K := ReadKey;
     Case K of
        kbUp : Begin
                If(Pos > 0)Then
                Begin
                 Dec(Pos);
                 If(Pos > 0)Then
                 Begin
                  If Not(Actif^[Pos])Then Dec(Pos);
                 End;
                End
                 Else
                Pos := L-1;
                PutBar;
               End;
      kbDown : Begin
                If(Pos < L-1)Then
                Begin
                 Inc(Pos);
                 If Not(Actif^[Pos])Then Inc(Pos);
                End
                 Else
                Pos := 0;
                PutBar;
               End;
      kbHome : If(Pos > 0)Then
               Begin
                Pos := 0;
                PutBar;
               End;
       kbEnd : If(Pos < (L-1))Then
               Begin
                Pos := L-1;
                PutBar;
               End;
          else Begin
                Chr := CharUpper(Char(Lo(K)));
                For I := 0 to L-1 do
                Begin
                 If(StrUpper(SearchHigh(CSearchWord(Msg,I))) = Chr)Then
                 Begin
                  Pos := I;
                  K := kbEnter;
                  PutBar;
                 End;
                End;
                Goto Quit;
               End;
     End;
    Until False = True;
   End;
Quit:
   Line.Done;
  End
   else
  K := $FFFF;
  Image.Restore;
  FreeMem(Actif,L);
  FreeMem(Letter,L);
  CExecMenu := K;
 End;

{$ENDIF}

BEGIN { Main Unit }
END.