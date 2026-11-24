# ⚔️ LA LÉGION [FrenchPoint] — TANOA

<div align="center">

![Arma 3](https://img.shields.io/badge/Arma%203-Scenario%20%5BSP%2FCOOP%201--6%20%2B%20IA%5D-blue?style=for-the-badge&logo=arma)
![DLC](https://img.shields.io/badge/DLC%20Required-Apex%20%28Tanoa%29-yellow?style=for-the-badge)
![Engine](https://img.shields.io/badge/Engine-Real%20Virtuality%204-red?style=for-the-badge)
![Mods](https://img.shields.io/badge/Mods-OFrP%20%7C%20ACE3%20optionnel-orange?style=for-the-badge)
![Localization](https://img.shields.io/badge/Localization-15%20Languages-green?style=for-the-badge)
![Author](https://img.shields.io/badge/Author-Friart%20Script-purple?style=for-the-badge)

**Scénario d'action tactique militaire Solo (SP) & Coopératif (COOP 1 à 6 joueurs), conçu pour Operation FrenchPoint (OFrP) avec compatibilité optionnelle ACE3, génération procédurale d'objectifs rapprochés et immersion totale.**

[Vue d'Ensemble](#-vue-densemble) • [Contexte Stratégique](#-contexte-stratégique--lore) • [Introduction Cinématique](#-cinématique-dintroduction-dynamique) • [Fonctionnalités Clés](#-fonctionnalités-majeures) • [Catalogue des Opérations](#-catalogue-des-opérations-dynamiques) • [Commandement & R.O.E](#-commandement-descouade--règles-dengagement) • [Installation & Dépendances](#-installation--dépendances) • [Architecture Technique](#-architecture-technique-du-projet)

---

</div>

<br/>

## 🎯 Vue d'Ensemble

**La Légion [FrenchPoint]** est une mission tactique militaire d'élite conçue pour offrir une immersion totale aux commandes d'un groupe de combat de la **Légion Étrangère**, jouable en **Solo (SP)** comme en **Coopération (COOP de 1 à 6 joueurs)** sur l'archipel tropical de **Tanoa**.

En multijoueur, les coéquipiers IA sont automatiquement disponibles pour compléter l'effectif si vous jouez en comité restreint (les slots d'IA peuvent être librement activés ou désactivés par l'hôte dans le salon d'affectation des rôles).

Équipé des dotations réelles de l'armée française issues du mod **Operation FrenchPoint (OFrP)** (fusils d'assaut HK416, véhicules légers tout-terrain VLTT P4, missiles antichars Eryx, treillis camouflage Centre-Europe et bérets verts), votre groupe est héliporté au cœur de la jungle pour accomplir une suite d'opérations chirurgicales à haute intensité.

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  DÉMARRAGE IMMÉDIAT ──► INSERTION TACTIQUE ──► 2 OU 3 OBJECTIFS EN SÉQUENCE  │
│  (Génération auto)      (Cinématique A à H)    (Clustering max 2 000 m)      │
│                                                                │             │
│  FIN DE MISSION ◄──────────── EXTRACTION HÉLIPORTÉE ◄──────────┘             │
│  (Debriefing complet)         (Soutien UH-80 CAS & Évacuation)               │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 🌍 Contexte Stratégique & Lore

### 1. La Peste Verte sur Tanoa (13 Mars 2019)
L'archipel insulaire de **Tanoa** est devenu la plaque tournante du narcotrafic international et du trafic d'armes lourdes. Profitant de la densité végétale et du relief volcanique, le cartel mafieux du **Syndikat** a verrouillé l'île : raffineries clandestines de solvants toxiques, batteries antiaériennes DCA pour interdire l'espace aérien, réseaux de communication cryptés et camps de détention d'otages.

### 2. Le Mandat d'Action Directe de la Légion
Face à l'urgence opérationnelle, la **Légion Étrangère** est déployée pour démanteler les infrastructures critiques du cartel :
* **Détruire la bulle de déni d'accès aérien DCA** (blindés Tigris) pour rétablir les corridors de vol.
* **Sécuriser les cargaisons de produits chimiques** avant leur dispersion dans l'archipel.
* **Fouiller les campements pour saisir les documents et registres secrets** des chefs de guerre.
* **Éliminer les cibles d'intérêt prioritaire (HVT)** et saboter les relais hertziens clandestins.
* **Secourir les otages captifs** et neutraliser les geôliers sans dommage collatéral.
* **Préserver impérativement la population civile locale** (échec immédiat de mission en cas de victime civile).

---

## 🎬 Cinématique d'Introduction Dynamique

L'introduction du scénario a été intégralement découpée en **8 séquences immersives (A à H)** synchronisées sur l'ensemble du réseau (voir le dossier d'expertise détaillé [`FN_INTRO.md`](./FN_INTRO.md)) :

```
[Seq A] Immersion Intérieure Carlingue (Face à face avec les légionnaires à hauteur des yeux)
   │     Cut franc (Raccord musical sur le verset 3)
[Seq B] Reveal Extérieur & Titre Tricolore MISSION LÉGION ÉTRANGÈRE
   │     Cut raccord dans l'axe
[Seq C] Vol Tactique Rase-Canopée (Portes ouvertes & tireurs en alerte)
   │     Cut franc
[Seq D] Zone d'Engagement — Archipel de Tanoa (Panorama géographique Pacifique Sud)
   │     Cut franc sur amorce d'obstacle
[Seq E] Approche en Descente Continue (Téléobjectif longue focale au sol sur la LZ)
   │     Cut franc
[Seq F] Ressource & Décélération (Flare et souffle rotor au-dessus de la LZ dégagée)
   │     Cut raccord d'action
[Seq G] Touchdown sur l'Héliport (Posé net des patins sur le terrain de la LZ)
   │     Travelling vers le véhicule P4
[Seq H] Départ du Vecteur Aérien & Prise en Main Joueur (Fondu d'armement 1ère personne)
```

### Atouts Clés du Moteur Cinématographique :
* **Synchronisation Réseau Parfaite (Host & Clients) :** Séparation stricte de l'environnement physique (piloté côté serveur) et des effets visuels/caméras (générés localement sur chaque machine avec interface). Aucun écran noir, quel que soit le statut de connexion du client.
* **Embarquement Garanti de l'Escouade :** Téléportation synchronisée de l'ensemble des membres (joueurs et IA) dans les sièges cargo de l'appareil à l'insertion sans risque d'exclusion.
* **Incarnation Subjective Immédiate :** La cinématique démarre directement dans l'allée centrale de la cabine, cadrée à hauteur des yeux face aux visages et paquetages des légionnaires, avec vue sur la jungle qui défile à pleine vitesse par les portes latérales.
* **Montage Cut de Cinéma Professionnel :** Élimination totale des flous répétés (*whips*) au profit de coupes franches et de raccords de mouvement synchronisés aux mesures du chant officiel de la Légion.
* **Typographie Militaire Épurée :** Titrages équilibrés en tiers d'écran préservant le champ de vision, avec liseré tricolore sobre et prestige français.
* **Approche et Poser 100% Sécurisés :** Vol continu de l'appareil verrouillé sur l'axe de la LZ sans aucune dérive en forêt, depuis le vol de croisière jusqu'au poser des patins sur l'héliport dégagé.
* **Anti-Collision Sol et Obstacles (`LL_fnc_findOpenCamSpot`) :** Analyse en temps réel du relief, des troncs d'arbres, rochers et bâtiments pour positionner la caméra dans une zone dégagée avec ligne de vue garantie.
* **Filet de Sécurité Visuel :** Sortie garantie de la cinématique avec restauration instantanée de la vue subjective interne (`INTERNAL`), suppression des bandes noires et réactivation du son plein volume dès la fin de séquence.

---

## ⚡ Fonctionnalités Majeures

### 📍 1. Regroupement Procédural des Objectifs (Clustering & Plafond 2 000 m)
* **Dynamisme Tactique Garanti :** Fini les traversées kilométriques fastidieuses ! Dès le choix de la LZ d'insertion, le moteur d'objectifs sélectionne la mission suivante dans un **rayon maximal de 2 000 mètres (2 km)**.
* **Algorithme de Proximité Prioritaire :** Les sites disponibles sont automatiquement triés par ordre de distance croissante pour privilégier les zones de contact les plus cohérentes et proches.
* **Système de Repli Adaptatif (4 Paliers de Sécurité) :** Si aucun secteur éligible n'est disponible sous 2 000 m, le moteur élargit intelligemment sa recherche (2 000 m → 3 000 m → 4 500 m → illimité), garantissant 100% de fiabilité de génération sans blocage de mission.
* **Rejouabilité Infinie :** Emplacements des objectifs, garnisons ennemies, patrouilles de jungle, météo dynamique et points d'extraction changent à chaque partie.

### 👥 2. Multijoueur Coopératif Réseau Robuste (COOP 1 à 6)
* **Architecture Client/Serveur Éprouvée :** Gestion sans faille en Listen Server (Hôte + Clients) et Serveur Dédié.
* **Attribution Intelligente du Leadership dès le Salon :**
  * Si un joueur humain choisit le rôle de Chef d'équipe (`player_0`), il conserve **inconditionnellement** le commandement du groupe.
  * Si aucun joueur humain ne sélectionne le slot chef (laissé à une IA), le moteur désigne **un joueur humain connecté au hasard** comme chef d'escouade opérationnel.
* **Escouade Complète Permanente :** En multijoueur, si vous jouez à 2 ou 3 amis, les rôles restants peuvent être occupés par des IA de soutien coordonnées.
* **Contrôle Total dans le Salon :** L'hôte peut activer ou désactiver les IA selon ses préférences avant de lancer la partie.
* **Actions Partagées sur le Terrain :** Toutes les interactions critiques d'objectifs (désamorçage/pose d'explosifs, libération d'otages, fouille de renseignements) sont partagées sur le réseau 3D et exécutables par n'importe quel équipier.

### 🎖️ 3. Chaîne de Commandement & Succession Dynamique (0-8)
* **Appuis Réservés au Chef de Groupe :** Les ordres stratégiques de niveau commandement (Appui Aérien CAS, Largage de ravitaillement, Drone de reconnaissance MQ-12, Évacuation/Extraction) sont strictement réservés au joueur occupant la fonction de chef d'escouade (`leader group player == player`).
* **Succession Immédiate au Combat :** Si le chef de groupe tombe au combat ou est neutralisé, le commandement passe instantanément au soldat suivant selon l'ordre hiérarchique, et l'accès complet au menu d'appui radio lui est automatiquement transféré en moins de **1,5 seconde**.
* **Veille Réseau Anti-Abandon (Boucle 5s) :** Un moniteur d'intégrité dédié (`LL_fnc_leaderMonitor`) analyse toutes les 5 secondes la présence et la viabilité du chef. En cas de déconnexion, d'abandon ou de passage intempestif à un chef IA, le commandement est automatiquement réattribué à un joueur humain présent sur le serveur (avec message radio informatif).
* **Délégation Volontaire du Commandement :** En multijoueur, le chef dispose d'une action jaune `<t color='#FFFF00'>Donner le commandement</t>` lui permettant de choisir un coéquipier humain connecté pour lui transférer immédiatement la direction du groupe et les prérogatives d'appuis (avec interface dynamique traduite en 15 langues et sécurité d'annulation sous 20s).
* **Annonce Radio TTS & Sous-titres Multilingues :** Lors de chaque passation de commandement (volontaire ou automatique), le nouveau leader entend instantanément l'ordre radio vocal en français *« Vous avez été désigné comme chef. »* (traitement radio VHF militaire authentique), doublé d'un sous-titre affiché dans la langue du client parmi les 15 langues officielles supportées (`STR_LL_Leader_Designated`).
* **Protection Radio :** Aucun parasite radio ni menu non autorisé sur les écrans des opérateurs réguliers.

### 🚁 4. Appuis Tactiques & Évacuation Héliportée
* **Soutien CAS UH-80 Ghost Hawk :** Possibilité d'appeler un hélicoptère d'appui aérien pour nettoyer un secteur chaud via le menu de communication radio.
* **Largage de Ravitaillement :** Parachutage de caisses de munitions ou d'un véhicule de secours sur coordonnées cartographiques.
* **Drone de Surveillance MQ-12 Falcon :** Visualisation par caméra thermique/FLIR des positions ennemies avec affichage direct.
* **Transmission Radio Vocale (TTS) :** Dialogues audio avec traitement radio Lo-Fi authentique et sous-titres traduits.

### 🌴 5. Immersion Civile & Atmosphère Insulaire Authentique
* **Identités Civiles 100% Tanoa :** Base de données patronymique et onomastique refondue selon les traditions mélanésiennes et polynésiennes du Pacifique Sud.
* **Voix Conformes :** Voix anglaises pacifiques (`Male01ENG` à `Male12ENG`), exclusion totale de voix françaises chez les civils locaux pour un dépaysement immersif complet.
* **Habillements & Morphologie :** Modèles de visages océaniens (`TanoanHead`) et tenues insulaires locales (chemises à fleurs, tenues légères tropicales).

### 🌿 6. Environnement Vivant & Optimisé
* **Météo Dynamique Locale :** Brume matinale, averses tropicales et éclaircies aléatoires.
* **Portes Automatiques Intelligentes :** Ouverture/fermeture fluide des portes des bâtiments pour l'escouade et les IA.
* **Protection Anti-Noyade et Sécurité Véhicules :** Système de protection empêchant les véhicules et coéquipiers de rester bloqués dans l'eau ou le décor.
* **Stabilité Maximale :** Patchs défensifs intégrés neutralisant les erreurs courantes de fin de mission (gestion robuste des paquetages BettIR et débriefing propre).

---

## 📋 Catalogue des Opérations Dynamiques

| Opération | Type de Mission | Objectifs & Déroulement |
| :--- | :---: | :--- |
| **☣️ Cargaison Chimique** | Neutralisation & Saisie | Localiser la citerne de précurseurs toxiques du cartel, éliminer la garnison de garde et sécuriser le véhicule chimique. |
| **📁 Documents Secrets** | Infiltration & Renseignement | Pénétrer dans le poste de commandement ennemi, éliminer les officiers et récupérer les données confidentielles sur table ou armoire. |
| **🎯 Élimination du Baron (HVT)** | Traque & Action Directe | Identifier et abattre le chef de secteur du Syndikat retranché dans sa résidence fortifiée sous haute escorte. |
| **🛡️ DCA Blindée Tigris** | Démantèlement Antiaérien | Neutraliser le blindé antiaérien ennemi pour rétablir la suprématie aérienne de la force d'intervention. |
| **📻 Relais de Transmission** | Sabotage & Guerre Électronique | Infiltrer la station hertzienne ennemie et dynamiter les relais de communication longue portée. |
| **🆘 Sauvetage d'Otage** | Libération & Extraction | Localiser la cellule de détention, neutraliser les geôliers sans blesser le captif et l'escorter vers le point d'extraction. |

---

## 🎮 Commandement d'Escouade & Règles d'Engagement

### Postures d'Engagement (R.O.E)
Accessibles à tout moment via l'interface de commandement :
* 🟢 **Feu à volonté :** L'escouade engage librement toute cible hostile identifiée.
* 🟡 **Riposte seule :** Les légionnaires ne tirent que s'ils sont directement pris à partie.
* 🔴 **Cessez-le-feu :** Silence radio et discrétion absolue pour les approches furtives.

### Médecine Tactique Autonome
* Les coéquipiers IA gèrent intelligemment leurs blessures : mise à couvert, application de bandages, injections de morphine et stabilisation mutuelle des coéquipiers inconscients.
* Compatible nativement avec le système médical vanilla ainsi qu'avec le module médical avancé **ACE3**.

### 👑 Passation & Continuité du Commandement en Multijoueur
* **Passation manuelle sur le terrain :** Le chef d'escouade dispose de l'action jaune **« Donner le commandement »** dans son menu contextuel. Au clic, la liste des légionnaires humains connectés s'affiche en sous-actions (`➔ Transférer à : <Nom>`). Dès la validation, le transfert de grade `SERGEANT`, la réattribution des accès radio 0-8 et la transmission vocale s'opèrent instantanément sur l'ensemble du réseau avec confirmation textuelle en chat.
* **Sécurisation anti-abandon automatique :** Si le chef en titre quitte le serveur ou s'il tombe au combat, le serveur analyse la situation toutes les 5 secondes et désigne automatiquement un joueur humain actif comme nouveau chef, empêchant l'escouade de basculer sous le contrôle passif d'une IA.
* **Accompagnement vocal & sous-titrage universel :** Tout nouveau chef désigné reçoit en direct l'appel radio VHF en français *« Vous avez été désigné comme chef. »*, associé à un sous-titrage natif traduit dans la langue choisie par le joueur parmi les 15 langues intégrées.

---

## 📦 Installation & Dépendances

### 1. Prérequis Obligatoires
* **Arma 3** avec l'extension officielle **Apex** (Carte de Tanoa).
* Mod officiel : **[Operation FrenchPoint (OFrP)](https://steamcommunity.com/sharedfiles/filedetails/?id=2059431006)**.

### 2. Dépendances Optionnelles
* **[ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057)** & **[Operation FrenchPoint - ACE3 Compatibility](https://steamcommunity.com/sharedfiles/filedetails/?id=2084745436)** : Intégration transparente si activés (la mission s'adapte sans aucune erreur si ACE3 est absent).

### 3. Installation Manuelle
1. Téléchargez ou clonez le dépôt :
   ```bash
   git clone https://github.com/friartscript/La-Legion-TANOA.git
   ```
2. Déplacez le dossier de mission dans votre répertoire Arma 3 :
   ```text
   C:\Users\<VotreNom>\Documents\Arma 3\missions\La Legion [FrenchPoint].Tanoa
   ```
3. Lancez le jeu, rendez-vous dans le menu **Jouer** ──► **Scénarios** ──► **MISSION LÉGION ÉTRANGÈRE** (ou en multijoueur via le navigateur de serveurs).

---

## 🌐 Localisation Multilingue (15 Langues)

L'intégralité des briefings, objectifs, messages radio, indices et sous-titres est traduite et gérée via la base multilingue `stringtable.xml` :

| Langue | Statut | Langue | Statut | Langue | Statut |
| :--- | :---: | :--- | :---: | :--- | :---: |
| 🇫🇷 **Français** | 100% | 🇬🇧 **Anglais** | 100% | 🇪🇸 **Espagnol** | 100% |
| 🇩🇪 **Allemand** | 100% | 🇮🇹 **Italien** | 100% | 🇵🇱 **Polonais** | 100% |
| 🇷🇺 **Russe** | 100% | 🇹🇷 **Turc** | 100% | 🇯🇵 **Japonais** | 100% |
| 🇰🇷 **Coréen** | 100% | 🇨🇳 **Chinois (Trad.)**| 100% | 🇨🇳 **Chinois (Simp.)**| 100% |
| 🇵🇹 **Portugais** | 100% | 🇨🇿 **Tchèque** | 100% | 🌐 **Original** | 100% |

*Maintenance et compilation automatisée par le script `python compile_stringtable.py`.*

---

## 🏗️ Architecture Technique du Projet

Le projet totalise **77 modules SQF** compilés et vérifiés selon des critères de propreté stricts (0 commentaire résiduel, 0 commande `diag_log`, parenthèses et accolades strictement équilibrées) :

```
La Legion [FrenchPoint].Tanoa/
├── init.sqf                      # Initialisation multijoueur, sécurité caméra et patchs compatibilité
├── briefing.sqf                  # Structure des ordres d'opération et journal de bord
├── description.ext               # CfgFunctions (tag LL), CfgSounds, CfgCommunicationMenu
├── stringtable.xml               # Base de données multilingue compilée (15 langues)
├── compile_stringtable.py        # Script de compilation XML non destructive
├── FN_INTRO.md                   # Dossier d'expertise et storyboard des cinématiques A-H
├── LL_camTools.sqf               # Bibliothèque caméra : anti-collision et lissage dynamique
├── Dialogs/                      # Interfaces HUD et menus personnalisés
├── Images/                       # Logos Légion, visuels et textures de présentation
├── TTS/                          # Fichiers audio radio des transmissions voix
└── Functions/                    # 74 modules fonctionnels répartis en 10 catégories :
    ├── Briefing/ (2)             # Menus contextuels et journal de bord
    ├── Civilian/ (7)             # Population pacifique authentique Tanoa et faune insulaire
    ├── Drone/ (2)                # Flux vidéo et contrôle de reconnaissance MQ-12 Falcon
    ├── Environment/ (4)          # Météo dynamique, portes automatiques et sécurité eau
    ├── Helicopter/ (5)           # Ravitaillement par largage, appui CAS, extraction et gestionnaire leader
    ├── Medical/ (1)              # Gestion des premiers soins et automédication IA
    ├── Player/ (6)               # Identité, tenues réglementaires, arsenal et soins joueur
    ├── Task/ (35)                # Moteur des 6 opérations, cinématiques réseau A-H et clustering
    ├── Team/ (11)                # Postures R.O.E, délégation du commandement, veille 5s et IA
    └── UI/ (1)                   # Système de sous-titres et messages radio stylisés
```

---

## 📚 Documents de Référence

* **[`FN_INTRO.md`](./FN_INTRO.md)** : Dossier d'expertise cinématographique, storyboard des séquences A à H et standards de réalisation.
* **[`EXPORTATION.md`](./EXPORTATION.md)** : Guide d'exportation et d'adaptation du scénario vers d'autres cartes et théâtres d'opérations.
* **[`CONSEILS.md`](./CONSEILS.md)** : Analyses d'immersion, pistes d'évolution tactique et game design.
* **[`INFO_STEAM.md`](./INFO_STEAM.md)** : Présentation officielle prête pour la page du Steam Workshop.
* **[`INFO_STRINTABLE.md`](./INFO_STRINTABLE.md)** : Guide de structure et de mise à jour des traductions XML.
* **[`INFO_TASKS.md`](./INFO_TASKS.md)** : Règles de codage strictes des missions en environnement SP/COOP.
* **[`INFO_TANOA.md`](./INFO_TANOA.md)** : Analyse géographique et contraintes du terrain de Tanoa.

---

## 👤 Auteur & Crédits

* **Créateur & Développeur :** **Friart Script** ([GitHub: friartscript](https://github.com/friartscript))
* **Dépôt Officiel :** [github.com/friartscript/La-Legion-TANOA](https://github.com/friartscript/La-Legion-TANOA)
* **Moteur & Simulation :** [Bohemia Interactive](https://www.bohemia.net/) (*Arma 3 Apex*)
* **Dotations Françaises :** [Operation FrenchPoint (OFrP)](https://steamcommunity.com/sharedfiles/filedetails/?id=2059431006)
* **Bande Son Officielle :** *Chant de la Légion Étrangère* (Legion 001 - Marche)

---

<div align="center">

*« Honneur et Fidélité — Analyser les données de vos missions et tout se passera bien. »*  
**Légion Étrangère — Détachement Tanoa**

</div>
