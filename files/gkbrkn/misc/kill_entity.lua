local e = GetUpdatedEntityID()
for k,v in pairs( EntityGetComponent( e, "ProjectileComponent" ) or {} ) do
    ComponentSetValue2( v, "on_death_explode", false )
    ComponentSetValue2( v, "on_lifetime_out_explode", false )
end
EntityKill( e )