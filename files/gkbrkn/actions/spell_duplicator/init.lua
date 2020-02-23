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
