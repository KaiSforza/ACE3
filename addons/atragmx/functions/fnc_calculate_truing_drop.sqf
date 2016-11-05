/*
 * Author: Ruthberg
 * Calculates the truing drop and updates the output fields
 *
 * Arguments:
 * Nothing
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call ace_atragmx_fnc_calculate_truing_drop
 *
 * Public: No
 */
#include "script_component.hpp"

private _transonicRange = 0 max abs(parseNumber(ctrlText 18011)) min 4000;
private _subsonicRange = 0 max abs(parseNumber(ctrlText 18012)) min 4000;
if (GVAR(currentUnit) != 2) then {
    _transonicRange = _transonicRange * 0.9144;
    _subsonicRange = _subsonicRange * 0.9144;
};
_transonicRange = Round(_transonicRange);
_subsonicRange  = Round(_subsonicRange);

private _transonicDrop = 0 max abs(parseNumber(ctrlText 18013)) min 1000;
private _subsonicDrop = 0 max abs(parseNumber(ctrlText 18014)) min 1000;
private _dropUnit = GVAR(currentScopeUnit);
if (_dropUnit == 3) then {
    switch (GVAR(currentScopeClickUnit)) do {
        case 0: { _dropUnit = 1; };
        case 1: { _dropUnit = 2; };
        case 2: { _dropUnit = 0; };
    };
};
switch (_dropUnit) do {
    case 0: {
        _transonicDrop = _transonicDrop * 3.38;
        _subsonicDrop  = _subsonicDrop  * 3.38;
    };
    case 2: {
        _transonicDrop = _transonicDrop / 1.047;
        _subsonicDrop  = _subsonicDrop  / 1.047;
    };
};
_transonicDrop = Round(_transonicDrop * 100) / 100;
_subsonicDrop  = Round(_subsonicDrop  * 100) / 100;

if ((GVAR(truingDropDropData) select 0) == 0 || {!([_transonicRange, _subsonicRange] isEqualTo GVAR(truingDropRangeData))}) then {
    if (isNil QGVAR(targetSolutionInput)) then {
        call FUNC(calculate_target_solution);
    };
    private _solutionInput = +GVAR(targetSolutionInput);
    
    if (_transonicRange == 0) then {
        _transonicRange = Round(403 call FUNC(calculate_distance_at_velocity));
    };
    _solutionInput set [13, _transonicRange];
    private _result1 = _solutionInput call FUNC(calculate_solution);
    _transonicDrop = Round((_result1 select 0) * 100) / 100;
    GVAR(truingDropRangeData) set [0, _transonicRange];
    GVAR(truingDropDropData) set [1, _transonicDrop];

    private _speedOfSound = (_solutionInput select 5) call EFUNC(weather,calculateSpeedOfSound);
    if (_subsonicRange == 0) then {
        _subsonicRange = Round(_speedOfSound call FUNC(calculate_distance_at_velocity));
        if (GVAR(currentUnit) == 2) then {
            _subsonicRange = _subsonicRange + 200;
        } else {
            _subsonicRange = _subsonicRange + 200 * 1.0936133;
        };
    };
    _solutionInput set [13, _subsonicRange];
    private _result2 = _solutionInput call FUNC(calculate_solution);
    _subsonicDrop = Round((_result2 select 0) * 100) / 100;
    GVAR(truingDropRangeData) set [1, _subsonicRange];
    GVAR(truingDropDropData) set [2, _subsonicDrop];
} else {
    GVAR(truingDropDropData) set [1, _transonicDrop];
    GVAR(truingDropDropData) set [2, _subsonicDrop];
    if (GVAR(truingDropMode) == 0) then {
        call FUNC(true_muzzle_velocity);
    } else {
        call FUNC(true_c1_ballistic_coefficient);
    };
};

call FUNC(update_truing_drop_data);
