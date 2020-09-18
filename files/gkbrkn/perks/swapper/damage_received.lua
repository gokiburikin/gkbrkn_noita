function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID();
    if entity_thats_responsible ~= entity and entity_thats_responsible ~= 0 and EntityGetIsAlive( entity_thats_responsible ) and EntityHasTag( entity_thats_responsible, "enemy" ) then
        local x,y = EntityGetTransform( entity );
        local ax,ay = EntityGetTransform( entity_thats_responsible );
        EntitySetTransform( entity, ax, ay );
        EntitySetTransform( entity_thats_responsible, x, y );
        local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        local vx,vy = ComponentGetValue2( velocity, "mVelocity" );
        local attacker_velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        local avx,avy = ComponentGetValue2( attacker_velocity, "mVelocity" );
        ComponentSetValue2( velocity, "mVelocity", avx, avy );
        ComponentSetValue2( attacker_velocity, "mVelocity", vx, vy );
        EntityLoad( "data/entities/particles/teleportation_target.xml", x, y );
        EntityLoad( "data/entities/particles/teleportation_source.xml", ax, ay );
        EntityLoad( "data/entities/misc/invisibility_last_known_player_position.xml", x, y );
    end
end