params [["_unit", player, [objNull]]];

if (!hasInterface) exitWith {};
if (isNull _unit || {!alive _unit}) exitWith {};
if (_unit != player) exitWith {};

if (_unit getVariable ["LL_support_initialized", false]) exitWith {};
_unit setVariable ["LL_support_initialized", true];

private _menu = _unit getVariable ["BIS_fnc_addCommMenuItem_menu", []];
{
    if (_x isEqualType [] && {count _x > 0}) then {
        [_unit, _x select 0] call BIS_fnc_removeCommMenuItem;
    };
} forEach +_menu;

private _existingIDs = _unit getVariable ["LL_support_commIDs", []];
{
    [_unit, _x] call BIS_fnc_removeCommMenuItem;
} forEach _existingIDs;

_unit setVariable ["BIS_fnc_addCommMenuItem_menu", []];

private _newIDs = [];

_newIDs pushBack ([_unit, "Support_Ammo"] call BIS_fnc_addCommMenuItem);
_newIDs pushBack ([_unit, "Support_Vehicle"] call BIS_fnc_addCommMenuItem);
_newIDs pushBack ([_unit, "Support_Extract"] call BIS_fnc_addCommMenuItem);
_newIDs pushBack ([_unit, "Support_CAS"] call BIS_fnc_addCommMenuItem);
_newIDs pushBack ([_unit, "Support_Drone"] call BIS_fnc_addCommMenuItem);

_unit setVariable ["LL_support_commIDs", _newIDs];
