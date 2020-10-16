dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

--[[ NORMAL ]]
    table.insert( actions, generate_action_entry(
        "GKBRKN_DUMMY_SHOT", "dummy_shot", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 10, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/dummy_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_ARCANE_BUCKSHOT", "arcane_buckshot", ACTION_TYPE_PROJECTILE,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 210, 12, -1,
        nil, 
        function()
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_buckshot/projectile.xml" );
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_buckshot/projectile.xml" );
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_buckshot/projectile.xml" );
            c.fire_rate_wait = c.fire_rate_wait + 16;
            current_reload_time = current_reload_time + 42;
        end, true
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_SEPARATOR", "separator", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.3,0.3,0.3,0.3,0.3,0.3,0.3", 210, 0, -1,
        nil, 
        function()
            if reflecting then return; end
            local old_c = c;
            BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" );
                BeginTriggerDeath();
                    c = {};
                    for k,v in pairs(old_c) do
                        c[k] = v;
                    end
                    draw_actions( 1, true );
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
            EndProjectile();
            c = old_c;
        end
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_ARCANE_SHOT", "arcane_shot", ACTION_TYPE_PROJECTILE,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 375, 65, -1,
        nil,
        function()
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_shot/projectile.xml" );
            c.fire_rate_wait = c.fire_rate_wait + 30;
            current_reload_time = current_reload_time + 90
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_BARRIER_TRAIL", "barrier_trail", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7,0.7,0.7", 200, 20, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/barrier_trail/wall_builder.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_BREAK_CAST", "break_cast", ACTION_TYPE_UTILITY,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 50, 2, -1,
        nil,
        function()
            c.fire_rate_wait = c.fire_rate_wait - 10.2;
            current_reload_time = current_reload_time - 10.2;
            skip_cards();
        end, true
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_BURST_FIRE", "burst_fire", ACTION_TYPE_STATIC_PROJECTILE,
        "0,1,2,3,4,5,6", "1.0,1.0,1.0,1.0,1.0,1.0,1.0", 300, 9, -1,
        nil,
        function()
            --c.fire_rate_wait = c.fire_rate_wait - 5;
            local projectile_path = "mods/gkbrkn_noita/files/gkbrkn/actions/burst_fire/projectile.xml";
            if reflecting then 
                Reflection_RegisterProjectile( projectile_path );
                return;
            end
            local burst_wait = (c.fire_rate_wait + math.ceil( gun.reload_time / 5 )) / 3;
            local base_fire_rate_wait = c.fire_rate_wait;
            local old_c = c;
            c = {};
            reset_modifiers( c );

            local deck_snapshot = peek_draw_actions( 1, true );

            BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" );
                BeginTriggerDeath();
                    BeginProjectile( projectile_path );
                        BeginTriggerTimer( 1 );
                            reset_modifiers( c );
                            for k,v in pairs( old_c ) do
                                c[k] = v;
                            end
                            c.spread_degrees = c.spread_degrees + 2;
                            temporary_deck( function( deck, hand, discarded ) draw_actions( 1, true ); end, deck_from_actions( deck_snapshot ), {}, {} );
                            register_action( c );
                            SetProjectileConfigs();
                        EndTrigger();

                        BeginTriggerTimer( burst_wait );
                            reset_modifiers( c );
                            for k,v in pairs( old_c ) do
                                c[k] = v;
                            end
                            c.spread_degrees = c.spread_degrees + 2;
                            temporary_deck( function( deck, hand, discarded ) draw_actions( 1, true ); end, deck_from_actions( deck_snapshot ), {}, {} );
                            register_action( c );
                            SetProjectileConfigs();
                        EndTrigger();

                        BeginTriggerTimer( burst_wait * 2 );
                            reset_modifiers( c );
                            for k,v in pairs( old_c ) do
                                c[k] = v;
                            end
                            c.spread_degrees = c.spread_degrees + 2;
                            temporary_deck( function( deck, hand, discarded ) draw_actions( 1, true ); end, deck_from_actions( deck_snapshot ), {}, {} );
                            register_action( c );
                            SetProjectileConfigs();
                        EndTrigger();
                    EndProjectile();
                    reset_modifiers( c );
                    c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/carry_shot/projectile_extra_entity.xml,";
                    c.lifetime_add = c.lifetime_add + burst_wait * 3;
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
            EndProjectile();
            c = old_c;
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_CARPET_BOMB", "carpet_bomb", ACTION_TYPE_OTHER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 50, -1,
        nil,
        function()
            current_reload_time = current_reload_time + 30;
            local _current_reload_time = current_reload_time;
            if reflecting then 
                return;
            end
            local _deck = deck;
            local _hand = hand;
            local _discarded = discarded;
            local old_capture = gkbrkn.add_projectile_capture_callback;
            gkbrkn.add_projectile_capture_callback = function( filepath )
                gkbrkn.add_projectile_capture_callback = old_capture;
                local captured_deck = nil;
                local old_c = c;
                BeginProjectile( filepath );
                    BeginTriggerTimer( 2 );
                        c = {};
                        reset_modifiers( c );
                        c.speed_multiplier = 0;
                        c.gravity = c.gravity + 1000;
                        if captured_deck == nil then
                            captured_deck = capture_draw_actions( 1, true );
                            hand, discarded = {}, {};
                        end
                        state_per_cast( c );
                        register_action( c );
                        SetProjectileConfigs();
                    EndTrigger();
                    for i=1,100 do
                        BeginTriggerTimer( 2 + i * 2 );
                            reset_modifiers( c );
                            c.speed_multiplier = 0;
                            c.gravity = c.gravity + 1000;
                            deck = {};
                            for _,v in pairs( captured_deck ) do
                                table.insert( deck, v );
                            end
                            draw_actions( 1, true );
                            state_per_cast( c );
                            register_action( c );
                            SetProjectileConfigs();
                        EndTrigger();
                    end
                EndProjectile();
                hand, discarded = _hand, _discarded;
                c = old_c;
                register_action( c );
                SetProjectileConfigs();
            end
            draw_actions( 1, true );
            deck = _deck;
            current_reload_time = _current_reload_time;
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_CARRY_SHOT", "carry_shot", ACTION_TYPE_UTILITY,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 160, 4, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/carry_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_CHAIN_CAST", "chain_cast", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33,0.33", 200, 50, -1,
        nil,
        function()
            c.speed_multiplier = c.speed_multiplier * 0.50;
            c.fire_rate_wait = c.fire_rate_wait + 35;
            c.spread_degrees = c.spread_degrees + 7;
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/chain_cast/projectile_extra_entity.xml,mods/gkbrkn_noita/files/gkbrkn/actions/chain_cast/trail.xml,"
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_CHAOTIC_BURST", "chaotic_burst", ACTION_TYPE_PROJECTILE,
        "0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 260, 42, -1,
        nil,
        function()
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_COLLISION_DETECTION", "collision_detection", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 90, 4, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/collision_detection/projectile_extra_entity.xml,";
            c.speed_multiplier = c.speed_multiplier * 0.85;
            c.bounces = math.max( 1, c.bounces );
            draw_actions( 1, true );
        end, true
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_COPY_SPELL", "copy_spell", ACTION_TYPE_OTHER,
        "0,1,2,3,4,5,6", "0.8,0.8,0.8,0.8,0.8,0.8,0.8", 300, 20, -1,
        nil,
        function()
            local drawn = false;
            for index,action in pairs( deck ) do
                if action.uses_remaining == nil or action.uses_remaining < 0 then
                    action.action();
                    drawn = true;
                    break;
                end
            end
            if drawn == false then
                draw_actions( 1, true );
            end
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_CURIOUS_SHOT", "curious_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7,0.7,0.7", 130, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/curious_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_DAMAGE_BOUNCE", "damage_bounce", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 7, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/damage_bounce/projectile_extra_entity.xml,";
            c.bounces = c.bounces + 3;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_DAMAGE_LIFETIME", "damage_lifetime", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 130, 9, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/damage_lifetime/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_DESTRUCTIVE_SHOT", "destructive_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 250, 30, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/destructive_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_DOUBLE_CAST", "double_cast", ACTION_TYPE_OTHER,
        "0,1,2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7,0.7,0.7", 400, 0, -1,
        nil,
        function()
            if reflecting then return; end
            duplicate_draw_action( 1, 2, true );
        end
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_DRAW_DECK", "draw_deck", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33,0.33", 280, 30, -1,
        nil,
        function()
            draw_actions( #deck, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_DUPLICAST", "duplicast", ACTION_TYPE_OTHER,
        "0,1,2,3,4,5,6", "0.8,0.8,0.8,0.8,0.8,0.8,0.8", 100, 5, -1,
        nil,
        function()
            gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 5.00;
            current_reload_time = current_reload_time + 30;
            c.pattern_degrees = c.pattern_degrees + 180;
            gkbrkn.extra_projectiles = gkbrkn.extra_projectiles + 7;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_FALSE_SPELL", "false_spell", ACTION_TYPE_PROJECTILE,
        "0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 90, 1, -1,
        nil,
        function()
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/false_spell/projectile.xml" );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_FAMILIAR_SHOT", "familiar_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 3, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/familiar_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_FEATHER_SHOT", "feather_shot", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 100, 3, -1,
        nil,
        function()
            c.lifetime_add = c.lifetime_add + 21;
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/feather_shot/projectile_extra_entity.xml,";
            current_reload_time = current_reload_time - 6;
            draw_actions( 1, true );
        end
    ) );

    --table.insert( actions, generate_action_entry(
    --    "GKBRKN_TEST_SHOT", "test_shot", ACTION_TYPE_MODIFIER, 
    --    "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 100, 1, -1,
    --    nil,
    --    function()
    --        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/test_shot/projectile.xml" );
    --    end
    --) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_FOLLOW_SHOT", "follow_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7,0.7,0.7", 120, 3, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/follow_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_FRACTURE", "fracture", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1.0,1.0,1.0,1.0,1.0,1.0,1.0", 300, 9, -1,
        nil,    
        function()
            local old_c = c;
            c = {};
            for k,v in pairs(old_c) do
                c[k] = v;
            end
            local inside_c = nil;
            local old_capture = gkbrkn.add_projectile_capture_callback;
            gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 3.00;
            gkbrkn._fractures = (gkbrkn._fractures or 0) + 1;
            gkbrkn.add_projectile_capture_callback = function( filepath, trigger_action_draw_count, trigger_delay_frames )
                BeginProjectile( filepath );
                if gkbrkn.add_projectile_depth <= gkbrkn._fractures then
                    BeginTriggerDeath();
                        inside_c = c;
                        add_projectile( filepath );
                        add_projectile( filepath );
                        add_projectile( filepath );
                        c = {};
                        for k,v in pairs(inside_c) do
                            c[k] = v;
                        end
                        c.spread_degrees = 45;
                        for i=1,gkbrkn.add_projectile_depth do
                            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/fracture/projectile_extra_entity.xml,";
                        end
                        register_action( c );
                        SetProjectileConfigs();
                        c = old_c;
                    EndTrigger();
                end
                EndProjectile();
            end
            draw_actions( 1, true );
            gkbrkn.add_projectile_capture_callback = old_capture;
            gkbrkn._fractures = gkbrkn._fractures - 1;
            gkbrkn.mana_multiplier = gkbrkn.mana_multiplier / 3.00;
            c = old_c;
            if inside_c then
                for k,v in pairs(inside_c) do
                    c[k] = v;
                end
            end
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_GLITTERING_TRAIL", "glittering_trail", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7,0.7,0.7", 120, 10, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/glittering_trail/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_GOLDEN_BLESSING", "golden_blessing", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 1000, 0, 1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/golden_blessing/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_GUIDED_SHOT", "guided_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 160, 8, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/guided_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_HYPER_BOUNCE", "hyper_bounce", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.8,0.8,0.8,0.8,0.8,0.8,0.8", 500, 10, -1,
        nil,
        function()
            c.bounces = c.bounces + 100;
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/hyper_bounce/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_ICE_SHOT", "ice_shot", ACTION_TYPE_PROJECTILE,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 175, 25, -1,
        nil,
        function()
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/ice_shot/projectile.xml" );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_MAGIC_LIGHT", "magic_light", ACTION_TYPE_PASSIVE,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 240, 0, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/custom_card.xml",
        function()
            draw_actions( 1, true );
        end
    ) );

    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
    table.insert( actions, generate_action_entry(
        "GKBRKN_MANA_EFFICIENCY", "mana_efficiency", ACTION_TYPE_UTILITY,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 150, 0, -1,
        nil,
        function()
            gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 0.50;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_MANA_RECHARGE", "mana_recharge", ACTION_TYPE_PASSIVE,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 1, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/mana_recharge/custom_card.xml",
        function()
            draw_actions(1, true);
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_META_CAST", "meta_cast", ACTION_TYPE_UTILITY,
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 180, 4, -1,
        nil,
        function()
            local mana_multiplier = gkbrkn.mana_multiplier;
            gkbrkn.mana_multiplier = 0.5;
            local skip_projectiles = gkbrkn.skip_projectiles;
            gkbrkn.skip_projectiles = true;
            draw_actions( 1, true );
            gkbrkn.mana_multiplier = mana_multiplier;
            gkbrkn.skip_projectiles = skip_projectiles;
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_MICRO_SHIELD", "micro_shield", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 540, 20, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/micro_shield/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_MODIFICATION_FIELD", "modification_field", ACTION_TYPE_STATIC_PROJECTILE,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 200, 50, 3,
        nil,
        function()
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/modification_field/projectile.xml" );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_MULTI_DEATH_TRIGGER", "multi_death_trigger", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33,0.33", 200, 12, -1,
        nil,
        function()
            for i=1,2,1 do
                set_trigger_death( 1 );
            end
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_NGON_SHAPE", "ngon_shape", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33,0.33", 120, 24, -1,
        nil,
        function()
            c.pattern_degrees = 180;
            draw_actions( #deck, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_NUGGET_SHOT", "nugget_shot", ACTION_TYPE_PROJECTILE,
        "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 1000, 30, -1,
        nil,
        function()
            local shooter = GetUpdatedEntityID();
            local wallet = EntityGetFirstComponent( shooter, "WalletComponent" );
            if wallet ~= nil then
                local money = ComponentGetValue2( wallet, "money" );
                local cost = 10;
                if money >= cost then
                    add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/nugget_shot/projectile.xml");
                    ComponentSetValue2( wallet, "money", money - cost );
                end
            end
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_ORDER_DECK", "order_deck", ACTION_TYPE_PASSIVE,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 7, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/order_deck/custom_card.xml",
        function()
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PAPER_SHOT", "paper_shot", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 20, -5, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/paper_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PASSIVE_RECHARGE", "passive_recharge", ACTION_TYPE_PASSIVE,
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 100, 1, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/passive_recharge/custom_card.xml",
        function()
            current_reload_time = current_reload_time - 12;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PATH_CORRECTION", "path_correction", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 250, 30, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/path_correction/projectile_extra_entity.xml,";
            c.speed_multiplier = c.speed_multiplier * 0.75;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PERFECT_CRITICAL", "perfect_critical", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 300, 20, -1,
        nil,
        function()
            c.damage_critical_multiplier = math.max( 1, c.damage_critical_multiplier ) + 1;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PERFORATING_SHOT", "perforating_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7,0.7,0.7", 210, 9, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/perforating_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PERSISTENT_SHOT", "persistent_shot", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 160, 17, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/persistent_shot/projectile_extra_entity.xml,";
            draw_actions( 2, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PIERCING_SHOT", "piercing_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 250, 9, -1,
        nil,
        function()
            c.damage_projectile_add = c.damage_projectile_add + 0.24;
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/piercing_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_POWER_SHOT", "power_shot", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 250, 9, -1,
        nil,
        function()
            c.damage_projectile_add = c.damage_projectile_add + 0.24;
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/power_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_EXTRA_PROJECTILE", "extra_projectile", ACTION_TYPE_OTHER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 320, 12, -1,
        nil,
        function()
            c.fire_rate_wait = c.fire_rate_wait + 6;
            current_reload_time = current_reload_time + 6;
            c.spread_degrees = c.spread_degrees + 2;
            gkbrkn.extra_projectiles = gkbrkn.extra_projectiles + 1;
            draw_actions( 1 , true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PROJECTILE_BURST", "projectile_burst", ACTION_TYPE_OTHER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 480, 30, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/projectile_burst/projectile_extra_entity.xml,";
            c.fire_rate_wait = c.fire_rate_wait + 12;
            current_reload_time = current_reload_time + 12;
            c.spread_degrees = c.spread_degrees + 5;
            gkbrkn.extra_projectiles = gkbrkn.extra_projectiles + 4;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PROTECTIVE_ENCHANTMENT", "protective_enchantment", ACTION_TYPE_UTILITY,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 200, 23, -1,
        nil,
        function()
            gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 3;
            c.fire_rate_wait = c.fire_rate_wait + 17;
            current_reload_time = current_reload_time + 17;
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/protective_enchantment/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PROXIMITY_BURST", "proximity_burst", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 300, 33, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/proximity_burst/projectile_extra_entity.xml,";
            c.lifetime_add = c.lifetime_add + 6;
            c.explosion_radius = c.explosion_radius + 8.0;
            c.damage_explosion_add = c.damage_explosion_add + 0.1;
            set_trigger_death( 1 );
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_RAPID_SHOT", "rapid_shot", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "1.0,1.0,1.0,1.0,1.0,1.0,1.0", 200, 2, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/rapid_shot/projectile_extra_entity.xml,";
            c.spread_degrees = c.spread_degrees + 3;
            c.fire_rate_wait = c.fire_rate_wait - 8;
            current_reload_time = current_reload_time - 12;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_REDUCE_KNOCKBACK", "reduce_knockback", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 100, 5, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/reduce_knockback/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_REVELATION", "revelation", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 3, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/revelation/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_SEEKER_SHOT", "seeker_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1.0,1.0,1.0,1.0,1.0,1.0,1.0", 280, 20, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/seeker_shot/projectile_extra_entity.xml,";
            c.speed_multiplier = c.speed_multiplier * 0.65;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_SHIMMERING_TREASURE", "shimmering_treasure", ACTION_TYPE_UTILITY,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 2, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/shimmering_treasure/custom_card.xml",
        function()
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_SHUFFLE_DECK", "shuffle_deck", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 1, -1,
        nil,
        function()
            local shuffle_deck = {};
            for i=1, #deck do
                local index = Random( 1, #deck );
                local action = deck[ index ];
                table.remove( deck, index );
                table.insert( shuffle_deck, action );
            end
            for index,action in pairs(shuffle_deck) do
                table.insert( deck, action );
            end
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_SPECTRAL_SHOT", "spectral_shot", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 1020, 35, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/spectral_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_SPEED_DOWN", "speed_down", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.8,0.8,0.8,0.8,0.8,0.8,0.8", 50, -3, -1,
        nil,
        function()
            c.speed_multiplier = c.speed_multiplier * 0.40;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_SPELL_DUPLICATOR", "spell_duplicator", ACTION_TYPE_STATIC_PROJECTILE,
        "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 300, 19, -1,
        nil,
        function()
            if reflecting then 
                Reflection_RegisterProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/spell_duplicator/projectile.xml" );
                return;
            end

            function recursive_death_trigger( how_many, old_c, skip_amount, depth, deck_snapshot )
                if depth == nil then
                    depth = (depth or 0) + 1;
                    old_c = c;
                    skip_amount = #hand + 1;
                    c = {};
                    reset_modifiers( c );
                    deck_snapshot = peek_draw_actions( 1, true );

                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/spell_duplicator/projectile.xml" );
                        BeginTriggerDeath();
                            c = {};
                            reset_modifiers( c );
                            c.spread_degrees = c.spread_degrees + 360;
                            temporary_deck( function( deck, hand, discarded ) 
                                draw_actions( 1, true );
                            end, deck_from_actions( deck_snapshot ), {}, {} );
                            register_action( c );
                            SetProjectileConfigs();
                            c = old_c;
                        EndTrigger();

                        if how_many > 1 then
                            recursive_death_trigger( how_many - 1, old_c, skip_amount, depth, deck_snapshot );
                        end

                    EndProjectile();
                    register_action( old_c );
                    c = old_c;
                    SetProjectileConfigs();
                else
                    BeginTriggerDeath();
                        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/spell_duplicator/projectile.xml" );
                            BeginTriggerDeath();
                                c = {};
                                reset_modifiers( c );
                                c.spread_degrees = c.spread_degrees + 360;
                                temporary_deck( function( deck, hand, discarded ) 
                                    draw_actions( 1, true );
                                end, deck_from_actions( deck_snapshot ), {}, {} );
                                register_action( c );
                                SetProjectileConfigs();
                                c = old_c;
                            EndTrigger();

                            if how_many > 1 then
                                recursive_death_trigger( how_many - 1, old_c, skip_amount, depth, deck_snapshot );
                            end
                        EndProjectile();

                        register_action( old_c );
                        SetProjectileConfigs();
                    EndTrigger();
                end
            end
            recursive_death_trigger( 5 );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_SPELL_EFFICIENCY", "spell_efficiency", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 380, 0, -1,
        nil,
        function()
            --reduce_spell_usage( 0.33 );
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_STICKY_SHOT", "sticky_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 200, 9, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/sticky_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_STORED_SHOT", "stored_shot", ACTION_TYPE_STATIC_PROJECTILE,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 160, 4, -1,
        nil,
        function()
            add_projectile_trigger_death( "mods/gkbrkn_noita/files/gkbrkn/actions/stored_shot/projectile.xml", 1 );
            current_reload_time = current_reload_time + 3;
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_SUPER_BOUNCE", "super_bounce", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 90, 3, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/super_bounce/projectile_extra_entity.xml,";
            c.bounces = c.bounces + 2;
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_TIME_COMPRESSION", "time_compression", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 150, 4, -1,
        nil,
        function()
            c.lifetime_add = c.lifetime_add - 9999;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_TREASURE_SENSE", "treasure_sense", ACTION_TYPE_UTILITY,
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 140, 2, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/treasure_sense/custom_card.xml",
        function()
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_TRIGGER_DEATH", "trigger_death", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 250, 10, -1,
        nil,
        function()
            set_trigger_death( 1 );
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_TRIGGER_HIT", "trigger_hit", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 250, 10, -1,
        nil,
        function()
            set_trigger_hit_world( 1 );
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_TRIGGER_TIMER", "trigger_timer", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 250, 10, -1,
        nil,
        function()
            set_trigger_timer( 10, 1 );
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_TRIPLE_CAST", "triple_cast", ACTION_TYPE_OTHER,
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 500, 0, -1,
        nil,
        function()
            if reflecting then return; end
            duplicate_draw_action( 1, 3, true );
        end
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_ZAP", "zap", ACTION_TYPE_PROJECTILE,
        "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 170, 8, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/zap/custom_card.xml",
        function()
            c.fire_rate_wait = c.fire_rate_wait - 5;
            current_reload_time = current_reload_time - 5;
            --add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
            
            if reflecting then 
                Reflection_RegisterProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                return;
            end

            if GameGetFrameNum() % 3 == 0 then
                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                BeginTriggerDeath();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    BeginTriggerDeath();
                        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                        EndProjectile();
                        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                        EndProjectile();
                        register_action( c );
                        SetProjectileConfigs();
                    EndTrigger();
                    EndProjectile();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    BeginTriggerDeath();
                        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                        EndProjectile();
                        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                        EndProjectile();
                        register_action( c );
                        SetProjectileConfigs();
                    EndTrigger();
                    EndProjectile();
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
                EndProjectile();
            elseif GameGetFrameNum() % 3 == 1 then
                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                BeginTriggerDeath();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    BeginTriggerDeath();
                        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                        EndProjectile();
                        register_action( c );
                        SetProjectileConfigs();
                    EndTrigger();
                    EndProjectile();

                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    EndProjectile();

                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    BeginTriggerDeath();
                        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                        EndProjectile();
                        register_action( c );
                        SetProjectileConfigs();
                    EndTrigger();
                    EndProjectile();
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
                EndProjectile();
            else
                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                BeginTriggerDeath();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    BeginTriggerDeath();
                        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                        EndProjectile();
                        register_action( c );
                        SetProjectileConfigs();
                    EndTrigger();
                    EndProjectile();
                EndTrigger();
                EndProjectile();

                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                BeginTriggerDeath();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    BeginTriggerDeath();
                        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                        EndProjectile();
                        register_action( c );
                        SetProjectileConfigs();
                    EndTrigger();
                    EndProjectile();
                EndTrigger();
                EndProjectile();
            end
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_ZERO_GRAVITY", "zero_gravity", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 100, 3, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/zero_gravity/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    --[[
    table.insert( actions, generate_action_entry(
        "GKBRKN_TRIGGER_REPEAT", "trigger_repeat", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 0, -1,
        nil,
        function()
            simple version doesn't allow me to hook into the draw_actions cast delay
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/projectile_extra_entity.xml,";
            set_trigger_hit_world( 1 )
            local projectile_index = GlobalsGetValue("gkbrkn_projectile_index","0");
            draw_actions( 1, true );
            GlobalsSetValue("gkbrkn_projectile_data_"..tostring(projectile_index), tostring( c.fire_rate_wait + current_reload_time ) );

            c.fire_rate_wait = c.fire_rate_wait + 22;
            current_reload_time = current_reload_time + 22;

            local projectile_path = "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/projectile.xml";
            if reflecting then 
                Reflection_RegisterProjectile( projectile_path );
                return;
            end
            
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/projectile_extra_entity.xml,";
            local old_c = c;
            local captured_trigger_delay = 60; -- default to one second if for some reason capture is impossible
            c = {};
            reset_modifiers( c );

            gkbrkn.add_projectile_capture_callback = function( filepath, trigger_action_draw_count, trigger_delay_frames )
                gkbrkn.add_projectile_capture_callback = nil;
                BeginProjectile( filepath );
                BeginTriggerHitWorld()
                    c = {};
                    reset_modifiers( c );
                    draw_actions( 1, true );
                    captured_trigger_delay = c.fire_rate_wait + current_reload_time;
                    --captured_trigger_delay = c.fire_rate_wait;
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
                EndProjectile();
            end
            local projectile_index = GlobalsGetValue("gkbrkn_projectile_index","0");
            draw_actions( 1, true );
            GlobalsSetValue("gkbrkn_projectile_data_"..tostring(projectile_index), tostring( math.max( 0, captured_trigger_delay ) ) );
            c = old_c;
            register_action( c );
            SetProjectileConfigs();
        end
    ) );
    ]]

    -- TODO revisit this, it's not complete
    table.insert( actions, generate_action_entry(
        "GKBRKN_TRIGGER_REPEAT", "trigger_repeat", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 100, 0, -1,
        nil,
        function()
            c.fire_rate_wait = c.fire_rate_wait + 22;
            current_reload_time = current_reload_time + 22;

            local projectile_path = "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/projectile.xml";
            if reflecting then 
                Reflection_RegisterProjectile( projectile_path );
                return;
            end
            --[[
            ]]
            local old_c = c;
            local pre_c = {};

            local trigger_repeat_group = tonumber( GlobalsGetValue("gkbrkn_trigger_repeat_index","0") );
            GlobalsSetValue("gkbrkn_trigger_repeat_index", tostring( trigger_repeat_group + 1 ) );
            trigger_repeat_group = "trigger_repeat_"..trigger_repeat_group;
            local old_capture = gkbrkn.add_projectile_capture_callback;
            gkbrkn.add_projectile_capture_callback = function( filepath, trigger_action_draw_count, trigger_delay_frames )
                gkbrkn.add_projectile_capture_callback = old_capture;
                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" );
                BeginTriggerDeath()
                    BeginProjectile( filepath );
                    EndProjectile();
                    gkbrkn.register_action_callback = function( state )
                        gkbrkn.register_action_callback = old_register_action_callback;
                        state.action_unidentified_sprite_filename = state.action_unidentified_sprite_filename..trigger_repeat_group..",";
                        state.extra_entities = state.extra_entities..",";
                    end
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
                EndProjectile();

                reset_modifiers( c );
                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" );
                BeginTriggerDeath()
                    pre_c = c;

                    BeginProjectile( projectile_path );
                    BeginTriggerHitWorld()
                        c = {};
                        reset_modifiers( c );
                        draw_actions( 1, true );
                        register_action( c );
                        SetProjectileConfigs();
                    EndTrigger();
                    EndProjectile();
                    gkbrkn.register_action_callback = function( state )
                        gkbrkn.register_action_callback = old_register_action_callback;
                        state.action_unidentified_sprite_filename = state.action_unidentified_sprite_filename..trigger_repeat_group..",";
                        state.extra_entities = state.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/projectile_extra_entity.xml,";
                    end
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
                EndProjectile();
            end
            draw_actions( 1, true );
            c = old_c;
            for k,v in pairs( pre_c ) do
                c[k] = v;
            end
            --c.action_unidentified_sprite_filename = c.action_unidentified_sprite_filename..trigger_repeat_group..",";
            register_action( c );
            SetProjectileConfigs();

--[[
            local trigger_repeat_group = iterate_group("trigger_repeat");
            BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" );
            BeginTriggerDeath();
                BeginProjectile( projectile_path );
                EndProjectile();
                gkbrkn.register_action_callback = function( state )
                    print(" register callbsck")
                    gkbrkn.register_action_callback = old_register_action_callback;
                    state.action_unidentified_sprite_filename = state.action_unidentified_sprite_filename..trigger_repeat_group..",";
                    state.extra_entities = "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/projectile_extra_entity.xml";
                end
            EndTrigger();
            EndProjectile();
            ]]
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_TRIGGER_TAKE_DAMAGE", "trigger_take_damage", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 100, 0, -1,
        nil,
        function()
            local take_damage_triggers = EntityGetWithTag("gkbrkn_trigger_take_damage_projectile") or {};
            for _,trigger in pairs(take_damage_triggers) do
                EntityKill(trigger);
            end
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_take_damage/projectile_extra_entity.xml,";
            add_projectile_trigger_hit_world( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_take_damage/projectile.xml", 1 );
        end
    ) );


    table.insert( actions, generate_action_entry(
        "GKBRKN_AREA_SHOT", "area_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 150, 4, -1,
        nil,
        function()
            if not c.extra_entities:find("mods/gkbrkn_noita/files/gkbrkn/actions/area_shot/projectile_extra_entity.xml_unique,") then
                c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/area_shot/projectile_extra_entity_unique.xml,";
            end
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/area_shot/projectile_extra_entity.xml,";
            gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 2;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_ANCHORED_SHOT", "anchored_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 150, 6, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/anchored_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

--[[ CAPTURES ]]
    local capture_projectile_draw = function( capture_id, amount )
        if reflecting then return; end
        local projectile_path = "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml";
        local old_c = c;
        local new_cast_delay = c.fire_rate_wait;
        c = {};
        reset_modifiers( c );
        for k,v in pairs(old_c) do
            c[k] = v;
        end
        BeginProjectile( projectile_path );
            BeginTriggerDeath();
                c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/"..capture_id.."/projectile_extra_entity.xml,";
                c.lifetime_add = c.lifetime_add + 1;
                draw_actions( amount, true );
                local old_register_action_callback = gkbrkn.register_action_callback;
                gkbrkn.register_action_callback = function( state )
                    gkbrkn.register_action_callback = old_register_action_callback;
                    state.action_unidentified_sprite_filename = state.action_unidentified_sprite_filename..iterate_group(capture_id)..",";
                end
                new_cast_delay = c.fire_rate_wait;
                register_action( c );
                SetProjectileConfigs();
            EndTrigger();
        EndProjectile();
        c = old_c;
        c.fire_rate_wait = c.fire_rate_wait + new_cast_delay;
    end

    table.insert( actions, generate_action_entry(
        "GKBRKN_FORMATION_STACK", "formation_stack", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 160, 2, -1,
        nil,
        function()
            capture_projectile_draw( "formation_stack", 3 );
        end
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_LINK_SHOT", "link_shot", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 190, 7, -1,
        nil,
        function()
            capture_projectile_draw( "link_shot", 2 );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_SPELL_MERGE", "spell_merge", ACTION_TYPE_DRAW_MANY, 
        "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 190, 14, -1,
        nil,
        function()
            capture_projectile_draw( "spell_merge", 2 );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PROJECTILE_GRAVITY_WELL", "projectile_gravity_well", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 210, 5, -1,
        nil,
        function()
            c.speed_multiplier = c.speed_multiplier * 0.75;
            capture_projectile_draw( "projectile_gravity_well", 3 );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PROJECTILE_ORBIT", "projectile_orbit", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 100, 12, -1,
        nil,
        function()
            capture_projectile_draw( "projectile_orbit", 5 );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_TRAILING_SHOT", "trailing_shot", ACTION_TYPE_DRAW_MANY, 
        "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 10, 5, -1,
        nil,
        function()
            capture_projectile_draw( "trailing_shot", 4 );
        end
    ) );

--[[ SUPERS ]]
    table.insert( actions, generate_action_entry(
        "GKBRKN_CONTROL", "control", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.25,0.25,0.25,0.25,0.25,0.25,0.25", 10, 3, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/control/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_CLINGING_SHOT", "clinging_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.25,0.25,0.25,0.25,0.25,0.25,0.25", 150, 30, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/clinging_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_FOCUSED_SHOT", "focused_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.25,0.25,0.25,0.25,0.25,0.25,0.25", 500, 20, -1,
        nil,
        function()
            gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 3.0;
			c.damage_projectile_add = c.damage_projectile_add + 0.08;
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/focused_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
            gkbrkn.mana_multiplier = gkbrkn.mana_multiplier / 3.0;
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_TIME_SPLIT", "time_split", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.25,0.25,0.25,0.25,0.25,0.25,0.25", 140, 4, -1,
        nil,
        function()
            local sum = (c.fire_rate_wait + current_reload_time) * 0.5;
            c.fire_rate_wait = c.fire_rate_wait / 3;
            current_reload_time = current_reload_time / 3;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_BOUND_SHOT", "bound_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.25,0.25,0.25,0.25,0.25,0.25,0.25", 150, 90, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/bound_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );