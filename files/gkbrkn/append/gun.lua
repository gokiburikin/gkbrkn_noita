local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

--[[
gun.*:
    shuffle_deck_when_empty
    deck_capacity
    actions_per_round
    reload_time
]]

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
    projectiles_fired = {},
    skip_cards = 0,
    trigger_queue = {},
    old_trigger_queue = {},
    add_projectile_capture_callback = nil,
    draw_actions_capture = nil,
    capture_draw_actions = true,
    draw_action_stack_size = 0,
    iteration_groups = {},
    did_action_add_projectile = false,
    mana_multiplier = 1.0,
    skip_projectiles = false,
    added_projectiles = 0,
    add_projectile_depth = 0,
    register_action_callback = nil,
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
    _BeginProjectile = BeginProjectile,
    _register_action = register_action,
    _clone_action = clone_action,
}

function register_action( state )
    local c = state;
    if gkbrkn.register_action_callback ~= nil then
        local callback_state = {};
        for k,v in pairs( state ) do
            callback_state[k] = v;
        end
        gkbrkn.register_action_callback( callback_state );
        c = callback_state;
        --gkbrkn._register_action( callback_state );
    else
        --gkbrkn._register_action( state );
    end
    local player = GetUpdatedEntityID();
    local calibration_level = EntityGetVariableNumber( player, "gkbrkn_magic_focus_stacks", 0 );
    local last_calibration_shot = EntityGetVariableNumber( player, "gkbrkn_last_calibration_shot_frame", 0 );
    local last_calibration_percent = EntityGetVariableNumber( player, "gkbrkn_last_calibration_shot_percent", 0 );
    local calibration_multiplier = get_magic_focus_multiplier( last_calibration_shot, last_calibration_percent );
    local rapid_fire_level = EntityGetVariableNumber( player, "gkbrkn_rapid_fire", 0 );
    local lead_boots = EntityGetVariableNumber( player, "gkbrkn_lead_boots", 0 );
    if #deck == 0 then
        current_reload_time = math.min( current_reload_time, current_reload_time * math.pow( 0.5, rapid_fire_level ) );
    end
    c.fire_rate_wait = math.min( c.fire_rate_wait, c.fire_rate_wait * math.pow( 0.5, rapid_fire_level ) );
    c.spread_degrees = c.spread_degrees + 8 * rapid_fire_level;
    c.spread_degrees = c.spread_degrees - c.spread_degrees * calibration_level * calibration_multiplier * 0.5 - calibration_multiplier * calibration_level * 10;
    c.fire_rate_wait = c.fire_rate_wait - c.fire_rate_wait * calibration_level * calibration_multiplier * 0.5 - calibration_multiplier * calibration_level * 6;
    current_reload_time = current_reload_time - current_reload_time * calibration_level * calibration_multiplier * 0.5 - calibration_multiplier * calibration_level * 6;
    if lead_boots > 0 then
        local character_data = EntityGetFirstComponent( player, "CharacterDataComponent" );
        if character_data ~= nil then
            if ComponentGetValue2( character_data, "is_on_ground" ) == true then
                shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10000;
            end
        end
    end

    gkbrkn._register_action( c );
    state_per_cast( c );
    --if not reflecting then
    --    for k,v in pairs(c) do
    --        print(k.."/"..tostring(v));
    --    end
    --end
    return state;
end

function BeginProjectile( filepath )
    gkbrkn.added_projectiles = gkbrkn.added_projectiles + 1;
    gkbrkn._BeginProjectile( filepath );
end

function iterate_group( id )
    local current_id = gkbrkn.iteration_groups[id] or 0;
    gkbrkn.iteration_groups[id] = ( gkbrkn.iteration_groups[id] or 0 ) + 1;
    return id.."_"..current_id;
end

function state_per_cast( state )
    gkbrkn.extra_projectiles = 0;
    gkbrkn.iteration_groups = {};
    gkbrkn.skip_projectiles = false;
    gkbrkn.mana_multiplier = 1.0;
    gkbrkn.added_projectiles = 0;
end

function create_shot( num_of_cards_to_draw )
    local shot = gkbrkn._create_shot( num_of_cards_to_draw );
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

function clone_action( source, target )
    gkbrkn._clone_action( source, target );
    if setting_get( "dev_option_infinite_spells" ) then target.custom_uses_logic = true; end
end

function peek_draw_action( shot, instant_reload_if_empty )
    --local _deck = deck;
    --local _hand = hand;
    --local _discarded = discarded;
    --deck = deck_from_actions( deck );
    --hand = deck_from_actions( hand );
    --discarded = deck_from_actions( discarded );
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

    --deck = _deck;
    --hand = _hand;
    --discarded = _discarded;

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

    --if gkbrkn.draw_actions_capture then
    --    for _,action in pairs( capture ) do
    --        table.insert( gkbrkn.draw_actions_capture, action );
    --    end
    --end

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
    gkbrkn.projectiles_fired = {};
    gkbrkn.old_trigger_queue = {};
end

function calculate_mana( base_mana )
    return base_mana * gkbrkn.mana_multiplier;
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
                        if ComponentGetValue2( component, "action_id" ) == "GKBRKN_ORDER_DECK" then
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
    
    -- This allows me to hook into the mana access and call an arbitrary function. Very tricksy
    for _,action in pairs(deck) do
        if action.gkbrkn == nil then
            local base_mana = action.mana or 0;
            action.mana = nil;
            local action_meta = {
                __index = function( table, key )
                    if key == "mana" then
                        return calculate_mana( base_mana );
                    end
                end
            }
            setmetatable( action, action_meta );
            action.gkbrkn = true;
        end
    end
end

function move_hand_to_discarded()
    gkbrkn._move_hand_to_discarded();
    gkbrkn.reset_on_draw = true;
    gkbrkn.drawn_actions = {};
end

function pre_play_action( action )
    local player = GetUpdatedEntityID();
    local rapid_fire_level = EntityGetVariableNumber( player, "gkbrkn_rapid_fire", 0 );
    local extra_projectiles_level = EntityGetVariableNumber( player, "gkbrkn_extra_projectiles", 0 );
    gkbrkn.did_action_add_projectile = false;
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
    if action.mana then
        if playing_permanent_card and action.mana < 0 and find_tweak("allow_negative_mana_always_cast") then
            mana = mana - action.mana;
        end
    end
    if playing_permanent_card and MISC.PerkOptions.BloodMagic.FreeAlwaysCasts == false then
        local player = GetUpdatedEntityID();
        local blood_magic_stacks = EntityGetVariableNumber( player, "gkbrkn_blood_magic_stacks", 0 );
        if blood_magic_stacks > 0 then
            local blood_to_mana_ratio = MISC.PerkOptions.BloodMagic.BloodToManaRatio * blood_magic_stacks / 25;
            local used_mana = action.mana;
            local damage_models = EntityGetComponent( player, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                local hp = tonumber( ComponentGetValue2( damage_model, "hp" ) );
                ComponentSetValue2( damage_model, "hp", hp - blood_to_mana_ratio * used_mana );
            end
        end
    end
    gkbrkn._play_action( action );
end

function post_play_action( action )
    gkbrkn.trigger_queue[gkbrkn.draw_action_stack_size] = {};
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
    if not reflecting and not c.extra_entities:find("mods/gkbrkn_noita/files/gkbrkn/misc/projectile_indexing.xml,") then
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/misc/projectile_indexing.xml,";
    end

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
                local hp = ComponentGetValue2( damage_model, "hp" );
                ComponentSetValue2( damage_model, "hp", hp - used_mana / 25 );
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
    post_play_action();
    gkbrkn.draw_action_stack_size = gkbrkn.draw_action_stack_size - 1;
    gkbrkn.draw_cards_remaining = gkbrkn.draw_cards_remaining - 1;

    if GameHasFlagRun( FLAGS.DisintegrateCorpses ) then
        c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
    end
    
    if gkbrkn.draw_action_stack_size == 0 then

        state_per_cast( c );
    else
        --c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/misc/ephemeral.xml,"
    end
    return result;
end

function add_projectile( filepath )
    gkbrkn.add_projectile_depth = gkbrkn.add_projectile_depth + 1;
    if not gkbrkn.did_action_add_projectile then
        local player = GetUpdatedEntityID();
        local extra_projectiles_level = EntityGetVariableNumber( player, "gkbrkn_extra_projectiles", 0 );
        gkbrkn.extra_projectiles = gkbrkn.extra_projectiles + extra_projectiles_level;
        gkbrkn.did_action_add_projectile = true;
        c.fire_rate_wait = c.fire_rate_wait + 2 * extra_projectiles_level;
        current_reload_time = current_reload_time + 2 * extra_projectiles_level;
    end
    if gkbrkn.extra_projectiles > 0 then
        gkbrkn.extra_projectiles = gkbrkn.extra_projectiles - 1;
        add_projectile( filepath );
    end
    gkbrkn.projectiles_fired[gkbrkn.draw_action_stack_size] = (gkbrkn.projectiles_fired[gkbrkn.draw_action_stack_size] or 0) + 1;
    local trigger_type = 0;
    local trigger_delay_frames = 0;
    local trigger_action_draw_count = nil;
    if find_tweak( "trigger_block_expansion" ) then
        local trigger_queue_index = gkbrkn.draw_action_stack_size;
        local trigger_queue = gkbrkn.trigger_queue[trigger_queue_index];
        while (trigger_queue and #trigger_queue == 0) or (trigger_queue == nil and trigger_queue_index > 0) do
            -- NOTE: this is to catch non nil and non zero projectile counts that happened before this
            if gkbrkn.projectiles_fired[trigger_queue_index - 1] then
                break;
            end
            trigger_queue_index = trigger_queue_index - 1;
            trigger_queue = gkbrkn.trigger_queue[trigger_queue_index];
        end
        if trigger_queue and #trigger_queue > 0 then
            trigger_type = trigger_queue[1].type;
            trigger_delay_frames = trigger_queue[1].delay_frames;
            trigger_action_draw_count = trigger_queue[1].action_draw_count;
        end
    else
        if #gkbrkn.old_trigger_queue > 0 then
            trigger_type = gkbrkn.old_trigger_queue[1].type;
            trigger_delay_frames = gkbrkn.old_trigger_queue[1].delay_frames;
            trigger_action_draw_count = gkbrkn.old_trigger_queue[1].action_draw_count;
            table.remove( gkbrkn.old_trigger_queue, 1 );
        end
    end
    if gkbrkn.peeking > 0 then
        if trigger_action_draw_count ~= nil then
            draw_actions( trigger_action_draw_count, true );
        end
    else
        if gkbrkn.skip_projectiles ~= true then
            if gkbrkn.add_projectile_capture_callback ~= nil and gkbrkn.peeking == 0 then
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
                else
                    BeginProjectile( filepath );
                        draw_shot( create_shot( trigger_action_draw_count ), true );
                    EndProjectile()
                end
            else
                local force_trigger_death = EntityGetVariableNumber( player, "gkbrkn_force_trigger_death", 0 );
                if force_trigger_death ~= 1 then
                    gkbrkn._add_projectile( filepath );
                else
                    gkbrkn._add_projectile_trigger_death( filepath, 1 );
                end
            end
        end
    end
    gkbrkn.add_projectile_depth = gkbrkn.add_projectile_depth - 1;
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

function get_current_trigger_queue()
    if find_tweak( "trigger_block_expansion") then
        gkbrkn.trigger_queue[ gkbrkn.draw_action_stack_size ] = gkbrkn.trigger_queue[ gkbrkn.draw_action_stack_size ] or {};
        return gkbrkn.trigger_queue[ gkbrkn.draw_action_stack_size ];
    else
        return gkbrkn.old_trigger_queue;
    end
end

function set_trigger_timer( delay_frames, action_draw_count )
    table.insert( get_current_trigger_queue(), {
        type=gkbrkn.TRIGGER_TYPE.Timer,
        delay_frames=delay_frames,
        action_draw_count=action_draw_count,
    });
end

function set_trigger_hit_world( action_draw_count )
    table.insert( get_current_trigger_queue(), {
        type=gkbrkn.TRIGGER_TYPE.Hit,
        action_draw_count=action_draw_count,
    });
end

function set_trigger_death( action_draw_count )
    table.insert( get_current_trigger_queue(), {
        type=gkbrkn.TRIGGER_TYPE.Death,
        action_draw_count=action_draw_count,
    });
end

function set_trigger_instant( action_draw_count )
    table.insert( get_current_trigger_queue(), {
        type=gkbrkn.TRIGGER_TYPE.Instant,
        action_draw_count=action_draw_count,
    });
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