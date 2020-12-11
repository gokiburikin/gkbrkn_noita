local entity = GetUpdatedEntityID();
for k,v in pairs( EntityGetComponent( entity, "ProjectileComponent" ) or {} ) do
    ComponentSetValue2( v, "on_death_explode", false );
    ComponentSetValue2( v, "on_lifetime_out_explode", false );
    ComponentSetValue2( v, "collide_with_entities", false );
    ComponentSetValue2( v, "collide_with_world", false );
    ComponentSetValue2( v, "lifetime", -1 );
end
EntityKill( entity );