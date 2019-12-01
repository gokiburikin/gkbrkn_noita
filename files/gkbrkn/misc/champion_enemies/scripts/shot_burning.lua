function shot( entity )
    local x, y = EntityGetTransform( entity );
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    local effect_entities = ComponentGetValue( projectile, "damage_game_effect_entities" );
    ComponentSetValue( projectile, "blood_count_multiplier", "0" );
    ComponentSetValue( projectile, "damage_game_effect_entities", effect_entities.."files/gkbrkn/misc/champion_enemies/entities/effect_burn.xml," );
    EntityAddChild( entity, EntityLoad( "files/gkbrkn/misc/champion_enemies/entities/burn_shot.xml", x, y ) );
end