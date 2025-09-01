print("[goki's things] player spawn")
return function( e )
    GameAddFlagRun( "gkbrkn_content_cached" )
    local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" )
    dofile_once( "data/scripts/perks/perk.lua" )
    dofile_once( "data/scripts/perks/perk_list.lua" )
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/packs.lua" )
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/cheats.lua" )
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua" )
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" )
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" )
    local CONTENT = GKBRKN_CONFIG.CONTENT
    local CHEATS = GKBRKN_CONFIG.CHEATS
    -- load active content, not cached content
    local ACTIVE_CONTENT = {}
    GKBRKN_CONFIG.parse_content( false, false, ACTIVE_CONTENT )

    local x, y = EntityGetTransform( e )
    local inventory_quick = nil
    for _,c in pairs(EntityGetAllChildren(e)) do
        if EntityGetName(c) == "inventory_quick" then
            inventory_quick = c
            break
        end
    end

    local has_player_update = false
    local has_player_damage_received = false
    for _,lua in pairs(EntityGetComponent( e, "LuaComponent" ) or {}) do
        if ComponentGetValue2( lua, "script_source_file" ) == "mods/gkbrkn_noita/files/gkbrkn/misc/player_update.lua" then
            has_player_update = true
        elseif ComponentGetValue2( lua, "script_source_file" ) == "mods/gkbrkn_noita/files/gkbrkn/misc/player_damage_received.lua" then
            has_player_damage_received = true
        end
    end
    if not has_player_update then
        EntityAddComponent( e, "LuaComponent", {
            script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/player_update.lua",
            execute_every_n_frame="1",
        })
    end

    if not has_player_damage_received then
        EntityAddComponent( e, "LuaComponent", {
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/player_damage_received.lua",
        })
    end

    if not GameHasFlagRun( FLAGS.NewGameRunFlag ) then
        if not setting_get( "gkbrkn_intro", false ) then
            AddFlagPersistent( "gkbrkn_intro" )
            GamePrint("Welcome to Goki's Things! Thanks for playing.")
            GamePrint("Don't forget to adjust the settings by clicking the button in the top right.")
        end

        GlobalsSetValue( "gkbrkn_champion_enemies_encountered", "0" )

        if setting_get( MISC.ShowModTips.EnabledFlag, false ) then
            SetRandomSeed( x, y )
            local tip = math.ceil( Random() * #MISC.ShowModTips.Tips )
            GamePrint( GameTextGetTranslatedOrNot( MISC.ShowModTips.Tips[tip] ) )
        end

        --[[ Content Callbacks ]]
        for _,content in pairs( ACTIVE_CONTENT ) do
            if content.enabled() and content.options ~= nil then
                if content.options.run_flags ~= nil then
                    for _,flag in pairs( content.options.run_flags ) do
                        GameAddFlagRun( flag )
                    end
                end
            end
        end

        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/infinite_inventory.xml" )

        DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/init.lua", { player_entity = e } )
        if not GameHasFlagRun( FLAGS.DelayInit ) then
            DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/misc/random_start/init.lua", { player_entity = e } )
        end

        EntityAddComponent( e, "LuaComponent", { script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/player_shot.lua" })
        EntityAddComponent( e, "LuaComponent", { script_kick="mods/gkbrkn_noita/files/gkbrkn/misc/player_kick.lua" })

        EntityAddComponent( e, "LuaComponent", {
            script_source_file="mods/gkbrkn_noita/files/gkbrkn/events/event_loop.lua",
            enable_coroutines="1",
            execute_on_added="1",
            execute_times="1",
            execute_every_n_frame="-1",
        })

        --[[ Hero Mode ]]
        if setting_get( MISC.HeroMode.EnabledFlag, false ) then
            GameAddFlagRun( MISC.HeroMode.EnabledFlag )
            if setting_get( MISC.HeroMode.OrbsDifficultyFlag, false ) then
                GameAddFlagRun( MISC.HeroMode.OrbsDifficultyFlag )
            end
            if setting_get( MISC.HeroMode.DistanceDifficultyFlag, false ) then
                GameAddFlagRun( MISC.HeroMode.DistanceDifficultyFlag )
            end
            if setting_get( MISC.HeroMode.CarnageDifficultyFlag, false ) then
                GameAddFlagRun( MISC.HeroMode.CarnageDifficultyFlag )
            end
            if setting_get( MISC.Badges.EnabledFlag, false ) then
                load_dynamic_badge_to( e, "hero_mode", {
                    {_distance=GameHasFlagRun( MISC.HeroMode.DistanceDifficultyFlag )},
                    {_orbs=GameHasFlagRun( MISC.HeroMode.OrbsDifficultyFlag )},
                    {_carnage=GameHasFlagRun( MISC.HeroMode.CarnageDifficultyFlag )},
                } )
            end

            if GameHasFlagRun( MISC.HeroMode.CarnageDifficultyFlag ) == true then
                GlobalsSetValue( "TEMPLE_PERK_COUNT", 4 )
                GlobalsSetValue( "TEMPLE_SHOP_ITEM_COUNT", 7 )
                GamePlaySound( "data/audio/Desktop/event_cues.snd", "event_cues/sampo_pick/create", x, y )
                GamePlaySound( "data/audio/Desktop/event_cues.snd", "event_cues/orb_distant_monster/create", x, y )
                GameScreenshake( 500 )
                GamePrintImportant( "$ui_carnage_warning_gkbrkn", "$ui_carnage_warning_note_gkbrkn" )
                --[[
                local damage_models = EntityGetComponent( e, "DamageModelComponent" )
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
                    }
                    for index,damage_model in pairs( damage_models ) do
                        for damage_type,multiplier in pairs( resistances ) do
                            local resistance = ComponentObjectGetValue2( damage_model, "damage_multipliers", damage_type )
                            resistance = resistance * multiplier
                            ComponentObjectSetValue2( damage_model, "damage_multipliers", damage_type, resistance )
                        end
                    end
                end
                ]]
            end
        end

        --[[ Champions Mode ]]
        if setting_get( MISC.ChampionEnemies.EnabledFlag, false ) then
            GameAddFlagRun( MISC.ChampionEnemies.EnabledFlag )
            GlobalsSetValue( "gkbrkn_next_miniboss", MISC.ChampionEnemies.MiniBossThreshold )
            if setting_get( MISC.ChampionEnemies.SuperChampionsFlag, false ) then
                GameAddFlagRun( MISC.ChampionEnemies.SuperChampionsFlag )
            end
            if setting_get( MISC.ChampionEnemies.AlwaysChampionsFlag, false ) then
                GameAddFlagRun( MISC.ChampionEnemies.AlwaysChampionsFlag )
            end
            if setting_get( MISC.ChampionEnemies.MiniBossesFlag, false ) then
                GameAddFlagRun( MISC.ChampionEnemies.MiniBossesFlag )
            end
            if setting_get( MISC.ChampionEnemies.ValourFlag, false ) then
                GameAddFlagRun( MISC.ChampionEnemies.ValourFlag )
            end
            if setting_get( MISC.Badges.EnabledFlag, false ) then
                load_dynamic_badge_to( e, "champion_mode", {
                    {_always=GameHasFlagRun( MISC.ChampionEnemies.AlwaysChampionsFlag )},
                    {_mini_boss=GameHasFlagRun( MISC.ChampionEnemies.MiniBossesFlag )},
                    {_super=GameHasFlagRun( MISC.ChampionEnemies.SuperChampionsFlag )},
                    {_valour=GameHasFlagRun( MISC.ChampionEnemies.ValourFlag )},
                } )
            end
        end

        if setting_get( MISC.Badges.EnabledFlag, false ) then
            if GameHasFlagRun( FLAGS.EnemyIntangibilityFrames ) then
                load_dynamic_badge_to( e, "intangibility_mode", nil )
            end
        end

        if setting_get("tweak_stun_lock") then 
            local character_platforming = EntityGetFirstComponent( e, "CharacterPlatformingComponent" )
            if character_platforming ~= nil then
                ComponentSetValue2( character_platforming, "precision_jumping_max_duration_frames", 10 )
            end
        end

        local wands = EntityGetChildrenWithTag( inventory_quick, "wand" ) or {}
        local inventory2 = EntityGetFirstComponent( e, "Inventory2Component" )
        if inventory2 ~= nil then
            local active_item = ComponentGetValue2( inventory2, "mActiveItem" )
            for _,wand in pairs(wands) do
                if wand then
                    if GameHasFlagRun( FLAGS.GuaranteedAlwaysCast ) then
                        force_always_cast( wand, 1 )
                    end
                    local ability = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
                    if ability ~= nil then
                        if GameHasFlagRun( FLAGS.OrderWandsOnly ) then
                            ability_component_set_stat( ability, "shuffle_deck_when_empty", false )
                        elseif GameHasFlagRun( FLAGS.ShuffleWandsOnly ) then
                            ability_component_set_stat( ability, "shuffle_deck_when_empty", true )
                        end
                    end
                end
            end
        end

        --[[ Content Callbacks ]]
        for _,content in pairs( ACTIVE_CONTENT ) do
            if content.enabled() then
                if content.options and content.options.player_spawned_callback then
                    content.options.player_spawned_callback( e )
                end
            end
        end

        --[[ Starting Perks ]]
        for _,perk in pairs( perk_list or {} ) do
            if setting_get( "sp_perk_"..perk.id, false ) then
                local perk_entity = perk_spawn( x, y, perk.id )
                if perk_entity ~= nil then
                    perk_pickup( perk_entity, e, EntityGetName( perk_entity ), false, false )
                end
            end
        end

        if setting_get( FLAGS.RunInfoIcon, false ) then
            local run_flags_string = ""
            local world_state_component = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
            for _,flag in pairs(ComponentGetValue2( world_state_component, "flags" ) or {}) do
                local key = "$run_flag_info_" .. flag
                local translation = GameTextGetTranslatedOrNot( key )
                if #translation > 0 then
                    run_flags_string = run_flags_string .. translation .. "\n"
                end
            end
            if #run_flags_string > 0 then
                add_icon_in_hud( e, "mods/gkbrkn_noita/files/gkbrkn/gui/info.png", "Run Info", run_flags_string, true )
            end
        end

        -- moved to bottom so things in here can check if the flag has been set yet
        GameAddFlagRun( FLAGS.NewGameRunFlag )
    end

    --[[ Development Options enabled warning ]]
    if setting_get( FLAGS.DebugMode, false ) then
        if #cheats > 0 then
            GamePrint("There are development mode options enabled! If this is unintentional, disable them from the config menu!")
        end
    end

    EntitySetTransform( n, x + 10, y - 10 )
end