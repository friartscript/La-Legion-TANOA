params [["_u", objNull, [objNull]]];

if (isNull _u || { !alive _u }) exitWith {};
if (side _u == civilian) exitWith {};
if (_u getVariable ["not_Random", false]) exitWith {};
if (captive _u) exitWith {};

if (!local _u) exitWith {
    [_u] remoteExecCall ["LL_fnc_ensureUnitNVG", _u];
};

private _nvgClass = "NVGoggles_tna_F";
if (!isClass (configFile >> "CfgWeapons" >> _nvgClass)) then { _nvgClass = "NVGogglesB_blk_F"; };
if (!isClass (configFile >> "CfgWeapons" >> _nvgClass)) then { _nvgClass = "NVGoggles"; };

if (hmd _u == "") then {
    _u linkItem _nvgClass;
    if (hmd _u == "") then {
        _u addItem _nvgClass;
        _u assignItem _nvgClass;
    };
};
