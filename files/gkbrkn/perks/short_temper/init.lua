dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_SHORT_TEMPER", "short_temper", true, function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "LuaComponent", {
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/perks/short_temper/damage_received.lua"
        });
    end
) );