(********************************************************)
(*                                                      *)
(*              Malte System/Gadget Path                *)
(*                    1993/05/17                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Directive de compilation conditionnel :

   DPMI                  Indique qu'il tourne sous DPMI.
   OS2                   Indique que l'environnement de travaille est OS/2.
   QUICKPASCAL           Indique qu'il s'agit du compilateur QuickPascal.
   VER10                 Indique qu'il s'agit soit du QuickPascal 1.0 ou
                         du Turbo Pascal for Windows 1.0 (Pr‚d‚finit).
   VER15                 Indique qu'il s'agit du Turbo Pascal for
                         Windows 1.5 (Pr‚d‚finit).
   VER60                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 6 (Pr‚d‚finit); si vous d‚finisez cette
                         directive, il faut ˆtre vraiment sur que ce
                         compilateur est compatible … 100%.
   VER70                 Indique qu'il s'agit du compilateur de Turbo
                         Pascal 7 (Pr‚d‚finit); si vous d‚finisez cette
                         directive, il faut ˆtre vraiment sur que ce
                         compilateur est compatible … 100%.
   WINDOWS               Indique que l'environnement de travaille est Windows
   __386__               Indique qu'il faut compiler les instructions pour un
                         processeur 80386 ou post‚rieur.
   __ASSEMBLERSUPPORT__  Indique que le compilateur support l'assembler.
                         (Pr‚d‚finit en fonction des autres variables).
   __EXTERNAL__          Indique qu'il faut faire appelle … la
                         bibliotŠque externe. Comme par exemple, si vous
                         d‚finis‚ des proc‚dures en Turbo C++, vous devrez
                         faire appelle a cette directive de compilation.
   __OPTIMIZESIZE__      Indique qu'il faut faire en sorte que le code
                         langage machine prenne le moin de place possible.
   __STRPTRSUPPORT__     Indique que le compilateur support des variables
                         de caractŠre du mˆme genre que le langage C.
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
 {$X+}
{$ENDIF}

Unit GadgetPath;

(********************************************************)
                        INTERFACE
(********************************************************)

{$IFDEF __STRPTRSUPPORT__}

 Uses Strings;

 Type

      GadgetPathRecord = Record
                          Msg:PChar;
                          DefaultPath:PChar;
                          NewPath:Array[0..80] of Char;
                         End;

      TGadgetPath      = Array[0..$FF0F div SizeOf(GadgetPathRecord)] of
                          GadgetPathRecord;

      PGadgetPathPtr   = ^TGadgetPath;

 Function GetPath(Title:PChar;Path:PGadgetPathPtr):Word;

{$ENDIF}

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses Numeric,LanDStr,Level,Text,Windows,LanWins;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                        GetPath                       ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

{$IFDEF __STRPTRSUPPORT__}

 Function GetPath(Title:PChar;Path:PGadgetPathPtr):Word;
 Var K,I,MP,ML,TL       : Word;
     L,H,Plane          : Byte;
     DoubleInterLine,Ok : Boolean;
     W                  : LWins;
     Str                : String;
 Begin
  I := 0; ML := 0; Plane := 0;
  While Not(Path^[I].Msg = NIL) do
  Begin
   TL := StrLen(Path^[I].Msg);
   If(TL > ML)Then ML := TL;
   Inc(I);
  End;
  MP := I;
  If(MP > Text.GetMaxY)Then { Screen support ? }
  Begin
   K := LInitError('Sorry! Structure too length for this screen!',
                   'D‚sol‚! Structure trop large pour cette ‚cran!',KeyOk);
   Exit;
  End;
  DoubleInterLine := (((MP shl 1) + 4) < Text.GetMaxY);
  H := ((Byte(DoubleInterLine)+1) * MP) + 4;
  L := TL + 40;
  W.InitCenter(L,H,StrPas(Title),Level.Color.Window.Regular);
  W.Ln;
  For I := 0 to (MP - 1) do
  Begin
   SetColor(W.Colors.Normal);
   W.PutTextXY(0,1+(I * (Byte(DoubleInterLine) + 1)),
               StrPas(Path^[I].Msg));
   SetColor(W.Colors.Msg);
   W.PutTextXY(ML+1,1+(I * (Byte(DoubleInterLine) + 1)),
	       StrPas(Path^[I].NewPath));
   W.Ln;
   If(DoubleInterLine)Then W.Ln;
  End;
  W.LPutKeyHoriDown('Ok|Default|Cancel','Correcte|D‚faut|Annule');
  I := 0;
  Repeat
   Ok := False;
   Case Plane of
    0 : Begin
         Str := StrPas(Path^[I].NewPath);
         K := W.InputXY(ML+1,1+(I * (Byte(DoubleInterLine) + 1)),Str);
         If Not(K = kbEsc)Then
	 Begin
          StrPCopy(Path^[I].NewPath,Str);
         End;
        End;
    1 : K := W.LGetKeyHoriDown('Ok|Default|Cancel','Correcte|D‚faut|Annule');
   End;
   Case K of
      kbUp : I := MinByte(I,MP-1);
    kbDown : I := MaxByte(I,MP-1);
     kbTab : Plane := ((Plane + 1) and 1);
        Else Begin
              If(Boolean(Plane))Then
              Begin
               Case K of
                0 : Begin
		     K := kbEnter;
                     Ok := True;
                    End;
                1 : Begin
                     For I := 0 to (MP - 1) do
                     Begin
                      StrCopy(Path^[I].NewPath,Path^[I].DefaultPath);
                      W.PutTextXY(ML+1,1+(I * (Byte(DoubleInterLine) + 1)),
		                  StrPas(Path^[I].NewPath));
                     End;
                    End;
                2 : Begin
		     K := kbEsc;
                     Ok := True;
                    End;
               End;
              End
               else
	      Ok := True;
             End;
   End;
  Until Ok;
  Case K of
   kbEsc : Begin
            For I := 0 to (MP - 1) do
            Begin
             StrCopy(Path^[I].NewPath,Path^[I].DefaultPath);
            End;
           End;
  End;
  W.Done;
 End;

{$ENDIF}

BEGIN { Main Unit }
END.