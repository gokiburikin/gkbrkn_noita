function shot( entity )
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        ComponentSetValue( projectile, "damage", tostring( tonumber( ComponentGetValue( projectile, "damage" ) ) * 2 ) );
    end
end