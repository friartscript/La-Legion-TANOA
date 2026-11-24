if (!isServer) exitWith { false };
if (missionNamespace getVariable ["LL_g_operationStartRequested", false]) exitWith { false };

missionNamespace setVariable ["LL_g_operationStartRequested", true, true];
missionNamespace setVariable ["LL_g_operationStartFailed", false, true];
missionNamespace setVariable ["LL_g_operationStarted", false, true];
missionNamespace setVariable ["MISSION_intro_finished", false, true];

[] spawn {
    waitUntil {
        sleep 0.5;
        time > 0 && { count (allPlayers select { alive _x }) > 0 }
    };

    private _sitesReady = [] call LL_fnc_prepareMissionSites;
    if (!_sitesReady) exitWith {
        missionNamespace setVariable ["LL_g_operationStartFailed", true, true];
    };

    private _planReady = [] call LL_fnc_selectOperation;
    if (!_planReady) exitWith {
        missionNamespace setVariable ["LL_g_operationStartFailed", true, true];
    };

    private _plan = missionNamespace getVariable ["LL_g_operationPlan", []];
    private _startLZ = missionNamespace getVariable ["LL_g_startLZ", []];
    if (count _plan == 0 || { count _startLZ < 3 }) exitWith {
        missionNamespace setVariable ["LL_g_operationStartFailed", true, true];
    };

    private _firstStep = _plan select 0;
    _firstStep params ["_firstTask", "_firstMarker"];

    private _primaryTargetPos = missionNamespace getVariable [format ["LL_g_sitePrimaryPos_%1", _firstMarker], getMarkerPos _firstMarker];
    missionNamespace setVariable ["MISSION_var_targetPos", _primaryTargetPos, true];

    private _allMarkers = allMapMarkers select { (_x select [0, 7]) == "marker_" };
    {
        if (_x == _firstMarker) then {
            _x setMarkerAlpha 1;
        } else {
            _x setMarkerAlpha 0;
        };
    } forEach _allMarkers;

    private _vehClass = missionNamespace getVariable ["MISSION_var_selected_vehicle_class", "OFrP_P4_FR_CE"];

    [_firstMarker, _startLZ, _vehClass] remoteExec ["LL_fnc_intro_A", 0];

    [_startLZ, 400, 15, _primaryTargetPos] spawn LL_fnc_ambientCivilians;
    [_primaryTargetPos, 400, 30, _startLZ] spawn LL_fnc_ambientCivilians;

    [_startLZ] spawn LL_fnc_ambientAnimal;
    [_primaryTargetPos] spawn LL_fnc_ambientAnimal;

    private _rebelAmbushEnabled = missionNamespace getVariable ["LL_g_rebelAmbushEnabled", false];
    if (_rebelAmbushEnabled) then {
        [_startLZ, _primaryTargetPos] spawn LL_fnc_rebelAmbush;
    };

    missionNamespace setVariable ["LL_g_civKilledByPlayers", false, true];
    addMissionEventHandler ["EntityKilled", {
        params ["_killed", "_killer", "_instigator"];
        if (isNull _instigator) then { _instigator = _killer; };
        if (!isNull _killed && { _killed isKindOf "CAManBase" && side group _killed == civilian && !(_killed getVariable ["LL_isEnemy", false]) }) then {
            if (!isNull _instigator && { side group _instigator in [west, independent] || _instigator in (allPlayers + switchableUnits) }) then {
                missionNamespace setVariable ["LL_g_civKilledByPlayers", true, true];
            };
        };
    }];

    missionNamespace setVariable ["LL_g_operationStarted", true, true];

    waitUntil { sleep 1; missionNamespace getVariable ["MISSION_intro_finished", false] };

    for "_stepIdx" from 0 to (count _plan - 1) do {
        private _step = _plan select _stepIdx;
        _step params ["_taskToken", "_markerName"];

        missionNamespace setVariable ["LL_g_operationSiteIndex", _stepIdx, true];
        _markerName setMarkerAlpha 1;
        private _stepPos = missionNamespace getVariable [format ["LL_g_sitePrimaryPos_%1", _markerName], getMarkerPos _markerName];
        missionNamespace setVariable ["MISSION_var_targetPos", _stepPos, true];

        private _moveId = if (_stepIdx == 0) then { "task_mandatory_move" } else { format ["task_mandatory_move_%1", _stepIdx] };
        private _moveTitle = if (_stepIdx == 0) then {
            localize "STR_LL_Task_Man1_Title"
        } else {
            format ["%1 (%2/%3)", localize "STR_LL_Task_Man1_Title", _stepIdx + 1, count _plan]
        };

        if (_stepIdx > 0) then {
            [_stepPos, 400, 25, getPosATL player] spawn LL_fnc_ambientCivilians;
            [_stepPos] spawn LL_fnc_ambientAnimal;
        };

        sleep 5;

        [
            [group player, west, independent],
            [_moveId],
            [
                localize "STR_LL_Task_Man1_Desc",
                _moveTitle,
                localize "STR_LL_Task_Man1_Marker"
            ],
            _stepPos,
            "ASSIGNED",
            10,
            true,
            "move",
            false
        ] call BIS_fnc_taskCreate;

        [_moveId, true] remoteExec ["BIS_fnc_taskSetCurrent", 0, true];
        [_moveId, true] call BIS_fnc_taskSetCurrent;
        call LL_fnc_saveProgress;

        waitUntil {
            sleep 2;
            ({ alive _x && (_x distance2D _stepPos) < 800 } count (allPlayers + switchableUnits + [player])) > 0
        };

        [_stepPos] spawn LL_fnc_secureOpforLanguage;
        [_moveId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
        call LL_fnc_saveProgress;
        sleep 3;

        missionNamespace setVariable ["LL_g_taskInProgress", true, true];
        switch (_taskToken) do {
            case "TASK_CAPTIVE": { [_markerName] spawn LL_fnc_taskD_captive; };
            case "TASK_HVT": { [_markerName] spawn LL_fnc_taskD_hvt; };
            case "TASK_TRANSMISSION": { [_markerName] spawn LL_fnc_taskD_transmission; };
            case "TASK_CHEMICAL": { [_markerName] spawn LL_fnc_taskD_chemical; };
            case "TASK_DOCUMENTS": { [_markerName] spawn LL_fnc_taskD_documents; };
            case "TASK_TIGRIS": { [_markerName] spawn LL_fnc_taskD_tigris; };
        };

        waitUntil {
            sleep 2;
            !(missionNamespace getVariable ["LL_g_taskInProgress", false])
        };

        call LL_fnc_saveProgress;
        sleep 4;
    };

    missionNamespace setVariable ["LL_g_operationSiteIndex", count _plan, true];
    sleep 3;
    [] spawn LL_fnc_extraction;
};

true

