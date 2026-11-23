if (isMultiplayer) exitWith {};

if (missionNamespace getVariable ["LL_g_extractionActive", false]) exitWith {};
if (["task_extraction"] call BIS_fnc_taskExists) exitWith {};

if (missionNamespace getVariable ["LL_save_queueActive", false]) exitWith {};
missionNamespace setVariable ["LL_save_queueActive", true];

[] spawn {
    sleep 35;

    private _waited = 0;
    while { _waited < 25 && (!alive player || { lifeState player == "INCAPACITATED" }) } do {
        sleep 1;
        _waited = _waited + 1;
    };

    if (alive player && { lifeState player != "INCAPACITATED" } && { !(missionNamespace getVariable ["LL_g_extractionActive", false]) } && { !(["task_extraction"] call BIS_fnc_taskExists) }) then {
        saveGame;
        systemChat (localize "STR_LL_Progress_Saved");
    };

    sleep 15;
    missionNamespace setVariable ["LL_save_queueActive", false];
};