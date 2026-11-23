params [["_fallbackPos", [0, 0, 0], [[]]]];

private _playerPositions = [];
{
    if (alive _x) then {
        _playerPositions pushBack (getPosATL _x);
    };
} forEach allPlayers;

if (count _playerPositions == 0 && { count _fallbackPos >= 2 } && { !(_fallbackPos isEqualTo [0, 0, 0]) }) then {
    private _fallback = [_fallbackPos select 0, _fallbackPos select 1, 0];
    if (count _fallbackPos > 2) then { _fallback set [2, _fallbackPos select 2]; };
    _playerPositions pushBack _fallback;
};

if (count _playerPositions == 0) exitWith { [] };

private _center = [0, 0, 0];
{
    _center set [0, (_center select 0) + (_x select 0)];
    _center set [1, (_center select 1) + (_x select 1)];
} forEach _playerPositions;
_center set [0, (_center select 0) / count _playerPositions];
_center set [1, (_center select 1) / count _playerPositions];

private _searchCenters = [_center];
_searchCenters append _playerPositions;

private _bestPosition = [];
private _bestScore = 1000000000000;
{
    private _searchCenter = _x;
    for "_attempt" from 1 to 25 do {
        private _distance = 40 + random 800;
        private _direction = random 360;
        private _candidate = [
            (_searchCenter select 0) + (sin _direction * _distance),
            (_searchCenter select 1) + (cos _direction * _distance),
            0
        ];

        private _nearWater = false;
        {
            if (surfaceIsWater (_candidate getPos [45, _x])) exitWith { _nearWater = true; };
        } forEach [0, 45, 90, 135, 180, 225, 270, 315];

        private _overheadBlocked = false;
        if (!_nearWater) then {
            {
                private _pt = _candidate getPos [_x select 0, _x select 1];
                private _ptASL = ATLToASL _pt;
                private _topASL = [_ptASL select 0, _ptASL select 1, (_ptASL select 2) + 35];
                if (lineIntersects [_ptASL, _topASL]) exitWith { _overheadBlocked = true; };
            } forEach [[0, 0], [12, 0], [12, 90], [12, 180], [12, 270]];
        };

        private _crossesWater = false;
        if (!_nearWater && !_overheadBlocked) then {
            for "_step" from 1 to 12 do {
                private _frac = _step / 12;
                private _sample = [
                    (_candidate select 0) + (((_searchCenter select 0) - (_candidate select 0)) * _frac),
                    (_candidate select 1) + (((_searchCenter select 1) - (_candidate select 1)) * _frac),
                    0
                ];
                if (surfaceIsWater _sample) exitWith { _crossesWater = true; };
            };
        };

        if (
            !surfaceIsWater _candidate &&
            !_nearWater &&
            !_overheadBlocked &&
            !_crossesWater &&
            { ((surfaceNormal _candidate) select 2) >= 0.97 } &&
            { count (nearestObjects [_candidate, ["House", "Building", "Strategic", "NonStrategic", "Ruins", "Thing", "LandVehicle", "Air", "Ship", "AllVehicles"], 28]) == 0 } &&
            { count (nearestTerrainObjects [_candidate, ["TREE", "SMALL TREE", "BUSH", "ROCK", "ROCKS", "BUILDING", "HOUSE", "FENCE", "WALL", "POWER LINES", "POLE", "TRANSMISSION TOWER"], 28]) == 0 }
        ) then {
            private _score = 0;
            {
                _score = _score + (_x distance2D _candidate);
            } forEach _playerPositions;

            if (_score < _bestScore) then {
                _bestPosition = _candidate;
                _bestScore = _score;
            };
        };
    };
} forEach _searchCenters;

_bestPosition
