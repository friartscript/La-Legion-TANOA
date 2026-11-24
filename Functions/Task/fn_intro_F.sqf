params ["_ctx"];
_ctx params ["_cam", "_heli", "_destPos", "_startPos", "_allUnits", "_t0", "_helipad", "_ppColor", "_ppGrain", "_lzASL", "_ppBlurIntro", "_inboundDir", "_heliHeading"];

call LL_fnc_camReset;

if (isServer && {!isNull (driver _heli)}) then { (driver _heli) action ["LandGearUp", _heli]; };

private _camGround6 = [_destPos, 22, 34, _lzASL, 1.4] call LL_fnc_findOpenCamSpot;
if (_camGround6 isEqualTo []) then {
    private _fallback = _destPos getPos [26, (_inboundDir + 210) % 360];
    _camGround6 = [_fallback select 0, _fallback select 1, (getTerrainHeightASL _fallback) + 1.4];
};

_cam camSetPos (ASLToAGL _camGround6);
_cam camSetTarget _destPos;
_cam camSetFov 0.52;
_cam camCommit 0;
waitUntil { camCommitted _cam };

missionNamespace setVariable ["LL_p6_t0", _t0 + 51.77];
missionNamespace setVariable ["LL_p6_baseASL", _camGround6];

private _ehPlan6 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _baseASL = missionNamespace getVariable ["LL_p6_baseASL", [0,0,0]];
    private _start = missionNamespace getVariable ["LL_p6_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 9.56) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _destPos = missionNamespace getVariable ["MISSION_intro_lz", [0,0,0]];
    private _inboundDir = missionNamespace getVariable ["LL_intro_inboundDir", 0];
    private _heliHeading = missionNamespace getVariable ["LL_intro_heliHeading", 180];

    private _curDist = 110 * (1 - _smooth);
    private _curH = 40 - (_smooth * 20);
    private _hPos = _destPos getPos [_curDist, _inboundDir];
    _hPos set [2, _curH];

    _heli setPosATL _hPos;
    _heli setDir _heliHeading;
    _heli setVelocity [sin _heliHeading * (14 * (1 - _smooth)), cos _heliHeading * (14 * (1 - _smooth)), -1.8 * (1 - _smooth)];

    private _wantASL = [
        (_baseASL select 0) + (_smooth * 1.5),
        (_baseASL select 1) - (_smooth * 1.2),
        (_baseASL select 2) - (_smooth * 0.3)
    ];
    private _tgtASL = getPosASLVisual _heli vectorAdd [0, 0, 0.2];
    private _fov = 0.52 - (_smooth * 0.05);

    [_cam, _wantASL, _tgtASL, _fov, [_heli], 0.015] call LL_fnc_camApply;
}];

waitUntil { (diag_tickTime - _t0) >= 61.33 };
removeMissionEventHandler ["EachFrame", _ehPlan6];

call LL_fnc_camReset;

[_ctx] spawn LL_fnc_intro_G;