dofile( "data/scripts/utilities.lua" );
dofile( "data/scripts/perks/perk.lua" );
dofile( "data/scripts/perks/perk_list.lua" );
if  _GKBRKN_CONFIG == nil then dofile( "files/gkbrkn/config.lua"); end

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
    if HasFlagPersistent( MISC.RandomStart.RandomCapeColorEnabled ) and cape ~= nil then
        edit_component( cape, "VerletPhysicsComponent", function( comp, vars ) 
            vars.cloth_color = Random( 0xFF000000, 0xFFFFFFFF );
            vars.cloth_color_edge = Random( 0xFF000000, 0xFFFFFFFF );
        end);
    end

    -- randomize starting hp
    local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" );
    if damage_models ~= nil then
        for i,v in pairs(damage_models) do
            local total = rand( MISC.RandomStart.MinimumHP * 0.04, MISC.RandomStart.MaximumHP * 0.04 );
            ComponentSetValue( v, "max_hp", total );
            ComponentSetValue( v, "hp", total );
        end
    end

    -- random wands
    if inventory ~= nil then
        local inventory_items = EntityGetAllChildren( inventory );
        
        if inventory_items ~= nil then
            for i,item_entity in ipairs( inventory_items ) do
                GameKillInventoryItem( player_entity, item_entity );
            end
        end

        local actions_pool = {
            "projectile_actions",
            "cost_actions"
        }
        for i=1,2 do
            if HasFlagPersistent( MISC.RandomStart.DefaultWandGenerationEnabled ) == false then
                local item_entity = EntityLoad( "files/gkbrkn/misc/random_start/random_wand.xml", Random( -1000, 1000 ),  Random( -1000, 1000 ) );
                EntityAddComponent( item_entity, "VariableStorageComponent", {
                    name = "random_start_actions_pool",
                    value_string  = actions_pool[i],
                });
                EntityAddComponent( item_entity, "LuaComponent", {
                    execute_on_added = "1",
                    remove_after_executed = "1",
                    script_source_file = "files/gkbrkn/misc/random_start/wand.lua"
                } );
                EntityAddChild( inventory, item_entity );
            else
                local wand = EntityLoad( "data/entities/items/wand_level_01.xml", Random( -10, 10 ), Random( -10, 10 ) );
                local item = EntityGetFirstComponent( wand, "ItemComponent" );
                ComponentSetValue( item, "play_hover_animation", "0" );
                EntityAddChild( inventory, wand );
            end
        end
        for i=1,MISC.RandomStart.RandomFlasks do
            EntityAddChild( inventory, EntityLoad( "data/entities/items/pickup/potion.xml", Random( -1000, 1000 ), Random( -1000, 1000 ) ) );
        end
    end

    -- random perk
    local random_perk = random_from_array( perk_list ).id;
    local perk_entity = perk_spawn( x, y, random_perk );
    if perk_entity ~= nil then
        perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
    end
end
