(********************************************************)
(*                                                      *)
(*                Malte Catalog/Printer                 *)
(*                     1993/02/06                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit MCatPrn;

(********************************************************)
                        INTERFACE
(********************************************************)

Procedure PrintListDiskInfo(Pos:LongInt);
Procedure PrintListIndex;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses DString,StrTime,BIOS_Prn,Prnt,Text,Level,LuxeVid,
     Handle,Sound,LanText,MCatStr,MCatFile,MCatWin,MCatIn,
     LanPrnt;

Procedure PrintListIndex;
Label _START;
Var I,Max  : LongInt;
    Handle : Word;
    Line   : BoxImage;
    Main   : IndexType;
Begin
_START:
 If Not(CheckPrinter)Then
 Begin
  If(LWinRetry('Printer not ready!','Imprimante pas prˆte!'))Then Goto _START
  Else
   Exit;
 End;
 Line.Init;
 If(Line.GetLine(0,GetMaxY,GetMaxX))Then
 Begin
  Max := GetMaxIndex;
  Handle := Open(GetNameIndex,ReadOnly);
  PrintLn('');
  PrintLn(ESC+SI);
  PrintLn('');
  LPrintLn('Volume        Used       Free       Files     Time        Description',
           'Volume        Utilis‚    Libre      Fichier   Temps       Description');
  PrintLn('------------- ---------- ---------- --------- ----------- '
         +'--------------------------------------------------------');
  BarTextHori(2,GetMaxY,GetMaxX-2,' ',Color.EndBar.Normal);
  For I := 0 to Max do
  Begin
   LWriteText(2,GetMaxY,'Print line : '+Strg(I+1),
                        'Imprime ligne : '+Strg(I+1),Color.EndBar.Normal);
   GetRecord(Handle,I,SizeOf(Main),Main);
   PrintLn(Main.Volume+Space(13-Length(Main.Volume))+
           Copy(StrgTo(Main.SizeUsed,9),1,9)+'  ' +
           Copy(StrgTo(Main.SizeFree,9),1,9)+'  ' +
           Copy(StrgTo(Main.NumberFile,8),1,8)+'  ' +
           StringTime(Main.Time) + ' '+
           Main.Description);
  End;
  PrintLn('');
  Close(Handle);
 End
  else
 Beep;
 Line.Restore;
End;

Procedure PrintListDiskInfo(Pos:LongInt);
Label _START;
Var I,Max  : LongInt;
    Handle : Word;
    Line   : BoxImage;
    _File  : DiskInfoType;
Begin
_START:
 If Not(CheckPrinter)Then
 Begin
  If(LWinRetry('Printer not ready!','Imprimante pas prˆte!'))Then Goto _START
  Else
   Exit;
 End;
 Line.Init;
 If(Line.GetLine(0,GetMaxY,GetMaxX))Then
 Begin
  Max := GetMaxDiskInfo(Pos);
  Handle := Open(GetNameDiskInfo(Pos),ReadOnly);
  PrintLn('');
  PrintLn(ESC+SI);
  PrintLn('');
  LPrintLn('Name          Size      Time                Category '+
           '                  Description',
           'Nom           Taille    Temps               Cat‚gorie'+
           '                  Description');
  PrintLn('------------- --------- ------------------- -----------'
          +'--------------- ----------------------------------------');
  BarTextHori(2,GetMaxY,GetMaxX-2,' ',Color.EndBar.Normal);
  For I := 0 to Max do
  Begin
   LWriteText(2,GetMaxY,'Print line : '+Strg(I+1),
              'Imprime ligne : '+Strg(I+1),Color.EndBar.Normal);
   GetRecord(Handle,I,SizeOf(_File),_File);
   PrintLn(_File.Path+Space(13-Length(_File.Path))+
           Copy(StrgTo(_File.Size,9),1,9)+ '  ' +
           StringTime(_File.Time) + ' ' +
           StrCategory(_File.Category) +
           Space(27-Length(StrCategory(_File.Category))) +
           _File.Description);
  End;
  PrintLn('');
  Close(Handle);
 End
  else
 Beep;
 Line.Restore;
End;

BEGIN { Main Unit }
END.