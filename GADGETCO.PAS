(********************************************************)
(*                                                      *)
(*            Malte System/Gadget Communcation          *)
(*                     1993/05/21                       *)
(*                                                      *)
(*       Copyright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit GadgetCommunication;

(********************************************************)
                        INTERFACE
(********************************************************)

Uses Windows;

Type

     Terminal = Object(Wins)
                 Constructor InitTerminal(X1,Y1,X2,Y2:Byte);
                End;

(********************************************************)
                      IMPLEMENTATION
(********************************************************)

Uses Level;

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                  Terminal.InitTerminal               ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Constructor Terminal.InitTerminal(X1,Y1,X2,Y2:Byte);
Begin
 Init(X1,Y1,X2,Y2,'Terminal',Level.Color.Window.Shell);
End;

BEGIN { Main Unit }
END.