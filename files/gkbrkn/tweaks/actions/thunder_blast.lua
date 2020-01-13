dofile_once( "data/scripts/lib/utilities.lua" );

local entity    = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local how_many = 4;
local angle_inc = ( 2 * 3.14159 ) / how_many + math.rad( math.random( 0, 30 ) - math.random( 0, 30 ) );
local theta = 0;
local length = 2500;

for i=1,how_many do
    local vx = math.cos( theta ) * length;
    local vy = math.sin( theta ) * length;
    theta = theta + angle_inc;

    shoot_projectile_from_projectile( entity, "data/entities/projectiles/deck/lightning.xml", x, y, vx, vy );
end
