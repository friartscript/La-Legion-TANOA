params [["_mode", "init", [""]]];

if (!isServer) exitWith {};

if (_mode == "init") exitWith {
    missionNamespace setVariable ["LL_g_taskInProgress", false, true];
    missionNamespace setVariable ["LL_g_operationSiteIndex", 0, true];
};

if (_mode == "REQUEST") exitWith {
    if (missionNamespace getVariable ["LL_g_taskInProgress", false]) exitWith {};

    private _plan = missionNamespace getVariable ["LL_g_operationPlan", []];
    private _siteIndex = missionNamespace getVariable ["LL_g_operationSiteIndex", 0];

    if (_siteIndex >= count _plan) exitWith {};

    private _operationStep = _plan select _siteIndex;
    _operationStep params ["_selectedTask", "_selectedMarker"];
    private _fnc = missionNamespace getVariable ["LL_fnc_" + _selectedTask, {}];

    if (_fnc isEqualTo {}) exitWith {};

    missionNamespace setVariable ["LL_g_operationSiteIndex", _siteIndex + 1, true];
    missionNamespace setVariable ["LL_g_taskInProgress", true, true];

    [_selectedTask, _selectedMarker, _fnc] spawn {
        params ["_selectedTask", "_selectedMarker", "_fnc"];

        _selectedMarker setMarkerAlpha 1;
        [_selectedMarker] spawn _fnc;

        waitUntil {
            sleep 2;
            !(missionNamespace getVariable ["LL_g_taskInProgress", false])
        };

        private _plan = missionNamespace getVariable ["LL_g_operationPlan", []];
        private _nextIndex = missionNamespace getVariable ["LL_g_operationSiteIndex", 0];
        if (_nextIndex < count _plan) then {
            ["REQUEST"] call LL_fnc_taskManager;
        } else {
            [] spawn LL_fnc_extraction;
        };
    };
};
