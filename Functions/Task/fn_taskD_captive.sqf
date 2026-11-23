if (!isServer) exitWith {};

params [
    ["_locMarker", "", [""]]
];

if (_locMarker == "" || { !(_locMarker in allMapMarkers) }) exitWith {
    missionNamespace setVariable ["LL_g_taskInProgress", false, true];
};

private _centerPos = getMarkerPos _locMarker;
if (_centerPos isEqualTo [0, 0, 0]) exitWith {
    missionNamespace setVariable ["LL_g_taskInProgress", false, true];
};
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

private _spawnPos = _centerPos;
private _sitePrimary = missionNamespace getVariable [format ["LL_g_sitePrimaryPos_%1", _locMarker], []];

if (count _sitePrimary == 3) then {
    _spawnPos = +_sitePrimary;
    _usedPositions pushBack _spawnPos;
    missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];
} else {
    if (count _validSpawnPoints > 0) then {
        private _shuffled = _validSpawnPoints call BIS_fnc_arrayShuffle;
        private _chosenLogic = _shuffled select 0;
        _chosenLogic setVariable ["LL_logic_occupied", true];
        _spawnPos = getPosATL _chosenLogic;
        _usedPositions pushBack _spawnPos;
        missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];
    } else {
        _spawnPos = _centerPos getPos [50 + random 80, random 360];
        _usedPositions pushBack _spawnPos;
        missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];
    };
};

_spawnPos set [2, 0.1];

private _nearBldg = nearestBuilding _spawnPos;
if (!isNull _nearBldg && { _spawnPos distance2D _nearBldg < 35 }) then {
    private _cfg = configFile >> "CfgVehicles" >> (typeOf _nearBldg);
    private _numDoors = if (isClass _cfg) then { getNumber (_cfg >> "numberOfDoors") } else { 0 };
    private _isSealed = false;

    if (_numDoors == 0) then {
        private _hasExit = false;
        private _spASL = ATLToASL [_spawnPos select 0, _spawnPos select 1, (_spawnPos select 2) + 1.0];
        for "_deg" from 0 to 315 step 45 do {
            private _outASL = ATLToASL [
                (_spawnPos select 0) + (sin _deg * 8),
                (_spawnPos select 1) + (cos _deg * 8),
                (_spawnPos select 2) + 1.0
            ];
            if (!lineIntersects [_spASL, _outASL]) exitWith { _hasExit = true; };
        };
        _isSealed = !_hasExit;
    };

    if (_isSealed) then {
        private _alternativePoint = objNull;
        {
            private _candPos = getPosATL _x;
            private _candBldg = nearestBuilding _candPos;
            private _candDoors = if (!isNull _candBldg) then { getNumber (configFile >> "CfgVehicles" >> (typeOf _candBldg) >> "numberOfDoors") } else { 0 };
            if (_candDoors > 0) exitWith { _alternativePoint = _x; };
        } forEach _validSpawnPoints;

        if (!isNull _alternativePoint) then {
            _alternativePoint setVariable ["LL_logic_occupied", true];
            _spawnPos = getPosATL _alternativePoint;
            _spawnPos set [2, 0.1];
        } else {
            private _safeOutPos = [_centerPos, 15, 65, 4, 0, 0.3, 0] call BIS_fnc_findSafePos;
            if (count _safeOutPos == 2) then {
                _spawnPos = [_safeOutPos select 0, _safeOutPos select 1, 0.1];
            };
        };
    };

    if (_numDoors > 0) then {
        for "_d" from 1 to _numDoors do {
            _nearBldg setVariable [format ["bis_disabled_Door_%1", _d], 0, true];
        };
    };
};

private _allUnits = [];

private _numGroups = 3;
for "_i" from 0 to (_numGroups - 1) do {
    private _grpEnemy = createGroup [east, true];
    _grpEnemy setBehaviour "SAFE";
    _grpEnemy setCombatMode "RED";

    private _numGuards = 2 + floor (random 2);
    for "_g" from 1 to _numGuards do {
        sleep 0.4;
        private _guardPos = _spawnPos getPos [1 + random 3, random 360];
        _guardPos set [2, 0.1];
        
        private _fClasses = (missionNamespace getVariable ["MISSION_EnemyClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) };
        private _isGuardFemale = (random 1) < 0.20 && { count _fClasses > 0 };
        private _guardClass = "O_G_Soldier_F";
        if (_isGuardFemale) then {
            private _picked = selectRandom _fClasses;
            if (!isNil "_picked" && { _picked != "" }) then {
                _guardClass = _picked;
            };
        };
        private _guard = _grpEnemy createUnit [_guardClass, _guardPos, [], 0, "CAN_COLLIDE"];
        [_guard] joinSilent _grpEnemy;
        _guard setVariable ["not_Random", true, true];
        _guard setPosATL _guardPos;
        _guard allowDamage false;
        _guard setDamage 0;
        _guard setBleedingRemaining 0;
        [_guard] spawn { 
            sleep 3; 
            if (!isNull (_this select 0)) then {
                (_this select 0) setDamage 0;
                (_this select 0) setBleedingRemaining 0;
                (_this select 0) allowDamage true;
            };
        };
        [_guard, _isGuardFemale, true] call LL_fnc_applyTakistaniIdentity;
        _allUnits pushBack _guard;
    };

    private _currentRadius = round (15 + (_i * 15) + (random 10));
    [_grpEnemy, _spawnPos, _currentRadius] call BIS_fnc_taskPatrol;
};

sleep 1.5;

private _grpCiv = createGroup [civilian, true];
private _fClasses = (missionNamespace getVariable ["MISSION_CivilianClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) && _x != "C_man_1" };
private _isHostageFemale = (random 1) < 0.50 && { count _fClasses > 0 };
private _hostageClass = "C_man_1";
if (_isHostageFemale) then {
    private _picked = selectRandom _fClasses;
    if (!isNil "_picked" && { _picked != "" }) then {
        _hostageClass = _picked;
    };
};
private _hostage = _grpCiv createUnit [_hostageClass, _spawnPos, [], 0, "CAN_COLLIDE"];
_hostage setVariable ["not_Random", true, true];
_hostage setPosATL _spawnPos;
_hostage allowDamage false;
_hostage setDamage 0;
_hostage setBleedingRemaining 0;
[_hostage] spawn { 
    sleep 3; 
    if (!isNull (_this select 0)) then {
        (_this select 0) setDamage 0;
        (_this select 0) setBleedingRemaining 0;
        (_this select 0) allowDamage true;
    };
};
[_hostage, _isHostageFemale, false] call LL_fnc_applyTakistaniIdentity;

_hostage setCaptive true;
removeAllWeapons _hostage;
removeBackpack _hostage;

_hostage setVariable ["LL_Task_Status", "WAIT"];

_hostage disableAI "MOVE";
_hostage disableAI "ANIM";
_hostage setUnitPos "UP";
_hostage switchMove "Acts_ExecutionVictim_Loop";
_hostage setDamage 0;
_hostage setBleedingRemaining 0;

_hostage addEventHandler ["AnimDone", {
    params ["_unit"];
    if (alive _unit && (_unit getVariable ["LL_Task_Status", "WAIT"]) == "WAIT") then {
        _unit switchMove "Acts_ExecutionVictim_Loop";
    };
}];

_hostage addEventHandler ["Killed", {
    ["task_d_captive", "FAILED", true] call BIS_fnc_taskSetState;
    missionNamespace setVariable ["LL_g_taskInProgress", false, true];
}];

_hostage addAction [
    format ["<t color='#FFFF00'>%1</t>", localize "STR_LL_Task_00_Action"],
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        if (missionNamespace getVariable ["LL_TaskDCaptive_Triggered", false]) exitWith {};
        missionNamespace setVariable ["LL_TaskDCaptive_Triggered", true];
        
        _target removeAction _actionId;
        _target setVariable ["LL_Task_Status", "ACTION"];
        
        [_target, _caller] spawn {
            params ["_hostage", "_caller"];
            
            _hostage setCaptive false;
            _hostage enableAI "ANIM";
            
            private _hostageFixedPos = getPosATL _hostage;
            private _hostageFixedDir = getDir _hostage;
            
            _hostage switchMove "Acts_ExecutionVictim_Unbow";
            
            private _tStart = time;
            while { alive _hostage && (_hostage getVariable ["LL_Task_Status", "WAIT"]) == "ACTION" && (time - _tStart) < 8.5 } do {
                _hostage setPosATL _hostageFixedPos;
                _hostage setDir _hostageFixedDir;
                sleep 0.05;
            };
            
            if (!alive _hostage) exitWith {};
            
            _hostage setPosATL _hostageFixedPos;
            _hostage setDir _hostageFixedDir;
            _hostage switchMove "";
            _hostage setVariable ["LL_Task_Status", "FREE"];
            
            [_hostage] joinSilent (group _caller);
            
            { _hostage enableAI _x; } forEach ["MOVE", "AUTOTARGET", "TARGET"];
            _hostage setUnitPos "UP";
            _hostage setSkill ["courage", 1];
            _hostage allowFleeing 0;
            _hostage disableAI "FSM";
            _hostage disableAI "AUTOCOMBAT";
            _hostage disableAI "SUPPRESSION";
            _hostage setBehaviour "CARELESS";
            _hostage setSpeedMode "FULL";
            
            [_hostage] spawn {
                params ["_h"];
                while {alive _h && group _h == group player} do {
                    if (vehicle _h == _h && _h distance2D player > 30) then {
                        _h doMove (getPosATL player);
                    };
                    sleep 5;
                };
            };
            
            ["task_d_captive", "SUCCEEDED", true] call BIS_fnc_taskSetState;
            missionNamespace setVariable ["LL_g_taskInProgress", false, true];
        };
    },
    nil, 6, true, true, "", "_this distance _target < 4"
];

[
    group player,
    ["task_d_captive"],
    [
        localize "STR_LL_Task_00_Desc",
        localize "STR_LL_Task_00_Title",
        localize "STR_LL_Task_00_MarkerMain"
    ],
    [_hostage, true],
    "AUTOASSIGNED",
    5,
    true,
    "interact",
    false
] call BIS_fnc_taskCreate;
call LL_fnc_saveProgress;

{
    _x createDiaryRecord ["diary", [localize "STR_LL_Diary_Task00_Title", localize "STR_LL_Diary_Task00_Text"]];
} forEach (units group player);

waitUntil {
    sleep 2;
    isNull _hostage || {!alive _hostage} || {(_hostage getVariable ["LL_Task_Status", "WAIT"]) == "FREE"}
};

private _guards = _allUnits select { alive _x };
if (count _guards > 0) then {
    [_guards] spawn LL_fnc_taskCleanup;
};
