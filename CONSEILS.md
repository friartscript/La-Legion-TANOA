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

## 4. Gestion du Revive et Mort Permanente en Coopératif [RÉGLÉ]

### Choix de Conception Appliqué :
- **Système de Revive Natif Arma 3 :** Activé pour tous les joueurs en multijoueur (`ReviveMode = 1;`).
- **Accessibilité Totale :** Aucun kit médical ni trait d'infirmier requis pour réanimer un allié à terre (`ReviveRequiredItems = 0;`, `ReviveRequiredTrait = 0;`). L'infirmier réanime cependant 2x plus vite.
- **Mort Définitive (Permadeath) :** Si un joueur saigne jusqu'au bout ou force sa mort, il ne réapparaît pas sur la carte (`respawnDelay = 999999;`).
- **Caméra Spectateur Native :** Les joueurs éliminés basculent immédiatement en spectateur natif Arma 3 (`respawnTemplates[] = {"Revive", "Spectator"};`) pour suivre leurs coéquipiers vivants en vue libre, 1ère personne ou 3ème personne.
- **Séparation Solo / Coop :** En Solo, le joueur continue de basculer automatiquement sur une IA de son escouade (`fn_switchToAI.sqf`). En Coop, le script n'interfère pas et laisse le système de spectateur opérer proprement.

---

## 5. Gestion Dynamique de l'Escouade SP et COOP sans Conflit [RÉGLÉ]

### Le Constat Réel et Résolution :
L'analyse de `mission.sqm` et des scripts a révélé que les 6 soldats de l'escouade étaient hétérogènes :
1. Le Chef de section (Sergent) n'avait pas de variable `player_0`.
2. Le Tireur AC ERYX portait la variable `player_6`.
3. Plusieurs scripts utilisaient des boucles fixes de `0 à 5`, excluant le Chef et `player_6` de l'armement, des munitions héliportées, de l'identité et de la réattribution de rôle.

### Corrections Appliquées dans toute la Mission :
- **Séparation Stricte SP / COOP dans `fn_switchToAI.sqf` :** En multijoueur, le script s'arrête immédiatement (`if (isMultiplayer) exitWith {};`), laissant le système de réanimation et de spectateur opérer sans voler le contrôle d'une unité. En Solo, le switch sélectionne dynamiquement n'importe quel survivant du groupe (Chef, Eryx, Tireur, Mitrailleur, Infirmier, Radio).
- **Transfert Immédiat des Capacités en Solo :** Le soldat incarné reçoit instantanément le commandement (`selectLeader`), les actions de règles d'engagement (RoE), le menu des 5 appuis radios (Héli, Drone, Munitions, Véhicule, CAS) et l'activation de la tâche en cours.
- **Fin de Mission Harmonieuse :** En Solo, la mort du dernier soldat déclenche un travelling arrière cinématique et l'écran de défaite. En Coop, si tous les joueurs et IA sont éliminés, le serveur déclenche proprement le débriefing d'échec après un délai de 8 secondes.
- **Harmonisation des Rôles et Munitions :** Les caisses de largage héliporté (`fn_heliManager.sqf`), le coffre du véhicule de départ (`fn_initVehicleLoadout.sqf`), les rechargements (`fn_reloadWeapons.sqf`) et l'équipement (`fn_initLoadout.sqf`) prennent désormais en compte dynamiquement les 6 membres du groupe.

---

## 6. Sauvegardes Automatiques à chaque Début et Fin de Task [RÉGLÉ]

### Choix et Implémentation :
- **Fonction Dédiée `LL_fnc_saveProgress` ([fn_saveProgress.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/La%20Legion%20[FrenchPoint].Tanoa/Functions/Task/fn_saveProgress.sqf)) :** Sauvegarde automatiquement la partie en solo (`saveGame;`) avec un filtre anti-doublon (debounce) de 3 secondes pour éviter les écritures disques redondantes.
- **Message Log Multilingue :** Affiche un message instantané dans le log de chat du joueur (`systemChat`) indiquant la confirmation de la sauvegarde.
- **Traduction Complète 14 Langues ([fn_saveProgress.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/La%20Legion%20[FrenchPoint].Tanoa/Functions/Task/fn_saveProgress.xml) & `stringtable.xml`) :** Traduit dans toutes les langues officielles d'Arma 3 conformément à `INFO_STRINTABLE.md` (`STR_LL_Progress_Saved` : « Progression sauvegardée », « Progress saved », etc.).
- **Points de Contrôle Intégrés :**
  1. À chaque début de déplacement d'étape (`_moveId` créé).
  2. À chaque fin de déplacement d'étape (`_moveId` validé).
  3. À chaque début de mission de combat (`taskCreate` : Otage, Chimique, Documents, HVT, Tigris, Transmission).
  4. À chaque fin de mission de combat (neutralisation de la cible et succès de l'objectif).
  5. Au début de l'extraction par hélicoptère.
  6. À la fin de l'extraction lors de la validation du succès final.

---

## 7. Gestion des Carcasses et Cadavres (Maintien des FPS sur Tanoa) [RÉGLÉ]

### Paramètres de Nettoyage Moteur Intégrés dans `description.ext` :
- **Gestionnaire de Cadavres (`corpseManager`) :**
  - `corpseManagerMode = 1;` : Active le ramassage automatique pour tous les corps d'ennemis abattus.
  - `corpseLimit = 15;` : Limite maximale de 15 cadavres simultanés sur la carte. Au-delà, le moteur supprime en priorité les plus anciens.
  - `corpseRemovalMinTime = 120;` : Durée minimale de 2 minutes pour permettre aux joueurs de fouiller les corps (munitions, soins, documents).
  - `corpseRemovalMaxTime = 300;` : Disparition garantie après 5 minutes pour préserver les performances.
- **Gestionnaire d'Épaves (`wreckManager`) :**
  - `wreckManagerMode = 1;` : Active le ramassage automatique des carcasses de véhicules détruits (Ural DCA, buggies, quads, camionnettes).
  - `wreckLimit = 5;` : Seules 5 épaves maximum sont conservées simultanément.
  - `wreckRemovalMinTime = 180;` : Maintien de l'épave pendant au moins 3 minutes pour l'ambiance et la fumée.
  - `wreckRemovalMaxTime = 420;` : Suppression automatique après 7 minutes.
- **Préservation de l'Immersion Joueur :**
  - `minPlayerDistance = 50;` : Aucun cadavre ni épave ne peut disparaître sous les yeux d'un joueur à moins de 50 mètres. Le moteur attend que les joueurs s'éloignent pour opérer la suppression en arrière-plan.

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

### Bilan de mise en conformité Workshop :

| Priorité | Action | Fichier concerné | Statut |
| :---: | :--- | :--- | :---: |
| **P0** | Corriger le switch IA pour inclure `player_6` et le Chef | `Functions\Team\fn_switchToAI.sqf` | **[TERMINÉ]** |
| **P1** | Ajouter `class Header` et `class CfgDebriefing` | `description.ext` | **[TERMINÉ]** |
| **P2** | Ajouter les réglages de Revive natif, Spectateur & Permadeath | `description.ext` | **[TERMINÉ]** |
| **P3** | Ajouter `saveGame` automatique et le ramasse-miettes moteur | `description.ext` & Tâches | **[TERMINÉ]** |
| **P4** | Description Steam Workshop FR/EN & dépendance ACE | `INFO_STEAM.md` | **[TERMINÉ]** |
