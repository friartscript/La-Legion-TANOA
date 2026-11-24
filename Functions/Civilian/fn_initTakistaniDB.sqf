private _terrain = toLower worldName;

if (_terrain in ["altis", "stratis", "malden"]) then {
    MISSION_CivilianClasses_Male = [
        "C_man_1", "C_man_p_beggar_F", "C_man_polo_1_F", "C_man_polo_2_F",
        "C_man_polo_3_F", "C_man_polo_4_F", "C_man_polo_5_F", "C_man_polo_6_F",
        "C_man_shorts_1_F", "C_man_shorts_2_F", "C_man_shorts_3_F", "C_man_shorts_4_F",
        "C_man_w_worker_F", "C_Man_Fisherman_01_F"
    ];
    MISSION_CivilianNames_Male = [
        ["Nikos Gekas", "Nikos", "Gekas"], ["Stavros Doukas", "Stavros", "Doukas"],
        ["Petros Kouris", "Petros", "Kouris"], ["Dimitrios Thanou", "Dimitrios", "Thanou"],
        ["Kostas Lyras", "Kostas", "Lyras"], ["Alexandros Metaxas", "Alexandros", "Metaxas"],
        ["Christos Papas", "Christos", "Papas"], ["Elias Samaras", "Elias", "Samaras"],
        ["Georgios Voulgaris", "Georgios", "Voulgaris"], ["Ioannis Zervas", "Ioannis", "Zervas"],
        ["Konstantinos Katsaros", "Konstantinos", "Katsaros"], ["Michail Economou", "Michail", "Economou"],
        ["Panagiotis Ladas", "Panagiotis", "Ladas"], ["Spyridon Makris", "Spyridon", "Makris"],
        ["Theodoros Nomikos", "Theodoros", "Nomikos"], ["Vasileios Petridis", "Vasileios", "Petridis"]
    ];
    MISSION_CivilianNames_Female = [
        ["Eleni Gekas", "Eleni", "Gekas"], ["Maria Doukas", "Maria", "Doukas"],
        ["Sofia Kouris", "Sofia", "Kouris"], ["Kalliopi Thanou", "Kalliopi", "Thanou"],
        ["Aikaterini Lyras", "Aikaterini", "Lyras"], ["Anastasia Metaxas", "Anastasia", "Metaxas"],
        ["Dimitra Papas", "Dimitra", "Papas"], ["Eirini Samaras", "Eirini", "Samaras"],
        ["Georgia Voulgaris", "Georgia", "Voulgaris"], ["Ioanna Zervas", "Ioanna", "Zervas"]
    ];
    MISSION_CivilianMaleFaces = [
        "GreekHead_A3_01", "GreekHead_A3_02", "GreekHead_A3_03", "GreekHead_A3_04",
        "GreekHead_A3_05", "GreekHead_A3_06", "GreekHead_A3_07", "GreekHead_A3_08", "GreekHead_A3_09",
        "WhiteHead_01", "WhiteHead_02", "WhiteHead_03", "WhiteHead_04", "WhiteHead_05"
    ];
    MISSION_Voices_Male = [
        "Male01GRE", "Male02GRE", "Male03GRE", "Male04GRE", "Male05GRE", "Male06GRE"
    ];
    MISSION_CivilianUniforms_Male = [
        "U_C_Poloshirt_blue", "U_C_Poloshirt_burgundy", "U_C_Poloshirt_redwhite",
        "U_C_Poloshirt_salmon", "U_C_Poloshirt_stripped", "U_C_Poloshirt_tricolour",
        "U_C_Poor_shorts_1_F", "U_C_Commoner_shorts_F", "U_C_HunterBody_grn",
        "U_C_Man_casual_1_F", "U_C_Man_casual_2_F", "U_C_Mechanic_01_F"
    ];
    MISSION_CivilianHats = [
        "H_StrawHat", "H_StrawHat_dark", "H_Cap_blu", "H_Cap_red", "H_Cap_tan",
        "H_Cap_oli", "H_Bandanna_surfer", "H_Hat_checker", ""
    ];
    MISSION_EnemyClasses_Male = [
        "B_G_Soldier_F", "B_G_Soldier_lite_F", "B_G_Soldier_AR_F", "O_G_Soldier_F"
    ];
    MISSION_EnemyUniforms_Male = [
        "U_BG_Guerilla1_1", "U_BG_Guerilla2_1", "U_BG_Guerilla2_2", "U_BG_Guerilla3_1",
        "U_BG_leader", "U_I_G_resistanceLeader_F"
    ];
    MISSION_EnemyHats = [
        "H_Bandanna_khk", "H_Bandanna_cbr", "H_Booniehat_khk", "H_Cap_blk", "H_Shemag_olive", ""
    ];
} else {
    if (_terrain in ["enoch", "livonia"]) then {
        MISSION_CivilianClasses_Male = [
            "C_Man_1_enoch_F", "C_Farmer_01_enoch_F", "C_man_w_worker_F", "C_man_1"
        ];
        MISSION_CivilianNames_Male = [
            ["Jan Nowak", "Jan", "Nowak"], ["Tomasz Kowalski", "Tomasz", "Kowalski"],
            ["Michal Wisniewski", "Michal", "Wisniewski"], ["Piotr Wojcik", "Piotr", "Wojcik"],
            ["Krzysztof Kaminski", "Krzysztof", "Kaminski"], ["Stanislaw Lewandowski", "Stanislaw", "Lewandowski"],
            ["Andrzej Zielinski", "Andrzej", "Zielinski"], ["Pawel Szymanski", "Pawel", "Szymanski"],
            ["Jakub Wozniak", "Jakub", "Wozniak"], ["Marek Kozlowski", "Marek", "Kozlowski"]
        ];
        MISSION_CivilianNames_Female = [
            ["Anna Nowak", "Anna", "Nowak"], ["Maria Kowalska", "Maria", "Kowalska"],
            ["Katarzyna Wisniewska", "Katarzyna", "Wisniewska"], ["Malgorzata Wojcik", "Malgorzata", "Wojcik"],
            ["Agnieszka Kaminska", "Agnieszka", "Kaminska"], ["Barbara Lewandowska", "Barbara", "Lewandowska"]
        ];
        MISSION_CivilianMaleFaces = [
            "LivonianHead_1", "LivonianHead_2", "LivonianHead_3", "LivonianHead_4",
            "LivonianHead_5", "LivonianHead_6", "LivonianHead_7", "LivonianHead_8",
            "LivonianHead_9", "LivonianHead_10", "WhiteHead_01", "WhiteHead_02"
        ];
        MISSION_Voices_Male = [
            "Male01POL", "Male02POL", "Male03POL", "Male01RUS", "Male02RUS"
        ];
        MISSION_CivilianUniforms_Male = [
            "U_C_Uniform_Farmer_01_F", "U_C_E_LooterJacket_01_F", "U_I_L_Uniform_01_tshirt_olive_F",
            "U_C_Mechanic_01_F", "U_C_Journalist", "U_C_HunterBody_grn", "U_C_Poloshirt_blue"
        ];
        MISSION_CivilianHats = [
            "H_Watchcap_blk", "H_Watchcap_camo", "H_Cap_blk", "H_Cap_oli", "H_Hat_Tanoa_F", ""
        ];
        MISSION_EnemyClasses_Male = [
            "I_L_Criminal_SG_F", "I_L_Criminal_SMG_F", "I_L_Looter_Rifle_F", "O_G_Soldier_F"
        ];
        MISSION_EnemyUniforms_Male = [
            "U_I_L_Uniform_01_camo_F", "U_I_L_Uniform_01_deserter_F", "U_BG_Guerilla1_1", "U_BG_Guerilla2_1"
        ];
        MISSION_EnemyHats = [
            "H_Booniehat_oli", "H_Watchcap_blk", "H_Cap_oli", ""
        ];
    } else {
        if (_terrain in ["takistan", "shapur_baf", "zargabad", "fallujah"]) then {
            MISSION_CivilianClasses_Male = [
                "C_man_1", "C_man_p_beggar_F", "C_man_w_worker_F"
            ];
            MISSION_CivilianNames_Male = [
                ["Ali Mohamed", "Ali", "Mohamed"], ["Said Abdallah", "Said", "Abdallah"],
                ["Mohamed Bacar", "Mohamed", "Bacar"], ["Nassim Soumaila", "Nassim", "Soumaila"],
                ["Fahad Toihir", "Fahad", "Toihir"], ["Ibrahim Nassur", "Ibrahim", "Nassur"],
                ["Kassim Ahamada", "Kassim", "Ahamada"], ["Rachid El-Amine", "Rachid", "El-Amine"]
            ];
            MISSION_CivilianNames_Female = [
                ["Fatima Said", "Fatima", "Said"], ["Amina Abdallah", "Amina", "Abdallah"],
                ["Mariama Mohamed", "Mariama", "Mohamed"], ["Halima Hamada", "Halima", "Hamada"]
            ];
            MISSION_CivilianMaleFaces = [
                "PersianHead_A3_01", "PersianHead_A3_02", "PersianHead_A3_03"
            ];
            MISSION_Voices_Male = [
                "Male01PER", "Male02PER", "Male03PER"
            ];
            MISSION_CivilianUniforms_Male = [
                "U_C_Poloshirt_salmon", "U_C_Poloshirt_stripped", "U_C_Poor_shorts_1_F"
            ];
            MISSION_CivilianHats = [
                "H_Shemag_olive", "H_ShemagOpen_tan", "H_StrawHat", ""
            ];
            MISSION_EnemyClasses_Male = [
                "O_G_Soldier_F", "O_G_Soldier_lite_F", "O_G_Soldier_AR_F"
            ];
            MISSION_EnemyUniforms_Male = [
                "U_BG_Guerilla1_1", "U_BG_Guerilla2_1", "U_BG_Guerilla3_1"
            ];
            MISSION_EnemyHats = [
                "H_Shemag_olive", "H_ShemagOpen_tan", "H_ShemagOpen_khk"
            ];
        } else {
            MISSION_CivilianClasses_Male = [
                "C_Man_casual_1_F_tanoan", "C_Man_casual_2_F_tanoan", "C_Man_casual_3_F_tanoan",
                "C_Man_casual_4_F_tanoan", "C_Man_casual_5_F_tanoan", "C_Man_casual_6_F_tanoan",
                "C_man_sport_1_F_tanoan", "C_man_sport_2_F_tanoan", "C_man_sport_3_F_tanoan",
                "C_Man_casual_1_F_euro", "C_Man_casual_2_F_euro",
                "C_Man_casual_1_F_afro", "C_Man_casual_2_F_afro",
                "C_Man_casual_1_F_asia", "C_Man_casual_2_F_asia",
                "C_Man_casual_shorts_F", "C_man_w_worker_F", "C_Man_Fisherman_01_F"
            ];
            MISSION_CivilianNames_Male = [
                ["Aluna Babitu", "Aluna", "Babitu"], ["Abesaloma Bari", "Abesaloma", "Bari"],
                ["Ahonui Bavadra", "Ahonui", "Bavadra"], ["Akamu Bole", "Akamu", "Bole"],
                ["Alika Delai", "Alika", "Delai"], ["Atonio Ganilau", "Atonio", "Ganilau"],
                ["Eloni Koroi", "Eloni", "Koroi"], ["Etera Lomu", "Etera", "Lomu"],
                ["Fale Mara", "Fale", "Mara"], ["Fetu Maraiwai", "Fetu", "Maraiwai"],
                ["Hemi Molia", "Hemi", "Molia"], ["Henare Naikelekele", "Henare", "Naikelekele"],
                ["Hohepa Naitaku", "Hohepa", "Naitaku"], ["Holokai Naivalu", "Holokai", "Naivalu"],
                ["Ietoro Rambuka", "Ietoro", "Rambuka"], ["Ihaia Reihana", "Ihaia", "Reihana"],
                ["Kaikane Semiti", "Kaikane", "Semiti"], ["Keon Serevi", "Keon", "Serevi"],
                ["Kimo Timoci", "Kimo", "Timoci"], ["Lagi Tonono", "Lagi", "Tonono"],
                ["Liko Tuikabe", "Liko", "Tuikabe"], ["Lucas Turagabea", "Lucas", "Turagabea"],
                ["Malo Umbari", "Malo", "Umbari"], ["Maro Veitayaki", "Maro", "Veitayaki"],
                ["Matiu Veniri", "Matiu", "Veniri"], ["Maui Vidini", "Maui", "Vidini"],
                ["Pio Vunibaka", "Pio", "Vunibaka"], ["Ropata Waqanitoga", "Ropata", "Waqanitoga"],
                ["Sefa Potaka", "Sefa", "Potaka"], ["Siaki Teheiura", "Siaki", "Teheiura"],
                ["Taine Vanaa", "Taine", "Vanaa"], ["Tane Temaru", "Tane", "Temaru"],
                ["Tangaroa Flosse", "Tangaroa", "Flosse"], ["Tanielu Salmon", "Tanielu", "Salmon"],
                ["Tui Chavez", "Tui", "Chavez"], ["Wainani Tupua", "Wainani", "Tupua"],
                ["Tua Naituyaga", "Tua", "Naituyaga"], ["Mateo Erenavula", "Mateo", "Erenavula"],
                ["Teiva Nakaunicina", "Teiva", "Nakaunicina"], ["Moana Katalou", "Moana", "Katalou"],
                ["Jean-Baptiste Duvuduvukulu", "Jean-Baptiste", "Duvuduvukulu"],
                ["Keanu Maikelekelevesi", "Keanu", "Maikelekelevesi"],
                ["Tamatoa Molias", "Tamatoa", "Molias"], ["Marama Deli", "Marama", "Deli"],
                ["Teva Ieremia", "Teva", "Ieremia"], ["Manoa Babitu", "Manoa", "Babitu"],
                ["Ariki Koroi", "Ariki", "Koroi"], ["Gabriel Mara", "Gabriel", "Mara"],
                ["Louis Ganilau", "Louis", "Ganilau"], ["Paul Serevi", "Paul", "Serevi"],
                ["Marc Naivalu", "Marc", "Naivalu"], ["Julien Lomu", "Julien", "Lomu"],
                ["Alexandre Timoci", "Alexandre", "Timoci"], ["David Rambuka", "David", "Rambuka"]
            ];
            MISSION_CivilianNames_Female = [
                ["Moana Delai", "Moana", "Delai"], ["Vaite Ganilau", "Vaite", "Ganilau"],
                ["Hina Lomu", "Hina", "Lomu"], ["Mareva Serevi", "Mareva", "Serevi"],
                ["Vaimalama Koroi", "Vaimalama", "Koroi"], ["Leilani Naivalu", "Leilani", "Naivalu"],
                ["Tiare Babitu", "Tiare", "Babitu"], ["Heipua Mara", "Heipua", "Mara"],
                ["Titaua Timoci", "Titaua", "Timoci"], ["Moea Rambuka", "Moea", "Rambuka"],
                ["Tarita Veitayaki", "Tarita", "Veitayaki"], ["Hinano Tuikabe", "Hinano", "Tuikabe"],
                ["Tahia Potaka", "Tahia", "Potaka"], ["Kiri Teheiura", "Kiri", "Teheiura"],
                ["Malina Vanaa", "Malina", "Vanaa"], ["Kalea Temaru", "Kalea", "Temaru"],
                ["Marie Salmon", "Marie", "Salmon"], ["Chloe Chavez", "Chloe", "Chavez"],
                ["Sophie Tupua", "Sophie", "Tupua"], ["Camille Naituyaga", "Camille", "Naituyaga"],
                ["Lea Erenavula", "Lea", "Erenavula"], ["Emilie Katalou", "Emilie", "Katalou"],
                ["Sarah Nakaunicina", "Sarah", "Nakaunicina"], ["Claire Duvuduvukulu", "Claire", "Duvuduvukulu"],
                ["Heidi Molias", "Heidi", "Molias"], ["Poeiti Maikelekelevesi", "Poeiti", "Maikelekelevesi"],
                ["Anapa Bari", "Anapa", "Bari"], ["Teura Bole", "Teura", "Bole"]
            ];
            MISSION_CivilianMaleFaces = [
                "TanoanHead_A3_01", "TanoanHead_A3_02", "TanoanHead_A3_03",
                "TanoanHead_A3_04", "TanoanHead_A3_05", "TanoanHead_A3_06",
                "TanoanHead_A3_07", "TanoanHead_A3_08", "TanoanHead_A3_09",
                "AfricanHead_01", "AfricanHead_02", "AfricanHead_03",
                "AsianHead_A3_01", "AsianHead_A3_02", "AsianHead_A3_03", "AsianHead_A3_04",
                "AsianHead_A3_05", "AsianHead_A3_06", "AsianHead_A3_07",
                "WhiteHead_01", "WhiteHead_02", "WhiteHead_03", "WhiteHead_04", "WhiteHead_05",
                "WhiteHead_06", "WhiteHead_07", "WhiteHead_08", "WhiteHead_09", "WhiteHead_10"
            ];
            MISSION_Voices_Male = [
                "Male01FRE", "Male02FRE", "Male03FRE",
                "Male01ENGFRE", "Male02ENGFRE",
                "Male01ENG", "Male02ENG", "Male03ENG", "Male04ENG", "Male05ENG"
            ];
            MISSION_CivilianUniforms_Male = [
                "U_C_Man_casual_1_F", "U_C_Man_casual_2_F", "U_C_Man_casual_3_F",
                "U_C_Man_casual_4_F", "U_C_Man_casual_5_F", "U_C_Man_casual_6_F",
                "U_C_man_sport_1_F", "U_C_man_sport_2_F", "U_C_man_sport_3_F",
                "U_C_Poloshirt_blue", "U_C_Poloshirt_burgundy", "U_C_Poloshirt_salmon",
                "U_C_Poloshirt_stripped", "U_C_Poloshirt_tricolour", "U_C_Poloshirt_redwhite",
                "U_C_Mechanic_01_F", "U_C_IDAP_Man_shorts_F", "U_C_IDAP_Man_TeeShorts_F",
                "U_C_IDAP_Man_casual_F", "U_C_IDAP_Man_Jeans_F", "U_C_IDAP_Man_cargo_F",
                "U_C_ArtTShirt_01_v1_F", "U_C_ArtTShirt_01_v2_F", "U_C_ArtTShirt_01_v3_F",
                "U_C_ArtTShirt_01_v4_F", "U_C_ArtTShirt_01_v5_F", "U_C_ArtTShirt_01_v6_F"
            ];
            MISSION_CivilianHats = [
                "H_StrawHat", "H_StrawHat_dark",
                "H_Cap_surfer", "H_Bandanna_surfer_blk",
                "H_Cap_blu", "H_Cap_red", "H_Cap_tan", "H_Cap_oli", "H_Cap_blk", "H_Cap_grn",
                "H_Booniehat_tna_F", "H_Booniehat_oli", "H_Booniehat_tan",
                "H_Bandanna_blu", "H_Bandanna_gry", "H_Bandanna_khk", "H_Bandanna_sand", "H_Bandanna_sgg",
                "", "", ""
            ];
            MISSION_EnemyClasses_Male = [
                "I_C_Soldier_Bandit_1_F", "I_C_Soldier_Bandit_2_F", "I_C_Soldier_Bandit_3_F",
                "I_C_Soldier_Bandit_4_F", "I_C_Soldier_Bandit_5_F", "I_C_Soldier_Bandit_6_F",
                "I_C_Soldier_Bandit_7_F", "I_C_Soldier_Bandit_8_F",
                "I_C_Soldier_Para_1_F", "I_C_Soldier_Para_2_F", "I_C_Soldier_Para_3_F", "I_C_Soldier_Para_4_F",
                "O_G_Soldier_F"
            ];
            MISSION_EnemyUniforms_Male = [
                "U_I_C_Soldier_Bandit_1_F", "U_I_C_Soldier_Bandit_2_F", "U_I_C_Soldier_Bandit_3_F",
                "U_I_C_Soldier_Bandit_4_F", "U_I_C_Soldier_Bandit_5_F",
                "U_I_C_Soldier_Para_1_F", "U_I_C_Soldier_Para_2_F", "U_I_C_Soldier_Para_3_F",
                "U_I_C_Soldier_Para_4_F", "U_I_C_Soldier_Para_5_F",
                "U_BG_Guerilla1_1", "U_BG_Guerilla2_1", "U_BG_Guerilla2_2", "U_BG_Guerilla3_1"
            ];
            MISSION_EnemyHats = [
                "H_Bandanna_camo", "H_Bandanna_surfer_blk", "H_Booniehat_oli", "H_Booniehat_khk",
                "H_Cap_blk_Syndikat_F", "H_Cap_oli_Syndikat_F", "H_Cap_tan_Syndikat_F", ""
            ];
        };
    };
};

MISSION_CivilianClasses_Male = MISSION_CivilianClasses_Male select { isClass (configFile >> "CfgVehicles" >> _x) };
if (count MISSION_CivilianClasses_Male == 0) then {
    MISSION_CivilianClasses_Male = ["C_man_1"];
};

MISSION_EnemyClasses_Male = MISSION_EnemyClasses_Male select { isClass (configFile >> "CfgVehicles" >> _x) };
if (count MISSION_EnemyClasses_Male == 0) then {
    MISSION_EnemyClasses_Male = ["O_G_Soldier_F"];
};

MISSION_Voices_Female = [];

private _foundFemaleFaces = [];
{
    private _faceCat = _x;
    {
        private _fName = configName _x;
        if (
            (toLower _fName find "female" != -1) ||
            (toLower _fName find "woman" != -1) ||
            (toLower _fName find "girl" != -1)
        ) then {
            _foundFemaleFaces pushBackUnique _fName;
        };
    } forEach ("true" configClasses _faceCat);
} forEach ("true" configClasses (configFile >> "CfgFaces"));

if (count _foundFemaleFaces == 0) then {
    _foundFemaleFaces = if (_terrain in ["altis", "stratis", "malden"]) then { ["GreekHead_A3_01"] } else { ["TanoanHead_A3_01"] };
};

MISSION_CivilianFemaleFaces = _foundFemaleFaces;

private _foundCivilianFemales = [];
private _foundEnemyFemales = [];

{
    private _cName = configName _x;
    if (getNumber (_x >> "scope") >= 2 && { _cName isKindOf "Man" }) then {
        private _side = getNumber (_x >> "side");
        private _low = toLower _cName;
        private _isMilitary = (_low find "viper" != -1) || 
                             (_low find "soldier" != -1) || 
                             (_low find "recon" != -1) || 
                             (_low find "sniper" != -1) || 
                             (_low find "gunner" != -1) || 
                             (_low find "officer" != -1) || 
                             (_low find "leader" != -1) || 
                             (_low find "specops" != -1) || 
                             (_low find "combat" != -1) || 
                             (_low find "pilot" != -1) || 
                             (_low find "crew" != -1) || 
                             (_low find "diver" != -1);

        if (_side == 3 && !_isMilitary) then {
            _foundCivilianFemales pushBackUnique _cName;
        };
        if (_side == 0 || _side == 2 || _isMilitary) then {
            _foundEnemyFemales pushBackUnique _cName;
        };
    };
} forEach ("(toLower configName _x find 'woman' != -1 || toLower configName _x find 'female' != -1 || toLower configName _x find 'girl' != -1) && !((toLower configName _x) find 'weapon' != -1)" configClasses (configFile >> "CfgVehicles"));

_foundCivilianFemales = _foundCivilianFemales select { isClass (configFile >> "CfgVehicles" >> _x) && _x != "C_man_1" };
_foundEnemyFemales = _foundEnemyFemales select { isClass (configFile >> "CfgVehicles" >> _x) && _x != "O_G_Soldier_F" };

MISSION_CivilianClasses_Female = _foundCivilianFemales;
MISSION_EnemyClasses_Female = _foundEnemyFemales;

private _foundFemaleUniforms = [];
{
    private _w = configName _x;
    if (getNumber (_x >> "scope") >= 2 && { isClass (_x >> "ItemInfo") }) then {
        private _low = toLower _w;
        if ((_low find "female" != -1 || _low find "woman" != -1) && { !(_low find "bra" != -1) } && { !(_low find "bikini" != -1) } && { !(_low find "swim" != -1) } && { !(_low find "naked" != -1) }) then {
            _foundFemaleUniforms pushBackUnique _w;
        };
    };
} forEach ("true" configClasses (configFile >> "CfgWeapons"));

private _enemyFemaleUniforms = _foundFemaleUniforms select {
    private _l = toLower _x;
    (_l find "combat" != -1) || (_l find "camo" != -1) || (_l find "tna" != -1) || (_l find "mtp" != -1) || (_l find "pants" != -1) || (_l find "sport" != -1) || (_l find "casual" != -1)
};

if (count _enemyFemaleUniforms == 0) then {
    _enemyFemaleUniforms = _foundFemaleUniforms;
};

_enemyFemaleUniforms = _enemyFemaleUniforms select { isClass (configFile >> "CfgWeapons" >> _x) };
MISSION_EnemyUniforms_Female = _enemyFemaleUniforms;

MISSION_CivilianUniforms_Female = _foundFemaleUniforms select { isClass (configFile >> "CfgWeapons" >> _x) };

MISSION_CivilianUniforms_Male = MISSION_CivilianUniforms_Male select { isClass (configFile >> "CfgWeapons" >> _x) };
if (count MISSION_CivilianUniforms_Male == 0) then {
    MISSION_CivilianUniforms_Male = ["U_C_Poloshirt_blue", "U_C_Man_casual_1_F"];
};

MISSION_EnemyUniforms_Male = MISSION_EnemyUniforms_Male select { isClass (configFile >> "CfgWeapons" >> _x) };
if (count MISSION_EnemyUniforms_Male == 0) then {
    MISSION_EnemyUniforms_Male = ["U_I_C_Soldier_Bandit_1_F", "U_I_C_Soldier_Bandit_4_F", "U_BG_Guerilla1_1"];
};

MISSION_CivilianVests = [];

MISSION_EnemyVests = [
    "V_BandollierB_oli", "V_BandollierB_khk", "V_BandollierB_blk", "V_BandollierB_cbr",
    "V_Chestrig_oli", "V_Chestrig_khk", "V_Chestrig_blk",
    "V_TacChestrig_oli_F", "V_TacChestrig_grn_F", "V_TacChestrig_cbr_F", "V_HarnessO_brn"
];
MISSION_EnemyVests = MISSION_EnemyVests select { isClass (configFile >> "CfgWeapons" >> _x) };
if (count MISSION_EnemyVests == 0) then {
    MISSION_EnemyVests = ["V_Chestrig_oli", "V_BandollierB_oli"];
};

MISSION_CivilianHats = MISSION_CivilianHats select { _x == "" || isClass (configFile >> "CfgWeapons" >> _x) };

MISSION_EnemyHats = MISSION_EnemyHats select { _x == "" || isClass (configFile >> "CfgWeapons" >> _x) };

MISSION_EnemyGoggles = [
    "G_Aviator", "G_Shades_Black", "G_Bandanna_blk", "G_Bandanna_khk", "G_Sport_Blackred", ""
];
MISSION_EnemyGoggles = MISSION_EnemyGoggles select { _x == "" || isClass (configFile >> "CfgGlasses" >> _x) };

MISSION_BanditWeapons = [
    "arifle_AKM_F", "arifle_AKS_F", "arifle_SPAR_01_blk_F", "arifle_Katiba_F",
    "arifle_Mk20C_F", "hgun_PDW2000_F", "arifle_AK12_F", "sgun_HunterShotgun_01_sawedoff_F"
];
MISSION_BanditWeapons = MISSION_BanditWeapons select { isClass (configFile >> "CfgWeapons" >> _x) };
if (count MISSION_BanditWeapons == 0) then {
    MISSION_BanditWeapons = ["arifle_AKM_F", "arifle_Katiba_F"];
};

MISSION_BanditBackpacks = [
    "B_FieldPack_khk", "B_FieldPack_oli", "B_AssaultPack_blk", "B_AssaultPack_rgr",
    "B_Messenger_Black_F", "B_Messenger_Coyote_F", "B_Messenger_Olive_F"
];
MISSION_BanditBackpacks = MISSION_BanditBackpacks select { isClass (configFile >> "CfgVehicles" >> _x) };
if (count MISSION_BanditBackpacks == 0) then {
    MISSION_BanditBackpacks = ["B_FieldPack_oli", "B_AssaultPack_blk"];
};
