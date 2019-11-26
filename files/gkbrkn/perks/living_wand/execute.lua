dofile_once( "data/scripts/lib/utilities.lua" );

local entity_id    = GetUpdatedEntityID();
local pos_x, pos_y = EntityGetTransform( entity_id );

local living_wand = EntityLoad( "files/gkbrkn/placeholder_wand.xml", pos_x, pos_y);
EntityAddTag( living_wand, "gkbrkn_living_wand_"..entity_id );