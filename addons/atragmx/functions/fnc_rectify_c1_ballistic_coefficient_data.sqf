/*
 * Author: Ruthberg
 * Rectifies the c1 ballistic coefficient vs. distance interpolation data
 *
 * Arguments:
 * Nothing
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call ace_atragmx_fnc_c1_ballistic_coefficient_data
 *
 * Public: No
 */
#include "script_component.hpp"

private _minDistance = 0;

{
    if ((_x select 1) > 0) then {
        private _distance = _x select 0;
        if (_distance < _minDistance) then {
            _x set [0, _minDistance];
        } else {
            _minDistance = _distance;
        };
    };
} forEach (GVAR(workingMemory) select 19);
