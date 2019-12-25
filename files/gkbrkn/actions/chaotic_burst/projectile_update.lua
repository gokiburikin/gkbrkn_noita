-- don't edit this stuff
function RGBtoABGR( r, g, b )
    local blue = math.floor( b / 255 * 0xFF0000 );
    local green = math.floor( g / 255 * 0xFF00 );
    local red = math.floor( r / 255 * 0xFF );
    return bit.bxor( 0xFF000000, red, green, blue );
end

local entity = GetUpdatedEntityID();
local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local vx,vy = ComponentGetValueVector2( velocity, "mVelocity", vx, vy );
    local scale = 0.2;
    local angle = math.atan2( vy, vx ) + (math.random() - 0.5) * math.pi * scale;
    local magnitude = math.sqrt( vx * vx + vy * vy );

    ComponentSetValueVector2( velocity, "mVelocity", math.cos( angle ) * magnitude, math.sin( angle ) * magnitude );
end

local particle_emitters = EntityGetComponent( entity, "ParticleEmitterComponent" ) or {};
for _,particle_emitter in pairs( particle_emitters ) do
    local red = Random( 0x88, 0xFF );
    local green = 0;
    local blue = Random( 0x00, 0x44 );
    ComponentSetValue( particle_emitter, "color", tostring( RGBtoABGR( red, green, blue ) ) );
end