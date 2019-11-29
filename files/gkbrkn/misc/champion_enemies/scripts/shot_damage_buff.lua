function shot( entity )
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    ComponentSetValue( projectile, "damage", tostring( tonumber( ComponentGetValue( projectile, "damage" ) ) * 2 ) );
end