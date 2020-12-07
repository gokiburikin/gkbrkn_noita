function shot( entity )
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        ComponentSetValue2( projectile, "damage", ComponentGetValue2( projectile, "damage" ) + 1.76 );
        ComponentSetValue2( projectile, "speed_min", ComponentGetValue2( projectile, "speed_min" ) * 0.30 );
        ComponentSetValue2( projectile, "speed_max", ComponentGetValue2( projectile, "speed_max" ) * 0.30 );
    end
    local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
    if velocity then
        local vx,vy = ComponentGetValue2( velocity, "mVelocity" );
        ComponentSetValue2( velocity, "mVelocity", vx * 0.30, vy * 0.30 );
    end
end