if (!isServer) exitWith { false };

private _sites = missionNamespace getVariable ["LL_g_operationSites", []];
if (count _sites < 2 || { count _sites > 3 }) exitWith {
    missionNamespace setVariable ["LL_g_operationPlan", [], true];
    false
};

private _availableTasks = [
    "TASK_DOCUMENTS",
    "TASK_TRANSMISSION",
    "TASK_CHEMICAL",
    "TASK_HVT",
    "TASK_TIGRIS",
    "TASK_CAPTIVE"
];

private _siteCount = count _sites;
private _shuffledTasks = _availableTasks call BIS_fnc_arrayShuffle;
private _chosenTasks = _shuffledTasks select [0, _siteCount];

if ("TASK_CAPTIVE" in _chosenTasks) then {
    _chosenTasks = _chosenTasks - ["TASK_CAPTIVE"];
    _chosenTasks pushBack "TASK_CAPTIVE";
};

private _operationPlan = [];
for "_i" from 0 to (_siteCount - 1) do {
    _operationPlan pushBack [_chosenTasks select _i, _sites select _i];
};

missionNamespace setVariable ["LL_g_operationPlan", _operationPlan, true];
missionNamespace setVariable ["LL_g_operationSiteIndex", 0, true];

true
