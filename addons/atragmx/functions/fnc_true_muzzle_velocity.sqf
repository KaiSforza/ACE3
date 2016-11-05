/*
 * Author: Ruthberg
 * Trues the muzzle velocity
 *
 * Arguments:
 * Nothing
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call ace_atragmx_fnc_true_muzzle_velocity
 *
 * Public: No
 */
#include "script_component.hpp"

private _referenceDrop = GVAR(truingDropDropData) select 0;
private _actualDrop = GVAR(truingDropDropData) select 1;

if (_actualDrop == _referenceDrop) exitWith {};

private _step = 1;
if (_actualDrop > _referenceDrop) then {
    _step = -1;
};

private _solutionInput = +GVAR(targetSolutionInput);
_solutionInput set [13, GVAR(truingDropRangeData) select 0];
private _muzzleVelocity = _solutionInput select 4;

while { _actualDrop * _step < _referenceDrop * _step } do {
    _muzzleVelocity = _muzzleVelocity + _step;
    _solutionInput set [4, _muzzleVelocity];
    private _result = _solutionInput call FUNC(calculate_solution);
    _referenceDrop = (_result select 0);
};

GVAR(truingDropMuzzleVelocity) = _muzzleVelocity;
