params [["_selectedLocationMarker", ""], ["_dropPosCenter", [0,0,0]], ["_selectedVehClass", "OFrP_P4_FR_CE"]];

disableSerialization;

if (isNil "LL_fnc_camApply") then {
    call compile preprocessFileLineNumbers "Functions\Task\LL_camTools.sqf";
};
if (isNil "LL_fnc_subtitles_legion") then {
    LL_fnc_subtitles_legion = compile preprocessFileLineNumbers "Functions\Task\fn_subtitles_legion.sqf";
};

cutText ["", "BLACK FADED", 999];
0 fadeSound 0;
0 fadeMusic 0;
showCinemaBorder true;

private _destPos = missionNamespace getVariable ["LL_g_startLZ", []];
if (count _destPos < 3) then { _destPos = _dropPosCenter; };
if (count _destPos < 3 && {_selectedLocationMarker in allMapMarkers}) then {
    _destPos = getMarkerPos _selectedLocationMarker;
};
if (count _destPos < 3 || {_destPos isEqualTo [0,0,0]}) exitWith { false };
private _lzASL = ATLToASL _destPos;

MISSION_intro_lz = _destPos;
publicVariable "MISSION_intro_lz";

private _helipad = createVehicle ["Land_HelipadEmpty_F", _destPos, [], 0, "CAN_COLLIDE"];

private _vehPos = [];
private _chosenVehDir = 90;
{
    private _vTest = _destPos getPos [32, _x];
    if (
        !surfaceIsWater _vTest &&
        { ((surfaceNormal _vTest) select 2) >= 0.96 } &&
        { abs ((getTerrainHeightASL _vTest) - (getTerrainHeightASL _destPos)) <= 1.5 } &&
        { count (nearestTerrainObjects [_vTest, ["TREE", "SMALL TREE", "ROCK", "ROCKS", "BUILDING", "HOUSE", "WALL"], 7]) == 0 } &&
        { count (nearestObjects [_vTest, ["House", "Building", "Strategic", "Thing", "AllVehicles"], 7]) == 0 }
    ) exitWith {
        _vehPos = _vTest;
        _chosenVehDir = _x;
    };
} forEach [90, 180, 270, 0, 45, 135, 225, 315];

if (count _vehPos < 3) then {
    _vehPos = _destPos getPos [32, 90];
    _chosenVehDir = 90;
};
_vehPos set [2, 0];
if (!isNil "vehicule_team" && {!isNull vehicule_team}) then { deleteVehicle vehicule_team; };
private _vehClass = missionNamespace getVariable ["MISSION_var_selected_vehicle_class", _selectedVehClass];
if (!isClass (configFile >> "CfgVehicles" >> _vehClass)) then {
    _vehClass = "OFrP_P4_FR_CE";
};
vehicule_team = createVehicle [_vehClass, _vehPos, [], 0, "NONE"];
vehicule_team setPosATL _vehPos;
vehicule_team setDir (_vehPos getDir _destPos);
vehicule_team allowDamage false;
publicVariable "vehicule_team";
missionNamespace setVariable ["LL_intro_vehDir", _chosenVehDir];

[] spawn LL_fnc_spawnStartArsenal;

private _allUnits = [];
if (!isNull player) then {
    { _allUnits pushBackUnique _x; } forEach (units group player);
};
{ _allUnits pushBackUnique _x; } forEach (playableUnits + switchableUnits);
for "_i" from 0 to 6 do {
    private _u = missionNamespace getVariable [format ["player_%1", _i], objNull];
    if (!isNull _u) then { _allUnits pushBackUnique _u; };
};
_allUnits = _allUnits select { alive _x };

{
    _x allowDamage true;
    _x enableFatigue false;
    _x enableStamina false;
} forEach _allUnits;

private _inboundDir = [_destPos, (_lzASL select 2) + 40, 600] call LL_fnc_pickApproachDir;
private _heliHeading = (_inboundDir + 180) % 360;

missionNamespace setVariable ["LL_intro_inboundDir", _inboundDir];
missionNamespace setVariable ["LL_intro_heliHeading", _heliHeading];

private _startPos = _destPos getPos [1800, _inboundDir];
_startPos set [2, 100];

private _heli = createVehicle ["B_Heli_Transport_01_F", _startPos, [], 0, "FLY"];
_heli setPosATL _startPos;
_heli setDir _heliHeading;

private _cruiseAltASL = (_lzASL select 2) + 100;
_heli flyInHeightASL [_cruiseAltASL, _cruiseAltASL, _cruiseAltASL];
_heli flyInHeight 100;
_heli allowDamage false;

createVehicleCrew _heli;
private _crew = crew _heli;
{ _x allowDamage false; } forEach _crew;

private _grpHeli = group driver _heli;
_grpHeli setBehaviour "CARELESS";
_grpHeli setCombatMode "BLUE";

{
    unassignVehicle _x;
    _x moveInCargo _heli;
    if (vehicle _x != _heli) then { _x moveInAny _heli; };
} forEach _allUnits;

_heli animateDoor ["doorLB", 1];
_heli animateDoor ["doorRB", 1];

_heli doMove _destPos;
_heli limitSpeed 150;
_heli setVelocityModelSpace [0, 38, 0];

private _ppColor = ppEffectCreate ["ColorCorrections", 1500];
_ppColor ppEffectEnable true;
_ppColor ppEffectAdjust [1, 0.95, 0.04, [0.15, 0.15, 0.2, 0.0], [0.88, 0.86, 0.9, 0.65], [0.1, 0.1, 0.15, 0]];
_ppColor ppEffectCommit 0;

private _ppGrain = ppEffectCreate ["FilmGrain", 2005];
_ppGrain ppEffectEnable true;
_ppGrain ppEffectAdjust [0.05, 0.8, 0.9, 0.05, 0.9, false];
_ppGrain ppEffectCommit 0;

private _ppBlurIntro = ppEffectCreate ["DynamicBlur", 405];
_ppBlurIntro ppEffectEnable true;
_ppBlurIntro ppEffectAdjust [2.0];
_ppBlurIntro ppEffectCommit 0;
_ppBlurIntro ppEffectAdjust [0.0];
_ppBlurIntro ppEffectCommit 2.0;

private _initCamPos = _heli modelToWorldVisual [0.0, 1.85, -0.44];
private _initTgtPos = _heli modelToWorldVisual [0.0, -4, -0.36];

private _cam = "camera" camCreate _initCamPos;
_cam cameraEffect ["INTERNAL", "BACK"];
if ((getLighting select 1) < 25) then { camUseNVG true; };

_cam camSetPos _initCamPos;
_cam camSetTarget _initTgtPos;
_cam camSetFov 0.70;
_cam camCommit 0;
waitUntil { camCommitted _cam };

if ((getAudioOptionVolumes select 1) > 0.05) then {
    playMusic "Legion_001";
    0 fadeMusic 1;
} else {
    playSound "Sound_Legion_001";
};

cutText ["", "BLACK IN", 1.8];

private _t0 = diag_tickTime;

[_t0] spawn LL_fnc_subtitles_legion;

missionNamespace setVariable ["LL_cam_obj", _cam];
missionNamespace setVariable ["LL_cam_target", _heli];
missionNamespace setVariable ["LL_p1_t0", _t0];

private _ehPlan1 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _start = missionNamespace getVariable ["LL_p1_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 10.11) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _wantASL = AGLToASL (_heli modelToWorldVisual [0.0, 1.85 - (_smooth * 0.10), -0.55]);
    private _tgtASL = AGLToASL (_heli modelToWorldVisual [0.0, -2.0, -0.40]);
    private _fov = 0.70 - (_smooth * 0.03);

    _cam camSetPos (ASLToAGL _wantASL);
    _cam camSetTarget (ASLToAGL _tgtASL);
    _cam camSetFov _fov;
    _cam camCommit 0;
}];

[] spawn {
    sleep 0.8;
    private _p1h = date select 3;
    private _p1m = date select 4;
    private _p1time = format ["%1:%2",
        if (_p1h < 10) then {"0" + str _p1h} else {str _p1h},
        if (_p1m < 10) then {"0" + str _p1m} else {str _p1m}
    ];
    private _rawLoc = localize "STR_LL_Intro_Location";
    if (_rawLoc == "" || _rawLoc == "STR_LL_Intro_Location") then { _rawLoc = "13 Mars 2019"; };
    private _dateTime = format ["%1 — %2", _rawLoc, _p1time];

    [
        format [
            "<t align='left'>" +
            "<t size='1.15' color='#F8FAFC' font='PuristaMedium'>%1</t><br/>" +
            "<t size='0.85' color='#94A3B8' font='PuristaLight'>VECTEUR D'INSERTION TACTIQUE // CE</t><br/>" +
            "<t size='0.55'><t color='#1E88E5'>━━━━━━ </t><t color='#FFFFFF'>━━━━━━ </t><t color='#E53935'>━━━━━━</t></t>" +
            "</t>",
            toUpper _dateTime
        ],
        0.08, 0.74, 6.2, 0.8, 0, 790
    ] spawn BIS_fnc_dynamicText;
};

private _ctx = [_cam, _heli, _destPos, _startPos, _allUnits, _t0, _helipad, _ppColor, _ppGrain, _lzASL, _ppBlurIntro, _inboundDir, _heliHeading];

waitUntil { (diag_tickTime - _t0) >= 10.11 };
removeMissionEventHandler ["EachFrame", _ehPlan1];

call LL_fnc_camReset;

[_ctx] spawn LL_fnc_intro_B;