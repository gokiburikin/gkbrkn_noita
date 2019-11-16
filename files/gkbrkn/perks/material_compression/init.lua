table.insert( perk_list, {
	id = "GKBRKN_MATERIAL_COMPRESSION",
	ui_name = "Material Compression",
	ui_description = "Your flasks can now hold twice as much",
	ui_icon = "files/gkbrkn/perks/material_compression/icon_ui.png",
    perk_icon = "files/gkbrkn/perks/material_compression/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        local succ_bonus = EntityGetFirstComponent( entity_who_picked, "VariableStorageComponent", "gkbrkn_material_compression" );
        if succ_bonus == nil then
            succ_bonus = EntityAddComponent( entity_who_picked, "VariableStorageComponent", {
                _tags="gkbrkn_material_compression",
                value_string="0"
            });
        end
        ComponentSetValue( succ_bonus, "value_string", tostring( tonumber( ComponentGetValue( succ_bonus, "value_string" ) + 1 ) ) );
	end,
});
