dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_SPELL_DUPLICATOR", "spell_duplicator", ACTION_TYPE_STATIC_PROJECTILE,
    "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 300, 19, -1,
    nil,
    function()
        if reflecting then 
            Reflection_RegisterProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/spell_duplicator/projectile.xml" );
            return;
        end

        --[[ i think this is bugged in the engine so it won't work right now, but this is a much simpler implementation 
        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/spell_duplicator/projectile.xml" );
            BeginTriggerTimer( 10 );
                draw_actions( 1, true );
            EndTrigger();

            BeginTriggerTimer( 20 );
                draw_actions( 1, true );
            EndTrigger();

            BeginTriggerTimer( 30 );
                draw_actions( 1, true );
            EndTrigger();
        EndProjectile();
        ]]

        --[[
        ]]
        function deck_from_drawn_actions( actions, start_index )
            local deck = {};
            for i=start_index,#actions,1 do
                table.insert( deck, actions[i] );
            end
            return deck;
        end

        function recursive_death_trigger( how_many, old_c, skip_amount, depth, deck_snapshot )
            
            if depth == nil then
                depth = (depth or 0) + 1;
                old_c = c;
                skip_amount = #hand + 1;

                local _deck = deck;
                local _hand = hand;
                local _discarded = discarded;

                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/spell_duplicator/projectile.xml" );
                    BeginTriggerDeath();
                        c = {};
                        reset_modifiers( c );
                        gkbrkn.capture_draw_actions = true;
                        deck_snapshot = capture_draw_actions( 1, true );
                        gkbrkn.capture_draw_actions = false;
                        hand = {};
                        discarded = {};
                        register_action( c );
                        SetProjectileConfigs();
                    EndTrigger();

                    if how_many > 1 then
                        recursive_death_trigger( how_many - 1, old_c, skip_amount, depth, deck_snapshot );
                    end

                    deck = _deck;
                    hand = _hand;
                    discarded = _discarded;

                EndProjectile();
                register_action( old_c );
                SetProjectileConfigs();
            else
                BeginTriggerDeath();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/spell_duplicator/projectile.xml" );
                        BeginTriggerDeath();
                            c = {};
                            reset_modifiers( c );
                            deck = deck_from_drawn_actions( deck_snapshot, 1 );
                            gkbrkn.capture_draw_actions = false;
                            draw_actions( 1, true );
                            gkbrkn.capture_draw_actions = true;
                            register_action( c );
                            SetProjectileConfigs();
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
