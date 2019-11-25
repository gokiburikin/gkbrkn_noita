local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local effect_distance = 36;

local projectiles = EntityGetInRadiusWithTag( x, y, effect_distance, "projectile" );
local parent = tonumber( EntityGetParent( entity ) );

if #projectiles > 0 then
    for _,projectile_id in pairs( projectiles ) do
        local component = EntityGetFirstComponent( projectile_id, "ProjectileComponent" );
        local shooter = tonumber( ComponentGetValue( component, "mWhoShot" ) );
        if shooter ~= parent then
            local px, py = EntityGetTransform( projectile_id );
            
            local distance = math.abs( x - px ) + math.abs( y - py );
            local distance_full = effect_distance;
            
            if distance < distance_full * 1.25 then
                distance = math.sqrt( ( x - px ) ^ 2 + ( y - py ) ^ 2 );
                direction = 0 - math.atan2( ( y - py ), ( x - px ) );
        
                if distance < distance_full then
                    local velocity_component = EntityGetFirstComponent( projectile_id, "VelocityComponent" );
                    
                    local gravity_percent = math.max(( distance_full - distance ) / distance_full, 0.2 );
                    local gravity_coeff = -150;
                    
                    if velocity_component ~= nil then
                        local vx,vy = ComponentGetValueVector2( velocity_component, "mVelocity" );
                            
                        local offset_x = math.cos( direction ) * ( gravity_coeff * gravity_percent );
                        local offset_y = 0 - math.sin( direction ) * ( gravity_coeff * gravity_percent );

                        vx = vx + offset_x;
                        vy = vy + offset_y;

                        ComponentSetValueVector2( velocity_component, "mVelocity", vx, vy );
                    end
                end
            end
        end
    end
end

local particle_emitter = EntityGetFirstComponent( entity, "ParticleEmitterComponent", "gkbrkn_pulse" );
if particle_emitter ~= nil then
    ComponentSetValueValueRange( particle_emitter, "area_circle_radius", GameGetFrameNum() * 1.3 % 36, GameGetFrameNum() * 1.3 % 36 )
end