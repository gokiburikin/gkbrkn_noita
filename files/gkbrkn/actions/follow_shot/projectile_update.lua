dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
local shooter = ComponentGetValue2( projectile, "mWhoShot" );
if shooter ~= nil then
    local shooter_velocity = EntityGetFirstComponentIncludingDisabled( shooter, "VelocityComponent" );
    local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
    if shooter_velocity ~= nil and velocity ~= nil then
        local multiplier = EntityGetVariableNumber( entity, "gkbrkn_follow_shot_multiplier", 0 );
        local svx, svy = ComponentGetValue2( shooter_velocity, "mVelocity" );
        svx = multiplier * svx;
        svy = multiplier * svy;
        local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
        --local angle = math.atan2( vy, vx );
        --local magnitude = math.sqrt( vx * vx + vy * vy );
        ComponentSetValue2( velocity, "mVelocity",
            vx + svx * 60 - EntityGetVariableNumber( entity, "gkbrkn_follow_shot_last_svx", 0 ),
            vy + svy * 60 - EntityGetVariableNumber( entity, "gkbrkn_follow_shot_last_svy", 0 )
        );
        EntitySetVariableNumber( entity, "gkbrkn_follow_shot_last_svx", svx * 60 );
        EntitySetVariableNumber( entity, "gkbrkn_follow_shot_last_svy", svy * 60 );
    end
end

