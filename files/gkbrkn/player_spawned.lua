local x, y = EntityGetTransform( player_entity );

if EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_player_update" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_player_update",
        script_source_file="files/gkbrkn/misc/player_update.lua",
        execute_every_n_frame="1",
    });
end

if EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_player_damage_received" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_player_damage_received",
        script_damage_received="files/gkbrkn/misc/player_damage_received.lua",
    });
end

local init_check_flag = "gkbrkn_player_new_game";
if GameHasFlagRun( init_check_flag ) == false then
    GameAddFlagRun( init_check_flag );
    DoFileEnvironment( "files/gkbrkn/misc/random_start/init.lua", { player_entity = player_entity } );
    EntityAddComponent( player_entity, "LuaComponent", {
        script_shot="files/gkbrkn/misc/projectile_shot.lua"
    });
end

--[[
if HasFlagPersistent( MISC.GoldPickupTracker.ShowTrackerEnabled ) or HasFlagPersistent( MISC.GoldPickupTracker.ShowMessageEnabled ) then
    if EntityGetFirstComponent( player_entity, "SpriteComponent", "gkbrkn_gold_tracker" ) == nil then
        EntityAddComponent( player_entity, "LuaComponent", {
            script_source_file="files/gkbrkn/misc/gold_tracking/player_update.lua",
            execute_on_added="1",
            execute_every_n_frame="1",
        });
    end
end
]]
if SETTINGS.Debug then 
    --local effect = GetGameEffectLoadTo( player_entity, "NO_DAMAGE_FLASH", true );
    --if effect ~= nil then ComponentSetValue( effect, "frames", "-1" ); end
    if GameHasFlagRun("gkbrkn_debug_player_spawned") == false then
        GameAddFlagRun("gkbrkn_debug_player_spawned");
        dofile_once( "data/scripts/perks/perk.lua");
        dofile_once( "data/scripts/gun/procedural/gun_action_utils.lua" );
        --dofile( "data/scripts/items/generate_shop_item.lua" );

        --TryGivePerk( player_entity, "MOVEMENT_FASTER" );
        --TryGivePerk( player_entity, "MOVEMENT_FASTER" );
        --TryGivePerk( player_entity, "MOVEMENT_FASTER" );
        --TryGivePerk( player_entity, "MOVEMENT_FASTER" );
        --TryGivePerk( player_entity, "GKBRKN_RAPID_FIRE" );
        --perk_spawn( x + 20, y - 20, "GKBRKN_FRAGILE_EGO" );
        --perk_spawn( x - 20, y - 20, "GKBRKN_PROTAGONIST" );
        --perk_spawn( x, y - 20, "GKBRKN_ALWAYS_CAST" );

        local inventory2 = EntityGetFirstComponent( player_entity, "Inventory2Component" );
        if inventory2 ~= nil then
            ComponentSetValue( inventory2, "full_inventory_slots_y", 5 );
        end
        
        local x, y = EntityGetTransform( player_entity );
        local inventory = EntityGetNamedChild( player_entity, "inventory_quick" );
        if inventory ~= nil then
            --[[
            local inventory_items = EntityGetAllChildren( inventory );
            if inventory_items ~= nil then
                for i,item_entity in ipairs( inventory_items ) do
                    local item = EntityGetFirstComponent( item_entity, "ItemComponent" );
                    GamePrint( tostring( item ) or "nil");
                end
            end
            ]]
            EntityAddChild( inventory, CreateWand( x, y, 
                "SPEED","SPEED","LIFETIME","BLACK_HOLE","BLACK_HOLE","BLACK_HOLE","BLACK_HOLE"
            ));
            EntityAddChild( inventory, CreateWand( x, y, 
                "GKBRKN_PATH_CORRECTION","GKBRKN_PIERCING_SHOT","GKBRKN_SPECTRAL_SHOT","SPEED","BOUNCY_ORB"
            ));
            --[[
            EntityAddChild( inventory, CreateWand( x, y, 
                "GKBRKN_ACTION_WIP","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","BUBBLESHOT"
            ));
            EntityAddChild( inventory, CreateWand( x, y, 
                "CHAOTIC_ARC","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","GKBRKN_DOUBLE_CAST","RUBBER_BALL"
            ));
            ]]
            --[[
            EntityAddChild( inventory, CreateWand( x, y, 
                "GKBRKN_MANA_RECHARGE","GKBRKN_MANA_RECHARGE","CRITICAL_HIT","DAMAGE","HEAVY_SHOT","GKBRKN_DRAW_DECK"
                ,"GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","CHAINSAW"
            ));
            ]]
        end

        --local screen_fill = EntityLoad( "files/gkbrkn/misc/screen_fill.xml", 0, 0 );
        --EntityAddChild( player_entity, screen_fill );

        --[[
        ]]
        --EntityLoad( "data/entities/animals/tank.xml", x - 80, y );
        EntityLoad( "data/entities/items/pickup/heart.xml", x + 40, y );
        for i=1,10 do
            EntityLoad( "data/entities/items/pickup/goldnugget.xml", x - 40, y - 20 );
        end
        --[[
        generate_shop_wand( x-40, y, false );
        generate_shop_wand( x-20, y, false );
        generate_shop_wand( x, y, false );
        generate_shop_wand( x+20, y, false );
        generate_shop_wand( x+40, y, false );
        ]]
        --EntityLoad( "data/entities/projectiles/deck/touch_gold.xml", x +30, y + 20 );
    end
end
