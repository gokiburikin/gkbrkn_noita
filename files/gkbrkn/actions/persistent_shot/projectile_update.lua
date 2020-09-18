dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");

function ease_angle( angle, target_angle, easing )
    local dir = (angle - target_angle) / (math.pi*2);
    dir = dir - math.floor(dir + 0.5);
    dir = dir * (math.pi*2);
    return angle - dir * easing;
end

local entity = GetUpdatedEntityID();
local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then

    local vx,vy = ComponentGetValue2( velocity, "mVelocity", vx, vy );
    local magnitude = math.max( math.sqrt( vx * vx + vy * vy ), 50 );
    local angle = math.atan2( vy, vx );
    local new_angle = ease_angle( angle, EntityGetVariableNumber( entity, "gkbrkn_persistent_shot_angle", angle ), 0.15 );

    ComponentSetValue2( velocity, "mVelocity", math.cos( new_angle ) * magnitude, math.sin( new_angle ) * magnitude );
end