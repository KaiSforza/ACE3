/*
 * Author: Ruthberg
 * Toggles the truing drop screen on/off
 *
 * Arguments:
 * Apply new data? <NUMBER>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * 1 call ace_atragmx_fnc_toggle_truing_drop
 *
 * Public: No
 */
#include "script_component.hpp"

if (!(missionNamespace getVariable [QEGVAR(advanced_ballistics,enabled), false])) exitWith {};

if (ctrlVisible 18000) then {
    false call FUNC(show_truing_drop);
    true call FUNC(show_main_page);

    if (_this == 1) then {
        if (GVAR(truingDropMode) == 0) then {
            (GVAR(truingDropMuzzleVelocity) - (GVAR(workingMemory) select 1)) call FUNC(shift_muzzle_velocity_data);
            call FUNC(update_muzzle_velocity_data);
            GVAR(workingMemory) set [1, GVAR(truingDropMuzzleVelocity)];
        } else {
            GVAR(workingMemory) set [15, GVAR(truingDropC1)];
        };
        call FUNC(update_gun);
        call FUNC(update_gun_ammo_data);
        call FUNC(calculate_target_solution);
    } else {
        call FUNC(update_truing_drop_data);
    };
} else {
    false call FUNC(show_main_page);
    true call FUNC(show_truing_drop);
};
