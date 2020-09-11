dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_BURST_FIRE", "burst_fire", ACTION_TYPE_STATIC_PROJECTILE,
    "0,1,2,3,4,5,6", "1.0,1.0,1.0,1.0,1.0,1.0,1.0", 300, 9, -1,
    nil,
    function()
        c.fire_rate_wait = c.fire_rate_wait - 5;
        local projectile_path = "mods/gkbrkn_noita/files/gkbrkn/actions/burst_fire/projectile.xml";
        if reflecting then 
            Reflection_RegisterProjectile( projectile_path );
            return;
        end
        local burst_wait = c.fire_rate_wait + math.ceil( gun.reload_time / 5 );
        local base_fire_rate_wait = c.fire_rate_wait;
        local old_c = c;
        c = {};
        reset_modifiers( c );

        function inner( how_many, old_c, skip_amount, depth, deck_snapshot )
            BeginProjectile( projectile_path );
                BeginTriggerDeath();
                    c = {};
                    reset_modifiers( c );
                    temporary_deck( function( deck, hand, discarded ) draw_actions( 1, true ); end, deck_from_actions( deck_snapshot ), {}, {} );
                    register_action( c );
                    SetProjectileConfigs();
                    reset_modifiers( c );
                EndTrigger();
                if how_many > 1 then
                    recursive_death_trigger( how_many - 1, old_c, skip_amount, depth, deck_snapshot );
                end
            EndProjectile();
        end

        function recursive_death_trigger( how_many, old_c, skip_amount, depth, deck_snapshot )
            if depth == nil then
                depth = (depth or 0) + 1;
                skip_amount = #hand + 1;
                c = {};
                reset_modifiers( c );
                deck_snapshot = peek_draw_actions( 1, true );

                inner( how_many, old_c, skip_amount, depth, deck_snapshot );
            else
                BeginTriggerDeath();
                    inner( how_many, old_c, skip_amount, depth, deck_snapshot );
                    -- burst fire's delay
                    c.lifetime_add = burst_wait;
                    c.spread_degrees = 3;
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
            end
        end

        -- NOTE: This is the secret sauce that makes burst fire lifetime_add not apply on the first shot
        BeginProjectile( projectile_path );
            BeginTriggerDeath();
                recursive_death_trigger( 3, old_c );
            EndTrigger();
        EndProjectile();
        c = old_c;
    end
) );
