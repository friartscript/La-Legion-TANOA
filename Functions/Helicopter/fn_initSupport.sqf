if (!hasInterface) exitWith {};

if (missionNamespace getVariable ["LL_support_monitor_started", false]) exitWith {};
missionNamespace setVariable ["LL_support_monitor_started", true];

[] spawn {
    waitUntil { sleep 0.5; !isNull player && { alive player } };

    private _fnc_clearMenu = {
        params ["_u"];
        private _existingIDs = _u getVariable ["LL_support_commIDs", []];
        {
            [_u, _x] call BIS_fnc_removeCommMenuItem;
        } forEach _existingIDs;
        _u setVariable ["LL_support_commIDs", []];
        _u setVariable ["BIS_fnc_addCommMenuItem_menu", []];
    };

    private _hasMenu = false;

    while {true} do {
        sleep 1.5;

        private _introDone = missionNamespace getVariable ["MISSION_intro_finished", false];
        private _u = player;
        private _isLeader = (!isNull _u) && { alive _u } && { (leader group _u) == _u };

        if (_introDone && _isLeader) then {
            if (!_hasMenu) then {
                [_u] call _fnc_clearMenu;
                private _newIDs = [];
                _newIDs pushBack ([_u, "Support_Ammo"] call BIS_fnc_addCommMenuItem);
                _newIDs pushBack ([_u, "Support_Vehicle"] call BIS_fnc_addCommMenuItem);
                _newIDs pushBack ([_u, "Support_Extract"] call BIS_fnc_addCommMenuItem);
                _newIDs pushBack ([_u, "Support_CAS"] call BIS_fnc_addCommMenuItem);
                _newIDs pushBack ([_u, "Support_Drone"] call BIS_fnc_addCommMenuItem);
                _u setVariable ["LL_support_commIDs", _newIDs];
                missionNamespace setVariable ["LL_group_leader", _u, true];
                _hasMenu = true;
            };
        } else {
            if (_hasMenu) then {
                [_u] call _fnc_clearMenu;
                _hasMenu = false;
            };
        };
    };
};
