(********************************************************)
(*                                                      *)
(*              Malte System/DOS Prompt                 *)
(*                     1993/03/09                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit Prompt;

(********************************************************)
                       INTERFACE
(********************************************************)

Function GetPrompt:String;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses DOS,OS,DString;

Function GetPrompt:String;
Var SPrompt,Tmp : String;
    I           : Byte;

 Function SymbolToStr(Chr:Char):String;
 Const Week : Array[0..6] of String[3] = ('Sun','Mon','The','Wed','Thu','Fri','Sat');
       Mon  : Array[1..12] of String[3] = ('Jan','Feb','Mar','Apr','May','Jun',
                                           'Jul','Aug','Sep','Oct','Nov','Dec');
 Var T                         : String;
     Year,Month,Day,DayOfWeek,
     Hour,Min,Sec,Sec100       : Word;
 Begin
  Case Chr of
       'D' : Begin
              GetDate(Year,Month,Day,DayOfWeek);
              T := Week[DayOfWeek] + '  ' +
	           Mon[Month] + ' ' + Strg(Day) + ', ' +
		   Strg(Year);
	     End;
       'T' : Begin
              GetTime(Hour,Min,Sec,Sec100);
              T := StrgTo(Hour,2) + ':' + MultChar(Byte('0'),2-Length(Strg(Min))) + Strg(Min) +
	           ':' + MultChar(Byte('0'),2-Length(Strg(Sec))) + Strg(Sec);
             End;
       'B' : T := '|';
   'e','E' : T := Char(27);
   'g','G' : T := '>';
       'N' : T := GetDrive;
   'p','P' : T := OS.GetPath;
   '-','S' : T := ' ';
       'V' : T := Strg(Lo(DOSVersion)) + '.' + Strg(Hi(DOSVersion));
   '_','Z' : T := #13+#10;
       'z' : T := '?';
        Else T := '';
  End;
  SymbolToStr := T;
 End;

Begin
 SPrompt := GetEnv('PROMPT');
 Tmp := '';
 For I := 1 to Length(SPrompt) do
 Begin
  If(SPrompt[I] = '$')Then
  Begin
   Inc(I);
   Tmp := Tmp + SymbolToStr(SPrompt[I]);
  End
   else
  Tmp := Tmp + SPrompt[I];
 End;
 GetPrompt := Tmp;
End;

BEGIN { Main Unit }
END.