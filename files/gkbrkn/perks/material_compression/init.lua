dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_MATERIAL_COMPRESSION", "material_compression", false, function( entity_perk_item, entity_who_picked, item_name )
        local succ_bonus = EntityGetFirstComponent( entity_who_picked, "VariableStorageComponent", "gkbrkn_material_compression" );
        if succ_bonus == nil then
            succ_bonus = EntityAddComponent( entity_who_picked, "VariableStorageComponent", {
                _tags="gkbrkn_material_compression",
                value_string="0"
            });
        end
        ComponentSetValue( succ_bonus, "value_string", tostring( tonumber( ComponentGetValue( succ_bonus, "value_string" ) + 1 ) ) );
	end
) );
