local x, y = EntityGetTransform( player_entity );

if HasFlagPersistent( MISC.RandomStart.Enabled ) then
    DoFileEnvironment( "files/gkbrkn/misc/random_start/init.lua", { player_entity = player_entity } );
end

if HasFlagPersistent( MISC.GoldPickupTracker.ShowTrackerEnabled ) or HasFlagPersistent( MISC.GoldPickupTracker.ShowMessageEnabled ) then
    if EntityGetFirstComponent( player_entity, "SpriteComponent", "gkbrkn_gold_tracker" ) == nil then
        EntityAddComponent( player_entity, "SpriteComponent", { 
            _tags="gkbrkn_gold_tracker,enabled_in_world",
            image_file="files/gkbrkn/font_pixel_white.xml", 
            emissive="1",
            is_text_sprite="1",
            offset_x="8", 
            offset_y="-4", 
            update_transform="1" ,
            update_transform_rotation="0",
            text="",
            has_special_scale="1",
            special_scale_x="0.6667",
            special_scale_y="0.6667",
            z_index="1.6",
        } );
        EntityAddComponent( player_entity, "LuaComponent", {
            script_source_file="files/gkbrkn/misc/gold_tracking.lua",
            execute_on_added="1",
            execute_every_n_frame="1",
        });
    end
end


--[[
local jetpack_component = EntityGetFirstComponent( player_entity, "ParticleEmitterComponent" );
while jetpack_component ~= nil do
    EntitySetComponentIsEnabled( player_entity, jetpack_component, false );
    GamePrint( "disabled "..jetpack_component );
    jetpack_component = EntityGetFirstComponent( player_entity, "jetpack" );
end
]]

--[[
local platforming = EntityGetComponent( player_entity, "CharacterPlatformingComponent" )
if platforming ~= nil then
    for i,component in ipairs(platforming) do
        ComponentSetValue( component, "fly_speed_max_up", "10000" );
        ComponentSetValue( component, "fly_speed_max_down", "10000" );
    end
end
]]

if HasFlagPersistent( MISC.InvincibilityFrames.Enabled ) then
    EntitySetVariableNumber( player_entity, "gkbrkn_invincibility_frames", MISC.InvincibilityFrames.Duration or 0 )
end

if EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_invincibility_frames" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_invincibility_frames",
        execute_every_n_frame="-1",
        script_damage_received="files/gkbrkn/misc/invincibility_frames.lua",
    });
end

if HasFlagPersistent( MISC.InvincibilityFrames.FlashEnabled ) and EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_invincibility_frames_flash" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_invincibility_frames_flash",
        script_source_file="files/gkbrkn/misc/invincibility_frames_flash.lua",
        execute_every_n_frame="1",
    });
end

EntityAddComponent( player_entity, "LuaComponent", {
    script_source_file="files/gkbrkn/perks/mana_recovery/player_update.lua",
    execute_every_n_frame="1",
});

if HasFlagPersistent( MISC.HealOnMaxHealthUp.Enabled ) then
    local target = 1.0;
    if HasFlagPersistent( MISC.HealOnMaxHealthUp.FullHeal ) then
        target = 1000.0;
    end
    if EntityGetVariableString( player_entity, "gkbrkn_max_health_recovery", 0.0 ) < target then
        EntitySetVariableString( player_entity, "gkbrkn_max_health_recovery", target );
    end
end

if EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_max_health_heal" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_max_health_heal",
        script_source_file="files/gkbrkn/misc/max_health_heal.lua",
        execute_on_added="1",
        execute_every_n_frame="1",
    });
end

if CONTENT[PERKS.LostTreasure].enabled() and EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_lost_treasure" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_lost_treasure",
        script_source_file="files/gkbrkn/perks/lost_treasure/player_update.lua",
        execute_every_n_frame="10"
    });
end

if HasFlagPersistent( MISC.QuickSwap.Enabled ) then
    local quick_swap_inventory = EntityCreateNew("gkbrkn_swap_inventory");
    EntityAddChild( player_entity, quick_swap_inventory );
end

EntityLoad('files/gkbrkn/gui/container.xml');

if SETTINGS.Debug then 
    dofile( "data/scripts/perks/perk.lua");
    dofile( "data/scripts/gun/procedural/gun_action_utils.lua" );

    --TryGivePerk( player_entity, "MOVEMENT_FASTER" );
    --TryGivePerk( player_entity, "MOVEMENT_FASTER" );
    --TryGivePerk( player_entity, "MOVEMENT_FASTER" );
    --TryGivePerk( player_entity, "MOVEMENT_FASTER" );
    --TryGivePerk( player_entity, "GKBRKN_RAPID_FIRE" );
    --TryGivePerk( player_entity, "GKBRKN_RAPID_FIRE" );
    perk_spawn( x, y, "GKBRKN_RESILIENCE" );
    --perk_spawn( x + 20, y - 20, "GKBRKN_MATERIAL_COMPRESSION" );

    GamePrint( player_entity );
    
    local effect = GetGameEffectLoadTo( player_entity, "EDIT_WANDS_EVERYWHERE", true );
    if effect ~= nil then ComponentSetValue( effect, "frames", "-1" ); end

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
                GameKillInventoryItem( player_entity, item_entity );
            end
        end
        ]]

        EntityAddChild( inventory, CreateWand( x, y, 
        "GKBRKN_MANA_RECHARGE","GKBRKN_MANA_RECHARGE","GKBRKN_MANA_RECHARGE","GKBRKN_PROJECTILE_EQUALIZATION","GKBRKN_DRAW_DECK","LIGHT_BULLET","HEAVY_BULLET","SLOW_BULLET","RUBBER_BALL"
        ));
        EntityAddChild( inventory, CreateWand( x, y, 
            "GKBRKN_MANA_RECHARGE","GKBRKN_MANA_RECHARGE","GKBRKN_MANA_RECHARGE","SPEED","BLACK_HOLE","SPEED","BLACK_HOLE","SPEED","BLACK_HOLE"
        ));
        --[[
        EntityAddChild( inventory, CreateWand( x, y, 
            "GKBRKN_MANA_RECHARGE","GKBRKN_MANA_RECHARGE","CRITICAL_HIT","DAMAGE","HEAVY_SHOT","GKBRKN_DRAW_DECK"
            ,"GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","GKBRKN_DUPLICATE_SPELL","CHAINSAW"
        ));
        ]]
    end

    --local screen_fill = EntityLoad( "files/gkbrkn/misc/screen_fill.xml", 0, 0 );
    --EntityAddChild( player_entity, screen_fill );

    --EntityLoad( "data/entities/animals/sniper.xml", x + 80, y );
    local target_dummy = EntityLoad( "data/entities/animals/chest_mimic.xml", x + 80, y );
    local damage_models = EntityGetComponent( target_dummy, "DamageModelComponent" );
    for _,damage_model in pairs( damage_models ) do
        ComponentSetValue( damage_model, "max_hp", 1000 );
        ComponentSetValue( damage_model, "hp", 1000 );
    end

    --[[
    ]]
    EntityLoad( "data/entities/items/pickup/heart.xml", x + 40, y );
    for i=1,10 do
        EntityLoad( "data/entities/items/pickup/goldnugget.xml", x - 40, y - 20 );
    end
    --EntityLoad( "data/entities/projectiles/deck/touch_gold.xml", x +30, y + 20 );
end
