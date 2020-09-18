local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    ComponentSetValue2( projectile, "penetrate_entities", true );

    local x, y = EntityGetTransform( entity );
    local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
    if velocity ~= nil then
        local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
        local angle = 0 - math.atan2( vy, vx );
        if vx == 0 and vy == 0 then
            local shooter = ComponentGetValue2( projectile, "mWhoShot" ) or 0;
            local components = EntityGetAllComponents( shooter ) or {};
            for _,component in pairs( components ) do
                if ComponentGetTypeName( component ) == "ControlsComponent" then
                    local ax, ay = ComponentGetValue2( component, "mAimingVector" );
                    angle = math.atan2( ay, ax );
                    ComponentSetValue2( velocity, "mVelocity", math.cos( angle ) * 40, math.sin( angle ) * 40 );
                    break;
                end
            end
        end
    end
end