# ⚔️ LA LÉGION [FrenchPoint] — TANOA

<div align="center">

![Arma 3](https://img.shields.io/badge/Arma%203-Scenario%20%5BSP%2FCOOP%201--6%20%2B%20IA%5D-blue?style=for-the-badge&logo=arma)
![DLC](https://img.shields.io/badge/DLC%20Required-Apex%20%28Tanoa%29-yellow?style=for-the-badge)
![Engine](https://img.shields.io/badge/Engine-Real%20Virtuality%204-red?style=for-the-badge)
![Mods](https://img.shields.io/badge/Mods-OFrP%20%7C%20ACE3%20optionnel-orange?style=for-the-badge)
![Languages](https://img.shields.io/badge/Localization-15%20Languages-green?style=for-the-badge)
![Author](https://img.shields.io/badge/Author-Friart%20Script-purple?style=for-the-badge)

**Scénario d'action tactique militaire Solo (SP) & Coopératif (COOP 1 à 6 joueurs), conçu pour Operation FrenchPoint (OFrP) avec compatibilité optionnelle ACE3 et génération procédurale de missions.**

[Vue d'Ensemble](#-vue-densemble) • [Contexte Stratégique](#-contexte-stratégique--lore) • [Introduction Cinématique](#-cinématique-dintroduction-dynamique) • [Fonctionnalités Clés](#-fonctionnalités-majeures) • [Catalogue des Opérations](#-catalogue-des-opérations-dynamiques) • [Commandement & R.O.E](#-commandement-descouade--règles-dengagement) • [Installation & Dépendances](#-installation--dépendances) • [Architecture Technique](#-architecture-technique-du-projet)

---

</div>

<br/>

## 🎯 Vue d'Ensemble

**La Légion [FrenchPoint]** est une mission tactique militaire conçue pour offrir une immersion totale aux commandes d'un groupe de combat de la **Légion Étrangère**, jouable en **Solo (SP)** comme en **Coopération (COOP de 1 à 6 joueurs)** sur l'archipel tropical de **Tanoa**.

En multijoueur, les coéquipiers IA sont automatiquement disponibles pour compléter l'effectif si vous jouez en comité restreint (les slots d'IA peuvent être librement activés ou désactivés par l'hôte dans le salon d'affectation des rôles).

Équipé des dotations réelles de l'armée française issues du mod **Operation FrenchPoint (OFrP)** (fusils d'assaut HK416, véhicules légers tout-terrain VLTT P4, missiles antichars Eryx, treillis camouflage Centre-Europe et bérets verts), votre groupe est héliporté au cœur de la jungle pour accomplir une suite d'opérations chirurgicales à haute intensité.

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  DÉMARRAGE IMMÉDIAT ──► INSERTION TACTIQUE ──► 2 OU 3 OBJECTIFS EN SÉQUENCE  │
│  (Génération auto)      (Cinématique A à H)    (Secteurs & missions aléatoires)│
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
* **Détruire la bulle de déni d'accès aérien DCA** (blindés Tigris) pour permettre les rotations héliportées.
* **Sécuriser les cargaisons de produits chimiques** avant leur dispersion dans l'archipel.
* **Fouiller les campements pour saisir les documents et registres secrets** des chefs de guerre.
* **Éliminer les cibles d'intérêt prioritaire (HVT)** et saboter les relais hertziens clandestins.
* **Secourir les otages captifs** et neutraliser les geôliers sans dommage collatéral.
* **Préserver impérativement la population civile locale** (échec immédiat de mission en cas de victime civile).

---

## 🎬 Cinématique d'Introduction Dynamique

L'introduction du scénario a été intégralement découpée en **8 séquences immersives (A à H)** (voir le dossier d'expertise détaillé [`FN_INTRO.md`](./FN_INTRO.md)) :

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
* **Incarnation subjective immédiate :** La cinématique démarre directement dans l'allée centrale de la cabine, cadrée à hauteur des yeux face aux visages et paquetages des légionnaires, avec vue sur la jungle qui défile à pleine vitesse par les portes latérales.
* **Montage cut de cinéma professionnel :** Élimination totale des flous répétés (*whips*) au profit de coupes franches et de raccords de mouvement synchronisés aux mesures du chant officiel de la Légion.
* **Typographie militaire épurée :** Titrages équilibrés en tiers d'écran préservant le champ de vision, avec liseré tricolore sobre et prestige français.
* **Approche et poser 100% sécurisés :** Vol continu de l'appareil verrouillé sur l'axe de la LZ sans aucune dérive en forêt, depuis le vol de croisière jusqu'au poser des patins sur l'héliport dégagé.
* **Anti-collision sol et obstacles (`LL_fnc_findOpenCamSpot`) :** Analyse en temps réel du relief, des troncs d'arbres, rochers et bâtiments pour positionner la caméra dans une zone dégagée avec ligne de vue garantie.
* **Lissage dynamique & Caméra à l'épaule (`LL_fnc_camApply`) :** Correction de trajectoire progressive avec un léger balancement naturel sans tremblement excessif.

---

## ⚡ Fonctionnalités Majeures

### 🚀 1. Lancement Immédiat & Génération Aléatoire
* **Aucun paramétrage fastidieux :** Dès le lancement, la mission choisit une zone d'insertion tactique adaptée, sélectionne **2 ou 3 opérations distinctes** parmi le catalogue et initialise l'arsenal et le véhicule VLTT P4 de patrouille.
* **Rejouabilité infinie :** Emplacements des objectifs, garnisons ennemies, patrouilles de jungle, météo dynamique et points d'extraction changent à chaque partie.

### 👥 2. Solo (SP) & Multijoueur Coopératif (COOP 1 à 6)
* **Escouade complète permanente :** En multijoueur, si vous jouez à 2 ou 3 amis, les rôles restants peuvent être occupés par des IA de soutien.
* **Contrôle total dans le salon :** L'hôte peut activer ou désactiver les IA selon ses préférences avant de lancer la partie.
* **Passage de commandement automatique :** Si le chef d'escouade tombe au combat, le commandement passe instantanément au soldat suivant sans rupture de script.

### 🚁 3. Support Aérien & Évacuation Tactique
* **Soutien CAS UH-80 Ghost Hawk :** Possibilité d'appeler un hélicoptère d'appui aérien pour nettoyer un secteur chaud via le menu de communication radio.
* **Largage de ravitaillement :** Parachutage de caisses de munitions ou d'un véhicule de secours sur coordonnées cartographiques.
* **Drone de surveillance MQ-12 Falcon :** Visualisation par caméra thermique/FLIR des positions ennemies avec affichage direct.
* **Transmission radio vocale (TTS) :** Dialogues audio avec traitement radio Lo-Fi authentique et sous-titres traduits.

### 🌿 4. Environnement Vivant & Optimisé
* **Météo dynamique locale :** Brume matinale, averses tropicales et éclaircies aléatoires.
* **Portes automatiques intelligentes :** Ouverture/fermeture fluide des portes des bâtiments pour l'escouade et les IA.
* **Protection anti-noyade et sécurité véhicules :** Système de protection empêchant les véhicules et coéquipiers de rester bloqués dans l'eau ou le décor.
* **Stabilité maximale :** Patchs défensifs intégrés neutralisant les erreurs courantes de fin de mission (gestion robuste des paquetages BettIR et débriefing propre).

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
3. Lancez le jeu, rendez-vous dans le menu **Jouer** ──► **Scénarios** ──► **MISSION LÉGION ÉTRANGÈRE**.

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

Le projet totalise **75 modules SQF** compilés et vérifiés selon des critères de propreté stricts (0 commentaire résiduel, 0 commande `diag_log`, parenthèses et accolades strictement équilibrées) :

```
La Legion [FrenchPoint].Tanoa/
├── init.sqf                      # Initialisation, surveillance et patchs de compatibilité
├── briefing.sqf                  # Structure des ordres d'opération et journal de bord
├── description.ext               # CfgFunctions (tag LL), CfgSounds, CfgCommunicationMenu
├── stringtable.xml               # Base de données multilingue compilée (15 langues)
├── compile_stringtable.py        # Script de compilation XML non destructive
├── FN_INTRO.md                   # Dossier d'expertise et storyboard des cinématiques A-H
├── LL_camTools.sqf               # Bibliothèque caméra : anti-collision et lissage dynamique
├── Dialogs/                      # Interfaces HUD et menus personnalisés
├── Images/                       # Logos Légion, visuels et textures de présentation
├── TTS/                          # Fichiers audio radio des transmissions voix
└── Functions/                    # 72 modules fonctionnels répartis en 10 catégories :
    ├── Briefing/ (2)             # Menus contextuels et journal de bord
    ├── Civilian/ (7)             # Population civile, ambiance insulaire et faune locale
    ├── Drone/ (2)                # Flux vidéo et contrôle de reconnaissance MQ-12 Falcon
    ├── Environment/ (4)          # Météo dynamique, portes automatiques et sécurité eau
    ├── Helicopter/ (5)           # Ravitaillement par largage, appui CAS et extraction
    ├── Medical/ (1)              # Gestion des premiers soins et automédication IA
    ├── Player/ (6)               # Identité, tenues réglementaires, arsenal et soins joueur
    ├── Task/ (35)                # Moteur des 6 opérations, cinématiques A-H et nettoyage
    ├── Team/ (9)                 # Postures R.O.E, continuité switchToAI et déblocage d'IA
    └── UI/ (1)                   # Système de sous-titres et messages radio stylisés
```

---

## 📚 Documents de Référence

* **[`FN_INTRO.md`](./FN_INTRO.md)** : Dossier d'expertise cinématographique, storyboard des séquences A à H et standards de réalisation.
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
