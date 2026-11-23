if (!hasInterface) exitWith {};

if (isNil { player getVariable ["LL_diary_briefing_added", nil] }) then {
    player setVariable ["LL_diary_briefing_added", true];
    {
        _x setVariable ["LL_diary_briefing_added", true];
        _x createDiaryRecord ["diary", [localize "STR_LL_Briefing_Title", localize "STR_LL_Briefing_Text"]];
    } forEach (units group player);
};

if (!(player diarySubjectExists "Manuel")) then {
    player createDiarySubject ["Manuel", localize "STR_LL_Briefing_Manual_Tab"];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_3_1_Title", localize "STR_LL_Briefing_3_1_Text"]];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_2_3_Title", localize "STR_LL_Briefing_2_3_Text"]];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_2_2_Title", localize "STR_LL_Briefing_2_2_Text"]];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_2_1_Title", localize "STR_LL_Briefing_2_1_Text"]];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_1_3_Title", localize "STR_LL_Briefing_1_3_Text"]];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_1_1_Title", localize "STR_LL_Briefing_1_1_Text"]];
};

if !(player getVariable ["LL_operationBriefingAdded", false]) then {
    private _briefingUnit = player;
    _briefingUnit setVariable ["LL_operationBriefingAdded", true];

    [_briefingUnit] spawn {
        params ["_briefingUnit"];

        private _timeout = 0;
        waitUntil {
            sleep 0.5;
            _timeout = _timeout + 0.5;
            !isNil { missionNamespace getVariable "LL_g_operationPlan" } || _timeout >= 60
        };

        private _plan = missionNamespace getVariable ["LL_g_operationPlan", []];
        if (count _plan < 2) exitWith {};

        private _body = "";
        {
            _x params ["_task", "_marker"];
            private _taskTitle = switch (toUpper _task) do {
                case "TASK_CAPTIVE";
                case "TASKD_CAPTIVE": { localize "STR_LL_Task_00_Title" };
                case "TASK_DOCUMENTS";
                case "TASKD_DOCUMENTS": { localize "STR_LL_Task_01_Title" };
                case "TASK_TRANSMISSION";
                case "TASKD_TRANSMISSION": { localize "STR_LL_Task_D_Transmission_Title" };
                case "TASK_CHEMICAL";
                case "TASKD_CHEMICAL": { localize "STR_LL_Task_04_Title" };
                case "TASK_HVT";
                case "TASKD_HVT": { localize "STR_LL_Task_D_HVT_Title" };
                case "TASK_TIGRIS";
                case "TASKD_TIGRIS": { localize "STR_LL_Task_08_Title" };
                default { _task };
            };

            private _siteLabel = markerText _marker;
            if (_siteLabel == "") then { _siteLabel = _marker; };

            _body = _body + format [
                "<br/><br/><font size='18' color='#e5b729'>%1 %2 - %3</font><br/>%4 : <marker name='%5'>%6</marker>",
                localize "STR_LL_OperationPlan_Objective",
                _forEachIndex + 1,
                _taskTitle,
                localize "STR_LL_OperationPlan_Site",
                _marker,
                _siteLabel
            ];
        } forEach _plan;

        _briefingUnit createDiaryRecord [
            "diary",
            [localize "STR_LL_OperationPlan_Title", _body]
        ];
    };
};
