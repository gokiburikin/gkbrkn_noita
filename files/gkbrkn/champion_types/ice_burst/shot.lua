function shot( entity )
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        ComponentSetValue2( projectile, "damage",  ComponentGetValue2( projectile, "damage" ) * 2 );
    end
end