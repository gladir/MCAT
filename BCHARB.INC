(********************************************************
 * Nom du fichier : BCHARB.INC                          *
 *                                                      *
 * Fonction                                             *
 *   PutCharBackground - BGI                            *
 *   PutCharBackgroundLuxe - BGI                        *
 ********************************************************)

(*
 *
 *   Malte System/Pascal
 *
 *   Copyright (C) par les Chevaliers de Malte
 *   1993-01-31
 *
 *
 *)

(*------------------------------------------------------*

  Nom                PutCharBackground - BGI

  Usage              Procedure PutCharBackground(X,Y:Word;
                               Chr:Char;Color:Byte);

  Prototype dans     BGI_TEXT.PAS

  Description        Ecrit que le fond du caractŠre sans
                     effacer le caractŠre lui-mˆme a
                     partir de la matrix courant.

  Retourne           Rien

  Note               Cette fonction requŠre l'unit‚ Graph
                     (BGI).

 *------------------------------------------------------*)

Procedure PutCharBackground(X,Y:Word;Chr:Char;Color:Byte);
Var I,J : Byte;
    B   : Word;
Begin
 B := OfsMat + (Byte(Chr) * TXT_HEIGHT);
 If(TXT_HEIGHT > 8)and(Chr in [#32..#175])Then
 Begin
  For J := 1 to (TXT_HEIGHT-2) do
  Begin
   For I := 0 to 7 do
   Begin
    If(((Mem[SegMat:B+J] shr I) and 1) = 0)Then
     PutPixel(X+7-I,Y+J,Color);
   End;
  End;
 End
  Else
 Begin
  For J := 0 to (TXT_HEIGHT-1) do
   Begin
   For I := 0 to 7 do
   Begin
    If(((Mem[SegMat:B+J] shr I) and 1) = 0)Then
     PutPixel(X+7-I,Y+J,Color);
   End;
  End;
 End;
End;

(*------------------------------------------------------*

  Nom                PutCharBackgroundLuxe - BGI

  Usage              Procedure PutCharBackgroundLuxe
                               (X,Y:Word;Chr:Char;
                               Color:Byte);

  Prototype dans     BGI_TEXT.PAS

  Description        Ecrit que le fond du caractŠre sans
                     effacer le caractŠre lui-mˆme a
                     partir de la matrix luxe courant.

  Retourne           Rien

  Note               Cette fonction requŠre l'unit‚ Graph
                     (BGI).

 *------------------------------------------------------*)

Procedure PutCharBackgroundLuxe(X,Y:Word;Chr:Char;Color:Byte);
Var I,J : Byte;
    B   : Word;
Begin
 B := OfsMatLuxe + (Byte(Chr) * TXT_HEIGHT);
 If(TXT_HEIGHT > 8)and(Chr in [#32..#175])Then
 Begin
  For J := 1 to (TXT_HEIGHT-2) do
  Begin
   For I := 0 to 7 do
   Begin
    If(((Mem[SegMatLuxe:B+J] shr I) and 1) = 0)Then
     PutPixel(X+7-I,Y+J,Color);
   End;
  End;
 End
  Else
 Begin
  For J := 0 to (TXT_HEIGHT-1) do
  Begin
   For I := 0 to 7 do
   Begin
    If(((Mem[SegMatLuxe:B+J] shr I) and 1) = 0)Then
     PutPixel(X+7-I,Y+J,Color);
   End;
  End;
 End;
End;