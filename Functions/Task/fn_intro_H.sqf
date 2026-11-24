params ["_ctx"];
_ctx params ["_cam", "_heli", "_destPos", "_startPos", "_allUnits", "_t0", "_helipad", "_ppColor", "_ppGrain", "_lzASL", "_ppBlurIntro", "_inboundDir", "_heliHeading"];

call LL_fnc_camReset;

private _teamRef = if (!isNil "vehicule_team" && {!isNull vehicule_team}) then { getPosATL vehicule_team } else { _destPos };

if (isServer) then {
    private _groundPos = +_destPos;
    _groundPos set [2, 0];
    _heli setPosATL _groundPos;
    _heli setVectorUp surfaceNormal _groundPos;
    _heli setVelocity [0, 0, 0];

    {
        unassignVehicle _x;
        moveOut _x;
    } forEach _allUnits;

    private _allSquad = [];
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

    [_heli] spawn {
        params ["_h"];
        sleep 2;
        if (!isNull _h && {!isNull (driver _h)}) then {
            (driver _h) action ["LandGearUp", _h];
        };
    };

    [_heli, _destPos] spawn {
        params ["_h", "_dp"];
        waitUntil { sleep 2; (_h distance2D _dp) > 3000 || !alive _h };
        { deleteVehicle _x; } forEach (crew _h);
        deleteVehicle _h;
    };
};

if (hasInterface) then {
    private _lookASL = AGLToASL [_teamRef select 0, _teamRef select 1, (_teamRef select 2) + 1.0];
    private _camGround8 = [_teamRef, 11, 16, _lookASL, 1.6] call LL_fnc_findOpenCamSpot;
    if (_camGround8 isEqualTo []) then {
        private _fallback = _teamRef getPos [13, 220];
        _camGround8 = [_fallback select 0, _fallback select 1, (getTerrainHeightASL _fallback) + 1.6];
    };

    _cam camSetPos (ASLToAGL _camGround8);
    _cam camSetTarget _teamRef;
    _cam camSetFov 0.50;
    _cam camCommit 0;
    waitUntil { camCommitted _cam };

    missionNamespace setVariable ["LL_p8_t0", _t0 + 71.56];
    missionNamespace setVariable ["LL_p8_baseASL", _camGround8];

    private _ehPlan8 = addMissionEventHandler ["EachFrame", {
        private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
        if (isNull _cam) exitWith {};

        private _teamPos = missionNamespace getVariable ["MISSION_intro_lz", [0,0,0]];
        if (!isNil "vehicule_team" && {!isNull vehicule_team}) then { _teamPos = getPosATL vehicule_team; };

        private _start = missionNamespace getVariable ["LL_p8_t0", diag_tickTime];
        private _prog = ((diag_tickTime - _start) / 8.72) min 1;
        private _smooth = _prog * _prog * (3 - 2 * _prog);

        private _angle = 220 + (_smooth * 75);
        private _dist = 14 - (_smooth * 2.5);
        private _wantPos = [
            (_teamPos select 0) + (sin _angle * _dist),
            (_teamPos select 1) + (cos _angle * _dist),
            (_teamPos select 2) + 1.4 + (_smooth * 0.4)
        ];
        private _wantASL = AGLToASL _wantPos;
        private _tgtASL = AGLToASL [_teamPos select 0, _teamPos select 1, (_teamPos select 2) + 1.1];
        private _fov = 0.50 - (_smooth * 0.05);

        [_cam, _wantASL, _tgtASL, _fov, [], 0.015] call LL_fnc_camApply;
    }];

    waitUntil { (diag_tickTime - _t0) >= 80.28 };
    cutText ["", "BLACK OUT", 0.4];

    waitUntil { (diag_tickTime - _t0) >= 80.68 };
    removeMissionEventHandler ["EachFrame", _ehPlan8];

    _cam cameraEffect ["TERMINATE", "BACK"];
    camDestroy _cam;
    camUseNVG false;
    ppEffectDestroy _ppColor;
    ppEffectDestroy _ppGrain;
    if (!isNil "_ppBlurIntro") then { ppEffectDestroy _ppBlurIntro; };

    player switchCamera "INTERNAL";
    showCinemaBorder false;

    if (sunOrMoon < 0.2) then {
        if (currentVisionMode player != 1) then {
            player action ["NVGoggles", player];
        };
    } else {
        if (currentVisionMode player == 1) then {
            player action ["nvGogglesOff", player];
        };
    };

    cutText ["", "BLACK IN", 1.2];
    2 fadeSound 1;

    waitUntil { (diag_tickTime - _t0) >= 90.72 };

    [
        format [
            "<t size='1.0' color='#bbbbbb' font='PuristaLight' align='center'>%1</t>",
            localize "STR_LL_Intro_MissionStartSubtitle"
        ],
        -1, -1, 5, 1, 0, 793
    ] spawn BIS_fnc_dynamicText;
};

if (isServer) then {
    if (!isNull _helipad) then {
        deleteVehicle _helipad;
    };

    private _allSquad = [];
    if (!isNil "player_0" && {!isNull player_0}) then { _allSquad pushBackUnique player_0; };
    for "_i" from 0 to 6 do {
        private _u = missionNamespace getVariable [format ["player_%1", _i], objNull];
        if (!isNull _u) then { _allSquad pushBackUnique _u; };
    };
    { _allSquad pushBackUnique _x; } forEach (playableUnits + switchableUnits);
    _allSquad = _allSquad select { !isNull _x && { alive _x } };

    private _slUnit = missionNamespace getVariable ["player_0", objNull];
    if (isNull _slUnit) then {
        {
            if (typeOf _x find "_SL_" != -1 || { rank _x == "SERGEANT" }) exitWith {
                _slUnit = _x;
            };
        } forEach _allSquad;
        if (isNull _slUnit && { count _allSquad > 0 }) then {
            _slUnit = _allSquad select 0;
        };
        if (!isNull _slUnit) then {
            player_0 = _slUnit;
            _slUnit setVehicleVarName "player_0";
            missionNamespace setVariable ["player_0", _slUnit, true];
        };
    };

    private _chosenLeader = missionNamespace getVariable ["LL_group_leader", objNull];
    if (isNull _chosenLeader || { !alive _chosenLeader }) then {
        if (!isNull _slUnit && { isPlayer _slUnit }) then {
            _chosenLeader = _slUnit;
        } else {
            private _humanPlayers = allPlayers select { alive _x && { side group _x in [west, independent] } };
            if (count _humanPlayers > 0) then {
                _chosenLeader = selectRandom _humanPlayers;
            } else {
                _chosenLeader = _slUnit;
            };
        };
        if (isNull _chosenLeader && { count _allSquad > 0 }) then {
            _chosenLeader = _allSquad select 0;
        };
        missionNamespace setVariable ["LL_group_leader", _chosenLeader, true];
    };

    if (!isNull _chosenLeader) then {
        private _grp = group _chosenLeader;
        {
            if (group _x != _grp) then {
                [_x] joinSilent _grp;
            };
        } forEach _allSquad;

        _grp selectLeader _chosenLeader;
        [_grp, _chosenLeader] remoteExecCall ["selectLeader", 0];

        {
            if (_x == _chosenLeader) then {
                _x setUnitRank "SERGEANT";
            } else {
                if (_forEachIndex in [1, 2]) then {
                    _x setUnitRank "CORPORAL";
                } else {
                    _x setUnitRank "PRIVATE";
                };
            };
        } forEach _allSquad;
    };

    {
        _x setDamage 0;
        _x allowDamage true;
        _x setCaptive false;
        _x enableAI "ALL";
        _x enableFatigue false;
        _x enableStamina false;
        _x setCustomAimCoef 0.1;
    } forEach _allSquad;

    if (!isNil "vehicule_team" && {!isNull vehicule_team}) then {
        vehicule_team setDamage 0;
        vehicule_team allowDamage true;
    };

    waitUntil { (diag_tickTime - _t0) >= 90.72 };

    missionNamespace setVariable ["MISSION_intro_finished", true, true];
};
