dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
EntityAdjustVariableNumber( entity, "gkbrkn_damage_plus_lifetime_stacks", 0, function( value ) return tonumber( value ) + 1; end );
