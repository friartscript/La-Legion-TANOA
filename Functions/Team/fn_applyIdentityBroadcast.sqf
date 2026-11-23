


params [
    ["_unit", objNull, [objNull]],
    ["_nameData", [], [[]]],
    ["_selectedFace", "", [""]],
    ["_selectedSpeaker", "", [""]],
    ["_pitch", 1, [0]]
];

if (isNull _unit || !alive _unit) exitWith {};

_nameData params ["_fullName", "_firstName", "_lastName"];

_unit setFace _selectedFace;

if !(_nameData isEqualTo []) then {
    _unit setName [_fullName, _firstName, _lastName];
};

_unit setSpeaker _selectedSpeaker;
_unit setPitch _pitch;
_unit setIdentity "";

true


