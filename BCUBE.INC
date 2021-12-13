(********************************************************
 * Nom du fichier : BCUBE.INC                           *
 *                                                      *
 * Fonction                                             *
 *   PutCube - BGI                                      *
 *   PutCubeLuxe - BGI                                  *
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

  Nom                PutCube - BGI

  Usage              Procedure PutCube(X,Y:Word;
                               Chr:Char;Back,Fore:Byte);

  Prototype dans     BGI_TEXT.PAS

  Description        Ecrit un caractŠre partir de la
                     matrix courant.

  Retourne           Rien

  Note               Cette fonction requŠre l'unit‚ Graph
                     (BGI).

 *------------------------------------------------------*)

Procedure PutCube(X,Y:Word;Chr:Char;Back,Fore:Byte);
Var I,J,T : Byte;
    B     : Word;
Begin
 B := OfsMat + (Word(Byte(Chr)) * Word(TXT_HEIGHT));
 If(TXT_Height > 8)and(Chr in [#32..#175])Then
 Begin
  For J := 1 to (TXT_HEIGHT-2) do
  Begin
   T := Mem[SegMat:B+Word(J)];
   If(T = 0)Then
   Begin
    Graph.SetColor(Back);
    Graph.Line(X,Y+Word(J),X+7,Y+Word(J));
   End
    else
   If(T = 255)Then
   Begin
    Graph.SetColor(Fore);
    Graph.Line(X,Y+Word(J),X+7,Y+Word(J));
   End
    else
   For I := 0 to 7 do
   Begin
    If(((T shr I) and 1) = 1)Then Graph.PutPixel(X+Word(7-I),Y+Word(J),Fore)
                             Else Graph.PutPixel(X+Word(7-I),Y+Word(J),Back);
   End;
  End;
 End
  else
 Begin
  For J := 0 to (TXT_HEIGHT-1) do
  Begin
   T := Mem[SegMat:B+Word(J)];
   If(T = 0)Then
   Begin
    Graph.SetColor(Back);
    Graph.Line(X,Y+Word(J),X+7,Y+Word(J));
   End
    else
   If(T = 255)Then
   Begin
    Graph.SetColor(Fore);
    Graph.Line(X,Y+Word(J),X+7,Y+Word(J));
   End
    else
   For I := 0 to 7 do
   Begin
    If(((T shr I) and 1) = 1)Then PutPixel(X+Word(7-I),Y+Word(J),Fore)
                             Else PutPixel(X+Word(7-I),Y+Word(J),Back);
   End;
  End;
 End;
End;

(*------------------------------------------------------*

  Nom                PutCubeLuxe - BGI

  Usage              Procedure PutCubeLuxe
                               (X,Y:Word;Chr:Char;
                               Back,Fore:Byte);

  Prototype dans     BGI_TEXT.PAS

  Description        Ecrit que le fond du caractŠre sans
                     effacer le caractŠre lui-mˆme a
                     partir de la matrix luxe courant.

  Retourne           Rien

  Note               Cette fonction requŠre l'unit‚ Graph
                     (BGI).

 *------------------------------------------------------*)

Procedure PutCubeLuxe(X,Y:Word;Chr:Char;Back,Fore:Byte);
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
    If(((Mem[SegMatLuxe:B+J] shr I) and 1) = 1)Then
     PutPixel(X+7-I,Y+J,Fore)
    Else
     PutPixel(X+7-I,Y+J,Back);
   End;
  End;
 End
  Else
 Begin
  For J := 0 to (TXT_HEIGHT-1) do
  Begin
   For I := 0 to 7 do
   Begin
    If(((Mem[SegMatLuxe:B+J] shr I) and 1) = 1)Then
     PutPixel(X+7-I,Y+J,Fore)
    Else
     PutPixel(X+7-I,Y+J,Back);
   End;
  End;
 End;
End;