# ⚔️ OPERATION FRENCHPOINT — Tanoa

<div align="center">

![Arma 3](https://img.shields.io/badge/Arma%203-Scenario%20%5BSP%2FCOOP%201--6%5D-blue?style=for-the-badge&logo=arma)
![DLC](https://img.shields.io/badge/DLC%20Required-Apex%20%28Tanoa%29-yellow?style=for-the-badge)
![Engine](https://img.shields.io/badge/Engine-Real%20Virtuality%204-red?style=for-the-badge)
![Mods](https://img.shields.io/badge/Mods-OFrP%20%7C%20ACE3%20optionnel-orange?style=for-the-badge)
![Languages](https://img.shields.io/badge/Localization-15%20Languages-green?style=for-the-badge)
![Author](https://img.shields.io/badge/Author-Friart%20Script-purple?style=for-the-badge)

**Un générateur d'opérations dynamiques pour Arma 3 SP/COOP (1–6 joueurs), prévu pour OFrP avec ACE3 en option.**

[Vue d'Ensemble](#-vue-densemble) • [Contexte & Lore](#-contexte-stratégique--lore) • [Fonctionnalités Clés](#-fonctionnalités-majeures) • [Opérations Tactiques](#-catalogue-des-missions) • [Commandement & R.O.E](#-règles-dengagement--commandement-descouade) • [Dépendances & Installation](#-installation--dépendances) • [Architecture Détaillée](#-architecture-détaillée-du-projet)

---

</div>

<br/>

## 🎯 Vue d'Ensemble

**Cible de refonte : Operation FrenchPoint**, une mission tactique de **1 à 6 joueurs (SP/COOP)** sur l'archipel tropical de **Tanoa**. La mission est intégralement adaptée pour la Légion Étrangère ; les tests décrits dans [`ETAPES.md`](./ETAPES.md) sont validés.

Incarnez le chef de groupe d'une escouade française équipée par **Operation FrenchPoint (OFrP)**. La cible est un démarrage sans menu de lancement, suivi d'une insertion et de deux ou trois objectifs générés sur des sites distincts de familles A/B/C/D/E différentes. Le premier site est à au moins 950 m de la LZ d'introduction ; les sites suivants sont choisis parmi les plus proches valides.

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  DÉMARRAGE AUTOMATIQUE ──► INSERTION ──► 2 OU 3 OBJECTIFS / SITES DISTINCTS│
│  (sans sélection menu)      (selon secteur)   (générés et joués en séquence)│
│                                                                │             │
│  FIN DE SESSION ◄──────────── EXTRACTION HÉLIPORTÉE ◄──────────┘             │
│  (Rapport de Mission)         (UH-80 CAS & Évacuation)                       │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 🌍 Contexte Stratégique & Lore

### 1. La Guerre Contre les Cartels & le Narcotrafic (Océan Indien)
* **Date opérationnelle :** 13 mars 2019 (dotations militaires OFrP 2019 CE).
* L'archipel de **Tanoa** et les îles environnantes sont devenus la plaque tournante du narcotrafic international dans l'Océan Indien. Profitant de la porosité des frontières maritimes, un cartel mafieux surarmé (le **Syndikat**) a transformé la région en sanctuaire de raffinage de drogue dure, de contrebande d'armes de guerre et de piraterie maritime. 

### 2. La Légion Étrangère
Le 13 mars 2019, face à la corruption locale et à la menace représentée par les milices du cartel, le gouvernement a fait appel à la **Légion Étrangère**. Cette unité d'élite mène des frappes chirurgicales au cœur des sanctuaires de la mafia insulaire avec un mandat strict :
* **Démanteler les infrastructures logistiques clandestines** (laboratoires chimiques, émetteurs radio de contrebande, technicals armés).
* **Traquer et neutraliser les têtes de réseau** (barons de la drogue et lieutenants).
* **Secourir les agents infiltrés et otages** avant leur exécution.
* **Protéger rigoureusement la population civile insulaire** (règle absolue : zéro dommage collatéral).

---

## ⚡ Fonctionnalités Majeures

### 🚀 1. Démarrage automatique (cible)
* **Aucun menu de sélection :** Génération automatique d'une opération à l'entrée en jeu.
* **Deux ou trois objectifs aléatoires :** Chaque objectif est associé à un site unique d'une famille A/B/C/D/E différente parmi les marqueurs Eden configurés.
* **Secours d'otage en fin d'opération :** `taskD_captive` est placé automatiquement en dernier objectif, après une première mission ou après deux missions.
* **Insertion adaptée au secteur :** Utiliser un moyen d'accès valide pour les sites séparés par la mer ; ne pas supposer que toutes les zones sont reliées par route.
* **État d'avancement :** Les objectifs sont présentés au briefing puis joués en séquence avant l'extraction.

---

### 🔄 2. Moteur d'Opérations Dynamiques & Procédurales
* **Opération en deux ou trois objectifs :** La cible sélectionne aléatoirement deux ou trois tâches distinctes et autant de sites ; les familles de marqueurs A/B/C/D/E ne se répètent pas. Le premier site est à au moins 950 m de la LZ, puis chaque site suivant est le plus proche admissible du précédent.
* **Génération Procédurale Réactive :** Placement dynamique des camps ennemis, patrouilles, otages, relais de communication, convois chimiques et technicals dans les secteurs configurés.
* **Contre-Attaque Ennemie Réactive :** À la réussite d'un objectif majeur, des cellules de sicarios déclenchent une manœuvre de traque et d'interception (*Search & Destroy*).
* **Extraction Cinématique à la Demande :** Demandez l'évacuation à tout moment via la molette. L'UH-80 Ghost Hawk vanilla vient extraire votre groupe sous couverture armée avec debriefing complet.

---

### 🌴 3. Immersion Insulaire & Vie Locale Vivante
* **Identités Civiles & Régionales :**
  * Noms et patronymes authentiques de l'Océan Indien (Mayotte, Comores, Tanoa).
  * Population masculine vêtue de tenues tropicales civiles, polos, chemisettes et vêtements de travail.
  * **Présence de femmes civiles et de combattantes ennemies :** Séparation stricte et étanche entre citoyennes civiles inoffensives (immunité totale, statut captif et zéro ciblage) et combattantes ennemies armées du cartel.
  * **Système vocal :** Utiliser les voix disponibles dans le jeu ou dans les mods réellement requis ; les anciennes références vocales CUP doivent être retirées pendant la migration.
* **Faune Insulaire Authentique :** Volailles de basse-cour (poules `Hen_random_F`, coqs `Cock_random_F`) déambulant dans les cours villageoises en remplacement des troupeaux désertiques.
* **Surveillance Anti-Noyade (`fn_preventWater`) :** Algorithme temps réel garantissant que les IA civiles et ennemies ne plongent pas et ne se noient pas dans les lagons ou l'océan.

---

### 🎮 4. Commandement d'Escouade & Continuité SP/COOP
* **Contrôle Tactique R.O.E :** Régulez instantanément la posture de vos coéquipiers IA via la molette (Infiltration, Normal, Défense, Regroupement d'Urgence, Assaut).
* **Transfert de Commandement Transparent (`fn_switchToAI`) :** Si le joueur tombe au combat, la caméra et le commandement basculent immédiatement et sans coupure sur un coéquipier survivant de l'escouade.
* **Auto-Soin des Unités Alliées :** Gestionnaire autonome de premiers secours permettant aux coéquipiers IA de se soigner et de stabiliser leurs blessures au combat.
* **Gestionnaire Intelligent de Portes & Grilles (`fn_doorSecurity`) :** Ouverture automatique universelle des portes, volets métalliques et portails à 4,5 m pour l'infanterie, avec fermeture à 6 m pour éliminer les blocages de pathfinding.

---

### 🚁 5. Appuis Tactiques & Armes Combinées
* **Appui Aérien Rapproché CAS (UH-80 Ghost Hawk vanilla) :** Mitraillage au sol sur coordonnées désignées.
* **Largage de Ravitaillement :** Parachutage de caisses d'armement et munitions sur votre position.
* **Drone de Reconnaissance (MQ-12 Falcon vanilla) :** Télémétrie en temps réel et retransmission vidéo de surveillance sur zone.
* **Écusson Officiel :** Insigne brodé de la Légion Étrangère sur les gilets de combat alliés.

---

## 📋 Catalogue des Missions

Chaque déploiement combine des directives d'engagement globales et des missions procédurales générées à la volée :

| Code Tâche | Type d'Opération | Description Stratégique |
| :---: | :--- | :--- |
| **Tâche A** | **Infiltration du Secteur** | Débarquement discret et progression à travers la jungle vers la zone contrôlée par le cartel. |
| **Tâche B** | **Protection Civile** | Zéro victime collatérale. Respect absolu des règles d'engagement envers les villageois insulaires. |
| **Tâche C** | **Survie du Détachement** | Préservation des effectifs de la Légion et évacuation sécurisée de l'escouade. |
| **Tâche D-00** | **Sauvetage d'Agent Infiltré** | Infiltration d'un camp retranché pour libérer un agent anti-drogue avant son exécution. |
| **Tâche D-01** | **Comptabilité Noire & Documents** | Récupération des registres de corruption et routes maritimes sur le corps d'un lieutenant du cartel. |
| **Tâche D-04** | **Citerne de Précurseurs Chimiques** | Sécurisation d'une citerne de solvants de raffinage et extraction par hélitreuillage lourd (Slingload). |
| **Tâche D-08** | **Destruction de Technical Lourd** | Neutralisation d'un pickup armé lourd (ZU-23-2 / HMG) et d'un camion de brouillage Tempest. |
| **Tâche D-HVT** | **Élimination du Baron de la Drogue** | Traque et neutralisation du chef local du cartel protégé par sa garde rapprochée. |
| **Tâche D-Trans**| **Terminaux Radio de Contrebande** | Sabotage aux explosifs des relais radio clandestins servant à la coordination des go-fast. |

---

## 🎖️ Règles d'Engagement & Commandement d'Escouade

Gérez la tactique de votre escouade en direct via le menu dynamique (molette de la souris) :

| Posture Tactique | Effet sur l'Escouade IA | Cas d'Usage Idéal |
| :--- | :--- | :--- |
| 🤫 **Infiltration** | Déplacement furtif en silence, accroupi, désactivation de l'autocombat. | Approche discrète dans la jungle, contournement de sentinelles. |
| 🛡️ **Normal** | Vitesse standard, engagement libre à portée utile, couverture mutuelle. | Progression générale en terrain ouvert et reconnaissance de village. |
| 🏰 **Défense** | Prise de position statique à 360°, couverture des accès et clairières. | Attente de l'hélicoptère d'extraction, tenue d'un carrefour ou d'un quai. |
| ⚡ **Regroupement d'Urgence** | Sprint immédiat vers le leader, rupture de contact sans riposte. | Désengagement sous tir de mitrailleuse lourde, repli d'urgence. |
| 💥 **Assaut** | Vitesse maximale, tir de suppression soutenu et progression agressive. | Assaut final sur bâtiment fortifié, réduction d'un camp retranché. |

---

## 📦 Installation & Dépendances

### 1. Dépendances visées (DLC & Mods)

- **Arma 3 Apex** (Tanoa) et **Operation FrenchPoint (OFrP)** uniquement pour les contenus moddés de la mission. Les unités, ennemis et civils moddés doivent utiliser OFrP ; le jeu de base peut fournir les éléments vanilla.
- **Aucune dépendance CUP ni autre mod tiers** (dont TCGM_Girls ou RHS) n'est admise dans la version finale.
- **ACE3 est facultatif.** La mission doit rester jouable sans ACE3. Pour une configuration ACE, charger [ACE3](https://github.com/acemod/ACE3) et le paquet [Operation FrenchPoint - ACE3 Compatibility](https://steamcommunity.com/sharedfiles/filedetails/?id=2084745436).
- La mission ne doit appeler aucun composant ACE sans vérification de disponibilité ; les fonctions essentielles et les soins/ravitaillements doivent conserver un comportement vanilla.

Voir le [guide des classes OFrP](https://steamcommunity.com/sharedfiles/filedetails/?id=2059431006) et valider chaque classe dans les fichiers du mod.

**État du projet :** des identifiants CUP hérités sont encore présents dans certains scripts du snapshot. Ils sont des éléments à supprimer, et non des dépendances autorisées ; la version actuelle ne respecte donc pas encore cette règle. Suivre [`ETAPES.md`](./ETAPES.md) pour les retirer et tester avec tous les mods tiers désactivés.

### 2. Installation Manuelle
1. Téléchargez ou clonez ce dépôt :
   ```bash
   git clone https://github.com/votre-compte/La Legion [FrenchPoint].Tanoa.git
   ```
2. Déposez le dossier `La Legion [FrenchPoint].Tanoa` dans votre répertoire de missions Solo Arma 3 :
   ```text
   C:\Users\<VotreNom>\Documents\Arma 3\missions\La Legion [FrenchPoint].Tanoa
   ```
3. Lancez **Arma 3** avec les extensions et mods activés.
4. Rendez-vous dans le menu : **Jouer** ──► **Scénarios** ──► **Mission Légion Étrangère**.

---

## 🌐 Localisation Multilingue (15 Langues)

La mission intègre une internationalisation native complète grâce au fichier compilé `stringtable.xml` :

| Langue | Statut | Langue | Statut | Langue | Statut |
| :--- | :---: | :--- | :---: | :--- | :---: |
| 🇫🇷 **Français** | 100% | 🇬🇧 **Anglais** | 100% | 🇪🇸 **Espagnol** | 100% |
| 🇩🇪 **Allemand** | 100% | 🇮🇹 **Italien** | 100% | 🇵🇱 **Polonais** | 100% |
| 🇷🇺 **Russe** | 100% | 🇹🇷 **Turc** | 100% | 🇯🇵 **Japonais** | 100% |
| 🇰🇷 **Coréen** | 100% | 🇨🇳 **Chinois** | 100% | 🇵🇹 **Portugais** | 100% |
| 🇨🇿 **Tchèque** | 100% | 🌐 **Original** | 100% | 🇨🇳 **Chinois (Alt)** | 100% |

*Pour plus de détails sur le système de localisation, consultez :* [`INFO_STRINTABLE.md`](file:///c:/Users/kevin/Documents/Arma%203/missions/La Legion [FrenchPoint].Tanoa/INFO_STRINTABLE.md).

---

## 🏗️ Architecture Détaillée du Projet

La cible est une architecture modulaire en SQF pour SP et COOP 1–6. Le partage des tâches et le spawn des IA doivent être maîtrisés par l'autorité serveur ; les briefings et actions locales sont initialisés pour chaque joueur. Cette compatibilité reste à valider en jeu.

```
La Legion [FrenchPoint].Tanoa/
├── init.sqf                      # Point d'entrée principal de la mission
├── description.ext               # Déclaration des fonctions (CfgFunctions), sons, musiques et GUI
├── stringtable.xml               # Base de données de localisation (15 langues traduites)
├── Dialogs/                      # Définitions des interfaces graphiques (GUI)
│   └── main_menu.hpp             # Panneau de lancement tactique 3D
└── Functions/                    # Modules fonctionnels de la mission
    ├── Spawn/                    # Centre de commandement et préparation de mission
    ├── Task/                     # Moteur procédural des opérations et cinématiques
    ├── Team/ & Player/           # Escouade, identité, R.O.E et continuité Solo
    ├── Medical/                  # Gestion des soins et de l'auto-médication IA
    ├── Helicopter/ & Drone/      # Soutien tactique 0-8 (Largages, CAS, Drone, Extraction)
    ├── Civilian/                 # Foule civile, comportement, fuite et faune
    ├── Environment/              # Météo dynamique, anti-noyade et ouverture de portes
    └── UI/                       # Radio militaire TTS et affichage sous-titré
```

---

### 🔄 1. Pipeline Global d'Exécution (Cycle de Vie de la Mission)

1. **Initialisation (`init.sqf`) :** Dès le chargement, les 6 membres de l'escouade (`player_0` à `player_5`) sont immunisés temporairement, leurs identités procédurales sont assignées, les gestionnaires d'ambiance et de confort démarrent en arrière-plan, et le joueur est plongé dans un fondu noir ouvrant le centre de commandement tactique.
2. **Centre de Commandement 3D (`Functions/Spawn/`) :** Le joueur configure son opération sur un panneau à 3 colonnes : choix de l'heure, de la météo, du véhicule d'appui (visualisé en direct via une caméra 3D PiP) et sélection de 1 à 3 missions optionnelles.
3. **Insertion Cinématique (`fn_intro_01` / `fn_intro_02`) :** Une cinématique immersive dépose l'escouade sur la zone d'opération au ras des arbres en hélicoptère UH-80 Ghost Hawk vanilla (ou largage aéroporté), accompagnée du *Chant de la Légion Étrangère*.
4. **Arsenal & Logistique Véhicule (`fn_spawnStartArsenal`, `fn_initVehicleLoadout`) :** Au point de départ, une caisse d'arsenal complète permet d'ajuster l'armement. Tout équipement choisi par le joueur synchronise automatiquement les munitions et chargeurs correspondants dans le coffre du véhicule de patrouille.
5. **Génération Procédurale en Cascade (`Functions/Task/`) :** L'arrivée à proximité du secteur d'opération déclenche automatiquement la mission d'infiltration (Tâche A), la surveillance de la population civile (Tâche B) et les objectifs optionnels choisis.
6. **Extraction Tactique (`fn_extraction`, `fn_extraction_secure`) :** L'évacuation n'est jamais automatique. Le joueur appelle manuellement l'hélicoptère d'extraction via le menu radio Support (0-8-3) quand il le décide pour terminer sa session.

---

### 🧩 2. Les Sous-Systèmes & Fonctionnalités Clés

#### 🎮 A. Escouade & Continuité SP/COOP (`Functions/Team/` & `Functions/Player/`)
* **Randomisation Procédurale (`fn_initIdentity`, `fn_initLoadout`) :** Chaque partie attribue des visages, voix, lunettes, casques et gilets de la Légion uniques à chaque coéquipier tout en conservant les uniformes réglementaires et l'armement.
* **Continuité Immédiate sans Game Over (`fn_switchToAI`) :** Si le joueur tombe au combat, la caméra et le contrôle passent instantanément au membre survivant le plus proche au sein de l'escouade.
* **Règles d'Engagement à la Molette (`fn_addRoeActions`, `fn_applyRoE`) :** 5 postures tactiques instantanées modifiant le comportement des coéquipiers (Infiltration discrète, Normal, Défense à 360°, Regroupement d'urgence en sprint, Assaut agressif).
* **Auto-Soin des Coéquipiers (`fn_aiHealSelf`, `fn_addHealAction`) :** Les coéquipiers IA blessés se soignent et se stabilisent de façon autonome dès qu'ils sont hors de danger immédiat.

#### 🎯 B. Moteur des Missions Procédurales (`Functions/Task/`)
* **Tâches Systématiques :**
  * **Tâche A (`fn_taskA`) :** Se rendre sur le secteur d'opération pour débloquer le réseau d'objectifs.
  * **Tâche B (`fn_taskB`) :** Protéger les civils insulaires (toute bavure sanctionne l'opération d'un échec).
  * **Tâche C (`fn_taskC`) :** Assurer la survie du détachement lors de l'évacuation finale.
* **Catalogue des Missions Optionnelles (Tâches D) :**
  * **Captif (`fn_taskD_captive`) :** Libération d'un agent retenu sous surveillance et ralliement au groupe.
  * **Cible Prioritaire HVT (`fn_taskD_hvt`) :** Élimination du baron de la drogue protégé par sa garde d'élite.
  * **Relais Radio (`fn_taskD_transmission`) :** Sabotage d'antennes émettrices avec amorces sonores et détonation.
  * **Citernes Chimiques (`fn_taskD_chemical`) :** Sécurisation et extraction par hélicoptère lourd Huron vanilla avec câbles PhysX, ou détonation catastrophique avec onde de choc et nuage toxique (les épaves restent définitivement sur le terrain).
  * **Renseignements (`fn_taskD_documents`) :** Récupération de documents confidentiels sur un officier adverse.
  * **Véhicules Antiaériens (`fn_taskD_tigris`) :** Destruction des DCA blindées du cartel pour libérer l'espace aérien.
* **Mission d'Urgence Bonus (`fn_taskBonus`) :** Le commandement peut contacter par radio l'escouade pour lui assigner un objectif surprise supplémentaire dans un secteur distant.
* **Réaction & Contre-Attaque (`fn_taskCleanup`) :** La complétion d'un objectif déclenche une traque active des insurgés survivants vers la position du joueur.

#### 🚁 C. Soutien Tactique & Appui Aérien (`Functions/Helicopter/` & `Functions/Drone/`)
* **Menu de Communication Dédié (0-8) :** Accessible via la radio tactique native d'Arma 3 :
  * **0-8-1 (Ravitaillement) :** Parachutage d'une caisse logistique complète balisée par des fumigènes tricolores (Bleu-Blanc-Rouge) et réarmement interactif des coéquipiers.
  * **0-8-2 (Véhicule) :** Dépose d'un véhicule de transport de remplacement en cas de perte de mobilité.
  * **0-8-3 (Extraction) :** Évacuation manuelle de l'escouade par hélicoptère allié.
  * **0-8-4 (CAS) :** Appui-feu aérien rapproché au canon sur zone désignée.
  * **0-8-5 (Drone) :** Survol de reconnaissance d'un MQ-12 Falcon vanilla avec flux de télémétrie.

#### 🌴 D. Simulation du Monde & Vie Civile (`Functions/Civilian/`)
* **6 Profils de Déplacement Civil (`fn_ambientCivilians`) :** Les civils vivent naturellement (présents à l'intérieur, marcheurs sur routes, voyageurs inter-villages, chalands de marché, personnes assises).
* **4 Stratégies de Fuite Sous le Feu :** Dès les premiers tirs, les civils paniquent, se réfugient dans les habitations ou fuient par les chemins, propageant la panique aux résidents proches.
* **Séparation Civils / Ennemis :** Respect strict entre les femmes civiles inoffensives (immunité totale) et les combattantes armées du cartel.
* **Sécurité Anti-Noyade (`fn_preventWater`) :** Algorithme repositionnant immédiatement toute unité civile ou ennemie égarée dans l'océan ou les canaux pour éliminer les noyades absurdes.

#### 🚪 E. Confort de Jeu & Environnement (`Functions/Environment/`)
* **Portes Automatiques Intelligentes (`fn_doorSecurity`) :** Ouverture automatique à 4,5 m des portes, volets roulants et portails de clôture pour éviter que les coéquipiers IA ne restent coincés, avec fermeture automatique après passage.
* **Météorologie Vivante (`fn_randomWeather`) :** Évolution fluide et naturelle du ciel, de la brume et du vent au fil de l'opération.

#### 🌐 F. Traduction & Audio TTS (`Functions/UI/`, `stringtable.xml`)
* **Sous-Titres & Menus 100% Traduits :** Prise en charge native intégrale des 15 langues d'Arma 3 dans tous les menus, directives et dialogues.
* **Radio Militaire TTS (`fn_radioMessage`) :** Communications audio des pilotes et du QG transmises avec un traitement sonore Lo-Fi radio pour une immersion maximale.

---

## 📚 Documentation Technique Complémentaire

Pour approfondir les détails d'implémentation et les directives de configuration, consultez les guides dédiés :

* **[ARCHI.md](file:///c:/Users/kevin/Documents/Arma%203/missions/La Legion [FrenchPoint].Tanoa/ARCHI.md)** : Répertoire exhaustif de toutes les fonctions SQF déclarées et variables globales de la mission.
* **[INFO_STRINTABLE.md](file:///c:/Users/kevin/Documents/Arma%203/missions/La Legion [FrenchPoint].Tanoa/INFO_STRINTABLE.md)** : Guide de gestion et de compilation des traductions multilingues (`stringtable.xml`).
* **[INFO_TANOA.md](file:///c:/Users/kevin/Documents/Arma%203/missions/La Legion [FrenchPoint].Tanoa/INFO_TANOA.md)** : Contexte narratif et adaptation géographique de l'archipel.
* **[INFO_STEAM.md](file:///c:/Users/kevin/Documents/Arma%203/missions/La Legion [FrenchPoint].Tanoa/INFO_STEAM.md)** : Modèle de publication officiel pour le Steam Workshop.
* **[Music/MUSIC.md](file:///c:/Users/kevin/Documents/Arma%203/missions/La Legion [FrenchPoint].Tanoa/Music/MUSIC.md)** : Retranscription intégrale, traduction et chronologie du *Chant de la Légion Étrangère*.

---

## 👤 Auteur & Crédits

* **Créateur & Développeur Principal :** **Friart Script** ([@friartscript](https://steamcommunity.com))
* **Moteur & Univers :** [Bohemia Interactive](https://www.bohemia.net/) (*Arma 3 Apex*)
* **Équipements OFrP :** [Guide des classes Operation FrenchPoint](https://steamcommunity.com/sharedfiles/filedetails/?id=2059431006)
* **Unités et contenus moddés :** Operation FrenchPoint (OFrP) ; aucune dépendance TCGM Girls, CUP ou autre mod tiers.
* **Bande Son d'Introduction :** *Chant de la Légion Étrangère* (Legion 001 - Marche)

---

<div align="center">

*« Analyser les données de vos missions et informations qui vous sont données et tout se passera bien. »*  
**OPORD — Commandement de la Légion Étrangère**

</div>
