dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
local shooter = ComponentGetValue( projectile, "mWhoShot" );
if shooter ~= nil then
    local shooter_velocity = EntityGetFirstComponent( shooter, "VelocityComponent" );
    local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
    if shooter_velocity ~= nil and velocity ~= nil then
        local multiplier = EntityGetVariableNumber( entity, "gkbrkn_follow_shot_multiplier", 0 );
        local svx, svy = ComponentGetValueVector2( shooter_velocity, "mVelocity" );
        svx = multiplier * svx;
        svy = multiplier * svy;
        local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
        --local angle = math.atan2( vy, vx );
        --local magnitude = math.sqrt( vx * vx + vy * vy );
        ComponentSetValueVector2( velocity, "mVelocity",
            vx + svx * 60 - EntityGetVariableNumber( entity, "gkbrkn_follow_shot_last_svx", 0 ),
            vy + svy * 60 - EntityGetVariableNumber( entity, "gkbrkn_follow_shot_last_svy", 0 )
        );
        EntitySetVariableNumber( entity, "gkbrkn_follow_shot_last_svx", svx * 60 );
        EntitySetVariableNumber( entity, "gkbrkn_follow_shot_last_svy", svy * 60 );
    end
end

