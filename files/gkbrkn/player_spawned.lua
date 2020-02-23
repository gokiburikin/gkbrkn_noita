dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua" );
local x, y = EntityGetTransform( player_entity );

--[[
local spells_to_add = {"TRANSMUTATION"};
local children = EntityGetAllChildren( player_entity );
if children ~= nil then
    for index,child_entity in pairs( children ) do
        if EntityGetName( child_entity ) == "inventory_full" then
            for _,action in pairs( spells_to_add ) do
                local action_card = CreateItemActionEntity( action, x, y );
                EntitySetComponentsWithTagEnabled( action_card, "enabled_in_world", false );
                EntityAddChild( child_entity, action_card );
            end
            break;
        end
    end
end
]]

--[[
for i=1,50 do
    EntityLoad( "data/entities/animals/longleg.xml", x - 100, y - 100 );
end
for i=1,50 do
    EntityLoad( "data/entities/animals/zombie.xml", x- 100, y - 100 );
end
]]

if EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_player_update" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_player_update",
        script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/player_update.lua",
        execute_every_n_frame="1",
    });
end

if EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_player_damage_received" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_player_damage_received",
        script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/player_damage_received.lua",
    });
end

local init_check_flag = "gkbrkn_player_new_game";
if GameHasFlagRun( init_check_flag ) == false then
    GameAddFlagRun( init_check_flag );
    DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/init.lua", { player_entity = player_entity } );
    DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/misc/random_start/init.lua", { player_entity = player_entity } );

    --[[
        local children = EntityGetAllChildren( player_entity ) or {};
        local inventory = nil;
        for _,child in pairs( children ) do
            if EntityGetName( child ) == "inventory_quick" then
                inventory = child;
            end
        end
        
        if inventory ~= nil then
            local items = EntityGetAllChildren( inventory );
            for _,child in pairs( items ) do
                if EntityHasTag( child, "wand" ) then 
                    ComponentSetValue( child, "ItemComponent", "1" );
                end
            end
        end
    ]]

    EntityAddComponent( player_entity, "LuaComponent", {
        script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/player_shot.lua"
    });

    EntityAddComponent( player_entity, "LuaComponent", {
        script_kick="mods/gkbrkn_noita/files/gkbrkn/misc/player_kick.lua"
    });

    local inventory = EntityGetNamedChild( player_entity, "inventory_quick" );
    if inventory ~= nil then
        --[[ Spell Bag ]]
        if CONTENT[ITEMS.SpellBag].enabled() then
            EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/items/spell_bag/item.xml", x + 20, y - 10 );
        end
    end

    --EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/legendary_wand.xml", x + 200, y - 40 );

    EntityAddComponent( player_entity, "LuaComponent", {
        script_source_file="mods/gkbrkn_noita/files/gkbrkn/events/event_loop.lua",
        enable_coroutines="1",
        execute_on_added="1",
        execute_times="1",
        execute_every_n_frame="-1",
    });

    --[[ Hero Mode ]]
    if HasFlagPersistent( MISC.HeroMode.Enabled ) then
        GameAddFlagRun( MISC.HeroMode.Enabled );
        if HasFlagPersistent( MISC.HeroMode.OrbsDifficultyEnabled ) then
            GameAddFlagRun( MISC.HeroMode.OrbsDifficultyEnabled );
        end
        if HasFlagPersistent( MISC.HeroMode.DistanceDifficultyEnabled ) then
            GameAddFlagRun( MISC.HeroMode.DistanceDifficultyEnabled );
        end
        if HasFlagPersistent( MISC.HeroMode.CarnageDifficultyEnabled ) then
            GameAddFlagRun( MISC.HeroMode.CarnageDifficultyEnabled );
        end
        if HasFlagPersistent( MISC.Badges.Enabled ) then
            local badge = load_dynamic_badge( "hero_mode", {
                {_distance=GameHasFlagRun( MISC.HeroMode.DistanceDifficultyEnabled )},
                {_orbs=GameHasFlagRun( MISC.HeroMode.OrbsDifficultyEnabled )},
                {_carnage=GameHasFlagRun( MISC.HeroMode.CarnageDifficultyEnabled )},
            }, gkbrkn_localization );
            EntityAddChild( player_entity, badge );

            if GameHasFlagRun( MISC.HeroMode.CarnageDifficultyEnabled ) == false then
                local character_platforming = EntityGetFirstComponent( player_entity, "CharacterPlatformingComponent" );
                if character_platforming ~= nil then
                    local speed_multiplier = 1.25;
                    local fly_velocity_x = tonumber( ComponentGetMetaCustom( character_platforming, "fly_velocity_x" ) );
                    ComponentAdjustValues( character_platforming, {
                        jump_velocity_x = function(value) return tonumber( value ) * speed_multiplier; end,
                        jump_velocity_y = function(value) return tonumber( value ) * speed_multiplier; end,
                        fly_smooth_y = function(value) return "0"; end,
                        fly_speed_mult = function(value) return tonumber( fly_velocity_x ) * speed_multiplier; end,
                        fly_speed_max_up = function(value) return tonumber( fly_velocity_x ) * 1.5; end,
                        fly_speed_max_down = function(value) return tonumber( fly_velocity_x ) * 1.5; end,
                        fly_speed_change_spd = function(value) return tonumber( fly_velocity_x ) * speed_multiplier; end,
                    });
                    ComponentAdjustMetaCustoms( character_platforming, {
                        fly_velocity_x = function(value) return fly_velocity_x * speed_multiplier; end,
                        run_velocity = function(value) return tonumber( value ) * speed_multiplier; end,
                        --velocity_min_x = function(value) return tonumber( value ) * speed_multiplier; end,
                        velocity_max_x = function(value) return tonumber( value ) * speed_multiplier; end,
                        velocity_max_y = function(value) return tonumber( value ) * speed_multiplier; end,
                    });
                end
            else
                local cursed_player = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/cursed_player.xml" );
                EntityAddChild( player_entity, cursed_player );
                GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", 1 );
                GlobalsSetValue( "TEMPLE_PERK_COUNT", 2 );
                GlobalsSetValue( "TEMPLE_SHOP_ITEM_COUNT", 3 );
                GamePlaySound( "data/audio/Desktop/event_cues.snd", "event_cues/sampo_pick/create", x, y );
                GamePlaySound( "data/audio/Desktop/event_cues.snd", "event_cues/orb_distant_monster/create", x, y );
                GameScreenshake( 500 );
		        EntityAddChild( player_entity, child_id );
		        GamePrintImportant( gkbrkn_localization.ui_carnage_warning, gkbrkn_localization.ui_carnage_warning_note );
                local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" );
                if damage_models ~= nil then
                    local resistances = {
                        ice = 2.0,
                        electricity = 2.0,
                        radioactive = 2.0,
                        slice = 2.0,
                        projectile = 2.0,
                        healing = 0.5,
                        physics_hit = 2.0,
                        explosion = 2.0,
                        poison = 2.0,
                        melee = 3.0,
                        drill = 2.0,
                        fire = 2.0,
                    };
                    for index,damage_model in pairs( damage_models ) do
                        for damage_type,multiplier in pairs( resistances ) do
                            local resistance = tonumber( ComponentObjectGetValue( damage_model, "damage_multipliers", damage_type ) );
                            resistance = resistance * multiplier;
                            ComponentObjectSetValue( damage_model, "damage_multipliers", damage_type, tostring( resistance ) );
                        end
                    end
                end
            end
        end
    end

    --[[ Champions Mode ]]
    if HasFlagPersistent( MISC.ChampionEnemies.Enabled ) then
        GameAddFlagRun( MISC.ChampionEnemies.Enabled );
        GlobalsSetValue( "gkbrkn_next_miniboss", MISC.ChampionEnemies.MiniBossThreshold );
        if HasFlagPersistent( MISC.ChampionEnemies.SuperChampionsEnabled ) then
            GameAddFlagRun( MISC.ChampionEnemies.SuperChampionsEnabled );
        end
        if HasFlagPersistent( MISC.ChampionEnemies.AlwaysChampionsEnabled ) then
            GameAddFlagRun( MISC.ChampionEnemies.AlwaysChampionsEnabled );
        end
        if HasFlagPersistent( MISC.ChampionEnemies.MiniBossesEnabled ) then
            GameAddFlagRun( MISC.ChampionEnemies.MiniBossesEnabled );
        end
        if HasFlagPersistent( MISC.Badges.Enabled ) then
            local badge = load_dynamic_badge( "champion_mode", {
                {_always=GameHasFlagRun( MISC.ChampionEnemies.AlwaysChampionsEnabled )},
                {_mini_boss=GameHasFlagRun( MISC.ChampionEnemies.MiniBossesEnabled )},
                {_super=GameHasFlagRun( MISC.ChampionEnemies.SuperChampionsEnabled )},
            }, gkbrkn_localization );
            EntityAddChild( player_entity, badge );
        end
    end

    --[[ Starting Perks ]]
    for _,content_id in pairs( STARTING_PERKS or {} ) do
        local starting_perk = CONTENT[content_id];
        if starting_perk ~= nil then
            if starting_perk.enabled() then
                local perk_entity = perk_spawn( x, y, starting_perk.key );
                if perk_entity ~= nil then
                    perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
                end
            end
        end
    end

    if CONTENT[TWEAKS.StunLock].enabled() then 
        local character_platforming = EntityGetFirstComponent( player_entity, "CharacterPlatformingComponent" );
        if character_platforming ~= nil then
            ComponentSetValue( character_platforming, "precision_jumping_max_duration_frames", "10" );
        end
    end

    --[[ Content Callbacks ]]
    for _,content in pairs( CONTENT ) do
        if content.enabled() and content.options ~= nil then
            if content.options.player_spawned_callback ~= nil then
                content.options.player_spawned_callback( player_entity );
            end
            if content.options.run_flags ~= nil then
                for _,flag in pairs( content.options.run_flags ) do
                    GameAddFlagRun( flag );
                end
            end
        end
    end

end

--[[ Development Options enabled warning ]]
for k,v in pairs( DEV_OPTIONS ) do
    if CONTENT[v].enabled() then
        GamePrint( "There are development mode options enabled! If this is unintentional, disable them from the config menu!" );
        break;
    end
end