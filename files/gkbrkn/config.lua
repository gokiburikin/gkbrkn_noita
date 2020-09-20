print( "[goki's things] config file called - reduce these calls as much as possible" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/content_types.lua" );
--dofile_once( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" );
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );

local has_content_been_cached = false;
local SETTINGS = {
    Version = "c99rc9"
}

local CONTENT_ACTIVATION_TYPE = {
    Immediate = 1,
    Restart = 2,
    NewGame = 3
}

local CONTENT = {};
local get_content_flag = function( content_id, content_table )
    if content_table == nil then content_table = CONTENT; end
    local content = content_table[content_id];
    if content ~= nil then
        local content_flag = string.lower("GKBRKN_"..find_content_type( content.type ).id.."_"..content.key);
        return content_flag;
    end
end

local register_content = function( content_table, content_type, key, display_name, description, options, enabled_by_default, deprecated, init_function, development_mode_only, tags )
    local content_id = #content_table + 1;
    local complete_display_name = display_name or ("missing display name: "..key);
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
        tags = tags or {}
    }
    table.insert( content_table, content );
    return content.id;
end

-- Options Menu Start
    local register_option = function( name, description, flag, activationType, toggleCallback, enabledByDefault, tags )
        if activationType == nil then
            activationType = CONTENT_ACTIVATION_TYPE.Restart;
        end
        return {
            Name = name,
            Description = description,
            PersistentFlag = flag,
            EnabledByDefault = enabledByDefault,
            ActivationType = activationType,
            ToggleCallback = toggleCallback,
            Tags = tags or {}
        }
    end

    local register_option_localized = function( key, activationType, toggleCallback, enabledByDefault, tags )
        return register_option( "$option_name_"..key, "$option_desc_"..key, key, activationType, toggleCallback, enabledByDefault, tags );
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
            register_option_localized( MISC.AutoHide.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate )
        ),
        register_option_group_localized( "gkbrkn_hero_mode",
            register_option_localized( MISC.HeroMode.EnabledFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {goki_thing = true, ultimate_challenge = true, hero_mode = true} ),
            register_option_localized( MISC.HeroMode.OrbsDifficultyFlag, CONTENT_ACTIVATION_TYPE.NewGame, function( enabled )
                if not enabled then RemoveFlagPersistent( MISC.HeroMode.CarnageDifficultyFlag ); end
            end, nil, {goki_thing = true, ultimate_challenge = true, hero_mode = true} ),
            register_option_localized( MISC.HeroMode.DistanceDifficultyFlag, CONTENT_ACTIVATION_TYPE.NewGame, function( enabled )
                if not enabled then RemoveFlagPersistent( MISC.HeroMode.CarnageDifficultyFlag ); end
            end, nil, {goki_thing = true, ultimate_challenge = true, hero_mode = true} ),
            register_option_localized( MISC.HeroMode.CarnageDifficultyFlag, CONTENT_ACTIVATION_TYPE.NewGame, function( enabled )
                if enabled then
                    AddFlagPersistent( MISC.HeroMode.OrbsDifficultyEnabled );
                    AddFlagPersistent( MISC.HeroMode.DistanceDifficultyEnabled );
                end
            end )
        ),
        register_option_group_localized( "gkbrkn_champion_enemies",
            register_option_localized( MISC.ChampionEnemies.EnabledFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {goki_thing = true, ultimate_challenge = true, champions_mode = true} ),
            register_option_localized( MISC.ChampionEnemies.SuperChampionsFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {goki_thing = true, ultimate_challenge = true, champions_mode = true} ),
            register_option_localized( MISC.ChampionEnemies.AlwaysChampionsFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {goki_thing = true, ultimate_challenge = true, champions_mode = true} ),
            register_option_localized( MISC.ChampionEnemies.MiniBossesFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {goki_thing = true, ultimate_challenge = true, champions_mode = true} )
        ),
        register_option_group_localized( "gkbrkn_random_start",
            register_option_localized( MISC.RandomStart.RandomWandsFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {random_starts = true} ),
            register_option_localized( MISC.RandomStart.CustomWandGenerationFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.RandomStart.RandomCapeColorFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {random_starts = true} ),
            register_option_localized( MISC.RandomStart.RandomHealthFlag, CONTENT_ACTIVATION_TYPE.NewGame ),
            register_option_localized( MISC.RandomStart.RandomFlaskFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {random_starts = true} ),
            register_option_localized( MISC.RandomStart.RandomPerkFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {random_starts = true} )
        ),
        register_option_group_localized( "gkbrkn_wands",
            register_option_localized( MISC.LegendaryWands.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.LooseSpellGeneration.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.ExtendedWandGeneration.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.ChaoticWandGeneration.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart ),
            register_option_localized( MISC.NoPregenWands.EnabledFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.PassiveRecharge.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate )
        ),
        register_option_group_localized( "gkbrkn_loadouts",
            register_option_localized( MISC.Loadouts.ManageFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {goki_thing = true,loadouts = true} ),
            register_option_localized( MISC.Loadouts.EnabledFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {loadouts = true} ),
            register_option_localized( MISC.Loadouts.CapeColorFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {loadouts = true} ),
            register_option_localized( MISC.Loadouts.PlayerSpritesFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {loadouts = true} ),
            register_option_localized( MISC.Loadouts.SelectableClassesIntegrationFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, nil, {loadouts = true} )
        ),
        register_option_group_localized( "gkbrkn_gold",
            register_option_localized( MISC.GoldPickupTracker.ShowMessageFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.GoldPickupTracker.ShowTrackerFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, true, {goki_thing = true} ),
            register_option_localized( MISC.GoldDecay.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.PersistentGold.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.AutoPickupGold.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.CombineGold.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, nil, {goki_thing = true} )
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
            register_option_localized( MISC.HealthBars.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.HealthBars.PrettyHealthBarsFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, nil, {goki_thing = true} )
        ),
        register_option_group_localized( "gkbrkn_ui",
            register_option_localized( MISC.ShowEntityNames.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.ShowPerkDescriptions.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.ShowDamageNumbers.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.ShowFPS.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.Badges.EnabledFlag, CONTENT_ACTIVATION_TYPE.NewGame, nil, true, {goki_thing = true} )
        ),
        register_option_group_localized( "gkbrkn_target_dummy",
            register_option_localized( MISC.TargetDummy.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, true, {goki_thing = true} ),
            register_option_localized( MISC.TargetDummy.AllowEnvironmentalDamage, CONTENT_ACTIVATION_TYPE.Immediate, nil, true )
        ),
        register_option_group_localized( "gkbrkn_misc",
            register_option_localized( MISC.PackShops.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart ),
            register_option_localized( MISC.RainbowProjectiles.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.QuickSwap.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.ChestsContainPerks.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.SlotMachine.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.ShopReroll.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate, nil, nil, {goki_thing = true} ),
            register_option_localized( MISC.Events.EnabledFlag, CONTENT_ACTIVATION_TYPE.Immediate ),
            register_option_localized( MISC.FixedCamera.EnabledFlag, CONTENT_ACTIVATION_TYPE.Restart, nil, nil, {goki_thing = true} ),
            register_option_localized( FLAGS.DebugMode, CONTENT_ACTIVATION_TYPE.Restart ),
            register_option_localized( FLAGS.ShowDeprecatedContent, CONTENT_ACTIVATION_TYPE.Restart )
        )
    }
-- Options Menu End

local cache_content = function()
    for _,content_type in pairs( content_types ) do
        local content_filepath = content_type.shared_content_filepath or content_type.content_filepath;
        dofile( content_filepath );
        local content_table = _G[content_type.shared_content_table] or _G[content_type.content_table];
        print( "[goki's things] caching "..#(content_table or {}).." "..content_type.short_name );
        local content_cache = content_type.cache_table.." = {};";
        for _,cache_content in pairs(content_table or {}) do
            local keys = { {"id"}, {"name","ui_name"}, {"description","ui_description"}, {"author"}, {"enabled_by_default"}, {"item_path"}, {"deprecated"}, {"local_content"} };
            local content_metadata = "{";
            for _,key_groups in pairs(keys) do
                for _,key in pairs(key_groups) do
                    local value = cache_content[key];
                    if value ~= nil then
                        if type(value) == "string" then
                            value = "\""..value:gsub("\n","\\n").."\"";
                        end
                        content_metadata = content_metadata..key.." = "..(tostring(value) or "nil")..",";
                        break;
                    end
                end
            end
            if cache_content.tags then
                content_metadata = content_metadata.. "tags={";
                for k,v in pairs( cache_content.tags ) do
                    content_metadata = content_metadata..k.."="..tostring(v)
                end
                content_metadata = content_metadata.. "}";
            end
            content_metadata = content_metadata.."}";
            content_cache = content_cache .. "\r\ntable.insert("..content_type.cache_table..","..content_metadata..");"
        end
        ModTextFileSetContent( content_type.cache_filepath, content_cache );
    end

    has_content_been_cached = true;
    print( "[goki's things] content cached" );
end

-- NOTE first_parse should only ever be true ONE time in goki's things. do not use it
-- TODO this needs to be handled by each content type itself
local parse_content = function( first_parse, force_cached, content_table )
    if content_table == nil then content_table = CONTENT; end
    local load_cached = force_cached;
    if load_cached == nil then
        load_cached = has_content_been_cached or GameHasFlagRun( "gkbrkn_content_cached" );
    end
    if load_cached then
        for _,content_type_data in pairs( content_types ) do dofile( content_type_data.cache_filepath ); end
    else
        for _,content_type_data in pairs( content_types ) do dofile( content_type_data.shared_content_filepath or content_type_data.content_filepath ); end
    end

    for _,content_type_data in pairs( content_types ) do
        local index = content_type_data.id;
        local starting_perk_string = "starting_perks = {};\r\n";
        local content_type_table = _G[content_type_data.shared_content_table] or _G[content_type_data.content_table] or _G[content_type_data.cache_table];
        if content_type_table then
            print( "[goki's things] registering "..#content_type_table.." "..content_type_data.short_name.. ( ( load_cached and content_type_data.cache_table and " cached" ) or "") );
            for content_index,content_data in pairs( content_type_table ) do
                local options = content_data.options or {};
                options.index = content_index;
                options.author = content_data.author;
                options.menu_note = "("..GameTextGetTranslatedOrNot(content_data.author or "Unknown")..")";
                if id == "loadout" then
                    options.display_name = string_trim(GameTextGetTranslatedOrNot(content_data.name):gsub("TYPE",""))
                end
                local content_name = content_data.ui_name or content_data.name;
                local content_description = content_data.ui_description or content_data.description;
                local content_enabled_by_default = false;
                if content_data.enabled_by_default ~= nil then
                    content_enabled_by_default = content_data.enabled_by_default;
                elseif index == "action" or index == "perk" or index == "champion_type" or index == "legendary_wand" or index == "loadout" or index == "pack" then
                    content_enabled_by_default = true;
                end

                local content = nil;
                local content_id = nil;
                if HasFlagPersistent( MISC.ManageExternalContent.EnabledFlag ) or ( index ~= "action" and index ~= "perk" ) or content_data.local_content == true then
                    if index == "perk" then
                        options.preview_callback = function( player_entity )
                            dofile_once( "data/scripts/perks/perk.lua" );
                            local perk_entity = perk_spawn( x, y, string.upper( content_data.id ) );
                            if perk_entity ~= nil then perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false ); end
                        end
                    elseif index == "action" then
                        options.preview_callback = function( player_entity )
                            local x, y = EntityGetTransform( player_entity );
                            local action_entity = CreateItemActionEntity( string.upper( content_data.id ), x, y );
                        end
                    elseif index == "legendary_wand" then
                        options.preview_callback = function( player_entity )
                            dofile( "mods/gkbrkn_noita/files/gkbrkn/content/legendary_wands.lua" );
                            dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua" );
                            local x, y = EntityGetTransform( player_entity );
                            local wand = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/legendary_wand.xml", x, y );
                            initialize_legendary_wand( wand, x, y, nil, find_legendary_wand( content_data.id ) );
                        end
                    elseif index == "item" then
                        if content_data.item_path then
                            options.preview_callback = function( player_entity )
                                local x, y = EntityGetTransform( player_entity );
                                EntityLoad( content_data.item_path, x, y );
                            end
                        end
                    elseif index == "loadout" then
                        options.preview_callback = function( player_entity )
                            dofile( "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua" );
                            dofile_once( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/helper.lua" );
                            handle_loadout( player_entity, find_loadout( content_data.id ) );
                        end
                    end
                    content_id = register_content( content_table, index, content_data.id, content_name, content_description, options, content_enabled_by_default, content_data.deprecated, content_data.init_function, content_data.development_mode_only, content_data.tags );
                end
                content = content_table[ content_id ];
                if index == "starting_perk" and content then
                    --local starting_perk_content_id = register_content( content_table, "starting_perk", content_data.id, content_name, content_description, options, false, content_data.deprecated )
                    if content.enabled() then
                        starting_perk_string = starting_perk_string .. "table.insert( starting_perks, \""..content_data.id.."\" );\r\n"
                    end
                end
            end
            if index == "starting_perk" and first_parse then
                if #starting_perk_string ~= 0 then
                    ModTextFileSetContent( "mods/gkbrkn_noita/files/gkbrkn/content/starting_perks.lua", starting_perk_string );
                end
            end
        else
            print( "[goki's things] no cache or content table found for "..index );
        end
    end
end

-- This function is to be called once by init.lua at the very latest it can be to ensure that disabled content is properly removed from their files
local disable_content = function( content_table )
    print( "[goki's things] disable content" );
    if content_table == nil then content_table = CONTENT; end
    local disable_strings = {};
    for i = #content_table, 1, -1 do
        local content = content_table[i];
        for _,content_type in pairs( content_types ) do
            if content.type == content_type.id then
                if not content.enabled() then
                    disable_strings[ content_type.id ] = content_type.content_disable_callback( content, (disable_strings[ content_type.id ] or "") );
                end
            end
        end
    end
    for _,content_type in pairs( content_types ) do
        if #(disable_strings[ content_type.id ] or "") > 0 then
            local disable_filepath = "mods/gkbrkn_noita/files/gkbrkn/scratch/disable_"..content_type.id..".lua";
            ModTextFileSetContent( disable_filepath, disable_strings[ content_type.id ] );
            ModLuaFileAppend( content_type.content_filepath, disable_filepath );
        end
    end
end

GKBRKN_CONFIG = {
    SETTINGS = SETTINGS,
    CONTENT_ACTIVATION_TYPE = CONTENT_ACTIVATION_TYPE,
    CONTENT = CONTENT,
    OPTIONS = OPTIONS,
    get_content = get_content,
    get_content_flag = get_content_flag,
    parse_content = parse_content,
    cache_content = cache_content,
    disable_content = disable_content,
};
