local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local correction_distance = 48;

dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

local nearby_entities = EntityGetInRadiusWithTag( x, y, correction_distance, "homing_target" ) or {};
local target = nearby_entities[ math.ceil( math.random() * #nearby_entities ) ];
if target ~= nil then
    local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
    local shooter = ComponentGetValue2( projectile, "mWhoShot" );
    local shooter_genome = EntityGetFirstComponentIncludingDisabled( shooter, "GenomeDataComponent" );
    local shooter_herd = -1;
    if shooter_genome ~= nil then
        shooter_herd = ComponentGetValue2( shooter_genome, "herd_id" );
    end
    local target_genome = EntityGetFirstComponentIncludingDisabled( target, "GenomeDataComponent" );
    local target_herd = -1;
    if target_genome ~= nil then
        target_herd = ComponentGetValue2( target_genome, "herd_id" );
    end
    if tonumber(target) ~= tonumber(shooter) and target_herd ~= shooter_herd then
        local tx, ty = EntityGetFirstHitboxCenter( target );
        if tx == nil or ty == nil then
            tx, ty = EntityGetTransform( target );
        end
        local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
        local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
        local angle = math.atan2( vy, vx );
        local target_angle = math.atan2( ty - y, tx - x ) + ( math.random() - 0.5 ) * 15 / 180 * math.pi;
        local magnitude = math.sqrt( vx * vx + vy * vy );
        ComponentSetValue2( velocity, "mVelocity", math.cos( target_angle ) * magnitude, math.sin( target_angle ) * magnitude );
        EntityKill( entity );
    end
end

