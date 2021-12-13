(********************************************************************)
(*                                                                  *)
(*                          Malte System/Level                      *)
(*                             1992/10/21                           *)
(*                                                                  *)
(*             Copyright (C) par les Chevaliers de Malte            *)
(*                                                                  *)
(********************************************************************)

Unit Level;

(********************************************************************)
                               INTERFACE
(********************************************************************)

Const

      LvlBeginner           = 0;
      LvlIntermediate       = 1;
      LvlAdvanced           = 2;
      LvlExpert             = 3;

      CatNormal             = 0;
      CatProgramming        = 1;
      CatTechnicien         = 2;

      EnvOldSystem          = 0;
      EnvNormal             = 1;
      EnvNormalWithKeyMouse = 2;
      EnvWindows            = 3;

      lgEnglish             = 0;
      lgFrensh              = 1;
      lgFrench              = 1;
      lgSpanish             = 2;

Type


     ColorBaseType       = Record
                            Title      : Byte;
                            Background : Byte;
                            Icon       : Byte;
                           End;

     ColorMenuType       = Record
                            HighLetter : Byte;
                            Normal     : Byte;
                            Select     : Byte;
                           End;

     ColorWindowBaseType = Record
                            Border     : Byte;
                            Title      : Byte;
                            TitleActif : Byte;
                            Icon       : Byte;
                            Msg        : Byte;
                            Key        : Byte;
                            KeyShade   : Byte;
                            SelectA    : Byte;
                            SelectB    : Byte;
                            Shade      : Byte;
                            Input      : Byte;
                            Normal     : Byte;
                           End;

     ColorWindowType   = Record
                          Regular : ColorWindowBaseType;
                          Warning : ColorWindowBaseType;
                          Error   : ColorWindowBaseType;
                          Shell   : ColorWindowBaseType;
                         End;

     ColorEndBarType   = Record
                          Normal     : Byte;
                          HighLetter : Byte;
                         End;

     ColorInputType    = Record
                          Error : Byte;
                         End;

     ColorType         = Record
                          Base   : ColorBaseType;
                          Menu   : ColorMenuType;
                          Window : ColorWindowType;
                          Input  : ColorInputType;
                          EndBar : ColorEndBarType;
                         End;

Var

    Language         : Byte;
    LvlLevel         : Byte;
    LvlCategory      : Byte;
    LvlEnvironnement : Byte;
    Color            : ColorType;

(********************************************************************)
                            IMPLEMENTATION
(********************************************************************)

Const

     Black        = 0;
     Blue         = 1;
     Green        = 2;
     Cyan         = 3;
     Red          = 4;
     Magenta      = 5;
     Brown        = 6;
     LightGray    = 7;
     DarkGray     = 8;
     LightBlue    = 9;
     LigntGreen   = 10;
     LightCyan    = 11;
     LightRed     = 12;
     LightMagenta = 13;
     Yellow       = 14;
     White        = 15;

BEGIN { Main Unit }
 Language         := lgEnglish;
 lvlLevel         := LvlBeginner;
 lvlCategory      := CatNormal;
 lvlEnvironnement := EnvWindows;
                                  { Background }     { Foreground }
 Color.Base.Title             := (Blue      shl 4) + White;
 Color.Base.Icon              := (Black     shl 4) + White;
 Color.Base.Background        := (Black     shl 4) + LightGray;
 Color.Menu.HighLetter        := (White     shl 4) + LightRed;
 Color.Menu.Normal            := (White     shl 4) + Black;
 Color.Menu.Select            := (Black     shl 4) + White;
 Color.Window.Regular.Border  := (LightBlue shl 4) + White;
 Color.Window.Regular.Icon    := (Black     shl 4) + White;
 Color.Window.Regular.Title   := (White     shl 4) + Blue;
 Color.Window.Regular.TitleActif := (White  shl 4) + LightRed;
 Color.Window.Regular.Msg     := (LightBlue shl 4) + LightCyan;
 Color.Window.Regular.Key     := (White     shl 4) + Black;
 Color.Window.Regular.SelectA := (White     shl 4) + Yellow;
 Color.Window.Regular.SelectB := (White     shl 4) + LightRed;
 Color.Window.Regular.Shade   := (LightBlue shl 4) + DarkGray;
 Color.Window.Regular.Input   := (Blue      shl 4) + White;
 Color.Window.Regular.Normal  := (LightBlue shl 4) + White;
 Color.Window.Warning.Border  := (Yellow    shl 4) + White;
 Color.Window.Warning.Icon    := (Black     shl 4) + White;
 Color.Window.Warning.Title   := (White     shl 4) + LightRed;
 Color.Window.Warning.TitleActif := (White  shl 4) + LightBlue;
 Color.Window.Warning.Msg     := (Yellow    shl 4) + Black;
 Color.Window.Warning.Key     := (White     shl 4) + Black;
 Color.Window.Warning.SelectA := (White     shl 4) + LightBlue;
 Color.Window.Warning.SelectB := (White     shl 4) + LightRed;
 Color.Window.Warning.Shade   := (Yellow    shl 4) + DarkGray;
 Color.Window.Warning.Input   := (Brown     shl 4) + White;
 Color.Window.Warning.Normal  := (Yellow    shl 4) + Black;
 Color.Window.Error.Border    := (LightRed  shl 4) + White;
 Color.Window.Error.Icon      := (Black     shl 4) + White;
 Color.Window.Error.Title     := (White     shl 4) + LightRed;
 Color.Window.Error.TitleActif := (White  shl 4) + LightBlue;
 Color.Window.Error.Msg       := (LightRed  shl 4) + White;
 Color.Window.Error.Key       := (White     shl 4) + Black;
 Color.Window.Error.SelectA   := (White     shl 4) + Yellow;
 Color.Window.Error.SelectB   := (White     shl 4) + LightBlue;
 Color.Window.Error.Shade     := (LightRed  shl 4) + DarkGray;
 Color.Window.Error.Input     := (Red       shl 4) + White;
 Color.Window.Error.Normal    := (LightRed  shl 4) + White;
 Color.Window.Shell.Border    := (Black     shl 4) + White;
 Color.Window.Shell.Icon      := (Black     shl 4) + White;
 Color.Window.Shell.Title     := (White     shl 4) + Blue;
 Color.Window.Shell.TitleActif := (White    shl 4) + LightRed;
 Color.Window.Shell.Msg       := (Black     shl 4) + LightCyan;
 Color.Window.Shell.Key       := (White     shl 4) + Black;
 Color.Window.Shell.SelectA   := (White     shl 4) + Yellow;
 Color.Window.Shell.SelectB   := (White     shl 4) + LightRed;
 Color.Window.Shell.Shade     := (Black     shl 4) + DarkGray;
 Color.Window.Shell.Input     := (Black     shl 4) + White;
 Color.Window.Shell.Normal    := (Black     shl 4) + White;
 Color.EndBar.Normal          := (White     shl 4) + Black;
 Color.EndBar.HighLetter      := (White     shl 4) + LightRed;
 Color.Input.Error            := (LightRed  shl 4) + Red;
END.