if (!isMultiplayer) exitWith {};

LL_fnc_evaluateGroupLeader = {
    if (!isServer) exitWith {};

    private _livingHumanPlayers = allPlayers select {
        alive _x && { side group _x in [west, independent] }
    };

    if (count _livingHumanPlayers == 0) exitWith {};

    private _playerGroup = grpNull;
    {
        private _grp = group _x;
        if (!isNull _grp) exitWith { _playerGroup = _grp; };
    } forEach _livingHumanPlayers;

    if (isNull _playerGroup) exitWith {};

    private _curLeader = leader _playerGroup;
    private _leaderValid = (!isNull _curLeader) &&
                           { alive _curLeader } &&
                           { isPlayer _curLeader } &&
                           { _curLeader in allPlayers };

    if (!_leaderValid) then {
        private _newLeader = objNull;
        private _slCandidate = missionNamespace getVariable ["player_0", objNull];

        if (!isNull _slCandidate && { _slCandidate in _livingHumanPlayers }) then {
            _newLeader = _slCandidate;
        } else {
            _newLeader = _livingHumanPlayers select 0;
        };

        if (!isNull _newLeader) then {
            _playerGroup selectLeader _newLeader;
            [_playerGroup, _newLeader] remoteExecCall ["selectLeader", 0];

            _newLeader setUnitRank "SERGEANT";
            {
                if (_x != _newLeader) then {
                    _x setUnitRank "CORPORAL";
                };
            } forEach _livingHumanPlayers;

            missionNamespace setVariable ["LL_group_leader", _newLeader, true];

            private _notice = format [localize "STR_LL_TransferCommand_AutoNotice", name _newLeader];
            [_notice] remoteExecCall ["systemChat", 0];

            ["STR_LL_Leader_Designated"] remoteExec ["LL_fnc_radioMessage", _newLeader];
        };
    };
};

if (isServer) then {
    if (missionNamespace getVariable ["LL_g_leaderMonitorRunning", false]) exitWith {};
    missionNamespace setVariable ["LL_g_leaderMonitorRunning", true];

    [] spawn {
        while { true } do {
            sleep 5;
            call LL_fnc_evaluateGroupLeader;
        };
    };
};
