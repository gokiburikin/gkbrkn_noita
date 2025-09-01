dofile_once( "data/scripts/items/chest_random.lua" )
local e = GetUpdatedEntityID()
local x, y = EntityGetTransform(e)

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
    item_pickup( e, entity_thats_responsible, name )
end
