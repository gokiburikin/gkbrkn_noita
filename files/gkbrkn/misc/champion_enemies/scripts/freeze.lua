dofile_once("files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local x,y = EntityGetTransform( entity );
ShootProjectile( entity, "files/gkbrkn/misc/champion_enemies/entities/freeze.xml", x, y, 0, 0, true );