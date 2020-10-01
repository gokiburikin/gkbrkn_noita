function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity = GetUpdatedEntityID();
	local x, y = EntityGetTransform( entity );
    local options = {
        { filepath="data/entities/animals/longleg.xml", min=3, max=6 },
        { filepath="data/entities/animals/rat.xml", min=2, max=4 },
        { filepath="data/entities/animals/miniblob.xml", min=1, max=2 },
        { filepath="data/entities/animals/frog.xml", min=1, max=2 },
        { filepath="data/entities/animals/frog_big.xml", min=1, max=1 },
        { filepath="data/entities/animals/worm_tiny.xml", min=1, max=1 },
    };
    SetRandomSeed( GameGetFrameNum(), x + y + entity );
    local option = options[Random(1, #options)];
    local amount = Random( option.min, option.max );
    for i=1,amount do 
        local add = EntityLoad( option.filepath, x + Random( -2, 2 ), y + Random( -12, -8 ) );
        EntityAddTag( add, "gkbrkn_no_champion" );
    end
end