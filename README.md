# ⚔️ OPERATION FRENCHPOINT — Tanoa

<div align="center">

![Arma 3](https://img.shields.io/badge/Arma%203-Scenario%20%5BSP%2FCOOP%201--6%5D-blue?style=for-the-badge&logo=arma)
![DLC](https://img.shields.io/badge/DLC%20Required-Apex%20%28Tanoa%29-yellow?style=for-the-badge)
![Engine](https://img.shields.io/badge/Engine-Real%20Virtuality%204-red?style=for-the-badge)
![Mods](https://img.shields.io/badge/Mods-OFrP%20%7C%20ACE3%20optionnel-orange?style=for-the-badge)
![Languages](https://img.shields.io/badge/Localization-15%20Languages-green?style=for-the-badge)
![Author](https://img.shields.io/badge/Author-Friart%20Script-purple?style=for-the-badge)

**Un générateur d'opérations dynamiques pour Arma 3 SP/COOP (1–6 joueurs), conçu pour Operation FrenchPoint (OFrP) avec compatibilité optionnelle ACE3.**

[Vue d'Ensemble](#-vue-densemble) • [Contexte & Lore](#-contexte-stratégique--lore) • [Fonctionnalités Clés](#-fonctionnalités-majeures) • [Opérations Tactiques](#-catalogue-des-missions) • [Commandement & R.O.E](#-règles-dengagement--commandement-descouade) • [Dépendances & Installation](#-installation--dépendances) • [Architecture Détaillée](#-architecture-détaillée-du-projet)

---

</div>

<br/>

## 🎯 Vue d'Ensemble

**Operation FrenchPoint [La Légion]** est une mission tactique militaire hybride **Solo (SP) et Coopérative (COOP 1 à 6 joueurs)** se déroulant sur l'archipel tropical de **Tanoa**.

Incarnez le chef de groupe d'une escouade d'élite de la **Légion Étrangère** équipée des dotations réglementaires françaises du mod **Operation FrenchPoint (OFrP)** (fusils d'assaut HK416, véhicules tout-terrain légers P4, missiles antichars Eryx, treillis Centre-Europe et bérets verts).

La mission génère automatiquement et sans menu préalable une campagne procédurale unique à chaque lancement : insertion aéroportée, sélection aléatoire de **2 ou 3 opérations majeures** sur des secteurs géographiques distincts, gestion dynamique de la menace et évacuation héliportée sous couverture.

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  DÉMARRAGE IMMÉDIAT ──► INSERTION TACTIQUE ──► 2 OU 3 OBJECTIFS EN SÉQUENCE  │
│  (Opération générée)    (Vol basse altitude)   (Secteurs & missions aléatoires)│
│                                                                │             │
│  FIN DE MISSION ◄──────────── EXTRACTION HÉLIPORTÉE ◄──────────┘             │
│  (Debriefing complet)         (Soutien UH-80 CAS & Évacuation)               │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 🌍 Contexte Stratégique & Lore

### 1. La Guerre Contre les Cartels (Océan Indien)
* **Date opérationnelle :** 13 mars 2019.
* L'archipel insulaire de **Tanoa** est devenu la plaque tournante du narcotrafic international et de la contrebande d'armes lourdes. Tirant parti des reliefs volcaniques et de la jungle dense, le cartel mafieux du **Syndikat** a sanctuarisé l'île : raffineries clandestines de solvants chimiques, batteries antiaériennes DCA pour interdire l'espace aérien, centres d'écoute et cellules d'exécution d'otages.

### 2. Le Mandat de la Légion Étrangère
Face à l'escalade de la violence et à la corruption des milices locales, la **Légion Étrangère** est déployée pour des frappes chirurgicales d'action directe :
* **Neutraliser la bulle antiaérienne DCA** (véhicules Tigris) pour rouvrir les corridors de transport aérien.
* **Sécuriser les précurseurs toxiques** par extraction héliportée en hélitreuillage lourd (*Slingload*).
* **Récupérer les documents de renseignement et comptabilités noires** sur les officiers du cartel.
* **Éliminer les cibles d'intérêt majeur (HVT)** et saboter les relais radio clandestins.
* **Secourir les agents infiltrés et otages** avant leur exécution programmée.
* **Protéger scrupuleusement la population civile insulaire** (règle absolue : échec de mission en cas de dommage collatéral).

---

## ⚡ Fonctionnalités Majeures

### 🚀 1. Démarrage Automatique & Moteur Procédural Réactif
* **Zéro Menu Bloquant :** Dès l'entrée en jeu, l'opération planifie automatiquement la chronologie, la météo, la zone d'atterrissage (LZ) et le chapelet d'objectifs.
* **Rejouabilité Infinie :** Sélection aléatoire de 2 ou 3 missions parmi les 6 archétypes tactiques, sur des sites espacés d'au moins 950 m, évitant toute redondance.
* **Sauvegarde Automatique de Progression :** À chaque début et fin d'objectif, la partie est automatiquement sauvegardée avec journalisation discrète et notification traduite en 14 langues (`fn_saveProgress`).
* **Secours d'Otage en Apothéose :** Si l'opération comporte la mission otage, celle-ci est automatiquement programmée en phase terminale avant l'extraction.

---

### 🛡️ 2. Déblocage Tactique d'Escouade (Watchdog IA Coincée)
* **Surveillance d'Immobilité (90 secondes) :** Algorithme temps réel dédié au leader d'escouade. Si un coéquipier IA sous ses ordres reste coincé au même endroit (déplacement < 2,5 m pendant 90 s) et se trouve à distance du chef (> 10 m), une action contextuelle d'urgence apparaît.
* **Repère Visuel Bleu Ciel (`#00DFFF`) :** Option discrète dans la molette d'action : `<t color='#00DFFF'>Téléporter l'unité (Nom)</t>`.
* **Regroupement Sécurisé :** Téléporte instantanément l'équipier à côté du chef sur la terre ferme (`!surfaceIsWater`), réinitialise ses animations bloquées et relance le suivi d'escouade (`doFollow`).
* **Suppression Dynamique Automatique :** L'action s'efface d'elle-même dès que l'IA se débloque seule, si le joueur revient vers elle, ou dès que la téléportation est accomplie.

---

### 🎯 3. Patrouilles Ennemies Étagées & Sécurité Littorale
* **Anneaux Concentriques (15 m à 250 m) :** Finis les ennemis agglutinés au même point. Les forces d'opposition sont réparties en 3 à 4 cercles de sécurité distincts (défense rapprochée, périmètre moyen, surveillance lointaine des axes routiers et sentiers de crête).
* **Sécurité Anti-Noyade Révisée (`surfaceIsWater`) :** Chaque spawn et waypoint est vérifié mathématiquement pour interdire l'eau. Même sur les plages et mangroves de Tanoa, les patrouilles restent sur la terre ferme et ne se bloquent jamais au rivage.
* **Circuits Polygonaux Vivants :** Les groupes parcourent des boucles tactiques à 3 ou 4 points en formation colonne décalée (`STAG COLUMN`), avec des pauses d'observation aléatoires (4 à 14 secondes).
* **Lampes d'Armes Tactiques Réactives :** Les armes ennemies sur rail sont dotées de lampes torches (`acc_flashlight`). Les patrouilles marchent discrètement de nuit sans lumière allumée et n'activent leurs torches qu'en cas d'alerte ou de combat (`Auto`).

---

### 🎮 4. Continuité Solo & Commandement Tactique R.O.E
* **Règles d'Engagement Instantanées :** Pilotez vos coéquipiers à la molette via 5 postures tactiques complètes (*Infiltration, Normal, Défense, Regroupement d'Urgence, Assaut*).
* **Relève de Commandement Transparent (`fn_switchToAI`) :** Si le joueur tombe au combat en Solo, la caméra et le contrôle passent immédiatement et sans fondu noir bloquant sur un coéquipier IA survivant.
* **Auto-Soin des Coéquipiers :** Les unités alliées se soignent et stabilisent leurs hémorragies de façon autonome dès qu'elles sont à couvert.
* **Portes & Barrières Automatiques (`fn_doorSecurity`) :** Détection et ouverture automatique universelle des portes et portails dans un rayon de 4,5 m pour fluidifier les franchissements de l'escouade.

---

### 🚁 5. Appuis Tactiques & Armes Combinées (Menu Radio 0-8)
* **0-8-1 (Ravitaillement Logistique) :** Parachutage d'une caisse complète de munitions et missiles Eryx balisée par des fumigènes tricolores.
* **0-8-2 (Véhicule de Remplacement) :** Dépose d'une P4 tout-terrain en cas de destruction ou panne de mobilité.
* **0-8-3 (Extraction Héliportée) :** Appel de l'UH-80 Ghost Hawk allié pour clôturer l'opération quand vous le décidez.
* **0-8-4 (CAS - Appui Aérien Rapproché) :** Mitraillage au canon lourd guidé sur coordonnées désignées.
* **0-8-5 (Drone de Reconnaissance) :** Survol du secteur par un drone MQ-12 Falcon avec retransmission vidéo.

---

## 📋 Catalogue des Missions

Chaque opération combine les directives d'engagement globales et des missions procédurales générées en séquence :

| Code Tâche | Type d'Opération | Description Stratégique |
| :---: | :--- | :--- |
| **Tâche A** | **Infiltration du Secteur** | Débarquement discret et progression à travers la jungle vers le secteur contrôlé par le cartel. |
| **Tâche B** | **Protection Civile** | Zéro victime collatérale. Respect absolu des règles d'engagement envers les villageois insulaires. |
| **Tâche C** | **Survie du Détachement** | Préservation des effectifs de la Légion et évacuation finale par les airs. |
| **Tâche D-Tigris** | **DCA Blindée & Brouillage** | Neutralisation de batteries antiaériennes blindées I_Truck_02_MRL sous compte à rebours d'interception aérienne. |
| **Tâche D-Chimique** | **Citernes de Solvants** | Sécurisation et extraction par hélitreuillage lourd (Slingload) avec simulation de fuite toxique progressive. |
| **Tâche D-Documents** | **Renseignement & Comptabilité** | Fouille du corps d'un officier du cartel pour récupérer les registres de corruption et routes de trafic. |
| **Tâche D-HVT** | **Élimination du Lieutenant** | Traque et neutralisation du chef local retranché avec ses gardes du corps rapprochés. |
| **Tâche D-Captif** | **Sauvetage d'Agent Infiltré** | Infiltration d'un campement pour libérer un agent anti-drogue avant son exécution. |
| **Tâche D-Trans** | **Terminaux de Communication** | Sabotage aux charges explosives C4 munies de bips sonores et lumineux stroboscopiques temporisés. |

---

## 🎖️ Règles d'Engagement & Commandement d'Escouade

Gérez la tactique de votre groupe de combat en direct via la molette de la souris :

| Posture Tactique | Effet sur l'Escouade IA | Cas d'Usage Idéal |
| :--- | :--- | :--- |
| 🤫 **Infiltration** | Déplacement furtif en silence, accroupi, désactivation de l'autocombat. | Approche discrète dans la jungle, contournement de sentinelles. |
| 🛡️ **Normal** | Vitesse standard, engagement libre à portée utile, couverture mutuelle. | Progression générale en terrain ouvert et reconnaissance de village. |
| 🏰 **Défense** | Prise de position statique à 360°, couverture des accès et clairières. | Attente de l'hélicoptère d'extraction, tenue d'un carrefour ou d'un quai. |
| ⚡ **Regroupement d'Urgence** | Sprint immédiat vers le leader, rupture de contact sans riposte. | Désengagement sous tir de mitrailleuse lourde, repli d'urgence. |
| 💥 **Assaut** | Vitesse maximale, tir de suppression soutenu et progression agressive. | Assaut final sur bâtiment fortifié, réduction d'un camp retranché. |

---

## 📦 Installation & Dépendances

### 1. Dépendances Requises (DLC & Mod)
* **Arma 3 Apex** (carte Tanoa).
* **[Operation FrenchPoint (OFrP)](https://steamcommunity.com/sharedfiles/filedetails/?id=2059431006)** : Armement, véhicules et tenues réglementaires de l'armée française.
* **ACE3 (Optionnel) :** Entièrement compatible avec le module [Operation FrenchPoint - ACE3 Compatibility](https://steamcommunity.com/sharedfiles/filedetails/?id=2084745436). Si ACE3 est absent, la mission fonctionne parfaitement en mode vanilla sans erreur.
* **Zéro dépendance superflue :** Aucune dépendance CUP, RHS, ou autre mod tiers. 100 % optimisé et stable.

### 2. Déploiement & Installation
1. Clonez le dépôt GitHub officiel :
   ```bash
   git clone https://github.com/friartscript/La-Legion-TANOA.git
   ```
2. Placez le dossier `La Legion [FrenchPoint].Tanoa` dans votre répertoire de missions Arma 3 :
   ```text
   C:\Users\<VotreNom>\Documents\Arma 3\missions\La Legion [FrenchPoint].Tanoa
   ```
3. Lancez **Arma 3** avec l'extension Apex et le mod OFrP activés.
4. Rendez-vous dans : **Jouer** ──► **Scénarios** ──► **MISSION LÉGION ÉTRANGÈRE**.

---

## 🌐 Localisation Multilingue (15 Langues)

La mission intègre une internationalisation native exhaustive via `stringtable.xml` :

| Langue | Statut | Langue | Statut | Langue | Statut |
| :--- | :---: | :--- | :---: | :--- | :---: |
| 🇫🇷 **Français** | 100% | 🇬🇧 **Anglais** | 100% | 🇪🇸 **Espagnol** | 100% |
| 🇩🇪 **Allemand** | 100% | 🇮🇹 **Italien** | 100% | 🇵🇱 **Polonais** | 100% |
| 🇷🇺 **Russe** | 100% | 🇹🇷 **Turc** | 100% | 🇯🇵 **Japonais** | 100% |
| 🇰🇷 **Coréen** | 100% | 🇨🇳 **Chinois (Trad.)**| 100% | 🇨🇳 **Chinois (Simp.)**| 100% |
| 🇵🇹 **Portugais** | 100% | 🇨🇿 **Tchèque** | 100% | 🌐 **Original** | 100% |

*Compilation et maintenance via `python compile_stringtable.py` selon les directives de [`INFO_STRINTABLE.md`](./INFO_STRINTABLE.md).*

---

## 🏗️ Architecture Détaillée du Projet

Une structure modulaire en SQF pur, respectant les normes strictes de compilation d'Arma 3 (0 commentaire résiduel, 0 commande `diag_log` de debug, accolades strictement vérifiées) :

```
La Legion [FrenchPoint].Tanoa/
├── init.sqf                      # Initialisation, protection de départ et boucle de surveillance
├── description.ext               # CfgFunctions, CfgSounds, CfgCommunicationMenu et respawn hybride
├── stringtable.xml               # Base de données multilingue compilée (15 langues)
├── compile_stringtable.py        # Script Python de compilation non destructive des fichiers XML
├── Dialogs/                      # Interfaces et éléments d'affichage
└── Functions/                    # 68 modules fonctionnels du projet
    ├── Briefing/                 # Ordres d'opération et journal de bord natif
    ├── Civilian/                 # Civils ambiants, identités régionales, embuscades et faune
    ├── Drone/                    # Surveillance MQ-12 Falcon et flux de reconnaissance
    ├── Environment/              # Portes automatiques universelles, météo vivante et anti-noyade
    ├── Helicopter/               # Ravitaillement par largage, hélicoptère d'appui et extraction
    ├── Medical/                  # Auto-médication et premiers secours des coéquipiers IA
    ├── Player/                   # Identité, tenues réglementaires, arsenal et soins
    ├── Task/                     # Moteur de génération des 6 opérations, cinématiques et cleanup
    ├── Team/                     # Postures R.O.E, continuité switchToAI et déblocage d'IA coincée
    └── UI/                       # Messages radio avec traitement audio Lo-Fi et sous-titres
```

---

## 📚 Documentation Complémentaire

* **[`CONSEILS.md`](./CONSEILS.md)** : Analyses d'immersion, pistes d'évolution tactique et concepts de missions additionnelles.
* **[`INFO_STEAM.md`](./INFO_STEAM.md)** : Présentation officielle au format BBCode prête pour le Steam Workshop.
* **[`INFO_STRINTABLE.md`](./INFO_STRINTABLE.md)** : Guide d'intégration et de maintenance des traductions multilingues.
* **[`INFO_TANOA.md`](./INFO_TANOA.md)** : Étude du théâtre d'opérations et de l'adaptation géographique de Tanoa.

---

## 👤 Auteur & Crédits

* **Créateur & Développeur :** **Friart Script** ([GitHub: friartscript](https://github.com/friartscript))
* **Dépôt Officiel :** [github.com/friartscript/La-Legion-TANOA](https://github.com/friartscript/La-Legion-TANOA)
* **Moteur & Simulation :** [Bohemia Interactive](https://www.bohemia.net/) (*Arma 3 Apex*)
* **Dotations Françaises :** [Operation FrenchPoint (OFrP)](https://steamcommunity.com/sharedfiles/filedetails/?id=2059431006)
* **Bande Son Officielle :** *Chant de la Légion Étrangère* (Legion 001 - Marche)

---

<div align="center">

*« Analyser les données de vos missions et informations qui vous sont données et tout se passera bien. »*  
**OPORD — Commandement de la Légion Étrangère**

</div>