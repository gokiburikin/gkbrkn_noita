dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
EntityAdjustVariableNumber( GetUpdatedEntityID(), "gkbrkn_damage_plus_lifetime_stacks", 0, function( value ) return tonumber( value ) + 1 end )
EntitySetVariableNumber( GetUpdatedEntityID(), "gkbrkn_damage_plus_lifetime_limit", GameGetFrameNum() + 60 )
