dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_DEMOLITIONIST", "demolitionist", true, function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "LuaComponent", {
            script_shot="mods/gkbrkn_noita/files/gkbrkn/perks/demolitionist/shot.lua"
        });
	end
) );