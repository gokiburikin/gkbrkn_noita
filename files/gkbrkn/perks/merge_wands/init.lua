dofile_once("data/scripts/lib/utilities.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua");

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_MERGE_WANDS", "merge_wands", false, function( entity_perk_item, entity_who_picked, item_name )
        local x, y = EntityGetTransform( entity_who_picked );

        local held_wands = {};
        local active_wand = nil;
        local children = EntityGetAllChildren( entity_who_picked ) or {};
        local inventory2 = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" );
        if inventory2 ~= nil then
            for key, child in pairs( children ) do
                if EntityGetName( child ) == "inventory_quick" then
                    held_wands = EntityGetChildrenWithTag( child, "wand" ) or {};
                    break;
                end
            end
            for _,wand in pairs( held_wands ) do
                local active_item = tonumber( ComponentGetValue( inventory2, "mActiveItem" ) );
                if wand == active_item then
                    active_wand = wand;
                end
            end
        end

        local comparisons = {
            shuffle_deck_when_empty=function( current_value, previous_value ) if current_value == "false" then return current_value; end end,
            actions_per_round=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
            speed_multiplier=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
            deck_capacity=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
            reload_time=function( current_value, previous_value ) if tonumber(previous_value) > tonumber(current_value) then return current_value; end end,
            fire_rate_wait=function( current_value, previous_value ) if tonumber(previous_value) > tonumber(current_value) then return current_value; end end,
            spread_degrees=function( current_value, previous_value ) if tonumber(previous_value) > tonumber(current_value) then return current_value; end end,
            mana_charge_speed=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
            mana_max=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
            mana=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
        }

        local best_values = {
            shuffle_deck_when_empty="true",
            actions_per_round=1,
            speed_multiplier=1,
            deck_capacity=0,
            reload_time=99999,
            fire_rate_wait=99999,
            spread_degrees=0,
            mana_charge_speed=0,
            mana_max=0,
            mana=0,
        };

        if #held_wands > 0 then
            for _,wand in pairs( held_wands ) do
                local ability = WandGetAbilityComponent( wand, "AbilityComponent" );
                for stat,comparison in pairs( comparisons ) do
                    local current_value = best_values[stat];
                    local outcome = comparison( ability_component_get_stat( ability, stat ), current_value );
                    best_values[stat] = outcome or current_value;
                end
            end
        end

        local held_actions = {};
        for _,wand in pairs( held_wands ) do
            while true do
                if wand == active_wand then
                    local removed_spell = wand_remove_first_action( wand );
                    if not removed_spell then
                        break;
                    else
                        table.insert( held_actions, removed_spell );
                    end
                else
                    if not wand_explode_random_action( wand ) then
                        break;
                    end
                end
            end
            GameKillInventoryItem( entity_who_picked, wand );
            EntitySetTransform( item, -9999, -9999 );
            EntityRemoveFromParent( wand );
        end
            
        if inventory2 ~= nil then
            local inventory2 = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" );
            if inventory2 ~= nil then
                ComponentSetValue( inventory2, "mInitialized", 0 );
                ComponentSetValue( inventory2, "mForceRefresh", 1 );
            end
        end

        local copy_wand = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/placeholder_wand.xml", x, y-8 );
        EntitySetVariableNumber( copy_wand, "gkbrkn_merged_wand", 1 );

        initialize_wand( copy_wand, { name="merged wand", stats=best_values } );

        for _,held_action in pairs( held_actions ) do
            wand_attach_action( copy_wand, held_action );
        end

        local item = EntityGetFirstComponent( copy_wand, "ItemComponent" );
        if item ~= nil then
            ComponentSetValue( item, "play_hover_animation", "1" );
        end
	end
) );