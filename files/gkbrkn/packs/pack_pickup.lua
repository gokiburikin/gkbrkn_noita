local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile( "mods/gkbrkn_noita/files/gkbrkn/content/packs.lua" );

function item_pickup( entity_item, entity_who_picked, item_name )
	local x, y = EntityGetTransform( entity_item );
    -- here we spawn the cards
    local pack_id = EntityGetVariableString( entity_item, "gkbrkn_pack_id" );
    local pack_data = find_pack( pack_id );
    if pack_data then
        local spawn_attempts = 100;
        local card_amounts = {};
        local card_weight_table = {};
        local chosen_cards = {};
        for card_data_index,action in pairs( pack_data.actions ) do
            card_weight_table[card_data_index] = action.weight;
        end
        while #chosen_cards < MISC.PackShops.CardsPerPack and spawn_attempts > 0 do
            local chosen_card_index = WeightedRandomTable( card_weight_table );
            local chosen_card_data = pack_data.actions[ chosen_card_index ];
            if ( chosen_card_data.limit_per_pack or -1 ) > 0 then
                if ( card_amounts[chosen_card_data.id] or 0 ) < chosen_card_data.limit_per_pack then
                    card_amounts[chosen_card_data.id] = (card_amounts[chosen_card_data.id] or 0) + 1;
                    table.insert( chosen_cards, chosen_card_data.id );
                end
            else
                spawn_attempts = spawn_attempts - 1;
            end
        end
        for i=1,MISC.PackShops.RandomCardsPerPack do
            table.insert( chosen_cards, GetRandomAction( x, y, 6, i ) );
        end
        for _,action_id in pairs( chosen_cards ) do
            local action = CreateItemActionEntity( action_id, x, y );
            local velocity = EntityGetFirstComponent( action, "VelocityComponent" );
            if velocity ~= nil then ComponentSetValueVector2( velocity, "mVelocity", Random( -100, 100 ), Random( -25, 25 ) - 100 ); end
        end
    else
        print( "[goki's things] Could not find pack data for "..pack_id );
    end
    EntityKill( entity_item );
end
