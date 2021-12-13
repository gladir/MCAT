(********************************************************)
(*                                                      *)
(*              Malte System/Malte-DOS                  *)
(*                    1993/03/09                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmer :

   Sylvain Maltais
}

Unit MalteDOS;

(********************************************************)
                       INTERFACE
(********************************************************)

Uses DOS,Windows;

Const

      MinKeyFunction = 1;
      MaxKeyFunction = 12;

      MinKey = Byte(^A);

Type

      MDOS   = Object(Wins)
                Constructor InitMDOSCenter(L,H:Byte);
                Constructor InitMDOS(_X1_,_Y1_,_X2_,_Y2_:Byte);
                Function Run:Word;
                PRIVATE
                Param:String;
                Ext:String;
                Echo:Boolean;
                Procedure PutComspec;
                Procedure PutCurrentDisk;
                Procedure PutCurrentPath;
                Procedure PutDir;
                Procedure PutEcho;
                Procedure PutFree;
                Procedure PutLine(Str:String);
                Procedure PutPath;
                Procedure PutMemory;
                Procedure PutSet;
                Procedure PutStr(Str:String);
                Procedure PutVer;
                Procedure PutVol;
                Procedure RunChDir;
                Procedure RunCopy;
                Procedure RunDel;
                Procedure RunMkDir;
                Procedure RunRMDir;
                Function Extract(CmpMsg:String):Boolean;
                Function ExtractExt(P:Byte;Var Bar:Boolean):String;
                Function MaxExtractExt:Byte;
                Function GetMaxLine:Byte;
                Function GetPath:PathStr;
                Function GetVer:String;
               End;

Procedure WinMalteDOS;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses Keyboard,StrTime,DString,Level,OS,Dir,Text,LanWins,LanDStr,
     Prompt,NumWin,Handle;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      WinMalteDOS                     ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure WinMalteDOS;
Var W   : MDOS;
    K   : Word;
    L,H : Byte;
Begin
 L := Text.GetMaxX-6;
 H := Text.GetMaxY-6;
 If(H < 2)Then H := 15;
 W.InitMDOSCenter(L,H);
 K := W.Run;
 W.Done;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MDOS.InitMDOS                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor MDOS.InitMDOS(_X1_,_Y1_,_X2_,_Y2_:Byte);
Begin
 Init(_X1,_Y1,_X2,_Y2,'Malte-DOS',Level.Color.Window.Shell);
 Echo := True;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MDOS.InitMDOSCenter               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor MDOS.InitMDOSCenter(L,H:Byte);
Var _X1_,_Y1_,_X2_,_Y2_ : Byte;
Begin
 GetSizeWindowCenter(L,H,_X1_,_Y1_,_X2_,_Y2_);
 InitMDOS(_X1_,_Y1_,_X2_,_Y2_);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MDOS.PutComspec                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutComspec;
Var Comspec : String;
Begin
 Comspec := GetEnv('COMSPEC');
 If(Comspec = '')Then
  Comspec := LStr('COMSPEC is empty!','Le COMSPEC est vide!');
 PutLine(Comspec);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MDOS.PutEcho                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutEcho;
Var Str : String;
Begin
 If(MaxExtractExt = 0)Then
 Begin
  PutStr(LStr('ECHO is ','L''‚cho est '));
  If(Echo)Then PutLine(LStr('ON','ouvert'))
          Else PutLine(LStr('OFF','fermer'));
 End
  else
 Begin
  Str := StrUpper(Ext);
  If(Str = 'ON')Then Echo := True Else
  If(Str = 'OFF')Then Echo := False Else
  If Not(Ext = '.')Then PutLine(Ext);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MDOS.PutFree                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutFree;
Var Drive : Char;
Begin
 Drive := GetDrive;
 PutLine('');
 PutLine(LStr('Volume in drive '+Drive+' is ',
              'Le volume de l''unit‚ ' + Drive + ' est ')+
         GetVolume(CharToDriveDOS(Drive)));
 PutLine('');
 PutLine(StrgTo(DiskSize(CharToDriveDOS(Drive)),10)+' '+
         LStr('byte(s) total','octet(s) en tous'));
 PutLine(StrgTo(DiskFree(CharToDriveDOS(Drive)),10)+' '+
         LStr('byte(s) free','octet(s) de libre'));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MDOS.PutMemory                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutMemory;
Begin
 PutLine(LStr('Memory Status','Status m‚moire'));
 PutLine('');
 PutLine(StrgTo(LongInt(MemW[$0040:$13])*1024,8) + ' ' +
         LStr('byte(s) total in conventionel',
  	      'octet(s) en tous dans la m‚moire conventionnel'));
 PutLine(StrgTo(MemAvail,8)+' '+
         LStr('byte(s) free in conventionel',
	      'octet(s) de libre en m‚moire conventionnel'));
 PutLine(StrgTo(MaxAvail,8)+' '+
         LStr('byte(s) max largest contiguous free block in heap',
	      'octet(s) de m‚moire continue pour le DOS'));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MDOS.PutCurrentDisk               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutCurrentDisk;
Begin
 PutLine(LStr('The current drive is ',
              'Le disque courant est ') + ' ' + OS.GetDrive);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                    MDOS.PutCurrentPath               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutCurrentPath;
Begin
 PutLine(OS.GetPath);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MDOS.PutDir                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutDir;
Var Descr       : SearchRec;
    TStr,DirCMD : String;
    Pause,Bar   : Boolean;
    Line,Max,I  : Byte;
    K           : Word;
    NumFiles    : LongInt;
    Path        : PathStr;
Begin
 Path := FileExpand('*.*');
 Max := GetMaxLine;
 DirCMD := GetEnv('DIRCMD');
 Pause := (Pos('/P',DirCMD) > 0);
 If(MaxExtractExt > 0)Then
 Begin
  For I := 1 to MaxExtractExt do
  Begin
   TStr := StrUpper(ExtractExt(I,Bar));
   If(Bar)Then
   Begin
    If(TStr = 'P')or(TStr = 'PAUSE')Then Pause := True else
    If(TStr = 'NP')Then Pause := False
     Else
    Begin
     PutLine(LStr('A don''t known parameters ',
                  'Je ne connais pas le paramŠtre ')+TStr);
     Exit;
    End;
   End
    Else
   Begin
    Path := TStr;
    Path := FileExpand(SelectAllIfNotExt(SetPathForAddFile(Path)));
   End;
  End;
 End;
 Line := 5;
 PutLine('');
 PutLine(LStr('Volume in drive '+Path[1]+' is ',
              'Le volume de l''unit‚ ' + Path[1] + ' est ')+
         GetVolume(Byte(Path[1])-64));
 PutLine(LStr('Directory ','R‚pertoire ')+Path);
 PutLine('');
 FindFirst(Path,$FFFF-VolumeID,Descr);
 While (DOSError = 0) do
 Begin
  Inc(NumFiles);
  If((Descr.Attr and Directory) = Directory)Then
   Descr.Name := BoostStrSpc(Descr.Name,12)
  Else
   Descr.Name := BoostStrSpc(SetFullName(Descr.Name),12);
  PutStr(Descr.Name);
  If((Descr.Attr and Directory) = Directory)Then
  Begin
   If(Descr.Name[1] = '.')Then PutStr(LStr('<MAN-DIR> ','<R‚p-pare>'))
                          Else PutStr(LStr('<SUB-DIR> ','<Sous-R‚p>'));
  End
   Else
  PutStr(StrgTo(Descr.Size,10));
  PutLine('  '+StringTime(Descr.Time)+'  '+'('+Strg(NumFiles)+')');
  FindNext(Descr);
  If(Pause)Then
  Begin
   Inc(Line);
   If(Line = (Max-1))Then { Page complete ? }
   Begin
    PutLine(LStr('ESC to cancel or press other key to continue...',
                 'ESC pour annuler ou presse une autre touche pour continuer...'));
    K := UserAction;
    If Not(K = kbEsc)Then Clear Else Exit;
    Line := 0;
   End;
  End;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MDOS.PutLine                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutLine(Str:String);
Begin
 PutStr(Str+#13+#10);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MDOS.PutPath                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutPath;
Begin
 PutLine(MDOS.GetPath);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MDOS.PutSet                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutSet;
Var I : Word;
Begin
 For I := 1 to EnvCount do PutLine(EnvStr(I));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MDOS.PutStr                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutStr(Str:String);
Label _JL;
Var I : Byte;
Begin
 For I := 1 to Length(Str) do
 Begin
  If(Str[I] = #13)and(Str[I+1] = #10)Then
  Begin
   Inc(I);
   Goto _JL;
  End;
  PutCube(Str[I],Colors.Normal);
  Inc(XP);
  If(XP > (_X2-(_X1+2)))Then
  Begin
_JL:
   XP := 0;
   Inc(YP);
   If(YP > (_Y2-(_Y1+2)))Then
   Begin
    YP := (_Y2-(_Y1+2));
    MoveUp(_X1+1,_Y1+1,_X2-1,_Y2-1);
    ClearEOF;
   End;
  End;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MDOS.PutVer                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutVer;
Begin
 PutLine(GetVer);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MDOS.GetVol                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.PutVol;
Begin
 PutLine(GetVolume(GetDriveNumeric));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MDOS.GetMaxLine                  ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function MDOS.GetMaxLine:Byte;
Begin
 GetMaxLine := (_Y2-(_Y1+2));
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MDOS.GetPath                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function MDOS.GetPath:PathStr;
Var Path : PathStr;
Begin
 Path := GetEnv('PATH');
 If(Path = '')Then Path := LStr('PATH is empty!','Le "PATH" est vide!');
 GetPath := Path;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MDOS.GetVer                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function MDOS.GetVer:String;
Begin
 GetVer := 'MS-DOS Version '+Strg(Lo(DOSVersion))+'.'+
           Strg(Hi(DOSVersion))+', Malte-DOS Version 2.01';
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MDOS.Extract                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function MDOS.Extract(CmpMsg:String):Boolean;
Var RtnValue : Boolean;
Begin
 RtnValue := CmpLeft(Param,CmpMsg);
 If(Length(Param) > Length(CmpMsg))and
   (IsLetterRegular(Param[Length(CmpMsg)+1]))Then RtnValue := False;
 If(RtnValue)Then
 Begin
  If(Length(CmpMsg) = Length(Param))Then Ext := ''
   Else
  Begin
   Ext := DelAllSpcLeft(Copy(Param,Length(CmpMsg)+1,255));
  End;
 End;
 Extract := RtnValue;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MDOS.ExtractExt                 ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function MDOS.ExtractExt(P:Byte;Var Bar:Boolean):String;
Var I,N,E   : Byte;
    Str,_Ex : String;
Begin
 If(Ext = '')Then
 Begin
  Bar := False;
  ExtractExt := '';
  Exit;
 End;
 N := 1; I := 2;
 _Ex := DelAllSpcLeft(Ext);
 If(_Ex = '')Then
 Begin
  ExtractExt := '';
  Exit;
 End;
 If((Length(_Ex) = 1)and(P = 1))Then
 Begin
  ExtractExt := _Ex;
  Exit;
 End;
 Bar := False;
 While ((Not(_Ex[I] in ['/','_','-',' ']))and(I < Length(_Ex))) do Inc(I);
 If(P = N)Then
 Begin
  Str := DelAllSpcRight(DelAllSpcLeft(Copy(_Ex,1,I)));
  If(Length(Str) > 0)Then
  Begin
   If(Str[1] in ['/','-','_'])Then
   Begin
    Bar := True;
    If(Length(Str) = 1)Then Str := ''
                       Else Str := Copy(Str,2,Length(Str)-1);
   End;
  End;
  ExtractExt := Str;
  Exit;
 End
  Else
 Inc(N);
 While (I < Byte(_Ex[0])) do
 Begin
  Bar := (_Ex[I] in ['/','-','_']);
  If(_Ex[I] = ' ')or(Bar)Then
  Begin
   If(_Ex[I+1] in ['/','-','_'])Then
   Begin
    Bar := True;
    _Ex := DeleteStr(_Ex,I+1,1);
   End;
   Inc(I);
   E := I;
   While (Not(_Ex[E] in [' ','/','-','_'])and(Length(_Ex) > E)) do Inc(E);
   If(N = P)Then
   Begin
    ExtractExt := DelAllSpcRight(Copy(_Ex,I,E-I+1));
    Exit;
   End
    Else
   Inc(N);
   I := E;
  End;
  Inc(I);
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                     MDOS.MaxExtractExt               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function MDOS.MaxExtractExt:Byte;
Var I,N,E : Byte;
    _Ex   : String;
Begin
 _Ex := Ext;
 If(_Ex = '')Then
 Begin
  MaxExtractExt := 0;
  Exit;
 End;
 N := 0; I := 2;
 While ((Not(_Ex[I] in ['/','_','-',' ']))and(I < Length(_Ex))) do Inc(I);
 Inc(N);
 While (I < Byte(_Ex[0])) do
 Begin
  If(_Ex[I] in [' ','/','-','_'])Then
  Begin
   If(_Ex[I+1] in ['/','-','_'])Then _Ex := DeleteStr(_Ex,I+1,1);
   Inc(I);
   E := I;
   While (Not(_Ex[E] in [' ','/','-','_'])and(Length(_Ex) > E)) do Inc(E);
   I := E;
   Inc(N);
  End;
  Inc(I);
 End;
 MaxExtractExt := N;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        MDOS.Run                      ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Function MDOS.Run:Word;
Var K,Err : Word;
Begin
 Repeat
  If(Echo)Then PutStr(GetPrompt);
  Param := '';
  K := Input(Param);
  If Not(K = kbEnter)Then
  Begin
   Run := K;
   Exit;
  End;
  PutLine('');
  Param := StrUpper(Param);
  If(Param = ':')Then PutCurrentDisk Else
  If(Extract('CD'))or(Extract('CHDIR'))Then RunChDir Else
  If(Param = 'CLS')Then Clear Else
  If(Param = 'COMSPEC')Then PutComspec Else
  If(Extract('DIR'))Then PutDir Else
  If(Extract('COPY'))Then RunCopy Else
  If(Extract('DATE'))Then Else
  If(Extract('DEL'))or(Extract('ERASE'))Then RunDel Else
  If(Extract('ECHO'))Then PutEcho Else
  If(Extract('EXIT'))Then
  Begin
   Run := kbEsc;
   Exit;
  End
   Else
  If(Extract('FREE'))Then PutFree Else
  If(Extract('MD'))or(Extract('MKDIR'))Then RunMkDir Else
  If(Extract('MEMORY'))Then PutMemory Else
  If(Param = 'PATH')Then PutPath Else
  If(Extract('RD'))or(Extract('RMDIR'))Then RunRMDir Else
  If(Param = 'SET')Then PutSet Else
  If(Extract('TIME'))Then Else
  If(Param = 'VER')Then PutVer Else
  If(Extract('VOL'))Then PutVol Else
  If(Extract('XCOPY'))Then
   Else
  Begin
   Case LvlCategory of
    CatNormal : Begin
                 {$M 16384, 0, 0 }
                 Exec(GetEnv('COMSPEC'),'/C'+Param);
                 {$M 16384, 65536, 655360 }
                 Err := DOSError;
                 Case Err of
                   2 : PutLine(LStr('Unknown command!',
		                    'Je ne connais pas cette commande!'));
                   8 : PutLine(LStr('Not enought memory!',
		                    'Je n''ai pas assez de m‚moire!'));
                  Else PutLine(LStr('DOS Error #' + Strg(Err),
		                    'Erreur DOS #'+ Strg(Err)));
                 End;
                End;
           Else Begin
 	         PutLine(LStr('Warning : Unknown command!',
	                      'Attenton : Je ne connais pas cette commande!'));
                 {$M 16384, 0, 0 }
                 Exec(GetEnv('COMSPEC'),'/C'+Param);
                 {$M 16384, 65536, 655360 }
                 Err := DOSError;
                 Case DOSError of
                   2 : PutLine(LStr('Error : Unknown command!',
		                    'Erreur : Je ne connais pas cette commande!'));
                   8 : PutLine(LStr('Error : Not enought memory!',
		                    'Erreur : Je n''ai pas assez de m‚moire!'));
                  Else PutLine(LStr('Critical Error : DOS Error #' + Strg(Err),
		                    'Erreur critique : Erreur DOS #'+ Strg(Err)));
                 End;
                End;
   End;
  End;
  PutLine('');
 Until (True = False);
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MDOS.RunChDir                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.RunChDir;
Var M : Byte;
Begin
 M := MaxExtractExt;
 If(M > 0)Then
 Begin
  If(M > 1)Then
  Begin
   Case LvlCategory of
    CatNormal : PutLine(LStr('Too many parameters!','Trop de paramŠtre'));
           Else PutLine(LStr('Error : Too many parameters!',
	                     'Erreur : Trop de paramŠtre!'));
   End;
   PutLine('');
   PutLine(LStr('CHDIR|CD [directory]','CHDIR|CD [r‚pertoire]'));
  End
   Else
  Begin
   System.ChDir(Ext);
  End;
 End
  Else
 PutCurrentPath;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MDOS.RunMkDir                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.RunMkDir;
Var M : Byte;
Begin
 M := MaxExtractExt;
 If(M > 0)Then
 Begin
  If(M > 1)Then
  Begin
   Case LvlCategory of
    CatNormal : PutLine(LStr('Too many parameters!','Trop de paramŠtre'));
           Else PutLine(LStr('Error : Too many parameters!',
	                     'Erreur : Trop de paramŠtre!'));
   End;
   PutLine('');
   PutLine(LStr('MD|MKDIR directory','MD|MKDIR r‚pertoire'));
  End
   Else
  Begin
   System.MkDir(Ext);
  End;
 End Else
 Begin
  Case LvlCategory of
   CatNormal : Begin
                PutLine(LStr('Parameter missing!','ParamŠtre requis!'));
                PutLine('');
                PutLine(LStr('MD|MKDIR directory','MD|MKDIR r‚pertoire'));
               End;
          Else Begin
	        PutLine(LStr('Error : Parameter requert create directory!',
	                     'Erreur : ParamŠtre requis pour cr‚er le r‚pertoire!'));
                PutLine('');
                PutLine(LStr('MD|MKDIR directory','MD|MKDIR r‚pertoire'));
               End;
  End;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      MDOS.RunRMDir                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.RunRMDir;
Var M : Byte;
Begin
 M := MaxExtractExt;
 If(M > 0)Then
 Begin
  If(M > 1)Then
  Begin
   Case LvlCategory of
    CatNormal : PutLine(LStr('Too many parameters!','Trop de paramŠtre'));
           Else PutLine(LStr('Error : Too many parameters!',
	                     'Erreur : Trop de paramŠtre!'));
   End;
   PutLine('');
   PutLine(LStr('RD|RMDIR directory','RD|RMDIR r‚pertoire'));
  End
   Else
  Begin
   System.RMDir(Ext);
  End;
 End Else
 Begin
  Case LvlCategory of
   CatNormal : Begin
                PutLine(LStr('Parameter missing!','ParamŠtre requis!'));
                PutLine('');
                PutLine(LStr('RD|RMDIR directory','RD|RMDIR r‚pertoire'));
               End;
          Else Begin
	        PutLine(LStr('Error : Parameter requert destroy directory!',
	                     'Erreur : ParamŠtre requis pour d‚truire le r‚pertoire!'));
                PutLine('');
                PutLine(LStr('RD|RMDIR directory','RD|RMDIR r‚pertoire'));
               End;
  End;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                       MDOS.RunCopy                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.RunCopy;
Var Source,Target : PathStr;
    I,NP          : Byte;
    Bar           : Boolean;
    TStr          : String;
    K             : Word;

 Procedure CommandMonoCopy(Source,Target:PathStr);
 Var HSource,HTarget,NM : Word;
     Size,I,ND          : LongInt;
     Buffer             : Array[0..1023] of Byte;
 Begin
  HSource := Open(Source,ReadOnly);
  If(IsHandleError(HSource))Then Exit;
  Size := FileSize(HSource);
  HTarget := New(Target);
  If(IsHandleError(HTarget))Then Exit;
  ND := Size div SizeOf(Buffer);
  NM := Size mod SizeOf(Buffer);
  For I := 0 to (ND - 1) do
  Begin
   GetRecord(HSource,I,SizeOf(Buffer),Buffer);
   SetRecord(HTarget,I,SizeOf(Buffer),Buffer);
  End;
  If(NM > 0)Then
  Begin
   SetFilePos(HSource,ND*SizeOf(Buffer));
   _GetRecord(HSource,NM,Buffer);
   SetFilePos(HTarget,ND*SizeOf(Buffer));
   _SetRecord(HTarget,NM,Buffer);
  End;
  Close(HTarget);
  Close(HSource);
 End;

 Procedure CommandCopy(Source,Target:PathStr);
 Var Rec             : SearchRec;
     TSource,TTarget : PathStr;
 Begin
  If(IsWildCard(Source))Then
  Begin
   FindFirst(Source,$FFFF-VolumeID-Directory,Rec);
   While (DOSError = 0) do
   Begin
    TSource := PathToDir(Source)+Rec.Name;
    TTarget := CompleteTargetName(TSource,Target);
    Case LvlCategory of
     CatNormal : PutLine(TSource + ' to ' + TTarget);
            Else PutLine(TSource + ' -> ' + TTarget);
    End;
    CommandMonoCopy(TSource,TTarget);
    FindNext(Rec);
   End;
  End
   Else
  Begin
   If(IsWildCard(Target))Then Target := CompleteTargetName(Rec.Name,Target);
   Case LvlCategory of
    CatNormal : PutLine(Source + ' to ' + Target);
           Else PutLine(Source + ' -> ' + Target);
   End;
   CommandMonoCopy(Source,Target);
  End;
 End;

Begin
 If(MaxExtractExt > 0)Then
 Begin
  NP := 0;
  For I := 1 to MaxExtractExt do
  Begin
   TStr := ExtractExt(I,Bar);
   If(Bar)Then
   Begin
    Case LvlCategory of
     CatNormal : Begin
                  PutLine(LStr('Unknown parameter!',
		               'ParamŠtre inconnue!'));
                  Exit;
                 End;
            Else Begin
	          PutLine(LStr('Warning : Unknown parameter '+TStr+'!',
	                       'Warning : Je ne connais pas le paramŠtre '+TStr+'!'));
                  PutLine('');
                  PutLine(LStr('Continue anyway (Y/N) ? ',
		               'Continue quand mˆme (O/N) ?'));
                  K := UserAction;
                  If(K = kbEsc)or(CharUpper(Char(Lo(K))) = 'N')Then Exit;
                 End;
    End;
   End
    Else
   Begin
    Case NP of
      0 : Source := TStr;
      1 : Target := TStr;
     Else Begin
           Case LvlCategory of
            CatNormal : Begin
                         PutLine(LStr('Too many path!','Trop de r‚pertoire!'));
                        End;
                   Else Begin
                         PutLine(LStr('Error : Too many path!',
			              'Erreur : Trop de r‚pertoire sp‚cifi‚!'));
                        End;
           End;
           Exit;
          End;
    End;
    Inc(NP);
   End;
  End;
  CommandCopy(Source,Target);
 End
  Else
 Begin
  Case LvlCategory of
   CatNormal : Begin
                PutLine(LStr('Parameter missing!','ParamŠtre requis!'));
                PutLine('');
                PutLine(LStr('COPY Source [Target]','COPY Source [Destination]'));
               End;
          Else Begin
	        PutLine(LStr('Error : Parameter requert to start copying!',
	                     'Erreur : ParamŠtre requis pour commencer le copiage!'));
                PutLine('');
                PutLine(LStr('COPY Source [Target]','COPY Source [Destination]'));
               End;
  End;
 End;
End;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        MDOS.RunDel                   ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure MDOS.RunDel;
Var I,M  : Byte;
    Bar  : Boolean;
    TStr : String;

 Procedure CommandDel(Path:PathStr);
 Var Rec   : SearchRec;
     TPath : PathStr;
 Begin
  Path := SelectAllIfNotExt(Path);
  If(IsWildCard(Path))Then
  Begin
   FindFirst(Path,$FFFF-VolumeID-Directory,Rec);
   While (DOSError = 0) do
   Begin
    TPath := PathToDir(Path)+Rec.Name;
    Case LvlCategory of
     CatNormal : PutLine('Delete '+TPath);
            Else PutLine('Del ' + TPath);
    End;
    Del(TPath);
    FindNext(Rec);
   End;
  End
   Else
  Begin
   Case LvlCategory of
    CatNormal : PutLine('Delete ' + Path);
           Else PutLine('Del ' + Path);
   End;
   Del(Path);
  End;
 End;

Begin
 M := MaxExtractExt;
 If(M > 0)Then
 Begin
  For I := 1 to M do
  Begin
   TStr := ExtractExt(I,Bar);
   If(Bar)Then CommandDel(TStr);
  End;
 End
  Else
 Begin
  Case LvlCategory of
   CatNormal : Begin
                PutLine(LStr('Parameter missing!','ParamŠtre requis!'));
                PutLine('');
                PutLine(LStr('DEL|ERASE file(s) [file(s)] [...]',
		             'DEL|ERASE fichier(s) [fichier(s)] [...]'));
               End;
          Else Begin
	        PutLine(LStr('Error : Parameter requert for delete files!',
	                     'Erreur : ParamŠtre requis pour effacer les fichiers!'));
                PutLine('');
                PutLine(LStr('DEL|ERASE file(s) [file(s)] [...]',
		             'DEL|ERASE fichier(s) [fichier(s)] [...]'));
               End;
  End;
 End;
End;

BEGIN { Main Unit }
END.
