--[[ Chaotic Velocity 
local entity = GetUpdatedEntityID();
local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
    local angle = math.atan2( vy, vx );
    local magnitude = math.sqrt( vx * vx + vy * vy );
    local offset = (0.6 + math.random() * 0.8);
    ComponentSetValueVector2( velocity, "mVelocity", math.cos( angle )  * magnitude* offset, math.sin( angle ) * magnitude * offset );
end
]]
--[[ Rainbow Projectile
local entity = GetUpdatedEntityID();
local particle_emitters = EntityGetComponent( entity, "ParticleEmitterComponent" ) or {};
for _,particle_emitter in pairs(particle_emitters) do
    ComponentSetValue( particle_emitter, "color", tostring( 0xFF000000 + math.floor( math.random() * 0xFFFFFF) ) );
end
]]
