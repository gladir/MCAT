(********************************************************)
(*                                                      *)
(*              Malte System/Numeric Window             *)
(*                     1993/02/02                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

{ Programmeur :

   Sylvain Maltais

  Compatible :

   Malte System

  Nom :

   Les fenˆtres num‚riques (Numeric Window).

  Description :

  þ Ce module rassemblent les fonctions de calcul des
    fenˆtres; les coordonn‚es sont basser sur un ‚cran
    de texte.

  þ Calcul la taille des fenˆtres (… partir de la largeur
    et de la hauteur).

  þ Comme entre autre les icons (Fermeture, Changement
    de taille).

 Notes :

  þ Il suppose que vous travaillez en relation constante
    avec le module vid‚o de luxe (LuxeVid).

  þ Ce module est support‚ par les versions de Turbo
    Pascal 4 ou post‚rieur et aux Quick Pascal de toutes
    versions.
}

Unit NumWin;

(********************************************************)
                      INTERFACE
(********************************************************)

Procedure GetSizeWindowCenter(L,H:Byte;Var X1,Y1,X2,Y2:Byte);

Function IsCloseIcon(X,Y,MX,MY:Byte):Boolean;
Function IsExitIcon(MX,MY:Byte):Boolean;
Function IsZoomIcon(X,Y,MX,MY:Byte):Boolean;

(********************************************************)
                    IMPLEMENTATION
(********************************************************)

Uses Text,LuxeVid; { Texte, Vid‚o de luxe. }

{ Nom :

   Lecture de la taille d'une fenˆtre centr‚e.

  Syntaxe :

   Procedure GetSizeWindowCenter(L,H:Byte;Var X1,Y1,X2,Y2:Byte);

  Description :

   þ Cette fonction retourne la taille d'une fenˆtre
     situ‚ au centre de l'‚cran. Il suffit pour cela
     de sp‚cifier la largeur (L) et la hauteur (H) de
     celui-ci.

  Notes :

   þ Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.

   þ Les variables GetMaxX et GetMaxY repr‚sentent les
     valeurs maximals X et Y de l'‚cran.

   þ Les fonctions shr (shift right) et shl (shift left)
     font un d‚calage des bits dans la direction indiqu‚.
     Les espaces lib‚r‚s sont remplacer par des 0.
}

Procedure GetSizeWindowCenter(L,H:Byte;Var X1,Y1,X2,Y2:Byte);
Begin
 X1 := (GetMaxX-L) shr 1;
 X2 := X1 + L;
 Y1 := ((GetMaxY-H) shr 1) + 1;
 Y2 := Y1 + H;
End;

{ Syntaxe :

   Function IsCloseIcon(X,Y,MX,MY:Byte):Boolean;

  Description :

   þ Cette fonction confirme, si le pointeur (MX,MY) pointe
     sur l'icon de fermeture … la position (X,Y).

  Notes :

   þ Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.

   þ La variable CloseIcon est une chaine de caractŠre qui
     contient le dessin de l'icon.

   þ La fonction length retourne la longeur de la chaine
     de caractŠre.
}

Function IsCloseIcon(X,Y,MX,MY:Byte):Boolean;
Begin
 IsCloseIcon := (((MX >= X)and(MX < X + Length(CloseIcon)))and(MY = Y));
End;

{ Syntaxe :

   Function IsZoomIcon(X,Y,MX,MY:Byte):Boolean;

  Description :

   þ Cette fonction confirme, si le pointeur (MX,MY) pointe
     sur l'icon de changement de taille … la position (X,Y).

  Notes :

   þ Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.

   þ La variable ZoomIcon est une chaine de caractŠre qui
     contient le dessin de l'icon.

   þ La fonction length retourne la longeur de la chaine
     de caractŠre.
}

Function IsZoomIcon(X,Y,MX,MY:Byte):Boolean;
Begin
 IsZoomIcon := (((MX >= X)and(MX < X + Length(ZoomIcon)))and(MY = Y));
End;

{ Syntaxe :

   Function IsExitIcon(MX,MY:Byte):Boolean;

  Description :

   þ Cette fonction confirme si le pointeur (MX,MY) pointe
     sur l'icon de fermeture principal (suppos‚ … la position
     X = 0, Y = 0).

  Notes :

   þ Cette fonction requŠre une version de Turbo Pascal
     3 ou post‚rieur.

   þ La variable CloseIcon est une chaine de caractŠre qui
     contient le dessin de l'icon.

   þ La fonction length retourne la longeur de la chaine
     de caractŠre.
}

Function IsExitIcon(MX,MY:Byte):Boolean;
Begin
 IsExitIcon := (MX < Length(CloseIcon))and(MY = 0);
End;

BEGIN { Main Unit }
END.