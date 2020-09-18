dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local random_offset = 8;
local maximum_strength = 96;
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local parent = tonumber(EntityGetVariableString( entity, "gkbrkn_soft_parent", "0" ));
if parent ~= 0 and EntityGetIsAlive(parent) then
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    local parent_projectile = EntityGetFirstComponent( parent, "ProjectileComponent" );
    local px, py = EntityGetTransform( parent );
    px = px + Random( -random_offset, random_offset );
    py = py + Random( -random_offset, random_offset );
    
    local distance = math.abs( x - px ) + math.abs( y - py );
    
    distance = math.sqrt( ( x - px ) ^ 2 + ( y - py ) ^ 2 );
    direction = 0 - math.atan2( ( y - py ), ( x - px ) );

    local distance_full = 128;
    local velocity_components = EntityGetComponent( entity, "VelocityComponent" ) or {};
    
    local gravity_percent = ( distance - distance_full  ) / distance_full / (math.random() * 0.5 + 0.3);
    local lifetime = ComponentGetValue2( parent_projectile, "lifetime" );
    local gravity_coeff = math.min( maximum_strength, lifetime * 4 );
    
    for _,velocity_component in pairs(velocity_components) do
        local vx,vy = ComponentGetValue2( velocity_component, "mVelocity", vx, vy);
        local ox = math.cos( direction ) * ( gravity_coeff * gravity_percent );
        local oy = 0 - math.sin( direction ) * ( gravity_coeff * gravity_percent );
        vx = vx + ox;
        vy = vy + oy;
        ComponentSetValue2( velocity_component, "mVelocity", vx, vy );
    end
end
