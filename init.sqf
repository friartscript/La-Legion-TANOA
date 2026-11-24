if (hasInterface) then {
    cutText ["", "BLACK FADED", 999];
    0 fadeSound 0;
    0 fadeMusic 0;
};
[] spawn {
    private _patchFnc = {
        CBA_fnc_encodeJSON = {
            params [["_object", "null"]];
            if (isNil "_object") exitWith { "null" };
            switch (typeName _object) do {
                case "BOOL": { if (_object) then { "true" } else { "false" } };
                case "SCALAR": { str _object };
                case "STRING": {
                    private _chars = toArray _object;
                    private _out = [];
                    {
                        switch (_x) do {
                            case 34: { _out append [92, 34]; };
                            case 92: { _out append [92, 92]; };
                            case 8:  { _out append [92, 98]; };
                            case 12: { _out append [92, 102]; };
                            case 10: { _out append [92, 110]; };
                            case 13: { _out append [92, 114]; };
                            case 9:  { _out append [92, 116]; };
                            default  { _out pushBack _x; };
                        };
                    } forEach _chars;
                    str (toString _out)
                };
                case "ARRAY": {
                    if (_object isEqualTo []) exitWith { "[]" };
                    private _elements = [];
                    for "_i" from 0 to (count _object - 1) do {
                        if (isNil { _object select _i }) then {
                            _elements pushBack "null";
                        } else {
                            _elements pushBack ([_object select _i] call CBA_fnc_encodeJSON);
                        };
                    };
                    "[" + (_elements joinString ",") + "]"
                };
                case "LOCATION";
                case "SIDE";
                case "GROUP";
                case "OBJECT": {
                    if (isNull _object) then { "null" } else { str (str _object) };
                };
                default { str (str _object) };
            };
        };

        if (!isNil "BettIR_Patches_fnc_onLoadoutUpdated" && { isNil "LL_patched_BettIR_Patches" }) then {
            LL_patched_BettIR_Patches = true;
            LL_orig_BettIR_Patches_onLoadout = BettIR_Patches_fnc_onLoadoutUpdated;
            BettIR_Patches_fnc_onLoadoutUpdated = {
                params [["_cbaLoadout", []]];
                if (!(_cbaLoadout isEqualType []) || { count _cbaLoadout < 10 }) then {
                    _cbaLoadout = [[],[],[],[],[],[],"","",[],["","","","","",""]];
                };
                [_cbaLoadout] call LL_orig_BettIR_Patches_onLoadout;
            };
        };
        if (!isNil "BettIR_fnc_onLoadoutUpdated" && { isNil "LL_patched_BettIR" }) then {
            LL_patched_BettIR = true;
            LL_orig_BettIR_onLoadout = BettIR_fnc_onLoadoutUpdated;
            BettIR_fnc_onLoadoutUpdated = {
                params [["_cbaLoadout", []]];
                if (!(_cbaLoadout isEqualType []) || { count _cbaLoadout < 10 }) then {
                    _cbaLoadout = [[],[],[],[],[],[],"","",[],["","","","","",""]];
                };
                [_cbaLoadout] call LL_orig_BettIR_onLoadout;
            };
        };
        if (!isNil "CBA_fnc_localEvent" && { isNil "LL_patched_CBA_localEvent" }) then {
            LL_patched_CBA_localEvent = true;
            LL_orig_CBA_localEvent = CBA_fnc_localEvent;
            CBA_fnc_localEvent = {
                params ["_event", ["_args", []]];
                if (_event == "cba_events_loadoutUpdated" && { _args isEqualType [] && { count _args > 1 } }) then {
                    if (!((_args select 1) isEqualType []) || { count (_args select 1) < 10 }) then {
                        _args set [1, [[],[],[],[],[],[],"","",[],["","","","","",""]]];
                    };
                };
                _this call LL_orig_CBA_localEvent;
            };
        };
    };

    call _patchFnc;

    for "_i" from 1 to 40 do {
        call _patchFnc;
        sleep 0.5;
    };
};


if (isNil "player_0" || {isNull (missionNamespace getVariable ["player_0", objNull])}) then {
    private _allPlayable = playableUnits + switchableUnits;
    if (!isNull player) then { _allPlayable pushBackUnique player; };
    private _slCandidate = objNull;
    {
        if (!isNull _x && { (typeOf _x find "_SL_" != -1) || { rank _x == "SERGEANT" } }) exitWith {
            _slCandidate = _x;
        };
    } forEach _allPlayable;
    if (isNull _slCandidate && { count _allPlayable > 0 }) then {
        _slCandidate = _allPlayable select 0;
    };
    if (!isNull _slCandidate) then {
        player_0 = _slCandidate;
        _slCandidate setVehicleVarName "player_0";
        missionNamespace setVariable ["player_0", _slCandidate, true];
    };
};

if (isServer) then {
    private _slUnit = missionNamespace getVariable ["player_0", objNull];
    private _initLeader = objNull;
    if (!isNull _slUnit && { isPlayer _slUnit }) then {
        _initLeader = _slUnit;
    } else {
        private _humanPlayers = allPlayers select { alive _x && { side group _x in [west, independent] } };
        if (count _humanPlayers > 0) then {
            _initLeader = selectRandom _humanPlayers;
        } else {
            _initLeader = _slUnit;
        };
    };
    if (!isNull _initLeader) then {
        missionNamespace setVariable ["LL_group_leader", _initLeader, true];
        (group _initLeader) selectLeader _initLeader;
        [(group _initLeader), _initLeader] remoteExecCall ["selectLeader", 0];
    };
};

if (isNil "LL_var_takistaniDB_init") then {
    LL_var_takistaniDB_init = true;
    [] call LL_fnc_initTakistaniDB;
};

[] spawn LL_fnc_initSkills;
[] execVM "Functions\Player\fn_initIdentity.sqf";
[] execVM "Functions\Player\fn_initLoadout.sqf";

if (isServer) then {
    [] spawn LL_fnc_randomWeather;
    [] spawn LL_fnc_heliManager;
    [] spawn LL_fnc_droneManager;
    [] spawn LL_fnc_doorSecurity;
    [] spawn LL_fnc_aiHealSelf;
    [] spawn LL_fnc_preventWater;
    [] spawn LL_fnc_identityManager;
    [] spawn LL_fnc_startOperation;
    [] spawn LL_fnc_leaderMonitor;
};

if (!hasInterface) exitWith {};

[] spawn LL_fnc_initSupport;
if (isMultiplayer) then { [player] call LL_fnc_transferCommand; };

LL_fnc_clearScreenEffects = {
    params [["_unit", player, [objNull]]];

    "DynamicBlur" ppEffectEnable true;
    "DynamicBlur" ppEffectAdjust [0];
    "DynamicBlur" ppEffectCommit 0;
    "DynamicBlur" ppEffectEnable false;

    "RadialBlur" ppEffectEnable true;
    "RadialBlur" ppEffectAdjust [0, 0, 0, 0];
    "RadialBlur" ppEffectCommit 0;
    "RadialBlur" ppEffectEnable false;

    "ChromAberration" ppEffectEnable true;
    "ChromAberration" ppEffectAdjust [0, 0, true];
    "ChromAberration" ppEffectCommit 0;
    "ChromAberration" ppEffectEnable false;

    "ColorCorrections" ppEffectEnable true;
    "ColorCorrections" ppEffectAdjust [1, 1, 0, [0,0,0,0], [1,1,1,1], [0,0,0,0]];
    "ColorCorrections" ppEffectCommit 0;
    "ColorCorrections" ppEffectEnable false;

    "FilmGrain" ppEffectEnable false;
    resetCamShake;

    if (!isNull _unit) then {
        _unit setDamage 0;
        _unit setBleedingRemaining 0;

        if (!isNil "ace_medical_treatment_fnc_fullHeal") then {
            [_unit, _unit] call ace_medical_treatment_fnc_fullHeal;
        };
        if (!isNil "ace_medical_treatment_fnc_fullHealLocal") then {
            [_unit, _unit] call ace_medical_treatment_fnc_fullHealLocal;
        };
        if (!isNil "CBA_fnc_localEvent") then {
            ["ace_medical_treatment_fullHealLocal", _unit] call CBA_fnc_localEvent;
        };

        _unit setVariable ["ace_medical_pain", 0, true];
        _unit setVariable ["ace_medical_painSuppress", 1, true];
        _unit setVariable ["ace_medical_suppression", 0, true];
        _unit setVariable ["ace_medical_heartRate", 80, true];
        _unit setVariable ["ace_medical_bloodVolume", 6.0, true];
        _unit setVariable ["ace_medical_bloodPressure", [120, 80], true];
        _unit setVariable ["ace_medical_peripheralResistance", 100, true];
        _unit setVariable ["ace_medical_isUnconscious", false, true];
        _unit setVariable ["ace_suppression_suppression", 0, true];

        {
            private _handle = missionNamespace getVariable [_x, -1];
            if (!isNil "_handle" && { _handle isEqualType 0 && { _handle >= 0 } }) then {
                _handle ppEffectEnable false;
            };
        } forEach [
            "ace_medical_feedback_ppPain",
            "ace_medical_feedback_ppUnconscious",
            "ace_medical_feedback_ppEffectBlur",
            "ace_medical_feedback_ppEffectRadialBlur",
            "ace_medical_feedback_ppRadial",
            "ace_medical_feedback_ppBlackout",
            "ace_medical_engine_ppRadial",
            "ace_medical_engine_ppBlur",
            "ace_suppression_ppRadial",
            "ace_suppression_ppBlur",
            "ace_suppression_ppEffect"
        ];
    };
};

if (fog > 0.20) then { 0 setFog [0.20, 0, 0]; };

private _allSquadInit = [];
if (!isNull player) then {
    { _allSquadInit pushBackUnique _x; } forEach (units group player);
};
{ _allSquadInit pushBackUnique _x; } forEach (playableUnits + switchableUnits);
for "_i" from 0 to 6 do {
    private _u = missionNamespace getVariable [format ["player_%1", _i], objNull];
    if (!isNull _u) then { _allSquadInit pushBackUnique _u; };
};

{
    if (!isNull _x) then {
        _x allowDamage true;
        _x enableFatigue false;
        _x enableStamina false;
        _x setCustomAimCoef 0.1;
        [_x] call LL_fnc_badgeManager;
        if (rating _x < 5000) then { _x addRating (5000 - (rating _x)); };
        _x removeAllEventHandlers "HandleRating";
        _x addEventHandler ["HandleRating", {
            params ["_unit", "_rating"];
            if (_rating < 0) then { 0 } else { _rating };
        }];
    };
} forEach _allSquadInit;

[] spawn {
    waitUntil { sleep 0.5; missionNamespace getVariable ["MISSION_intro_finished", false] };
    cutText ["", "BLACK IN", 1.5];
    1 fadeSound 1;
    1 fadeMusic 1;
    player switchCamera "INTERNAL";
    showCinemaBorder false;
    [] spawn LL_fnc_reloadWeapons;

    private _lastPlayer = objNull;
    while {true} do {
        waitUntil { sleep 1; player != _lastPlayer && { !isNull player && alive player } };
        _lastPlayer = player;
        
        [_lastPlayer] call LL_fnc_clearScreenEffects;
        _lastPlayer allowDamage true;
        _lastPlayer enableFatigue false;
        _lastPlayer enableStamina false;
        _lastPlayer setCustomAimCoef 0.1;
        
        _lastPlayer removeAllEventHandlers "HandleRating";
        _lastPlayer addEventHandler ["HandleRating", {
            params ["_unit", "_rating"];
            if (_rating < 0) then { 0 } else { _rating };
        }];
        if (rating _lastPlayer < 5000) then {
            _lastPlayer addRating (5000 - (rating _lastPlayer));
        };
        
        _lastPlayer addEventHandler ["Respawn", {
            params ["_newUnit", "_oldUnit"];
            _newUnit allowDamage true;
            _newUnit enableFatigue false;
            _newUnit enableStamina false;
            _newUnit setCustomAimCoef 0.1;
            [_newUnit] call LL_fnc_badgeManager;
            _newUnit removeAllEventHandlers "HandleRating";
            _newUnit addEventHandler ["HandleRating", {
                params ["_unit", "_rating"];
                if (_rating < 0) then { 0 } else { _rating };
            }];
            if (rating _newUnit < 5000) then {
                _newUnit addRating (5000 - (rating _newUnit));
            };
        }];

        _lastPlayer addEventHandler ["Killed", {
            params ["_unit"];
            if (!isMultiplayer) then {
                [_unit] spawn LL_fnc_switchToAI;
            };
        }];
        
        [_lastPlayer] call LL_fnc_addRoeActions;
        [] spawn LL_fnc_stuckUnitManager;
        [] call LL_fnc_initSupport;
        if (isMultiplayer) then {
            [_lastPlayer] call LL_fnc_transferCommand;
        };
        [] call LL_fnc_initBriefing;
        [] call LL_fnc_initContext;

        [] spawn {
            sleep 0.5;
            private _tasks = [
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
            private _cur = "";
            {
                if ([_x] call BIS_fnc_taskExists) then {
                    private _st = [_x] call BIS_fnc_taskState;
                    if (_st in ["CREATED", "ASSIGNED", "AUTOASSIGNED"]) exitWith { _cur = _x; };
                };
            } forEach _tasks;
            if (_cur != "") then { [_cur, true] call BIS_fnc_taskSetCurrent; };
        };
    };
};

if (isServer && isMultiplayer) then {
    [] spawn {
        waitUntil { sleep 2; missionNamespace getVariable ["MISSION_intro_finished", false] };
        while {true} do {
            sleep 5;
            private _livingPlayers = allPlayers select { alive _x };
            if (_livingPlayers isEqualTo [] && { count allPlayers > 0 }) then {
                private _livingAI = (playableUnits + switchableUnits) select { alive _x && side _x == west };
                if (_livingAI isEqualTo []) exitWith {
                    sleep 8;
                    ["LOSER", false, 5] remoteExec ["BIS_fnc_endMission", 0];
                };
            };
        };
    };
};
