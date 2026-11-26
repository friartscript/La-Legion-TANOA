if (!isServer) exitWith { false };
if (missionNamespace getVariable ["LL_g_dynamicSitesPrepared", false]) exitWith { true };

private _fnc_validateLZ = {
    params ["_candidate", "_anchorCenter", "_allSitesInZone", ["_minDistToAnchor", 950]];

    if (surfaceIsWater _candidate) exitWith { false };

    private _centerH = getTerrainHeightASL _candidate;
    if (_centerH > 95 || { _centerH < 3 }) exitWith { false };

    private _nearWater = false;
    {
        if (surfaceIsWater (_candidate getPos [50, _x])) exitWith { _nearWater = true; };
    } forEach [0, 45, 90, 135, 180, 225, 270, 315];
    if (_nearWater) exitWith { false };

    if (((surfaceNormal _candidate) select 2) < 0.98) exitWith { false };

    private _maxHDiff = 0;
    {
        private _p = _candidate getPos [_x select 0, _x select 1];
        if (surfaceIsWater _p) exitWith { _maxHDiff = 999; };
        private _diff = abs ((getTerrainHeightASL _p) - _centerH);
        if (_diff > _maxHDiff) then { _maxHDiff = _diff; };
    } forEach [
        [15, 0], [15, 45], [15, 90], [15, 135], [15, 180], [15, 225], [15, 270], [15, 315],
        [25, 0], [25, 60], [25, 120], [25, 180], [25, 240], [25, 300]
    ];
    if (_maxHDiff > 1.5) exitWith { false };

    private _overheadBlocked = false;
    {
        private _pt = _candidate getPos [_x select 0, _x select 1];
        private _ptASL = ATLToASL _pt;
        private _topASL = [_ptASL select 0, _ptASL select 1, (_ptASL select 2) + 35];
        if (lineIntersects [_ptASL, _topASL]) exitWith { _overheadBlocked = true; };
    } forEach [[0, 0], [15, 0], [15, 90], [15, 180], [15, 270]];
    if (_overheadBlocked) exitWith { false };

    private _nearTerrain = nearestTerrainObjects [_candidate, [
        "TREE", "SMALL TREE", "BUSH", "ROCK", "ROCKS", 
        "BUILDING", "HOUSE", "FENCE", "WALL", 
        "POWER LINES", "POLE", "TRANSMISSION TOWER"
    ], 30];
    if (count _nearTerrain > 0) exitWith { false };

    private _nearObjs = nearestObjects [_candidate, [
        "House", "Building", "Strategic", "NonStrategic", 
        "Ruins", "Thing", "LandVehicle", "Air", "Ship", "AllVehicles"
    ], 30];
    if (count _nearObjs > 0) exitWith { false };

    private _crossesWater = false;
    for "_step" from 1 to 15 do {
        private _frac = _step / 15;
        private _sample = [
            (_candidate select 0) + (((_anchorCenter select 0) - (_candidate select 0)) * _frac),
            (_candidate select 1) + (((_anchorCenter select 1) - (_candidate select 1)) * _frac),
            0
        ];
        if (surfaceIsWater _sample) exitWith { _crossesWater = true; };
    };
    if (_crossesWater) exitWith { false };

    if (_candidate distance2D _anchorCenter < _minDistToAnchor) exitWith { false };

    private _tooCloseToSite = false;
    {
        private _mkr = _x select 0;
        private _sc = _x select 2;
        if (_candidate distance2D _sc < 600 || { _candidate inArea _mkr }) exitWith {
            _tooCloseToSite = true;
        };
    } forEach _allSitesInZone;
    if (_tooCloseToSite) exitWith { false };

    private _hasCleanVehSpot = false;
    {
        private _vTest = _candidate getPos [32, _x];
        if (
            !surfaceIsWater _vTest &&
            { ((surfaceNormal _vTest) select 2) >= 0.96 } &&
            { abs ((getTerrainHeightASL _vTest) - _centerH) <= 1.2 } &&
            { count (nearestTerrainObjects [_vTest, ["TREE", "SMALL TREE", "ROCK", "ROCKS", "BUILDING", "HOUSE", "WALL"], 8]) == 0 } &&
            { count (nearestObjects [_vTest, ["House", "Building", "Strategic", "Thing", "AllVehicles"], 8]) == 0 }
        ) exitWith {
            _hasCleanVehSpot = true;
        };
    } forEach [90, 180, 270, 0, 45, 135, 225, 315];
    if (!_hasCleanVehSpot) exitWith { false };

    true
};

private _fnc_findSafePosition = {
    params ["_anchorCenter", "_allSitesInZone", ["_minDist", 950], ["_maxDist", 1500], ["_attempts", 120]];

    private _safePos = [];
    for "_attempt" from 1 to _attempts do {
        private _distance = _minDist + random (_maxDist - _minDist);
        private _direction = random 360;
        private _candidate = [
            (_anchorCenter select 0) + (sin _direction * _distance),
            (_anchorCenter select 1) + (cos _direction * _distance),
            0
        ];

        if ([_candidate, _anchorCenter, _allSitesInZone, _minDist] call _fnc_validateLZ) exitWith {
            _safePos = _candidate;
        };
    };

    _safePos
};

private _fnc_isEnterableBuilding = {
    params ["_bld"];
    if (isNull _bld) exitWith { false };

    private _type = typeOf _bld;
    if (_type == "") exitWith { false };
    private _cfg = configFile >> "CfgVehicles" >> _type;
    if (!isClass _cfg) exitWith { false };

    private _numDoors = getNumber (_cfg >> "numberOfDoors");
    private _bPosList = _bld buildingPos -1;
    if (count _bPosList == 0) exitWith { false };

    if (_numDoors > 0) exitWith { true };

    private _hasOpenWay = false;
    {
        private _pASL = ATLToASL [_x select 0, _x select 1, (_x select 2) + 1.0];
        for "_deg" from 0 to 315 step 45 do {
            private _outASL = ATLToASL [
                (_x select 0) + (sin _deg * 7),
                (_x select 1) + (cos _deg * 7),
                (_x select 2) + 1.0
            ];
            if (!lineIntersects [_pASL, _outASL]) exitWith {
                _hasOpenWay = true;
            };
        };
        if (_hasOpenWay) exitWith {};
    } forEach _bPosList;

    _hasOpenWay
};

private _siteCandidates = [];
{
    private _parts = _x splitString "_";
    if (
        count _parts == 3 &&
        { (_parts select 0) == "marker" } &&
        { (_parts select 1) in ["A", "B", "C", "D", "E"] } &&
        { parseNumber (_parts select 2) > 0 } &&
        { (markerShape _x) in ["ELLIPSE", "RECTANGLE"] }
    ) then {
        private _marker = _x;
        private _center = getMarkerPos _marker;
        private _size = markerSize _marker;
        private _searchRadius = sqrt (((_size select 0) ^ 2) + ((_size select 1) ^ 2));
        private _buildings = nearestObjects [_center, ["House", "Building"], _searchRadius];
        private _spawnPositions = [];

        {
            private _building = _x;
            if ((getPosATL _building) inArea _marker && { [_building] call _fnc_isEnterableBuilding }) then {
                private _numDoors = getNumber (configFile >> "CfgVehicles" >> (typeOf _building) >> "numberOfDoors");
                for "_d" from 1 to _numDoors do {
                    _building setVariable [format ["bis_disabled_Door_%1", _d], 0, true];
                };

                {
                    private _position = +_x;
                    if (count _position == 2) then { _position pushBack 0; };
                    if (
                        count _position == 3 &&
                        { _position inArea _marker } &&
                        { !surfaceIsWater _position } &&
                        { (_spawnPositions findIf { _x distance2D _position < 4 }) == -1 }
                    ) then {
                        private _posASL = ATLToASL [_position select 0, _position select 1, (_position select 2) + 0.1];
                        private _headASL = [_posASL select 0, _posASL select 1, (_posASL select 2) + 1.7];
                        if (!lineIntersects [_posASL, _headASL]) then {
                            _spawnPositions pushBack _position;
                        };
                    };
                } forEach (_building buildingPos -1);
            };
        } forEach _buildings;

        if (count _spawnPositions >= 5) then {
            _siteCandidates pushBack [
                _marker,
                _parts select 1,
                _center,
                _spawnPositions
            ];
        };
    };
} forEach allMapMarkers;

if (count _siteCandidates < 2) exitWith {
    missionNamespace setVariable ["LL_g_startLZ", [], true];
    missionNamespace setVariable ["MISSION_intro_lz", [], true];
    false
};

private _validZones = [];
{
    private _z = _x;
    private _zSites = _siteCandidates select { (_x select 1) == _z };
    private _hasValidPair = false;
    for "_i" from 0 to (count _zSites - 1) do {
        for "_j" from (_i + 1) to (count _zSites - 1) do {
            if (((_zSites select _i select 2) distance2D (_zSites select _j select 2)) >= 600) exitWith {
                _hasValidPair = true;
            };
        };
        if (_hasValidPair) exitWith {};
    };
    if (_hasValidPair) then { _validZones pushBack _z; };
} forEach ["B", "C", "D", "E", "A"];

if (count _validZones == 0 && { count _siteCandidates >= 2 }) then {
    _validZones pushBack "ALL";
};

if (count _validZones == 0) exitWith {
    missionNamespace setVariable ["LL_g_startLZ", [], true];
    missionNamespace setVariable ["MISSION_intro_lz", [], true];
    false
};

private _candidateZones = [];
private _forcedZone = missionNamespace getVariable ["MISSION_var_zone", ""];
if (!(_forcedZone in ["A", "B", "C", "D", "E"])) then {
    _forcedZone = missionNamespace getVariable ["LL_g_forcedZone", ""];
};

if (_forcedZone in _validZones) then {
    _candidateZones pushBack _forcedZone;
};

private _explicitLZMarker = "MISSION_intro_lz";
if (_explicitLZMarker in allMapMarkers) then {
    private _lzMarkerPos = getMarkerPos _explicitLZMarker;
    {
        if (_lzMarkerPos inArea (_x select 0)) exitWith {
            if (!((_x select 1) in _candidateZones) && { (_x select 1) in _validZones }) then {
                _candidateZones pushBack (_x select 1);
            };
        };
    } forEach _siteCandidates;
};

private _lastZone = profileNamespace getVariable ["LL_hist_lastZone", ""];
private _lastSites = profileNamespace getVariable ["LL_hist_lastSites", []];

// Zone tirée au hasard ; la zone de la partie précédente passe en dernier choix pour éviter la répétition.
private _otherValid = (_validZones select { !(_x in _candidateZones) }) call BIS_fnc_arrayShuffle;
if (count _otherValid > 1 && { _lastZone in _otherValid }) then {
    _otherValid = (_otherValid - [_lastZone]) + [_lastZone];
};
_candidateZones append _otherValid;

private _chosenZone = "";
private _startLZ = [];
private _selectedSites = [];
private _tiers = [2000, 3000, 4500, 999999];

{
    private _zone = _x;
    private _zoneSites = if (_zone == "ALL") then { _siteCandidates } else { _siteCandidates select { (_x select 1) == _zone } };

    if (count _zoneSites >= 2) then {
        {
            private _tierMaxDist = _x;
            private _tierMaxSpan = _tierMaxDist * 1.35;

            {
                private _avoidHistory = _x;
                private _candSites = if (_avoidHistory) then {
                    _zoneSites select { !((_x select 0) in _lastSites) }
                } else {
                    _zoneSites
                };

                if (count _candSites >= 2 && { !_avoidHistory || { count _candSites < count _zoneSites } }) then {
                    private _desiredSiteCount = 2 + floor (random 2);
                    // Chaque site est équiprobable comme point de départ de la chaîne.
                    private _starts = _candSites call BIS_fnc_arrayShuffle;

                    {
                        private _s1 = _x;
                        private _chains = [];

                        if (_desiredSiteCount >= 3) then {
                            {
                                private _s2 = _x;
                                private _d12 = (_s1 select 2) distance2D (_s2 select 2);
                                if (!(_s2 isEqualTo _s1) && { _d12 >= 600 } && { _d12 <= _tierMaxDist }) then {
                                    {
                                        private _s3 = _x;
                                        private _d23 = (_s2 select 2) distance2D (_s3 select 2);
                                        private _d13 = (_s1 select 2) distance2D (_s3 select 2);
                                        if (
                                            !(_s3 isEqualTo _s1) && { !(_s3 isEqualTo _s2) } &&
                                            { _d23 >= 600 } && { _d23 <= _tierMaxDist } &&
                                            { _d13 >= 600 } && { _d13 <= _tierMaxSpan }
                                        ) then {
                                            _chains pushBack [_s1, _s2, _s3];
                                        };
                                    } forEach _candSites;
                                };
                            } forEach _candSites;
                        };

                        if (count _chains == 0) then {
                            {
                                private _d12 = (_s1 select 2) distance2D (_x select 2);
                                if (!(_x isEqualTo _s1) && { _d12 >= 600 } && { _d12 <= _tierMaxDist }) then {
                                    _chains pushBack [_s1, _x];
                                };
                            } forEach _candSites;
                        };

                        if (count _chains > 0) then {
                            _chains = _chains call BIS_fnc_arrayShuffle;

                            {
                                private _chain = _x;
                                private _s1Center = (_chain select 0) select 2;
                                private _candLZ = [_s1Center, _chain, 950, 1500, 120] call _fnc_findSafePosition;

                                if (count _candLZ < 3) then {
                                    _candLZ = [_s1Center, _chain, 800, 1800, 150] call _fnc_findSafePosition;
                                };
                                if (count _candLZ < 3) then {
                                    _candLZ = [_s1Center, _chain, 650, 2200, 180] call _fnc_findSafePosition;
                                };

                                if (count _candLZ == 3) exitWith {
                                    _startLZ = _candLZ;
                                    _selectedSites = _chain;
                                    _chosenZone = if (_zone == "ALL") then { (_chain select 0) select 1 } else { _zone };
                                };
                            } forEach (_chains select [0, 3]);
                        };

                        if (count _startLZ == 3 && { count _selectedSites >= 2 }) exitWith {};
                    } forEach _starts;
                };

                if (count _startLZ == 3 && { count _selectedSites >= 2 }) exitWith {};
            } forEach [true, false];

            if (count _startLZ == 3 && { count _selectedSites >= 2 }) exitWith {};
        } forEach _tiers;
    };

    if (count _startLZ == 3 && { count _selectedSites >= 2 }) exitWith {};
} forEach _candidateZones;

if (count _startLZ < 3 || { count _selectedSites < 2 }) exitWith {
    missionNamespace setVariable ["LL_g_startLZ", [], true];
    missionNamespace setVariable ["MISSION_intro_lz", [], true];
    false
};

profileNamespace setVariable ["LL_hist_lastZone", _chosenZone];
profileNamespace setVariable ["LL_hist_lastSites", (_selectedSites apply { _x select 0 }) + (_lastSites select [0, 4])];
saveProfileNamespace;

missionNamespace setVariable ["MISSION_var_zone", _chosenZone, true];
missionNamespace setVariable ["LL_g_startLZ", _startLZ, true];
missionNamespace setVariable ["MISSION_intro_lz", _startLZ, true];
publicVariable "MISSION_intro_lz";

private _createdObjects = [];
private _selectedMarkers = [];
{
    _x params ["_marker", "_family", "_center", "_spawnPositions"];
    _selectedMarkers pushBack _marker;

    {
        private _obj = _x;
        if ((getPosATL _obj) inArea _marker) then {
            deleteVehicle _obj;
        };
    } forEach (nearestObjects [_center, ["Logic", "Land_HelipadEmpty_F", "Helipad_Invisible_F", "HeliH", "HeliHEmpty", "HeliHSquare_F"], 400]);

    private _remainingPositions = +_spawnPositions;
    private _sitePrimaryPos = [];
    for "_i" from 1 to 8 do {
        if (count _remainingPositions == 0) exitWith {};
        private _position = _remainingPositions deleteAt (floor (random (count _remainingPositions)));
        if (_i == 1) then {
            _sitePrimaryPos = +_position;
        };
        private _logicGroup = createGroup sideLogic;
        private _logic = _logicGroup createUnit ["Logic", _position, [], 0, "CAN_COLLIDE"];
        if (!isNull _logic) then {
            _logic setPosATL _position;
            _logic setVariable ["LL_logic_occupied", false, true];
            _logic setVariable ["LL_dynamicSiteObject", true, true];
            _logic setVariable ["LL_dynamicSiteMarker", _marker, true];
            if (_i == 1) then {
                _logic setVariable ["LL_is_primary_point", true, true];
            };
            _createdObjects pushBack _logic;
        } else {
            deleteGroup _logicGroup;
        };
    };

    if (count _sitePrimaryPos == 3) then {
        missionNamespace setVariable [format ["LL_g_sitePrimaryPos_%1", _marker], _sitePrimaryPos, true];
    } else {
        missionNamespace setVariable [format ["LL_g_sitePrimaryPos_%1", _marker], _center, true];
    };
} forEach _selectedSites;

if (count _createdObjects == 0) exitWith {
    false
};

missionNamespace setVariable ["LL_g_operationSites", _selectedMarkers, true];
missionNamespace setVariable ["LL_g_operationSiteIndex", 0, true];
missionNamespace setVariable ["LL_g_dynamicSiteObjects", _createdObjects];
missionNamespace setVariable ["LL_g_dynamicSiteResults", [count _selectedMarkers, count _createdObjects, _chosenZone]];
missionNamespace setVariable ["LL_g_dynamicSitesPrepared", true];

true
