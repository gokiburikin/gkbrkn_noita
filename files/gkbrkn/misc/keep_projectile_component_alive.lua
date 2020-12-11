local entity = GetUpdatedEntityID();
for k,v in pairs( EntityGetComponent( entity, "ProjectileComponent" ) or {} ) do
    ComponentSetValue2( v, "lifetime", -1 );
end