local entity = GetUpdatedEntityID()
local p = EntityGetFirstComponent( entity, "ProjectileComponent" )
if p then
    ComponentSetValue2( p, "collide_with_tag", "gkbrkn_proximity_field_trigger" )
end