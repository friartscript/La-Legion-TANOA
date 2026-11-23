# Audit & Recommandations Techniques : Ce qui manque réellement dans votre Mission
*Diagnostic personnalisé pour : La Légion [FrenchPoint] — Tanoa (Arma 3)*

Ce document ne contient aucun conseil généraliste. Il s'appuie sur l'analyse approfondie de votre code source, de votre `description.ext`, de votre `mission.sqm` et de votre architecture de scripts, pour lister **exclusivement ce qui manque ou ce qui doit être amélioré** dans votre mission avant sa publication sur le Steam Workshop.

---

## Sommaire des Points Critiques Détectés

1. [Absence de `cba_settings.sqf` (Harmonisation obligatoire pour ACE3)](#1-absence-de-cba_settingssqf-harmonisation-obligatoire-pour-ace3)
2. [Écrans de Fin et Débriefing manquants (`CfgDebriefing` dans `description.ext`)](#2-écrans-de-fin-et-débriefing-manquants-cfgdebriefing-dans-descriptionext)
3. [Métadonnées Multijoueur manquantes dans `description.ext` (`class Header`)](#3-métadonnées-multijoueur-manquantes-dans-descriptionext-class-header)
4. [Gestion du Respawn / JIP (Join In Progress) pour le mode Coopératif](#4-gestion-du-respawn--jip-join-in-progress-pour-le-mode-coopératif)
5. [Bug structurel dans `fn_switchToAI.sqf` (Tireur Eryx exclu et Chef bloqué)](#5-bug-structurel-dans-fn_switchtoaisqf-tireur-eryx-exclu-et-chef-bloqué)
6. [Absence totale de Sauvegardes Automatiques en Solo (`saveGame`)](#6-absence-totale-de-sauvegardes-automatiques-en-solo-savegame)
7. [Gestion des Carcasses et Cadavres (Maintien des FPS sur Tanoa)](#7-gestion-des-carcasses-et-cadavres-maintien-des-fps-sur-tanoa)
8. [Nettoyage des fichiers de développement avant compilation du `.pbo`](#8-nettoyage-des-fichiers-de-développement-avant-compilation-du-pbo)

---

## 1. Absence de `cba_settings.sqf` (Harmonisation obligatoire pour ACE3)

### Le Constat Réel dans votre Mission :
Votre mission s'appuie fortement sur ACE3 (soins, flous, dégâts), mais **aucun fichier `cba_settings.sqf` n'existe à la racine de la mission**.

### Pourquoi c'est un problème majeur sur le Workshop :
Lorsqu'un abonné Steam lance votre mission, ACE3 applique **ses propres réglages personnels** (ceux configurés dans son menu local d'Arma 3) :
- Si un joueur a activé le médical avancé avec fractures chirurgicales et arrêt cardiaque en 30 secondes, votre mission deviendra injouable pour lui car vous n'avez pas prévu de chirurgien ni de kit de suture lourd dans les sacs.
- Si un autre joueur a désactivé le recul ou mis la visée des IA ennemies à 100 %, l'équilibrage que vous avez testé chez vous sera totalement faussé.

### Ce qu'il faut faire :
Dans l'éditeur 3den, allez dans **Options des addons (CBA) > Exporter vers la mission** ou créez un fichier `cba_settings.sqf` à la racine contenant vos choix verrouillés (en particulier : niveau médical ACE3, arrêt cardiaque désactivé ou rallongé, coefficient de dispersion de l'IA). Cela garantit que tous les joueurs vivront la même expérience équilibrée.

---

## 2. Écrans de Fin et Débriefing manquants (`CfgDebriefing` dans `description.ext`)

### Le Constat Réel dans votre Mission :
Vos scripts appellent des fins de mission formelles :
- Dans `fn_extraction.sqf` : `[_endType, _win, 5] remoteExec ["BIS_fnc_endMission", 0];` (avec `End1` en cas de succès, `End2` en cas d'échec partiel).
- Dans `fn_heliManager.sqf` : `["MissionSuccess", true, true] call BIS_fnc_endMission;`.
- Dans `fn_switchToAI.sqf` : `failMission "LOSER";` si toute l'escouade est morte.

Cependant, votre `description.ext` ne contient **aucune classe `CfgDebriefing`**.

### Pourquoi c'est un problème :
Lorsque la mission se termine, Arma 3 affiche un écran de fin générique noir/gris, sans titre, sans sous-titre explicatif et sans l'insigne de la Légion.

### Ce qu'il faut ajouter dans `description.ext` :
```ext
class CfgDebriefing
{
    class End1
    {
        title = "$STR_LL_Debrief_Win_Title";
        subtitle = "$STR_LL_Debrief_Win_Sub";
        description = "$STR_LL_Debrief_Win_Desc";
        pictureBackground = "overviewPicture.jpg";
        picture = "Images\001.png";
        pictureColor[] = {1, 1, 1, 1};
    };
    class End2
    {
        title = "$STR_LL_Debrief_Fail_Title";
        subtitle = "$STR_LL_Debrief_Fail_Sub";
        description = "$STR_LL_Debrief_Fail_Desc";
        pictureBackground = "overviewPicture.jpg";
        picture = "Images\001.png";
        pictureColor[] = {1, 0.3, 0.3, 1};
    };
    class LOSER: End2 {};
    class MissionSuccess: End1 {};
};
```

---

## 3. Métadonnées Multijoueur manquantes dans `description.ext` (`class Header`)

### Le Constat Réel dans votre Mission :
Votre `description.ext` commence par :
```ext
briefingName = "MISSION LÉGION ÉTRANGÈRE";
onLoadName = "MISSION LÉGION ÉTRANGÈRE";
...
disabledAI = 0;
```
La classe standard `Header` est complètement absente.

### Pourquoi c'est un problème :
Dans le navigateur de serveurs Steam et dans l'écran de salon multijoueur :
- Le mode de jeu apparaît comme **`Unknown`** au lieu de **`COOP`**.
- Le nombre de joueurs est affiché avec un point d'interrogation (`?`) au lieu de `1 - 6`.

### Ce qu'il faut ajouter au sommet de `description.ext` :
```ext
class Header
{
    gameType = Coop;
    minPlayers = 1;
    maxPlayers = 6;
};
```

---

## 4. Gestion du Respawn / JIP (Join In Progress) pour le mode Coopératif

### Le Constat Réel dans votre Mission :
Vous avez conçu la mission pour être jouable en Solo (SP) ET en Coopératif (COOP 1-6).
- En Solo, votre script `LL_fnc_switchToAI` permet de basculer sur une IA vivante lors d'une élimination.
- Mais en Multijoueur, votre `description.ext` n'a **aucune directive de respawn** (`respawn`, `respawnDelay`, `respawnTemplates`).

### Pourquoi c'est un problème :
Si 2 à 6 joueurs jouent en COOP sur un serveur :
- Quand un joueur humain meurt, il n'y a pas d'IA libre pour faire un `selectPlayer`.
- Sans directive de respawn, Arma 3 bascule le joueur éliminé sur la vieille caméra "mouette" (seagull) ou le fige sur son corps sans possibilité de revenir en jeu ou d'observer ses coéquipiers proprement.
- Un joueur qui rejoint en cours de partie (JIP) ne sait pas où spawner.

### Ce qu'il faut ajouter dans `description.ext` :
```ext
respawn = 3; // BASE
respawnDelay = 30;
respawnDialog = 0;
respawnOnStart = -1;
respawnTemplates[] = {"MenuPosition", "Spectator"};
```
Et associer un marqueur `respawn_west` placé au niveau de la LZ de départ ou lié dynamiquement au véhicule d'équipe `vehicule_team`.

---

## 5. Bug structurel dans `fn_switchToAI.sqf` (Tireur Eryx exclu et Chef bloqué)

### Le Constat Réel dans votre Mission :
Dans `Functions\Team\fn_switchToAI.sqf` (ligne 17), vous écrivez :
```sqf
private _allPlayersVars = ["player_0", "player_1", "player_2", "player_3", "player_4", "player_5"];
```
Or, l'analyse binaire de votre `mission.sqm` montre la composition réelle des soldats :
1. Le Chef de section : **n'a pas de nom de variable** (c'est le leader du groupe).
2. Tireur de précision HK 417 : **`player_2`**
3. Mitrailleur 7,62 : **`player_3`**
4. Infirmier : **`player_4`**
5. Opérateur Radio : **`player_5`**
6. Tireur AC ERYX : **`player_6`**

### Deux bugs concrets provoqués par cette ligne :
1. **Le Tireur Eryx (`player_6`) est ignoré :** Si vous mourez, le système ne basculera JAMAIS sur `player_6` car il n'est pas dans votre tableau `_allPlayersVars`.
2. **Le Chef de section est perdu après un switch :** Comme le Chef n'a pas de variable nommée `player_0` ou `player_1`, si vous mourez et passez sur `player_3`, et que `player_3` meurt à son tour alors que le Chef est toujours vivant, le script ne verra pas le Chef et déclarera la mission perdue alors qu'il reste un soldat !

### La solution :
Ne pas coder en dur des variables dans un tableau, mais tester directement les survivants du groupe :
```sqf
private _livingUnits = (units (group _deadUnit)) select { alive _x && _x != _deadUnit };
```
Cette correction rend le switch 100 % fiable quel que soit le soldat éliminé.

---

## 6. Absence totale de Sauvegardes Automatiques en Solo (`saveGame`)

### Le Constat Réel dans votre Mission :
L'audit complet des 66 fichiers SQF montre que la commande `saveGame` n'apparaît **absolument nulle part**.

### Pourquoi c'est un défaut d'ergonomie majeur :
Votre scénario propose une succession de 6 tâches dynamiques (sauvetage d'otage, destruction de Kamaz, HVT, documents, etc.). Une partie solo dure en moyenne entre 45 et 90 minutes.
Si un joueur solo meurt ou subit un plantage au bout de 50 minutes à la 5e tâche, il doit impérativement **recommencer toute la mission depuis le début**. C'est la première cause d'abandon et d'avis négatifs sur le Workshop.

### Ce qu'il faut ajouter :
Insérer un point de contrôle automatique à la fin de chaque tâche validée (par exemple dans `fn_taskCleanup.sqf` ou lors de chaque `SUCCEEDED`) :
```sqf
if (!isMultiplayer) then {
    saveGame;
};
```
*(En multijoueur, la commande est ignorée sans erreur. En solo, elle crée un point de sauvegarde instantané).*

---

## 7. Gestion des Carcasses et Cadavres (Maintien des FPS sur Tanoa)

### Le Constat Réel dans votre Mission :
La végétation de Tanoa est la plus lourde de tout Arma 3 en termes d'appels de rendu (Draw Calls). Au fur et à mesure que les tâches s'enchaînent :
- Des dizaines de miliciens et gardes du cartel sont abattus.
- Des camions, buggies et quads sont détruits.
- Actuellement, aucun gestionnaire moteur de corps (`corpseManager`) n'est activé dans votre `description.ext`.

### Pourquoi c'est un problème :
Au bout d'une heure de jeu, la carte accumule tous les débris et cadavres, ce qui provoque une baisse progressive des images par seconde (chute de FPS) chez les joueurs, même avec de bonnes cartes graphiques.

### Ce qu'il faut ajouter dans `description.ext` :
Activer les paramètres natifs d'Arma 3 pour nettoyer automatiquement l'arrière-plan sans aucun script lourd :
```ext
corpseManagerMode = 1;
corpseLimit = 12;
corpseRemovalMinTime = 120;
corpseRemovalMaxTime = 300;

wreckManagerMode = 1;
wreckLimit = 4;
wreckRemovalMinTime = 180;
wreckRemovalMaxTime = 360;
```

---

## 8. Nettoyage des fichiers de développement avant compilation du `.pbo`

### Le Constat Réel dans votre Dossier :
À la racine de votre mission se trouvent actuellement des scripts Python utilitaires et des notes de travail :
- `compile_stringtable.py`
- `convert_images.py`
- `check_sqf.py`
- `fix_switch_blur.py`
- `fix_pp_error.py`
- `ANALYSE.md`, `ETAPES.md`, `PROMPT.md`, `INFO_TANOA.md`, etc.

### Pourquoi c'est un problème :
Lorsque vous exportez votre mission en fichier `.pbo` (via 3den ou via l'outil Addon Builder / Publisher), ces fichiers de travail se retrouvent empaquetés à l'intérieur du `.pbo`. Cela alourdit inutilement le téléchargement pour les abonnés Steam et expose vos scripts de maintenance internes.

### Ce qu'il faut faire :
Déplacez vos scripts Python et fichiers de notes markdown de travail dans un dossier externe ou un sous-dossier non exporté avant de générer le PBO final destiné au Workshop.

---

### Résumé des 4 actions prioritaires à coder :

| Priorité | Action | Fichier concerné | Impact joueur |
| :---: | :--- | :--- | :--- |
| **P0** | Corriger le switch IA pour inclure `player_6` et le Chef | `Functions\Team\fn_switchToAI.sqf` | Évite le Game Over injustifié |
| **P1** | Ajouter `class Header` et `class CfgDebriefing` | `description.ext` | Débriefing de victoire/défaite propre + affichage COOP 06 |
| **P2** | Ajouter les réglages de Respawn / JIP | `description.ext` | Jouabilité multijoueur garantie en cas de mort |
| **P3** | Ajouter `saveGame` et le ramasse-miettes de corps | `description.ext` & Tâches | Confort solo (points de contrôle) + FPS stables sur Tanoa |
