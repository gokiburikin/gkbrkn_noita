local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" )
--##DEV local STATS = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/stats.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/misc/hero_mode.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")

player = player or 0
function process_entity( e )
    --##DEV local t = GameGetRealWorldTimeSinceStarted()
    if EntityHasTag( e, "workshop_exit" ) then
        if GameHasFlagRun( FLAGS.DiplomaticImmunity ) then EntityKill(e) end
        --##DEV STATS.add_and_count( "process_entity", GameGetRealWorldTimeSinceStarted() - t )
        return
    end

    if IsPlayer(e) then
        player = e
    end

    if EntityHasVarTag( e, "gkbrkn_processed_entity" ) then
        --##DEV STATS.add_and_count( "process_entity", GameGetRealWorldTimeSinceStarted() - t )
        return
    end

    if EntityHasTag( e, "enemy" ) then process_enemy( e ) end
    if EntityHasTag( e, "wand" ) then process_wand( e ) end
    if EntityHasTag( e, "gold_nugget" ) then process_gold_nugget( e ) end

    -- Remove annoying edit wand prompt
    if EntityHasTag( e, "workshop_untouched") then
        if setting_get( MISC.RemoveEditPrompt.EnabledFlag, false ) then
            EntityRemoveTag( e, "workshop_untouched" )
        end
    end

    -- Less Particles
    if setting_get( MISC.LessParticles.OtherStuffFlag, false ) then
        reduce_particles( e, setting_get( MISC.LessParticles.DisableCosmeticsFlag, false ) )
    end

    if setting_get( MISC.LessParticles.ExplosionStainsFlag, false ) then
        remove_explosion_stains( projectile_entity )
    end

     -- Custom Damage Numbers
    if setting_get( MISC.ShowDamageNumbers.EnabledFlag, false ) then
        if EntityHasTag( e, "homing_target" ) then
            if not EntityHasTag( e, "boss" ) and not EntityHasVarTag( e, "gkbrkn_no_custom_damage_numbers") then
                if not EntityHasScript( e, "mods/gkbrkn_noita/files/gkbrkn/misc/custom_damage_numbers.lua" ,"script_damage_received" ) then
                    EntityAddComponent( e, "LuaComponent", { script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/custom_damage_numbers.lua" })
                end
                if not EntityHasVarTag( e, "gkbrkn_custom_damage_numbers" ) then
                    EntityAddVarTag( e, "gkbrkn_custom_damage_numbers" )
                    local container = EntityCreateNew()
                    EntityAddComponent( container, "InheritTransformComponent",{ only_position="1"} )
                    EntityAddChild( e, container )
                    EntityLoadToEntity( "mods/gkbrkn_noita/files/gkbrkn/misc/custom_damage_numbers_text.xml", container )
                    EntityAddComponent( container, "LuaComponent", {
                        execute_every_n_frame="1",
                        script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/custom_damage_numbers_text.lua",
                    })
                end
            end
        end
    end

    -- Entity Names
    if setting_get( MISC.ShowEntityNames.EnabledFlag, false ) then
        if EntityHasTag( e, "mortal" ) then
            if EntityGetFirstComponent( e, "UIInfoComponent" ) == nil then
                EntityAddComponent( e, "UIInfoComponent", {
                    name=EntityGetName( e )
                })
            end
        end
    end
    --##DEV STATS.add_and_count( "process_entity", GameGetRealWorldTimeSinceStarted() - t )
    EntityAddVarTag( e, "gkbrkn_processed_entity" )
end

local champion_blacklist_filenames = {
    ["data/entities/animals/apparition/playerghost.xml"] = true,
}

local champion_blacklist_tags = { 
    "boss",
    "gkbrkn_champion",
    "gkbrkn_no_champion",
    "boss_centipede",
    "polymorphed",
    "necromancer_shop",
    "drone_friendly",
    "wand_ghost",
}

local hero_mode_blacklist_tags = {
    "boss_centipede",
}

local hero_mode_blacklist_filenames = {
    ["data/entities/animals/apparition/playerghost.xml"] = true,
}

local badge_blacklist = {
    ["data/entities/animals/chest_mimic.xml"] = true,
}

local weak_filenames = {
    ["data/entities/animals/lukki/lukki_tiny.xml"] = true,
    ["data/entities/animals/pebble_physics.xml"] = true
}

local weak_if_nearby_filenames = {
    ["data/entities/animals/bat.xml"] = true,
    ["data/entities/animals/miniblob.xml"] = true,
    ["data/entities/misc/fungus_projectile.xml"] = true,
    ["data/entities/animals/fungus_tiny.xml"] = true,
}

function process_wand( e )
    -- Game Modifier - Remove Generic Wands
    if GameHasFlagRun( FLAGS.RemoveGenericWands ) then
        local wand_parent = EntityGetParent( e )
        local wand_holder = EntityGetParent( wand_parent )
        if wand_parent == 0 or wand_parent == nil or wand_holder == player then
            if not wand_is_special( e ) then
                EntityKill( e )
                return
            end
        end
    end

    -- Limited Mana
    if setting_get( "game_modifier_gkbrkn_limited_mana", false ) then
        local ability = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
        if ability then
            if not EntityHasVarTag( e, "gkbrkn_duplicate_wand" ) then
                local mana_max = ability_component_get_stat( ability, "mana_max" )
                local mana_charge_speed = ability_component_get_stat( ability, "mana_charge_speed" )
                local adjusted_mana_max = mana_max * math.pow( mana_charge_speed, 0.4 )
                ability_component_set_stat( ability, "mana", adjusted_mana_max )
                ability_component_set_stat( ability, "mana_max", adjusted_mana_max )
                ability_component_set_stat( ability, "mana_charge_speed", 0 )
            end
        end
    end

    -- Game Modifier - No Wand Editing
    if GameHasFlagRun( FLAGS.NoWandEditing ) then
        if EntityGetVariableNumber( e, "gkbrkn_no_edit", nil ) == nil then
            EntitySetVariableNumber( e, "gkbrkn_no_edit", 1 )
            local wand_children = EntityGetAllChildren( e ) or {}
            for _,child in pairs( wand_children ) do
                local component = EntityGetFirstComponentIncludingDisabled( child, "ItemComponent" )
                if component ~= nil then
                    ComponentSetValue2( component, "is_frozen", true )
                end
            end
        end
        local component = EntityGetFirstComponentIncludingDisabled( e, "ItemComponent" )
        if component ~= nil then
            ComponentSetValue2( component, "is_frozen", true )
        end
    end
    -- Game Modifier - No Shuffle Wands
    if GameHasFlagRun( FLAGS.OrderWandsOnly ) then
        for _,ability in pairs( EntityGetComponent( e, "AbilityComponent") or {} ) do
            ability_component_set_stat( ability, "shuffle_deck_when_empty", false )
        end
    -- Game Modifier - No Order Wands
    elseif GameHasFlagRun( FLAGS.ShuffleWandsOnly ) then
        for _,ability in pairs( EntityGetComponent( e, "AbilityComponent") or {} ) do
            ability_component_set_stat( ability, "shuffle_deck_when_empty", true )
        end
    end
end

local align_champion_badges = function( e )
    local sprites = EntityGetComponent( e, "SpriteComponent", "gkbrkn_champion_badge" ) or {}
    if #sprites <= 0 then return end
    local columns = 6
    local badge_width = 10
    local badge_height = 10
    local _,height = EntityGetFirstHitboxSize( e )
    if height == nil then
        height = 0
    end
    height = math.max( height, 8 )
    local x = 0
    local y = 0
    local i = 0
    for _,badge in ipairs( sprites ) do
        local badges_in_this_row = math.min( columns, #sprites - y * columns )
        local offset_x = x * -badge_width + badges_in_this_row * badge_width * 0.5
        local offset_y = y * badge_height + height + badge_height * 2
        ComponentSetValue2( badge, "offset_x", offset_x )
        ComponentSetValue2( badge, "offset_y", offset_y )
        i = i + 1
        x = x + 1
        if x >= columns then
            x = 0
            y = y + 1
        end
    end
end

function process_enemy( e )
    local filename = EntityGetFilename(e)
    local x, y = EntityGetTransform( e )

    -- Enemy Intangibility Frames
    if GameHasFlagRun( FLAGS.EnemyIntangibilityFrames ) then
        EntityAddComponent2( e, "LuaComponent", { script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/intangibility_frames/damage_received.lua" } )
    end

    -- Enemy Invincibility Frames
    if GameHasFlagRun( FLAGS.EnemyInvincibilityFrames ) then
        EntityAddComponent2( e, "LuaComponent", { script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/invincibility_frames/damage_received.lua" } )
    end

    if filename == "data/entities/animals/chest_mimic.xml" and setting_get( FLAGS.MimicsAreChests, false ) then
        for _,c in pairs(EntityGetComponent( e, "LuaComponent" )) do
            if ComponentGetValue2( c, "script_death" ) == "data/scripts/items/drop_money.lua" then
                ComponentSetValue2( c, "script_death", "mods/gkbrkn_noita/files/gkbrkn/misc/mimic_chest.lua" )
            end
        end
    end

    -- Tweak - Blood Amount
    if setting_get("tweak_blood_amount") then
        EntityAddComponent2( e, "LuaComponent", { script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/blood_tweak/damage_received.lua" } )
    end

    local make_champion = false
    if EntityGetIsAlive(e) then
        -- Champion Enemies
        if EntityHasVarTag( e, "gkbrkn_force_champion" ) then
            make_champion = true
        end
        local px, py = 0, 0
        if player ~= 0 and EntityGetIsAlive(player) then
            px, py = EntityGetTransform( player )
        end
        local is_near_player = get_distance( px, py, x, y ) <= 300
        if GameHasFlagRun( MISC.ChampionEnemies.EnabledFlag ) then
            local bail = false
            for _,tag in pairs(champion_blacklist_tags) do
                if EntityHasTag( e, tag ) or EntityHasVarTag( e, tag ) then
                    bail = true
                    break
                end
            end
            if not bail then
                if champion_blacklist_filenames[filename] ~= true then
                    SetRandomSeed( now, x + y + e )
                    if GameHasFlagRun( MISC.ChampionEnemies.AlwaysChampionsFlag ) or Random() <= MISC.ChampionEnemies.ChampionChance then
                        make_champion = true
                        if weak_filenames[filename] == true or
                        not does_entity_drop_gold( e ) or 
                        (weak_if_nearby_filenames[filename] == true and is_near_player) then
                            EntityAddVarTag( e, "gkbrkn_weak_champion" )
                        end
                    else
                        EntityAddVarTag( e, "gkbrkn_no_champion" )
                    end
                end
            end
        end
    end
    local exclusion_groups = {}
    local champion_exclusion = {}

    local parallel_world_x, parallel_world_y = GetParallelWorldPosition( x, y )
    local parallel_world_distance = math.abs( parallel_world_x ) + math.abs( parallel_world_y )

    -- Champion Modifiers
    if make_champion then
        if setting_get( FLAGS.PersistentSpecialEntities, false ) then
            for _,c in pairs(EntityGetComponent( e, "CameraBoundComponent" ) or {}) do EntityRemoveComponent( e, c ) end
        end
        SetRandomSeed( now, x + y + e * 10 )
        EntityAddVarTag( e, "gkbrkn_champion" )
        EntityRemoveVarTag( e, "gkbrkn_force_champion" )

        local weighted_champion_types = {}
        for index,champion_type_data in pairs( champion_types ) do
            weighted_champion_types[champion_type_data.id] = champion_type_data.weight or 1
        end

        local is_mini_boss = false
        local champion_types_to_apply = 1 + parallel_world_distance
        local champions_encountered = tonumber( GlobalsGetValue( "gkbrkn_champion_enemies_encountered" ) ) or 0
        if GameHasFlagRun( MISC.ChampionEnemies.SuperChampionsFlag ) then
            local extra_type_chance = MISC.ChampionEnemies.ExtraTypeChance + champions_encountered * 0.0012
            local random_roll = Random()
            while random_roll <= extra_type_chance do
                champion_types_to_apply = champion_types_to_apply + 1
                extra_type_chance = extra_type_chance - random_roll
                random_roll = Random()
            end
        end
        if GameHasFlagRun( MISC.ChampionEnemies.ValourFlag ) then
            champion_types_to_apply = champion_types_to_apply + MISC.ChampionEnemies.ValourBonus
        end
        if EntityHasVarTag( e, "gkbrkn_weak_champion" ) then
            champion_types_to_apply = math.ceil( champion_types_to_apply * 0.20 )
        else
            if GameHasFlagRun( MISC.ChampionEnemies.MiniBossesFlag ) then
                local next_mini_boss = tonumber( GlobalsGetValue( "gkbrkn_next_miniboss" ) ) or 0
                if champions_encountered >= next_mini_boss then
                    is_mini_boss = Random() <= MISC.ChampionEnemies.MiniBossChance
                    if is_mini_boss == true then
                        EntityAddVarTag( e, "gkbrkn_mini_boss" )
                        GlobalsSetValue( "gkbrkn_next_miniboss", next_mini_boss + MISC.ChampionEnemies.MiniBossThreshold )
                    end
                end
            end
        end

        local add_these_badges = {}

        local apply_these_champion_types = {}
        if is_mini_boss then
            champion_types_to_apply = champion_types_to_apply * 2
            apply_these_champion_types = {
                all_seeing_eye = 1,
                reward = 1,
                mini_boss = 1,
            }
        end

        local to_apply = champion_types_to_apply
        local bail_limit = 10
        if not EntityHasVarTag( e, "gkbrkn_weak_champion" ) then
            GlobalsSetValue( "gkbrkn_champion_enemies_encountered", champions_encountered + 1 )
        end
        while to_apply > 0 do
            local champion_type_id = WeightedRandomTable( weighted_champion_types )
            if not champion_type_id then break end
            local champion_type = get_champion_type(champion_type_id)
            local bail = false
            if champion_type.validator ~= nil and champion_type.validator( e, apply_these_champion_types ) == false then
                bail = true
            end
            if champion_type.exclusion_groups ~= nil then
                for _,group in ipairs(champion_type.exclusion_groups) do
                    if exclusion_groups[group] ~= nil then
                        bail = true
                        break
                    end
                end
                for _,group in ipairs(champion_type.exclusion_groups or {}) do
                    exclusion_groups[group] = true
                end
            end
            if not bail then
                apply_these_champion_types[champion_type_id] = (apply_these_champion_types[champion_type_id] or 0) + 1
                if champion_type.stackable ~= true then
                    apply_these_champion_types[champion_type_id] = 1
                    weighted_champion_types[champion_type_id] = nil
                end
                to_apply = to_apply - 1
                bail_limit = 10
            end
            bail_limit = bail_limit - 1
            if bail_limit <= 0 then
                break
            end
        end

        -- Per champion type
        local total_reward = 0.0
        for champion_id,amount_to_apply in pairs( apply_these_champion_types ) do
            local champion_data = get_champion_type(champion_id)
            if not champion_data then
                print(champion_id, "datamissing")
            end
            for i=1,amount_to_apply do
                total_reward = total_reward + (champion_data.reward or 1.0)

                -- Badges
                if setting_get( MISC.ChampionEnemies.ShowIconsFlag, false ) and champion_data.sprite ~= nil then
                    table.insert( add_these_badges, champion_data.sprite )
                end

                -- Game Effects
                for _,game_effect in pairs( champion_data.game_effects or {} ) do
                    local effect = GetGameEffectLoadTo( e, game_effect, true )
                    if effect ~= nil then ComponentSetValue2( effect, "frames", -1 ) end
                end

                -- General Application
                if champion_data.apply ~= nil then
                    champion_data.apply( e, i, amount_to_apply )
                end
            end

            -- Particle Emitter
            local particle_material = champion_data.particle_material
            if particle_material ~= nil then
                local emitter_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/particles.xml" )
                local emitter = EntityGetFirstComponent( emitter_entity, "ParticleEmitterComponent" )
                if emitter ~= nil then
                    ComponentSetValue2( emitter, "emitted_material_name", particle_material )
                    EntityAddChild( e, emitter_entity )
                end
                ComponentSetValue2( emitter, "gravity", 0, -200 )
            end

            -- Sprite Particle Emitter
            local sprite_particle_sprite_file = champion_data.sprite_particle_sprite_file
            if sprite_particle_sprite_file ~= nil then
                local emitter_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/sprite_particles.xml" )
                local emitter = EntityGetFirstComponent( emitter_entity, "SpriteParticleEmitterComponent" )
                if emitter ~= nil then
                    ComponentSetValue2( emitter, "sprite_file", sprite_particle_sprite_file )
                    EntityAddChild( e, emitter_entity )
                end
            end
        end

        -- Mini-Boss Particle Emitter
        if is_mini_boss then
            local emitter_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/mini_boss_particles.xml" )
            EntityAddChild( e, emitter_entity )
        end

        -- Mini-Boss Health Bar
        if is_mini_boss and EntityGetFirstComponent( e, "HealthBarComponent" ) == nil then
            add_entity_mini_health_bar( e )
        end
        
        if #add_these_badges > 0 and badge_blacklist[filename] == nil and EntityGetIsAlive( e ) then
            for _,badge_filepath in pairs( add_these_badges ) do
                local sprite = EntityAddComponent2( e, "SpriteComponent", {
                    z_index = -1,
                    image_file = badge_filepath,
                    never_ragdollify_on_death = true,
                    has_special_scale = true,
                    update_transform_rotation = false,
                    special_scale_x = 1,
                    special_scale_y = 1,
                } )
                ComponentAddTag( sprite, "gkbrkn_champion_badge" )
            end
            align_champion_badges(e)
        end
    end

    -- Hero Mode Scaling
    if GameHasFlagRun( MISC.HeroMode.EnabledFlag ) then
        local bail = false
        if hero_mode_blacklist_filenames[EntityGetFilename(e)] == true then
            bail = true
        end
        if not bail then
            for _,tag in pairs(hero_mode_blacklist_tags) do
                if EntityHasTag( e, tag ) or EntityHasVarTag( e, tag ) then
                    bail = true
                    break
                end
            end
        end
        if not bail then
            hero_mode_process_entity( e )
        end
    end
end

function process_gold_nugget( e )
    local world_entity_id = GameGetWorldStateEntity()

    local world_state = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
    local is_gold_forever = false
    if world_state ~= nil then
        is_gold_forever = ComponentGetValue2( world_state, "perk_gold_is_forever" )
    end

    local item = EntityGetFirstComponent( e, "ItemComponent" )

    -- Combine Gold
    --[[ This has duplication issues leading to very high value gold nuggets. Disabling for now in favour of drop_money replacement
    if setting_get( MISC.CombineGold.EnabledFlag, false ) then
        local nugget_sizes = { 10, 50, 200, 1000, 10000, 200000 }
        SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
        if EntityGetIsAlive( e ) then
            local x, y = EntityGetTransform( e )
            local nearby_gold_nuggets = EntityGetInRadiusWithTag( x, y, 32, "gold_nugget" )
            if #nearby_gold_nuggets > 1 then
                local nearby_gold_nugget = EntityGetInRadiusWithTag( x, y, 32, "gold_nugget" )[1]
                while nearby_gold_nugget == gold_nugget and #nearby_gold_nuggets > 1 do
                    nearby_gold_nugget = nearby_gold_nuggets[ Random() ]
                end
                if nearby_gold_nugget ~= e and EntityGetIsAlive( nearby_gold_nugget ) then
                    local gold_value = 0
                    local hp_value = 0
                    local creation_frame = 0
                    local kill_frame = 0
                    local nuggets_to_combine = { e, nearby_gold_nugget }
                    for _,nugget in pairs(nuggets_to_combine) do
                        local components = EntityGetComponent( nugget, "VariableStorageComponent" ) or {}
                        for _,component in pairs( components ) do 
                            if ComponentGetValue2( component, "name" ) == "gold_value" then
                                gold_value = gold_value + ComponentGetValue2( component, "value_int" )
                            end
                            if ComponentGetValue2( component, "name" ) == "hp_value" then
                                hp_value = hp_value + ComponentGetValue2( component, "value_float" )
                            end
                        end
                        local lifetime = EntityGetFirstComponent( nugget, "LifetimeComponent" )
                        if lifetime ~= nil then
                            kill_frame  = kill_frame + ComponentGetValue2( lifetime, "kill_frame" )
                            creation_frame  = creation_frame + ComponentGetValue2( lifetime, "creation_frame" )
                        end
                        clear_lost_treasure( nugget )
                        clear_gold_decay( nugget )
                        EntityKill( nugget )
                    end
                    gold_value = gold_value
                    hp_value = hp_value
                    creation_frame = math.ceil( creation_frame / 2 )
                    kill_frame = math.ceil( kill_frame / 2 )
                    local new_size = 10
                    for i=2,#nugget_sizes do
                        local size = nugget_sizes[i]
                        if gold_value >= size then
                            new_size = size
                        end
                    end
                    -- make new nug
                    if hp_value > 0 then
                        e = EntityLoad( "data/entities/items/pickup/bloodmoney_"..new_size..".xml", x, y )
                    else
                        e = EntityLoad( "data/entities/items/pickup/goldnugget_"..new_size..".xml", x, y )
                    end
                    if setting_get( FLAGS.PersistentSpecialEntities, false ) then
                        for _,c in pairs(EntityGetComponent( e, "CameraBoundComponent" ) or {}) do EntityRemoveComponent( e, c ) end
                    end
                    local components = EntityGetComponent( e, "VariableStorageComponent" ) or {}
                    for _,component in pairs( components ) do 
                        if gold_value and ComponentGetValue2( component, "name" ) == "gold_value" then
                            ComponentSetValue2( component, "value_int", gold_value )
                        end
                        if hp_value and ComponentGetValue2( component, "name" ) == "hp_value" then
                            ComponentSetValue2( component, "value_float", hp_value )
                        end
                    end
                    local lifetime = EntityGetFirstComponent( e, "LifetimeComponent" )
                    if lifetime then
                        if is_gold_forever then
                            EntityRemoveComponent( e, lifetime )
                        else 
                            if kill_frame ~= 0 and creation_frame ~= 0 then
                                ComponentSetValue2( lifetime, "kill_frame", kill_frame )
                                ComponentSetValue2( lifetime, "creation_frame", creation_frame )
                            else
                                EntityRemoveComponent( e, lifetime )
                            end
                        end
                    end
                    local item = EntityGetFirstComponent( e, "ItemComponent" )
                    if item ~= nil then
                        if hp_value > 0 then
                            ComponentSetValue2( item, "item_name", GameTextGetTranslatedOrNot("$item_bloodmoney").." ("..gold_value..")" )
                        else
                            ComponentSetValue2( item, "item_name", GameTextGetTranslatedOrNot("$item_goldnugget").." ("..gold_value..")" )
                        end
                    end
                    
                    local ui_info = EntityGetFirstComponent( e, "UIInfoComponent" )
                    if ui_info ~= nil then
                        if hp_value > 0 then
                            ComponentSetValue2( ui_info, "name", GameTextGetTranslatedOrNot("$item_bloodmoney").." ("..gold_value..")" )
                        else
                            ComponentSetValue2( ui_info, "name", GameTextGetTranslatedOrNot("$item_goldnugget").." ("..gold_value..")" )
                        end
                    end
                end
            end
        end
    end

    -- Don't bother with anything else if this gold was just combined
    if not EntityGetIsAlive( e ) then return end
    ]]

    -- Persistent Gold
    if setting_get( MISC.PersistentGold.EnabledFlag, false ) then
        local lifetime_component = EntityGetFirstComponent( e, "LifetimeComponent" )
        if lifetime_component ~= nil then
            EntityRemoveComponent( e, lifetime_component )
        end
    -- Gold Lifetime Multiplier
    elseif setting_get( MISC.GoldLifetime.MultiplierFlag, 1 ) ~= 1 and not EntityHasVarTag( e,"gkbrkn_lifetime_goldnugget" ) then
        EntityAddVarTag( e,"gkbrkn_lifetime_goldnugget" )
        local lifetime_component = EntityGetFirstComponent( e, "LifetimeComponent" )
        if lifetime_component ~= nil then
            ComponentSetValue2( lifetime_component, "kill_frame", ComponentGetValue2( lifetime_component, "creation_frame" ) + ComponentGetValue2( lifetime_component, "lifetime" ) * setting_get( MISC.GoldLifetime.MultiplierFlag, 1 ) )
        end
    end
    
    -- Lost Treasure
    if not EntityHasVarTag( e, "gkbrkn_lost_treasure" ) then
        local lifetime_component = EntityGetFirstComponent( e, "LifetimeComponent" )
        -- don't track gold nuggets that won't despawn naturally
        if lifetime_component ~= nil then
            set_lost_treasure( e )
        end
    end
        
    -- Gold Decay
    if setting_get( MISC.GoldDecay.EnabledFlag, false ) and not EntityHasVarTag( e, "gkbrkn_gold_decay" ) then
        local lifetime_component = EntityGetFirstComponent( e, "LifetimeComponent" )
        if lifetime_component ~= nil then
            set_gold_decay( e )
        end
    end

    -- Gold Spawn Velocity
    if setting_get( MISC.JumpyGold.MultiplierFlag, 0 ) > 0 then
        --PhysicsApplyForce( gold_nugget, Random( -100, 100 ) * setting_get( MISC.JumpyGold.MultiplierFlag, 0 ), Random( -50, -100 )* setting_get( MISC.JumpyGold.MultiplierFlag, 0 ) )
        local v = (setting_get( MISC.JumpyGold.MultiplierFlag, 1 ) * 10 ) * (math.random() * 0.5 + 0.5)
        PhysicsApplyForce( e, random_velocity( -math.pi * 0.35 - math.pi * 0.5, math.pi * 0.35 - math.pi * 0.5, v ) )
    end

end