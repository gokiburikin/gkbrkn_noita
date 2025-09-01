function shot( e )
    local v = EntityGetFirstComponent( e, "VelocityComponent" )
    if v then
        local vx, vy = ComponentGetValue2( v, "mVelocity" )
        vx = vx * math.random( 0.6, 0.8 )
        vy = vy * math.random( 0.6, 0.8 )
        ComponentSetValue2( v, "mVelocity", vx, vy )
    end
    local l = EntityGetFirstComponent( e, "LifetimeComponent" )
    if l then
        ComponentSetValue2( l, "lifetime", ComponentGetValue2( l, "lifetime" ) * 1.5 )
    end
    local p = EntityGetFirstComponent( e, "ProjectileComponent" )
    if p then
        ComponentSetValue2( p, "lifetime", ComponentGetValue2( p, "lifetime" ) * 1.5 )
    end
end