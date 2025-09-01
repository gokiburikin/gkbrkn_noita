function shot( e )
    local projectile = EntityGetFirstComponent( e, "ProjectileComponent" )
    if projectile ~= nil then
        ComponentSetValue2( projectile, "damage", ComponentGetValue2( projectile, "damage" ) + 0.2 )
    end
    EntityLoadToEntity( "data/entities/particles/tinyspark_yellow.xml", e )
end