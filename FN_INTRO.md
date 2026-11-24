# DOSSIER D'EXPERTISE CINÉMATOGRAPHIQUE & SQF — INTRODUCTION « LA LÉGION »

> **Document de référence pour la refonte intégrale de la cinématique d'introduction (fn_intro_A à fn_intro_H).**  
> *Objectif : Transformer l'introduction en une séquence cinématographique immersive de calibre professionnel (standard cinéma militaire type Sicario / Black Hawk Down / Act of Valor), éliminer les transitions nauséeuses, épurer les textes et fluidifier la séquence d'atterrissage.*

---

## 1. DIAGNOSTIC CRITIQUE DES SÉQUENCES ACTUELLES

L'analyse détaillée du code des 8 fichiers (`fn_intro_A.sqf` à `fn_intro_H.sqf`) et des captures d'écran en jeu met en évidence plusieurs ruptures majeures d'immersion, tant sur le plan de la mise en scène que de la technique moteur Arma 3.

### 1.1. Plan initial (Séquence A) : Absence d'incarnation et cadre vide
- **Le problème constaté :** La caméra est initialisée à `destPos + [-75, -75, +145]` et descend vers `destPos + [-25, -25, +45]`, braquée en plongée diagonale vers la zone d'atterrissage (LZ). Or, au démarrage, l'hélicoptère se trouve à **1500 mètres de là**.
- **Conséquence visuelle :** Le joueur est accueilli par 10 secondes d'observation d'un champ d'herbe et de boue totalement vide à 145 mètres de hauteur. L'hélicoptère n'est même pas dans le champ. Ce plan statique et plat est désincarné (« dégueulasse ») et ne crée aucune tension dramatique.

### 1.2. Absence totale de plan intérieur (Perte de l'ancrage joueur)
- **Le problème constaté :** Le joueur et son escouade sont insérés dans les sièges cargo du Ghosthawk (`_x moveInCargo _heli`), mais la caméra ne pénètre **jamais** à l'intérieur de la carlingue.
- **Conséquence immersive :** Le joueur ne ressent ni la promiscuité de la carlingue, ni les vibrations mécaniques des turbines, ni la tension qui se lit sur le visage de ses frères d'armes assis en face de lui. Il regarde un objet 3D extérieur de loin au lieu de vivre l'insertion tactique « dans la peau du légionnaire ».

### 1.3. L'overdose du « Whip Blur » nauséeux (7 occurrences en 80 secondes)
- **Le problème constaté :** À la fin de chaque séquence (A→B, B→C, C→D, D→E, E→F, F→G), l'effet `LL_fnc_whip` est systématiquement déclenché avec un flou cinétique violent (`DynamicBlur` réglé à 4.0 - 4.5).
- **Conséquence physiologique :** Toutes les 9 à 11 secondes, l'écran subit une déformation floue brutale sans justification de raccord. Cette répétition mécanique produit un effet stroboscopique qui provoque cinétose et nausée chez le joueur, détruisant tout le professionnalisme de la réalisation.

### 1.4. L'atterrissage haché par téléportations successives (Séquences E, F, G, H)
- **Le problème constaté :** Au lieu de laisser le vecteur aérien suivre une trajectoire de descente et de décélération continue, le script procède à des téléportations en chaîne via `setPosATL` :
  - **Séquence E :** Téléportation brutale de l'hélico à 180 m de la LZ, altitude 45 m, vitesse injectée 26 m/s.
  - **Séquence F :** Téléportation à 25 m de la LZ, altitude 16 m, vitesse réduite à 4 m/s.
  - **Séquence G :** Téléportation à la verticale de la LZ à 5 m d'altitude, puis descente linéaire forcée en `EachFrame` (4.5s) en écrasant artificiellement `setPosATL`.
  - **Séquence H :** Téléportation plaquée au sol (`setPosATL [x,y,0]`), puis éjection instantanée de toute l'équipe via `moveOut _x`.
- **Conséquence visuelle :** Ces ruptures physiques détruisent l'inertie de l'appareil, brisent le mouvement du rotor, coupent les effets de poussière/particules au sol et créent des sauts temporels flagrants entre les plans au lieu d'une approche aéronautique fluide.

### 1.5. Typographie brute, envahissante et masquante
- **Le problème constaté :** Dans la séquence B, le titre tricolore (`MISSION LÉGION ÉTRANGÈRE`) est affiché en `size='3.4'`, occupant plus de la moitié de la hauteur de l'écran en plein centre. Dans les autres séquences, les textes oscillent entre `size='1.9'` et `size='2.4'`.
- **Conséquence visuelle :** Les polices géantes masquent l'hélicoptère et le décor. Le spectateur lit un panneau publicitaire au lieu de contempler la mise en scène. L'élégance militaire requiert au contraire une typographie compacte, précise, technique et positionnée dans les zones de respiration de l'image (tiers inférieur ou supérieur gauche).

---

## 2. LA NOUVELLE DIRECTION CINÉMATOGRAPHIQUE

### 2.1. Philosophie de réalisation
Une introduction militaire d'élite doit respecter trois piliers :
1. **L'intimité avant l'ampleur :** Commencer au plus près de l'homme (le casque, la respiration, la poignée de maintien, les armes, le regard des équipiers dans la pénombre de la cabine) avant de révéler l'environnement extérieur.
2. **La continuité cinétique :** L'hélicoptère ne doit jamais paraître figé ou téléporté. Chaque coupe doit être un raccord de mouvement (le vecteur continue sa course logique d'un plan à l'autre).
3. **Le montage cut professionnel :** Remplacer les 7 flous violents par des coupes franches calées sur les respirations et percussions du chant de la Légion, avec au maximum un ou deux fondus invisibles ou raccords dans l'axe.

---

## 3. STORYBOARD SÉQUENCE PAR SÉQUENCE (PLAN DE VOL ET CADRAGES)

```
00.00s ──────── 10.11s ──────── 19.48s ──────── 30.03s ──────── 39.42s ──────── 51.77s ──────── 61.33s ──────── 71.56s ──────── 80.28s ── 90.72s
[   SEQ A   ]   [   SEQ B   ]   [   SEQ C   ]   [   SEQ D   ]   [   SEQ E   ]   [   SEQ F   ]   [   SEQ G   ]   [   SEQ H   ]   [ INGAME ]
  Intérieur        Reveal         Travelling      Canopée &       Approche        Rase-motte      Touchdown       Décollage      Contrôle
  Carlingue       Extérieur       Basse-alt       Territoire      Téléobjectif     & Souffle       & Débarquement  & P4           Joueur
```

### SÉQUENCE A (0.00s - 10.11s) : L'immersion intérieure (« Face aux Légionnaires »)
- **Concept :** Caméra embarquée dans la cabine passagers, positionnée à hauteur des yeux et braquée vers l'arrière, face aux légionnaires assis en rangs serrés.
- **Cadrage :** 
  - La caméra est fixée en avant du compartiment de troupe (`modelToWorldVisual [0.15, 1.25, -0.32]`), à mi-hauteur (sous la traverse du compartiment mitrailleur), évitant tout obstacle visuel.
  - Direction du regard : vers l'arrière (`modelToWorldVisual [-0.15, -1.0, -0.32]`), cadrant les visages, casques FÉLIN, gilets pare-balles et fusils tenus entre les genoux par les hommes de la Légion.
  - Travelling lent et subtil ($Y = 1.25 \to 1.05$) avec un léger panoramique balayant les deux rangées de coéquipiers.
  - En arrière-plan et de chaque côté : les portes latérales ouvertes laissant entrevoir la jungle et l'océan qui défilent à 160 km/h.
  - Vibration de carlingue naturelle (`_shake = 0.015`).
- **Typographie :** 
  - Cartouche militaire moderne et discret en bas à gauche (`PuristaMedium`, taille 1.15) :  
    `13 MARS 2019 — 16:44`  
    `VECTEUR D'INSERTION TACTIQUE // CE`  
    Liseré tricolore de prestige.
- **Raccord vers B :** **Cut franc** (0 frame) à la seconde 10.11 sur le début du verset 3 (« Héritiers de ses traditions »).

---

### SÉQUENCE B (10.11s - 19.48s) : Le Reveal extérieur (L'envergure de la Légion)
- **Concept :** Contre-plongée spectaculaire en travelling latéral.
- **Cadrage :** 
  - Caméra extérieure positionnée à 22 mètres sur le flanc avant-droit, en contre-plongée légère (angle d'élévation -15°).
  - L'appareil franchit une crête boisée, les turbines grondent, la lumière du matin frappe la carlingue.
  - Raccord parfait avec la trajectoire initiée dans la séquence A.
- **Typographie :**
  - Titre principal épuré et centré dans le tiers supérieur de l'écran :  
    `MISSION` (Bleu ciel feutré `#4FC3F7`, size 1.3, espacement moderne)  
    `LÉGION ÉTRANGÈRE` (Blanc pur `#FFFFFF`, size 1.6, PuristaBold)  
  - Plus de pavé de 3.4 qui mange tout l'écran ! L'hélicoptère reste le sujet central visible.
- **Raccord vers C :** **Raccord dans l'axe** (changement de focale sans flou artificiel).

---

### SÉQUENCE C (19.48s - 30.03s) : Travelling de vol tactique rase-canopée
- **Concept :** Caméra suiveuse dynamique trois-quarts arrière.
- **Cadrage :** 
  - Positionnée à l'arrière gauche (`_angle = _hDir + 155`), légèrement sous l'axe du rotor pour capter le sillage de l'appareil fendant la brume matinale.
  - On aperçoit distinctement par les portes latérales ouvertes les légionnaires assis prêts à l'engagement.
- **Typographie :**
  - Mention sobre de contexte :  
    `IMMERSION & OBJECTIFS DYNAMIQUES` (Or vieilli `#D4AF37`, size 1.1)  
    Liseré fin tricolore en dessous.
- **Raccord vers D :** **Cut sec au changement de verset**.

---

### SÉQUENCE D (30.03s - 39.42s) : Le cadre opérationnel (Panorama géographique)
- **Concept :** Plan large d'ensemble établissant la géographie insulaire hostile.
- **Cadrage :** 
  - Caméra grand angle (FOV 0.72) en hauteur surplombant l'océan Pacifique et la côte de Tanoa.
  - L'hélicoptère traverse le cadre de gauche à droite en diagonale descendante, se rapprochant de la terre ferme.
- **Typographie :**
  - `THÉÂTRE D'OPÉRATIONS — ARCHIPEL DE TANOA` (size 1.15, blanc titane)  
  - `ZONE D'ENGAGEMENT FORESTIÈRE & CÔTIÈRE` (size 0.9, gris ardoise `#94A3B8`).
- **Raccord vers E :** **Cut sur amorce d'obstacle** (l'appareil passe derrière un bouquet de palmiers).

---

### SÉQUENCE E (39.42s - 51.77s) : Approche Haute Sécurisée (Train Rentrée)
- **Concept :** Première vue sol en longue focale depuis la LZ dégagée.
- **Sécurisation de la trajectoire (Anti-arbres) :** 
  - L'hélicoptère maintient une **haute altitude de sécurité** ($52\text{ m} \to 40\text{ m}$) en survolant la lisière forestière (fini l'atterrissage en ligne droite type avion qui frôlait les arbres).
  - Train d'atterrissage maintenu **fermé/rentré** (`LandGearUp`).
  - Distance passant de 320 m à 110 m de la LZ.
- **Cadrage :** Caméra au sol à 55 mètres de la LZ, équivalent téléobjectif (FOV 0.38) cadrant l'appareil arrivant au-dessus de la cime des arbres.
- **Typographie :** Mention discrète de création en bas à droite : `Scénario & Scripts : Friart Script` (size 0.95).
- **Raccord vers F :** **Cut franc**.

---

### SÉQUENCE F (51.77s - 61.33s) : Ressource (Flare) & Stationnaire Vertical (Train Rentrée)
- **Concept :** Plan rasant au sol montrant la violence du souffle des pales sur la clairière.
- **Sécurisation de la trajectoire :** 
  - L'appareil franchit la lisière en altitude ($40\text{ m} \to 20\text{ m}$) et avance de 110 m à **0 m** (verticale exacte de l'héliport).
  - Ressource (flare) : le pilote cabre pour casser toute vitesse horizontale ($14\text{ m/s} \to 0\text{ m/s}$).
  - L'appareil se stabilise en stationnaire haut à $20\text{ m}$ à la verticale pile de la LZ, train toujours fermé.
- **Cadrage :** Caméra à 1.40 m du sol sur le bord de la LZ (FOV 0.52).
- **Typographie :** Écran 100% épuré.
- **Raccord vers G :** **Cut raccord d'action**.

---

### SÉQUENCE G (61.33s - 71.56s) : Descente Droite Verticale, Sortie du Train & Touchdown
- **Concept :** Véritable descente hélicoptère droite (« Descente Droite ») sur l'axe vertical de la LZ.
- **Sortie du train :** Déploiement du train d'atterrissage pour cette unique séquence de descente finale (`LandGear` via le pilote).
- **Sécurisation :** 
  - Déplacement horizontal : **0.0 m** (l'hélicoptère est rigoureusement à l'aplomb de l'héliport).
  - Descente verticale droite de $20\text{ m}$ à $0\text{ m}$ sur une durée de 7.2 secondes, avec amortissement doux avant le contact.
  - Les roues touchent le sol à $t \approx 68.5\text{ s}$ sur la position exacte de la LZ (`_destPos`).
  - Suspension comprimée, posé net sur l'héliport, stabilisation des patins.
- **Cadrage :** Caméra stable à 18 m cadrant la descente verticale et le contact des roues avec le sol.
- **Typographie :** Aucune.
- **Raccord vers H :** **Cut raccord**.

---

### SÉQUENCE H (71.56s - 80.28s) : Débarquement, Rentrée du Train & Départ
- **Concept :** Débarquement coordonné des légionnaires, prise de position au P4 et décollage.
- **Cinématique :**
  - L'escouade débarque de l'appareil posé sur la LZ et s'établit en garde à 360° autour du VLTT P4.
  - L'hélicoptère remet plein gaz, rentre son train d'atterrissage (`LandGearUp`) et prend de la vitesse vers le large.
  - La caméra pivote vers le joueur et le groupe.
- **Transition finale (80.28s) :**
  - Fondu au noir rapide et propre (`cutText ["", "BLACK OUT", 0.4]`).
  - Rétablissement de la vue subjective joueur (`player switchCamera "INTERNAL"`).
  - Fondu d'ouverture (`cutText ["", "BLACK IN", 1.2]`). Mission lancée !

---

## 4. ARCHITECTURE TECHNIQUE SQF & BONNES PRATIQUES

### 4.1. Suppression intégrale des `LL_fnc_whip`
Dans tous les fichiers `fn_intro_*.sqf`, les lignes :
```sqf
[_ppBlurIntro, 4.5, 0.30] call LL_fnc_whip;
```
sont supprimées. Le passage de plan s'effectue par un **vrai cut cinématographique** via `camCommit 0` et remise à zéro des handlers d'interpolation.

### 4.2. Élimination des téléportations en vol
Pour l'approche (E, F, G) :
- Au lieu d'écraser la position de l'appareil 3 fois avec `setPosATL`, l'hélicoptère reçoit au départ une route de vol fluide (`flyInHeight`, `limitSpeed`, `doMove`) avec des points de passage calculés.
- L'approche est calculée pour arriver naturellement au-dessus de la LZ à $t = 61.33	ext{ s}$.

### 4.3. Standardisation des calques et polices d'affichage
- **Calque RSC des sous-titres :** `LL_subtitles_layer` (ID 8888, synchronisé aux 18 versets du chant).
- **Calque RSC des titres cinématiques :** Layer dédié `790`, polices `PuristaMedium` et `RobotoCondensedBold`, taille plafonnée à **1.35 maximum** pour le titre principal et **0.95** pour les sous-titres contextuels.
- **Format du liseré tricolore :** Fine barre d'accentuation discrète sous le texte :
```sqf
"<t size='0.55'><t color='#1E88E5'>━━━━ </t><t color='#FFFFFF'>━━━━ </t><t color='#E53935'>━━━━</t></t>"
```

### 4.4. Conformité stricte du code
- **Zéro commentaire** (`//` ou `/* */`) dans l'ensemble des fichiers SQF déployés.
- **Zéro `diag_log`**.
- **Équilibrage rigoureux de toutes les accolades**, crochets et parenthèses.

---

## 5. PLAN D'EXÉCUTION DÉTAILLÉ

1. **Validation du concept :** Approbation du découpage cinématique et du storyboard ci-dessus.
2. **Implémentation Séquence A :** Remplacement de la plongée statique par la caméra subjective cockpit/cargo hold embarquée.
3. **Implémentation Séquence B :** Ajustement de la contre-plongée reveal et réduction calibrée du titre tricolore.
4. **Implémentation Séquences C & D :** Fluidification des travellings dynamiques et harmonisation des polices.
5. **Refonte Séquences E, F, G (Approche & Atterrissage) :** Remplacement des téléportations saccadées par une approche physique continue et des cadrages téléobjectif / ras de terre immersifs.
6. **Finalisation Séquence H :** Alignement du décollage et de la transition première personne.
7. **Contrôle qualité automatisé :** Exécution du script de conformité (75/75 fichiers propres, syntaxe irréprochable).
