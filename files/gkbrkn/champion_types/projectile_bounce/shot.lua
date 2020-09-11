function shot( entity )
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        local bounces_left = tonumber( ComponentGetValue( projectile, "bounces_left" ) );
        local bounce_energy = tonumber( ComponentGetValue( projectile, "bounce_energy" ) );
        ComponentSetValue( projectile, "bounces_left", tostring( math.max( 4, bounces_left * 2 ) ) );
        ComponentSetValue( projectile, "bounce_energy", tostring( math.max( bounce_energy, 0.75 ) ) );
        ComponentSetValue( projectile, "bounce_at_any_angle", tostring( "1" ) );
    end
end