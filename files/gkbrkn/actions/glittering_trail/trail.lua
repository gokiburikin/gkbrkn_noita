dofile_once("data/scripts/lib/utilities.lua")

local entity    = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
SetRandomSeed( GameGetFrameNum(), x + y + entity );
if Random() <= 0.25 then
    shoot_projectile_from_projectile( entity, "data/entities/projectiles/deck/purple_explosion.xml", x, y, 0, 0 );
end