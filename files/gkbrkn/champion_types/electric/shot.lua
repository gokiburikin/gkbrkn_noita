function shot( entity )
    local x, y = EntityGetTransform( entity );
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        local effect_entities = ComponentGetValue( projectile, "damage_game_effect_entities" );
        ComponentSetValue( projectile, "damage_game_effect_entities", effect_entities.."mods/gkbrkn_noita/files/gkbrkn/champion_types/electric/effect_shock.xml," );
        EntityAddChild( entity, EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/electric/shot_electricity.xml", x, y ) );
    end
end