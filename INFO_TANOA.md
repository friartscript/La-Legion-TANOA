# MISSION LÉGION ÉTRANGÈRE — ADAPTATION TANOA & OCÉAN INDIEN
**Document de Référence, Architecture Technique et Refonte Narrative (Lore Cartel / Mafia / Narcotrafic)**
*Mission : La Legion [FrenchPoint].Tanoa | Faction Joueur : French Foreign Legion | Date : 13 mars 2019 | Moteur : Arma 3*

---

## 1. NOUVEAU CONTEXTE OPÉRATIONNEL & GÉOPOLITIQUE : GUERRE CONTRE LES CARTELS

### 1.1 Cadre Géographique : L'Archipel de Tanoa / Océan Indien (Canal du Mozambique, Mayotte, Comores)
Le théâtre d'opérations quitte définitivement les déserts arides et les montagnes rocailleuses du Takistan pour l'environnement insulaire, tropical et maritime de **Tanoa**, transposé dans le bassin stratégique du **Sud-Ouest de l'Océan Indien** (archipels voisins du Canal du Mozambique, Mayotte, Comores et Madagascar).

* **Environnement physique** : Archipel tropical morcelé, forêts denses de jungle pluviale, mangroves côtières, lagons coralliens, réseaux fluviaux et zones portuaires clandestines.
* **Problématiques de terrain** : Rupture constante des lignes de vue par la canopée, omniprésence de cours d'eau et de côtes maritimes, dépendance aux pistes de brousse étroites et aux vecteurs héliportés.

### 1.2 La Faction Joueur : Légion Étrangère (Légion Étrangère)
La **Légion Étrangère** n'intervient plus dans une guerre civile conventionnelle contre des insurgés politiques du Moyen-Orient, mais sous mandat spécial militaire intergouvernemental de **contre-narcotrafic de haute intensité et de neutralisation des cartels militarisés** :
* **Mandat d'Intervention** : Démanteler les structures logistiques et militaires du syndicat du crime, assécher les voies maritimes d'exportation de stupéfiants, sécuriser les informateurs et officiers de liaison capturés, et rétablir la souveraineté républicaine sur l'archipel.
* **Doctrine Tactique** : Escouade d'opérateurs équipée OFrP, insertion et appui assurés par les hélicoptères vanilla UH-80 Ghost Hawk et Huron, avec surveillance drone MQ-12 Falcon.

### 1.3 Les Factions Locales
* **Population Civile** : Habitants de l'Océan Indien (Mahorais, Comoriens, Créoles, Tanoens). Communautés de pêcheurs, dockers, agriculteurs et villageois pris en étau entre la terreur imposée par les trafiquants et les opérations armées.
* **Opposition Armée (Le Syndicat / Cartel de l'Océan Indien)** : Organisation mafieuse transnationale lourdement armée. Elle contrôle les laboratoires de raffinage clandestins, dispose de vedettes go-fast, de factions de mercenaires étrangers et de milices locales (sicarios, patrouilles en pick-ups armés et guetteurs infiltrés au sein de la population civile).

---

## 2. ANALYSE ET REFONTE INTÉGRALE DU LORE DANS LE BRIEFING ET LES TÂCHES

### 2.1 Refonte des Textes du Carnet de Bord (Journal / Diary / Briefing)
Dans `Functions\Briefing\fn_initContext.sqf` et [stringtable.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/La Legion [FrenchPoint].Tanoa/stringtable.xml), les 3 volets du contexte sont réécrits pour évincer la guerre afghane/takistanaise au profit de la lutte contre le narcotrafic :

#### Volet 1 : Contexte Global (`STR_LL_Context_1`)
* **Ancien texte (Takistan)** : Guerre civile dévastatrice au Takistan, crise majeure au Moyen-Orient, Légion déployée pour sécuriser des ressources énergétiques.
* **Nouveau texte (Cartel Tanoa / Océan Indien)** :
  > *L'archipel de Tanoa et les îles environnantes du canal du Mozambique sont devenus la plaque tournante du narcotrafic international dans l'Océan Indien. Profitant de la porosité des frontières maritimes et de la corruption locale, un cartel mafieux surarmé (le « Syndikat ») a transformé la région en sanctuaire de production et d'acheminement de drogues dures et d'armes de contrebande. Les forces de police locale et les garde-côtes étant submergés et corrompus, le gouvernement a fait appel à la Légion Étrangère pour mener des frappes chirurgicales au cœur des sanctuaires du cartel.*

#### Volet 2 : Objectifs et Mandat (`STR_LL_Context_2`)
* **Ancien texte (Takistan)** : Restaurer l'ordre, pacifier le Takistan, contre-terrorisme.
* **Nouveau texte (Cartel Tanoa / Océan Indien)** :
  > *La Légion Étrangère est déployée avec les directives suivantes :*
  > * **1. Démantèlement des Infrastructures Illicites** : Destruction des laboratoires de traitement chimique, des terminaux radio de contrebande et neutralisation des véhicules d'appui lourd.
  > * **2. Élimination et Capture des Têtes de Réseau** : Traque des barons de la drogue (HVT), arrestation des lieutenants locaux et récupération de leurs livres de comptes clandestins.
  > * **3. Sauvetage & Exfiltration** : Récupération des agents infiltrés des stups et informateurs locaux retenus en otage avant leur exécution.
  > * **4. Protection des Populations** : Sanctionner immédiatement tout dommage collatéral envers les villageois et pêcheurs locaux pour ne pas basculer l'opinion publique en faveur des cartels.

#### Volet 3 : Contexte Narratif & Enjeux Secrets (`STR_LL_Context_3`)
* **Ancien texte (Takistan)** : Les superpuissances (OTAN/CSAT/USA) attisent les braises pour s'emparer des ressources.
* **Nouveau texte (Cartel Tanoa / Océan Indien)** :
  > *Sous couvert d'une simple mafia locale, le cartel bénéficie du soutien clandestin d'entités mercenaires et de réseaux financiers internationaux qui recyclent l'argent sale à travers les ports francs de la région. Le matériel militaire intercepté (pickups militarisés avec armes lourdes, brouilleurs de fréquences Tempest) démontre que les barons du trafic disposent d'un arsenal capable de contester les espaces côtiers et de menacer les aéronefs de patrouille.*

---

### 2.2 Réinterprétation Thématique de Tous les Objectifs de Mission

Chaque tâche SQF existante s'intègre naturellement dans cette trame narrative sans altérer la mécanique de jeu :

| Tâche / Script | Ancien Contexte (Takistan) | Nouveau Contexte Adapté (Cartel / Mafia / Océan Indien) |
| :--- | :--- | :--- |
| **Tâche A (`fn_taskA.sqf`)**<br>`task_mandatory_move` | Atteindre la zone d'opération hostile au Takistan. | **Infiltration du Secteur du Cartel** : Débarquement discret et progression à travers la mangrove/jungle vers la zone contrôlée par la mafia locale. |
| **Tâche B (`fn_taskB.sqf`)**<br>`task_mandatory_civ` | Protéger les civils takistanais contre la guerre. | **Zéro Victime Civile / Population Insulaire** : Interdiction absolue de blesser les habitants mahorais/tanoens. Éviter toute provocation qui pousserait les villageois dans les bras des trafiquants. |
| **Tâche C (`fn_taskC.sqf`)**<br>`task_mandatory_ext` | Extraction et survie de l'équipe face aux insurgés. | **Exfiltration d'Urgence** : Évacuer la zone de poser avant que les renforts de sicarios et de vedettes armées ne submergent le point d'extraction. |
| **Otage (`fn_taskD_captive.sqf`)**<br>`taskD_captive` | Agent de renseignement capturé par des rebelles afghans. | **Agent Anti-Drogue Infiltré** : Un agent des services de renseignement / stups infiltré dans le cartel a été démasqué. Retenu dans un camp retranché, il doit être extrait avant son exécution par les tueurs du cartel. |
| **Cible HVT (`fn_taskD_hvt.sqf`)**<br>`taskD_hvt` | Commandant insurgé / chef de guerre afghan. | **Baron de la Drogue / Parrain du Cartel** : Le capo local supervisant le trafic régional d'armes et de stupéfiants se trouve sur zone, protégé par ses gardes du corps privés lourdement armés. À éliminer ou capturer. |
| **Transmissions (`fn_taskD_transmission.sqf`)**<br>`taskD_transmission` | Stations radio de propagande terroriste. | **Terminaux Radio de Contrebande** : Antennes relais clandestines utilisées par le cartel pour coordonner les go-fast maritimes et brouiller les communications de la gendarmerie maritime. À faire sauter aux explosifs. |
| **Citerne Chimique (`fn_taskD_chemical.sqf`)**<br>`taskD_chemical` | Convoi d'armes chimiques / gaz toxique de guerre. | **Laboratoire Mobile / Citerne de Précurseurs de Drogue** : Citerne contenant des précurseurs chimiques industriels (acétone, acide sulfurique, solvants de pureté) servant au raffinage à grande échelle des stupéfiants. Véhicule inflammable et toxique à sécuriser intact pour extraction par élingage lourd (Slingload). |
| **Documents (`fn_taskD_documents.sqf`)**<br>`taskD_documents` | Plans d'attaque terroriste sur le corps d'un officier. | **Comptabilité Noire & Registres de Corruption** : Fouiller le corps du trésorier/lieutenant du cartel pour récupérer les clés USB et documents listant les fonctionnaires corrompus, comptes offshore et routes de livraison maritime. |
| **Arme Lourde Mobilité (`fn_taskD_tigris.sqf`)**<br>`taskD_tigris` | Blindé chenillé antiaérien Tigris (`O_APC_Tracked_02_AA_F`) volé par les milices. | **Technical du Cartel (Pickup avec Arme Lourde)** : Le blindé Tigris lourd (incohérent pour une mafia insulaire) est remplacé par un **Pickup Tout-Terrain armé d'une mitrailleuse lourde cal. 50 ou d'un bitube lourd (DShKM / ZU-23-2)**, servant de véhicule d'interdiction et d'escorte lourd aux trafiquants. |
| **Embuscade (`fn_rebelAmbush.sqf`)**<br>`rebelAmbush` | Embuscade surprise de paysans armés. | **Guet-apens de Sicarios / Tueurs du Cartel** : Des hommes de main du cartel déguisés en civils locaux tendent une embuscade coordonnée pour intercepter l'escouade. |

---
