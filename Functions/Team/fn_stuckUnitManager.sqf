if (!hasInterface) exitWith {};
if (missionNamespace getVariable ["LL_g_stuckManagerRunning", false]) exitWith {};
missionNamespace setVariable ["LL_g_stuckManagerRunning", true];

[] spawn {
    private _lastTrackedLeader = objNull;
    private _activeActions = [];

    while { true } do {
        sleep 3;

        private _leader = player;
        if (isNull _leader || { !alive _leader }) then {
            if (count _activeActions > 0) then {
                {
                    _x params ["_u", "_actId"];
                    if (!isNull _lastTrackedLeader && { _actId != -1 }) then {
                        _lastTrackedLeader removeAction _actId;
                    };
                    if (!isNull _u) then {
                        _u setVariable ["LL_stuck_active", false];
                        _u setVariable ["LL_stuck_actionId", -1];
                    };
                } forEach _activeActions;
                _activeActions = [];
            };
        } else {
            if (_leader != _lastTrackedLeader && { !isNull _lastTrackedLeader }) then {
                {
                    _x params ["_u", "_actId"];
                    if (_actId != -1) then {
                        _lastTrackedLeader removeAction _actId;
                    };
                    if (!isNull _u) then {
                        _u setVariable ["LL_stuck_active", false];
                        _u setVariable ["LL_stuck_actionId", -1];
                    };
                } forEach _activeActions;
                _activeActions = [];
            };
            _lastTrackedLeader = _leader;

            private _isActualLeader = (leader group _leader == _leader);
            if (!_isActualLeader) then {
                if (count _activeActions > 0) then {
                    {
                        _x params ["_u", "_actId"];
                        if (_actId != -1) then {
                            _leader removeAction _actId;
                        };
                        if (!isNull _u) then {
                            _u setVariable ["LL_stuck_active", false];
                            _u setVariable ["LL_stuck_actionId", -1];
                        };
                    } forEach _activeActions;
                    _activeActions = [];
                };
            } else {
                private _subordinates = (units group _leader) select { alive _x && _x != _leader && !(isPlayer _x) };

                {
                    private _u = _x;
                    private _inVeh = (vehicle _u != _u);
                    private _savedPos = _u getVariable ["LL_stuck_savedPos", []];
                    private _stuckSince = _u getVariable ["LL_stuck_since", -1];
                    private _isStuck = _u getVariable ["LL_stuck_active", false];
                    private _actId = _u getVariable ["LL_stuck_actionId", -1];
                    private _curPos = getPosATL _u;
                    private _distToLeader = _u distance2D _leader;

                    if (_inVeh || { _savedPos isEqualTo [] }) then {
                        _u setVariable ["LL_stuck_savedPos", _curPos];
                        _u setVariable ["LL_stuck_since", time];
                        if (_isStuck) then {
                            _leader removeAction _actId;
                            _u setVariable ["LL_stuck_active", false];
                            _u setVariable ["LL_stuck_actionId", -1];
                            _activeActions = _activeActions select { (_x select 0) != _u };
                        };
                    } else {
                        private _distMoved = _curPos distance2D _savedPos;
                        if (_distMoved > 2.5) then {
                            _u setVariable ["LL_stuck_savedPos", _curPos];
                            _u setVariable ["LL_stuck_since", time];
                            if (_isStuck) then {
                                _leader removeAction _actId;
                                _u setVariable ["LL_stuck_active", false];
                                _u setVariable ["LL_stuck_actionId", -1];
                                _activeActions = _activeActions select { (_x select 0) != _u };
                            };
                        } else {
                            if (_distToLeader <= 10) then {
                                _u setVariable ["LL_stuck_savedPos", _curPos];
                                _u setVariable ["LL_stuck_since", time];
                                if (_isStuck) then {
                                    _leader removeAction _actId;
                                    _u setVariable ["LL_stuck_active", false];
                                    _u setVariable ["LL_stuck_actionId", -1];
                                    _activeActions = _activeActions select { (_x select 0) != _u };
                                };
                            } else {
                                private _elapsed = time - _stuckSince;
                                if (_elapsed >= 90 && { !_isStuck }) then {
                                    _u setVariable ["LL_stuck_active", true];

                                    private _actionTitle = format ["<t color='#00DFFF'>%1 (%2)</t>", localize "STR_LL_Action_TeleportStuck", name _u];
                                    private _newActId = _leader addAction [
                                        _actionTitle,
                                        {
                                            params ["_target", "_caller", "_actionId", "_arguments"];
                                            _arguments params ["_unitToTeleport"];

                                            if (!isNull _unitToTeleport && { alive _unitToTeleport }) then {
                                                private _teleportPos = [];
                                                for "_att" from 1 to 16 do {
                                                    private _tDir = (getDir _caller) + 120 + random 120;
                                                    private _tDist = 2.5 + random 2.5;
                                                    private _candidate = _caller getPos [_tDist, _tDir];
                                                    if (!surfaceIsWater _candidate) exitWith {
                                                        _candidate set [2, (getPosATL _caller) select 2];
                                                        _teleportPos = _candidate;
                                                    };
                                                };
                                                if (_teleportPos isEqualTo []) then {
                                                    _teleportPos = (getPosATL _caller) vectorAdd [1.5, -1.5, 0];
                                                };

                                                _unitToTeleport setPosATL _teleportPos;
                                                _unitToTeleport setVelocity [0, 0, 0];
                                                _unitToTeleport switchMove "";
                                                _unitToTeleport playMoveNow "AmovPknlMstpSrasWrflDnon";
                                                _unitToTeleport doFollow _caller;

                                                systemChat format [localize "STR_LL_Stuck_Teleported", name _unitToTeleport];
                                            };

                                            _caller removeAction _actionId;
                                            if (!isNull _unitToTeleport) then {
                                                _unitToTeleport setVariable ["LL_stuck_active", false];
                                                _unitToTeleport setVariable ["LL_stuck_actionId", -1];
                                                _unitToTeleport setVariable ["LL_stuck_since", time];
                                                _unitToTeleport setVariable ["LL_stuck_savedPos", getPosATL _unitToTeleport];
                                            };
                                        },
                                        [_u],
                                        6.5,
                                        false,
                                        true,
                                        "",
                                        "alive _target && { leader group _target == _target }"
                                    ];

                                    _u setVariable ["LL_stuck_actionId", _newActId];
                                    _activeActions pushBack [_u, _newActId];
                                };
                            };
                        };
                    };
                } forEach _subordinates;

                private _activeUnits = _activeActions apply { _x select 0 };
                {
                    private _deadOrGone = _x;
                    if (!(_deadOrGone in _subordinates)) then {
                        private _found = _activeActions select { (_x select 0) == _deadOrGone };
                        if (count _found > 0) then {
                            private _entry = _found select 0;
                            _leader removeAction (_entry select 1);
                            _activeActions = _activeActions - [_entry];
                        };
                    };
                } forEach _activeUnits;
            };
        };
    };
};