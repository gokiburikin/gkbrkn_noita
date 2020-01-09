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

        local deck_snapshot = nil;

        function deck_snapshot()
            deck_snapshot = {};
            local s = ""
            for _,action in pairs(gkbrkn.drawn_actions) do
                if action.id ~= "GKBRKN_ACTION_WIP" then
                    s = s ..action.id..", ";
                    table.insert( deck_snapshot, action );
                end
            end
            print("--- drawn_actions snapshot: "..s);
        end

        function deck_from_drawn_actions( start_index )
            local deck = {};
            for i=start_index,#deck_snapshot,1 do
                table.insert( deck, deck_snapshot[i] );
            end
            return deck;
        end

        function recursive_death_trigger( how_many, old_c, skip_amount, depth )
            if depth == nil then
                depth = (depth or 0) + 1;
                old_c = c;
                skip_amount = #hand + 1;

                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/spell_duplicator/projectile.xml" );
                    BeginTriggerDeath();
                        c = {};
                        reset_modifiers( c );
                        local old_drawn_actions = gkbrkn.drawn_actions;
                        gkbrkn.drawn_actions = {};
                        gkbrkn.capture_drawn_actions = true;
                        draw_actions( 1, true );
                        deck_snapshot();
                        gkbrkn.capture_drawn_actions = false;
                        gkbrkn.drawn_actions = old_drawn_actions;
                        local _deck = deck;
                        local _hand = hand;
                        local _discarded = discarded;
                        hand = {};
                        discarded = {};
                        register_action( c );
                        SetProjectileConfigs();
                    EndTrigger();

                    if how_many > 1 then
                        recursive_death_trigger( how_many - 1, old_c, skip_amount, depth );
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
                            deck = deck_from_drawn_actions( 1 );
                            draw_actions( 1, true );
                            register_action( c );
                            SetProjectileConfigs();
                        EndTrigger();

                        if how_many > 1 then
                            recursive_death_trigger( how_many - 1, old_c, skip_amount, depth );
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
