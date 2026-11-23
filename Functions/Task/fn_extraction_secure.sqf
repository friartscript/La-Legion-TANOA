params ["_heli"];

if (!isServer) exitWith {};
if (isNull _heli || !alive _heli) exitWith {};

_heli lock 0;
_heli lockCargo false;

private _allSquadUnits = [];
if (!isNull player) then {
    { _allSquadUnits pushBackUnique _x; } forEach (units group player);
};
{ _allSquadUnits pushBackUnique _x; } forEach (playableUnits + switchableUnits);
if (_allSquadUnits isEqualTo [] && { count allPlayers > 0 }) then {
    _allSquadUnits = units group (allPlayers select 0);
};
for "_i" from 0 to 6 do {
    private _u = missionNamespace getVariable [format ["player_%1", _i], objNull];
    if (!isNull _u) then { _allSquadUnits pushBackUnique _u; };
};
_allSquadUnits = _allSquadUnits select { alive _x };

private _squadGroup = grpNull;
private _squadSide = independent;
{
    if (alive _x) exitWith { 
        _squadGroup = group _x; 
        _squadSide = side _squadGroup;
    };
} forEach _allSquadUnits;

private _individualGroups = [];
missionNamespace setVariable ["LL_Extraction_Boarded", false, true];
missionNamespace setVariable ["LL_Extraction_HeliObj", _heli, true];

{
    private _u = _x;
    if (alive _u && !isPlayer _u) then {
        private _newGrp = createGroup [_squadSide, true];
        [_u] joinSilent _newGrp;
        _individualGroups pushBack _newGrp;

        _u setBehaviour "AWARE";
        _u setSpeedMode "FULL";
        _u allowDamage true; 
        
        _newGrp reveal [_heli, 4]; 

        unassignVehicle _u;
        _u assignAsCargo _heli;
        
        private _wp = _newGrp addWaypoint [getPosATL _heli, 0];
        _wp setWaypointType "GETIN";
        _wp waypointAttachVehicle _heli;
        
        _u setVariable ["LL_lastPos", getPosATL _u];
        _u setVariable ["LL_stuckTime", 0];
    };
} forEach _allSquadUnits;

private _allBoarded = false;

while { !_allBoarded && alive _heli } do {
    sleep 1;

    private _livingSquad = _allSquadUnits select { alive _x };
    
    {
        if (alive _x && !isPlayer _x && vehicle _x != _heli) then {
            private _lastPos = _x getVariable ["LL_lastPos", getPosATL _x];
            private _stuckTime = _x getVariable ["LL_stuckTime", 0];
            
            if (_lastPos distance2D (getPosATL _x) < 1.5) then {
                _stuckTime = _stuckTime + 1;
            } else {
                _stuckTime = 0; 
                _x setVariable ["LL_lastPos", getPosATL _x];
            };
            
            if (_stuckTime >= 10) then {
                _x moveInCargo _heli;
                if (vehicle _x != _heli) then { _x moveInAny _heli; };
                _x setVariable ["LL_stuckTime", 0];
                
                _x disableAI "MOVE";
                _x disableAI "PATH";
                while {count (waypoints (group _x)) > 0} do { deleteWaypoint [(group _x), 0] };
            } else {
                _x setVariable ["LL_stuckTime", _stuckTime];
            };
        };
    } forEach _allSquadUnits;

    private _inCargoCount = { vehicle _x == _heli } count _livingSquad;
    if (_inCargoCount == count _livingSquad && count _livingSquad > 0) then {
        _allBoarded = true;
    };
};

if (!alive _heli) exitWith {};

missionNamespace setVariable ["LL_Extraction_Boarded", true, true];
missionNamespace setVariable ["LL_g_extractionStarted", true, true];


_heli lockCargo true;
_heli lock 2;

{
    if (alive _x && !isPlayer _x && vehicle _x == _heli) then {
        _x disableAI "MOVE";
        _x disableAI "PATH";
    };
} forEach _allSquadUnits;

{
    if (alive _x && !isPlayer _x) then {
        [_x] joinSilent _squadGroup;
        _x allowDamage true; 
    };
} forEach _allSquadUnits;

{ if (!isNull _x) then { deleteGroup _x; }; } forEach _individualGroups;



{
    if (_x != driver _heli) then {
        _x setBehaviour "COMBAT";
        _x setCombatMode "RED";
        _x enableAI "AUTOTARGET";
        _x enableAI "TARGET";
        _x enableAI "WEAPONAIM";
    };
} forEach (crew _heli);
