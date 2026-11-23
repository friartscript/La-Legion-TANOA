# Configuration Eden — variables et zones d'opération

Ce document décrit les noms à donner aux objets et aux marqueurs dans Eden. Les champs **Variable Name** des objets et **Name** des marqueurs sont deux choses différentes : les marqueurs d'opération ne reçoivent pas de variable d'objet.

## Dépendances autorisées

La mission doit fonctionner avec Arma 3/Tanoa et les contenus **Operation FrenchPoint (OFrP)** utilisés. **Aucune dépendance CUP ni aucun autre mod tiers** n'est autorisé : cela inclut unités jouables, ennemis, alliés et civils. Une classe vanilla du jeu de base est permise ; une classe provenant d'un mod doit être OFrP. ACE3 est facultatif et ne doit pas être requis pour lancer ou terminer la mission.

> Les marqueurs typés ci-dessous définissent la convention cible. Certaines fonctions de tâches historiques utilisent encore `marker_0` comme repli ; le sélecteur dynamique utilise uniquement les sites `marker_A_1` à `marker_E_99` et prépare les points intérieurs des sites retenus.

## 1. Variables des objets à renseigner dans Eden

Sélectionner l'objet dans Eden et renseigner son champ **Variable Name** exactement comme indiqué.

| Objet dans Eden | Variable Name | Rôle / consigne |
|---|---|---|
| Chef d'équipe jouable | `player_0` | Chef d'équipe ; plusieurs scripts le recherchent directement. |
| Équipier jouable 1 | `player_1` | Jouable / contrôlable par le système de transfert. |
| Équipier jouable 2 | `player_2` | Idem. |
| Équipier jouable 3 | `player_3` | Idem. |
| Équipier jouable 4 | `player_4` | Idem. |
| Équipier jouable 5 | `player_5` | Idem. |

### Groupe jouable 1–6

- Utiliser un seul slot joueur principal (`player_0`) et définir `player_1` à `player_5` comme unités jouables/contrôlables selon la configuration SP ou COOP choisie.
- En COOP, ne pas assigner plusieurs joueurs humains au même objet. Garder les variables uniques et vérifier que les six unités apparaissent correctement dans le lobby.
- Des fonctions vérifient également les formes `player_00`, `player_01`, etc. Ne pas utiliser ces noms comme convention principale : préférer `player_0` à `player_5` et harmoniser les scripts qui recherchent l'ancienne forme.
- Les noms d'objets constatés dans la scène doivent être comparés aux noms ci-dessus dans Eden ; la configuration rapifiée de `mission.sqm` ne permet pas de confirmer ici tous les champs Variable Name.

**Constat de l'inventaire :** l'extraction statique initiale de `mission.sqm` révélait une unité joueur sans nom de variable visible et cinq noms `player_2` à `player_6`. La dernière vue Eden montre encore plusieurs noms `player_3` à `player_6` et le chef de groupe sans nom visible. Vérifier les six unités et les réassigner à `player_0`–`player_5` avant de dépendre des fonctions d'identité/transfert.

### Objets de spawn de tâches et préparation dynamique

Ne placer **aucun** `Game Logic` ni héliport invisible (`Land_HelipadEmpty_F`, `Helipad_Invisible_F`, `HeliH`, `HeliHEmpty` ou `HeliHSquare_F`) dans Eden. Au démarrage serveur, `LL_fnc_prepareMissionSites` supprime ces objets à l'exécution, choisit une LZ aléatoire sur une position sèche, plane et dégagée à l'intérieur d'un marqueur d'aire, puis sélectionne deux ou trois sites `marker_A_1` à `marker_E_99`. Le premier site est à au moins 950 m de la LZ ; les suivants sont les sites valides les plus proches, sans réutiliser une famille.

Les points intérieurs sont calculés depuis les emplacements de bâtiments uniquement dans les sites retenus. Les marqueurs d'aire doivent être des ellipses ou rectangles aux dimensions valides ; seuls les marqueurs `marker_<famille>_<index>` avec index supérieur à zéro sont des objectifs. `LL_logic_occupied` reste une variable d'état gérée par script et ne se renseigne pas dans Eden. Les résultats et les cas impossibles sont inscrits dans le RPT.

Pour les livraisons et l'extraction, `LL_fnc_nearestPlayerLZ` calcule une position sûre autour des joueurs vivants sans rechercher ni créer de point d'héliport préplacé. Si aucun terrain adéquat n'est trouvé, les livraisons sont refusées ; l'extraction conserve un repli vers la position de la tâche et l'inscrit dans le RPT.

## 2. Cinq familles de marqueurs de mission

Les marqueurs ci-dessous servent à identifier des **sites de mission**, pas des objectifs ou des points de spawn individuels. Créer plusieurs sites par famille et les nommer sans espace, avec un index unique.

| Famille | Noms | Utilisation recommandée | Présentation Eden suggérée |
|---|---|---|---|
| A — Villages | `marker_A_1`, `marker_A_2`, … `marker_A_99` | Villages, quartiers habités et zones civiles ; priorité à la protection des civils, documents ou arrestation/capture. | Ellipse de couleur bleue, contour discret. |
| B — Littoral | `marker_B_1`, `marker_B_2`, … `marker_B_99` | Ports, plages, criques, installations de pêche ou de contrebande ; accès maritime ou héliporté à vérifier. | Ellipse turquoise, contour discret. |
| C — Jungle | `marker_C_1`, `marker_C_2`, … `marker_C_99` | Camps, clairières, relais isolés et pistes en forêt ; prévoir des logiques en terrain praticable. | Ellipse verte, contour discret. |
| D — Infrastructures | `marker_D_1`, `marker_D_2`, … `marker_D_99` | Dépôts, laboratoires, antennes, installations industrielles ou positions militarisées. | Ellipse orange, contour discret. |
| E — Famille complémentaire | `marker_E_1`, `marker_E_2`, … `marker_E_99` | Sites complémentaires ; préciser leur catégorie dans la scène et le briefing. | Couleur distincte, contour discret. |

### Paramètres des marqueurs de site

1. Dans l'éditeur de marqueurs, renseigner **Name** avec le nom exact (`marker_A_1`, etc.). Le texte affiché peut être descriptif, par exemple `A | Village Nord`; il n'est pas utilisé comme identifiant.
Pour chaque famille, réserver les noms de `1` à `99` : `marker_A_1` à `marker_A_99`, `marker_B_1` à `marker_B_99`, `marker_C_1` à `marker_C_99`, `marker_D_1` à `marker_D_99` et `marker_E_1` à `marker_E_99`. Créer uniquement les marqueurs correspondant à des sites réellement configurés ; les numéros inutilisés restent libres. L'index `0` est réservé à la compatibilité temporaire et ne peut pas être tiré au hasard.

**État observé dans Eden (à confirmer sur la scène sauvegardée) :** la première extraction statique montrait `marker_A_0` à `marker_A_3`. Les vues ultérieures montrent des marqueurs des familles A à E. Vérifier que tous les noms sont sauvegardés, puis valider les secteurs et les distances ; aucun de ces constats visuels ne confirme encore le seuil de 950 m.

### Règles de sélection des sites

- Une opération comporte au hasard deux ou trois objectifs sur autant de sites distincts.
- Chaque site sélectionné doit appartenir à une famille différente parmi A, B, C, D et E ; le numéro de chaque marqueur est compris entre 1 et 99.
- Après l'introduction, utiliser `MISSION_intro_lz` comme position de départ. Le premier site choisi doit être à **au moins 950 m** de cette LZ (`distance2D`).
- Pour le deuxième objectif, choisir le site valide non utilisé le plus proche du premier ; pour le troisième, choisir le site valide non utilisé le plus proche du deuxième. La distance minimale de 950 m ne s'applique pas entre les sites d'objectifs.
- Tirer d'abord au hasard deux ou trois objectifs ; si la chaîne de trois sites valides ne peut pas être complétée, retenter avec deux. Avec moins de deux sites valides, le démarrage doit signaler l'erreur au lieu de créer une opération partielle.

### Compatibilité avec l'ancien nom

La correspondance demandée est :

| Ancien identifiant | Nouveau site |
|---|---|
| `marker_0` | `marker_A_0` (alias transitoire, hors du pool aléatoire) |

Cette correspondance signifie **renommer/remapper la référence dans les scripts**, pas créer deux marqueurs superposés. Les références par défaut `marker_0` présentes notamment dans les fonctions d'insertion et de tâches doivent être migrées vers une sélection explicite. `marker_A_0` peut servir d'alias temporaire pour les scripts hérités, mais ne doit jamais être sélectionné comme site d'opération.

## 3. Secteurs de Tanoa et déplacements entre îles

Les cinq familles A–E décrivent le **type de terrain** ; elles ne garantissent pas qu'un site soit joignable depuis un autre par la route. Tanoa comporte des bras de mer et des zones insulaires sans liaison terrestre continue.

- Créer des marqueurs de secteur séparés, nommés `zone_<SECTEUR>` (par exemple `zone_Tanoa_Principal`, `zone_Ile_Nord`), couvrant des groupes de sites appartenant au même secteur géographique.
- Un marqueur de site `marker_A_1` / `marker_B_1` / etc. doit se trouver dans un seul secteur. Les marqueurs `zone_*` sont des limites de sélection, pas des objectifs ; leur préfixe ne doit pas être `marker_`.
- Pour une opération sans transport entre objectifs, tirer les deux ou trois sites dans un secteur dont le déplacement au sol ou à pied est continu. Le premier site reste à 950 m minimum de `MISSION_intro_lz` ; les suivants sont choisis par proximité parmi les sites accessibles.
- Si l'opération traverse plusieurs îles/secteurs, prévoir un transport explicite (hélicoptère ou bateau) entre les objectifs et valider les zones de poser/débarquement. Ne pas considérer deux marqueurs comme accessibles simplement parce qu'ils sont proches à vol d'oiseau.
- La sélection doit écarter un site s'il n'a pas assez de logiques de spawn valides ou si son itinéraire est incompatible avec le moyen de déplacement prévu. Pour le premier site, vérifier la distance de 950 m depuis `MISSION_intro_lz`.

La liste des secteurs et l'association exacte de chaque site doivent être maintenues dans le sélecteur d'opération lorsqu'il sera implémenté. Le nom du marqueur de site ne contient pour l'instant que le type et l'index ; le secteur doit donc être défini dans cette configuration ou par une règle Eden explicitement prise en charge par le code.

## 4. Variables de mission initialisées par les scripts

Ces noms existent dans le code ou sont attendus à l'exécution. Ils ne sont **pas** des Variable Name à attribuer à un objet Eden.

| Variable | Rôle | Action de configuration |
|---|---|---|
| `MISSION_var_selected_vehicle_class` | Classe du véhicule d'équipe récupérée par l'insertion ; provient actuellement de la sélection du véhicule. | Sans menu de lancement, initialiser une classe valide par défaut dans le démarrage de mission ou supprimer cette dépendance. |
| `MISSION_var_targetPos` | Position utilisée par la gestion/destruction des civils et animaux ambiants. | Définir à l'initialisation et mettre à jour à chaque changement de secteur. |
| `MISSION_CivilianClasses_Female` | Liste de classes civiles féminines, lue par les fonctions civiles et les otages. | Définir avec des classes réellement installées et validées ; liste vide si aucune classe compatible n'est configurée. |
| `MISSION_EnemyClasses_Female` | Liste de classes ennemies féminines, lue par les patrouilles et les tâches. | Définir avec des classes de faction ennemie validées ; ne pas y mélanger les civiles. |
| `MISSION_intro_lz`, `MISSION_intro_finished` | État d'insertion et fin de la séquence d'introduction. | Écrites par les fonctions d'insertion ; ne pas leur attribuer une valeur par un objet Eden. |
| `vehicule_team`, `MISSION_start_crate` | Véhicule d'équipe et caisse d'arsenal créés en jeu. | Créés par scripts ; ne pas placer de doublon avec le même rôle sans vérifier le code d'initialisation. |
| `LL_logic_occupied`, `LL_g_usedTaskPos` | Réservation des points de spawn pendant une tâche. | État temporaire géré par les scripts. |

Les deux listes de classes de factions doivent être recherchées dans les initialisations complètes de la mission : elles ne sont pas déclarées dans les scripts `Functions` actuellement visibles.

## 5. Contrôles à faire dans Eden avant export

- Chaque Variable Name d'objet est unique ; chaque marqueur a un Name unique.
- Les six unités existent et sont configurées comme prévu pour les slots jouables/IA.
- Chaque site `marker_[A-E]_<index>` (index 1–99) a une position et une taille non nulle ; vérifier dans le RPT les positions intérieures et la LZ de départ générées.
- Une opération choisit deux ou trois familles différentes ; son premier site est à 950 m minimum de `MISSION_intro_lz`, puis les sites suivants sont choisis par proximité.
- Chaque marqueur de site appartient à un seul secteur `zone_*`.
- Les secteurs séparés par l'eau ne sont pas assemblés dans une même opération sans transport.
- Aucun objet `Heliport_<index>` n'est requis ; les positions de poser de soutien sont calculées à l'exécution.
- Vérifier les classes OFrP sélectionnées dans le mod installé et la présence des dépendances sur les postes COOP.
- Tester dans Eden/jeu que les familles A–E sont reconnues par la préparation dynamique ; le simple renommage des marqueurs ne remplace pas la migration des appels `marker_0` et des filtres `marker_`.

## 6. ACE3 facultatif

ACE3 ne doit pas être requis pour lancer ou terminer la mission. La configuration de base doit fonctionner avec les systèmes vanilla et les fournitures médicales vanilla.

- Mode sans ACE3 : Arma 3/Tanoa et les packs OFrP employés par la mission ; aucun appel ou objet ACE requis.
- Mode ACE3 : charger [ACE3](https://github.com/acemod/ACE3) et le paquet officiel [Operation FrenchPoint - ACE3 Compatibility](https://steamcommunity.com/sharedfiles/filedetails/?id=2084745436).
- Les objets médicaux `ACE_*` du ravitaillement sont optionnels et ne doivent être ajoutés que lorsque leurs classes existent. Garder les objets vanilla disponibles dans les deux modes.
- Tester les deux configurations en COOP avec le même ensemble de mods sur tous les clients. La mission ne doit pas produire d'erreur ni perdre sa fonctionnalité essentielle lorsque ACE3 est absent.
