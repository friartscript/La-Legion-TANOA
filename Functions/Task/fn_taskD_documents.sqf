if (!isServer) exitWith {};

params [
    ["_locMarker", "", [""]]
];

if (_locMarker == "" || !(_locMarker in allMapMarkers)) exitWith { missionNamespace setVariable ["LL_g_taskInProgress", false, true]; false };

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

if (count _validSpawnPoints < 2) then {
    while { count _validSpawnPoints < 2 } do {
        private _dummyLogic = "Logic" createVehicleLocal (_centerPos getPos [120 + random 200, random 360]);
        _validSpawnPoints pushBack _dummyLogic;
    };
};

private _numSpawns = (1 + floor (random 2)) min (count _validSpawnPoints);
private _shuffled = _validSpawnPoints call BIS_fnc_arrayShuffle;
private _selectedLogics = _shuffled select [0, _numSpawns];

private _sitePrimary = missionNamespace getVariable [format ["LL_g_sitePrimaryPos_%1", _locMarker], []];
if (count _sitePrimary == 3) then {
    private _pLogicMatches = _validSpawnPoints select { (getPosATL _x) distance2D _sitePrimary < 2 };
    if (count _pLogicMatches > 0) then {
        private _pLogic = _pLogicMatches select 0;
        _selectedLogics = [_pLogic] + ((_validSpawnPoints - [_pLogic]) select [0, _numSpawns - 1]);
    };
};

{
    _x setVariable ["LL_logic_occupied", true];
    private _p = getPosATL _x;
    if (_p isEqualTo [0,0,0]) then { _p = getPos _x; };
    _usedPositions pushBack _p;
} forEach _selectedLogics;
missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];

missionNamespace setVariable ["LL_TaskD_Doc_NumZones", _numSpawns, true];
private _targetIndex = floor random _numSpawns;
missionNamespace setVariable ["LL_TaskD_Doc_AllUnits", [], true];
private _officersData = [];
private _targetOfficer = objNull;

for "_i" from 0 to (_numSpawns - 1) do {
    private _logic = _selectedLogics select _i;
    private _spawnPos = getPosATL _logic;
    if (_spawnPos isEqualTo [0,0,0]) then { _spawnPos = getPos _logic; };
    _spawnPos set [2, (_spawnPos select 2) + 0.2];

    private _nearBldgDoc = nearestBuilding _spawnPos;
    if (!isNull _nearBldgDoc && { _spawnPos distance2D _nearBldgDoc < 35 }) then {
        private _cfgDoc = configFile >> "CfgVehicles" >> (typeOf _nearBldgDoc);
        private _doorsDoc = if (isClass _cfgDoc) then { getNumber (_cfgDoc >> "numberOfDoors") } else { 0 };
        private _isSealedDoc = false;

        if (_doorsDoc == 0) then {
            private _hasExitDoc = false;
            private _spASLDoc = ATLToASL [_spawnPos select 0, _spawnPos select 1, (_spawnPos select 2) + 1.0];
            for "_deg" from 0 to 315 step 45 do {
                private _outASLDoc = ATLToASL [
                    (_spawnPos select 0) + (sin _deg * 8),
                    (_spawnPos select 1) + (cos _deg * 8),
                    (_spawnPos select 2) + 1.0
                ];
                if (!lineIntersects [_spASLDoc, _outASLDoc]) exitWith { _hasExitDoc = true; };
            };
            _isSealedDoc = !_hasExitDoc;
        };

        if (_isSealedDoc) then {
            private _safeOutDoc = [_centerPos, 15, 65, 4, 0, 0.3, 0] call BIS_fnc_findSafePos;
            if (count _safeOutDoc == 2) then {
                _spawnPos = [_safeOutDoc select 0, _safeOutDoc select 1, 0.2];
            };
        };

        if (_doorsDoc > 0) then {
            for "_d" from 1 to _doorsDoc do {
                _nearBldgDoc setVariable [format ["bis_disabled_Door_%1", _d], 0, true];
            };
        };
    };

    private _zoneGuards = [];
    
    private _patrolConfigs = [
        [3, 20, 45, 45, "SAFE"],
        [3, 55, 95, 165, "SAFE"],
        [3, 105, 175, 285, "AWARE"]
    ];

    {
        _x params ["_sz", "_minD", "_maxD", "_baseDir", "_behav"];
        private _grp = createGroup [east, true];
        _grp setBehaviour _behav;
        _grp setSpeedMode "LIMITED";
        _grp setCombatMode "YELLOW";

        private _grpCenter = [_spawnPos, _minD, _maxD, _baseDir, 90] call _fnc_findSafeLandPos;

        for "_g" from 1 to _sz do {
            private _fEnemyClasses = (missionNamespace getVariable ["MISSION_EnemyClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) };
            private _isGuardFemale = (random 1) < 0.15 && { count _fEnemyClasses > 0 };
            private _guardClass = "O_G_Soldier_F";
            if (_isGuardFemale) then {
                private _picked = selectRandom _fEnemyClasses;
                if (!isNil "_picked" && { _picked != "" }) then {
                    _guardClass = _picked;
                };
            };
            private _guardSpot = [_grpCenter, 2, 7] call _fnc_findSafeLandPos;
            _guardSpot set [2, (_spawnPos select 2)];
            private _guard = _grp createUnit [_guardClass, _guardSpot, [], 0, "CAN_COLLIDE"];
            [_guard] joinSilent _grp;
            _guard setVariable ["not_Random", true, true];
            _guard setPosATL _guardSpot;
            _guard allowDamage false;
            [_guard] spawn { sleep 3; (_this select 0) allowDamage true; };
            [_guard, _isGuardFemale, true] call LL_fnc_applyTakistaniIdentity;
            _zoneGuards pushBack _guard;
            sleep 0.15;
        };

        private _wpPos1 = [_grpCenter, 10, 25, _baseDir - 35, 60] call _fnc_findSafeLandPos;
        private _wpPos2 = [_grpCenter, 15, 35, _baseDir + 35, 60] call _fnc_findSafeLandPos;
        private _wpPos3 = [_grpCenter, 5, 20, _baseDir + 180, 80] call _fnc_findSafeLandPos;

        private _wp1 = _grp addWaypoint [_wpPos1, 0];
        _wp1 setWaypointType "MOVE";
        _wp1 setWaypointSpeed "LIMITED";
        _wp1 setWaypointFormation "STAG COLUMN";
        _wp1 setWaypointBehaviour _behav;
        _wp1 setWaypointTimeout [4, 8, 14];

        private _wp2 = _grp addWaypoint [_wpPos2, 0];
        _wp2 setWaypointType "MOVE";
        _wp2 setWaypointSpeed "LIMITED";
        _wp2 setWaypointTimeout [4, 8, 14];

        private _wp3 = _grp addWaypoint [_wpPos3, 0];
        _wp3 setWaypointType "MOVE";
        _wp3 setWaypointSpeed "LIMITED";
        _wp3 setWaypointTimeout [4, 8, 14];

        private _wp4 = _grp addWaypoint [_wpPos1, 0];
        _wp4 setWaypointType "CYCLE";

        sleep 0.5;
    } forEach _patrolConfigs;

    sleep 1.0;

    private _grpOfficer = createGroup [east, true];
    _grpOfficer setBehaviour "SAFE";
    _grpOfficer setCombatMode "YELLOW";
    private _fEnemyClasses = (missionNamespace getVariable ["MISSION_EnemyClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) };
    private _isOfficerFemale = (random 1) < 0.10 && { count _fEnemyClasses > 0 };
    private _officerClass = "O_Officer_F";
    if (_isOfficerFemale) then {
        private _picked = selectRandom _fEnemyClasses;
        if (!isNil "_picked" && { _picked != "" }) then {
            _officerClass = _picked;
        };
    };
    private _officer = _grpOfficer createUnit [_officerClass, _spawnPos, [], 0, "CAN_COLLIDE"];
    [_officer] joinSilent _grpOfficer;
    _officer setVariable ["not_Random", true, true];
    _officer setPosATL _spawnPos;
    _officer allowDamage false;
    [_officer] spawn { sleep 3; (_this select 0) allowDamage true; };
    [_officer, _isOfficerFemale, true] call LL_fnc_applyTakistaniIdentity;
    _officer setRank "COLONEL";

    private _offWpPos1 = [_spawnPos, 5, 18, 0, 180] call _fnc_findSafeLandPos;
    private _offWpPos2 = [_spawnPos, 5, 18, 180, 180] call _fnc_findSafeLandPos;
    private _wpO1 = _grpOfficer addWaypoint [_offWpPos1, 0];
    _wpO1 setWaypointType "MOVE";
    _wpO1 setWaypointSpeed "LIMITED";
    _wpO1 setWaypointBehaviour "SAFE";
    _wpO1 setWaypointTimeout [6, 12, 20];
    private _wpO2 = _grpOfficer addWaypoint [_offWpPos2, 0];
    _wpO2 setWaypointType "MOVE";
    _wpO2 setWaypointSpeed "LIMITED";
    _wpO2 setWaypointTimeout [6, 12, 20];
    private _wpO3 = _grpOfficer addWaypoint [_offWpPos1, 0];
    _wpO3 setWaypointType "CYCLE";

    private _allUnits = missionNamespace getVariable ["LL_TaskD_Doc_AllUnits", []];
    _allUnits append _zoneGuards;
    _allUnits pushBack _officer;
    missionNamespace setVariable ["LL_TaskD_Doc_AllUnits", _allUnits, true];

    if (_i == _targetIndex) then {
        _officer setVariable ["LL_hasDocuments", true, true];
        _targetOfficer = _officer;
    } else {
        _officer setVariable ["LL_hasDocuments", false, true];
    };

    _officer addEventHandler ["Killed", {
        params ["_unit"];
        
        if (_unit getVariable ["LL_hasDocuments", false]) then {
            
            if (isNil "LL_fnc_taskD_docComplete") then {
                missionNamespace setVariable ["LL_fnc_taskD_docComplete", {
                    params ["_unit"];
                    ["task_d_documents", "SUCCEEDED", true] call BIS_fnc_taskSetState;
                    missionNamespace setVariable ["LL_g_taskInProgress", false, true];
                    
                    private _allU = missionNamespace getVariable ["LL_TaskD_Doc_AllUnits", []];
                    private _alive = _allU select { alive _x };
                    if (count _alive > 0) then {
                        [_alive] spawn LL_fnc_taskCleanup;
                    };
                }];
            };

            private _actionTitle = format ["<t color='#FFFF00'>%1</t>", "Fouiller le corps (Documents)"];
            
            [
                _unit, 
                _actionTitle, 
                "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa", 
                "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa", 
                "_this distance _target < 3", 
                "true", 
                { (_this select 1) playActionNow "PutDown"; }, 
                {}, 
                {
                    params ["_target", "_caller", "_actionId", "_arguments"];
                    _arguments params ["_unit"];
                    
                    if (missionNamespace getVariable ["LL_TaskD_Doc_Triggered", false]) exitWith {};
                    missionNamespace setVariable ["LL_TaskD_Doc_Triggered", true];
                    
                    if (_caller canAdd "Item_Document_01_F") then { _caller addItem "Item_Document_01_F"; };
                    
                    [_target, _actionId] call BIS_fnc_holdActionRemove;
                    [_unit] call (missionNamespace getVariable "LL_fnc_taskD_docComplete");
                }, 
                {}, 
                [_unit], 
                1.5, 
                10, 
                true, 
                false
            ] call BIS_fnc_holdActionAdd;
            
            private _alivePlayers = allPlayers select { alive _x };
            private _allTaskUnits = missionNamespace getVariable ["LL_TaskD_Doc_AllUnits", []];
            private _guards = _allTaskUnits select { alive _x && _x != _unit };
            if (count _guards > 0 && count _alivePlayers > 0) then {
                private _grpsProcessed = [];
                {
                    private _guard = _x;
                    _guard setBehaviour "COMBAT";
                    _guard setCombatMode "RED";
                    _guard setSpeedMode "FULL";
                    { _guard reveal [_x, 4]; } forEach _alivePlayers;

                    private _grp = group _guard;
                    if !(_grp in _grpsProcessed) then {
                        _grpsProcessed pushBack _grp;
                        private _nearest = _alivePlayers select 0;
                        while { count waypoints _grp > 0 } do { deleteWaypoint [_grp, 0]; };
                        private _wp = _grp addWaypoint [getPosATL _nearest, 10];
                        _wp setWaypointType "SAD";
                    };
                } forEach _guards;
            };
        };
    }];
};

[
    group player,
    ["task_d_documents"],
    [
        localize "STR_LL_Task_01_Desc",
        localize "STR_LL_Task_01_Title",
        localize "STR_LL_Task_01_Marker"
    ],
    [_targetOfficer, true],
    "AUTOASSIGNED",
    5,
    true,
    "documents",
    false
] call BIS_fnc_taskCreate;
call LL_fnc_saveProgress;

{ _x createDiaryRecord ["diary", [localize "STR_LL_Diary_Task01_Title", localize "STR_LL_Diary_Task01_Text"]]; } forEach (units group player);
