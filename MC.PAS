(********************************************************)
(*                                                      *)
(*                Malte Center/Main Program             *)
(*                      1993/01/04                      *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Uses VidState,LuxeVid,Window,Error,Text,Keyboard,VidKey,
     Input,Handle,DString,Sound,DOS,Level,PassWord,Mnu,
     WinErr,MCFile,MCStruct;

Var

    VideoStatement : VideoStatementType;

    _VideoMethode  : Byte;
    _EditMenu      : Boolean;

    FileName : PathStr;

{ Cette fonction enregistre un titre dans le fichier
  sp�cifi� et sp�cifi� par l'utilisateur. Si l'utilisateur
  a chang� d'id�e, il retourne 'false'. Il retourne 'true'
  si l'op�ration s'est bien d�roul�.

  Note : Si le fichier contient d�ja un titre il n'est pas
         pris en compte. }

Function NewInputTitle(FileName:PathStr):Boolean;
Const L = 50; H = 3;
Var Image       : BoxImage;
    Window      : WindowType;
    X1,Y1,X2,Y2 : Byte;
    Key         : KeyInputType;
    Title       : TitleType;
    Escape      : Word;
Begin
 FillChar(Title,SizeOf(Title),0);
 FillChar(Key,SizeOf(Key),0);
 X1 := (GetMaxX-(L+4)) shr 1; X2 := X1 + (L+3);
 Y1 := (GetMaxY-H) shr 1; Y2 := Y1 + H;
 If(Image.GetBox(X1,Y1,X2+2,Y2+2))Then
 Begin
  Window.InitRegular;
  Window.NoZoom;
  Window.PutWindow(X1,Y1,X2,Y2,'Set Title Menu');
  Window.Done;
  SetPos(X1+2,Y1+2);
  SetColor($1F);
  Repeat
   _InputExtra(Title,L,Key,False,Escape);
  Until (Escape = kbEnter)or(Escape = kbEsc);
  If(Escape = kbEnter)Then
  Begin
   If(Title = '')Then NewInputTitle := False
    else
   Begin
    Escape := NewFileItem(FileName,Title);
    NewInputTitle := True;
   End;
  End
   else
  NewInputTitle := False;
 End
  else
 Beep;
 Image.Restore;
End;

{ Cette fonction demande les informations sur l'item.
  L'enregistrement n'est pas initialis�. }

Function InputItem(Var Item:ItemType):Word;
Label _NAME,_PATH,_PARAMETER,_PASSWORD,_EXIT;
Const L = 73; H = 6;
      NameLen      = 64;
      PathLen      = 64;
      ParameterLen = 64;
      PasswordLen  = 32;
Var Image       : BoxImage;
    Window      : WindowType;
    X1,Y1,X2,Y2 : Byte;
    Key         : KeyInputType;
    Title       : TitleType;
    Escape      : Word;
Begin
 FillChar(Title,SizeOf(Title),0);
 FillChar(Key,SizeOf(Key),0);
 X1 := (GetMaxX-(L+4)) shr 1; X2 := X1 + (L+4);
 Y1 := (GetMaxY-H) shr 1; Y2 := Y1 + H;
 If(Image.GetBox(X1,Y1,X2+2,Y2+2))Then
 Begin
  Window.InitRegular;
  Window.NoZoom;
  Window.PutWindow(X1,Y1,X2,Y2,'Set Item Menu');
  Window.Done;
  SetColor(Color.Window.Regular.Msg);
  Case Language of
   lgEnglish : WriteTypingXY(X1+2,Y1+2,'Name|Path|Parameter|Password');
          else WriteTypingXY(X1+2,Y1+2,'Nom|R�pertoire|Param�tre|Mots passe');�=߷�����_�
4d`M���T��0t =Z�F�Lt$�� ���\�_�[��?>�� �=����r&R��X�'u
�(��y�"�r _�AZ5�x�r?�
@u  �=�u����Όن��� N�
����z �����t�#�z͇0 ����5D{+VP�0`e�=q�؏3ªQ2uS�{� p����	����f��/Z*��������Ҥ;��
�{��{5vƓŽ�؃�0� �z�Y{!1�B���� ��훇ځ��ō�ۉ� <�+r-���� ����O}��������/ ��#z 5��������wb�=��D �1	�^}&  x\Qv{��,Q�,y D���0�%""0"���������� ������'�   V���Z��S��1�S ��N].�9҃��� ���v )����_:��Hori(X1+12,Y1+3,X1+12+PathLen-1,$9F);
  Case Escape of
     kbEsc : Begin
              InputItem := kbEsc;
              Goto _EXIT;
              End;
       kbUp : Goto _NAME;
    kbEnter : Begin
               InputItem := kbEnter;
               Goto _EXIT;
              End;
  End;
_PARAMETER:
  SetPos(X1+12,Y1+4);
  _InputExtra(Item.Param,ParameterLen,Key,True,Escape);
  BarSelectHori(X1+12,Y1+4,X1+12+ParameterLen-1,$9F);
  Case Escape of
      kbEsc : Begin
               InputItem := kbEsc;
               Goto _EXIT;
              End;
       kbUp : Goto _PATH;
    kbEnter : Begin
               InputItem := kbEnter;
               Goto _EXIT;
              End;
  End;
_PASSWORD:
  SetPos(X1+12,Y1+5);
  _InputExtra(Item.Password,PasswordLen,Key,True,Escape);
  CloseCursor;
  BarSelectHori(X1+12,Y1+5,X1+12+PasswordLen-1,$9F);
  Case Escape of
        kbEsc : Begin
                 InputItem := kbEsc;
                 Goto _EXIT;
                End;
         kbUp : Goto _PARAMETER;
 kbTab,kbDown : Goto _NAME;
      kbEnter : Begin
                 InputItem := kbEnter;
                 Goto _EXIT;
                End;
  End;
  Goto _PASSWORD;
 End
  else
 Begin
  Beep;
  InputItem := 0;
 End;
_EXIT:
 Image.Restore;
End;

Function NewInputItem(Var Item:ItemType):Word;
Begin
 FillChar(Item,SizeOf(Item),0);
 NewInputItem := InputItem(Item);
End;

Procedure NewMenu(FileName:PathStr;Var P:LongInt);
Var Rtn,Err : Word;
    Item    : ItemType;
Begin
 If(NewInputTitle(FileName))Then
 Begin
  Repeat
   Rtn := NewInputItem(Item);
   If(Item.Name = '')Then Rtn := kbEsc;
   If(Rtn = kbEnter)Then
   Begin
    Err := SetItemLine(FileName,P,Item);
    Inc(P);
   End;
  Until (Rtn <> kbEnter);
 End;
End;

Procedure EditMenu(Var FileName:PathStr);
Label _FIRST;
Const Pos1 : Byte = 0; Pos2 : Byte = 0; P : LongInt = 0;
Var K : Word;
Begin
 P := 0;
 SetColor(Color.Menu.HighLetter); SetColor(Color.Menu.Normal);
 WriteTypingXY(3,1,'^M^enu  ^I^tem');
_FIRST:
 Case Language of
  lgEnglish : K := ExecMenu(2,1,'^M^enu','^L^oad|^N^ew|^S^ave|^E^xit',Pos1);
         else K := ExecMenu(2,1,'^M^enu','^C^harge|^N^ouveau|^S^auve|^Q^uitte',Pos1);
 End;
 Case K of
  kbEnter : Case Pos1 of
             1 : NewMenu(FileName,P);
             3 : Exit;
            End;
 End;
 Case Language of
  lgEnglish : K := ExecMenu(8,1,'^I^tem','^A^ddition|^M^odify|^D^elete|^T^ri',Pos2);
         else K := ExecMenu(8,1,'^I^tem','^A^ddition|^M^odifie|^E^fface|^T^ri',Pos2);
 End;
 Goto _FIRST;
End;

Procedure ExecMenu(FileName:PathStr);
Label _RETRY,_EXIT;
Const L = 64; H = 10;
Var Image            : BoxImage;
    X1,Y1,X2,Y2,I,YP : Byte;
    Title            : TitleType;
    Item             : ItemType;
    K,Err            : Word;
    DOSErr           : Integer;
    EndItem,P        : LongInt;
    Flags            : Boolean;

 Procedure InitScreen;
 Var I,Max  : Byte;
     Window : WindowType;
 Begin
  Window.InitRegular;
  Window.NoZoom;
  Window.PutWindow(X1,Y1,X2,Y2,Title);
  Window.Done;
  If(EndItem < 7)Then Max := EndItem
                 Else Max := 7;
  For I := 0 to Max do
  Begin
   Err := GetItemLine(FileName,I,Item);
   WriteText(X1+2,Y1+2+I,Item.Name,$9B);
  End;
  BarSelectHori(X1+1,Y1+2+YP,X2-1,$0F);
 End;

Begin
 FillChar(Title,SizeOf(Title),0);
 Err := GetTitle(FileName,Title);
 EndItem := GetEndItem(FileName);
 P  := 0; YP := 0;
 X1 := (GetMaxX-(L+4)) shr 1; X2 := X1 + (L+4);
 Y1 := (GetMaxY-H) shr 1; Y2 := Y1 + H;
 If(Image.GetBox(X1,Y1,X2+2,Y2+2))Then
 Begin
  InitScreen;
  Repeat
   K := ReadKey;
   Case K of
    kbUp : Begin
            If(EndItem > 0)Then
            Begin
             If(P > 0)Then
             Begin
              If(YP > 0)Then
              Begin
               BarSelectHori(X1+1,Y1+2+YP,X2-1,$9B);
               Dec(YP); Dec(P);
               BarSelectHori(X1+1,Y1+2+YP,X2-1,$0F);
              End
               else
              Begin
               Dec(P);
               For I := 0 to 7 do
               Begin
                Err := GetItemLine(FileName,P+I,Item);
                WriteUnColor(X1+2,Y1+2+I,Item.Name+Space(64-Length(Item.Name)));
               End;
              End;
             End;
            End;
           End;
  kbDown : Begin
            If(EndItem > 0)Then
            Begin
             If(P < EndItem)Then
             Begin
              If(YP < 7)Then
              Begin
               If(YP < EndItem)Then
               Begin
                BarSelectHori(X1+1,Y1+2+YP,X2-1,$9B);
                Inc(YP); Inc(P);
                BarSelectHori(X1+1,Y1+2+YP,X2-1,$0F);
               End;
              End
               else
              Begin
               Inc(P);
               For I := 0 to 7 do
               Begin
                Err := GetItemLine(FileName,P-I,Item);
                WriteUncolor(X1+2,Y1+2+7-I,Item.Name+Space(64-Length(Item.Name)));
               End;
              End;
             End;
            End;
           End;
 kbEnter : Begin
            Err := GetItemLine(FileName,P,Item);
            If(WinPassWord(Item.Password))Then
            Begin
             If((Item.Path = '')and
              ((StrUpper(Item.Param) = 'QUIT')or
               (StrUpper(Item.Param) = 'EXIT')))Then Goto _EXIT;
             If((Item.Param = '')and
              ((StrUpper(Item.Path) = 'QUIT')or
               (StrUpper(Item.Path) = 'EXIT')))Then Goto _EXIT;
_RETRY:      Flags := VideoStatement.Restore;
             VideoStatement.Done;
             Exec(Item.Path,Item.Param);
             DOSErr := DOSError;
             VideoStatement.Init;
             Flags := VideoStatement.Save;
             InitVideoDeluxe;
             InitScreenApplication('Malte Center');
             InitScreen;
             If(DOSErr > 0)Then
             Begin
              Case WinExecError(DOSErr) of
               1 : Goto _RETRY;
              End;
             End;
            End;
           End;
   End;
  Until (K = kbEsc);
 End
  else
 Beep;
_EXIT:
 Image.Restore;
End;

Procedure GetParam;
Var I   : Word;
    Chn : String;
Begin
 If(ParamCount > 0)Then
 Begin
  For I := 1 to ParamCount do
  Begin
   Chn := StrUpper(ParamStr(I));
   If(Chn[1] in ['-','/','_'])Then Chn := DeleteStr(Chn,1,1);
   If(Chn = 'ANG')Then Language := lgEnglish else
   If(Chn = 'ANGLAIS')Then Language := lgEnglish else
   If(Chn = 'BIOSSCRN')Then _VideoMethode := ScrnBIOS else
   If(Chn = 'BIOSVIDEO')Then _VideoMethode := ScrnBIOS else
   If(Chn = 'BIOSVID')Then _VideoMethode := ScrnBIOS else
   If(Chn = 'DIRECTSCRN')Then _VideoMethode := ScrnDirect else
   If(Chn = 'DIRECTVIDEO')Then _VideoMethode := ScrnDirect else
   If(Chn = 'EDIT')Then _EditMenu := True else
   If(Chn = 'EDITMENU')Then _EditMenu := True else
   If(Chn = 'ENG')Then Language := lgEnglish else
   If(Chn = 'ENGLISH')Then Language := lgEnglish else
   If(Chn = 'FR')Then Language := lgFrensh else
   If(Chn = 'FRA')Then Language := lgFrensh else
   If(Chn = 'FRANCAIS')Then Language := lgFrensh else
   If(Chn = 'FRE')Then Language := lgFrensh else
   If(Chn = 'FRENSH')Then Language := lgFrensh else
   If(Chn = 'JOYSTICK')Then _Joystick := True else
   If(Chn = 'MOUSE')Then _Mouse := True else
   If(Chn = 'MS')Then _Mouse := True else
   If(Chn = 'NOJOY')Then _Joystick := False else
   If(Chn = 'NOJOYSTICK')Then _Joystick := False else
   If(Chn = 'NOMOUSE')Then _Mouse := False else
   If(Chn = 'NOMS')Then _Mouse := False else
   If(Chn = 'SETMENU')Then _EditMenu := True else
   If(Chn = 'VIDBIOS')Then _VideoMethode := ScrnBIOS
    else
   FileName := ParamStr(I);
  End;
 End;
End;

Var Item : ItemType;
    P    : LongInt;

BEGIN { main program }
 FileName := 'MC.MNU'; P := 0;
 _EditMenu := False; _VideoMethode := ScrnDirect;
 GetParam;
 SetVideoMethode(_VideoMethode);
 VideoStatement.Init;
 If Not(VideoStatement.Save)Then
 Begin
  Case Language of
   lgEnglish : HaltMsg('Error : Saving video bad!');
          else HaltMsg('Erreur : Sauvegarde impossible!');
  End;
 End;
 InitVideoDeluxe;
 InitScreenApplication('Malte Center');
 If(_EditMenu)Then
 Begin
  EditMenu(FileName);
 End
  else
 Begin
  If(FileExist(FileName))Then ExecMenu(FileName)
                         Else NewMenu(FileName,P);
 End;
 DoneVideoDeluxe;
 If Not(VideoStatement.Restore)Then
 Begin
  Case Language of
   lgEnglish : HaltMsg('Error : Restoring video bad!');
          else HaltMsg('Erreur : Restoration impossible!');
  End;
 End;
 VideoStatement.Done;
END.