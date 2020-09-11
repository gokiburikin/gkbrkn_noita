print( "\n\n[goki's things] config file called - reduce these calls as much as possible\n\n" );
--dofile_once( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" );
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );

local has_content_been_cached = false;
local SETTINGS = {
    Version = "c99rc7"
}

local CONTENT_TYPE = {
    Action = 1,
    Perk = 2,
    --Misc = 3,
    Tweak = 4,
    ChampionType = 5,
    Item = 6,
    Loadout = 7,
    StartingPerk = 8,
    LegendaryWand = 9,
    Event = 10,
    GameModifier = 11,
    DevOption = 12,
}

local CONTENT_ACTIVATION_TYPE = {
    Immediate = 1,
    Restart = 2,
    NewGame = 3
}

local CONTENT_TYPE_PREFIX = {
    [CONTENT_TYPE.Action] = "action_",
    [CONTENT_TYPE.Perk] = "perk_",
    [CONTENT_TYPE.Tweak] = "tweak_",
    [CONTENT_TYPE.ChampionType] = "champion_type_",
    [CONTENT_TYPE.Item] = "item_",
    [CONTENT_TYPE.Loadout] = "loadout_",
    [CONTENT_TYPE.StartingPerk] = "starting_perk_",
    [CONTENT_TYPE.LegendaryWand] = "legendary_wand_",
    [CONTENT_TYPE.Event] = "event_",
    [CONTENT_TYPE.GameModifier] = "game_modifier_",
    [CONTENT_TYPE.DevOption] = "dev_option_",
}

local CONTENT_TYPE_DISPLAY_NAME = {
    [CONTENT_TYPE.Action] = "$config_content_type_name_gkbrkn_action",
    [CONTENT_TYPE.Perk] = "$config_content_type_name_gkbrkn_perk",
    [CONTENT_TYPE.Tweak] = "$config_content_type_name_gkbrkn_tweak",
    [CONTENT_TYPE.ChampionType] = "$config_content_type_name_gkbrkn_champion",
    [CONTENT_TYPE.Item] = "$config_content_type_name_gkbrkn_item",
    [CONTENT_TYPE.Loadout] = "$config_content_type_name_gkbrkn_loadout",
    [CONTENT_TYPE.StartingPerk] = "$config_content_type_name_gkbrkn_starting_perk",
    [CONTENT_TYPE.LegendaryWand] = "$config_content_type_name_gkbrkn_legendary_wand",
    [CONTENT_TYPE.Event] = "$config_content_type_name_gkbrkn_event",
    [CONTENT_TYPE.GameModifier] = "$config_content_type_name_gkbrkn_game_modifier",
    [CONTENT_TYPE.DevOption] = "$config_content_type_name_gkbrkn_dev_option",
}

local CONTENT_TYPE_SHORT_NAME = {
    [CONTENT_TYPE.Action] = "actions",
    [CONTENT_TYPE.Perk] = "perks",
    [CONTENT_TYPE.Tweak] = "tweaks",
    [CONTENT_TYPE.ChampionType] = "champion types",
    [CONTENT_TYPE.Item] = "items",
    [CONTENT_TYPE.Loadout] = "loadouts",
    [CONTENT_TYPE.StartingPerk] = "starting perks",
    [CONTENT_TYPE.LegendaryWand] = "unique wands",
    [CONTENT_TYPE.Event] = "events",
    [CONTENT_TYPE.GameModifier] = "game modifiers",
    [CONTENT_TYPE.DevOption] = "dev options",
}

local CONTENT = {};
local get_content_flag = function( content_id, content_table )
    if content_table == nil then content_table = CONTENT; end
    local content = content_table[content_id];
    if content ~= nil then
        return string.lower("GKBRKN_"..CONTENT_TYPE_PREFIX[content_type or content.type]..content.key);
    end
end

local register_content = function( content_table, content_type, key, display_name, description, options, enabled_by_default, deprecated, init_function, development_mode_only )
    local content_id = #content_table + 1;
    local complete_display_name = display_name or ("missing display name: "..key);
    if deprecated then
        complete_display_name = complete_display_name .. " (D)";
    end
    local complete_description = description or ("missing description: "..key);
    local content = {
        id = content_id,
        type = content_type,
        key = key,
        name = complete_display_name,
        description = complete_description,
        enabled_by_default = enabled_by_default,
        deprecated = deprecated,
        development_mode_only = development_mode_only,
        enabled = function()
            if development_mode_only == true and HasFlagPersistent( FLAGS.DebugMode ) == false then
                return false;
            end
            if HasFlagPersistent( FLAGS.ShowDeprecatedContent ) == true or deprecated ~= true then
                if enabled_by_default then
                    return HasFlagPersistent( get_content_flag( content_id, content_table ) ) == false;
                else
                    return HasFlagPersistent( get_content_flag( content_id, content_table ) ) == true;
                end
            end
        end,
        visible = function()
            return HasFlagPersistent( FLAGS.ShowDeprecatedContent ) == true or deprecated ~= true;
        end,
        toggle = function( force )
            local flag = get_content_flag( content_id, content_table );
            local enable = true;
            if force == true then
                enable = true;
            elseif force == false then
                enable = false;
            else
                if HasFlagPersistent( flag ) then
                    enable = false;
                else
                    enable = true;
                end
            end
            if force ~= nil and enabled_by_default then
                enable = not enable;
            end
            if enable then
                AddFlagPersistent( flag );
            else
                RemoveFlagPersistent( flag );
            end
        end,
        options = options or {},
        init_function = init_function,
    }
    table.insert( content_table, content );
    return content.id;
end

local get_content = function( content_id )
    return CONTENT[content_id];
end

local is_content_enabled = function( content_type, content_key )
    return HasFlagPersistent( string.lower( "GKBRKN_"..CONTENT_TYPE_PREFIX[content.type]..content.key ) );
end

local PERKS = {};
local STARTING_PERKS = {};
local ACTIONS = {};
local TWEAKS = {};
local CHAMPION_TYPES = {};
local DEV_OPTIONS = {};
local GAME_MODIFIERS = {};
local LEGENDARY_WANDS = {};
local LOADOUTS = {};
local EVENTS = {}
local ITEMS = {};

-- Options Menu Start
    local register_option = function( name, description, flag, activationType, toggleCallback, enabledByDefault )
        if activationType == nil then
            activationType = CONTENT_ACTIVATION_TYPE.Restart;
        end
        return {
            Name = name,
            Description = description,
            PersistentFlag = flag,
            EnabledByDefault = enabledByDefault,
            ActivationType = activationType,
            ToggleCallback = toggleCallback
        }
    end

    local register_option_localized = function( key, activationType, toggleCallback, enabledByDefault )
        return register_option( "$option_name_"..key, "$option_desc_"..key, key, activationType, toggleCallback, enabledByDefault );
    end

    local register_option_group = function( name, ... )
        return {
            GroupName = name,
            SubOptions = {...}
        }
    end

    local register_option_group_localized = function( key, ... )
        return register_option_group( "$option_group_name_"..key, ... );
    end

    local OPTIONS = {
        register_option_group_localized( "gkbrkn_mod_core",
            register_option_localized( MISC.ManageExternalContent.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart ),
            register_option_localized( MISC.ShowModTips.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, true ),
            register_option_localized( MISC.VerboseMenus.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.AutoHide.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate )
        ),
        register_option_group_localized( "gkbrkn_hero_mode",
            register_option_localized( MISC.HeroMode.EnabledFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.HeroMode.OrbsDifficultyFlag, CONTENT_ACTIVATION_TYPE.NewGame, function( enabled )
                if not enabled then RemoveFlagPersistent( MISC.HeroMode.CarnageDifficultyFlag ); end
            end ),
            register_option_localized( MISC.HeroMode.DistanceDifficultyFlag, CONTENT_ACTIVATION_TYPE.NewGame, function( enabled )
                if not enabled then RemoveFlagPersistent( MISC.HeroMode.CarnageDifficultyFlag ); end
            end ),
            register_option_localized( MISC.HeroMode.CarnageDifficultyFlag, CONTENT_ACTIVATION_TYPE.NewGame, function( enabled )
                if enabled then
                    AddFlagPersistent( MISC.HeroMode.OrbsDifficultyEnabled );
                    AddFlagPersistent( MISC.HeroMode.DistanceDifficultyEnabled );
                end
            end )
        ),
        register_option_group_localized( "gkbrkn_champion_enemies",
            register_option_localized( MISC.ChampionEnemies.EnabledFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.ChampionEnemies.SuperChampionsFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.ChampionEnemies.AlwaysChampionsFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.ChampionEnemies.MiniBossesFlag, CONTENT_ACTIVATION_TYPE.NewGame )
        ),
        register_option_group_localized( "gkbrkn_random_start",
            register_option_localized( MISC.RandomStart.RandomWandsFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.RandomStart.CustomWandGenerationFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.RandomStart.RandomCapeColorFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.RandomStart.RandomHealthFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.RandomStart.RandomFlaskFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.RandomStart.RandomPerkFlag, CONTENT_ACTIVATION_TYPE.NewGame )
        ),
        register_option_group_localized( "gkbrkn_wands",
            register_option_localized( MISC.LegendaryWands.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart ),
            register_option_localized( MISC.LooseSpellGeneration.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart ),
            register_option_localized( MISC.ExtendedWandGeneration.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart ),
            register_option_localized( MISC.ChaoticWandGeneration.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart ),
            register_option_localized( MISC.NoPregenWands.EnabledFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.PassiveRecharge.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate )
        ),
        register_option_group_localized( "gkbrkn_loadouts",
            register_option_localized( MISC.Loadouts.ManageFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.Loadouts.EnabledFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.Loadouts.CapeColorFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.Loadouts.PlayerSpritesFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.Loadouts.SelectableClassesIntegrationFlag, CONTENT_ACTIVATION_TYPE.NewGame )
        ),
        register_option_group_localized( "gkbrkn_gold",
            register_option_localized( MISC.GoldPickupTracker.ShowMessageFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.GoldPickupTracker.ShowTrackerFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, true ),
            register_option_localized( MISC.GoldDecay.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.PersistentGold.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.AutoPickupGold.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.CombineGold.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate )
        ),
        register_option_group_localized( "gkbrkn_invincibility_frames",
            register_option_localized( MISC.InvincibilityFrames.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.InvincibilityFrames.FlashingFlag, CONTENT_ACTIVATION_TYPE.Immediate )
        ),
        register_option_group_localized( "gkbrkn_heal_new_health",
            register_option_localized( MISC.HealOnMaxHealthUp.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.HealOnMaxHealthUp.FullHealFlag, CONTENT_ACTIVATION_TYPE.Immediate )
        ),
        register_option_group_localized( "gkbrkn_less_particles",
            register_option_localized( MISC.LessParticles.PlayerProjectilesFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.LessParticles.OtherStuffFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.LessParticles.DisableCosmeticsFlag, CONTENT_ACTIVATION_TYPE.Immediate )
        ),
        register_option_group_localized( "gkbrkn_health_bars",
            register_option_localized( MISC.HealthBars.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.HealthBars.PrettyHealthBarsFlag, CONTENT_ACTIVATION_TYPE.Immediate )
        ),
        register_option_group_localized( "gkbrkn_ui",
            register_option_localized( MISC.ShowEntityNames.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.ShowPerkDescriptions.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.ShowDamageNumbers.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.ShowFPS.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.Badges.EnabledFlag, CONTENT_ACTIVATION_TYPE.NewGame )
        ),
        register_option_group_localized( "gkbrkn_target_dummy",
            register_option_localized( MISC.TargetDummy.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.TargetDummy.AllowEnvironmentalDamage, CONTENT_ACTIVATION_TYPE.Immediate )
        ),
        register_option_group_localized( "gkbrkn_misc",
            register_option_localized( MISC.RainbowProjectiles.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.QuickSwap.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.ChestsContainPerks.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart ),
            register_option_localized( MISC.SlotMachine.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.ShopReroll.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.Events.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.FixedCamera.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart ),
            register_option_localized( FLAGS.DebugMode, CONTENT_ACTIVATION_TYPE.Restart ),
            register_option_localized( FLAGS.ShowDeprecatedContent, CONTENT_ACTIVATION_TYPE.Restart )
        )
    }
-- Options Menu End

local cache_content = function()
    
    local work = {
        {
            content_filepath = "data/scripts/gun/gun_actions.lua",
            cache_type = "actions",
            content_table = "actions",
            cache_table = "actions_cache",
            cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/actions_cache.lua"
        },
        {
            content_filepath = "data/scripts/perks/perk_list.lua",
            cache_type = "perks",
            content_table = "perk_list",
            cache_table = "perks_cache",
            cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/perks_cache.lua"
        },
        {
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua",
            cache_type = "loadouts",
            content_table = "loadouts",
            cache_table = "loadouts_cache",
            cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/loadouts_cache.lua"
        },
        {
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua",
            cache_type = "tweaks",
            content_table = "tweaks",
            cache_table = "tweaks_cache",
            cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/tweaks_cache.lua"
        },
        {
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/champion_types.lua",
            cache_type = "champion_types",
            content_table = "champion_types",
            cache_table = "champion_types_cache",
            cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/champion_types_cache.lua"
        },
        {
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/legendary_wands.lua",
            cache_type = "legendary_wands",
            content_table = "legendary_wands",
            cache_table = "legendary_wands_cache",
            cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/legendary_wands_cache.lua"
        },
        {
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/dev_options.lua",
            cache_type = "dev_options",
            content_table = "dev_options",
            cache_table = "dev_options_cache",
            cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/dev_options_cache.lua"
        },
        {
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua",
            cache_type = "game_modifiers",
            content_table = "game_modifiers",
            cache_table = "game_modifiers_cache",
            cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/game_modifiers_cache.lua"
        },
        {
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/events.lua",
            cache_type = "events",
            content_table = "events",
            cache_table = "events_cache",
            cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/events_cache.lua"
        },
        {
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/items.lua",
            cache_type = "items",
            content_table = "items",
            cache_table = "items_cache",
            cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/items_cache.lua"
        }
    }

    for _,job in pairs(work) do
        dofile( job.content_filepath );
        print( "[goki's things] caching "..#(_G[job.content_table] or {}).." "..job.cache_type );
        local content_cache = job.cache_table.." = {};";
        for _,cache_content in pairs(_G[job.content_table] or {}) do
            local keys = { {"id"}, {"name","ui_name"}, {"description","ui_description"}, {"author"}, {"enabled_by_default"}, {"item_path"}, {"deprecated"}, {"local_content"} };
            local content_metadata = "{";
            for _,key_groups in pairs(keys) do
                for _,key in pairs(key_groups) do
                    local value = cache_content[key];
                    if value then
                        if type(value) == "string" then
                            value = "\""..value:gsub("\n","\\n").."\"";
                        end
                        content_metadata = content_metadata..key.." = "..(tostring(value) or "nil")..",";
                        break;
                    end
                end
            end
            content_metadata = content_metadata.."}";
            content_cache = content_cache .. "\r\ntable.insert("..job.cache_table..","..content_metadata..");"
        end
        ModTextFileSetContent( job.cache_filepath, content_cache );
    end

    has_content_been_cached = true;
    print("[goki's things] content cached");
end

-- NOTE: first_parse should only ever be true ONE time in goki's things. do not use it
local parse_content = function( first_parse, force_cached, content_table )
    if content_table == nil then
        content_table = CONTENT;
    end
    local load_cached = force_cached;
    if load_cached == nil then
        load_cached = has_content_been_cached or GameHasFlagRun( "gkbrkn_content_cached" );
    end
    if load_cached then
        dofile( "mods/gkbrkn_noita/files/gkbkrn/scratch/actions_cache.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbkrn/scratch/perks_cache.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbkrn/scratch/loadouts_cache.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbkrn/scratch/tweaks_cache.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbkrn/scratch/champion_types_cache.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbkrn/scratch/legendary_wands_cache.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbkrn/scratch/dev_options_cache.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbkrn/scratch/game_modifiers_cache.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbkrn/scratch/events_cache.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbkrn/scratch/items_cache.lua" );
    else
        dofile( "data/scripts/gun/gun_actions.lua" );
        dofile( "data/scripts/perks/perk_list.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbrkn/content/champion_types.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbrkn/content/legendary_wands.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbrkn/content/dev_options.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbrkn/content/events.lua" );
        dofile( "mods/gkbrkn_noita/files/gkbrkn/content/items.lua" );
    end

    local work = {
        [CONTENT_TYPE.Action] = {
            registry_table = ACTIONS,
            content_table = (load_cached and actions_cache) or action or {},
            cache_table = actions_cache,
        },
        [CONTENT_TYPE.Perk] = {
            registry_table = PERKS,
            content_table = (load_cached and perks_cache) or perk_list or {},
            cache_table = perks_cache,
        },
        [CONTENT_TYPE.Loadout] = {
            registry_table = LOADOUTS,
            content_table = (load_cached and loadouts_cache) or loadouts or {},
            cache_table = loadouts_cache,
        },
        [CONTENT_TYPE.Tweak] = {
            registry_table = TWEAKS,
            content_table = (load_cached and tweaks_cache) or tweaks or {},
            cache_table = tweaks_cache,
        },
        [CONTENT_TYPE.ChampionType] = {
            registry_table = CHAMPION_TYPES,
            content_table = (load_cached and champion_types_cache) or champion_types or {},
            cache_table = champion_types_cache,
        },
        [CONTENT_TYPE.LegendaryWand] = {
            registry_table = LEGENDARY_WANDS,
            content_table = (load_cached and legendary_wands_cache) or legendary_wands or {},
            cache_table = legendary_wands_cache,
        },
        [CONTENT_TYPE.DevOption] = {
            registry_table = DEV_OPTIONS,
            content_table = (load_cached and dev_options_cache) or dev_options or {},
            cache_table = dev_options_cache,
        },
        [CONTENT_TYPE.GameModifier] = {
            registry_table = GAME_MODIFIERS,
            content_table = (load_cached and game_modifiers_cache) or game_modifiers or {},
            cache_table = game_modifiers_cache,
        },
        [CONTENT_TYPE.Event] = {
            registry_table = EVENTS,
            content_table = (load_cached and events_cache) or events or {},
            cache_table = events_cache,
        },
        [CONTENT_TYPE.Item] = {
            registry_table = ITEMS,
            content_table = (load_cached and items_cache) or items or {},
            cache_table = items_cache,
        }
    }

    for content_type,job in pairs(work) do
        local starting_perk_string = "starting_perks = {};\r\n";
        print( "[goki's things] registering "..#job.content_table.." "..CONTENT_TYPE_SHORT_NAME[content_type].. ( ( load_cached and job.cache_table and " cached" ) or "") );
        for content_index,content in pairs(job.content_table) do
            local options = content.options or {};
            options.index = content_index;
            options.author = content.author;
            options.menu_note = "("..GameTextGetTranslatedOrNot(content.author or "Unknown")..")";
            if content_type == CONTENT_TYPE.Loadout then
                options.display_name = string_trim(GameTextGetTranslatedOrNot(content.name):gsub("TYPE",""))
            end
            local content_name = content.ui_name or content.name;
            local content_description = content.ui_description or content.description;
            local content_enabled_by_default = false;
            if content.enabled_by_default ~= nil then
                content_enabled_by_default = content.enabled_by_default;
            elseif content_type == CONTENT_TYPE.Action or content_type == CONTENT_TYPE.Perk or content_type == CONTENT_TYPE.ChampionType or content_type == CONTENT_TYPE.LegendaryWand or content_type == CONTENT_TYPE.Loadout then
                content_enabled_by_default = true;
            end

            if HasFlagPersistent( MISC.ManageExternalContent.EnabledFlag ) or ( content_type ~= CONTENT_TYPE.Action and content_type ~= CONTENT_TYPE.Perk ) or content.local_content == true then
                if content_type == CONTENT_TYPE.Perk then
                    options.preview_callback = function( player_entity )
                        dofile_once( "data/scripts/perks/perk.lua" );
                        local perk_entity = perk_spawn( x, y, string.upper( content.id ) );
                        if perk_entity ~= nil then perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false ); end
                    end
                elseif content_type == CONTENT_TYPE.Action then
                    options.preview_callback = function( player_entity )
                        local x, y = EntityGetTransform( player_entity );
                        local action_entity = CreateItemActionEntity( string.upper( content.id ), x, y );
                    end
                elseif content_type == CONTENT_TYPE.LegendaryWand then
                    options.preview_callback = function( player_entity )
                        dofile( "mods/gkbrkn_noita/files/gkbrkn/content/legendary_wands.lua" );
                        dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua" );
                        local x, y = EntityGetTransform( player_entity );
                        local wand = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/legendary_wand.xml", x, y );
                        initialize_legendary_wand( wand, x, y, nil, find_legendary_wand( content.id ) );
                    end
                elseif content_type == CONTENT_TYPE.Item then
                    if content.item_path then
                        options.preview_callback = function( player_entity )
                            local x, y = EntityGetTransform( player_entity );
                            EntityLoad( content.item_path, x, y );
                        end
                    end
                elseif content_type == CONTENT_TYPE.Loadout then
                    options.preview_callback = function( player_entity )
                        dofile( "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua" );
                        dofile_once( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/helper.lua" );
                        handle_loadout( player_entity, find_loadout( content.id ) );
                    end
                end
                job.registry_table[content.id] = register_content( content_table, content_type, content.id, content_name, content_description, options, content_enabled_by_default, content.deprecated, content.init_function, content.development_mode_only );
            end
            if content_type == CONTENT_TYPE.Perk then
                local starting_perk_content_id = register_content( content_table, CONTENT_TYPE.StartingPerk, content.id, content_name, content_description, nil, false, content.deprecated )
                local starting_perk_content = get_content( starting_perk_content_id );
                table.insert( STARTING_PERKS, starting_perk_content_id );
                if starting_perk_content.enabled() then
                    starting_perk_string = starting_perk_string .. "table.insert( starting_perks, \""..content.id.."\" );\r\n"
                end
            end
        end
        if content_type == CONTENT_TYPE.Perk and first_parse then
            if #starting_perk_string ~= 0 then
                ModTextFileSetContent( "mods/gkbrkn_noita/files/gkbrkn/content/starting_perks.lua", starting_perk_string );
            end
        end
    end
end

-- This function is to be called once by init.lua at the very latest it can be to ensure that disabled content is properly removed from their files
-- TODO: find a way to still access disabled content. put it into a disabled table? 
-- this can solve the preview callback issue if the entries in the disable table share the same id as the original content
-- does this solve it in both cases?
local disable_content = function()
    print("[goki's things] disable content");
    local work = {
        [CONTENT_TYPE.Action] = {
            content_table = actions,
            content_filepath = "data/scripts/gun/gun_actions.lua",
            content_disable_callback = function( content, current_string ) return current_string .."table.remove( actions, "..content.options.index.." );\r\n" end,
            content_disable_string = "",
            content_disable_filepath = "data/scripts/gun/gun_actions_disable.lua",
        },
        [CONTENT_TYPE.Perk] = {
            content_table = perk_list,
            content_filepath = "data/scripts/perks/perk_list.lua",
            content_disable_callback = function( content, current_string ) return current_string .."table.remove( perk_list, "..content.options.index.." );\r\n" end,
            content_disable_string = "",
            content_disable_filepath = "data/scripts/perks/perk_list_disable.lua",
        },
        [CONTENT_TYPE.Loadout] = {
            content_table = loadouts,
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua",
            content_disable_callback = function( content, current_string ) return current_string .."table.insert( disabled_loadouts, loadouts["..content.options.index.."] ); table.remove( loadouts, "..content.options.index.." );\r\n" end,
            content_disable_string = "",
            content_disable_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/loadouts_disable.lua",
        },
        [CONTENT_TYPE.Tweak] = {
            content_table = tweaks,
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua",
            content_disable_callback = function( content, current_string ) return current_string .."table.remove( tweaks, "..content.options.index.." );\r\n" end,
            content_disable_string = "",
            content_disable_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/tweaks_disable.lua",
        },
        [CONTENT_TYPE.ChampionType] = {
            content_table = champion_types,
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/champion_types.lua",
            content_disable_callback = function( content, current_string ) return current_string .."table.remove( champion_types, "..content.options.index.." );\r\n" end,
            content_disable_string = "",
            content_disable_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/champion_types_disable.lua",
        },
        [CONTENT_TYPE.LegendaryWand] = {
            content_table = legendary_wands,
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/legendary_wands.lua",
            content_disable_callback = function( content, current_string ) return current_string .."table.insert( disabled_legendary_wands, legendary_wands["..content.options.index.."] ); table.remove( legendary_wands, "..content.options.index.." );\r\n" end,
            content_disable_string = "",
            content_disable_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/legendary_wands_disable.lua",
        },
        [CONTENT_TYPE.DevOption] = {
            content_table = dev_options,
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/dev_options.lua",
            content_disable_callback = function( content, current_string ) return current_string .."table.remove( dev_options, "..content.options.index.." );\r\n" end,
            content_disable_string = "",
            content_disable_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/dev_options_disable.lua",
        },
        [CONTENT_TYPE.GameModifier] = {
            content_table = game_modifiers,
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua",
            content_disable_callback = function( content, current_string ) return current_string .."table.remove( game_modifiers, "..content.options.index.." );\r\n" end,
            content_disable_string = "",
            content_disable_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers_disable.lua",
        },
        [CONTENT_TYPE.Event] = {
            content_table = events,
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/events.lua",
            content_disable_callback = function( content, current_string ) return current_string .."table.remove( events, "..content.options.index.." );\r\n" end,
            content_disable_string = "",
            content_disable_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/events_disable.lua",
        },
        [CONTENT_TYPE.Item] = {
            content_table = items,
            content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/items.lua",
            content_disable_callback = function( content, current_string ) return current_string .."table.remove( items, "..content.options.index.." );\r\n" end,
            content_disable_string = "",
            content_disable_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/items_disable.lua",
        },
    }
    
    for i = #CONTENT, 1, -1 do
        local content = CONTENT[i];
        for content_type,management_info in pairs( work ) do
            if content.type == content_type then
                if not content.enabled() then
                    management_info.content_disable_string = management_info.content_disable_callback( content, management_info.content_disable_string );
                end
            end
        end
    end
    for content_type,management_info in pairs( work ) do
        if #management_info.content_disable_string > 0 then
            ModTextFileSetContent( management_info.content_disable_filepath, management_info.content_disable_string );
            ModLuaFileAppend( management_info.content_filepath, management_info.content_disable_filepath );
        end
    end
end

GKBRKN_CONFIG = {
    SETTINGS = SETTINGS,
    CONTENT_TYPE = CONTENT_TYPE,
    CONTENT_ACTIVATION_TYPE = CONTENT_ACTIVATION_TYPE,
    CONTENT_TYPE_PREFIX = CONTENT_TYPE_PREFIX,
    CONTENT_TYPE_DISPLAY_NAME = CONTENT_TYPE_DISPLAY_NAME,
    CONTENT = CONTENT,
    PERKS = PERKS,
    ACTIONS = ACTIONS,
    TWEAKS = TWEAKS,
    CHAMPION_TYPES = CHAMPION_TYPES,
    ITEMS = ITEMS,
    DEV_OPTIONS = DEV_OPTIONS,
    GAME_MODIFIERS = GAME_MODIFIERS,
    EVENTS = EVENTS,
    OPTIONS = OPTIONS,
    LEGENDARY_WANDS = LEGENDARY_WANDS,
    LOADOUTS = LOADOUTS,
    get_content = get_content,
    get_content_flag = get_content_flag,
    parse_content = parse_content,
    cache_content = cache_content,
    disable_content = disable_content,
    is_content_enabled = is_content_enabled
};
