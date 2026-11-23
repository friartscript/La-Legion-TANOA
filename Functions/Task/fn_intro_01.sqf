params [["_selectedLocationMarker", ""], ["_dropPosCenter", [0,0,0]], ["_selectedVehClass", "OFrP_P4_FR_CE"]];

disableSerialization;

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

private _startDir = random 360;
private _startPos = _destPos getPos [1500, _startDir];
_startPos set [2, 110];

private _heli = createVehicle ["B_Heli_Transport_01_F", _startPos, [], 0, "FLY"];
_heli setPosATL _startPos;
_heli setDir (_heli getDir _destPos);

private _cruiseAltASL = (_lzASL select 2) + 110;
_heli flyInHeightASL [_cruiseAltASL, _cruiseAltASL, _cruiseAltASL];
_heli flyInHeight 110;
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

_heli doMove _destPos;
_heli limitSpeed 160;
_heli setVelocityModelSpace [0, 42, 0];

private _ppColor = ppEffectCreate ["ColorCorrections", 1500];
_ppColor ppEffectEnable true;
_ppColor ppEffectAdjust [1, 0.95, 0.04, [0.15, 0.15, 0.2, 0.0], [0.88, 0.86, 0.9, 0.65], [0.1, 0.1, 0.15, 0]];
_ppColor ppEffectCommit 0;

private _ppGrain = ppEffectCreate ["FilmGrain", 2005];
_ppGrain ppEffectEnable true;
_ppGrain ppEffectAdjust [0.05, 0.8, 0.9, 0.05, 0.9, false];
_ppGrain ppEffectCommit 0;

private _highCamPos = [(_destPos select 0) - 75, (_destPos select 1) - 75, (_destPos select 2) + 145];
private _lowCamPos = [(_destPos select 0) - 25, (_destPos select 1) - 25, (_destPos select 2) + 45];

private _cam = "camera" camCreate _highCamPos;
_cam cameraEffect ["INTERNAL", "BACK"];
if ((getLighting select 1) < 25) then { camUseNVG true; };

_cam camSetPos _highCamPos;
_cam camSetTarget _destPos;
_cam camSetFov 0.65;
_cam camCommit 0;
waitUntil { camCommitted _cam };

if ((getAudioOptionVolumes select 1) > 0.05) then {
    playMusic "Legion_001";
    0 fadeMusic 1;
} else {
    playSound "Sound_Legion_001";
};
2 fadeSound 1;

private _t0 = diag_tickTime;
[_t0] spawn LL_fnc_subtitles_legion;

cutText ["", "BLACK IN", 2.0];
_cam camSetPos _lowCamPos;
_cam camSetTarget _destPos;
_cam camSetFov 0.48;
_cam camCommit 10.0;

waitUntil { (diag_tickTime - _t0) >= 1.2 };

titleText [
    format [
        "<t font='PuristaBold' shadow='2' align='center'>" +
        "<t size='2.8' color='#1E88E5'>MISSION</t><br/>" +
        "<t size='2.8' color='#FFFFFF'>LÉGION</t><br/>" +
        "<t size='2.8' color='#E53935'>ÉTRANGÈRE</t>" +
        "</t><br/><br/>" +
        "<t size='1.4' color='#E5B729' font='PuristaSemiBold' align='center'>%1</t><br/>" +
        "<t size='1.2' color='#FFFFFF' font='PuristaBold' shadow='2' align='center'>LÉGION ÉTRANGÈRE - TANOA</t><br/>" +
        "<t size='1.0' color='#87CEEB' font='PuristaLight' shadow='1' align='center'>%2</t>",
        localize "STR_LL_Intro_Presents",
        localize "STR_LL_Intro_CreatedBy"
    ],
    "PLAIN", 1, true, true
];

waitUntil { (diag_tickTime - _t0) >= 8.5 };
titleText ["", "PLAIN", 1.0];

waitUntil { (diag_tickTime - _t0) >= 9.8 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 10.11 };

missionNamespace setVariable ["LL_cam_obj", _cam];
missionNamespace setVariable ["LL_cam_target", _heli];
missionNamespace setVariable ["LL_p2_t0", _t0 + 10.11];

private _ehPlan2 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _start = missionNamespace getVariable ["LL_p2_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 9.37) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _hASL = getPosASLVisual _heli;
    private _hDir = getDirVisual _heli;
    private _angle = _hDir - 25 + (_smooth * 35);
    private _dist = 24 + (_smooth * 8);
    private _cASL = [
        (_hASL select 0) + (sin _angle * _dist),
        (_hASL select 1) + (cos _angle * _dist),
        (_hASL select 2) + 38 - (_smooth * 9)
    ];
    _cam camSetPos (ASLToAGL _cASL);
    _cam camSetTarget (_heli modelToWorldVisual [0, 0, -1]);
    _cam camSetFov (0.75 - (_smooth * 0.12));
    _cam camCommit 0;
}];

cutText ["", "BLACK IN", 0.3];

[] spawn {
    sleep 0.5;
    private _p2h = date select 3;
    private _p2m = date select 4;
    private _p2time = format ["%1:%2",
        if (_p2h < 10) then {"0" + str _p2h} else {str _p2h},
        if (_p2m < 10) then {"0" + str _p2m} else {str _p2m}
    ];
    private _rawLoc = localize "STR_LL_Intro_Location";
    if (_rawLoc == "" || _rawLoc == "STR_LL_Intro_Location") then { _rawLoc = "TANOA - SECTEUR OPÉRATIONNEL"; };
    private _fullLoc = _rawLoc + " - " + _p2time;
    private _chars = toArray _fullLoc;
    private _built = "";

    {
        _built = _built + toString [_x];
        [
            format ["<t size='1.35' font='PuristaMedium' align='center' shadow='2'><t color='#1E88E5'>[</t> <t color='#FFFFFF'>%1</t> <t color='#E53935'>]</t></t>", _built],
            -1, 0.38, 4, 0, 0, 793
        ] spawn BIS_fnc_dynamicText;
        if (_x != 32) then { playSound "readoutClick"; };
        sleep 0.07;
    } forEach _chars;

    sleep 2.0;
    ["", -1, 0.38, 0.8, 0, 0, 793] spawn BIS_fnc_dynamicText;
};

waitUntil { (diag_tickTime - _t0) >= 19.18 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 19.48 };
removeMissionEventHandler ["EachFrame", _ehPlan2];

_heli animateDoor ["doorLB", 1];
_heli animateDoor ["doorRB", 1];
_heli flyInHeight 65;
_heli limitSpeed 140;

missionNamespace setVariable ["LL_p3_t0", _t0 + 19.48];

private _ehPlan3 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _start = missionNamespace getVariable ["LL_p3_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 10.55) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _hASL = getPosASLVisual _heli;
    private _hDir = getDirVisual _heli;
    private _angle = _hDir + 165 - (_smooth * 30);
    private _dist = 36 + (_smooth * 10);
    private _cASL = [
        (_hASL select 0) + (sin _angle * _dist),
        (_hASL select 1) + (cos _angle * _dist),
        (_hASL select 2) - 14 + (_smooth * 5)
    ];
    _cam camSetPos (ASLToAGL _cASL);
    _cam camSetTarget (_heli modelToWorldVisual [0, 1, 1.5]);
    _cam camSetFov (0.65 - (_smooth * 0.08));
    _cam camCommit 0;
}];

cutText ["", "BLACK IN", 0.3];

waitUntil { (diag_tickTime - _t0) >= 29.73 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 30.03 };
removeMissionEventHandler ["EachFrame", _ehPlan3];

missionNamespace setVariable ["LL_p4_t0", _t0 + 30.03];

private _ehPlan4 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _start = missionNamespace getVariable ["LL_p4_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 9.39) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _hASL = getPosASLVisual _heli;
    private _hDir = getDirVisual _heli;
    private _angle = _hDir - 85 + (_smooth * 40);
    private _dist = 11 + (_smooth * 3);
    private _cASL = [
        (_hASL select 0) + (sin _angle * _dist),
        (_hASL select 1) + (cos _angle * _dist),
        (_hASL select 2) + 0.4 + (_smooth * 1.2)
    ];
    _cam camSetPos (ASLToAGL _cASL);
    _cam camSetTarget (_heli modelToWorldVisual [0, 0.5, 0.2]);
    _cam camSetFov (0.45 - (_smooth * 0.05));
    _cam camCommit 0;
}];

cutText ["", "BLACK IN", 0.3];

waitUntil { (diag_tickTime - _t0) >= 39.12 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 39.42 };
removeMissionEventHandler ["EachFrame", _ehPlan4];

private _inboundDir = _destPos getDir _startPos;
private _heliHeading = (_inboundDir + 180) mod 360;

private _posPlan5 = _destPos getPos [135, _inboundDir];
_posPlan5 set [2, 42];
_heli setPosATL _posPlan5;
_heli setDir _heliHeading;
_heli setVelocity [sin _heliHeading * 15, cos _heliHeading * 15, -1.0];
_heli flyInHeight 22;
_heli limitSpeed 65;
_heli doMove _destPos;

private _camGround5 = [
    (_destPos select 0) + 40,
    (_destPos select 1) - 42,
    (_destPos select 2) + 1.8
];
_cam camSetPos _camGround5;
_cam camSetTarget _heli;
_cam camSetFov 0.60;
_cam camCommit 0;
waitUntil { camCommitted _cam };

cutText ["", "BLACK IN", 0.4];

missionNamespace setVariable ["LL_p5_t0", _t0 + 39.42];
missionNamespace setVariable ["LL_p5_cPos", _camGround5];

private _ehPlan5 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _base = missionNamespace getVariable ["LL_p5_cPos", [0,0,0]];
    private _start = missionNamespace getVariable ["LL_p5_t0", diag_tickTime];
    private _prog = ((diag_tickTime - _start) / 12.35) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    _cam camSetPos [
        (_base select 0) - (_smooth * 5),
        (_base select 1) + (_smooth * 4),
        (_base select 2) + (_smooth * 0.5)
    ];
    _cam camSetTarget (_heli modelToWorldVisual [0, 0, 0.8]);
    _cam camSetFov (0.60 - (_smooth * 0.12));
    _cam camCommit 0;
}];

waitUntil { (diag_tickTime - _t0) >= 51.47 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 51.77 };
removeMissionEventHandler ["EachFrame", _ehPlan5];

private _posPlan6 = _destPos getPos [25, _inboundDir];
_posPlan6 set [2, 16];
_heli setPosATL _posPlan6;
_heli setDir _heliHeading;
_heli setVelocity [sin _heliHeading * 4, cos _heliHeading * 4, -1.2];
_heli flyInHeight 6;
_heli limitSpeed 25;
_heli doMove _destPos;

private _camGround6 = [
    (_destPos select 0) - 28,
    (_destPos select 1) + 32,
    (_destPos select 2) + 18.0
];
_cam camSetPos _camGround6;
_cam camSetTarget _heli;
_cam camSetFov 0.55;
_cam camCommit 0;
waitUntil { camCommitted _cam };

cutText ["", "BLACK IN", 0.4];

missionNamespace setVariable ["LL_p6_t0", _t0 + 51.77];
missionNamespace setVariable ["LL_p6_cPos", _camGround6];

private _ehPlan6 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _base = missionNamespace getVariable ["LL_p6_cPos", [0,0,0]];
    private _start = missionNamespace getVariable ["LL_p6_t0", diag_tickTime];
    private _prog = ((diag_tickTime - _start) / 9.56) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    _cam camSetPos [
        (_base select 0) + (_smooth * 6),
        (_base select 1) - (_smooth * 5),
        (_base select 2) - (_smooth * 6.5)
    ];
    _cam camSetTarget (_heli modelToWorldVisual [0, 0, 0.3]);
    _cam camSetFov (0.55 - (_smooth * 0.08));
    _cam camCommit 0;
}];

waitUntil { (diag_tickTime - _t0) >= 61.03 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 61.33 };
removeMissionEventHandler ["EachFrame", _ehPlan6];

private _hoverPos = +_destPos;
_hoverPos set [2, 5.0];
_heli setPosATL _hoverPos;
_heli setDir _heliHeading;
_heli setVelocity [0, 0, -1.0];
_heli land "LAND";

private _camGround7 = [
    (_destPos select 0) + 14,
    (_destPos select 1) - 13,
    (_destPos select 2) + 1.6
];
_cam camSetPos _camGround7;
_cam camSetTarget _heli;
_cam camSetFov 0.44;
_cam camCommit 0;
waitUntil { camCommitted _cam };

cutText ["", "BLACK IN", 0.4];

missionNamespace setVariable ["LL_p7_t0", _t0 + 61.33];
missionNamespace setVariable ["LL_p7_cPos", _camGround7];

private _ehPlan7 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _base = missionNamespace getVariable ["LL_p7_cPos", [0,0,0]];
    private _start = missionNamespace getVariable ["LL_p7_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 10.23) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    _cam camSetPos [
        (_base select 0) - (_smooth * 2.5),
        (_base select 1) - (_smooth * 1.5),
        (_base select 2) + (_smooth * 0.2)
    ];
    _cam camSetTarget (_heli modelToWorldVisual [0, 0, 0.1]);
    _cam camSetFov (0.44 + (_smooth * 0.06));
    _cam camCommit 0;

    if (_elapsed < 4.5) then {
        private _descentAlt = (5.0 * (1 - (_elapsed / 4.5))) max 0;
        private _curPos = getPosATL _heli;
        if ((_curPos select 2) > _descentAlt) then {
            _curPos set [2, _descentAlt];
            _heli setPosATL _curPos;
        };
    } else {
        if ((getPosATL _heli select 2) > 0.05) then {
            private _gPos = getPosATL _heli;
            _gPos set [2, 0];
            _heli setPosATL _gPos;
            _heli setVectorUp surfaceNormal _gPos;
        };
        _heli setVelocity [0, 0, 0];
    };
}];

waitUntil { (diag_tickTime - _t0) >= 71.26 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 71.56 };
removeMissionEventHandler ["EachFrame", _ehPlan7];

private _groundPos = +_destPos;
_groundPos set [2, 0];
_heli setPosATL _groundPos;
_heli setVectorUp surfaceNormal _groundPos;
_heli setVelocity [0, 0, 0];

{
    unassignVehicle _x;
    moveOut _x;
} forEach _allUnits;

private _teamRef = if (!isNil "vehicule_team" && {!isNull vehicule_team}) then { getPosATL vehicule_team } else { _destPos };

private _allSquad = [];
if (!isNull player) then {
    { _allSquad pushBackUnique _x; } forEach (units group player);
};
{ _allSquad pushBackUnique _x; } forEach (playableUnits + switchableUnits);
for "_i" from 0 to 6 do {
    private _u = missionNamespace getVariable [format ["player_%1", _i], objNull];
    if (!isNull _u) then { _allSquad pushBackUnique _u; };
};
_allSquad = _allSquad select { alive _x };

{
    private _u = _x;
    private _pos = _teamRef getPos [3.5 + (_forEachIndex * 1.5), 20 + (_forEachIndex * 55)];
    _pos set [2, 0];
    _u setPosATL _pos;
    _u setVelocity [0, 0, 0];
    _u switchMove "";
    _u setDir (_pos getDir _teamRef);
} forEach _allSquad;

_heli land "NONE";
_heli engineOn true;
private _vehDir = missionNamespace getVariable ["LL_intro_vehDir", 90];
private _takeoffDir = (_vehDir + 180) % 360;
private _exitPos = _destPos getPos [5000, _takeoffDir];
_exitPos set [2, 120];
_heli setVelocity [0, 0, 5];
_heli flyInHeight 80;
_heli doMove _exitPos;

[_heli, _destPos] spawn {
    params ["_h", "_dp"];
    waitUntil { sleep 2; (_h distance2D _dp) > 3000 || !alive _h };
    { deleteVehicle _x; } forEach (crew _h);
    deleteVehicle _h;
};

private _camGround8 = [
    (_teamRef select 0) - 13,
    (_teamRef select 1) - 11,
    (_teamRef select 2) + 1.3
];
_cam camSetPos _camGround8;
_cam camSetTarget _teamRef;
_cam camSetFov 0.52;
_cam camCommit 0;
waitUntil { camCommitted _cam };

cutText ["", "BLACK IN", 0.4];

missionNamespace setVariable ["LL_p8_t0", _t0 + 71.56];
missionNamespace setVariable ["LL_p8_cPos", _camGround8];

private _ehPlan8 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    if (isNull _cam) exitWith {};

    private _teamPos = missionNamespace getVariable ["MISSION_intro_lz", [0,0,0]];
    if (!isNil "vehicule_team" && {!isNull vehicule_team}) then { _teamPos = getPosATL vehicule_team; };

    private _start = missionNamespace getVariable ["LL_p8_t0", diag_tickTime];
    private _prog = ((diag_tickTime - _start) / 9.02) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _angle = 220 + (_smooth * 75);
    private _dist = 16 - (_smooth * 3);
    private _cPos = [
        (_teamPos select 0) + (sin _angle * _dist),
        (_teamPos select 1) + (cos _angle * _dist),
        (_teamPos select 2) + 1.3 + (_smooth * 0.7)
    ];
    _cam camSetPos _cPos;
    _cam camSetTarget [_teamPos select 0, _teamPos select 1, (_teamPos select 2) + 1.1];
    _cam camSetFov (0.52 - (_smooth * 0.06));
    _cam camCommit 0;
}];

waitUntil { (diag_tickTime - _t0) >= 80.28 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 80.58 };
removeMissionEventHandler ["EachFrame", _ehPlan8];

private _teammates = _allSquad - [player];
_teammates joinSilent (group player);
(group player) selectLeader player;

{
    _x doFollow player;
    _x setDamage 0;
    _x allowDamage true;
    _x setCaptive false;
    _x enableAI "ALL";
    _x enableFatigue false;
    _x enableStamina false;
    _x setCustomAimCoef 0.1;
} forEach _allUnits;

if (!isNil "vehicule_team" && {!isNull vehicule_team}) then {
    vehicule_team setDamage 0;
    vehicule_team allowDamage true;
};

_cam cameraEffect ["TERMINATE", "BACK"];
camDestroy _cam;
camUseNVG false;
ppEffectDestroy _ppColor;
ppEffectDestroy _ppGrain;

player switchCamera "INTERNAL";
showCinemaBorder false;

if (!isNull _helipad) then {
    deleteVehicle _helipad;
};

if ((getLighting select 1) < 25) then {
    player action ["NVGoggles", player];
};

cutText ["", "BLACK IN", 1.5];
2 fadeSound 1;

waitUntil { (diag_tickTime - _t0) >= 90.72 };

[
    format [
        "<t size='1.0' color='#bbbbbb' font='PuristaLight' align='center'>%1</t>",
        localize "STR_LL_Intro_MissionStartSubtitle"
    ],
    -1, -1, 5, 1, 0, 793
] spawn BIS_fnc_dynamicText;

missionNamespace setVariable ["MISSION_intro_finished", true, true];
