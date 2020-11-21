local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "data/scripts/perks/perk.lua" );
dofile_once( "data/scripts/perks/perk_list.lua" );

local init_check_flag = "gkbrkn_random_start_init";
if GameHasFlagRun( init_check_flag ) == false then
    GameAddFlagRun( init_check_flag );

    local x,y = EntityGetTransform( player_entity );
    SetRandomSeed( x - 216, y + 5182 );

    local inventory = nil;
    local cape = nil;

    local player_child_entities = EntityGetAllChildren( player_entity );
    if player_child_entities ~= nil then
        for i,child_entity in pairs( player_child_entities ) do
            local name = EntityGetName( child_entity );
            if name == "inventory_quick" then
                inventory = child_entity;
            end
            if name == "cape" then
                cape = child_entity;
            end
        end
    end

    -- random cape colour
    if HasFlagPersistent( MISC.RandomStart.RandomCapeColorFlag ) and cape ~= nil then
        local verlet_physics = EntityGetFirstComponent( cape, "VerletPhysicsComponent" );
        ComponentSetValue2( verlet_physics, "cloth_color",  Random( 0xFF000000, 0xFFFFFFFF ) );
        ComponentSetValue2( verlet_physics, "cloth_color_edge",  Random( 0xFF000000, 0xFFFFFFFF ) );
    end

    -- randomize starting hp
    if HasFlagPersistent( MISC.RandomStart.RandomHealthFlag ) then
        local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" );
        if damage_models ~= nil then
            for i,v in pairs(damage_models) do
                local total = rand( MISC.RandomStart.MinimumHP * 0.04, MISC.RandomStart.MaximumHP * 0.04 );
                ComponentSetValue2( v, "max_hp", total );
                ComponentSetValue2( v, "hp", total );
            end
        end
    end

    -- random wands
    if inventory ~= nil then
        local held_wands = {};
        
        local inventory_items = EntityGetAllChildren( inventory );
        if inventory_items ~= nil then
            for i,item_entity in ipairs( inventory_items ) do
                if EntityHasTag( item_entity, "wand" ) then
                    --GameKillInventoryItem( player_entity, item_entity );
                    table.insert( held_wands, item_entity );
                end
            end
        end

        local generate_wands = {}
        if HasFlagPersistent( MISC.RandomStart.RandomPrimaryWandFlag ) then
            generate_wands[1] = { "projectile_actions"};
        end
        if HasFlagPersistent( MISC.RandomStart.RandomSecondaryWandFlag ) then
            generate_wands[2] = { "cost_actions" };
        end
        if HasFlagPersistent( MISC.RandomStart.RandomExtraWandFlag ) then
            generate_wands[3] = { "projectile_actions" };
        end

        for i,v in pairs(generate_wands) do
            local held_wand = held_wands[i];
            local actions_pool = generate_wands[i][1];
            if HasFlagPersistent( MISC.RandomStart.CustomWandGenerationFlag ) == true then
                local item_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/random_start/random_wand.xml", Random( -1000, 1000 ),  Random( -1000, 1000 ) );
                EntityAddComponent( item_entity, "VariableStorageComponent", {
                    name = "random_start_actions_pool",
                    value_string  = actions_pool,
                });
                EntityAddComponent( item_entity, "LuaComponent", {
                    execute_on_added = "1",
                    remove_after_executed = "1",
                    script_source_file = "mods/gkbrkn_noita/files/gkbrkn/misc/random_start/wand.lua"
                } );
                if held_wand then
                    wand_copy( item_entity, held_wand, true, true );
                    EntityKill( item_entity );
                else
                    EntityAddChild( inventory, item_entity );
                end
            else
                local wand = EntityLoad( "data/entities/items/wand_level_01.xml", Random( -1000, 1000 ), Random( -1000, 1000 ) );
                --local item = EntityGetFirstComponent( wand, "ItemComponent" );
                --ComponentSetValue2( item, "play_hover_animation", false );
                --EntityAddChild( inventory, wand );
                if held_wand then
                    wand_copy( wand, held_wand, true, true );
                    EntityKill( wand );
                else
                    EntityAddChild( inventory, wand );
                end
            end
        end

        if HasFlagPersistent( MISC.RandomStart.RandomFlaskFlag ) then
            local inventory_items = EntityGetAllChildren( inventory );
            local flasks_to_replace = 0;
            if inventory_items ~= nil then
                for i,item_entity in ipairs( inventory_items ) do
                    if EntityHasTag( item_entity, "item_physics" ) then
                        flasks_to_replace = flasks_to_replace + 1;
                        GameKillInventoryItem( player_entity, item_entity );
                    end
                end
            end
        
            for i=1,flasks_to_replace do
                EntityAddChild( inventory, EntityLoad( "data/entities/items/pickup/potion.xml", Random( -1000, 1000 ), Random( -1000, 1000 ) ) );
            end
        end
    end

    -- random perk
    if HasFlagPersistent( MISC.RandomStart.RandomPerkFlag ) then
        local random_perk = random_from_array( perk_list ).id;
        local perk_entity = perk_spawn( x, y, random_perk );
        if perk_entity ~= nil then
            perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
        end
    end
end
