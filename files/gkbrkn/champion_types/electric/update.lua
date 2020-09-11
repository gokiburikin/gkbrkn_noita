dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local x,y = EntityGetTransform( entity );
ShootProjectile( entity, "mods/gkbrkn_noita/files/gkbrkn/champion_types/electric/electricity.xml", x, y, 0, 0, true );