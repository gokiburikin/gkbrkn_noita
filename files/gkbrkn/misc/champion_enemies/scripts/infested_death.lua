function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity    = GetUpdatedEntityID();
	local x, y = EntityGetTransform( entity );
    local options = {
        "data/entities/animals/longleg.xml",
        "data/entities/animals/rat.xml",
        "data/entities/animals/miniblob.xml",
    };
    for i=1,Random(2,4) do 
        EntityLoad( options[Random(1,#options)], x + Random( -2, 2 ), y + Random( -12, -8 ) );
    end
end