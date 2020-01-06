dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
function item_pickup( entity_item, entity_pickupper, item_name )
    clear_lost_treasure( entity_item );
    clear_gold_decay( entity_item );
end 