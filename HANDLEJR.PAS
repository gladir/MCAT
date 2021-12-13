(********************************************************)
(*                                                      *)
(*     Malte System/Handle Junior (Special Video)       *)
(*                     1993/01/06                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit HandleJr;

(********************************************************)
                        INTERFACE
(********************************************************)

Procedure InitHandleJr;
Procedure DoneHandleJr;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Const

      L = 50;
      H = 6;

Var Buffer      : Pointer;
    Size        : Word;
    X1,Y1,X2,Y2 : Byte;

Procedure WinHandleError(Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP:Word); Far;
Interrupt;
Label _RESET;
Var Window : WindowType;
    Image  : BoxImage;
    R      : Byte;

 Function CriticalErrorDOSMsg(Error:Word):String;
 Begin
  Case Language of
   lgEnglish : Case Error of
                 0 : CriticalErrorDOSMsg := 'Disk protected';
                 1 : CriticalErrorDOSMsg := 'Unknown handle access';
                 2 : CriticalErrorDOSMsg := 'Disk not ready';
                 3 : CriticalErrorDOSMsg := 'Unknown code';
                 4 : CriticalErrorDOSMsg := 'CRC Error';
                 5 : CriticalErrorDOSMsg := 'Data length invalid';
                 6 : CriticalErrorDOSMsg := 'Track not found';
                 7 : CriticalErrorDOSMsg := 'Unkown handle type';
                 8 : CriticalErrorDOSMsg := 'Sector not found';
                 9 : CriticalErrorDOSMsg := 'Out of paper';
                10 : CriticalErrorDOSMsg := 'Write error';
                11 : CriticalErrorDOSMsg := 'Read error';
                12 : CriticalErrorDOSMsg := 'General error (CPU)';
               End;
          else Case Error of
                 0 : CriticalErrorDOSMsg := 'Disquette prot‚ger';
                 1 : CriticalErrorDOSMsg := 'Unit‚ inconnue';
                 2 : CriticalErrorDOSMsg := 'Disque pas prˆte';
                 3 : CriticalErrorDOSMsg := 'Commande inconnue';
                 4 : CriticalErrorDOSMsg := 'Erreur de CRC';
                 5 : CriticalErrorDOSMsg := 'Longeur incorrect';
                 6 : CriticalErrorDOSMsg := 'Erreur de piste';
                 7 : CriticalErrorDOSMsg := 'Type de m‚dia inconnu';
                 8 : CriticalErrorDOSMsg := 'Secteur introuvable';
                 9 : CriticalErrorDOSMsg := 'Plus de papier';
                10 : CriticalErrorDOSMsg := 'Erreur d''‚criture';
                11 : CriticalErrorDOSMsg := 'Erreur de lecture';
                12 : CriticalErrorDOSMsg := 'Erreur g‚n‚rale';
               End;
  End;
 End;

Begin
 If(Image.GetBox(X1,Y1,X2+2,Y2+2))Then
 Begin
  Window.InitError;
  Window.NoZoom;
  Case Language of
   lgEnglish : Window.PutWindow(X1,Y1,X2,Y2,'Critical Error');
          else Window.PutWindow(X1,Y1,X2,Y2,'Erreur Critique');
  End;
  Window.Done;
  WriteText(X1+2,Y1+2,CriticalErrorDOSMsg(Error),Color.Window.Error.Msg);
_RESET:
  Case Language of
   lgEnglish : R := KeyHori(X1+7,Y2-2,20,'Abort|Retry');
          Else R := KeyHori(X1+7,Y2-2,20,'Abandonne|Reprise');
  End;
  If(R = 253)Then
  Begin
   { Help }
   Goto _RESET;
  End;
  If(R = 254)Then Goto _RESET;
  If(R = 255)Then R := 0;
  WinExecError := R;
 End
  else
 Begin
  Beep;
  WinExecError := 255;
 End;
 Image.Restore;
End;

Procedure InitHandleJr;
Begin
 X1 := (GetMaxX-(L+4)) shr 1; X2 := X1 + (L+3);
 Y1 := (GetMaxY-H) shr 1; Y2 := Y1 + H;
 Buffer := NIL;
 Size := ();
End;

Procedure DoneHandleJr;
Begin
 Buffer := NIL;
End;

BEGIN { Main Unit }
END.