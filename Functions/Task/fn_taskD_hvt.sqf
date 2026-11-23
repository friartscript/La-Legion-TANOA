if (!isServer) exitWith {};

params [
    ["_locMarker", "", [""]]
];

if (_locMarker == "" || !(_locMarker in allMapMarkers)) exitWith { missionNamespace setVariable ["LL_g_taskInProgress", false, true]; false };

private _centerPos = getMarkerPos _locMarker;
private _radius = (markerSize _locMarker) select 0;
if (_radius == 0) then { _radius = 250; };
private _nearHelipads = nearestObjects [_centerPos, ["Land_HelipadEmpty_F"], _radius];
private _nearLogics = nearestObjects [_centerPos, ["Logic"], _radius];

private _usedPositions = missionNamespace getVariable ["LL_g_usedTaskPos", []];
private _validSpawnPoints = (_nearLogics + _nearHelipads) select {
    private _candidate = _x;
    !(_candidate getVariable ["LL_logic_occupied", false]) && 
    { (_usedPositions findIf { _x distance2D _candidate < 20 }) == -1 }
};

private _hvtPos = _centerPos;
private _otherLogics = [];
private _sitePrimary = missionNamespace getVariable [format ["LL_g_sitePrimaryPos_%1", _locMarker], []];

if (count _sitePrimary == 3) then {
    _hvtPos = +_sitePrimary;
    _otherLogics = _validSpawnPoints select { (getPosATL _x) distance2D _hvtPos > 2 };
    _usedPositions pushBack _hvtPos;
    missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];
} else {
    if (count _validSpawnPoints > 0) then {
        private _shuffled = _validSpawnPoints call BIS_fnc_arrayShuffle;
        private _chosenLogic = _shuffled select 0;
        _chosenLogic setVariable ["LL_logic_occupied", true];
        _hvtPos = getPosATL _chosenLogic;
        _otherLogics = _shuffled select [1, (count _shuffled - 1)];
        _usedPositions pushBack _hvtPos;
        missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];
    } else {
        _hvtPos = _centerPos getPos [60 + random 80, random 360];
        _usedPositions pushBack _hvtPos;
        missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];
    };
};

_hvtPos set [2, (_hvtPos select 2) + 0.2];

private _nearBldgHVT = nearestBuilding _hvtPos;
if (!isNull _nearBldgHVT && { _hvtPos distance2D _nearBldgHVT < 35 }) then {
    private _cfgHVT = configFile >> "CfgVehicles" >> (typeOf _nearBldgHVT);
    private _doorsHVT = if (isClass _cfgHVT) then { getNumber (_cfgHVT >> "numberOfDoors") } else { 0 };
    private _isSealedHVT = false;

    if (_doorsHVT == 0) then {
        private _hasExitHVT = false;
        private _spASLHVT = ATLToASL [_hvtPos select 0, _hvtPos select 1, (_hvtPos select 2) + 1.0];
        for "_deg" from 0 to 315 step 45 do {
            private _outASLHVT = ATLToASL [
                (_hvtPos select 0) + (sin _deg * 8),
                (_hvtPos select 1) + (cos _deg * 8),
                (_hvtPos select 2) + 1.0
            ];
            if (!lineIntersects [_spASLHVT, _outASLHVT]) exitWith { _hasExitHVT = true; };
        };
        _isSealedHVT = !_hasExitHVT;
    };

    if (_isSealedHVT) then {
        private _altPtHVT = objNull;
        {
            private _cPosHVT = getPosATL _x;
            private _cBldgHVT = nearestBuilding _cPosHVT;
            private _cDoorsHVT = if (!isNull _cBldgHVT) then { getNumber (configFile >> "CfgVehicles" >> (typeOf _cBldgHVT) >> "numberOfDoors") } else { 0 };
            if (_cDoorsHVT > 0) exitWith { _altPtHVT = _x; };
        } forEach _validSpawnPoints;

        if (!isNull _altPtHVT) then {
            _altPtHVT setVariable ["LL_logic_occupied", true];
            _hvtPos = getPosATL _altPtHVT;
            _hvtPos set [2, (_hvtPos select 2) + 0.2];
        } else {
            private _safeOutHVT = [_centerPos, 15, 65, 4, 0, 0.3, 0] call BIS_fnc_findSafePos;
            if (count _safeOutHVT == 2) then {
                _hvtPos = [_safeOutHVT select 0, _safeOutHVT select 1, 0.2];
            };
        };
    };

    if (_doorsHVT > 0) then {
        for "_d" from 1 to _doorsHVT do {
            _nearBldgHVT setVariable [format ["bis_disabled_Door_%1", _d], 0, true];
        };
    };
};

private _allGuards = [];
private _allGroups = [];

private _sentinelLogics = _otherLogics select [0, 4];
{
    private _sPos = getPosATL _x;
    _sPos set [2, (_sPos select 2) + 0.2];
    
    private _sGrp = createGroup [east, true];
    _sGrp setBehaviour "SAFE";
    _sGrp setCombatMode "WHITE";
    _allGroups pushBack _sGrp;

    private _fEnemyClasses = (missionNamespace getVariable ["MISSION_EnemyClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) };
    private _isSentinelFemale = (random 1) < 0.20 && { count _fEnemyClasses > 0 };
    private _sClass = "O_G_Soldier_F";
    if (_isSentinelFemale) then {
        private _picked = selectRandom _fEnemyClasses;
        if (!isNil "_picked" && { _picked != "" }) then {
            _sClass = _picked;
        };
    };
    private _sentinel = _sGrp createUnit [_sClass, _sPos, [], 0, "CAN_COLLIDE"];
    [_sentinel] joinSilent _sGrp;
    _sentinel setVariable ["not_Random", true, true];
    _sentinel setPosATL _sPos;
    _sentinel setDir (random 360);
    _sentinel disableAI "MOVE";
    _sentinel allowDamage false;
    [_sentinel] spawn { sleep 3; (_this select 0) allowDamage true; };
    [_sentinel, _isSentinelFemale, true] call LL_fnc_applyTakistaniIdentity;
    
    _allGuards pushBack _sentinel;
    sleep 0.2;
} forEach _sentinelLogics;

private _patrolLogics = _otherLogics - _sentinelLogics;
if (count _patrolLogics == 0) then {
    _patrolLogics = if (count _otherLogics > 0) then { _otherLogics } else { _validSpawnPoints };
};

for "_p" from 1 to 2 do {
    private _pGrp = createGroup [east, true];
    _pGrp setBehaviour "SAFE";
    _pGrp setCombatMode "WHITE";
    _pGrp setSpeedMode "LIMITED";
    _allGroups pushBack _pGrp;

    private _pStartPos = _hvtPos getPos [30 + random 50, random 360];
    if (count _patrolLogics > 0) then {
        _pStartPos = getPosATL (selectRandom _patrolLogics);
    };
    _pStartPos set [2, (_pStartPos select 2) + 0.2];

    for "_g" from 1 to 2 do {
        private _fEnemyClasses = (missionNamespace getVariable ["MISSION_EnemyClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) };
        private _isPGuardFemale = (random 1) < 0.15 && { count _fEnemyClasses > 0 };
        private _pGuardClass = "O_G_Soldier_F";
        if (_isPGuardFemale) then {
            private _picked = selectRandom _fEnemyClasses;
            if (!isNil "_picked" && { _picked != "" }) then {
                _pGuardClass = _picked;
            };
        };
        private _pGuard = _pGrp createUnit [_pGuardClass, _pStartPos, [], 0, "CAN_COLLIDE"];
        [_pGuard] joinSilent _pGrp;
        _pGuard setVariable ["not_Random", true, true];
        _pGuard setPosATL _pStartPos;
        _pGuard allowDamage false;
        [_pGuard] spawn { sleep 3; (_this select 0) allowDamage true; };
        [_pGuard, _isPGuardFemale, true] call LL_fnc_applyTakistaniIdentity;
        _allGuards pushBack _pGuard;
        sleep 0.2;
    };

    [_pGrp, _pStartPos, 80] call BIS_fnc_taskPatrol;
    sleep 0.5;
};

private _bgGrp = createGroup [east, true];
_bgGrp setBehaviour "SAFE";
_bgGrp setCombatMode "WHITE";
_allGroups pushBack _bgGrp;

private _angles = [0, 120, 240];
{
    private _bgPos = _hvtPos getPos [3 + random 2, _x];
    _bgPos set [2, (_bgPos select 2) + 0.2];

    private _fEnemyClasses = (missionNamespace getVariable ["MISSION_EnemyClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) };
    private _isBgFemale = (random 1) < 0.15 && { count _fEnemyClasses > 0 };
    private _bgClass = "O_G_Soldier_F";
    if (_isBgFemale) then {
        private _picked = selectRandom _fEnemyClasses;
        if (!isNil "_picked" && { _picked != "" }) then {
            _bgClass = _picked;
        };
    };
    private _bg = _bgGrp createUnit [_bgClass, _bgPos, [], 0, "CAN_COLLIDE"];
    [_bg] joinSilent _bgGrp;
    _bg setVariable ["not_Random", true, true];
    _bg setPosATL _bgPos;
    _bg setDir (_x + 180);
    _bg allowDamage false;
    [_bg] spawn { sleep 3; (_this select 0) allowDamage true; };
    [_bg, _isBgFemale, true] call LL_fnc_applyTakistaniIdentity;
    _allGuards pushBack _bg;
    sleep 0.2;
} forEach _angles;

sleep 1.5;

private _hvtGrp = createGroup [east, true];
_hvtGrp setBehaviour "SAFE";
_hvtGrp setCombatMode "WHITE";
_allGroups pushBack _hvtGrp;

private _fEnemyClasses = (missionNamespace getVariable ["MISSION_EnemyClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) };
private _isHvtFemale = (random 1) < 0.10 && { count _fEnemyClasses > 0 };
private _hvtClass = "O_Officer_F";
if (_isHvtFemale) then {
    private _picked = selectRandom _fEnemyClasses;
    if (!isNil "_picked" && { _picked != "" }) then {
        _hvtClass = _picked;
    };
};
private _hvt = _hvtGrp createUnit [_hvtClass, _hvtPos, [], 0, "CAN_COLLIDE"];
[_hvt] joinSilent _hvtGrp;
_hvt setVariable ["not_Random", true, true];
_hvt setPosATL _hvtPos;
_hvt setDir (random 360);
_hvt allowDamage false;
[_hvt] spawn { sleep 3; (_this select 0) allowDamage true; };
[_hvt, _isHvtFemale, true] call LL_fnc_applyTakistaniIdentity;
_hvt setRank "COLONEL";

missionNamespace setVariable ["LL_g_hvtAlertTriggered", false, true];

private _fn_triggerAlert = {
    params ["_shooterPos"];
    if (missionNamespace getVariable ["LL_g_hvtAlertTriggered", false]) exitWith {};
    missionNamespace setVariable ["LL_g_hvtAlertTriggered", true, true];

    {
        if (!isNull _x) then {
            _x enableAI "MOVE";
            _x setUnitPos "AUTO";
        };
    } forEach _allGuards;

    {
        if (!isNull _x) then {
            _x setBehaviour "COMBAT";
            _x setCombatMode "RED";
            _x setSpeedMode "FULL";
        };
    } forEach _allGroups;

    if (!isNil "_shooterPos" && { count _shooterPos >= 2 }) then {
        {
            if (!isNull _x) then {
                _x reveal [_shooterPos, 2];
            };
        } forEach _allGroups;
    };
};

{
    if (!isNull _x) then {
        _x addEventHandler ["FiredNear", {
            params ["_unit", "_firer", "_distance"];
            if (_distance < 250 && { side _firer != east }) then {
                [getPosATL _firer] call _fn_triggerAlert;
            };
        }];

        _x addEventHandler ["Killed", {
            params ["_unit", "_killer"];
            [getPosATL _unit] call _fn_triggerAlert;
        }];

        _x addEventHandler ["Hit", {
            params ["_unit", "_causedBy"];
            [getPosATL _unit] call _fn_triggerAlert;
        }];
    };
} forEach (_allGuards + [_hvt]);

[
    group player,
    ["task_d_hvt"],
    [
        localize "STR_LL_Task_D_HVT_Desc",
        localize "STR_LL_Task_D_HVT_Title",
        localize "STR_LL_Task_D_HVT_Marker"
    ],
    [_hvt, true],
    "AUTOASSIGNED",
    5,
    true,
    "kill",
    false
] call BIS_fnc_taskCreate;
call LL_fnc_saveProgress;

waitUntil {
    sleep 2;
    isNull _hvt || {!alive _hvt}
};

["task_d_hvt", "SUCCEEDED", true] call BIS_fnc_taskSetState;
missionNamespace setVariable ["LL_g_taskInProgress", false, true];

private _remainingGuards = _allGuards select { !isNull _x && { alive _x } };
if (count _remainingGuards > 0) then {
    [_remainingGuards] spawn LL_fnc_taskCleanup;
};
