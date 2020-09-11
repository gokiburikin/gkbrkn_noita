dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID();
    if is_fatal then
        local x, y = EntityGetTransform( entity );
        EntityLoad( "data/entities/items/pickup/chest_random.xml", x, y - 8 );
    end
end