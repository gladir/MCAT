(********************************************************)
(*                                                      *)
(*             Malte System/Language DOS                *)
(*                     1993/01/19                       *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit LanDOS;

(********************************************************)
                       INTERFACE
(********************************************************)

Function StrAttribut(Attr:Byte):String;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

Uses Level,DOS;

Function StrAttribut(Attr:Byte):String;
Begin
 Case Language of
  lgEnglish : Case Attr of
     ReadOnly + Archive,
               ReadOnly : StrAttribut := 'Read Only';
       Hidden + Archive,
                 Hidden : StrAttribut := 'Hidden';
      SysFile + Archive,
                SysFile : StrAttribut := 'System';
               VolumeID : StrAttribut := 'Volume';
              Directory : StrAttribut := 'Directory';
                Archive : StrAttribut := 'Archive';
ReadOnly + Hidden + Archive,
      ReadOnly + Hidden : StrAttribut := 'Hidden/Read Only';
ReadOnly + Hidden + SysFile + Archive,
ReadOnly+Hidden+SysFile : StrAttribut := 'System/Hidden/Read Only';
       Hidden + SysFile : StrAttribut := 'System/Hidden';
     SysFile + ReadOnly : StrAttribut := 'System/Read Only';
     ReadOnly + Archive : StrAttribut := 'Archive/Read Only';
ReadOnly+Archive+Hidden : StrAttribut := 'Archive/Read Only/Hidden';
     Directory + Hidden : StrAttribut := 'Directory/Hidden';
ReadOnly+Directory+Hidden:StrAttribut := 'Directory/Hidden/Read Only';
   ReadOnly + Directory : StrAttribut := 'Directory/Read Only';
                     else StrAttribut := 'Unknown';
              End;
         else Case Attr of
       ReadOnly + Archive,
               ReadOnly : StrAttribut := 'Prot‚g‚';
         Hidden + Archive,
                 Hidden : StrAttribut := 'Cach‚';
        SysFile + Archive,
                SysFile : StrAttribut := 'SystŠme';
               VolumeID : StrAttribut := 'Volume';
              Directory : StrAttribut := 'R‚pertoire';
                Archive : StrAttribut := 'Archive';
ReadOnly + Hidden + Archive,
      ReadOnly + Hidden : StrAttribut := 'Cach‚/Prot‚g‚';
ReadOnly + Hidden + SysFile + Archive,
ReadOnly+Hidden+SysFile : StrAttribut := 'SystŠme/Cach‚/Prot‚g‚';
       Hidden + SysFile : StrAttribut := 'SystŠme/Cach‚';
     SysFile + ReadOnly : StrAttribut := 'SystŠme/Prot‚g‚';
     ReadOnly + Archive : StrAttribut := 'Archive/Prot‚g‚';
ReadOnly+Archive+Hidden : StrAttribut := 'Archive/Prot‚g‚/Cach‚';
     Directory + Hidden : StrAttribut := 'R‚pertoire/Cach‚';
ReadOnly+Directory+Hidden:StrAttribut := 'R‚pertoire/Cach‚/Prot‚g‚';
   ReadOnly + Directory : StrAttribut := 'R‚pertoire/Prot‚g‚';
                     else StrAttribut := 'ModŠle inconnu';
              End;
 End;
End;

BEGIN { Main Unit }
END.