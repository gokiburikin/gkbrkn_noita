dofile( "data/scripts/gun/gun_actions.lua" );
dofile_once( "data/scripts/gun/gun_enums.lua" );
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua" );

local action_types = {
    ACTION_TYPE_PROJECTILE,
    ACTION_TYPE_STATIC_PROJECTILE,
    ACTION_TYPE_MODIFIER,
    ACTION_TYPE_DRAW_MANY,
    ACTION_TYPE_MATERIAL,
    ACTION_TYPE_OTHER,
    ACTION_TYPE_UTILITY,
    ACTION_TYPE_PASSIVE
}
local extended_types = {
    ACTION_TYPE_STATIC_PROJECTILE,
    ACTION_TYPE_MATERIAL,
    ACTION_TYPE_OTHER,
    ACTION_TYPE_UTILITY,
    ACTION_TYPE_PASSIVE
};
local action_type_weights  = {
    [ACTION_TYPE_STATIC_PROJECTILE] = 3,
    [ACTION_TYPE_PROJECTILE] = 76,
    [ACTION_TYPE_MODIFIER] = 23,
    [ACTION_TYPE_DRAW_MANY] = 10,
    [ACTION_TYPE_MATERIAL] = 2,
    [ACTION_TYPE_OTHER] = 1,
    [ACTION_TYPE_UTILITY] = 1,
    [ACTION_TYPE_PASSIVE] = 4
}

local chaotic_actions = {};
for _,action in pairs( actions ) do
    chaotic_actions[ action.id ] = 1;
end

local chance_to_replace = 0.03;
local _generate_gun = generate_gun;
function generate_gun( cost, level, force_unshuffle )
    if GlobalsGetValue( "gkbrkn_rerolling_shop", "0" ) == "1" then
        local pull = tonumber( GlobalsGetValue( "gkbrkn_shop_rerolls", "0" ) );
        local _SetRandomSeed = SetRandomSeed;
        SetRandomSeed = function( x, y )
            return _SetRandomSeed( x + pull * 13, y + pull * 127 );
        end
        _generate_gun( cost, level, force_unshuffle );
        SetRandomSeed = _SetRandomSeed;
    else
        _generate_gun( cost, level, force_unshuffle );
    end

    -- NOTE: This can be done better by sorting the local wands array and taking in only the last one, but at least for now this works.
    local held_wands = {};
    local players = EntityGetWithTag("player_unit") or {};
    local wandsmith_stacks = 0;
    local mana_mastery_stacks = 0;
    for _,player in pairs( players ) do
        wandsmith_stacks = wandsmith_stacks + EntityGetVariableNumber( player, "gkbrkn_wandsmith_stacks", 0 );
        mana_mastery_stacks = mana_mastery_stacks + EntityGetVariableNumber( player, "gkbrkn_mana_mastery", 0 );

        local children = EntityGetAllChildren( player ) or {};
        local inventory2 = EntityGetFirstComponent( player, "Inventory2Component" );
        if inventory2 ~= nil then
            for key, child in pairs( children ) do
                if EntityGetName( child ) == "inventory_quick" then
                    local wands_in_hand = EntityGetChildrenWithTag( child, "wand" ) or {};
                    for k,v in pairs( wands_in_hand ) do
                        held_wands[tostring(v)] = true;
                    end
                    break;
                end
            end
        end
    end

    local entity = GetUpdatedEntityID();
    local x,y = EntityGetTransform( entity );
    local local_wands = EntityGetInRadiusWithTag( x, y, 1, "wand" ) or {};

    for _,wand in pairs( local_wands ) do
        if not held_wands[tostring(wand)] then
            local ability = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" );
            if HasFlagPersistent( MISC.AlternativeWandGeneration.EnabledFlag ) then
                local children = EntityGetAllChildren( wand );
                for _,child in ipairs( children ) do
                    local item = EntityGetFirstComponentIncludingDisabled( child, "ItemComponent" );
                    local permanent_action = false;
                    if item ~= nil then
                        if ComponentGetValue2( item, "permanently_attached" ) == true then
                            permanent_action = true;
                        end
                    end
                    EntityRemoveFromParent( child );
                    local child_to_return = child;
                    local item_action = EntityGetFirstComponentIncludingDisabled( child, "ItemActionComponent" );
                    if item_action then
                        local action_id = ComponentGetValue2( item_action, "action_id" );
                        if action_id ~= nil and action_id ~= "" then
                            -- TODO an assert will fail if the action type pool is empty
                            -- not too much that can be done about this right now, doesn't show up outside of dev
                            local weighted_type = WeightedRandomTable( action_type_weights );
                            local action = GetRandomActionWithType( x, y, level or Random(0,6), weighted_type, Random(0,1000)+_+x+y );
                            if action ~= nil and action ~= "" then
                                child_to_return = CreateItemActionEntity( action, x, y );
                                local item = EntityGetFirstComponent( child_to_return, "ItemComponent" );
                                if item ~= nil then
                                    if permanent_action == true  then
                                        ComponentSetValue2( item, "permanently_attached", true );
                                    end
                                end
                                EntitySetComponentsWithTagEnabled( child_to_return, "enabled_in_world", false );
                            end
                        end
                    end
                    EntityAddChild( wand, child_to_return );
                end
            elseif HasFlagPersistent( MISC.ChaoticWandGeneration.EnabledFlag ) then
                local children = EntityGetAllChildren( wand );
                for _,child in ipairs( children ) do
                    local item = EntityGetFirstComponentIncludingDisabled( child, "ItemComponent" );
                    local permanent_action = false;
                    if item ~= nil then
                        if ComponentGetValue2( item, "permanently_attached" ) == true then
                            permanent_action = true;
                        end
                    end
                    EntityRemoveFromParent( child );
                    local child_to_return = child;
                    local item_action = EntityGetFirstComponentIncludingDisabled( child, "ItemActionComponent" );
                    if item_action then
                        local action_id = ComponentGetValue2( item_action, "action_id" );
                        if action_id ~= nil and action_id ~= "" then
                            local action = WeightedRandomTable( chaotic_actions );
                            if action ~= nil and action ~= "" then
                                child_to_return = CreateItemActionEntity( action, x, y );
                                local item = EntityGetFirstComponent( child_to_return, "ItemComponent" );
                                if item ~= nil then
                                    if permanent_action == true  then
                                        ComponentSetValue2( item, "permanently_attached", true );
                                    end
                                end
                                EntitySetComponentsWithTagEnabled( child_to_return, "enabled_in_world", false );
                            end
                        end
                    end
                    EntityAddChild( wand, child_to_return );
                end
            elseif HasFlagPersistent( MISC.ExtendedWandGeneration.EnabledFlag ) then
                local children = EntityGetAllChildren( wand );
                for _,child in ipairs( children ) do
                    local item = EntityGetFirstComponentIncludingDisabled( child, "ItemComponent" );
                    local permanent_action = false;
                    if item ~= nil then
                        if ComponentGetValue2( item, "permanently_attached" ) == true then
                            permanent_action = true;
                        end
                    end
                    EntityRemoveFromParent( child );
                    local child_to_return = child;
                    local item_action = EntityGetFirstComponentIncludingDisabled( child, "ItemActionComponent" );
                    if item_action then
                        local action_id = ComponentGetValue2( item_action, "action_id" );
                        if action_id ~= nil and action_id ~= "" and Random() <= chance_to_replace then
                            -- TODO an assert will fail if the action type pool is empty
                            -- not too much that can be done about this right now, doesn't show up outside of dev
                            local action = GetRandomActionWithType( x, y, level or 6, extended_types[Random(1,#extended_types)], Random(0,1000)+_+x+y );
                            if action ~= nil and action ~= "" then
                                child_to_return = CreateItemActionEntity( action, x, y );
                                local item = EntityGetFirstComponent( child_to_return, "ItemComponent" );
                                if item ~= nil then
                                    if permanent_action == true  then
                                        ComponentSetValue2( item, "permanently_attached", true );
                                    end
                                end
                                EntitySetComponentsWithTagEnabled( child_to_return, "enabled_in_world", false );
                            end
                        end
                    end
                    EntityAddChild( wand, child_to_return );
                end
            end
            if GameHasFlagRun( FLAGS.GuaranteedAlwaysCast ) then
                force_always_cast( wand, 1 )
            end

            if ability ~= nil then
                if GameHasFlagRun( FLAGS.OrderWandsOnly ) then
                    ability_component_set_stat( ability, "shuffle_deck_when_empty", false );
                elseif GameHasFlagRun( FLAGS.ShuffleWandsOnly ) then
                    ability_component_set_stat( ability, "shuffle_deck_when_empty", true );
                end

                if wandsmith_stacks > 0 then
                    ability_component_adjust_stats( ability, {
                        mana_max=function(value) return tonumber( value ) * ( 1.1 ^ wandsmith_stacks ); end,
                        mana_charge_speed=function(value) return ( tonumber( value ) + Random( 10, 20 ) ) * ( 1.1 ^ wandsmith_stacks ); end,
                        deck_capacity=function(value) return math.min( 26, math.floor( tonumber( value ) + wandsmith_stacks * 2 ) ); end,
                        reload_time=function(value) return tonumber( value ) - Random( 8, 16 ) * wandsmith_stacks; end,
                        fire_rate_wait=function(value) return tonumber( value ) - Random( 4, 8 ) * wandsmith_stacks; end,
                        spread_degrees=function(value) return tonumber( value ) - 2 * wandsmith_stacks; end,
                    } );
                end

                if mana_mastery_stacks > 0 then
                    local mana_max = ability_component_get_stat( ability, "mana_max" );
                    local mana_charge_speed = ability_component_get_stat( ability, "mana_charge_speed" );
                    local reallocated = 0.42;
                    local retained = 0.33;
                    local stats = (mana_max + mana_charge_speed) * reallocated;
                    local rand = Random();
                    ability_component_set_stat( ability, "mana_max", (stats * rand) + mana_max * retained );
                    ability_component_set_stat( ability, "mana_charge_speed", (stats * (1 - rand)) + mana_charge_speed * retained );
                end
            end
        end
    end
end