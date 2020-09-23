dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");

function ease_angle( angle, target_angle, easing )
    local dir = (angle - target_angle) / (math.pi*2);
    dir = dir - math.floor(dir + 0.5);
    dir = dir * (math.pi*2);
    return angle - dir * easing;
end

local entity = GetUpdatedEntityID();
local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
if velocity ~= nil then
    local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
    if projectile ~= nil then
        local shooter = ComponentGetValue2( projectile, "mWhoShot" ) or 0;
        local aim_angle = 0;
        local components = EntityGetAllComponents( shooter ) or {};
        for _,component in pairs( components ) do
            if ComponentGetTypeName( component ) == "ControlsComponent" then
                local ax, ay = ComponentGetValue2( component, "mAimingVector" );
                aim_angle = math.atan2( ay, ax );
                break;
            end
        end
        local vx,vy = ComponentGetValue2( velocity, "mVelocity", vx, vy );
        local magnitude = math.max( math.sqrt( vx * vx + vy * vy ), 50 );
        local angle = math.atan2( vy, vx );
        local new_angle = ease_angle( angle, aim_angle, 0.15 );

        ComponentSetValue2( velocity, "mVelocity", math.cos( new_angle ) * magnitude, math.sin( new_angle ) * magnitude );
    end
end