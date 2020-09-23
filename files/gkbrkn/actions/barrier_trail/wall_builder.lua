dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local now = GameGetFrameNum();
local wall_piece = shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/wall_piece.xml", pos_x, pos_y, 0, 0 );
local projectile = EntityGetFirstComponentIncludingDisabled( wall_piece, "ProjectileComponent" );
if projectile ~= nil then
    ComponentSetValue2( projectile, "lifetime", 60 );
end