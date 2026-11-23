if (!isServer) exitWith {};

missionNamespace setVariable ["LL_Drone_Active", false, true];
missionNamespace setVariable ["LL_DRONE_pending", [], false];

while { true } do {
    sleep 0.5;

    private _pending = missionNamespace getVariable ["LL_DRONE_pending", []];
    if (count _pending > 0) then {
        _pending params ["_type", "_targetPos", "_caller"];
        missionNamespace setVariable ["LL_DRONE_pending", [], false];

        LL_Drone_Active = true;
        publicVariable "LL_Drone_Active";

        private _altitude = 350;
        private _orbitRadius = 400;
        private _scanRadius = 500;
        private _duration = 300;
        
        if (count _targetPos < 3) then { _targetPos resize 3; };
        { if (isNil "_targetPos") exitWith {}; if (isNil { _targetPos # _forEachIndex }) then { _targetPos set [_forEachIndex, 0]; }; } forEach _targetPos;

        private _spawnPos = [_targetPos select 0, (_targetPos select 1) - 3000, _altitude];

        private _drone = createVehicle ["B_UAV_02_dynamicLoadout_F", _spawnPos, [], 0, "FLY"];
        _drone setDir (_spawnPos getDir _targetPos);
        _drone setVelocityModelSpace [0, 80, 0];
        _drone flyInHeight _altitude;
        createVehicleCrew _drone;
        private _grp = group (driver _drone);

        _drone allowDamage false;
        _drone setCaptive true;

        _grp setCombatMode "BLUE";
        _grp setBehaviour "CARELESS";
        {
            _x allowDamage false;
            _x disableAI "SUPPRESSION";
        } forEach units _grp;

        _grp addEventHandler ["EnemyDetected", {
            params ["_grp", "_detected"];
            if (_detected isKindOf "Man") then {
                { _x forgetTarget _detected } forEach units _grp;
            };
        }];

        private _markerArea = createMarker ["LL_Drone_Area", _targetPos];
        _markerArea setMarkerShape "ELLIPSE";
        _markerArea setMarkerSize [_orbitRadius, _orbitRadius];
        _markerArea setMarkerColor "ColorBlue";
        _markerArea setMarkerAlpha 0.15;
        _markerArea setMarkerBrush "SolidBorder";

        private _markerIcon = createMarker ["LL_Drone_Icon", _targetPos];
        _markerIcon setMarkerType "b_air";
        _markerIcon setMarkerColor "ColorBlue";
        _markerIcon setMarkerSize [1.2, 1.2];
        _markerIcon setMarkerText "  MQ-12 Falcon";

        private _markerDroneName = format ["LL_Drone_Pos_%1", floor(random 1000)];
        private _markerDrone = createMarker [_markerDroneName, getPosATL _drone];
        _markerDrone setMarkerType "mil_triangle";
        _markerDrone setMarkerColor "ColorCIV";
        _markerDrone setMarkerSize [0.9, 0.9];

        private _msgSent = false;

        private _wp = _grp addWaypoint [_targetPos, 0];
        _wp setWaypointType "LOITER";
        _wp setWaypointLoiterRadius _orbitRadius;
        _wp setWaypointLoiterType "CIRCLE";
        _wp setWaypointSpeed "LIMITED";

        private _endTime = time + _duration;
        private _enemyMarkers = createHashMap;
        private _timeEnteredOrbit = -1;
        private _attackActivationTime = -1;
        private _hasFired = false;

        while { time < _endTime && alive _drone && !(missionNamespace getVariable ["LL_Drone_Jammed", false]) } do {
            _markerDrone setMarkerPos (getPosATL _drone);

            private _distToZone = _drone distance2D _targetPos;
            if (_distToZone <= (_orbitRadius + 500) && !_msgSent) then {
                ["STR_Drone_Approach"] call LL_fnc_radioMessage;
                _msgSent = true;
            };

            private _isOnStation = (_distToZone <= (_orbitRadius + 150));
            if (_isOnStation && _timeEnteredOrbit < 0) then {
                _timeEnteredOrbit = time;
                _attackActivationTime = _timeEnteredOrbit + 120 + (random 120);
            };

            private _enemies = [];
            if (_isOnStation) then {
                _enemies = (_targetPos nearEntities [["Car", "Tank", "Truck", "Helicopter", "Plane", "Ship", "Man"], _scanRadius]) select {
                    alive _x && { (_x distance2D _targetPos) <= _scanRadius } && { !(_x isKindOf "Animal") } && { (side group _x == east || side _x == east || _x in (missionNamespace getVariable ["LL_Task08_Targets", []])) }
                };
            };

            private _currentEnemyIds = [];

            {
                private _id = str (netId _x);
                _currentEnemyIds pushBack _id;
                private _mName = format ["LL_Drone_Enemy_%1", _id];

                if !(_id in keys _enemyMarkers) then {
                    createMarker [_mName, getPosATL _x];
                    _mName setMarkerType "mil_dot";
                    _mName setMarkerColor "ColorRed";
                    _mName setMarkerSize [0.8, 0.8];
                    _mName setMarkerText "";
                    _enemyMarkers set [_id, _mName];
                };

                _mName setMarkerPos (getPosATL _x);
                _mName setMarkerText "";
            } forEach _enemies;

            private _toRemove = [];
            {
                private _eid = _x;
                private _mkr = _y;
                if !(_eid in _currentEnemyIds) then {
                    deleteMarker _mkr;
                    _toRemove pushBack _eid;
                };
            } forEach _enemyMarkers;
            { _enemyMarkers deleteAt _x; } forEach _toRemove;

            {
                private _ltW = _x getVariable ["LL_LaserTargetW", objNull];
                if (!alive _x && !isNull _ltW) then {
                    deleteVehicle _ltW;
                    _x setVariable ["LL_LaserTargetW", objNull];
                };
                private _ltC = _x getVariable ["LL_LaserTargetC", objNull];
                if (!alive _x && !isNull _ltC) then {
                    deleteVehicle _ltC;
                    _x setVariable ["LL_LaserTargetC", objNull];
                };
            } forEach (missionNamespace getVariable ["LL_Task08_Targets", []]);

            if (_isOnStation && _timeEnteredOrbit > 0 && { time >= _attackActivationTime } && { !_hasFired }) then {
                private _dcaTargets = (missionNamespace getVariable ["LL_Task08_Targets", []]) select { alive _x && !isNull _x };
                if (count _dcaTargets == 0) then {
                    _dcaTargets = (_targetPos nearEntities [["Car", "Tank", "Truck", "AllVehicles"], _scanRadius]) select {
                        alive _x && { (_x getVariable ["LL_IsCartelDCA", false]) || typeOf _x in ["I_Truck_02_MRL_F", "O_APC_Tracked_02_AA_F"] }
                    };
                };

                if (count _dcaTargets > 0) then {
                    private _targetDCA = _dcaTargets select 0;

                    _grp setCombatMode "RED";
                    _grp setBehaviour "COMBAT";

                    _grp reveal [_targetDCA, 4];
                    west reportRemoteTarget [_targetDCA, 10];
                    independent reportRemoteTarget [_targetDCA, 10];
                    _targetDCA confirmSensorTarget [west, true];
                    _targetDCA confirmSensorTarget [independent, true];

                    (gunner _drone) doTarget _targetDCA;
                    (gunner _drone) doFire _targetDCA;

                    private _ltW = createVehicle ["LaserTargetW", getPosATL _targetDCA, [], 0, "CAN_COLLIDE"];
                    _ltW attachTo [_targetDCA, [0, 0, 1.2]];
                    _targetDCA setVariable ["LL_LaserTargetW", _ltW];

                    private _wpn = "";
                    {
                        private _lowerW = toLower _x;
                        if (["agm", _lowerW] call BIS_fnc_inString || ["hellfire", _lowerW] call BIS_fnc_inString || ["scalpel", _lowerW] call BIS_fnc_inString || ["lg", _lowerW] call BIS_fnc_inString || ["missile", _lowerW] call BIS_fnc_inString || ["bomb", _lowerW] call BIS_fnc_inString || ["gbu", _lowerW] call BIS_fnc_inString) exitWith {
                            _wpn = _x;
                        };
                    } forEach (_drone weaponsTurret [0]);

                    if (_wpn != "") then {
                        _drone selectWeaponTurret [_wpn, [0]];
                        (gunner _drone) fireAtTarget [_targetDCA, _wpn];
                    };

                    _hasFired = true;

                    _grp setCombatMode "BLUE";
                    _grp setBehaviour "CARELESS";

                    [_targetDCA, _ltW] spawn {
                        params ["_tgt", "_lt"];
                        sleep 8;
                        if (!isNull _lt) then { deleteVehicle _lt; };
                        if (!isNull _tgt) then {
                            _tgt setVariable ["LL_LaserTargetW", objNull];
                            _tgt setVariable ["LL_LaserTargetC", objNull];
                        };
                    };
                };
            };

            sleep 2;
        };

        ["STR_Drone_RTB"] call LL_fnc_radioMessage;

        {
            private _ltW = _x getVariable ["LL_LaserTargetW", objNull];
            if (!isNull _ltW) then {
                deleteVehicle _ltW;
                _x setVariable ["LL_LaserTargetW", objNull];
            };
            private _ltC = _x getVariable ["LL_LaserTargetC", objNull];
            if (!isNull _ltC) then {
                deleteVehicle _ltC;
                _x setVariable ["LL_LaserTargetC", objNull];
            };
        } forEach (missionNamespace getVariable ["LL_Task08_Targets", []]);

        { deleteMarker _y; } forEach _enemyMarkers;
        _enemyMarkers = createHashMap;
        deleteMarker _markerArea;
        deleteMarker _markerIcon;
        deleteMarker _markerDrone;

        if (alive _drone) then {
            _grp setBehaviour "CARELESS";
            _grp setCombatMode "BLUE";

            private _rtbPos = [
                (_targetPos select 0),
                (_targetPos select 1) - 3000,
                _altitude
            ];
            while { count (waypoints _grp) > 0 } do { deleteWaypoint [_grp, 0]; };
            private _wpRtb = _grp addWaypoint [_rtbPos, 0];
            _wpRtb setWaypointType "MOVE";
            _wpRtb setWaypointBehaviour "CARELESS";
            _wpRtb setWaypointCombatMode "BLUE";
            _wpRtb setWaypointSpeed "FULL";
            _drone doMove _rtbPos;

            private _timer = 0;
            waitUntil {
                sleep 5; _timer = _timer + 5;
                (!alive _drone) || (_drone distance2D _rtbPos < 100) || _timer > 120
            };

            { deleteVehicle _x; } forEach (crew _drone);
            deleteVehicle _drone;
        };

        deleteGroup _grp;

        sleep 10;
        LL_Drone_Active = false;
        publicVariable "LL_Drone_Active";
        ["STR_Drone_Available"] call LL_fnc_radioMessage;
    };
};
