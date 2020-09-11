function shot( entity )
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        ComponentSetValue( projectile, "knockback_force", tostring( math.max( 8, tonumber( ComponentGetValue( projectile, "knockback_force" ) ) * 2 ) ) );
    end
end