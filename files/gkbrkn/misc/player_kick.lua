dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua" );

function kick( is_electric )
    if GameHasFlagRun( FLAGS.KickSpellsAround ) then
        local entity = GetUpdatedEntityID();
        local x,y = EntityGetTransform( entity );
        local nearby_actions = EntityGetInRadiusWithTag( x, y, 16, "card_action" ) or {};
        for _,action in pairs( nearby_actions ) do
            local action_parent = EntityGetParent( action );
            if action_parent == nil or action_parent == 0 then
                local ax, ay = EntityGetTransform( action );
                local dx = ax - x;
                ComponentSetValueVector2( EntityGetFirstComponent( action, "VelocityComponent" ), "mVelocity", dx * 8, Random( -100, -50 ) );
            end
        end
    end
    if GameHasFlagRun( FLAGS.KickSpellsOffWands ) then
        local entity = GetUpdatedEntityID();
        local x,y = EntityGetTransform( entity );
        local nearby_wands = EntityGetInRadiusWithTag( x, y, 16, "wand" ) or {};
        for _,wand in pairs( nearby_wands ) do
            local item_cost = EntityGetFirstComponent( wand, "ItemCostComponent" );
            if item_cost == nil or tonumber( ComponentGetValue( item_cost, "cost" ) ) <= 0 then
                local wand_parent = EntityGetParent( wand );
                if wand_parent == nil or wand_parent == 0 then
                    wand_explode_random_action( wand, false );
                end
            end
        end
    end
end