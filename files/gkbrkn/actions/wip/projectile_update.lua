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

--[[
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local shooter = ComponentGetValue( projectile, "mWhoShot" );
    local controls = EntityGetFirstComponent( shooter, "ControlsComponent" );
    if controls ~= nil then
        local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        if velocity ~= nil then
            local ax, ay = ComponentGetValueVector2( controls, "mAimingVector" );
            local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
            local angle = math.atan2( ay, ax );
            local magnitude = math.sqrt( vx * vx + vy * vy );
            ComponentSetValueVector2( velocity, "mVelocity", math.cos( angle ) * magnitude, math.sin( angle ) * magnitude );
        end
    end
end
]]

--[[

local wrap_distance = 128;
local inner_wrap_distance = 96;
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local shooter = ComponentGetValue( projectile, "mWhoShot" );
    if shooter ~= nil then
        local sx, sy = EntityGetTransform( shooter );
        local x, y = EntityGetTransform( entity );
        --local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        --if velocity ~= nil then
            local distance = math.sqrt( ( sy - y ) ^ 2 + ( sx - x ) ^ 2 );
            if distance > wrap_distance then
                local dx, dy = x - sx, y - sy;

                --local angle = math.atan2( sy - y, sx - x );
                --local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
                --local leftover = wrap_distance % distance;
                --local nx, ny = sx - math.sin( (math.pi * 0.5) % angle ) * ( inner_wrap_distance ), sy - math.cos( angle - math.pi * 0.5 ) * ( inner_wrap_distance );
                --GamePrint( dx.."/"..dy );
                --EntityKill( entity );
                EntitySetTransform( entity, x - dx * 1.9, y - dy * 1.9 );
            end
        --end
    end
end
]]