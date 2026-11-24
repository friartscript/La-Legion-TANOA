params ["_ctx"];
_ctx params ["_cam", "_heli", "_destPos", "_startPos", "_allUnits", "_t0", "_helipad", "_ppColor", "_ppGrain", "_lzASL", "_ppBlurIntro", "_inboundDir", "_heliHeading"];

call LL_fnc_camReset;

if (isServer) then {
    [_heli] spawn {
        params ["_h"];
        for "_i" from 1 to 6 do {
            if (!isNull _h && {!isNull (driver _h)}) then {
                (driver _h) action ["LandGear", _h];
            };
            sleep 0.5;
        };
    };
};

private _camGround7 = [_destPos, 16, 24, _lzASL, 1.5] call LL_fnc_findOpenCamSpot;
if (_camGround7 isEqualTo []) then {
    private _fallback = _destPos getPos [18, (_inboundDir + 120) % 360];
    _camGround7 = [_fallback select 0, _fallback select 1, (getTerrainHeightASL _fallback) + 1.5];
};

_cam camSetPos (ASLToAGL _camGround7);
_cam camSetTarget _destPos;
_cam camSetFov 0.48;
_cam camCommit 0;
waitUntil { camCommitted _cam };

missionNamespace setVariable ["LL_p7_t0", _t0 + 61.33];
missionNamespace setVariable ["LL_p7_baseASL", _camGround7];

private _ehPlan7 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _baseASL = missionNamespace getVariable ["LL_p7_baseASL", [0,0,0]];
    private _start = missionNamespace getVariable ["LL_p7_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 10.23) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _destPos = missionNamespace getVariable ["MISSION_intro_lz", [0,0,0]];
    private _heliHeading = missionNamespace getVariable ["LL_intro_heliHeading", 180];

    if (_elapsed < 7.2) then {
        private _descentProg = (_elapsed / 7.2) min 1;
        private _descentSmooth = _descentProg * _descentProg * (3 - 2 * _descentProg);
        private _curH = (20.0 * (1 - _descentSmooth)) max 0;
        private _hPos = +_destPos;
        _hPos set [2, _curH];
        _heli setPosATL _hPos;
        _heli setDir _heliHeading;
        _heli setVelocity [0, 0, -2.6 * (1 - _descentSmooth)];
    } else {
        private _gPos = +_destPos;
        _gPos set [2, 0];
        _heli setPosATL _gPos;
        _heli setVectorUp surfaceNormal _gPos;
        _heli setVelocity [0, 0, 0];
    };

    private _wantASL = [
        (_baseASL select 0) - (_smooth * 1.2),
        (_baseASL select 1) - (_smooth * 0.8),
        (_baseASL select 2) + (_smooth * 0.2)
    ];
    private _tgtASL = getPosASLVisual _heli vectorAdd [0, 0, 0.1];
    private _fov = 0.48 + (_smooth * 0.04);

    [_cam, _wantASL, _tgtASL, _fov, [_heli], 0.015] call LL_fnc_camApply;
}];

waitUntil { (diag_tickTime - _t0) >= 71.56 };
removeMissionEventHandler ["EachFrame", _ehPlan7];

call LL_fnc_camReset;

[_ctx] spawn LL_fnc_intro_H;