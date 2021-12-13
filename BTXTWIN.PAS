(********************************************************)
(*                                                      *)
(*             Malte System/BGI Text Window             *)
(*                     1993/01/31                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit BTXTWIN;

(********************************************************)
                      INTERFACE
(********************************************************)

Uses Level;

Type

     WindowType = Object
                   Color : ColorWindowBaseType;
                   Constructor InitRegular;
                   Constructor InitWarning;
                   Constructor InitError;
                   Procedure PutWindow(X1,Y1,X2,Y2:Byte;Title:String);
                   Destructor Done;
                  End;

(********************************************************)
                    IMPLEMENTATION
(********************************************************)

Uses Graph,BGI_BOX,BGI_TEXT;

Constructor WindowType.InitRegular;
Begin
 Color := Level.Color.Window.Regular;
End;

Constructor WindowType.InitWarning;
Begin
 Color := Level.Color.Window.Warning;
End;

Constructor WindowType.InitError;
Begin
 Color := Level.Color.Window.Error;
End;

Procedure WindowType.PutWindow(X1,Y1,X2,Y2:Byte;Title:String);
Begin
 ClearTextWindow(X1,Y1+1,X2,Y2,Color.Border);
 SetColor(Color.Border and 15);
 Rectangle(X1 * 8,Y1 * GetHeightChar,(X2 * 8)+7,
           (Y2 * GetHeightChar)+GetHeightChar-1);
 SetColor(Color.Icon and 15);
 Rectangle((X1 * 8),(Y1 * GetHeightChar)+1,(X1 * 8)+15,
           (Y1 * GetHeightChar)+GetHeightChar);
 PutFillBox((X1 * 8)+1,(Y1 * GetHeightChar)+1,(X1 * 8)+14,
            (Y1 * GetHeightChar)+GetHeightChar-1,Color.Icon shr 4);
 PutFillBox((X1 * 8)+3,(Y1 * GetHeightChar)+7,
            (X1 * 8)+12,(Y1 * GetHeightChar)+8,Color.Icon and 15);
 BarSpaceHori(X1+2,Y1,X2,Color.Title);
 WriteText(X1+((X2-X1)-Length(Title)) shr 1,Y1,Title,Color.Title);
End;

Destructor WindowType.Done;
Begin
End;

BEGIN { Main Unit }
END.