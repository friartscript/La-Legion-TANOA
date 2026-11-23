params [["_target", objNull, [objNull]]];

private _vests = [
    "OFrP_Vest_SMB_Medic_Kaki",
    "OFrP_Vest_SMB_Teamleader_Kaki",
    "OFrP_Vest_SMB_Rifleman_Kaki",
    "OFrP_Vest_SMB_MachineGunner_Kaki",
    "OFrP_Vest_SMB_Grenadier_Kaki",
    "OFrP_Vest_SMB_Marksman1_Kaki",
    "OFrP_Vest_SMB_Kaki"
];
private _helmets = [
    "OFrP_Helmet_Spectra_01_CE",
    "OFrP_Helmet_Spectra_02_CE",
    "OFrP_Helmet_Spectra_01_ESSCOVER_CE",
    "OFrP_Helmet_Spectra_02_ESSCOVER_CE",
    "OFrP_Helmet_FELIN_CE"
];
private _backpacks = [
    "OFrP_Bag_Felin_45L",
    "OFrP_Bag_CrusaderIII",
    "OFrP_Bag_Felin_45L_Radio"
];
private _uniforms = [
    "OFrP_Uniform_T4S2_Full_CE",
    "OFrP_Uniform_T4S2_Short_CE",
    "OFrP_Uniform_T4S2_UBAS_CE01",
    "OFrP_Uniform_T4S2_UBAS_CE02"
];
private _goggles = [
    "G_Aviator",
    "G_Bandanna_tan",
    "G_Combat",
    "G_Lowprofile",
    "G_Bandana_khk"
];

_vests = _vests select { isClass (configFile >> "CfgWeapons" >> _x) };
_helmets = _helmets select { isClass (configFile >> "CfgWeapons" >> _x) };
_backpacks = _backpacks select { isClass (configFile >> "CfgVehicles" >> _x) };
_uniforms = _uniforms select { isClass (configFile >> "CfgWeapons" >> _x) };
_goggles = _goggles select { isClass (configFile >> "CfgGlasses" >> _x) };

if (count _vests == 0) then { _vests = ["V_PlateCarrier1_rgr"]; };
if (count _helmets == 0) then { _helmets = ["H_HelmetB"]; };
if (count _backpacks == 0) then { _backpacks = ["B_AssaultPack_rgr"]; };
if (count _uniforms == 0) then { _uniforms = ["U_B_CombatUniform_mcam"]; };
if (count _goggles == 0) then { _goggles = ["G_Combat"]; };

private _nvg = "NVGoggles";
if (isClass (configFile >> "CfgWeapons" >> "NVGoggles_tna_F")) then {
    _nvg = "NVGoggles_tna_F";
} else {
    if (isClass (configFile >> "CfgWeapons" >> "NVGogglesB_blk_F")) then {
        _nvg = "NVGogglesB_blk_F";
    };
};

private _squad = [];
if (!isNull _target) then {
    _squad = [_target];
} else {
    if (!isNull player) then {
        { _squad pushBackUnique _x; } forEach (units group player);
    };
    { _squad pushBackUnique _x; } forEach (playableUnits + switchableUnits);
    for "_i" from 0 to 6 do {
        private _u = missionNamespace getVariable [format ["player_%1", _i], objNull];
        if (!isNull _u) then { _squad pushBackUnique _u; };
    };
};

private _isAceMedical = isClass (configFile >> "CfgPatches" >> "ace_medical");

{
    private _unit = _x;
    if (!isNull _unit && { alive _unit }) then {
        private _strName = toLower (vehicleVarName _unit);
        private _type = typeOf _unit;
        private _idx = _forEachIndex;

        private _isLeader = (_unit == (leader group _unit)) || (_strName in ["player_0", "player_00"]) || (_type find "_SL_" != -1);
        private _isMedic = (_strName in ["player_1", "player_01", "player_4", "player_04"]) || (_type find "Medic" != -1);
        private _isMarksman = (_strName in ["player_2", "player_02"]) || (_type find "TP_" != -1) || (_type find "Marksman" != -1);
        private _isGunner = (_strName in ["player_3", "player_03"]) || (_type find "MachineGunner" != -1);
        private _isRadio = (_strName in ["player_5", "player_05"]) || (_type find "Radio" != -1);
        private _isAT = (_strName in ["player_6", "player_06"]) || (_type find "ERYX" != -1) || (_type find "AC_" != -1) || (_type find "AT" != -1);
        private _isGrenadier = (_type find "Grenadier" != -1);

        private _pWeapon = primaryWeapon _unit;
        private _hWeapon = handgunWeapon _unit;
        private _sWeapon = secondaryWeapon _unit;
        private _pItems = primaryWeaponItems _unit;
        private _hItems = handgunItems _unit;
        private _sItems = secondaryWeaponItems _unit;

        private _pMag = "";
        if (_pWeapon != "") then {
            private _m = primaryWeaponMagazine _unit;
            if (count _m > 0) then {
                _pMag = _m select 0;
            } else {
                private _c = [_pWeapon] call BIS_fnc_compatibleMagazines;
                if (count _c > 0) then { _pMag = _c select 0; };
            };
        };

        private _hMag = "";
        if (_hWeapon != "") then {
            private _m = handgunMagazine _unit;
            if (count _m > 0) then {
                _hMag = _m select 0;
            } else {
                private _c = [_hWeapon] call BIS_fnc_compatibleMagazines;
                if (count _c > 0) then { _hMag = _c select 0; };
            };
        };

        private _sMag = "";
        if (_sWeapon != "") then {
            private _m = secondaryWeaponMagazine _unit;
            if (count _m > 0) then {
                _sMag = _m select 0;
            } else {
                private _c = [_sWeapon] call BIS_fnc_compatibleMagazines;
                if (count _c > 0) then { _sMag = _c select 0; };
            };
        };

        removeAllWeapons _unit;
        removeAllItems _unit;
        removeAllAssignedItems _unit;
        removeUniform _unit;
        removeVest _unit;
        removeBackpack _unit;
        removeHeadgear _unit;
        removeGoggles _unit;

        private _selectedUniform = _uniforms select (_idx % (count _uniforms));
        _unit forceAddUniform _selectedUniform;

        private _targetVest = switch (true) do {
            case _isLeader: { "OFrP_Vest_SMB_Teamleader_Kaki" };
            case _isMedic: { "OFrP_Vest_SMB_Medic_Kaki" };
            case _isMarksman: { "OFrP_Vest_SMB_Marksman1_Kaki" };
            case _isGunner: { "OFrP_Vest_SMB_MachineGunner_Kaki" };
            case _isGrenadier: { "OFrP_Vest_SMB_Grenadier_Kaki" };
            default { "OFrP_Vest_SMB_Rifleman_Kaki" };
        };
        if (!isClass (configFile >> "CfgWeapons" >> _targetVest)) then {
            _targetVest = selectRandom _vests;
        };
        _unit addVest _targetVest;

        private _targetBackpack = switch (true) do {
            case _isRadio: { "OFrP_Bag_Felin_45L_Radio" };
            case (_isGunner || _isMarksman || _isAT): { "OFrP_Bag_CrusaderIII" };
            default { "OFrP_Bag_Felin_45L" };
        };
        if (!isClass (configFile >> "CfgVehicles" >> _targetBackpack)) then {
            _targetBackpack = selectRandom _backpacks;
        };
        _unit addBackpack _targetBackpack;

        _unit addHeadgear (selectRandom _helmets);
        _unit addGoggles (selectRandom _goggles);

        if (_pWeapon != "") then {
            _unit addWeapon _pWeapon;
            { if (_x != "") then { _unit addPrimaryWeaponItem _x; }; } forEach _pItems;
        };
        if (_hWeapon != "") then {
            _unit addWeapon _hWeapon;
            { if (_x != "") then { _unit addHandgunItem _x; }; } forEach _hItems;
        };
        if (_sWeapon != "") then {
            _unit addWeapon _sWeapon;
            { if (_x != "") then { _unit addSecondaryWeaponItem _x; }; } forEach _sItems;
        };

        private _bino = switch (true) do {
            case _isLeader: {
                if (isClass (configFile >> "CfgWeapons" >> "Laserdesignator")) then { "Laserdesignator" } else { "Rangefinder" }
            };
            case _isMarksman: { "Rangefinder" };
            default { "Binocular" };
        };
        if (!isClass (configFile >> "CfgWeapons" >> _bino)) then { _bino = "Binocular"; };
        _unit addWeapon _bino;
        if (_bino == "Laserdesignator") then {
            _unit addMagazine "Laserbatteries";
        };

        _unit linkItem "ItemMap";
        _unit linkItem "ItemCompass";
        _unit linkItem "ItemWatch";
        _unit linkItem "ItemRadio";
        _unit linkItem "ItemGPS";
        _unit linkItem _nvg;

        if (_pMag != "") then {
            private _magCount = if (_isGunner) then { 5 } else { 8 };
            for "_j" from 1 to _magCount do {
                _unit addMagazine _pMag;
            };
            _unit addPrimaryWeaponItem _pMag;
        };

        if (_hMag != "") then {
            for "_j" from 1 to 3 do {
                _unit addMagazine _hMag;
            };
            _unit addHandgunItem _hMag;
        };

        if (_sMag != "") then {
            for "_j" from 1 to 2 do {
                _unit addMagazine _sMag;
            };
            _unit addSecondaryWeaponItem _sMag;
        };

        if (_isGrenadier) then {
            {
                if (isClass (configFile >> "CfgMagazines" >> _x)) then {
                    for "_j" from 1 to 3 do { _unit addMagazine _x; };
                };
            } forEach ["1Rnd_HE_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell"];
        };

        for "_j" from 1 to 2 do { _unit addMagazine "HandGrenade"; };
        for "_j" from 1 to 2 do { _unit addMagazine "SmokeShell"; };
        _unit addMagazine "SmokeShellGreen";

        if (_isAceMedical) then {
            _unit addItem "ACE_EarPlugs";
            for "_j" from 1 to 8 do { _unit addItem "ACE_fieldDressing"; };
            for "_j" from 1 to 4 do { _unit addItem "ACE_packingBandage"; };
            for "_j" from 1 to 4 do { _unit addItem "ACE_elasticBandage"; };
            for "_j" from 1 to 3 do { _unit addItem "ACE_tourniquet"; };
            for "_j" from 1 to 2 do { _unit addItem "ACE_morphine"; };
            for "_j" from 1 to 1 do { _unit addItem "ACE_epinephrine"; };
            for "_j" from 1 to 2 do { _unit addItem "ACE_splint"; };

            if (_isMedic) then {
                _unit addItem "ACE_surgicalKit";
                for "_j" from 1 to 4 do { _unit addItem "ACE_bloodIV_500"; };
                for "_j" from 1 to 15 do { _unit addItem "ACE_fieldDressing"; };
                for "_j" from 1 to 10 do { _unit addItem "ACE_elasticBandage"; };
                for "_j" from 1 to 6 do { _unit addItem "ACE_tourniquet"; };
                for "_j" from 1 to 6 do { _unit addItem "ACE_morphine"; };
                for "_j" from 1 to 6 do { _unit addItem "ACE_epinephrine"; };
                for "_j" from 1 to 4 do { _unit addItem "ACE_splint"; };
            };
        } else {
            for "_j" from 1 to 4 do { _unit addItem "FirstAidKit"; };
            if (_isMedic) then {
                _unit addItem "Medikit";
                for "_j" from 1 to 10 do { _unit addItem "FirstAidKit"; };
            };
        };

        if (_pWeapon != "") then { _unit selectWeapon _pWeapon; };

        [_unit] spawn {
            params ["_u"];
            sleep 0.5;
            if (!isNull _u && { alive _u }) then {
                [_u] call LL_fnc_badgeManager;
            };
        };
    };
} forEach _squad;
