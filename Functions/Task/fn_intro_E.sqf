params ["_ctx"];
_ctx params ["_cam", "_heli", "_destPos", "_startPos", "_allUnits", "_t0", "_helipad", "_ppColor", "_ppGrain", "_lzASL", "_ppBlurIntro", "_inboundDir", "_heliHeading"];

call LL_fnc_camReset;

if (isServer && {!isNull (driver _heli)}) then { (driver _heli) action ["LandGearUp", _heli]; };

private _camGround5 = [_destPos, 50, 70, _lzASL, 2.0] call LL_fnc_findOpenCamSpot;
if (_camGround5 isEqualTo []) then {
    private _fallback = _destPos getPos [55, (_inboundDir + 150) % 360];
    _camGround5 = [_fallback select 0, _fallback select 1, (getTerrainHeightASL _fallback) + 2.0];
};

_cam camSetPos (ASLToAGL _camGround5);
_cam camSetTarget _destPos;
_cam camSetFov 0.38;
_cam camCommit 0;
waitUntil { camCommitted _cam };

missionNamespace setVariable ["LL_p5_t0", _t0 + 39.42];
missionNamespace setVariable ["LL_p5_baseASL", _camGround5];

private _ehPlan5 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _baseASL = missionNamespace getVariable ["LL_p5_baseASL", [0,0,0]];
    private _start = missionNamespace getVariable ["LL_p5_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 12.35) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _destPos = missionNamespace getVariable ["MISSION_intro_lz", [0,0,0]];
    private _inboundDir = missionNamespace getVariable ["LL_intro_inboundDir", 0];
    private _heliHeading = missionNamespace getVariable ["LL_intro_heliHeading", 180];

    private _curDist = 320 - (_smooth * 210);
    private _curH = 52 - (_smooth * 12);
    private _hPos = _destPos getPos [_curDist, _inboundDir];
    _hPos set [2, _curH];

    _heli setPosATL _hPos;
    _heli setDir _heliHeading;
    _heli setVelocity [sin _heliHeading * (22 - _smooth * 8), cos _heliHeading * (22 - _smooth * 8), -0.9];

    private _wantASL = +_baseASL;
    _wantASL set [2, (_wantASL select 2) + (_smooth * 0.8)];
    private _tgtASL = getPosASLVisual _heli;
    private _fov = 0.38 - (_smooth * 0.06);

    [_cam, _wantASL, _tgtASL, _fov, [_heli], 0.015] call LL_fnc_camApply;
}];

[] spawn {
    sleep 1.0;
    [
        format [
            "<t align='center'>" +
            "<t size='0.95' color='#94A3B8' font='PuristaLight'>%1</t><br/>" +
            "<t size='0.55'><t color='#1E88E5'>■ </t><t color='#FFFFFF'>■ </t><t color='#E53935'>■</t></t>" +
            "</t>",
            localize "STR_LL_Intro_CreatedBy"
        ],
        -1, 0.76, 6.5, 0.8, 0, 790
    ] spawn BIS_fnc_dynamicText;
};

waitUntil { (diag_tickTime - _t0) >= 51.77 };
removeMissionEventHandler ["EachFrame", _ehPlan5];

call LL_fnc_camReset;

[_ctx] spawn LL_fnc_intro_F;