dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_FRACTURE", "fracture", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1.0,1.0,1.0,1.0,1.0,1.0,1.0", 300, 9, -1,
    nil,    
    function()
        local projectile_path = "mods/gkbrkn_noita/files/gkbrkn/actions/fracture/projectile.xml";
        if reflecting then 
            Reflection_RegisterProjectile( projectile_path );
            return;
        end
        
        local old_c = c;
        local fractured_c;
        c = {};
        reset_modifiers( c );

        local deck_snapshot = peek_draw_actions( 1, true );
        gkbrkn.add_projectile_capture_callback = function( filepath, trigger_action_draw_count, trigger_delay_frames )
            gkbrkn.add_projectile_capture_callback = nil;
            BeginProjectile( filepath );
            BeginTriggerDeath();
                c = {};
                reset_modifiers( c );
                for k,v in pairs(old_c) do
                    c[k] = v;
                end
                c.spread_degrees = 45;
                c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/fracture/projectile_extra_entity.xml,";
                temporary_deck( function( deck, hand, discarded ) draw_actions( 1, true ); end, deck_from_actions( deck_snapshot ), {}, {} );
                temporary_deck( function( deck, hand, discarded ) draw_actions( 1, true ); end, deck_from_actions( deck_snapshot ), {}, {} );
                temporary_deck( function( deck, hand, discarded ) draw_actions( 1, true ); end, deck_from_actions( deck_snapshot ), {}, {} );
                register_action( c );
                SetProjectileConfigs();
                if fractured_c == nil then
                    fractured_c = {};
                    for k,v in pairs(c) do
                        fractured_c[k] = v;
                    end
                end
            EndTrigger();
            register_action( c );
            SetProjectileConfigs();
            EndProjectile();
        end
        temporary_deck( function( deck, hand, discarded ) draw_actions( 1, true ); end, deck_from_actions( deck_snapshot ), {}, {} );

        c = fractured_c or old_c;
        register_action( c );
        SetProjectileConfigs();
    end
) );
