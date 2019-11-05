dofile( "data/scripts/lib/utilities.lua" );

local gravity_well_distance = 64;
local maximum_strength = 128;
local entity_id = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity_id );

if EntityHasTag( entity_id, "gkbrkn_action_orbit" ) == false then
    EntityAddTag( entity_id, "gkbrkn_action_orbit" );
end

local projectiles = EntityGetInRadiusWithTag( x, y, gravity_well_distance, "projectile" );

if #projectiles > 0 then
    for i,projectile_id in ipairs( projectiles ) do
        -- ignore self and other orbit projectiles
        if projectile_id ~= entity_id and EntityHasTag( projectile_id, "gkbrkn_action_orbit" ) == false then
            local projectile_component = EntityGetFirstComponent( projectile_id, "ProjectileComponent" );
            if projectile_component ~= nil then
                local herd_id = tonumber( ComponentGetValue( projectile_component , "mShooterHerdId") );
                -- if it was shot by a player in some way
                if herd_id == 0 then
                    local px, py = EntityGetTransform( projectile_id );
                    
                    local distance = math.abs( x - px ) + math.abs( y - py );
                    local distance_full = gravity_well_distance;
                    
                    if distance < distance_full * 1.25 then
                        distance = math.sqrt( ( x - px ) ^ 2 + ( y - py ) ^ 2 );
                        direction = 0 - math.atan2( ( y - py ), ( x - px ) );
                
                        if distance < distance_full then
                            local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" );
                            
                            local gravity_percent = ( distance_full - distance ) / distance_full;
                            local gravity_coeff = math.min( maximum_strength, tonumber(ComponentGetValue( projectile_component, "lifetime" ) * 10 ) );
                            
                            if velocitycomponents ~= nil then
                                edit_component( projectile_id, "VelocityComponent", function(comp,vars)
                                    local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y);
                                    
                                    local offset_x = math.cos( direction ) * ( gravity_coeff * gravity_percent );
                                    local offset_y = 0 - math.sin( direction ) * ( gravity_coeff * gravity_percent );

                                    vel_x = vel_x + offset_x;
                                    vel_y = vel_y + offset_y;

                                    ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y);
                                end);
                            end
                        end
                    end
                end
            end
        end
	end
end