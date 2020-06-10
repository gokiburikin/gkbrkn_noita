dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

gkbrkn = {
    TRIGGER_TYPE = {
        Timer=1,
        Hit=2,
        Death=3,
        Instant=4,
    },
    reset_on_draw = false,
    extra_projectiles = 0,
    projectile_tracker = 0,
    stack_next_actions = 0,
    draw_cards_remaining = 0,
    instant_reload_if_empty = true,
    stack_projectiles = "",
    trigger_data = {
        type = 0,
        action_draw_count = 1,
        delay_frames = 0,
    },
    peeking = 0,
    projectiles_fired = 0,
    skip_cards = 0,
    trigger_queue = {},
    add_projectile_capture_callback = nil,
    draw_actions_capture = nil,
    capture_draw_actions = true,
    draw_action_stack_size = 0,
    _create_shot = create_shot,
    _create_shot = create_shot,
    _draw_actions = draw_actions,
    _set_current_action = set_current_action,
    _play_action = play_action,
    __play_permanent_card = _play_permanent_card,
    _add_projectile = add_projectile,
    _move_hand_to_discarded = move_hand_to_discarded,
    _order_deck = order_deck,
    _draw_action = draw_action,
    _add_projectile_trigger_timer = add_projectile_trigger_timer,
    _add_projectile_trigger_death = add_projectile_trigger_death,
    _add_projectile_trigger_hit_world = add_projectile_trigger_hit_world,
}

function state_per_cast( state )
    local player = GetUpdatedEntityID();
    local current_protagonist_bonus = EntityGetVariableNumber( player, "gkbrkn_low_health_damage_bonus", 0.0 );
    if current_protagonist_bonus ~= 0 then
        state.extra_entities = state.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/perks/protagonist/projectile_extra_entity.xml,";
    end
    if GameHasFlagRun( FLAGS.DisintegrateCorpses ) then
        state.game_effect_entities = state.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
    end
end

function create_shot( num_of_cards_to_draw )
    local shot = gkbrkn._create_shot( num_of_cards_to_draw );
    state_per_cast( shot.state );
    return shot;
end

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

function peek_draw_action( shot, instant_reload_if_empty )
    local action = nil;

    state_cards_drawn = state_cards_drawn + 1;

    if reflecting then return end;

    if #deck <= 0 then
        if instant_reload_if_empty then
            move_discarded_to_deck();
            order_deck();
            start_reload = true;
        else
            -- NOTE we are setting reloading to true here so that peek draw actions resolves correctly, but we were not (and are now) resetting this to false. IT IS GLOBAL STATE
            reloading = true;
            return true;
        end
    end

    if #deck > 0 then
        -- draw from the start of the deck
        action = deck[ 1 ];

        table.remove( deck, 1 );

        -- update mana
        local action_mana_required = action.mana;
        if action.mana == nil then
            action_mana_required = ACTION_MANA_DRAIN_DEFAULT;
        end

        mana = mana - action_mana_required;
    end

    --- add the action to hand and execute it ---
    if action ~= nil then
        play_action( action );
    end

    return true;
end

function peek_draw_actions( how_many, instant_reload_if_empty, remove_tail )
    local _reloading = reloading;
    gkbrkn.peeking = gkbrkn.peeking + 1;
    
    -- if we're going to draw an action, peek it only, don't actually cast it
    local _draw_action = gkbrkn._draw_action;
    gkbrkn._draw_action = peek_draw_action;

    -- don't shoot any projectiles during this peek
    local _add_projectile = gkbrkn._add_projectile;
    gkbrkn._add_projectile = function( filepath )  end

    -- track the old capture function
    local old_capture = gkbrkn.draw_actions_capture;
    if remove_tail and old_capture ~= nil then
        table.remove( old_capture, #old_capture );
    end

    -- make a new capture
    local capture = {};

    local drawn_actions = {};
    gkbrkn.draw_actions_capture = capture;
    draw_actions( how_many, instant_reload_if_empty );

    for _,action in pairs( capture ) do
        table.insert( drawn_actions, action );
    end

    gkbrkn.draw_actions_capture = old_capture;

    gkbrkn._draw_action = _draw_action;
    gkbrkn._add_projectile = _add_projectile;
    
    gkbrkn.peeking = gkbrkn.peeking - 1;
    reloading = _reloading;
    return drawn_actions;
end

function capture_draw_actions( how_many, instant_reload_if_empty )
    local old_capture = gkbrkn.draw_actions_capture;
    local capture = {};
    local drawn_actions = {};
    gkbrkn.draw_actions_capture = capture;
    draw_actions( how_many, instant_reload_if_empty );
    for _,action in pairs( capture ) do
        table.insert( drawn_actions, action );
    end
    if old_capture ~= nil then
        for _,action in pairs( capture ) do
            table.insert( old_capture, action );
        end
    end
    gkbrkn.draw_actions_capture = old_capture;

    local s = "";
    for _,action in pairs( drawn_actions ) do
        s = s ..action.id..", ";
    end
    return drawn_actions;
end

function deck_from_actions( actions, start_index )
    local deck = {};
    if start_index == nil then start_index = 1; end
    for i=start_index,#actions,1 do
        table.insert( deck, actions[i] );
    end
    return deck;
end

function duplicate_draw_action( amount, repeat_n_times, instant_reload_if_empty )
    local old_c = c;
    local captured = peek_draw_actions( amount, instant_reload_if_empty, true );

    -- repeat the captured set n times
    local capture_set = {};
    for i=1,repeat_n_times do
        for _,action in pairs( captured ) do
            table.insert( capture_set, action );
        end
    end

    -- draw all duplicated actions
    temporary_deck( function( deck, hand, discarded )
        c = {};
        reset_modifiers( c );
        draw_actions( #capture_set, instant_reload_if_empty );
    end, capture_set, {}, {} );
    c = old_c;
    register_action( c );
    SetProjectileConfigs();
end


function skip_cards( amount )
    if amount == nil then
        amount = #deck;
    end
    gkbrkn.skip_cards = amount;
end

function reset_per_casts()
    delete_cloned_actions();
    gkbrkn.projectiles_fired = 0;
    gkbrkn.stack_next_actions = 0;
    gkbrkn.stack_projectiles = "";
    gkbrkn.extra_projectiles = 0;
    gkbrkn.trigger_queue = {};
end

function order_deck()
    local force_sorted = false;
    local player = GetUpdatedEntityID();
    local base_wand = WandGetActive( player );
    if base_wand ~= nil then
        local wand_children = EntityGetAllChildren( base_wand ) or{};
        for _,wand_child in pairs( wand_children ) do
            if EntityHasTag( wand_child, "card_action" ) then
                local components = (EntityGetAllComponents( wand_child, "ItemActionComponent" ) or {});
                for _,component in pairs(components) do
                    if ComponentGetTypeName( component ) == "ItemActionComponent" then
                        if ComponentGetValue( component, "action_id" ) == "GKBRKN_ORDER_DECK" then
                            force_sorted = true;
                        end
                    end
                end
            end
        end
    end
    if force_sorted then
        local before = gun.shuffle_deck_when_empty;
        gun.shuffle_deck_when_empty = false;
        gkbrkn._order_deck();
        gun.shuffle_deck_when_empty = before;
    else
        gkbrkn._order_deck();
    end
end

function move_hand_to_discarded()
    GlobalsSetValue( "gkbrkn_projectiles_fired", gkbrkn.projectiles_fired );
    gkbrkn._move_hand_to_discarded();
    gkbrkn.reset_on_draw = true;
    gkbrkn.drawn_actions = {};
end

function pre_play_action( action )
    local player = GetUpdatedEntityID();
    local rapid_fire_level = EntityGetVariableNumber( player, "gkbrkn_rapid_fire", 0 );
    local extra_projectiles_level = EntityGetVariableNumber( player, "gkbrkn_extra_projectiles", 0 );

    if current_action ~= nil and current_action.type == ACTION_TYPE_PROJECTILE then
        c.fire_rate_wait = c.fire_rate_wait + 8 * extra_projectiles_level;
        current_reload_time = current_reload_time + 8 * extra_projectiles_level;
    end
end

function set_current_action( action )
    gkbrkn._set_current_action( action );
    pre_play_action( action );
end

function play_action( action )
    if gkbrkn.reset_on_draw == true then
        gkbrkn.reset_on_draw = false;
        reset_per_casts();
    end
    if playing_permanent_card and CONTENT[PERKS.BloodMagic].options.FreeAlwaysCasts == false then
        local player = GetUpdatedEntityID();
        local blood_magic_stacks = EntityGetVariableNumber( player, "gkbrkn_blood_magic_stacks", 0 );
        if blood_magic_stacks > 0 then
            local blood_to_mana_ratio = CONTENT[PERKS.BloodMagic].options.BloodToManaRatio * blood_magic_stacks / 25;
            local used_mana = action.mana;
            local damage_models = EntityGetComponent( player, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                local hp = tonumber( ComponentGetValue( damage_model, "hp" ) );
                ComponentSetValue( damage_model, "hp", tostring( hp - blood_to_mana_ratio * used_mana ) );
            end
        end
    end
    gkbrkn._play_action( action );
end

function draw_actions( how_many, instant_reload_if_empty )
    gkbrkn.instant_reload_if_empty = instant_reload_if_empty;
    local actions_to_draw = how_many;
    local player = GetUpdatedEntityID();
    local extra_actions = EntityGetVariableNumber( player, "gkbrkn_draw_actions_bonus", 0 );
    local draw_remaining = EntityGetVariableNumber( player, "gkbrkn_draw_remaining", 0 );
    actions_to_draw = extra_actions + actions_to_draw;
    if draw_remaining > 0 and gkbrkn.draw_action_stack_size == 0 then
        actions_to_draw = math.max( actions_to_draw, #deck );
    end
    gkbrkn._draw_actions( actions_to_draw, instant_reload_if_empty );
end

function discard_action()
    local action = deck[1];
    table.remove( deck, 1 );
    table.insert( discarded, action );
end

function draw_action( instant_reload_if_empty )
    gkbrkn.draw_cards_remaining = gkbrkn.draw_cards_remaining + 1;
    gkbrkn.draw_action_stack_size = gkbrkn.draw_action_stack_size + 1;

    local result = false;
    local player = GetUpdatedEntityID();
    local blood_magic_stacks = EntityGetVariableNumber( player, "gkbrkn_blood_magic_stacks", 0 );
    local extra_projectiles_level = EntityGetVariableNumber( player, "gkbrkn_extra_projectiles", 0 );

    --[[
        if current_action ~= and current_action.type == ACTION_TYPE_PROJECTILE then
            c.fire_rate_wait = c.fire_rate_wait + 8 * extra_projectiles_level;
            current_reload_time = current_reload_time + 8 * extra_projectiles_level;
        end
    ]]

    if gkbrkn.skip_cards <= 0 then
        --for index,extra_modifier in pairs( active_extra_modifiers ) do
        --    handle_extra_modifier( extra_modifier, index, gkbrkn.draw_action_stack_size );
        --end
        if gkbrkn.draw_actions_capture ~= nil and gkbrkn.capture_draw_actions then
            table.insert( gkbrkn.draw_actions_capture, deck[1] );
        end
        if blood_magic_stacks > 0 then
            local old_mana = mana;
            -- NOTE this could cause mod interoperability issues
            mana = 100000;
            result = gkbrkn._draw_action( instant_reload_if_empty );
            local used_mana = 100000 - mana;
            mana = old_mana;
            local damage_models = EntityGetComponent( player, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                local hp = tonumber( ComponentGetValue( damage_model, "hp" ) );
                ComponentSetValue( damage_model, "hp", tostring( hp - used_mana / 25 ) );
            end
        else
            result = gkbrkn._draw_action( instant_reload_if_empty );
        end
        --[[
        if current_action ~= nil and current_action.uses_remaining ~= nil and current_action.uses_remaining >= 0 then
            current_action.uses_remaining = current_action.uses_remaining + 1;
        end
        ]]
    else
        gkbrkn.skip_cards = gkbrkn.skip_cards - 1;
        gkbrkn.draw_cards_remaining = gkbrkn.draw_cards_remaining - 1;
        result = true;
        discard_action();
    end
    gkbrkn.draw_action_stack_size = gkbrkn.draw_action_stack_size - 1;
    gkbrkn.draw_cards_remaining = gkbrkn.draw_cards_remaining - 1;
    
    if gkbrkn.draw_action_stack_size == 0 then
        state_per_cast( c );
        local rapid_fire_level = EntityGetVariableNumber( player, "gkbrkn_rapid_fire", 0 );
        local hyper_casting = EntityGetVariableNumber( player, "gkbrkn_hyper_casting", 0 );
        local lead_boots = EntityGetVariableNumber( player, "gkbrkn_lead_boots", 0 );
        if #deck == 0 then
            current_reload_time = math.min( current_reload_time, current_reload_time * math.pow( 0.5, rapid_fire_level ) );
        end
        c.fire_rate_wait = math.min( c.fire_rate_wait, c.fire_rate_wait * math.pow( 0.5, rapid_fire_level ) );
        c.spread_degrees = c.spread_degrees + 8 * rapid_fire_level;
        if lead_boots > 0 then
            local character_data = EntityGetFirstComponent( player, "CharacterDataComponent" );
            if character_data ~= nil then
                if ComponentGetValue( character_data, "is_on_ground" ) == "1" then
                    shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10000;
                end
            end
        end
        if hyper_casting > 0 then
            c.speed_multiplier = 100;
        end
    end
    return result;
end

function add_projectile( filepath )
    local trigger_type = 0;
    local trigger_delay_frames = 0;
    local trigger_action_draw_count = nil;
    if #gkbrkn.trigger_queue > 0 then
        trigger_type = gkbrkn.trigger_queue[1].type;
        trigger_delay_frames = gkbrkn.trigger_queue[1].delay_frames;
        trigger_action_draw_count = gkbrkn.trigger_queue[1].action_draw_count;
        table.remove( gkbrkn.trigger_queue, 1 );
    end
    if gkbrkn.peeking > 0 then
        if trigger_action_draw_count ~= nil then
            draw_actions( trigger_action_draw_count, true );
        end
        return;
    end

    local player = GetUpdatedEntityID();
    local projectiles_to_add = EntityGetVariableNumber( player, "gkbrkn_extra_projectiles", 0 );
    if #deck == 0 then
        gkbrkn.stack_next_actions = 0;
    end
    local before = c.extra_entities;
    if #gkbrkn.stack_projectiles > 0 and gkbrkn.stack_next_actions == 0 then
        c.extra_entities = c.extra_entities..gkbrkn.stack_projectiles;
        gkbrkn.stack_projectiles = "";
        projectiles_to_add = projectiles_to_add + gkbrkn.extra_projectiles + 1;
    elseif gkbrkn.stack_next_actions > 0 then
        gkbrkn.stack_next_actions = gkbrkn.stack_next_actions - 1;
        gkbrkn.stack_projectiles = (gkbrkn.stack_projectiles or "") .. filepath..",";
        draw_action( 1 );
    else
        projectiles_to_add = projectiles_to_add + gkbrkn.extra_projectiles + 1;
    end
    
    for i=1,projectiles_to_add do
        gkbrkn.projectiles_fired = gkbrkn.projectiles_fired + 1;
        if gkbrkn.add_projectile_capture_callback ~= nil then
            gkbrkn.add_projectile_capture_callback( filepath, trigger_action_draw_count, trigger_delay_frames );
        elseif trigger_type == gkbrkn.TRIGGER_TYPE.Timer then
            gkbrkn._add_projectile_trigger_timer( filepath, trigger_delay_frames, trigger_action_draw_count );
        elseif trigger_type == gkbrkn.TRIGGER_TYPE.Death then
            gkbrkn._add_projectile_trigger_death( filepath, trigger_action_draw_count );
        elseif trigger_type == gkbrkn.TRIGGER_TYPE.Hit then
            gkbrkn._add_projectile_trigger_hit_world( filepath, trigger_action_draw_count );
        elseif trigger_type == gkbrkn.TRIGGER_TYPE.Instant then
            if reflecting then 
                Reflection_RegisterProjectile( filepath );
                return;
            end
        
            BeginProjectile( filepath );
                draw_shot( create_shot( trigger_action_draw_count ), true );
            EndProjectile()
        else
            local force_trigger_death = EntityGetVariableNumber( player, "gkbrkn_force_trigger_death", 0 );
            if force_trigger_death ~= 1 then
                gkbrkn._add_projectile( filepath );
            else
                gkbrkn._add_projectile_trigger_death( filepath, 1 );
            end
        end
    end
    gkbrkn.extra_projectiles = 0;
end

function add_projectile_trigger_timer( entity_filename, delay_frames, action_draw_count )
    set_trigger_timer( delay_frames, action_draw_count );
    add_projectile( entity_filename );
end

function add_projectile_trigger_hit_world( entity_filename, action_draw_count )
    set_trigger_hit_world( action_draw_count );
    add_projectile( entity_filename );
end

function add_projectile_trigger_death( entity_filename, action_draw_count )
    set_trigger_death( action_draw_count );
    add_projectile( entity_filename );
end

function set_trigger_timer( delay_frames, action_draw_count )
    table.insert( gkbrkn.trigger_queue, {
        type=gkbrkn.TRIGGER_TYPE.Timer,
        delay_frames=delay_frames,
        action_draw_count=action_draw_count,
    });
end

function set_trigger_hit_world( action_draw_count )
    table.insert( gkbrkn.trigger_queue, {
        type=gkbrkn.TRIGGER_TYPE.Hit,
        action_draw_count=action_draw_count,
    });
end

function set_trigger_death( action_draw_count )
    table.insert( gkbrkn.trigger_queue, {
        type=gkbrkn.TRIGGER_TYPE.Death,
        action_draw_count=action_draw_count,
    });
end

function set_trigger_instant( action_draw_count )
    table.insert( gkbrkn.trigger_queue, {
        type=gkbrkn.TRIGGER_TYPE.Instant,
        action_draw_count=action_draw_count,
    });
end

function stack_next_action( amount )
    gkbrkn.stack_next_actions = gkbrkn.stack_next_actions + amount;
end

function extra_projectiles( amount )
    gkbrkn.extra_projectiles = gkbrkn.extra_projectiles + amount;
end

function delete_cloned_actions()
    for _,clear_table in pairs( { deck, discarded, hand } ) do
        for i=#clear_table,1,-1 do
            local action = clear_table[i];
            if action.cloned ~= nil then
                action.cloned = nil;
            end
            if action.clone == true then
                table.remove( clear_table, i );
            end
        end
    end
end

-- TODO this should not set variables on actions and instead keep a local table of which
-- actions have been cloned and which actions are clones to avoid potential issues
function duplicate_draw_action_old( amount, instant_reload_if_empty )
    if #deck >= 1 then
        local original_amount = amount;
        local drawn_before = state_cards_drawn;
        local next_natural_action_index = #deck;
        for index,action in pairs( deck ) do
            if action.clone ~= true then
                if index < next_natural_action_index then
                    next_natural_action_index = index;
                end
            end
        end
    
        local next_natural_action = deck[next_natural_action_index];
    
        if next_natural_action.clone ~= true then
            if next_natural_action.cloned == true then
                amount = amount + 1;
            end
            for i=1,amount-1 do
                local clone = {};
                for k,v in pairs( next_natural_action ) do
                    clone[k] = v;
                end
                clone.clone = true;
                clone.cloned = false;
                table.insert( deck, next_natural_action_index + 1 , clone );
            end
            next_natural_action.cloned = true;
        end
    
        local last_cloned_action_index = 1;
        for index,action in pairs( deck ) do
            if action.clone == true then
                if index > last_cloned_action_index then
                    last_cloned_action_index = index;
                end
            end
        end
        draw_actions( original_amount, instant_reload_if_empty );
    end
end

function temporary_deck( callback, new_deck, new_hand, new_discarded )
    local _deck = deck;
    local _hand = hand;
    local _discarded = discarded;
    deck = new_deck;
    hand = new_hand;
    discarded = new_discarded;
    callback( deck, hand, discarded );
    deck = _deck;
    hand = _hand;
    discarded = _discarded;
end