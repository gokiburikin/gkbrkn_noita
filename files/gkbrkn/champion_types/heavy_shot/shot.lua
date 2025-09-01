function shot( e )
    local projectile = EntityGetFirstComponent( e, "ProjectileComponent" )
    if projectile ~= nil then
        ComponentSetValue2( projectile, "damage", ComponentGetValue2( projectile, "damage" ) * 2 )
        ComponentSetValue2( projectile, "speed_min", ComponentGetValue2( projectile, "speed_min" ) * 0.5 )
        ComponentSetValue2( projectile, "speed_max", ComponentGetValue2( projectile, "speed_max" ) * 0.5 )
    end
    local velocity = EntityGetFirstComponent( e, "VelocityComponent" )
    if velocity then
        local vx,vy = ComponentGetValue2( velocity, "mVelocity" )
        ComponentSetValue2( velocity, "mVelocity", vx * 0.5, vy * 0.5 )
    end
    EntityLoadToEntity( "data/entities/particles/heavy_shot.xml", e )
end