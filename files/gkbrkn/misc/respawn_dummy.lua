local entity = GetUpdatedEntityID();
local x,y = EntityGetTransform( entity );
function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
    EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/dummy_target.xml", x, y );
end
