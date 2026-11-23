[] spawn {
    while {true} do {
        if (hasInterface && {side player in [west, independent]}) then {
            player allowDamage true;
            player setFatigue 0;
            player setStamina 60; 
            player enableFatigue false;
            player enableStamina false;
            player setCustomAimCoef 0.1; 
        };

        {
            if (local _x && {side _x in [west, independent]} && {alive _x} && {isNil "drone_0" || {vehicle _x != drone_0}}) then {
                _x allowDamage true;
                _x setFatigue 0;
                _x enableFatigue false;
                _x enableStamina false;
            };
        } forEach allUnits;

        sleep 30; 
    };
};

if (!isServer) exitWith {}; 

[] spawn {
    while {true} do {
        {
            private _unit = _x;

            if (alive _unit && {isNil "drone_0" || {vehicle _unit != drone_0}}) then {

                private _side = side _unit;

                if (_side in [west, independent]) then {
                    _unit allowDamage true;
                    _unit enableFatigue false;
                    _unit enableStamina false;
                    _unit setUnitTrait ["loadCoef", 0.1];
                    _unit setAnimSpeedCoef 1.15;

                    if (str _unit in ["player_2", "player_02"] || typeOf _unit find "TP_" != -1 || typeOf _unit find "Marksman" != -1) then {
                        _unit setSkill ["aimingAccuracy", 0.95 + random 0.05]; 
                        _unit setSkill ["aimingShake",    0.95 + random 0.05]; 
                        _unit setSkill ["aimingSpeed",    0.95 + random 0.05]; 
                        _unit setSkill ["spotDistance",   1.00]; 
                        _unit setSkill ["spotTime",       1.00]; 
                    } else {
                        _unit setSkill ["aimingAccuracy", 0.80 + random 0.15]; 
                        _unit setSkill ["aimingShake",    0.80 + random 0.15]; 
                        _unit setSkill ["aimingSpeed",    0.80 + random 0.15]; 
                        _unit setSkill ["spotDistance",   0.90 + random 0.10]; 
                        _unit setSkill ["spotTime",       0.90 + random 0.10]; 
                    };

                    _unit setSkill ["commanding",     1.00]; 
                    _unit setSkill ["courage",        1.00]; 
                    _unit setSkill ["general",        1.00];
                    _unit allowFleeing 0; 
                    _unit setSpeedMode "FULL";
                    
                } else {
                    _unit setSkill ["aimingAccuracy", 0.10 + random 0.25]; 
                    _unit setSkill ["aimingShake",    0.10 + random 0.25]; 
                    _unit setSkill ["aimingSpeed",    0.15 + random 0.20]; 
                    _unit setSkill ["spotDistance",   0.20 + random 0.15]; 
                    _unit setSkill ["spotTime",       0.15 + random 0.20]; 
                    _unit setSkill ["commanding",     0.20 + random 0.15]; 
                    _unit setSkill ["courage",        1.00]; 
                    _unit setSkill ["general",        0.35];
                    _unit allowFleeing 0; 
                };
            };
        } forEach allUnits;

        sleep 45;
    };
};

