Uses Numeric,Level,Text,LuxeVid,Windows,LanWins;

Const

      IOAddress : Array[0..2] of Word =
                  (
                   $0021,
                   $03C2,
                   0
                  );

Procedure WinIO0021h;
Const L = 60; H = 16;
Var W   : LWins;
    K   : Word;
    V,I : Byte;
    S   : String;
Begin
 W.LInitCenter(L,H,'Port I/O 0021h, Interrupt control (8259A)',
                   'Port E/S 0021h, Contr“leur interruption (8259A)',
                   Level.Color.Window.Regular);
 W.Ln;
 V := Port[$0021];
 BinByteChn(V,S);
 W.LPutTypingLn('Value ^'+S+'b^','Valeur ^'+S+'b^');
 W.Ln;
 W.LPutTyping('IRQ0 (Clock) ','IRQ0 (Horloge) ');
 Case (V and 1) of
  0 : W.LPutTypingLn('^Actived^','^Actif^');
  1 : W.LPutTypingLn('^Unactived^','^Inactif^');
 End;
 W.LPutTyping('IRQ1 (Keyboard) ','IRQ1 (Clavier) ');
 Case ((V shr 1) and 1) of
  0 : W.LPutTypingLn('^Actived^','^Actif^');
  1 : W.LPutTypingLn('^Unactived^','^Inactif^');
 End;
 W.LPutTyping('IRQ2 ','IRQ2 ');
 Case ((V shr 2) and 1) of
  0 : W.LPutTypingLn('^Actived^','^Actif^');
  1 : W.LPutTypingLn('^Unactived^','^Inactif^');
 End;
 W.LPutTyping('IRQ3 ','IRQ3 ');
 Case ((V shr 3) and 1) of
  0 : W.LPutTypingLn('^Actived^','^Actif^');
  1 : W.LPutTypingLn('^Unactived^','^Inactif^');
 End;
 W.LPutTyping('IRQ4 ','IRQ4 ');
 Case ((V shr 4) and 1) of
  0 : W.LPutTypingLn('^Actived^','^Actif^');
  1 : W.LPutTypingLn('^Unactived^','^Inactif^');
 End;
 W.LPutTyping('IRQ5 ','IRQ5 ');
 Case ((V shr 5) and 1) of
  0 : W.LPutTypingLn('^Actived^','^Actif^');
  1 : W.LPutTypingLn('^Unactived^','^Inactif^');
 End;
 W.LPutTyping('IRQ6 (Floppy-Disk) ','IRQ6 (Diskette) ');
 Case ((V shr 6) and 1) of
  0 : W.LPutTypingLn('^Actived^','^Actif^');
  1 : W.LPutTypingLn('^Unactived^','^Inactif^');
 End;
 W.LPutTyping('IRQ7 ','IRQ7 ');
 Case ((V shr 7) and 1) of
  0 : W.LPutTypingLn('^Actived^','^Actif^');
  1 : W.LPutTypingLn('^Unactived^','^Inactif^');
 End;
 W.Ln;
 W.LKeyOk;
 W.Done;
End;

Procedure WinIO03C2h;
Const L = 40; H = 9;
Var W : LWins;
    K : Word;
    V : Byte;
    S : String;
Begin
 If Not(IsVGA)Then
 Begin
  If(LInitWarning('VGA adaptor not-found! Continue anyway ?',
                  'Adapteur VGA introuvable! Continue quand mˆme ?',
                  KeyYes+KeyNo) = _No_)Then Exit;
 End;
 W.LInitCenter(L,H,'Port I/O 03C2h (VGA)',
                   'Port E/S 03C2h (VGA)',
                   Level.Color.Window.Regular);
 W.Ln;
 V := Port[$03C2];
 BinByteChn(V,S);
 W.LPutTypingLn('Value ^'+S+'b^','Valeur ^'+S+'b^');
 W.Ln;
 W.LPutTyping('Cursor ','Le curseur est ');
 Case (V and 1) of
  1 : W.LPutTypingLn('^Open^','^Ouvert^');
  0 : W.LPutTypingLn('^Closed^','^Fermer^');
 End;
 W.LPutTyping('Buffer video acces ','AccŠs au tampon vid‚o ');
 Case ((V shr 1) and 1) of
  0 : W.LPutTypingLn('^Autorised^','^Autoris‚^');
  1 : W.LPutTypingLn('^Illegal^','^Refus‚^');
 End;
 W.Ln;
 W.LKeyOk;
 W.Done;
End;

BEGIN
 If(DirectTextDetect)Then VC.Methode := ScrnDirect
                     Else VC.Methode := ScrnBIOS;
 InitVideoDeluxe;
 WinIO0021h;
 DoneVideoDeluxe;
END.