dofile_once("data/scripts/lib/utilities.lua");
dofile( "data/scripts/game_helpers.lua" );
dofile( "data/scripts/perks/perk.lua" );

function item_pickup( entity_item, entity_who_picked, item_name )
	perk_pickup( entity_item, entity_who_picked, item_name, true, false );
end
