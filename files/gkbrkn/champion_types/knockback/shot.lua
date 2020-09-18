function shot( entity )
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        ComponentSetValue2( projectile, "knockback_force", math.max( 8, ComponentGetValue2( projectile, "knockback_force" ) * 2 ) );
    end
end