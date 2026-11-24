params ["_ctx"];
_ctx params ["_cam", "_heli", "_destPos", "_startPos", "_allUnits", "_t0", "_helipad", "_ppColor", "_ppGrain", "_lzASL", "_ppBlurIntro", "_inboundDir", "_heliHeading"];

call LL_fnc_camReset;

_heli flyInHeight 45;
_heli limitSpeed 105;

missionNamespace setVariable ["LL_p4_t0", _t0 + 30.03];

private _ehPlan4 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _start = missionNamespace getVariable ["LL_p4_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 9.39) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _hASL = getPosASLVisual _heli;
    private _hDir = getDirVisual _heli;
    private _angle = _hDir - 50 - (_smooth * 15);
    private _dist = 42 - (_smooth * 6);
    private _wantASL = [
        (_hASL select 0) + (sin _angle * _dist),
        (_hASL select 1) + (cos _angle * _dist),
        (_hASL select 2) + 8 - (_smooth * 3)
    ];
    private _tgtASL = getPosASLVisual _heli vectorAdd [0, 0, 0.3];
    private _fov = 0.60 + (_smooth * 0.04);

    [_cam, _wantASL, _tgtASL, _fov, [_heli], 0.02] call LL_fnc_camApply;
}];

[] spawn {
    sleep 0.8;
    [
        format [
            "<t align='center'>" +
            "<t size='1.25' color='#FFFFFF' font='PuristaMedium'>%1</t><br/>" +
            "<t size='0.85' color='#94A3B8' font='PuristaLight'>ARCHIPEL DU PACIFIQUE SUD // ZONE HOSTILE</t><br/>" +
            "<t size='0.55'><t color='#1E88E5'>━━━━ </t><t color='#FFFFFF'>━━━━ </t><t color='#E53935'>━━━━</t></t>" +
            "</t>",
            toUpper (localize "STR_LL_Intro_Theatre")
        ],
        -1, 0.18, 6.2, 0.8, 0, 790
    ] spawn BIS_fnc_dynamicText;
};

waitUntil { (diag_tickTime - _t0) >= 39.42 };
removeMissionEventHandler ["EachFrame", _ehPlan4];

call LL_fnc_camReset;

[_ctx] spawn LL_fnc_intro_E;