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
        print("rdt start");
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
        EndTrigger();

        EndProjectile();
        register_action( old_c );
        SetProjectileConfigs();
        print("rdt end");
    else
        print("    rdt depth "..depth);
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

--[[
local old_c = c;
GamePrint( "h "..#hand );
GamePrint( "c "..#discarded );
local skip_amount = #hand + 1;
BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/wip/projectile.xml" );

    BeginTriggerDeath();
        c = {};
        reset_modifiers( c );
        draw_actions( 1, true );
        gkbrkn.capture_drawn_actions = false;
        local _deck = deck;
        local _hand = hand;
        local _discarded = discarded;
        deck = deck_from_drawn_actions( skip_amount );
        hand = {};
        discarded = {};
        register_action( c );
        SetProjectileConfigs();
    EndTrigger();

    BeginTriggerDeath();
        BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/wip/projectile.xml" );
        
        BeginTriggerDeath();
            c = {};
            reset_modifiers( c );
            draw_actions( 1, true );
            deck = deck_from_drawn_actions( skip_amount );
            register_action( c );
            SetProjectileConfigs();
        EndTrigger();

        BeginTriggerDeath();
            BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/wip/projectile.xml" );
            
            BeginTriggerDeath();
                c = {};
                reset_modifiers( c );
                draw_actions( 1, true );
                deck = deck_from_drawn_actions( skip_amount );
                register_action( c );
                SetProjectileConfigs();
            EndTrigger();

            BeginTriggerDeath();
                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/wip/projectile.xml" );
                
                BeginTriggerDeath();
                    c = {};
                    reset_modifiers( c );
                    draw_actions( 1, true );
                    deck = deck_from_drawn_actions( skip_amount );
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();

                EndProjectile();
                register_action( old_c );
                SetProjectileConfigs();
            EndTrigger();

            EndProjectile();
            register_action( old_c );
            SetProjectileConfigs();
        EndTrigger();

        EndProjectile();
        register_action( old_c );
        SetProjectileConfigs();
        
        deck = _deck;
        hand = _hand;
        discarded = _discarded;
        gkbrkn.capture_drawn_actions = true;
    EndTrigger();

EndProjectile();
register_action( old_c );
SetProjectileConfigs();
]]
recursive_death_trigger( 2 );