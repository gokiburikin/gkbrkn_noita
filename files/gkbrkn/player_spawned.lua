print( "[goki's things] player spawn")
GameAddFlagRun( "gkbrkn_content_cached" );
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile( "mods/gkbrkn_noita/files/gkbrkn/content/packs.lua" );
dofile( "mods/gkbrkn_noita/files/gkbrkn/content/starting_perks.lua" );
dofile( "mods/gkbrkn_noita/files/gkbrkn/content/dev_options.lua" );
dofile( "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );
local CONTENT = GKBRKN_CONFIG.CONTENT;
local DEV_OPTIONS = GKBRKN_CONFIG.DEV_OPTIONS;
-- load active content, not cached content
local ACTIVE_CONTENT = {};
GKBRKN_CONFIG.parse_content( false, false, ACTIVE_CONTENT );

local x, y = EntityGetTransform( player_entity );

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
    if not HasFlagPersistent( "gkbrkn_intro" ) then
        AddFlagPersistent( "gkbrkn_intro" );
        GamePrint( "Welcome to Goki's Things! Thanks for playing." );
        GamePrint( "Don't forget to adjust the settings by clicking the button in the top right." );
    end
    if HasFlagPersistent( MISC.ShowModTips.EnabledFlag ) then
        SetRandomSeed( x, y );
        local tip = math.ceil( Random() * #MISC.ShowModTips.Tips );
        GamePrint( GameTextGetTranslatedOrNot( MISC.ShowModTips.Tips[tip] ) );
    end

    --[[ Content Callbacks ]]
    for _,content in pairs( ACTIVE_CONTENT ) do
        if content.enabled() and content.options ~= nil then
            if content.options.run_flags ~= nil then
                for _,flag in pairs( content.options.run_flags ) do
                    GameAddFlagRun( flag );
                end
            end
        end
    end

    DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/init.lua", { player_entity = player_entity } );
    DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/misc/random_start/init.lua", { player_entity = player_entity } );

    EntityAddComponent( player_entity, "LuaComponent", { script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/player_shot.lua" });
    EntityAddComponent( player_entity, "LuaComponent", { script_kick="mods/gkbrkn_noita/files/gkbrkn/misc/player_kick.lua" });

    EntityAddComponent( player_entity, "LuaComponent", {
        script_source_file="mods/gkbrkn_noita/files/gkbrkn/events/event_loop.lua",
        enable_coroutines="1",
        execute_on_added="1",
        execute_times="1",
        execute_every_n_frame="-1",
    });

    --[[ Hero Mode ]]
    if HasFlagPersistent( MISC.HeroMode.EnabledFlag ) then
        GameAddFlagRun( MISC.HeroMode.EnabledFlag );
        if HasFlagPersistent( MISC.HeroMode.OrbsDifficultyFlag ) then
            GameAddFlagRun( MISC.HeroMode.OrbsDifficultyFlag );
        end
        if HasFlagPersistent( MISC.HeroMode.DistanceDifficultyFlag ) then
            GameAddFlagRun( MISC.HeroMode.DistanceDifficultyFlag );
        end
        if HasFlagPersistent( MISC.HeroMode.CarnageDifficultyFlag ) then
            GameAddFlagRun( MISC.HeroMode.CarnageDifficultyFlag );
        end
        if HasFlagPersistent( MISC.Badges.EnabledFlag ) then
            local badge = load_dynamic_badge( "hero_mode", {
                {_distance=GameHasFlagRun( MISC.HeroMode.DistanceDifficultyFlag )},
                {_orbs=GameHasFlagRun( MISC.HeroMode.OrbsDifficultyFlag )},
                {_carnage=GameHasFlagRun( MISC.HeroMode.CarnageDifficultyFlag )},
            } );
            EntityAddChild( player_entity, badge );
        end

        if GameHasFlagRun( MISC.HeroMode.CarnageDifficultyFlag ) == true then
            GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", 1 );
            GlobalsSetValue( "TEMPLE_PERK_COUNT", 2 );
            GlobalsSetValue( "TEMPLE_SHOP_ITEM_COUNT", 3 );
            GamePlaySound( "data/audio/Desktop/event_cues.snd", "event_cues/sampo_pick/create", x, y );
            GamePlaySound( "data/audio/Desktop/event_cues.snd", "event_cues/orb_distant_monster/create", x, y );
            GameScreenshake( 500 );
            GamePrintImportant( "$ui_carnage_warning_gkbrkn", "$ui_carnage_warning_note_gkbrkn" );
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
                        local resistance = ComponentObjectGetValue2( damage_model, "damage_multipliers", damage_type );
                        resistance = resistance * multiplier;
                        ComponentObjectSetValue2( damage_model, "damage_multipliers", damage_type, resistance );
                    end
                end
            end
        end
    end

    --[[ Champions Mode ]]
    if HasFlagPersistent( MISC.ChampionEnemies.EnabledFlag ) then
        GameAddFlagRun( MISC.ChampionEnemies.EnabledFlag );
        GlobalsSetValue( "gkbrkn_next_miniboss", MISC.ChampionEnemies.MiniBossThreshold );
        if HasFlagPersistent( MISC.ChampionEnemies.SuperChampionsFlag ) then
            GameAddFlagRun( MISC.ChampionEnemies.SuperChampionsFlag );
        end
        if HasFlagPersistent( MISC.ChampionEnemies.AlwaysChampionsFlag ) then
            GameAddFlagRun( MISC.ChampionEnemies.AlwaysChampionsFlag );
        end
        if HasFlagPersistent( MISC.ChampionEnemies.MiniBossesFlag ) then
            GameAddFlagRun( MISC.ChampionEnemies.MiniBossesFlag );
        end
        if HasFlagPersistent( MISC.ChampionEnemies.ValourFlag ) then
            GameAddFlagRun( MISC.ChampionEnemies.ValourFlag );
        end
        if HasFlagPersistent( MISC.Badges.EnabledFlag ) then
            local badge = load_dynamic_badge( "champion_mode", {
                {_always=GameHasFlagRun( MISC.ChampionEnemies.AlwaysChampionsFlag )},
                {_mini_boss=GameHasFlagRun( MISC.ChampionEnemies.MiniBossesFlag )},
                {_super=GameHasFlagRun( MISC.ChampionEnemies.SuperChampionsFlag )},
                {_valour=GameHasFlagRun( MISC.ChampionEnemies.ValourFlag )},
            } );
            EntityAddChild( player_entity, badge );
        end
    end

    if GameHasFlagRun( FLAGS.EnemyIntangibilityFrames ) then
        local badge = load_dynamic_badge( "intangibility_mode", nil );
        if badge ~= nil then EntityAddChild( player_entity, badge ); end
    end

    if find_tweak("stun_lock") then 
        local character_platforming = EntityGetFirstComponent( player_entity, "CharacterPlatformingComponent" );
        if character_platforming ~= nil then
            ComponentSetValue2( character_platforming, "precision_jumping_max_duration_frames", 10 );
        end
    end

    local wands = {};
    local inventory2 = EntityGetFirstComponent( player_entity, "Inventory2Component" );
    if inventory2 ~= nil then
        local active_item = ComponentGetValue2( inventory2, "mActiveItem" );
        for key, child in pairs( EntityGetAllChildren( player_entity ) ) do
            if EntityGetName( child ) == "inventory_quick" then
                wands = EntityGetChildrenWithTag( child, "wand" ) or {};
                break;
            end
        end
        for _,wand in pairs(wands) do
            if wand then
                if GameHasFlagRun( FLAGS.GuaranteedAlwaysCast ) then
                    force_always_cast( wand, 1 )
                end
                local ability = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" );
                if ability ~= nil then
                    if GameHasFlagRun( FLAGS.OrderWandsOnly ) then
                        ability_component_set_stat( ability, "shuffle_deck_when_empty", false );
                    elseif GameHasFlagRun( FLAGS.ShuffleWandsOnly ) then
                        ability_component_set_stat( ability, "shuffle_deck_when_empty", true );
                    end
                end
            end
        end
    end

    --[[ Content Callbacks ]]
    for _,content in pairs( ACTIVE_CONTENT ) do
        if content.enabled() then
            if content.options and content.options.player_spawned_callback then
                content.options.player_spawned_callback( player_entity );
            end
        end
    end

    --[[ Starting Perks ]]
    for _,starting_perk in pairs( starting_perks or {} ) do
        local perk_entity = perk_spawn( x, y, starting_perk );
        if perk_entity ~= nil then
            perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
        end
    end

    -- moved to bottom so things in here can check if the flag has been set yet
    GameAddFlagRun( init_check_flag );
end

--[[ Development Options enabled warning ]]
if HasFlagPersistent( FLAGS.DebugMode ) then
    if #dev_options > 0 then
        GamePrint( "There are development mode options enabled! If this is unintentional, disable them from the config menu!" );
    end
end

--[[
for _,pack_data in pairs( packs ) do
    simulate_cracking_packs( pack_data.id, 100, x, y );
end
]]