dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_draw_actions_bonus", 0, function(value) return tonumber( value ) + 2 end );
print_error( "set draw actions bonus "..EntityGetVariableNumber( entity_who_picked, "gkbrkn_draw_actions_bonus" ) )
