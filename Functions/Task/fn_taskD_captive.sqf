if (!isServer) exitWith {};

params [
    ["_locMarker", "", [""]]
];

if (_locMarker == "" || { !(_locMarker in allMapMarkers) }) exitWith {
    missionNamespace setVariable ["LL_g_taskInProgress", false, true];
};

private _fnc_findSafeLandPos = {
    params ["_center", "_minDist", "_maxDist", ["_prefDir", -1], ["_dirArc", 120]];
    private _res = [];
    for "_attempt" from 1 to 24 do {
        private _d = if (_prefDir >= 0) then {
            (_prefDir - (_dirArc / 2) + random _dirArc + 360) % 360
        } else {
            random 360
        };
        private _dist = _minDist + random ((_maxDist - _minDist) max 5);
        private _test = _center getPos [_dist, _d];
        if (!surfaceIsWater _test) exitWith {
            _test set [2, 0];
            _res = _test;
        };
    };
    if (_res isEqualTo []) then {
        for "_r" from _minDist to 10 step -10 do {
            for "_stepD" from 0 to 315 step 45 do {
                private _tp = _center getPos [_r, _stepD];
                if (!surfaceIsWater _tp) exitWith { _res = _tp; };
            };
            if (!(_res isEqualTo [])) exitWith {};
        };
    };
    if (_res isEqualTo []) then { _res = +_center; };
    _res set [2, 0];
    _res
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

private _captivePatrolConfigs = [
    [2, 6, 14, 45, "SAFE"],
    [3, 35, 65, 165, "SAFE"],
    [3, 85, 150, 285, "AWARE"]
];

{
    _x params ["_sz", "_minD", "_maxD", "_baseDir", "_behav"];
    private _grpEnemy = createGroup [east, true];
    _grpEnemy setBehaviour _behav;
    _grpEnemy setSpeedMode "LIMITED";
    _grpEnemy setCombatMode "RED";

    private _grpCenter = [_spawnPos, _minD, _maxD, _baseDir, 90] call _fnc_findSafeLandPos;

    for "_g" from 1 to _sz do {
        private _fClasses = (missionNamespace getVariable ["MISSION_EnemyClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) };
        private _isGuardFemale = (random 1) < 0.20 && { count _fClasses > 0 };
        private _guardClass = "O_G_Soldier_F";
        if (_isGuardFemale) then {
            private _picked = selectRandom _fClasses;
            if (!isNil "_picked" && { _picked != "" }) then {
                _guardClass = _picked;
            };
        };
        private _guardSpot = [_grpCenter, 2, 6] call _fnc_findSafeLandPos;
        _guardSpot set [2, 0.1];
        private _guard = _grpEnemy createUnit [_guardClass, _guardSpot, [], 0, "CAN_COLLIDE"];
        [_guard] joinSilent _grpEnemy;
        _guard setVariable ["not_Random", true, true];
        _guard setPosATL _guardSpot;
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
        sleep 0.15;
    };

    private _wpPos1 = [_grpCenter, 10, 25, _baseDir - 35, 60] call _fnc_findSafeLandPos;
    private _wpPos2 = [_grpCenter, 15, 35, _baseDir + 35, 60] call _fnc_findSafeLandPos;
    private _wpPos3 = [_grpCenter, 5, 20, _baseDir + 180, 80] call _fnc_findSafeLandPos;

    private _wp1 = _grpEnemy addWaypoint [_wpPos1, 0];
    _wp1 setWaypointType "MOVE";
    _wp1 setWaypointSpeed "LIMITED";
    _wp1 setWaypointFormation "STAG COLUMN";
    _wp1 setWaypointBehaviour _behav;
    _wp1 setWaypointTimeout [4, 8, 14];

    private _wp2 = _grpEnemy addWaypoint [_wpPos2, 0];
    _wp2 setWaypointType "MOVE";
    _wp2 setWaypointSpeed "LIMITED";
    _wp2 setWaypointTimeout [4, 8, 14];

    private _wp3 = _grpEnemy addWaypoint [_wpPos3, 0];
    _wp3 setWaypointType "MOVE";
    _wp3 setWaypointSpeed "LIMITED";
    _wp3 setWaypointTimeout [4, 8, 14];

    private _wp4 = _grpEnemy addWaypoint [_wpPos1, 0];
    _wp4 setWaypointType "CYCLE";

    sleep 0.5;
} forEach _captivePatrolConfigs;

sleep 1.5;

private _grpCiv = createGroup [civilian, true];
private _fClasses = (missionNamespace getVariable ["MISSION_CivilianClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) && _x != "C_man_1" };
private _mClasses = (missionNamespace getVariable ["MISSION_CivilianClasses_Male", ["C_Man_casual_1_F_tanoan", "C_man_1"]]) select { isClass (configFile >> "CfgVehicles" >> _x) };
if (count _mClasses == 0) then { _mClasses = ["C_man_1"]; };
private _isHostageFemale = (random 1) < 0.35 && { count _fClasses > 0 };
private _hostageClass = if (_isHostageFemale) then {
    selectRandom _fClasses
} else {
    selectRandom _mClasses
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
