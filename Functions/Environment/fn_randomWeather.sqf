if (!isServer) exitWith {};

private _minMinutes = 5 * 60;
private _maxMinutes = 21 * 60;
private _totalMinutes = _minMinutes + floor (random (_maxMinutes - _minMinutes + 1));
private _hour = floor (_totalMinutes / 60);
private _minute = _totalMinutes % 60;

setDate [2019, 3, 13, _hour, _minute];

private _fnc_generateWeather = {
    params ["_weatherIndex"];

    private _profiles = [
        [0.00, 0.20, 0.00, 0.02, 0.000, 0,  0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1.0,  5.0, 0.00, 0.10, [0, 1, 2, 8]],
        [0.20, 0.45, 0.00, 0.04, 0.000, 0,  0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 3.0,  8.0, 0.10, 0.25, [0, 1, 2, 4, 8]],
        [0.05, 0.35, 0.05, 0.15, 0.025, 40, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.5,  3.5, 0.00, 0.10, [0, 1, 3, 4]],
        [0.55, 0.80, 0.08, 0.20, 0.005, 10, 0.00, 0.10, 0.00, 0.00, 0.00, 0.00, 0.5,  4.0, 0.05, 0.15, [2, 3, 4, 5]],
        [0.65, 0.85, 0.02, 0.08, 0.001, 0,  0.00, 0.20, 0.00, 0.00, 0.00, 0.00, 4.0, 12.0, 0.20, 0.45, [1, 3, 4, 5, 8]],
        [0.85, 0.95, 0.05, 0.15, 0.002, 0,  0.30, 0.65, 0.00, 0.15, 0.00, 0.30, 6.0, 16.0, 0.35, 0.65, [4, 5, 6, 7]],
        [0.95, 1.00, 0.08, 0.20, 0.003, 0,  0.75, 1.00, 0.60, 1.00, 0.00, 0.00, 12.0, 24.0, 0.70, 1.00, [5, 6, 7]],
        [0.35, 0.60, 0.04, 0.12, 0.010, 20, 0.00, 0.05, 0.00, 0.00, 0.60, 1.00, 3.0, 10.0, 0.20, 0.40, [0, 1, 4]],
        [0.05, 0.50, 0.00, 0.02, 0.000, 0,  0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 18.0, 30.0, 0.80, 1.00, [0, 1, 4, 8]]
    ];

    if (_weatherIndex < 0 || _weatherIndex >= count _profiles) then {
        _weatherIndex = floor (random (count _profiles));
    };

    private _cfg = _profiles select _weatherIndex;
    _cfg params [
        "_ocMin", "_ocMax",
        "_fogValMin", "_fogValMax", "_fogDecay", "_fogBase",
        "_rainMin", "_rainMax",
        "_lightMin", "_lightMax",
        "_rbMin", "_rbMax",
        "_wMin", "_wMax",
        "_gMin", "_gMax",
        "_transitions"
    ];

    private _overcast   = _ocMin + random (_ocMax - _ocMin);
    private _fogVal     = 0 max ((_fogValMin + random (_fogValMax - _fogValMin)) min 0.20);
    private _rain       = _rainMin + random (_rainMax - _rainMin);
    private _lightnings = _lightMin + random (_lightMax - _lightMin);
    private _rainbow    = _rbMin + random (_rbMax - _rbMin);
    private _gusts      = _gMin + random (_gMax - _gMin);

    private _windSpeed  = _wMin + random (_wMax - _wMin);
    private _windDir    = random 360;
    private _windX      = _windSpeed * sin _windDir;
    private _windY      = _windSpeed * cos _windDir;

    private _nextIndex  = selectRandom _transitions;

    [_overcast, [_fogVal, _fogDecay, _fogBase], _rain, _lightnings, _rainbow, _gusts, _windX, _windY, _nextIndex]
};

private _initial = [-1] call _fnc_generateWeather;
_initial params ["_overcast", "_fogParams", "_rain", "_lightnings", "_rainbow", "_gusts", "_windX", "_windY", "_nextIndex"];

skipTime -24;
86400 setOvercast _overcast;
skipTime 24;

_fogParams set [0, 0 max ((_fogParams select 0) min 0.20)];
0 setFog _fogParams;
0 setRain _rain;
0 setLightnings _lightnings;
0 setRainbow _rainbow;
0 setGusts _gusts;
setWind [_windX, _windY, true];
forceWeatherChange;
setDate [2019, 3, 13, _hour, _minute];

[_fnc_generateWeather, _nextIndex] spawn {
    params ["_fnc_generateWeather", "_currentIndex"];

    while {true} do {
        private _transDuration = 2400 + floor (random 1500);
        sleep _transDuration;

        private _weather = [_currentIndex] call _fnc_generateWeather;
        _weather params ["_overcast", "_fogParams", "_rain", "_lightnings", "_rainbow", "_gusts", "_windX", "_windY", "_nextIdx"];
        _currentIndex = _nextIdx;

        _fogParams set [0, 0 max ((_fogParams select 0) min 0.20)];
        _transDuration setOvercast _overcast;
        _transDuration setFog _fogParams;
        _transDuration setRain _rain;
        _transDuration setLightnings _lightnings;
        _transDuration setRainbow _rainbow;
        _transDuration setGusts _gusts;
        setWind [_windX, _windY, true];
    };
};

[] spawn {
    while {true} do {
        sleep 5;
        if (fog > 0.20) then {
            1 setFog [0.20, 0, 0];
        };
    };
};
