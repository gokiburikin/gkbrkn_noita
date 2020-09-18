function shot( entity )
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        local bounces_left = ComponentGetValue2( projectile, "bounces_left" );
        local bounce_energy = ComponentGetValue2( projectile, "bounce_energy" );
        ComponentSetValue2( projectile, "bounces_left", math.max( 4, bounces_left * 2 ) );
        ComponentSetValue2( projectile, "bounce_energy", math.max( bounce_energy, 0.75 ) );
        ComponentSetValue2( projectile, "bounce_at_any_angle", true);
    end
end