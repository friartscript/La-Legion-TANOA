private _lastSave = missionNamespace getVariable ["LL_lastSaveTime", -999];
if (time - _lastSave < 3) exitWith {};
missionNamespace setVariable ["LL_lastSaveTime", time];

if (!isMultiplayer) then {
    saveGame;
    systemChat (localize "STR_LL_Progress_Saved");
};
