dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local area = 8
local enemies = EntityGetInRadiusWithTag( pos_x, pos_y, area, "homing_target" );
 
pos_x = pos_x + Random( -area, area );
pos_y = pos_y + Random( -area, area );

if #enemies > 0 and Random( 1, 5 ) == 2 then
	local rnd = Random( 1, #enemies );
	local enemy_id = enemies[rnd];
	local ex, ey = EntityGetTransform( enemy_id );
	pos_x = ex;
	pos_y = ey;
end

local projectile = shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/purple_explosion.xml", pos_x, pos_y, 0, 0 );