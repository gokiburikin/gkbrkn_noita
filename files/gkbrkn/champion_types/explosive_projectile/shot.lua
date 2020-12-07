function shot( projectile_entity )
    local projectile = EntityGetFirstComponent( projectile_entity, "ProjectileComponent" );
    if projectile then
        ComponentSetValue2( projectile, "on_death_explode", true );
        ComponentSetValue2( projectile, "on_lifetime_out_explode", true );
        ComponentObjectSetValue2( projectile, "config_explosion", "explosion_radius", math.min( ComponentObjectGetValue2( projectile, "config_explosion", "explosion_radius" ) + 10, 15 ) );
        ComponentObjectSetValue2( projectile, "config_explosion", "damage", ComponentObjectGetValue2( projectile, "config_explosion", "damage" ) + 0.4 );
        ComponentObjectSetValue2( projectile, "config_explosion", "damage_mortals", true );
        ComponentObjectSetValue2( projectile, "config_explosion", "explosion_sprite", "data/particles/explosion_032.xml" );
    end
end