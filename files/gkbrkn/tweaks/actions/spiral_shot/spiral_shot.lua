dofile_once( "data/scripts/lib/utilities.lua" );

local entity    = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local how_many = 4;
local distance = 16;

while #( EntityGetAllChildren( entity ) or {} ) < how_many do
    local spiral_part = shoot_projectile_from_projectile( entity, "mods/gkbrkn_noita/files/gkbrkn/tweaks/actions/spiral_shot/spiral_part.xml", x, y, 0, 0 );
    EntityAddChild( entity, spiral_part );
end

local angle_inc = ( 2 * 3.14159 ) / how_many;
local theta = math.rad( 6 ) - GameGetFrameNum() / 10.0;
for i,child in ipairs( EntityGetAllChildren( entity ) or {} ) do
    local velocity = EntityGetFirstComponent( child, "VelocityComponent" );
    if velocity ~= nil then
        local cx, cy = EntityGetTransform( child );
        local tx = x + math.cos( theta + angle_inc * ( i - 1 ) ) * distance;
        local ty = y + math.sin( theta + angle_inc * ( i - 1 ) ) * distance;

        ComponentSetValueVector2( velocity, "mVelocity", ( tx - cx ) * 60, ( ty - cy ) * 60 );
    end
end
