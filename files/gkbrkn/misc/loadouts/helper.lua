dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua" );
dofile_once( "data/scripts/perks/perk.lua" );
dofile_once( "data/scripts/lib/utilities.lua" );
dofile_once( "data/scripts/gun/procedural/gun_action_utils.lua" );
dofile_once( "data/scripts/gun/procedural/gun_procedural.lua" );
dofile_once( "data/scripts/gun/procedural/wands.lua" );

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

    local removed_items = {};
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
                -- this prevents potion breaking sounds
                EntitySetTransform( item, -9999, -9999 );
                EntityRemoveFromParent( item );
                table.insert( removed_items, item );
            end
            other_items = {};
        end

        if loadout_data.wands ~= nil then
            for _,wand in pairs( default_wands ) do
                GameKillInventoryItem( player_entity, wand );
                -- this prevents potion breaking sounds
                EntitySetTransform( item, -9999, -9999 );
                EntityRemoveFromParent( wand );
                table.insert( removed_items, wand );
            end
            default_wands = {};
        end

        if loadout_data.potions ~= nil then
            for _,item in pairs( other_items ) do
                GameKillInventoryItem( player_entity, item );
                -- this prevents potion breaking sounds
                EntitySetTransform( item, -9999, -9999 );
                EntityRemoveFromParent( item );
                table.insert( removed_items, item );
            end
            other_items = {};
        end

        if loadout_data.items ~= nil then
            for _,item_choice in pairs( loadout_data.items or {} ) do
                local random_item = item_choice[ Random( 1, #item_choice ) ];
                local item = EntityLoad( random_item, x, y );
                EntityAddChild( inventory, item );
            end
        end

        if loadout_data.wands ~= nil then
            for wand_index,wand_data in pairs( loadout_data.wands ) do
                local wand = EntityLoad( wand_data.custom_file or "mods/gkbrkn_noita/files/gkbrkn_loadouts/wands/wand_"..( ( wand_index - 1 ) % 4 + 1 )..".xml", x, y );
                SetRandomSeed( x, y );

                EntitySetVariableNumber( wand, "gkbrkn_loadout_wand", 1 );
                initialize_wand( wand, wand_data );
                EntityAddChild( inventory, wand );
                EntitySetComponentsWithTagEnabled( wand, "enabled_in_world", false );
            end
        end

        if loadout_data.potions ~= nil then
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
                    EntityAddChild( inventory, potion );
                    EntitySetComponentsWithTagEnabled( potion, "enabled_in_world", false );
                end
            end
        end
    end

    if full_inventory ~= nil then
        if loadout_data.actions ~= nil then
            for _,actions in pairs( loadout_data.actions ) do
                local action = actions[ Random( 1, #actions ) ];
                local action_card = CreateItemActionEntity( action, x, y );
                EntityAddChild( full_inventory, action_card );
                EntitySetComponentsWithTagEnabled( action_card, "enabled_in_world", false );
            end
        end
    end

    local inventory2 = EntityGetFirstComponent( player_entity, "Inventory2Component" );
    if inventory2 ~= nil then
        ComponentSetValue( inventory2, "mInitialized", 0 );
        ComponentSetValue( inventory2, "mForceRefresh", 1 );
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