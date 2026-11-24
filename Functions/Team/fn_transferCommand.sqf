if (!isMultiplayer || !hasInterface) exitWith {};

params [["_unit", player, [objNull]]];

if (isNull _unit) exitWith {};
if (_unit getVariable ["LL_transferActionAdded", false]) exitWith {};
_unit setVariable ["LL_transferActionAdded", true];

LL_fnc_clearTransferSubActions = {
    params [["_target", player]];
    private _acts = _target getVariable ["LL_transferSubActions", []];
    {
        _target removeAction _x;
    } forEach _acts;
    _target setVariable ["LL_transferSubActions", []];
    _target setVariable ["LL_transferMenuOpen", false];
};

if (isNil "LL_fnc_applyCommandTransfer") then {
    LL_fnc_applyCommandTransfer = {
        params [["_newLeader", objNull], ["_oldLeader", objNull]];
        if (isNull _newLeader || { !alive _newLeader }) exitWith {};

        private _grp = group _newLeader;
        _grp selectLeader _newLeader;
        [_grp, _newLeader] remoteExecCall ["selectLeader", 0];

        _newLeader setUnitRank "SERGEANT";
        if (!isNull _oldLeader) then {
            _oldLeader setUnitRank "CORPORAL";
        };
        missionNamespace setVariable ["LL_group_leader", _newLeader, true];

        private _oldName = if (!isNull _oldLeader) then { name _oldLeader } else { name (leader _grp) };
        private _notice = format [localize "STR_LL_TransferCommand_Notification", _oldName, name _newLeader];
        [_notice] remoteExecCall ["systemChat", 0];

        ["STR_LL_Leader_Designated"] remoteExec ["LL_fnc_radioMessage", _newLeader];
    };
};

private _cond = "alive _target && { leader group _target == _target } && { count (allPlayers select { alive _x && _x != _target && side group _x in [west, independent] }) > 0 }";

_unit addAction [
    format ["<t color='#FFFF00'>%1</t>", localize "STR_LL_TransferCommand_Action"],
    {
        params ["_target", "_caller", "_actionId"];

        if (_target getVariable ["LL_transferMenuOpen", false]) exitWith {
            [_target] call LL_fnc_clearTransferSubActions;
        };

        [_target] call LL_fnc_clearTransferSubActions;
        _target setVariable ["LL_transferMenuOpen", true];

        private _candidates = allPlayers select {
            alive _x && { _x != _target } && { side group _x in [west, independent] }
        };

        if (count _candidates == 0) exitWith {
            _target setVariable ["LL_transferMenuOpen", false];
        };

        private _subActs = [];
        {
            private _cand = _x;
            private _candName = name _cand;
            private _title = format [localize "STR_LL_TransferCommand_To", _candName];

            private _act = _target addAction [
                format ["<t color='#FFFF00'>   ➔ %1</t>", _title],
                {
                    params ["_tgt", "_clr", "_id", "_args"];
                    _args params ["_chosen"];
                    [_tgt] call LL_fnc_clearTransferSubActions;
                    [_chosen, _tgt] remoteExecCall ["LL_fnc_applyCommandTransfer", 2];
                },
                [_cand],
                7.39 - (_forEachIndex * 0.01),
                false,
                true,
                "",
                "alive _target && { leader group _target == _target }"
            ];
            _subActs pushBack _act;
        } forEach _candidates;

        private _cancelAct = _target addAction [
            format ["<t color='#FF4444'>   ✖ %1</t>", localize "STR_LL_TransferCommand_Cancel"],
            {
                params ["_tgt"];
                [_tgt] call LL_fnc_clearTransferSubActions;
            },
            nil,
            7.25,
            false,
            true,
            "",
            "true"
        ];
        _subActs pushBack _cancelAct;

        _target setVariable ["LL_transferSubActions", _subActs];

        [_target] spawn {
            params ["_tgt"];
            sleep 20;
            if (!isNull _tgt && { _tgt getVariable ["LL_transferMenuOpen", false] }) then {
                [_tgt] call LL_fnc_clearTransferSubActions;
            };
        };
    },
    nil,
    7.4,
    false,
    true,
    "",
    _cond
];
