dofile( "files/gkbrkn/lib/variables.lua" );
EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_low_health_damage_bonus", 0.0, function( value ) return value + 2.00; end );
