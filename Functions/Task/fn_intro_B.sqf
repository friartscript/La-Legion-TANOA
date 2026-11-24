params ["_ctx"];
_ctx params ["_cam", "_heli", "_destPos", "_startPos", "_allUnits", "_t0", "_helipad", "_ppColor", "_ppGrain", "_lzASL", "_ppBlurIntro", "_inboundDir", "_heliHeading"];

call LL_fnc_camReset;

missionNamespace setVariable ["LL_cam_obj", _cam];
missionNamespace setVariable ["LL_cam_target", _heli];
missionNamespace setVariable ["LL_p2_t0", _t0 + 10.11];

private _ehPlan2 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _start = missionNamespace getVariable ["LL_p2_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 9.37) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _hASL = getPosASLVisual _heli;
    private _hDir = getDirVisual _heli;
    private _angle = _hDir - 30 + (_smooth * 25);
    private _dist = 22 + (_smooth * 6);
    private _wantASL = [
        (_hASL select 0) + (sin _angle * _dist),
        (_hASL select 1) + (cos _angle * _dist),
        (_hASL select 2) + 2 - (_smooth * 4)
    ];
    private _tgtASL = getPosASLVisual _heli vectorAdd [0, 0, 0.5];
    private _fov = 0.65 - (_smooth * 0.08);

    [_cam, _wantASL, _tgtASL, _fov, [_heli], 0.02] call LL_fnc_camApply;
}];

[] spawn {
    sleep 0.5;
    [
        "<t align='center'>" +
        "<t size='1.25' font='PuristaMedium' color='#4FC3F7'>M I S S I O N</t><br/>" +
        "<t size='1.75' font='PuristaBold' color='#FFFFFF'>L É G I O N</t><br/>" +
        "<t size='1.55' font='PuristaBold' color='#EF4444'>É T R A N G È R E</t><br/>" +
        "<t size='0.55'><t color='#1E88E5'>━━━━━━ </t><t color='#FFFFFF'>━━━━━━ </t><t color='#E53935'>━━━━━━</t></t>" +
        "</t>",
        -1, 0.16, 6.8, 0.8, 0, 790
    ] spawn BIS_fnc_dynamicText;
};

waitUntil { (diag_tickTime - _t0) >= 19.48 };
removeMissionEventHandler ["EachFrame", _ehPlan2];

call LL_fnc_camReset;

[_ctx] spawn LL_fnc_intro_C;