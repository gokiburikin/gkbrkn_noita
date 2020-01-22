dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
EntityAdjustVariableNumber( entity, "gkbrkn_demolitionist_bonus", 0, function(value) return tonumber( value ) + 0.5; end );
