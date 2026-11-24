LL_fnc_safeCamPos = {
    params ["_wantASL", "_tgtASL", ["_ignore", []], ["_minH", 1.5]];

    private _ig1 = if (count _ignore > 0) then { _ignore select 0 } else { objNull };
    private _ig2 = if (count _ignore > 1) then { _ignore select 1 } else { objNull };
    private _pos = +_wantASL;

    private _floorZ = ((getTerrainHeightASL _pos) max 0) + _minH;
    if ((_pos select 2) < _floorZ) then { _pos set [2, _floorZ]; };

    private _down = lineIntersectsSurfaces [
        _pos vectorAdd [0, 0, 0.6], _pos vectorAdd [0, 0, -_minH],
        _ig1, _ig2, true, 1, "GEOM", "NONE"
    ];
    if (count _down > 0) then {
        private _hitZ = (((_down select 0) select 0) select 2);
        _pos set [2, _hitZ + _minH];
    };

    private _tgtTop = _tgtASL vectorAdd [0, 0, 0.5];
    private _fnBlocked = {
        (terrainIntersectASL [_tgtTop, _this]) ||
        { count lineIntersectsSurfaces [_tgtTop, _this, _ig1, _ig2, true, 1, "VIEW", "NONE"] > 0 }
    };

    if (_pos call _fnBlocked) then {
        private _hit = lineIntersectsSurfaces [_tgtTop, _pos, _ig1, _ig2, true, 1, "VIEW", "NONE"];
        private _dir = _tgtTop vectorFromTo _pos;
        private _dist = _tgtTop vectorDistance _pos;
        if (count _hit > 0) then {
            _dist = (_tgtTop vectorDistance ((_hit select 0) select 0)) - 1.5;
        };
        if (_dist >= 6) then {
            _pos = _tgtTop vectorAdd (_dir vectorMultiply _dist);
        } else {
            for "_i" from 1 to 6 do {
                if !(_pos call _fnBlocked) exitWith {};
                _pos = _pos vectorAdd [0, 0, 4];
            };
        };
    };

    _pos
};

LL_fnc_camReset = {
    missionNamespace setVariable ["LL_cam_lastOff", [0, 0, 0]];
    missionNamespace setVariable ["LL_cam_lastT", diag_tickTime];
};

LL_fnc_camApply = {
    params ["_cam", "_wantASL", "_tgtASL", "_fov", ["_ignore", []], ["_shake", 0.03], ["_rate", 6]];

    private _now = diag_tickTime;
    private _lastT = missionNamespace getVariable ["LL_cam_lastT", _now];
    private _dt = ((_now - _lastT) max 0) min 0.1;
    missionNamespace setVariable ["LL_cam_lastT", _now];

    private _safe = [_wantASL, _tgtASL, _ignore] call LL_fnc_safeCamPos;

    private _off = _safe vectorDiff _wantASL;
    private _lastOff = missionNamespace getVariable ["LL_cam_lastOff", [0, 0, 0]];
    if ((vectorMagnitude _off) < (vectorMagnitude _lastOff)) then {
        _off = _lastOff vectorAdd ((_off vectorDiff _lastOff) vectorMultiply (1 - exp (-_rate * _dt)));
    };
    missionNamespace setVariable ["LL_cam_lastOff", _off];

    private _pos = _wantASL vectorAdd _off;

    private _floorZ = ((getTerrainHeightASL _pos) max 0) + 1.2;
    if ((_pos select 2) < _floorZ) then { _pos set [2, _floorZ]; };

    if (_shake > 0) then {
        _pos = _pos vectorAdd [
            (sin (_now * 47) + 0.5 * sin (_now * 113)) * _shake,
            (cos (_now * 53) + 0.5 * sin (_now * 97)) * _shake,
            (sin (_now * 61) + 0.5 * cos (_now * 131)) * _shake * 0.7
        ];
    };

    _cam camSetPos (ASLToAGL _pos);
    _cam camSetTarget (ASLToAGL _tgtASL);
    _cam camSetFov _fov;
    _cam camCommit 0;
};

LL_fnc_findOpenCamSpot = {
    params ["_center", "_rMin", "_rMax", "_lookAtASL", ["_h", 1.2]];

    private _best = [];
    private _bestScore = -1e6;
    private _types = ["TREE", "SMALL TREE", "BUSH", "ROCK", "ROCKS", "BUILDING", "HOUSE", "WALL", "FENCE"];

    for "_i" from 1 to 40 do {
        private _p = _center getPos [_rMin + random (_rMax - _rMin), random 360];
        if (!surfaceIsWater _p) then {
            private _asl = [_p select 0, _p select 1, (getTerrainHeightASL _p) + _h];
            private _obst = count nearestTerrainObjects [_p, _types, 6, false, true];
            private _flat = (surfaceNormal _p) select 2;
            private _los = !(terrainIntersectASL [_asl, _lookAtASL]) &&
                            { count lineIntersectsSurfaces [_asl, _lookAtASL, objNull, objNull, true, 1, "VIEW", "NONE"] == 0 };
            private _score = (if (_los) then { 100 } else { 0 }) - (_obst * 10) + (_flat * 20);
            if (_score > _bestScore) then { _bestScore = _score; _best = _asl; };
        };
    };
    _best
};

LL_fnc_pickApproachDir = {
    params ["_dest", "_cruiseASL", ["_dist", 1500]];

    private _good = [];
    private _bestDir = random 360;
    private _bestClear = -1e6;

    for "_k" from 0 to 11 do {
        private _dir = _k * 30;
        private _clear = 1e6;
        for "_d" from 100 to _dist step 100 do {
            _clear = _clear min (_cruiseASL - (getTerrainHeightASL (_dest getPos [_d, _dir])));
        };
        if (_clear >= 60) then { _good pushBack _dir; };
        if (_clear > _bestClear) then { _bestClear = _clear; _bestDir = _dir; };
    };

    if (count _good > 0) then { (selectRandom _good) + (random 20) - 10 } else { _bestDir }
};

LL_fnc_whip = {
    params ["_pp", ["_amount", 5], ["_time", 0.35]];
    _pp ppEffectAdjust [_amount];
    _pp ppEffectCommit 0;
    _pp ppEffectAdjust [0];
    _pp ppEffectCommit _time;
};

true;
