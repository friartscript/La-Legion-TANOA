# Analyse — restauration de la logique originale et correction des bugs

Mission : **Mission Légion Étrangère / La Légion [FrenchPoint]** sur Tanoa, SP/COOP 1 à 6 joueurs, équipement OFrP, ACE3 facultatif.
Référence fonctionnelle : le projet original `C:\Users\kevin\Downloads\La-Legion-FrenchPoint` (fonctionnel, sans bug, avec CUP et un menu de lancement).
Plan de développement et critères de validation : [`ETAPES.md`](./ETAPES.md). Règles de codage : [`PROMPT.md`](./PROMPT.md).

## 1. Règles non négociables

1. **La logique de la mission originale est la référence et reste intacte.** Séquence : insertion musicale → déploiement sur la LZ → tâche « Se rendre sur les lieux » → objectif → enchaînement → extraction.
2. **Seules trois familles de changement sont autorisées**, chacune justifiée par l'objectif du développeur :
   - remplacer les classes CUP et tiers par des classes OFrP ou vanilla vérifiées dans les fichiers du jeu ;
   - remplacer le menu de lancement par un démarrage automatique côté serveur qui produit exactement les mêmes entrées que le menu (marqueur cible, LZ, tâches) ;
   - remplacer le choix manuel de 1 à 3 tâches sur un seul site par un plan automatique de **2 ou 3 objectifs séquentiels sur des sites A/B/C/D/E distincts**, la mission de secours d'otage étant toujours la dernière.
3. **Aucune simplification.** Interdit : supprimer une phase de cinématique, remplacer une classe par un substitut « qui passe », ajouter un repli silencieux, contourner une erreur en retirant la fonctionnalité, ajouter une attente qui fige un écran noir. Toute adaptation conserve le comportement d'origine et le même niveau de finition.
4. **Un défaut se traite par sa cause racine**, démontrée par le RPT, une comparaison avec l'original ou une vérification dans les fichiers du jeu, jamais par une hypothèse non testée.
5. **Seul le développeur valide en jeu.** Aucun jalon n'est considéré corrigé tant qu'il n'a pas été testé par lui dans Arma 3.

## 2. Mesure des écarts entre l'original et le dossier de travail

Comparaison automatique ligne à ligne de tous les `Functions\**\*.sqf` :

| Catégorie | Fichiers |
|---|---|
| **Identiques à l'original** (38) | `fn_intro_02_new`, `fn_taskA`, `fn_taskB`, `fn_taskBonus`, `fn_taskC`, `fn_task_generator`, `fn_taskCleanup`, `fn_taskD_documents`, `fn_taskD_hvt`, `fn_taskD_transmission`, `fn_taskD_chemical_01`, `fn_taskD_chemical_03`, `fn_spawnStartArsenal`, `fn_subtitles_legion`, `fn_extraction_secure`, `fn_initVehicleLoadout`, `fn_addTaskAction`, `fn_ambientCivilians`, `fn_rebelAmbush`, `fn_spawnPresence`, `fn_initContext`, `fn_initSkills`, `fn_preventWater`, `fn_randomWeather`, `fn_doorSecurity`, `fn_aiHealSelf`, `fn_initSupport`, `fn_droneDispatch`, `fn_addHealAction`, `fn_applyIdentity` (Player), `fn_initIdentity`, `fn_initLocal`, `fn_addRoeActions`, `fn_applyRoE`, `fn_badgeManager`, `fn_reloadWeapons`, `fn_switchToAI`, `fn_radioMessage` |
| **Modifiés par la migration CUP → OFrP/vanilla** (légitime) | `fn_applyLoadout`, `fn_initLoadout`, `fn_randomizeLoadout`, `fn_addResupplyAction`, `fn_heliManager`, `fn_heliDispatch`, `fn_droneManager`, `fn_extraction`, `fn_taskD_chemical`, `fn_taskD_chemical_02`, `fn_taskD_tigris`, `fn_intro_02`, `fn_identityManager` |
| **Modifiés par les sessions précédentes et à corriger** | `fn_intro_01` (substitutions et attentes fautives), `fn_taskManager` (déviation de logique), `fn_taskD_captive` (gardes de marqueur + `diag_log`), `fn_initBriefing` (plan d'opération à adapter aux jetons) |
| **Ajoutés par les sessions précédentes** | `fn_prepareMissionSites`, `fn_selectOperation`, `fn_startOperation`, `fn_nearestPlayerLZ`, `fn_ambientAnimal` (remplace `fn_ambientSheep`), `fn_applyIdentityBroadcast` (renomme `Team/fn_applyIdentity`) |
| **Absents du dossier de travail** | `fn_initTakistaniDB`, `fn_applyTakistaniIdentity`, `fn_secureOpforLanguage`, `fn_playEzan`, `fn_ambientSheep`, `fn_spawn_main_menu` |

Fichiers racine absents du dossier de travail : `init.sqf`, `CfgSounds.hpp`, `Dialogs\main_menu.hpp`, et tout le contenu de `description.ext` hors `CfgFunctions` (en-tête de mission, `CfgCommunicationMenu`, `CfgMusic`, `CfgUnitInsignia`, `RscTitles`).

**Conclusion :** presque toutes les fonctions sont présentes et identiques. Les défauts viennent de **l'orchestration** (le rôle de `init.sqf` et du menu n'a jamais été reconstruit fidèlement), de **trois fonctions manquantes**, d'un **`description.ext` tronqué** et de **retouches incorrectes** de `fn_intro_01`, `fn_taskManager` et `fn_taskD_tigris`.

## 3. Chaîne originale à préserver

### 3.1 Démarrage (`init.sqf`)

Toutes machines : `LL_fnc_initTakistaniDB` (appel synchrone), `initSkills`, exécution de `fn_initIdentity` et `fn_initLoadout`.

Serveur : `randomWeather`, `heliManager`, `droneManager`, `doorSecurity`, `playEzan`, `aiHealSelf`, `preventWater`, `identityManager`.

Client : protection de l'escouade (`allowDamage false`, cote 5000, `HandleRating`), **`titleCut BLACK FADED` immédiat**, puis ouverture du menu. Après `MISSION_intro_finished` : `reloadWeapons`, boucle de cycle de vie du joueur (`HandleRating`, `Respawn`, `Killed` → `switchToAI`, `addRoeActions`, `initSupport`, `initBriefing`, `initContext`, tâche courante).

### 3.2 Lancement (branche `LAUNCH` du menu)

1. Lecture de la sélection : tâches (`TASK_*`), marqueur cible, insertion `HELI`, embuscade rebelle (décochée par défaut).
2. Réglage de l'heure, de la nébulosité et du brouillard.
3. **Tous les marqueurs `marker_*` passent à `alpha 0` sauf la cible.**
4. Calcul de la LZ : marqueur à ≥ 900 m de la cible, le plus proche de cette limite.
5. `[marqueur, LZ, classe véhicule] spawn LL_fnc_intro_01`.
6. `ambientCivilians` ×2 (LZ et cible), `ambientSheep` ×2, `rebelAmbush` si activée.
7. `[marqueur, insertion, tâches] spawn LL_fnc_task_generator`.

### 3.3 Introduction (`fn_intro_01`) — chronologie qui doit rester exacte

| Instant (s) | Événement |
|---|---|
| 0 | Fondu noir, création du véhicule d'équipe à `LZ + 18 m` (est), arsenal, escouade `moveInCargo` dans l'hélicoptère spawné à 1 500 m, altitude 110 m, `doMove` vers la LZ, `limitSpeed 160` |
| 0 → 10 | Plan haut, `playMusic "Legion_001"` (ou `playSound "Sound_Legion_001"` si le volume musique est nul), sous-titres, titre « MISSION LÉGION ÉTRANGÈRE » |
| 10.11 → 19.18 | Plan de suivi de l'hélicoptère, annonce du lieu et de l'heure |
| 19.48 | Ouverture des portes, `flyInHeight 65`, `limitSpeed 140` |
| 30.03 | Plan porte ouverte |
| **39.42** | **`land "GET OUT"`**, caméra au sol |
| 51.77 / 61.33 | Plans au sol de l'hélicoptère posé |
| **71.56** | `moveOut`, téléportation de l'escouade autour du véhicule (`setPosATL`) |
| 80.58 | Fin de caméra, jonction de groupe, `allowDamage true` |
| 90.72 | Sous-titre de début de mission, `MISSION_intro_finished = true` |

Les sous-titres (`fn_subtitles_legion`) sont calés sur les mêmes instants (10.11, 19.48, 30.03, 39.42…) et utilisent la classe `RscTitles >> LL_Legion_Subtitles`. **Toute attente ajoutée dans cette chronologie la désynchronise.**

### 3.4 Chaîne de tâches

| Étape | Fonction | Comportement |
|---|---|---|
| +5 s après l'intro | `taskC` | Crée `task_mandatory_ext` (extraction en toute sécurité), résolue à l'extraction selon la survie de l'escouade |
| +15 s | `taskA` | Crée **`task_mandatory_move` « Se rendre sur les lieux »** vers le site, attend un joueur à < 800 m, lance `secureOpforLanguage`, passe la tâche à `SUCCEEDED`, puis appelle `taskB` |
| +2,5 s | `taskB` | Crée `task_mandatory_civ` (protéger les civils), surveille `EntityKilled`, remet à zéro `LL_logic_occupied`/`LL_g_usedTaskPos`, lance chaque objectif (+5 s entre deux), puis `taskBonus` |
| | `taskBonus` | Attend la fin des objectifs, révèle un autre site, annonce l'urgence, crée `task_bonus_move` (500 m), lance un objectif supplémentaire |
| | Extraction | **Manuelle** : menu de soutien (0-8), `heliDispatch` → `heliManager` → `extraction_secure` → `LL_g_extractionStarted` |

L'extraction automatique ajoutée par les sessions précédentes dans `fn_taskManager` **n'existe pas dans l'original** et doit disparaître.

## 4. Bugs observés, cause racine et correction

Chaque cause est appuyée par une preuve : **[RPT]** journal Arma, **[DIFF]** comparaison avec l'original, **[PBO]** recherche dans les fichiers du jeu et d'OFrP, **[CAPTURE]** capture du développeur.

| # | Symptôme observé | Cause racine | Correction |
|---|---|---|---|
| B1 | Escouade visible au sol quelques secondes avant l'intro | `init.sqf` n'existe plus : le `titleCut BLACK FADED` immédiat de l'original n'est jamais appliqué avant que le serveur ait préparé l'opération **[DIFF]** | Recréer `init.sqf` (§5.1) avec le noir immédiat côté client et `allowDamage false` sur l'escouade |
| B2 | Écran noir prolongé « sans raison » en pleine introduction | Une attente `waitUntil` que j'ai insérée juste après `land "GET OUT"` s'exécutait pendant la coupure noire des plans 4 → 5 **[DIFF]** | Retirer toute attente de la chronologie ; rendre l'hélicoptère déterministe (§5.3) |
| B3 | Musique et sous-titres désynchronisés | Même attente (décalage de `_t0`) ; en plus `RscTitles >> LL_Legion_Subtitles` et `CfgSounds >> Sound_Legion_001` sont absents de `description.ext`, donc les sous-titres tombent dans un chemin de secours **[DIFF]** | Restaurer `RscTitles`, `CfgSounds.hpp`, `CfgMusic` avec le gain d'origine (`db+3`) et la condition de volume d'origine |
| B4 | Largage hors de l'hélicoptère, hors LZ, sans véhicule ni caisse à proximité | Trois facteurs combinés : (a) l'hélicoptère vanilla est spawné sans vitesse initiale et arrive après 39,42 s ; `land "GET OUT"` le pose donc à sa position courante, loin de la LZ ; (b) l'héliport invisible sur lequel l'original se posait (`Heliport_*`) a été supprimé ; (c) `moveOut` à 71,56 s s'exécute même si l'appareil n'est pas au sol | Vitesse initiale cohérente, héliport invisible **créé à l'exécution** sur la LZ, recalage invisible pendant la coupure noire de 39,42 s si l'appareil est à plus de 60 m, recalage au sol avant `moveOut` (§5.3). *Cause à confirmer en jeu : hypothèse la plus probable, pas une certitude.* |
| B5 | Départ à 14 km puis 9 km de la mission | La LZ était tirée au hasard parmi **tous** les marqueurs elliptiques de Tanoa **[RPT]** : `LZ de départ [11582.8,2151.77,0] (marker_D_2)` alors que l'escouade Eden est vers `[4400,3900]` | LZ dérivée de la position réelle de l'escouade Eden (déjà corrigé) ; `LL_g_startLZ` et `MISSION_intro_lz` alimentent `intro_01` (§5.2) |
| B6 | « Se rendre sur les lieux » a disparu | Les sessions précédentes ont remplacé `task_generator → taskA → taskB → taskBonus` par `startOperation → taskManager`, qui lance directement l'objectif sans la tâche de déplacement, la tâche civile ni la tâche d'extraction **[DIFF]** | Rebrancher la chaîne originale ; `startOperation` devient l'équivalent exact du `LAUNCH` du menu (§5.2) |
| B7 | Erreur à l'ouverture de Tigris, Documents, HVT… (`LL_fnc_applyTakistaniIdentity` indéfinie) | La fonction, `initTakistaniDB` et `secureOpforLanguage` ne sont pas dans le dossier de travail ni dans `CfgFunctions` **[DIFF] [CAPTURE]** ; `taskA` appelle aussi `secureOpforLanguage` | Porter les trois fonctions sans CUP ni TCGM (§5.4) |
| B8 | Tigris : véhicules AA jamais créés | `Cannot create non-ai vehicle 'O_Truck_02_aa_F'` **[RPT]** : cette classe **n'existe pas** dans Arma 3 ni OFrP **[PBO]** ; elle a été inventée lors de la migration de `CUP_O_Ural_ZU23_TKM` | Utiliser une classe vanilla vérifiée : `O_APC_Tracked_02_AA_F` (CSAT « Tigris ») **[PBO]** ; supprimer le repli `marker_0` |
| B9 | Support hélicoptère, drone, météo, compétences, identités, loadouts, ROE jamais actifs | Les appels de `init.sqf` (§3.1) n'ont jamais été reportés ; `heliManager`, `droneManager`, `randomWeather`, `doorSecurity`, `aiHealSelf`, `preventWater`, `identityManager`, `initSkills` ne sont lancés nulle part | Recréer `init.sqf` (§5.1) |
| B10 | Menu de soutien radio (0-8) absent | `CfgCommunicationMenu` n'est plus dans `description.ext` | Restaurer `CfgCommunicationMenu` |
| B11 | Points intérieurs jamais créés, opération annulée | `createVehicle ["Logic"]` est refusé par le moteur : `Unexpected call of CreateVehicle for 'Logic'` **[RPT]** | Déjà corrigé : `createUnit` dans un groupe `sideLogic` |
| B12 | Tous les marqueurs de site visibles sur la carte | L'original met tous les `marker_*` à `alpha 0` sauf la cible **[DIFF]** | Reproduire dans `startOperation` ; révélation progressive des sites (§5.2) |
| B13 | Extraction déclenchée automatiquement | Ajout de `fn_taskManager` absent de l'original | Restaurer `fn_taskManager` d'origine ; extraction manuelle |
| B14 | Risque de casse des modules d'autres mods | `fn_prepareMissionSites` supprime **tous** les objets `Logic` et héliports de la mission, y compris ceux d'ACE, CBA ou d'autres mods | Restreindre la suppression aux objets situés dans l'aire d'un marqueur de site |
| B15 | Véhicule d'équipe remplacé par un offroad | Ma retouche de `fn_intro_01` : substitution d'une classe valide **[PBO : `OFrP_P4_FR_CE` existe]** | Revenir à `OFrP_P4_FR_CE`, sans substitut |
| B16 | Erreurs de script à l'arrivée sur la LZ | Enchaînement des erreurs B7 dès le démarrage des tâches, au moment où l'écran noir se lève | Corrigé par B7 et B8 |

## 5. Architecture cible

### 5.1 `init.sqf` (nouveau, portage fidèle de l'original)

Reprend l'ordre du §3.1. Différences contrôlées :
- `LL_fnc_spawn_main_menu` est remplacé par `[] spawn LL_fnc_startOperation` côté serveur ;
- `LL_fnc_playEzan` et `MISSION_var_debug` ne sont pas repris (appel à la prière absent du contexte, variable de debug interdite par `PROMPT.md`) ;
- côté client, le **noir est appliqué en premier**, avant toute autre instruction ;
- `initServer.sqf` et `initPlayerLocal.sqf` sont supprimés : ils dupliquaient une partie de `init.sqf` et faisaient exécuter deux fois les initialisations en SP.

### 5.2 `fn_startOperation` — équivalent du `LAUNCH`

Exécution serveur, une seule fois, séquentielle :

1. attendre `time > 0` et un joueur vivant ;
2. `LL_fnc_prepareMissionSites` : LZ de départ, sites candidats, points intérieurs des sites retenus ;
3. `LL_fnc_selectOperation` : plan `LL_g_operationPlan` ;
4. mettre **tous** les `marker_*` à `alpha 0` sauf le premier site ; `MISSION_var_targetPos` ← position du premier site ;
5. `[premierSite, LZ, classe véhicule] spawn LL_fnc_intro_01` ;
6. `ambientCivilians` ×2, `ambientAnimal` ×2, `rebelAmbush` désactivée par défaut comme dans le menu ;
7. `[premierSite, "HELI", [jeton de la première tâche]] spawn LL_fnc_task_generator`.

Un serveur dédié est refusé explicitement tant que le jalon COOP n'est pas validé : la cinématique est locale au client.

### 5.3 `fn_intro_01` — original + adaptations strictement nécessaires

Le fichier original est restauré tel quel, puis :

| Adaptation | Raison |
|---|---|
| Classe véhicule par défaut `OFrP_P4_FR_CE` | Véhicule tout-terrain français standard |
| Classe hélicoptère `B_Heli_Transport_01_F` | Hélicoptère d'insertion Ghost Hawk |
| `_destPos` ← LZ calculée par `prepareMissionSites` | Remplace la recherche d'héliports Eden et de `marker_0` |
| Héliport invisible `Land_HelipadEmpty_F` créé sur `_destPos`, supprimé en fin d'intro | Rétablit le point d'atterrissage précis que fournissait l'objet `Heliport_*` |
| `setVelocityModelSpace [0, 42, 0]` au spawn | Évite la phase d'accélération depuis zéro qui retarde l'arrivée |
| À 39,42 s, **pendant la coupure noire** : si l'hélicoptère est à plus de 60 m de la LZ, le replacer à 25 m au-dessus de la LZ, vitesse nulle, puis `land "GET OUT"` | Coupure cinématographique : invisible, aucune attente, chronologie intacte |
| À 71,56 s, **pendant la coupure noire** : si l'appareil est à plus de 2 m du sol, le poser sur l'héliport avant `moveOut` | Interdit toute éjection en vol |
| Retrait de `marker_0` | Plus de repli silencieux |

Conservé à l'identique : plans caméra, titres, sous-titres, effets, `playMusic`/`playSound` conditionnel, `allowDamage`, jonction de groupe, `MISSION_intro_finished`.

### 5.4 Fonctions civiles portées sans CUP ni TCGM

| Fonction | Contenu conservé | Contenu remplacé |
|---|---|---|
| `fn_initTakistaniDB` | Noms, visages, scan de `CfgFaces`/`CfgVehicles`/`CfgWeapons`, listes de tenues, gilets, couvre-chefs, lunettes, armes de bandits | Voix `CUP_D_*_CZ` → `Male01PER`…`Male03PER` ; toutes les listes filtrées par `isClass` ; tokens `tcgm` et entrées `CUP_*` supprimés |
| `fn_applyTakistaniIdentity` | Logique complète civils/ennemis, genre, tenue, équipement, `Killed` | Détection de genre sans `tcgm` ; voix par défaut ; aucune voix féminine vanilla : la liste reste vide et l'unité garde sa voix |
| `fn_secureOpforLanguage` | Boucle de 30 s, voix forcées pour les unités OPFOR | Voix `CUP_D_*_CZ` → voix vanilla vérifiées |

**Vérification [PBO] :** `Male01FRE`, `Male01PER` existent ; `Female01GRE` et `Female01FRE` n'existent pas.

### 5.5 Plan d'opération et séquencement

Contrat de données : `LL_g_operationPlan = [["TASK_XXX", "marker_F_N"], …]` avec les jetons de l'original (`TASK_DOCUMENTS`, `TASK_TRANSMISSION`, `TASK_CHEMICAL`, `TASK_HVT`, `TASK_TIGRIS`, `TASK_CAPTIVE`).

Règles :
- 2 ou 3 objectifs, un par site, une famille A/B/C/D/E par site ;
- le premier site est à ≥ 950 m (`distance2D`) de `MISSION_intro_lz` ;
- le deuxième est le site valide le plus proche du premier, le troisième le plus proche du deuxième, sans seuil de 950 m entre eux ;
- trois sites impossibles → opération à deux ; moins de deux → erreur explicite, aucune opération partielle ;
- **`TASK_CAPTIVE` est toujours le dernier objectif** (2ᵉ ou 3ᵉ) ;
- les autres objectifs sont tirés sans répétition parmi les cinq restants.

Enchaînement, conforme à l'original :
- `task_generator` → `taskC` et `taskA` **inchangés** ;
- `taskA` mène au premier site, `taskB` lance **uniquement le premier objectif** ;
- `taskBonus` est réécrit pour parcourir **les étapes suivantes du plan** en conservant ses mécanismes : attente de fin de l'objectif courant, +4 s, révélation du marqueur, tâche de déplacement, remise à zéro de `LL_logic_occupied` et `LL_g_usedTaskPos`, suppression de l'ancienne tâche, création de l'objectif, tâche courante. Étape intermédiaire : textes « Se rendre sur les lieux » (800 m). Étape finale (otage) : message « mission d'urgence » et textes d'urgence (500 m) ;
- extraction manuelle par le menu de soutien.

## 6. Classes et dépendances — vérifié dans les fichiers du jeu

| Classe | Résultat | Décision |
|---|---|---|
| `O_Truck_02_aa_F`, `I_Truck_02_aa_F` | **Absentes** | Ne jamais utiliser |
| `O_APC_Tracked_02_AA_F` | Présente | AA de Tigris |
| `B_Heli_Transport_01_F` | Présente | Hélicoptère d'insertion et de soutien |
| `OFrP_P4_FR_CE` | Présente (`ofrp_a3_p4`, `ofrp_a3_characters`, `ofrp_a3_wheeled`) | Véhicule d'équipe |
| `Land_HelipadEmpty_F` | Présente (`structures_f_mil`) | Héliport invisible d'exécution |
| `Male01FRE`, `Male01PER` | Présentes | Voix escouade / civils et OPFOR |
| `Female01GRE`, `Female01FRE` | **Absentes** | Liste féminine vide |

Modules OFrP installés : `aanf1`, `characters`, `milan`, `mod`, `p4`, `static`, `structures`, `vehicles_weapons`, `vps2`, `weapons`, `wheeled`. Aucun hélicoptère OFrP n'a été identifié par le nom des modules.

## 7. Qualité du code

`PROMPT.md` exige : aucun commentaire, aucun `diag_log`, `hint`, `hintSilent` ni `systemChat`, indentation propre, autorité serveur, initialisation locale côté client.

Tout le **nouveau code** respecte ces règles dès l'écriture. Le **code existant** contient des violations (commentaires dans de nombreux scripts de tâches, `diag_log` dans `prepareMissionSites`, `selectOperation`, `startOperation`, `extraction`, `initBriefing`, `taskD_captive`, `initLoadout`, `randomizeLoadout`, `spawnStartArsenal` avec `systemChat`). Elles sont traitées au dernier jalon, **sans modifier la logique**.

## 8. Décisions ouvertes

1. **Hélicoptère d'insertion :** `B_Heli_Transport_01_F` (Ghost Hawk) est le substitut vanilla de l'UH-60L. Un hélicoptère OFrP serait préférable s'il existe.
2. **Insigne :** `fn_badgeManager` applique `OFrP_TFLafayette_01` (Task Force Lafayette) conformément à la demande utilisateur.
3. **Appel à la prière** (`fn_playEzan`, `ezan.ogg`) : non repris, le contexte Tanoa/OFrP ne le justifie pas.
4. **Date et Météo :** Date opérationnelle fixée au 13 mars 2019 (cohérence avec les dotations d'équipement OFrP 2019 CE). Heure aléatoire de mission entre 06h00 et 19h30 et profils météo dynamiques contrôlés (brouillard max 20 %).
5. **COOP :** l'introduction est une cinématique locale. Elle reste exécutée sur l'hôte tant que le jalon COOP n'est pas traité.
6. **Lore :** univers Légion Étrangère / Syndikat conservé dans les textes tant que le développeur ne décide pas d'une nouvelle trame.
