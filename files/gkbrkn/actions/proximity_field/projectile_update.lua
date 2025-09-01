local entity = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity)
if #EntityGetInRadiusWithTag( x, y, 50, "enemy" ) > 0 then
    local trigger_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/proximity_field/trigger_entity.xml" )
    EntityAddChild( entity, trigger_entity )
end