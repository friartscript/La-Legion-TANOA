params [
    ["_locMarker", "", [""]],
    ["_insertion", "", [""]],
    ["_tasks", [], [[]]]
];

if (!isServer) exitWith {};

[_locMarker] spawn {
    params ["_locMarker"];
    waitUntil { sleep 1; missionNamespace getVariable ["MISSION_intro_finished", false] };
    sleep 5;
    [_locMarker] spawn LL_fnc_taskC;
};

[_locMarker, _tasks] spawn {
    params ["_locMarker", "_tasks"];
    waitUntil { sleep 1; missionNamespace getVariable ["MISSION_intro_finished", false] };
    sleep 15;
    [_locMarker, _tasks] spawn LL_fnc_taskA;
};
