dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua" );

local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
initialize_legendary_wand( entity, x, y );
