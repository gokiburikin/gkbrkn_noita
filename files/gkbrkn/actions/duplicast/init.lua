dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_DUPLICAST", "duplicast", ACTION_TYPE_OTHER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 25, -1,
    nil,
    function()
        current_reload_time = current_reload_time + 30;
        --[[
        ]]
        c.pattern_degrees = c.pattern_degrees + 180;
        extra_projectiles( 7 );
        draw_actions( 1, true );
        --[[
        local _current_reload_time = current_reload_time;
        if reflecting then 
            return;
        end
        local _deck = deck;
        local _hand = hand;
        local _discarded = discarded;
        gkbrkn.add_projectile_capture_callback = function( filepath )
            gkbrkn.add_projectile_capture_callback = nil;
            local captured_deck = nil;
            local old_c = c;
            BeginProjectile( filepath );
                BeginTriggerTimer( 15 );
                    c = {};
                    reset_modifiers( c );
                    if captured_deck == nil then
                        captured_deck = capture_draw_actions( 1, true );
                        hand, discarded = {}, {};
                    end
                    for i=1,7 do
                        reset_modifiers( c );
                        deck = {};
                        for _,v in pairs( captured_deck ) do
                            table.insert( deck, v );
                        end
                        draw_actions( 1, true );
                        state_per_cast( c );
                    end
                    c.pattern_degrees = 180;
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
            EndProjectile();
            hand, discarded = _hand, _discarded;
            c = old_c;
            register_action( c );
            SetProjectileConfigs();
        end
        draw_actions( 1, true );
        deck = _deck;
        current_reload_time = _current_reload_time;
        ]]
    end
) );