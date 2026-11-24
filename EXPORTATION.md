# 🚀 GUIDE COMPLET D'EXPORTATION VERS D'AUTRES TERRAINS ARMA 3

> **Guide de référence technique pour porter le scénario « La Légion [FrenchPoint] » sur n'importe quelle carte d'Arma 3 (Altis, Malden, Stratis, Livonia, Chernarus, Takistan, Cam Lao Nam, etc.).**  
> *Grâce à l'architecture procédurale du projet, 95% des scripts fonctionnent de manière 100% autonome et agnostique du terrain. Seuls quelques réglages spécifiques (nom du dossier, marqueurs Eden, filtres d'altitude, identités des civils et mentions textuelles) sont à adapter.*

---

## 📑 SOMMAIRE

1. [Principe Fondamental & Architecture Portable](#1-principe-fondamental--architecture-portable)
2. [Étape 1 : Nommage du Dossier & Extension Terrain](#2-étape-1--nommage-du-dossier--extension-terrain)
3. [Étape 2 : Configuration dans l'Éditeur Eden (Unités & Marqueurs)](#3-étape-2--configuration-dans-léditeur-eden-unités--marqueurs)
4. [Étape 3 : Fichiers SQF à Adapter (Points Techniques Critiques)](#4-étape-3--fichiers-sqf-à-adapter-points-techniques-critiques)
5. [Étape 4 : Adaptation Intégrale des Civils & Ennemis (Tenues, Visages, Voix et Noms)](#5-étape-4--adaptation-intégrale-des-civils--ennemis-tenues-visages-voix-et-noms)
6. [Étape 5 : Adaptation des Textes & Localisation (XML / Stringtable)](#6-étape-5--adaptation-des-textes--localisation-xml--stringtable)
7. [Étape 6 : Métadonnées de Mission (description.ext & Images)](#7-étape-6--métadonnées-de-mission-descriptionext--images)
8. [Check-list Récapitulative Pas-à-Pas (10 Minutes)](#8-check-list-récapitulative-pas-à-pas-10-minutes)

---

## 1. PRINCIPE FONDAMENTAL & ARCHITECTURE PORTABLE

Le scénario a été développé selon un standard modulaire strict :
* **Génération dynamique des objectifs :** Les cibles (véhicules chimiques, officiers HVT, otages, blindés Tigris, documents secrets, relais) ne sont **jamais** posées en dur dans l'éditeur. Elles sont spawnées dynamiquement à l'intérieur des bâtiments existants du terrain sélectionné par script.
* **Zone d'atterrissage (LZ) procédurale :** Aucun héliport n'est préplacé. L'algorithme scanne le relief en temps réel pour trouver une clairière plate, sans arbre ni rocher, et y fait poser le Ghosthawk.
* **Arsenal & Véhicule d'escouade :** La caisse d'arsenal et le VLTT P4 sont générés automatiquement à proximité immédiate de la LZ calculée.
* **Systèmes transversaux :** La météo aléatoire, les ordres d'engagement (R.O.E), les secours médicaux autonomes, le support aérien CAS, le drone MQ-12 Falcon et l'extraction fonctionnent partout sans retouche.

---

## 2. ÉTAPE 1 : NOMMAGE DU DOSSIER & EXTENSION TERRAIN

Dans Arma 3, le nom d'un dossier de mission détermine la carte sur laquelle elle se charge :
```text
NomDeLaMission.<NomInterneDuTerrain>
```

### Table des Noms Internes des Terrains Populaires :
| Terrain | Type d'Environnement | Nom du dossier cible à créer |
| :--- | :--- | :--- |
| **Tanoa** (Apex) | Jungle tropicale insulaire | `La Legion [FrenchPoint].Tanoa` |
| **Altis** (Vanilla) | Mer Méditerranée (très vaste, aride) | `La Legion [FrenchPoint].Altis` |
| **Stratis** (Vanilla) | Mer Méditerranée (île militaire compacte) | `La Legion [FrenchPoint].Stratis` |
| **Malden** (Vanilla) | Méditerranée / Atlantique (vallonné) | `La Legion [FrenchPoint].Malden` |
| **Livonia** (Contact) | Forêt d'Europe de l'Est tempérée | `La Legion [FrenchPoint].Enoch` *(Attention au nom technique !)* |
| **Chernarus 2020** (CUP) | Forêts et collines post-soviétiques | `La Legion [FrenchPoint].cup_chernarus_A3` |
| **Takistan** (CUP) | Désert montagneux moyen-oriental | `La Legion [FrenchPoint].Takistan` |
| **Cam Lao Nam** (S.O.G.) | Jungle du Sud-Est asiatique | `La Legion [FrenchPoint].vn_the_nam` ou `.vn_khe_sanh` |

### Procédure :
1. Faites un simple **Copier-Coller** du dossier entier de la mission dans votre répertoire `missions/`.
2. Renommez le dossier en remplaçant `.Tanoa` par la nouvelle extension (exemple : `La Legion [FrenchPoint].Altis`).
3. Ouvrez Arma 3 et chargez la mission dans l'éditeur Eden sur ce nouveau terrain.

---

## 3. ÉTAPE 2 : CONFIGURATION DANS L'ÉDITEUR EDEN (UNITÉS & MARQUEURS)

Une fois la mission ouverte sur le nouveau terrain dans l'éditeur Eden, seuls **deux éléments** sont à placer : les 6 soldats et les marqueurs de sites.

### 3.1. Les 6 Unités Jouables (Groupe Alpha 1-1)
Placez un groupe de 6 soldats de l'armée française (classes OFrP recommandées : treillis CE, FÉLIN, béret vert).  
Dans le champ **Variable Name** de chaque unité, renseignez scrupuleusement :

| Unité dans Eden | Variable Name | Rôle Opérationnel | Configuration Lobby |
| :--- | :--- | :--- | :--- |
| Soldat 1 (Chef) | `player_0` | Chef de groupe (Commandant d'escouade) | **Joueur** (Player) |
| Soldat 2 (TP) | `player_1` | Tireur de précision (HK417) | **Jouable** (Playable) |
| Soldat 3 (FM) | `player_2` | Fusilier-mitrailleur (Minimi / Mag) | **Jouable** (Playable) |
| Soldat 4 (Medic)| `player_3` | Infirmier de combat | **Jouable** (Playable) |
| Soldat 5 (Radio)| `player_4` | Opérateur transmissions & drone | **Jouable** (Playable) |
| Soldat 6 (AT) | `player_5` | Spécialiste antichar (Eryx / AT4CS) | **Jouable** (Playable) |

> ⚠️ **Important :** Ne placez aucun objet de spawn (héliport invisible, caisse, etc.). Le code gère l'insertion et l'arsenal dynamiquement.

---

### 3.2. Les 5 Familles de Marqueurs d'Objectifs (De 1 à 99 et au-delà)
Le moteur `LL_fnc_prepareMissionSites` scanne automatiquement la carte et prend en charge **tous les marqueurs numérotés de 1 à 99** (et même au-delà : l'algorithme valide tout identifiant dont le numéro est supérieur à 0 via `parseNumber > 0`).

Dans Eden, placez des marqueurs d'aire (**Ellipse** ou **Rectangle**) aux endroits stratégiques de votre nouvelle carte en renseignant le champ **Name** (l'identifiant unique) :

| Famille | Identifiants gérés par le code | Type d'Environnement | Où les placer sur la nouvelle carte ? |
| :---: | :--- | :--- | :--- |
| **A** | `marker_A_1` à `marker_A_99` | **Villages & Zones Urbaines** | Villes, hameaux civils, zones résidentielles. |
| **B** | `marker_B_1` à `marker_B_99` | **Littoral & Côtes** | Plages, criques, ports, ou rives fluviales (ou oasis en désert). |
| **C** | `marker_C_1` à `marker_C_99` | **Nature & Relief** | Forêts, collines boisées, clairières, maquis ou vallées isolées. |
| **D** | `marker_D_1` à `marker_D_99` | **Infrastructures Militaires** | Bases, antennes radio, usines désaffectées, dépôts de carburant. |
| **E** | `marker_E_1` à `marker_E_99` | **Sites Complémentaires** | Ruines, campements de fortune, carrières, postes de contrôle. |

#### Règles d'or pour le placement des marqueurs :
1. **Dimensions :** Donnez une taille réaliste à l'ellipse dans Eden (par exemple 80x80 m pour un hameau, 150x150 m pour un village ou une base).
2. **Présence de bâtiments :** Chaque marqueur doit englober **au moins 2 ou 3 bâtiments habitables** du décor de la carte (les documents secrets, l'otage et le baron HVT apparaissent à l'intérieur des maisons existantes).
3. **Quantité libre (Illimitée) :** Vous pouvez placer autant de marqueurs que vous le désirez par famille (`marker_A_1` jusqu'à `marker_A_99`). Plus vous en placez, plus la rejouabilité sera immense ! Sur Tanoa par exemple, il y a déjà des marqueurs jusqu'à `marker_E_23` (23 sites dans la famille E). Recommandation : placez **au minimum 2 ou 3 marqueurs par famille** pour laisser du choix au générateur.
4. **Marqueurs de secteur (`zone_*`) :** Si la nouvelle carte comporte des îles distinctes sans pont (comme Altis avec l'île principale et de petits îlots, ou Stratis), tracez un grand marqueur rectangulaire `zone_principal` recouvrant les sites reliés par la route pour que l'algorithme ne sélectionne que des objectifs accessibles à pied ou en P4.

---

## 4. ÉTAPE 3 : FICHIERS SQF À ADAPTER (POINTS TECHNIQUES CRITIQUES)

Il n'y a que **deux fichiers SQF** contenant des paramètres spécifiques à la géographie de Tanoa :

### 4.1. Fichier `Functions/Task/fn_prepareMissionSites.sqf` (Filtre d'Altitude LZ)
* **Localisation :** Vers la ligne 25 du fichier.
* **Code actuel (calibré pour le littoral de Tanoa) :**
  ```sqf
  private _centerH = getTerrainHeightASL _candidate;
  if (_centerH > 95 || { _centerH < 3 }) exitWith { false };
  ```
* **Pourquoi le modifier ?**  
  Sur Tanoa, les collines côtières dépassent rarement 95 mètres. Mais sur **Altis**, **Livonia** ou **Takistan**, l'altitude moyenne du sol peut se situer entre **150 m et 1200 m au-dessus du niveau de la mer** !  
  Si vous ne modifiez pas cette ligne sur Takistan ou Livonia, l'algorithme rejettera toutes les clairières car leur altitude dépasse 95 m, provoquant un échec au démarrage.
* **Modification recommandée pour un terrain continental / montagneux :**
  ```sqf
  private _centerH = getTerrainHeightASL _candidate;
  if (_centerH < 1) exitWith { false };
  ```
  *(Cette condition simple empêche simplement la LZ de spawner dans l'eau ou sous le niveau de la mer, tout en acceptant n'importe quelle altitude de plateau ou de montagne).*

---

### 4.2. Fichier `Functions/Task/fn_intro_D.sqf` (Sous-titre du Théâtre de Guerre)
* **Localisation :** Vers la ligne 39 du fichier.
* **Code actuel :**
  ```sqf
  <t size='0.85' color='#94A3B8' font='PuristaLight'>ARCHIPEL DU PACIFIQUE SUD // ZONE HOSTILE</t>
  ```
* **Modification à apporter :** Adaptez le texte à la région du globe correspondante :
  * **Pour Altis / Stratis / Malden :**  
    `<t size='0.85' color='#94A3B8' font='PuristaLight'>BASSIN MÉDITERRANÉEN // SECTEUR INSULAIRE</t>`
  * **Pour Livonia (Enoch) / Chernarus :**  
    `<t size='0.85' color='#94A3B8' font='PuristaLight'>EUROPE DE L'EST // ZONE FORESTIÈRE DÉLÉGUÉE</t>`
  * **Pour Takistan / Kunduz :**  
    `<t size='0.85' color='#94A3B8' font='PuristaLight'>MOYEN-ORIENT // THÉÂTRE DÉSERTIQUE & VALLÉES</t>`
  * **Pour Cam Lao Nam :**  
    `<t size='0.85' color='#94A3B8' font='PuristaLight'>SUD-EST ASIATIQUE // JUNGLE & FLEUVES</t>`

---

## 5. ÉTAPE 4 : ADAPTATION INTÉGRALE DES CIVILS & ENNEMIS (TENUES, VISAGES, VOIX ET NOMS)

Le scénario intègre un moteur de population procédurale (`fn_ambientCivilians.sqf`, `fn_spawnPresence.sqf`, `fn_applyTakistaniIdentity.sqf` et `fn_initTakistaniDB.sqf`).  
Ce moteur attribue à chaque civil et ennemi une identité complète : **classe 3D, prénom/nom, visage, voix, tenue vestimentaire et chapeau**.

### 5.1. Fonctionnement Automatique (Auto-Détection du Terrain)
Dans `Functions/Civilian/fn_initTakistaniDB.sqf`, le script analyse la variable native du moteur Arma 3 :
```sqf
private _terrain = toLower worldName;
```
Le système charge automatiquement le profil culturel correspondant au terrain actif :
* **Sur Tanoa (`worldName == "tanoa"`) :** Identités polynésiennes et françaises du Pacifique (fini les tenues et noms moyen-orientaux inadaptés !).
* **Sur Altis / Stratis / Malden :** Population grecque et méditerranéenne.
* **Sur Livonia (`enoch`) :** Population rurale d'Europe de l'Est (polonaise).
* **Sur Takistan :** Population du Moyen-Orient en dishdashas et turbans.

> 🛡️ **Sécurité anti-crash :** Toutes les classes d'uniformes, chapeaux et unités sont filtrées dynamiquement avec `isClass (configFile >> "CfgVehicles" >> _x)`. Si un joueur ou un serveur ne possède pas un DLC particulier, le moteur bascule automatiquement sur les classes équivalentes de base sans aucune erreur de script.

---

### 5.2. Table de Référence Complète par Terrain

| Terrain | Classes Civiles Recommandées | Visages (`setFace`) | Voix (`setSpeaker`) | Exemple de Noms Générés | Tenues & Couvre-chefs Typiques |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Tanoa** (Apex) | `C_Man_casual_1_F_tanoan` à `6_F_tanoan`, `C_man_sport_1_F_tanoan` à `3_F_tanoan`, `C_Man_casual_shorts_F`, `C_man_w_worker_F`, `C_Man_Fisherman_01_F` | `TanoanHead_A3_01` à `09`, `AfricanHead_01` à `03`, `AsianHead_A3_01` à `07`, `WhiteHead_01` à `10` | `Male01FRE` à `03FRE` (Français), `Male01ENGFRE` à `02ENGFRE`, `Male01ENG` | *Hommes :* Aluna Babitu, Atonio Ganilau, Eloni Koroi, Lucas Mara, Maui Naivalu, Tane Rambuka, Teiva Nakaunicina, Jean-Baptiste Duvuduvukulu.<br/>*Femmes :* Moana Delai, Vaite Ganilau, Hina Lomu, Mareva Serevi, Leilani Naivalu, Chloe Chavez. | Chemises à fleurs tropicales (`U_C_Man_casual_1_F` à `6_F`), sportswear, polos colorés, shorts.<br/>Chapeaux de paille (`H_StrawHat`, `H_StrawHat_dark`), casquettes surfer, bobs jungle, tête nue. |
| **Altis / Stratis / Malden** | `C_man_1`, `C_man_polo_1_F` à `6_F`, `C_man_shorts_1_F` à `4_F`, `C_man_w_worker_F` | `GreekHead_A3_01` à `09`, `WhiteHead_01` à `20` | `Male01GRE` à `06GRE` (Grec) | Nikos Gekas, Stavros Doukas, Petros Kouris, Dimitrios Thanou, Kostas Lyras, Alexandros Metaxas. | Poloshirts bleu/bordeaux/saumon, shorts beiges, chemises légères d'été.<br/>Chapeaux de paille, casquettes de baseball, casquettes de marin. |
| **Livonia** (`Enoch`) | `C_Man_1_enoch_F`, `C_Farmer_01_enoch_F`, `C_man_w_worker_F` | `LivonianHead_1` à `10`, `WhiteHead_01` à `20` | `Male01POL` à `03POL` (Polonais), `Male01RUS` | Jan Nowak, Tomasz Kowalski, Michal Wisniewski, Piotr Wojcik, Krzysztof Kaminski. | Vêtements de fermier (`U_C_Uniform_Farmer_01_F`), vestes en cuir de pillard (`U_C_E_LooterJacket_01_F`), pulls chauds ruraux.<br/>Bonnets en laine (`H_Watchcap_blk`), casquettes de travail. |
| **Takistan** (CUP / Desert) | `C_man_1`, `C_man_p_beggar_F`, `C_man_w_worker_F` (ou `CUP_C_TK_Man_01`) | `PersianHead_A3_01` à `03`, `TakistaniHead_01` à `03` | `Male01PER` à `03PER` (Persan / Farsi) | Ali Mohamed, Said Abdallah, Mohamed Bacar, Nassim Soumaila, Fahad Toihir, Ibrahim Nassur. | Robes orientales, dishdashas traditionnelles, tuniques amples.<br/>Chèches (`H_Shemag_olive`, `H_ShemagOpen_tan`), turbans (`H_Turban_01`). |
| **Chernarus** (CUP) | `C_man_1`, `C_Man_casual_1_F` (ou `CUP_C_C_Worker_01`) | `RussianHead_1` à `5`, `WhiteHead_01` à `20` | `Male01RUS` à `03RUS` (Russe) | Alexei Ivanov, Dmitri Smirnov, Ivan Popov, Sergei Kuznetsov, Mikhail Sokolov. | Vestes matelassées, blousons en cuir, casquettes plates, chapkas. |
| **Cam Lao Nam** (S.O.G.) | Classes civiles vietnamiennes (`vn_c_men_*`) | `AsianHead_A3_01` à `07` | Voix vietnamiennes du DLC S.O.G. | Nguyen Van Duc, Tran Van Nam, Le Van Phuc, Pham Van Thang, Vo Van Kiet. | Pyjamas paysans traditionnels noirs ou beiges, tenues rurales d'Indochine.<br/>Chapeaux coniques en paille, bandanas. |

---

### 5.3. Comment Personnaliser Manuellement une Faction ou une Carte Spécifique
Si vous souhaitez définir une faction civile personnalisée ou un mod tiers (CUP Civilians, CFP, RHS) :
1. Ouvrez `Functions/Civilian/fn_initTakistaniDB.sqf`.
2. Repérez la section de votre terrain ou ajoutez un bloc `if (_terrain == "votre_carte") then { ... }`.
3. Vous pouvez modifier directement les 6 tableaux fondamentaux :
   * `MISSION_CivilianClasses_Male` : Les modèles 3D d'hommes créés dans les rues.
   * `MISSION_CivilianNames_Male` : Les listes de noms sous la forme `["Prénom Nom", "Prénom", "Nom"]`.
   * `MISSION_CivilianMaleFaces` : Les textures de visages appliquées via `setFace`.
   * `MISSION_Voices_Male` : Les profils vocaux du fichier `CfgVoice` assignés via `setSpeaker`.
   * `MISSION_CivilianUniforms_Male` : Les vêtements civils assignés avec `forceAddUniform`.
   * `MISSION_CivilianHats` : Les chapeaux (laissez `""` dans la liste pour autoriser les civils nu-tête).
   * `MISSION_EnemyUniforms_Male` : Les tenues des rebelles / gardes d'objectifs (sur Tanoa : paramilitaires et bandits du Syndikat).

---

## 6. ÉTAPE 5 : ADAPTATION DES TEXTES & LOCALISATION (XML / STRINGTABLE)

Pour que les titres de cinématique et les briefings affichent le nom de votre nouvelle carte (au lieu de « Tanoa »), le projet utilise des fragments XML compilés dans `stringtable.xml`.

### 6.1. Titre Cinématique dans `Functions\Taskn_intro_A.xml`
Ouvrez `Functions\Taskn_intro_A.xml` :
* Clé `STR_LL_Intro_Theatre` :
  * Actuel : `THÉÂTRE D'OPÉRATIONS — TANOA`
  * Remplacer par : `THÉÂTRE D'OPÉRATIONS — ALTIS` (ou le nom de votre terrain).
* Clé `STR_LL_Intro_Location` :
  * Actuel : `13 Mars 2019 — Tanoa`
  * Remplacer par : `13 Mars 2019 — Altis`

### 6.2. Briefing et Ordres d'Opération dans `Functions\Briefingn_initContext.xml`
Dans ce fichier, remplacez les mentions narratives de Tanoa et du cartel du Syndikat par le contexte local souhaité (ex: forces séparatistes sur Altis, insurgés au Takistan, rebelles du LDF sur Livonia).

### 6.3. Recompilation Automatique de la Base Multilingue
Dès que vous avez modifié les fragments XML, exécutez la commande suivante à la racine de la mission :
```cmd
python compile_stringtable.py
```
*Le script fusionne automatiquement l'ensemble des traductions dans `stringtable.xml` en préservant les 15 langues prises en charge.*

---

## 7. ÉTAPE 6 : MÉTADONNÉES DE MISSION (description.ext & IMAGES)

Ouvrez le fichier `description.ext` à la racine de la mission :

```sqf
briefingName = "MISSION LÉGION ÉTRANGÈRE - ALTIS";
onLoadName = "MISSION LÉGION ÉTRANGÈRE";
onLoadMission = "Altis — Opérations de la Légion Étrangère (SP / COOP 1-6 + IA)";
author = "Friart Script";
overviewText = "Altis — Opérations de la Légion Étrangère. Solo & Coop 1-6. Sécurisation du secteur et neutralisation des menaces.";
```

### Images de Présentation :
Vous pouvez remplacer si vous le souhaitez :
* `loadScreen.jpg` : Image affichée pendant le chargement (format 2:1 ou 16:9, ex: 1024x512 ou 1920x1080).
* `overviewPicture.jpg` : Image affichée dans la liste des scénarios d'Arma 3.

---

## 8. CHECK-LIST RÉCAPITULATIVE PAS-À-PAS (10 MINUTES)

Voici la marche à suivre synthétique pour exporter le projet en moins de 10 minutes :

- [ ] **1. Dupliquer le dossier :** Copier le dossier et le renommer avec la nouvelle extension terrain (ex: `La Legion [FrenchPoint].Altis`).
- [ ] **2. Placer le groupe dans Eden :** Ouvrir la carte dans Eden, placer 6 soldats et nommer leurs variables `player_0`, `player_1`, `player_2`, `player_3`, `player_4`, `player_5`.
- [ ] **3. Placer les marqueurs de sites :** Disposer des ellipses de sites (de `marker_A_1` à `marker_A_99`, `marker_B_1` à `marker_B_99`, etc. — placez-en autant que vous voulez de 1 à 99, avec au minimum 2 ou 3 par famille) sur des zones contenant des bâtiments.
- [ ] **4. Ajuster l'altitude LZ (`fn_prepareMissionSites.sqf`) :** Remplacer le filtre `_centerH > 95 || { _centerH < 3 }` par `_centerH < 1` si la carte est en altitude ou montagneuse.
- [ ] **5. Modifier le sous-titre de l'intro (`fn_intro_D.sqf`) :** Remplacer `"ARCHIPEL DU PACIFIQUE SUD"` par la région géographique appropriée.
- [ ] **6. Vérifier le profil des civils (`fn_initTakistaniDB.sqf`) :** Le script auto-détecte le terrain (`Altis`, `Livonia`, `Takistan`, etc.). Si c'est une carte moddée inconnue, vérifiez les classes et tenues dans `fn_initTakistaniDB.sqf`.
- [ ] **7. Mettre à jour `description.ext` :** Modifier le nom de la mission dans `briefingName`, `onLoadMission` et `overviewText`.
- [ ] **8. Mettre à jour les titres XML :** Modifier `STR_LL_Intro_Theatre` dans `Functions/Task/fn_intro_A.xml` puis lancer `python compile_stringtable.py`.
- [ ] **9. Sauvegarder et tester :** Sauvegarder dans Eden (touche Ctrl+S) et lancer la prévisualisation !
