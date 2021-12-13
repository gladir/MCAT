(********************************************************)
(*                                                      *)
(*            Malte System/Gadget Printer               *)
(*                    1993/05/18                        *)
(*                                                      *)
(*      Copyright (C) par les Chevaliers de Malte       *)
(*                                                      *)
(********************************************************)

Unit GadgetPrinter;

(********************************************************)
                       INTERFACE
(********************************************************)

Uses Level,TPointer;

Const

      PrinterCommandCtrlData : Array[lgEnglish..lgFrench,0..19] of PChar =
                               (
                                (
                                 'Beep',
                                 'DelLine',
                                 'Return',
                                 'SetLine printer',
                                 'ResetLine printer',
                                 'BackSpace',
                                 '8bit off',
                                 'Mode unidirectionnel for line',
                                 'Set upbit 0',
                                 'Set upbit 1',
                                 'Initialisation printer',
                                 'Set off end of paper',
                                 'Set on end of paper',
                                 'Paper to paper',
                                 'Set typewriter',
                                 'Slow-speed',
                                 'Unidirectionnel printing',
                                 'End of data to copy',
                                 'Multi-printing',
                                 NIL
                                ),
                                (
                                 'Signal sonore',
                                 'D‚truire une ligne de caractŠres',
                                 'Retour de chariot',
                                 'Mettre l''imprimante en ligne',
                                 'D‚sactive l''imprimante en ligne',
                                 'D‚truire un caractŠre',
                                 'Supprimer l''effet du huitiŠme bit',
                                 'Mode unidirectionnel pour une seul ligne',
                                 'Mettre le bit le plus haut sur 0',
                                 'Mettre le bit le plus haut sur 1',
                                 'Initialisation de l''imprimante',
                                 'D‚sactiver le d‚tecteur de fin de papier',
                                 'Activer le d‚tecteur de fin de papier',
                                 'Alimentation feuille … feuille',
                                 'Activer le mode machine-…-‚crire',
                                 'Demi-vitesse',
                                 'Impression unidirectionnelle',
                                 'Fin des donn‚es copier',
                                 'Impression multiple',
                                 NIL
			        )
			       );

      PrinterCommandTab      : Array[lgEnglish..lgFrench,0..39] of PChar =
                               (
                                (
                                 'Backspace',
                                 'DelLine',
                                 'Return',
                                 'KillLine',
                                 'Set pixel absolute position',
                                 'Select vertical Tab canal',
                                 'Set position pixel',
                                 'Interline 1/8"',
                                 'Interline 7/72"',
                                 'Interline 1/6"',
                                 'Interline n/72"',
                                 'Interline n/216" ou n/180"',
                                 'Interline n/360"',
                                 'Set home page',
                                 'Auto-return On/Off',
                                 'Calibrat text',
                                 'Define vertical Tab',
                                 'Mark vertical Tab',
                                 'Define page length in line',
                                 'Define page length in "',
                                 'Define horizontal Tab',
                                 'Horizontal Tab length',
                                 'Repeat vetical Tab',
                                 'Interline',
                                 'JumpLine n/216" or n/180"',
                                 'Format of paper in n/180"',
                                 'Left merge',
                                 'Set down merge',
                                 'Set off down merge',
                                 'Right merge',
                                 'Define Tab',
                                 'Merge in the char',
                                 'Merge left-right',
                                 'Find Feed',
                                 'Move right',
                                 'Move left',
                                 'Move down',
                                 'Horizontal Tab',
                                 'Vertical Tab',
                                 NIL
                                ),
                                (
                                 'Recule espace (Backspace)',
                                 'Effacer une ligne',
                                 'Retour de chariot',
                                 'Supprimer une ligne',
                                 'Fixer la position absolue d''un point',
                                 'S‚lectionner un canal de tabulation verticale',
                                 'Fixer la position relatif d''un point',
                                 'Interligne 1/8"',
                                 'Interligne 7/72"',
                                 'Interligne 1/6"',
                                 'Interligne n/72"',
                                 'Interligne n/216" ou n/180"',
                                 'Interligne n/360"',
                                 'D‚finir le d‚but de page',
                                 'Activer/D‚sactiver saut de ligne automatique',
                                 'Alignement du texte',
                                 'D‚finir des tabulations verticales',
                                 'Marques des tabulations verticales',
                                 'D‚finition de la longeur de page en ligne',
                                 'D‚finition de la longeur de page en pouces',
                                 'D‚finition des tabulations horizontales',
                                 'Largeur de tabulation horizontales',
                                 'R‚p‚tition de tabulation verticales',
                                 'Interligne',
                                 'Saut de ligne de n/216" ou n/180"',
                                 'Transport de papier en n/180"',
                                 'Marge gauche',
                                 'D‚finition de la marge inf‚rieure',
                                 'Annule la marge inf‚rieure',
                                 'Marge droite',
                                 'D‚finir la tabulation',
                                 'Intervalle entre les caractŠres',
                                 'Marges droite et gauche',
                                 'Saut de page',
                                 'Transport avant',
                                 'Transport arriŠre',
                                 'Saut de ligne',
                                 'Tabulation horizontale',
                                 'Tabulation verticale',
                                 NIL
                                )
                               );

      PrinterCommandStyle    : Array[lgEnglish..lgFrench,0..22] of PChar =
                               (
                                (
                                 'Set off double-length',
                                 'Set off compress-mode',
				 'Multi-mode printer',
                                 'Set height char',
                                 'Black color',
                                 'Cyan color',
                                 'Magenta color',
                                 'Yellow color',
                                 'Micro-printing',
                                 'Print quality LQ or NLQ',
                                 'Select char matrix',
                                 'Elite',
                                 'Pica',
                                 'Printing proportionnel On/Off',
                                 'Select compress-mode',
                                 'Set double-length for line',
                                 'Print double-length',
                                 'Print double-height',
                                 'Choice printer-mode',
                                 'Length Double/Triple On/Off',
                                 'Fast printing',
                                 'Compress-Printing for line',
                                 NIL
                                ),
                                (
                                 'Annuler l''impression en double-largeur',
                                 'D‚sactiver l''impression en mode condens‚',
                                 'Combinaison des modes d''impression',
                                 'Choix du mode hauter de caractŠres',
                                 'Couleur d''impression noir',
                                 'Couleur d''impression cyan',
                                 'Couleur d''impression magenta',
                                 'Couleur d''impression jaune',
                                 'Micro impression',
                                 'Impression en qualit‚ LQ ou NLQ',
                                 'S‚lection d''une police de caractŠres',
                                 'Elite',
                                 'Pica',
                                 'Impression proportionnelle activ‚e/d‚sactiv‚e',
                                 'S‚lection de l''impression condens‚e',
                                 'Active la double largeur pour une ligne',
                                 'Impression en double largeur',
                                 'Impression en double hauteur',
                                 'Choix du mode d''impression',
                                 'Active/D‚sactive la longeur double/triple',
                                 'Impression rapide',
                                 'Impression condens‚e pour une ligne',
                                 NIL
                                )
                               );

      PrinterCommandText     : Array[lgEnglish..lgFrench,0..10] of PChar =
                               (
                                (
                                 'Select mark line',
                                 'Underline continue On/Off',
                                 'Double-Underline On/Off',
                                 'Bold Char',
                                 'Double-Printing On',
                                 'Double-Printing Off',
                                 'Select char matrix',
                                 'Exp/Indice On',
                                 'Exp/Indice Off',
                                 'Set merge in the char',
                                 NIL
                                ),
                                (
                                 'S‚lection du marquage de lignes',
                                 'Active/D‚sactive le soulignement continue',
                                 'Active/D‚sacitve le surlign‚',
                                 'CaractŠre gras',
                                 'Activer l''impression en double frappe',
                                 'D‚sactiver l''impression en double frappe',
                                 'S‚lection de l''affichage des caractŠres',
                                 'Active le mode exposant/Indice',
                                 'D‚sactive le mode exposant/Indice',
                                 'Fixer l''intervalle entre les caractŠres',
                                 NIL
				)
                               );

        PrinterCommandFont   : Array[lgEnglish..lgFrench,0..7] of PChar =
                               (
                                (
                                 'Print more char symbol',
                                 'Print one char symbol',
                                 'Italic char On',
                                 'Italic char Off',
                                 'Set internationnal char',
                                 'Choice font',
                                 'IBM italic char',
                                 NIL
                                ),
                                (
                                 'Impression de plusieur caractŠres symbol',
                                 'Impression d''un caractŠre symbol',
                                 'S‚lectionner les caractŠres italique',
                                 'D‚selectionner les caractŠres italique',
                                 'S‚lectionner le jeu de caractŠre internationnal',
                                 'Choix de la fonte',
                                 'CaractŠre italique ou IBM',
                                 NIL
                                )
                               );

        PrinterCommandUserFont : Array[lgEnglish..lgFrench,0..13] of PChar =
                                 (
                                  (
                                   'Set char matrix',
                                   'Define font',
                                   'Select graph-mode',
                                   'Copy ROM Font to ROM',
                                   'User char',
                                   'User graph-command',
                                   'Select graph-mode 9 pins',
                                   'Ext. printer codes',
                                   'Graph 8 pixel, sample',
                                   'Graph 8 pixel, double',
                                   'Graph 8 pixel, 2 x double',
                                   'Double, fast speed',
                                   'Graph 360dpi',
                                   NIL
                                  ),
                                  (
                                   'Activer le jeu de caractŠre',
                                   'D‚finition d''une fonte',
                                   'S‚lection du mode graphique',
                                   'Copier la fonte de la ROM dans la RAM',
                                   'CaractŠre utilisateur',
                                   'R‚affection de la commande graphique',
                                   'S‚lectionner le mode graphique … 9 aiguilles',
                                   'Extension des codes imprimables',
                                   'Impression graphique 8 point, simple densit‚',
                                   'Impression graphique 8 point, double densit‚',
                                   'Impression quadruple densit‚, 8 point',
                                   'Impression double densit‚, double vitesse',
                                   'Impression graphique en 360dpi',
                                   NIL
                                  )
                                 );

        CenterPrinterCommand   : Array[lgEnglish..lgFrench,0..6] of
	                          Record
                                   Title:PChar;
                                   Option:^TPChar;
				  End =
				 (
                                  (
                                   (Title:'Controler data';Option:@PrinterCommandCtrlData),
                                   (Title:'Tabulations';Option:@PrinterCommandTab),
                                   (Title:'Styles';Option:@PrinterCommandStyle),
                                   (Title:'Visuel printing/text controle';Option:@PrinterCommandText),
                                   (Title:'Select fonts';Option:@PrinterCommandFont),
                                   (Title:'User fonts';Option:@PrinterCommandUserFont),
                                   (Title:NIL;Option:NIL)
                                  ),
                                  (
                                   (Title:'Contr“le des donn‚es';Option:@PrinterCommandCtrlData),
                                   (Title:'Tabulations';Option:@PrinterCommandTab),
                                   (Title:'Styles';Option:@PrinterCommandStyle),
                                   (Title:'Effets d''impression/traitement de texte';Option:@PrinterCommandText),
                                   (Title:'S‚lection des fontes';Option:@PrinterCommandFont),
                                   (Title:'Fontes utilisateur';Option:@PrinterCommandUserFont),
                                   (Title:NIL;Option:NIL)
                                  )
				 );

Procedure PrinterSetup;

(********************************************************)
                     IMPLEMENTATION
(********************************************************)

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                      PrinterSetup                    ³Û
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

Procedure PrinterSetup;
Begin
End;

BEGIN { Main Unit }
END.