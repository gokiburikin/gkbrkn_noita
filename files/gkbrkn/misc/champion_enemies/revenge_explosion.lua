function damage_received( damage, desc, entity_who_caused, is_fatal )
    local entity = GetUpdatedEntityID()
    if is_fatal == true and entity_who_caused ~= entity then
        local x, y = EntityGetTransform( entity )

        local projectile_entity = EntityLoad( "data/entities/misc/perks/revenge_explosion.xml", x, y );
        local genome = EntityGetFirstComponent( entity, "GenomeDataComponent" );
        local herd_id = -1;
        if genome ~= nil then
            herd_id = ComponentGetMetaCustom( genome, "herd_id" );
        end
        if send_message == nil then send_message = true end

        GameShootProjectile( who_shot, x, y, x+vel_x, y+vel_y, projectile_entity, send_message );

        local projectile = EntityGetFirstComponent( projectile_entity, "ProjectileComponent" );
        ComponentSetValue( projectile, "mWhoShot", who_shot );
        ComponentSetValue( projectile, "mShooterHerdId", herd_id );

        local velocity = EntityGetFirstComponent( projectile_entity, "VelocityComponent" );
        ComponentSetValueVector2( velocity, "mVelocity", vel_x, vel_y )

        return entity;
    end
end