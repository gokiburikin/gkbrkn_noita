dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );

local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
initialize_legendary_wand( entity, x, y );
