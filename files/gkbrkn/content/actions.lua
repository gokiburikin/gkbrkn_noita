dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

--[[ NORMAL ]]
    table.insert( actions, generate_action_entry(
        "GKBRKN_DUMMY_SHOT", "dummy_shot", ACTION_TYPE_MODIFIER, 
        "1,3,5", "0.4,0.4,0.4", 10, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/dummy_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end, true
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
        "4,5,6", "0.3,0.3,0.3", 210, 0, -1,
        nil, 
        function()
            if reflecting then return; end
            local old_c = c;
            BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" );
                BeginTriggerDeath();
                    c = {};
                    reset_modifiers( c );
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
        "2,3,4,5", "0.7,0.7,0.7,0.7", 200, 20, -1,
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
        "0,1,2,3,4,5,6", "0.9,0.9,0.9,0.9,0.9,0.9,0.9", 300, 9, -1,
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
        "2,3,4,5", "1,1,1,1", 160, 4, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/carry_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end, true
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_CHAIN_CAST", "chain_cast", ACTION_TYPE_MODIFIER,
        "4,5,6", "0.6,0.6,0.6", 200, 50, -1,
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
        "3,4,5,6", "1,1,1,1", 260, 42, -1,
        nil,
        function()
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
        end, nil, nil, nil,
		{"mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml",5}
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_RED_SPARKBOLT", "red_sparkbolt", ACTION_TYPE_PROJECTILE,
        "0,1,2", "2,1,0.5", 120, 7, -1,
        nil,
        function()
            c.fire_rate_wait = c.fire_rate_wait + 2;
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/red_sparkbolt/projectile.xml" );
        end, nil, nil, nil,
		{"mods/gkbrkn_noita/files/gkbrkn/actions/red_sparkbolt/projectile.xml",1}
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
        "0,1,2,3,4,5,6", "0.3,0.3,0.3,0.3,0.3,0.3,0.3", 130, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/curious_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_DAMAGE_BOUNCE", "damage_bounce", ACTION_TYPE_MODIFIER,
        "1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33", 100, 7, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/damage_bounce/projectile_extra_entity.xml,";
            c.damage_projectile_add = c.damage_projectile_add + 0.04;
            c.bounces = c.bounces + 3;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_DAMAGE_LIFETIME", "damage_lifetime", ACTION_TYPE_MODIFIER,
        "1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33", 130, 9, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/damage_lifetime/projectile_extra_entity.xml,";
            c.damage_projectile_add = c.damage_projectile_add + 0.04;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_DESTRUCTIVE_SHOT", "destructive_shot", ACTION_TYPE_MODIFIER,
        "3,4,5,6", "0.5,0.5,0.5,0.5", 250, 30, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/destructive_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_DOUBLE_CAST", "double_cast", ACTION_TYPE_MODIFIER,
        "2,3,4", "0.7,0.7,0.7", 400, 0, -1,
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
        "4,5,6", "0.8,0.8,0.8", 100, 5, -1,
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
        "0,1", "0.1,0.1", 90, 1, -1,
        nil,
        function()
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/false_spell/projectile.xml" );
        end, nil, nil, nil,
		{"mods/gkbrkn_noita/files/gkbrkn/actions/false_spell/projectile.xml",1}
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
        "1,3,5", "0.3,0.3,0.3", 100, 3, -1,
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
        "2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7", 300, 9, -1,
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
        "2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7", 120, 10, -1,
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
        "1,2,3", "0.4,0.4,0.4", 160, 8, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/guided_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_HYPER_BOUNCE", "hyper_bounce", ACTION_TYPE_MODIFIER, 
        "2,3,4", "0.8,0.8,0.8", 500, 10, -1,
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
        "0,1,2", "1,1,1", 240, 0, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/custom_card.xml",
        function()
            draw_actions( 1, true );
        end
    ) );
    
    table.insert( actions, generate_action_entry(
        "GKBRKN_ANTI_SHIELD", "anti_shield", ACTION_TYPE_PASSIVE,
        "1,2,3,4,5,6", "0.05,0.6,0.6,0.6,0.6,0.6", 220, 0, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/anti_shield/custom_card.xml",
        function()
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_MANA_EFFICIENCY", "mana_efficiency", ACTION_TYPE_MODIFIER,
        "3,4,5,6", "0.2,0.2,0.2,0.2", 150, 0, -1,
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
        "0,1,2,3", "1,1,1,1", 200, 50, 3,
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
        "2,3,4,5", "0.6,0.6,0.6,0.6", 1000, 30, -1,
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
        "0,1,2,3,4", "1,1,1,1,1", 100, 7, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/order_deck/custom_card.xml",
        function()
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PAPER_SHOT", "paper_shot", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4", "0.5,0.4,0.3,0.2,0.1", 20, -5, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/paper_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end, true
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
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 250, 30, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/path_correction/projectile_extra_entity.xml,";
            c.speed_multiplier = c.speed_multiplier * 0.75;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PERFECT_CRITICAL", "perfect_critical", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7,0.7,0.7", 300, 20, -1,
        nil,
        function()
            c.damage_critical_multiplier = math.max( 1, c.damage_critical_multiplier ) + 1;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_DAMAGE_SMALL", "damage_small", ACTION_TYPE_MODIFIER,
        "0,1,2,3", "1.0,1.0,1.0,1.0", 70, 1, -1,
        nil,
        function()
            c.damage_projectile_add = c.damage_projectile_add + 0.04;
            if not reflecting then
                _add_extra_modifier_to_shot( "gkbrkn_dimige" );
            end
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PERFORATING_SHOT", "perforating_shot", ACTION_TYPE_MODIFIER,
        "2,3,4,5", "0.7,0.7,0.7,0.7", 210, 9, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/perforating_shot/projectile_extra_entity.xml,";
			c.gore_particles = c.gore_particles + 20;
            c.damage_projectile_add = c.damage_projectile_add + 0.12;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PERSISTENT_SHOT", "persistent_shot", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4", "0.4,0.4,0.4,0.4,0.4", 160, 17, -1,
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
        "0,1,2,3,4,5,6", "0.2,0.4,0.6,0.8,1,1,1", 250, 9, -1,
        nil,
        function()
            c.damage_projectile_add = c.damage_projectile_add + 0.24;
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/power_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_EXTRA_PROJECTILE", "extra_projectile", ACTION_TYPE_OTHER,
        "0,1,2,3,4,5,6", "0.2,0.4,0.6,0.8,1,1,1", 320, 12, -1,
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
        "3,4,5,6", "0.2,0.4,0.6,0.8", 480, 30, -1,
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
        "2,3,4,5", "0.2,0.2,0.2,0.2", 300, 70, -1,
        nil,
        function()
            SetRandomSeed( GameGetFrameNum(), 1284 );
            c.explosion_radius = c.explosion_radius + 15.0;
			c.damage_explosion_add = c.damage_explosion_add + 0.2;
            local old_c = c;
            c = {};
            for k,v in pairs(old_c) do
                c[k] = v;
            end
            local inside_c = nil;
            local old_capture = gkbrkn.add_projectile_capture_callback;
            gkbrkn._proximity_bursts = (gkbrkn._proximity_bursts or 0) + 1;
            gkbrkn.add_projectile_capture_callback = function( filepath, trigger_action_draw_count, trigger_delay_frames )
                BeginProjectile( filepath );
                if gkbrkn.add_projectile_depth <= gkbrkn._proximity_bursts then
                    BeginTriggerDeath();
                        inside_c = c;
                        for i=1,Random(1,4) do
                            add_projectile( filepath );
                        end
                        c = {};
                        for k,v in pairs(inside_c) do
                            c[k] = v;
                        end
                        c.spread_degrees = 360;
                        c.gravity = c.gravity + 1200;
                        c.bounces = c.bounces + 1;
                        c.explosion_radius = c.explosion_radius + 10.0;
			            c.damage_explosion_add = c.damage_explosion_add + 0.1;
                        for i=1,gkbrkn.add_projectile_depth do
                            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/proximity_burst/projectile_extra_entity.xml,";
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
            gkbrkn._proximity_bursts = gkbrkn._proximity_bursts - 1;
            c = old_c;
            if inside_c then
                for k,v in pairs(inside_c) do
                    c[k] = v;
                end
            end

            --c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/proximity_burst/projectile_extra_entity.xml,";
            --c.lifetime_add = c.lifetime_add + 6;
            --c.explosion_radius = c.explosion_radius + 8.0;
            --c.damage_explosion_add = c.damage_explosion_add + 0.1;
            --set_trigger_death( 1 );
            --draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_RAPID_SHOT", "rapid_shot", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.8,0.8,0.8,0.8,0.8,0.8,0.8", 200, 2, -1,
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
        "0,1,2,3,4,5,6", "0.1,0.2,0.3,0.4,0.5,0.4,0.3", 280, 20, -1,
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
        "1,2,3,4", "0.8,0.8,0.8,0.8", 50, -3, -1,
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
        "0,1,2,3,4,5,6", "0.3,0.3,0.3,0.3,0.3,0.3,0.3", 160, 4, -1,
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
        "GKBRKN_TRIPLE_CAST", "triple_cast", ACTION_TYPE_MODIFIER,
        "3,4,5", "0.5,0.5,0.5", 500, 0, -1,
        nil,
        function()
            if reflecting then return; end
            duplicate_draw_action( 1, 3, true );
        end
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_ZAP", "zap", ACTION_TYPE_PROJECTILE,
        "1,3,4", "1,1,1", 170, 8, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/zap/custom_card.xml",
        function()
            c.fire_rate_wait = c.fire_rate_wait - 5;
            current_reload_time = current_reload_time - 5;
            
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
        end, nil, nil, nil,
		{"mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml",6}
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_ZERO_GRAVITY", "zero_gravity", ACTION_TYPE_MODIFIER, 
        "2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5", 100, 3, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/zero_gravity/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

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
                    print(" register callback")
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
        "2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5", 150, 4, -1,
        nil,
        function()
            if not c.extra_entities:find("mods/gkbrkn_noita/files/gkbrkn/actions/area_shot/projectile_extra_entity_unique.xml,") then
                c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/area_shot/projectile_extra_entity_unique.xml,";
            end
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/area_shot/projectile_extra_entity.xml,";
            gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 2;
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_ANCHORED_SHOT", "anchored_shot", ACTION_TYPE_MODIFIER,
        "0,1,2", "0.2,0.2,0.2", 150, 6, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/anchored_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_BLUE_MAGIC", "blue_magic", ACTION_TYPE_PROJECTILE,
        "0,1,2,3,4,5", "0.5,0.4,0.3,0.2,0.2,0.2", 90, 11, -1,
        nil,
        function()
            c.fire_rate_wait = c.fire_rate_wait + 10;
            current_reload_time = current_reload_time + 6;
            if not reflecting then
                local player = EntityGetWithTag( "player_unit" )[1];
                local projectile_file = EntityGetVariableString( player, "gkbrkn_blue_magic_projectile_file" );
                if projectile_file ~= nil and #projectile_file > 0 then
                    c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/blue_magic/projectile_extra_entity.xml,";
                    add_projectile( projectile_file );
                end
            end
        end
    ) );

--[[ CAPTURES ]]
    table.insert( actions, generate_action_entry(
        "GKBRKN_FORMATION_STACK", "formation_stack", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 160, 5, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/formation_stack/projectile_extra_entity.xml,";
            if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/formation_stack/separator.xml"); end
            draw_actions( 3, true );
        end
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_FORMATION_SHIELD", "formation_shield", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 160, 50, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/formation_shield/projectile_extra_entity.xml,";
            if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/formation_shield/separator.xml"); end
            c.speed_multiplier = 0.0;
            c.lifetime_add = c.lifetime_add + 60;
            draw_actions( 4, true );
        end
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_FORMATION_SWORD", "formation_sword", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 160, 7, -1,
        "mods/gkbrkn_noita/files/gkbrkn/actions/formation_sword/custom_card.xml",
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/formation_sword/projectile_extra_entity.xml,";
            if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/formation_sword/separator.xml"); end
            draw_actions( 5, true );
        end
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_LINK_SHOT", "link_shot", ACTION_TYPE_MODIFIER, 
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 190, 7, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/link_shot/projectile_extra_entity.xml,";
            if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/link_shot/separator.xml"); end
            draw_actions( 2, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_SPELL_MERGE", "spell_merge", ACTION_TYPE_DRAW_MANY, 
        "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 190, 14, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/spell_merge/projectile_extra_entity.xml,";
            if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/spell_merge/separator.xml"); end
            draw_actions( 2, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PROJECTILE_GRAVITY_WELL", "projectile_gravity_well", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 210, 5, -1,
        nil,
        function()
            c.speed_multiplier = c.speed_multiplier * 0.75;
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/projectile_gravity_well/projectile_extra_entity.xml,";
            if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/projectile_gravity_well/separator.xml"); end
            draw_actions( 3, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_PROJECTILE_ORBIT", "projectile_orbit", ACTION_TYPE_DRAW_MANY,
        "0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 100, 12, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/projectile_orbit/projectile_extra_entity.xml,";
            if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/projectile_orbit/separator.xml"); end
            draw_actions( 5, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_TRAILING_SHOT", "trailing_shot", ACTION_TYPE_DRAW_MANY, 
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 5, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/trailing_shot/projectile_extra_entity.xml,";
            if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/trailing_shot/separator.xml"); end
            draw_actions( 4, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_MATRA_MAGIC", "matra_magic", ACTION_TYPE_PROJECTILE,
        "3,4,5,6", "1,1,1,1", 180, 52, -1,
        nil,
        function()
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/matra_magic/projectile.xml" );
			c.fire_rate_wait = c.fire_rate_wait + 33;
			current_reload_time = current_reload_time + 33;
        end, nil, nil, nil,
		{"mods/gkbrkn_noita/files/gkbrkn/actions/matra_magic/projectile.xml"}
    ) );

--[[ SUPERS ]]
    table.insert( actions, generate_action_entry(
        "GKBRKN_CONTROL", "control", ACTION_TYPE_MODIFIER, 
        "2,3,4,5,6,10", "0.12,0.12,0.12,0.24,0.24,0.36", 10, 3, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/control/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_CLINGING_SHOT", "clinging_shot", ACTION_TYPE_MODIFIER,
        "2,3,4,5,6,10", "0.12,0.12,0.12,0.24,0.24,0.36", 150, 30, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/clinging_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_FOCUSED_SHOT", "focused_shot", ACTION_TYPE_MODIFIER,
        "2,3,4,5,6,10", "0.12,0.12,0.12,0.24,0.24,0.36", 500, 20, -1,
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
        "2,3,4,5,6,10", "0.12,0.12,0.12,0.24,0.24,0.36", 140, 4, -1,
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
        "2,3,4,5,6,10", "0.12,0.12,0.12,0.24,0.24,0.36", 150, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/bound_shot/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end
    ) );

--[[
    table.insert( actions, generate_action_entry(
        "GKBRKN_TEST_SHOT", "test_shot", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.25,0.25,0.25,0.25,0.25,0.25,0.25", 150, 90, -1,
        nil,
        function()
            if not reflecting then
                for k,v in pairs(c) do
                    print(k.."/"..tostring(v));
                end
            end
        end
    ) );
]]



--[[ EXTRA THINGS ]]
    table.insert( actions, generate_action_entry(
        "GKBRKN_FREEZING_MIST", "freezing_mist", ACTION_TYPE_PROJECTILE,
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 600, 200, -1,
        nil,
        function()
            add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/freezing_mist/projectile.xml" );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/freezing_mist/icon.png",
        "goki_dev_extra",
        {"mods/gkbrkn_noita/files/gkbrkn/actions/freezing_mist/projectile.xml",1},
        false
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_FREEZING_VAPOUR_TRAIL", "freezing_vapour_trail", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 300, 13, -1,
        nil,
        function()
            c.trail_material = c.trail_material .. "blood_cold";
            c.trail_material_amount = c.trail_material_amount + 5;
            draw_actions( 1, true );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/freezing_vapour_trail/icon.png",
        "goki_dev_extra",
        nil,
        false
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_HONK", "honk", ACTION_TYPE_OTHER,
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 10, 0, -1,
        nil,
        function()
            if not reflecting then
                local entity = GetUpdatedEntityID();
                local x,y = EntityGetTransform( entity );
                GamePlaySound( "mods/gkbrkn_noita/files/gkbrkn_extras.snd", "lily_honk"..math.ceil( math.random() * 3 + 1 ), x, y );
            end
            draw_actions( 1, true );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/honk/icon.png",
        "goki_dev_extra",
        nil,
        false
    ));

    table.insert( actions, generate_action_entry(
        "GKBRKN_LOVELY_TRAIL", "lovely_trail", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/lovely_trail/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/lovely_trail/icon.png",
        "goki_dev_extra",
        nil,
        false
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_NULL_TRAIL", "null_trail", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/null_trail/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/null_trail/icon.png",
        "goki_dev_extra",
        nil,
        false
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_POP_TRAIL", "pop_trail", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/pop_trail/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/pop_trail/icon.png",
        "goki_dev_extra",
        nil,
        false
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_RAINBOW_GLITTER_TRAIL", "rainbow_glitter_trail", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/rainbow_glitter_trail/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/rainbow_glitter_trail/icon.png",
        "goki_dev_extra",
        nil,
        false
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_RAINBOW_PROJECTILE", "rainbow_projectile", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/rainbow_projectile/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/rainbow_projectile/icon.png",
        "goki_dev_extra",
        nil,
        false
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_RAINBOW_TRAIL", "rainbow_trail", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/rainbow_trail/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/rainbow_trail/icon.png",
        "goki_dev_extra",
        nil,
        false
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_SPARKLING_TRAIL", "sparkling_trail", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/sparkling_trail/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/sparkling_trail/icon.png",
        "goki_dev_extra",
        nil,
        false
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_STARRY_TRAIL", "starry_trail", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
        nil,
        function()
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/starry_trail/projectile_extra_entity.xml,";
            draw_actions( 1, true );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/starry_trail/icon.png",
        "goki_dev_extra",
        nil,
        false
    ) );

    table.insert( actions, generate_action_entry(
        "GKBRKN_VOID_TRAIL", "void_trail", ACTION_TYPE_MODIFIER,
        "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 200, 6, -1,
        nil,
        function()
            c.trail_material = c.trail_material .. "void_liquid,";
            c.trail_material_amount = c.trail_material_amount + 1;
            draw_actions( 1, true );
        end,
        false,
        "mods/gkbrkn_noita/files/gkbrkn/actions/void_trail/icon.png",
        "goki_dev_extra",
        nil,
        false
    ));