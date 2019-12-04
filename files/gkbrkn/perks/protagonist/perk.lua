dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_low_health_damage_bonus", 0.0, function( value ) return value + 1.00; end );
