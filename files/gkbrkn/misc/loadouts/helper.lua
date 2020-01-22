dofile( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "data/scripts/perks/perk.lua" );
dofile_once("data/scripts/lib/utilities.lua");
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua");

function get_random_from( target )
    return tostring( Random( 1, #target ) );
end

function get_random_between_range( target )
    local min = target[1];
    local max = target[2];
    return Random( min, max );
end

local WAND_STAT_SETTER = {
    Direct = 1,
    Gun = 2,
    GunAction = 3
}

local WAND_STAT_SETTERS = {
    shuffle_deck_when_empty = WAND_STAT_SETTER.Gun,
    actions_per_round = WAND_STAT_SETTER.Gun,
    speed_multiplier = WAND_STAT_SETTER.GunAction,
    deck_capacity = WAND_STAT_SETTER.Gun,
    reload_time = WAND_STAT_SETTER.Gun,
    fire_rate_wait = WAND_STAT_SETTER.GunAction,
    spread_degrees = WAND_STAT_SETTER.GunAction,
    mana_charge_speed = WAND_STAT_SETTER.Direct,
    mana_max = WAND_STAT_SETTER.Direct,
}

function ability_component_set_stat( ability, stat, value )
    local setter = WAND_STAT_SETTERS[stat];
    if setter ~= nil then
        if setter == WAND_STAT_SETTER.Direct then
            ComponentSetValue( ability, stat, tostring( value ) );
            if stat == "mana_max" then
                ComponentSetValue( ability, "mana", tostring( value ) );
            end
        elseif setter == WAND_STAT_SETTER.Gun then
            ComponentObjectSetValue( ability, "gun_config", stat, tostring( value ) );
        elseif setter == WAND_STAT_SETTER.GunAction then
            ComponentObjectSetValue( ability, "gunaction_config", stat, tostring( value ) );
        end
    end
end

function handle_loadout( player_entity, loadout_data )
    local x, y = EntityGetTransform( player_entity );
    -- find the quick inventory, player cape and arm
    local inventory = nil;
    local full_inventory = nil;
    local cape = nil;
    local player_arm = nil;
    local player_child_entities = EntityGetAllChildren( player_entity );
    if player_child_entities ~= nil then
        for i,child_entity in ipairs( player_child_entities ) do
            local child_entity_name = EntityGetName( child_entity );
            
            if child_entity_name == "inventory_quick" then
                inventory = child_entity;
            elseif child_entity_name == "inventory_full" then
                full_inventory = child_entity;
            elseif child_entity_name == "cape" then
                cape = child_entity;
            elseif child_entity_name == "arm_r" then
                player_arm = child_entity;
            end
        end
    end

    -- set cape colour
    if HasFlagPersistent( MISC.Loadouts.CapeColorEnabled ) then
        local verlet = EntityGetFirstComponent( cape, "VerletPhysicsComponent" );
        if verlet ~= nil then
            if loadout_data.cape_color ~= nil then
                ComponentSetValue( verlet, "cloth_color", loadout_data.cape_color );
            end
            if loadout_data.cape_color_edge ~= nil then
                ComponentSetValue( verlet, "cloth_color_edge", loadout_data.cape_color_edge );
            end
        end
    end

    -- set inventory contents
    if inventory ~= nil then
        local inventory_items = EntityGetAllChildren( inventory );
        local default_wands = {};
        local other_items = {};
        -- remove default items
        if inventory_items ~= nil then
            for i,item_entity in ipairs( inventory_items ) do
                if EntityHasTag( item_entity, "wand" ) then
                    table.insert( default_wands, item_entity );
                else
                    table.insert( other_items, item_entity );
                end
            end
        end

        if loadout_data.items ~= nil then
            for _,item in pairs( other_items ) do
                GameKillInventoryItem( player_entity, item );
            end
            other_items = {};
            for _,item_choice in pairs( loadout_data.items or {} ) do
                local random_item = item_choice[ Random( 1, #item_choice ) ];
                local item = EntityLoad( random_item, x, y );
                EntityAddChild( inventory, item );
            end
        end

        if loadout_data.wands ~= nil then
            for _,wand in pairs(default_wands) do
                GameKillInventoryItem( player_entity, wand );
            end
            default_wands = {};
            for wand_index,wand_data in pairs( loadout_data.wands ) do
                local wand = EntityLoad( wand_data.custom_file or "mods/gkbrkn_noita/files/gkbrkn_loadouts/wands/wand_"..( ( wand_index - 1 ) % 4 + 1 )..".xml", x, y );
                SetRandomSeed( x, y );

                EntitySetVariableNumber( wand, "gkbrkn_loadout_wand", 1 );

                local ability = EntityGetFirstComponent( wand, "AbilityComponent" );
                ComponentSetValue( ability, "ui_name", wand_data.name );
                if wand_data.sprite ~= nil then
                    if wand_data.sprite.file ~= nil then
                        ComponentSetValue( ability, "sprite_file", wand_data.sprite.file );
                        -- TODO this takes a second to apply, probably work fixing, but for now just prefer using custom file
                        local sprite = EntityGetFirstComponent( wand, "SpriteComponent", "item" );
                        if sprite ~= nil then
                            ComponentSetValue( sprite, "image_file", wand_data.sprite.file );
                        end
                    end
                    if wand_data.sprite.hotspot ~= nil then
                        local hotspot = EntityGetFirstComponent( wand, "HotspotComponent", "shoot_pos" );
                        if hotspot ~= nil then
                            ComponentSetValueVector2( hotspot, "offset", wand_data.sprite.hotspot.x, wand_data.sprite.hotspot.y );
                        end
                    end
                end

                local item = EntityGetFirstComponent( wand, "ItemComponent" );
                if item ~= nil then
                    ComponentSetValue( item, "item_name", wand_data.name );
                end

                for stat,value in pairs( wand_data.stats or {} ) do
                    ability_component_set_stat( ability, stat, value );
                end

                for stat,range in pairs( wand_data.stat_ranges or {} ) do
                    ability_component_set_stat( ability, stat, Random( range[1], range[2] ) );
                end

                for stat,random_values in pairs( wand_data.stat_randoms or {} ) do
                    ability_component_set_stat( ability, stat, random_values[ Random( 1, #random_values ) ] );
                end

                for _,actions in pairs( wand_data.permanent_actions or {} ) do
                    local random_action = actions[ Random( 1, #actions ) ];
                    if random_action ~= nil then
                        AddGunActionPermanent( wand, random_action );
                    end
                end

                for _,actions in pairs( wand_data.actions or {} ) do
                    local random_action = actions[ Random( 1, #actions ) ];
                    if random_action ~= nil then
                        if type(random_action) == "table" then
                            local action_entity = CreateItemActionEntity( random_action.action );
                            local component = EntityGetFirstComponent( action_entity, "ItemComponent" );
                            if random_action.locked then
                                ComponentSetValue( component, "is_frozen", "1" );
                            end
                            if random_action.permanent then
                                ComponentSetValue( component, "permanently_attached", "1" );
                            end
                            EntityAddChild( wand, action_entity );
                        else
                            AddGunAction( wand, random_action );
                        end
                    end
                end

                if wand_data.callback ~= nil then
                    wand_data.callback( wand, ability );
                end

                EntitySetComponentsWithTagEnabled( wand, "enabled_in_world", false );
                EntityAddChild( inventory, wand );
            end
        end

        if loadout_data.potions ~= nil then
            for _,item in pairs( other_items ) do
                GameKillInventoryItem( player_entity, item );
            end
            other_items = {};
            -- add loadout items
            for _,potion_data in pairs( loadout_data.potions or {} ) do
                local choice = potion_data[ Random( 1, #potion_data ) ];
                if choice ~= nil then
                    local potion = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn_loadouts/potion_base.xml", x, y );
                    local material_inventory = EntityGetFirstComponent( potion, "MaterialInventoryComponent" );
                    for _,material_data in pairs( choice ) do
                        if material_data ~= nil then
                            local material = material_data[1];
                            local amount = material_data[2];
                            AddMaterialInventoryMaterial( potion, material, amount );
                        end
                    end
                    EntitySetComponentsWithTagEnabled( potion, "enabled_in_world", false );
                    EntityAddChild( inventory, potion );
                end
            end
        end
    end

    -- set inventory contents
    if full_inventory ~= nil then
        if loadout_data.actions ~= nil then
            for _,actions in pairs( loadout_data.actions ) do
                local action = actions[ Random( 1, #actions ) ];
                local action_card = CreateItemActionEntity( action, x, y );
                EntitySetComponentsWithTagEnabled( action_card, "enabled_in_world", false );
                EntityAddChild( full_inventory, action_card );
            end
        end
    end

    -- spawn perks
    if loadout_data.perks ~= nil then
        for _,perk_choices in pairs( loadout_data.perks ) do
            local perk = perk_choices[ Random( 1, #perk_choices ) ];
            if perk ~= nil then
                local perk_entity = perk_spawn( x, y, perk );
                if perk_entity ~= nil then
                    perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
                end
            end
        end	
    end

    if HasFlagPersistent( MISC.Loadouts.PlayerSpritesEnabled ) and loadout_data.sprites ~= nil then
        if loadout_data.sprites.player_sprite_filepath ~= nil then
            local player_sprite_component = EntityGetFirstComponent( player_entity, "SpriteComponent" );
            local player_sprite_file = loadout_data.sprites.player_sprite_filepath;
            ComponentSetValue( player_sprite_component, "image_file", player_sprite_file );
        end

        if loadout_data.sprites.player_arm_sprite_filepath ~= nil then
            local player_arm_sprite_component = EntityGetFirstComponent( player_arm, "SpriteComponent" );
            local player_arm_sprite_file = loadout_data.sprites.player_arm_sprite_filepath;
            ComponentSetValue( player_arm_sprite_component, "image_file", player_arm_sprite_file );
        end

        if loadout_data.sprites.player_ragdoll_filepath ~= nil then
            local player_ragdoll_component = EntityGetFirstComponent( player_entity, "DamageModelComponent" );
            local player_ragdoll_file = loadout_data.sprites.player_ragdoll_filepath;
            ComponentSetValue( player_ragdoll_component, "ragdoll_filenames_file", player_ragdoll_file );
        end
    end
end