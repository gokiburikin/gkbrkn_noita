dofile_once( "data/scripts/lib/utilities.lua" );
local entity = GetUpdatedEntityID();
local x,y = EntityGetTransform( entity );
shoot_projectile( entity, "mods/gkbrkn_noita/files/gkbrkn/champion_types/janitor/clear_materials.xml", x, y, 0, 0 );