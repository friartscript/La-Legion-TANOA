params [
    ["_deadUnit", objNull, [objNull]]
];

if (isMultiplayer) exitWith {};

if (!isNull _deadUnit) then {
    private _deadMenu = _deadUnit getVariable ["BIS_fnc_addCommMenuItem_menu", []];
    {
        if (_x isEqualType [] && {count _x > 0}) then {
            [_deadUnit, _x select 0] call BIS_fnc_removeCommMenuItem;
        };
    } forEach +_deadMenu;
    _deadUnit setVariable ["BIS_fnc_addCommMenuItem_menu", []];
    _deadUnit setVariable ["LL_support_commIDs", []];
    _deadUnit setVariable ["LL_support_initialized", nil];
};

private _grp = group _deadUnit;
private _livingUnits = if (!isNull _grp) then {
    (units _grp) select { alive _x && _x != _deadUnit }
} else {
    private _all = (playableUnits + switchableUnits);
    for "_i" from 0 to 6 do {
        private _u = missionNamespace getVariable [format ["player_%1", _i], objNull];
        if (!isNull _u) then { _all pushBackUnique _u; };
    };
    _all select { alive _x && _x != _deadUnit }
};

if (count _livingUnits > 0) then {
    private _targetAI = selectRandom _livingUnits;
    
    _targetAI addScore (score _deadUnit);
    
    selectPlayer _targetAI;
    private _group = group _targetAI;
    _group selectLeader _targetAI;
    
    titleCut ["", "BLACK FADED", 999];
    if (!isNil "LL_fnc_clearScreenEffects") then {
        [_targetAI] call LL_fnc_clearScreenEffects;
    };
    
    [_targetAI, _group] spawn {
        params ["_targetAI", "_group"];
        sleep 1.2;
        if (!isNil "LL_fnc_clearScreenEffects") then {
            [_targetAI] call LL_fnc_clearScreenEffects;
        };
        sleep 0.3;
        _group selectLeader _targetAI;
        titleCut ["", "BLACK IN", 2];
        if (!isNil "LL_fnc_clearScreenEffects") then {
            [_targetAI] call LL_fnc_clearScreenEffects;
        };
        [_targetAI] call LL_fnc_addRoeActions;
        [_targetAI] call LL_fnc_initSupport;

        private _allCandidateTasks = [
            "task_extraction",
            "task_chemical_1", "task_chemical_2", "task_chemical",
            "task_d_transmission_radio_0", "task_d_transmission_radio_1", "task_d_transmission",
            "task_d_documents",
            "task_d_hvt",
            "task_d_captive",
            "task_tigris_vehicles", "task_tigris",
            "task_mandatory_move_3",
            "task_mandatory_move_2",
            "task_mandatory_move_1",
            "task_mandatory_move"
        ];
        
        private _activeTask = "";
        {
            if ([_x] call BIS_fnc_taskExists) then {
                private _st = [_x] call BIS_fnc_taskState;
                if (_st in ["CREATED", "ASSIGNED", "AUTOASSIGNED"]) exitWith {
                    _activeTask = _x;
                };
            };
        } forEach _allCandidateTasks;
        
        if (_activeTask != "") then {
            [_activeTask, true] call BIS_fnc_taskSetCurrent;
        };
    };
} else {
    [_deadUnit] spawn {
        params ["_deadUnit"];
        
        private _cam = "camera" camCreate (getPosATL _deadUnit);
        _cam camSetTarget _deadUnit;
        _cam cameraEffect ["internal", "BACK"];
        _cam camSetRelPos [0, -5, 3];
        _cam camCommit 0;
        
        titleCut ["", "BLACK OUT", 4];
        sleep 4;
        
        failMission "LOSER";
    };
};
