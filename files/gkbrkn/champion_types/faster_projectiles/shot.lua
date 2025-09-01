function shot( e )
    local v = EntityGetFirstComponent( e, "VelocityComponent" )
    if not v then return end
    local vx, vy = ComponentGetValue2( v, "mVelocity" )
    vx = vx * math.random( 1.25, 1.5 )
    vy = vy * math.random( 1.25, 1.5 )
    ComponentSetValue2( v, "mVelocity", vx, vy )
end