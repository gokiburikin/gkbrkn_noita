function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity    = GetUpdatedEntityID();
	local x, y = EntityGetTransform( entity );
    local options = {
        "data/entities/animals/longleg.xml",
        "data/entities/animals/rat.xml",
        "data/entities/animals/miniblob.xml",
    };
    SetRandomSeed( GameGetFrameNum(), x + y + entity );
    for i=1,Random(3,6) do 
        local add = EntityLoad( options[Random(1,#options)], x + Random( -2, 2 ), y + Random( -12, -8 ) );
        EntityAddTag( add, "gkbrkn_no_champion" );
    end
end