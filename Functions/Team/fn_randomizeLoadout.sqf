params [["_unit", objNull, [objNull]]];

if (isNull _unit) exitWith { false };

private _uniforms = [
    "OFrP_Uniform_T4S2_Full_CE",
    "OFrP_Uniform_T4S2_Short_CE",
    "OFrP_Uniform_T4S2_UBAS_CE01",
    "OFrP_Uniform_T4S2_UBAS_CE02"
];

private _headgears = [
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
private _radioBackpack = "OFrP_Bag_Felin_45L_Radio";

private _goggles = [
    "G_Aviator",
    "G_Bandanna_tan",
    "G_Combat",
    "G_Lowprofile",
    "G_Bandana_khk"
];

private _vests = [
    "OFrP_Vest_SMB_Kaki",
    "OFrP_Vest_SMB_Teamleader_Kaki",
    "OFrP_Vest_SMB_Grenadier_Kaki",
    "OFrP_Vest_SMB_Marksman1_Kaki",
    "OFrP_Vest_SMB_Medic_Kaki"
];

_uniforms = _uniforms select { isClass (configFile >> "CfgWeapons" >> _x) };
_headgears = _headgears select { isClass (configFile >> "CfgWeapons" >> _x) };
_backpacks = _backpacks select { isClass (configFile >> "CfgVehicles" >> _x) };
_vests = _vests select { isClass (configFile >> "CfgWeapons" >> _x) };

if (count _uniforms == 0 || count _headgears == 0 || count _backpacks == 0 || count _vests == 0) exitWith {
    false
};

private _binocular = "Rangefinder";
private _nvg = "NVGoggles";
if (isClass (configFile >> "CfgWeapons" >> "NVGoggles_tna_F")) then {
    _nvg = "NVGoggles_tna_F";
} else {
    if (isClass (configFile >> "CfgWeapons" >> "NVGogglesB_blk_F")) then {
        _nvg = "NVGogglesB_blk_F";
    };
};

private _patch = "OFrP_TFLafayette_01";

private _primaryWeapon = primaryWeapon _unit;
private _handgunWeapon = handgunWeapon _unit;

private _existingMags = magazines _unit;
private _primaryMagClass = "";
private _handgunMagClass = "";

{
    if (_primaryMagClass == "" && { _x in (compatibleMagazines _primaryWeapon) }) then {
        _primaryMagClass = _x;
    };
    if (_handgunMagClass == "" && { _x in (compatibleMagazines _handgunWeapon) }) then {
        _handgunMagClass = _x;
    };
} forEach _existingMags;

if (_primaryMagClass == "" && _primaryWeapon != "") then {
    private _compat = compatibleMagazines _primaryWeapon;
    if (count _compat > 0) then { _primaryMagClass = _compat select 0; };
};
if (_handgunMagClass == "" && _handgunWeapon != "") then {
    private _compat = compatibleMagazines _handgunWeapon;
    if (count _compat > 0) then { _handgunMagClass = _compat select 0; };
};

removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

_unit unassignItem (hmd _unit);
_unit removeItem (hmd _unit);

if (binocular _unit != "") then {
    _unit removeWeapon (binocular _unit);
};

if (isNil "LL_UniformCounter") then { LL_UniformCounter = 0; };
private _newUniform = _uniforms select (LL_UniformCounter % (count _uniforms));
LL_UniformCounter = LL_UniformCounter + 1;

private _newVest = selectRandom _vests;
private _newHeadgear = selectRandom _headgears;
private _newGoggle = selectRandom _goggles;

private _isRadio = (toLower (str _unit) in ["player_5", "player_05"] || typeOf _unit == "OFrP_Soldier_2019_Radio_CE" || (typeOf _unit find "Radio" != -1));
private _newBackpack = if (_isRadio) then { _radioBackpack } else { selectRandom _backpacks };

_unit forceAddUniform _newUniform;
_unit addVest _newVest;
_unit addBackpack _newBackpack;
_unit addHeadgear _newHeadgear;
_unit addGoggles _newGoggle;

_unit addWeapon _binocular;
[_unit] call LL_fnc_ensureUnitNVG;
_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
_unit linkItem "ItemWatch";
_unit linkItem "ItemRadio";
_unit linkItem "ItemGPS";

_unit setVariable ["bis_fnc_setUnitInsignia_class", _patch, true];
[_unit, _patch] call BIS_fnc_setUnitInsignia;

if (_primaryMagClass != "") then {
    _unit addMagazines [_primaryMagClass, 8];
};

if (_handgunMagClass != "") then {
    _unit addMagazines [_handgunMagClass, 3];
};

for "_i" from 1 to 4 do {
    _unit addItem "FirstAidKit";
};
for "_i" from 1 to 2 do {
    _unit addItem "HandGrenade";
    _unit addItem "SmokeShell";
};
_unit addItem "SmokeShellGreen";

if (_primaryWeapon != "" && _primaryMagClass != "") then {
    _unit addPrimaryWeaponItem _primaryMagClass;
};
if (_handgunWeapon != "" && _handgunMagClass != "") then {
    _unit addHandgunItem _handgunMagClass;
};

_unit selectWeapon _primaryWeapon;

true
