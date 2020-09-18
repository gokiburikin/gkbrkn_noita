local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile( "mods/gkbrkn_noita/files/gkbrkn/content/packs.lua" );

function item_pickup( entity_item, entity_who_picked, item_name )
	local x, y = EntityGetTransform( entity_item );
    SetRandomSeed( x, y );
    -- here we spawn the cards
    local pack_id = EntityGetVariableString( entity_item, "gkbrkn_pack_id" );
    local pack_data = find_pack( pack_id );
    if pack_data then
        local chosen_cards = crack_pack( pack_data, x, y );
        for _,action_id in pairs( chosen_cards ) do
            local action = CreateItemActionEntity( action_id, x, y );
            local velocity = EntityGetFirstComponent( action, "VelocityComponent" );
            if velocity ~= nil then ComponentSetValue2( velocity, "mVelocity", Random( -100, 100 ), Random( -25, 25 ) - 100 ); end
        end
    else
        print( "[goki's things] Could not find pack data for "..pack_id );
    end
    EntityKill( entity_item );
end
