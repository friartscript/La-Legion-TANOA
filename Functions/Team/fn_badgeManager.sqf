

params [
    ["_unit", objNull, [objNull]]
];

if (isNull _unit) exitWith {};

[_unit, ""] call BIS_fnc_setUnitInsignia;
[_unit, "OFrP_TFLafayette_01"] call BIS_fnc_setUnitInsignia;
