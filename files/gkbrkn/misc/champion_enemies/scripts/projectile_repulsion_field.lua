dofile_once("data/scripts/lib/utilities.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

local entity_id = GetUpdatedEntityID();
local distance_full = 36;
local distance_full_squared = distance_full ^ 2;
local x, y = EntityGetTransform( entity_id );
local gravity_coeff = 333;

local projectiles = EntityGetInRadiusWithTag( x, y, distance_full, "projectile" ) or {};
if #projectiles > 0 then
    local parent_id = EntityGetParent( entity_id );
    SetRandomSeed( GameGetFrameNum(), x + y + entity_id );
    local direction_random = math.rad( Random( -30, 30 ) );
	for _,projectile_entity in pairs( projectiles ) do
        local projectile = EntityGetFirstComponent( projectile_entity, "ProjectileComponent" );
        if tonumber( ComponentGetValue( projectile, "mWhoShot" ) ) ~= parent_id then
            local px, py = EntityGetTransform( projectile_entity );
            local distance_squared = ( x - px ) ^ 2 + ( y - py ) ^ 2;
            
            if distance_squared < distance_full_squared then
                direction = get_direction( px, py, x, y );
        
                local velocity_components = EntityGetComponent( projectile_entity, "VelocityComponent" ) or {};
                
                local gravity_percent = math.max( ( distance_full_squared - distance_squared ) / distance_full_squared, 0.01 );
                
                for _,velocity in pairs( velocity_components ) do
                    local vx,vy = ComponentGetValueVector2( velocity, "mVelocity", vx, vy );
                    
                    local offset_x = math.cos( direction + direction_random ) * ( gravity_coeff * gravity_percent );
                    local offset_y = 0 - math.sin( direction + direction_random ) * ( gravity_coeff * gravity_percent );

                    vx = vx + offset_x;
                    vy = vy + offset_y;

                    ComponentSetValueVector2( velocity, "mVelocity", vx, vy );
                end
            end
        end
	end
end

local particle_emitter = EntityGetFirstComponent( entity_id, "ParticleEmitterComponent", "gkbrkn_pulse" );
if particle_emitter ~= nil then
    ComponentSetValueValueRange( particle_emitter, "area_circle_radius", GameGetFrameNum() * 1.3 % distance_full, GameGetFrameNum() * 1.3 % distance_full )
end
