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

   Les fen�tres num�riques (Numeric Window).

  Description :

  � Ce module rassemblent les fonctions de calcul des
    fen�tres; les coordonn�es sont basser sur un �cran
    de texte.

  � Calcul la taille des fen�tres (� partir de la largeur
    et de la hauteur).

  � Comme entre autre les icons (Fermeture, Changement
    de taille).

 Notes :

  � Il suppose que vous travaillez en relation constante
    avec le module vid�o de luxe (LuxeVid).

  � Ce module est support� par les versions de Turbo
    Pascal 4 ou post�rieur et aux Quick Pascal de toutes
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

Uses Text,LuxeVid; { Texte, Vid�o de luxe. }

{ Nom :

   Lecture de la taille d'une fen�tre centr�e.

  Syntaxe :

   Procedure GetSizeWindowCenter(L,H:Byte;Var X1,Y1,X2,Y2:Byte);

  Description :

   � Cette fonction retourne la taille d'une fen�tre
     situ� au centre de l'�cran. Il suffit pour cela
     de sp�cifier la largeur (L) et la hauteur (H) de
     celui-ci.

  Notes :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.

   � Les variables GetMaxX et GetMaxY repr�sentent les
     valeurs maximals X et Y de l'�cran.

   � Les fonctions shr (shift right) et shl (shift left)
     font un d�calage des bits dans la direction indiqu�.
     Les espaces lib�r�s sont remplacer par des 0.
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

   � Cette fonction confirme, si le pointeur (MX,MY) pointe
     sur l'icon de fermeture � la position (X,Y).

  Notes :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.

   � La variable CloseIcon est une chaine de caract�re qui
     contient le dessin de l'icon.

   � La fonction length retourne la longeur de la chaine
     de caract�re.
}

Function IsCloseIcon(X,Y,MX,MY:Byte):Boolean;
Begin
 IsCloseIcon := (((MX >= X)and(MX < X + Length(CloseIcon)))and(MY = Y));
End;

{ Syntaxe :

   Function IsZoomIcon(X,Y,MX,MY:Byte):Boolean;

  Description :

   � Cette fonction confirme, si le pointeur (MX,MY) pointe
     sur l'icon de changement de taille � la position (X,Y).

  Notes :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.

   � La variable ZoomIcon est une chaine de caract�re qui
     contient le dessin de l'icon.

   � La fonction length retourne la longeur de la chaine
     de caract�re.
}

Function IsZoomIcon(X,Y,MX,MY:Byte):Boolean;
Begin
 IsZoomIcon := (((MX >= X)and(MX < X + Length(ZoomIcon)))and(MY = Y));
End;

{ Syntaxe :

   Function IsExitIcon(MX,MY:Byte):Boolean;

  Description :

   � Cette fonction confirme si le pointeur (MX,MY) pointe
     sur l'icon de fermeture principal (suppos� � la position
     X = 0, Y = 0).

  Notes :

   � Cette fonction requ�re une version de Turbo Pascal
     3 ou post�rieur.

   � La variable CloseIcon est une chaine de caract�re qui
     contient le dessin de l'icon.

   � La fonction length retourne la longeur de la chaine
     de caract�re.
}

Function IsExitIcon(MX,MY:Byte):Boolean;
Begin
 IsExitIcon := (MX < Length(CloseIcon))and(MY = 0);
End;

BEGIN { Main Unit }
END.