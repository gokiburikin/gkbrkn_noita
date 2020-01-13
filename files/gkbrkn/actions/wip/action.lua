if reflecting then 
    Reflection_RegisterProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/wip/projectile.xml" );
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

        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/wip/projectile.xml" );
            BeginTriggerDeath();
                c = {};
                reset_modifiers( c );
                gkbrkn.capture_drawn_actions = true;
                draw_actions( 1, true );
                deck_snapshot();
                gkbrkn.capture_drawn_actions = false;
                local _deck = deck;
                local _hand = hand;
                local _discarded = discarded;
                --deck = deck_from_drawn_actions( 1 );
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
            BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/wip/projectile.xml" );
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