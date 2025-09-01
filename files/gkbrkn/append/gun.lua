--##DEV local STATS = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/stats.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")

local EntityGetVariableString = function( e, tag, default )
    local variable = EntityGetFirstComponentIncludingDisabled( e, "VariableStorageComponent", tag )
    if variable then return ComponentGetValue2( variable, "value_string" ) end
    return default
end

local EntitySetVariableString = function( e, tag, value )
    local current_variable = EntityGetFirstComponentIncludingDisabled( e, "VariableStorageComponent", tag )
    if current_variable then
        ComponentSetValue2( current_variable, "value_string", value )
    else
        local c = EntityAddComponent2( e, "VariableStorageComponent", {
            value_string = tostring(value)
        } )
        ComponentAddTag( c, tag )
    end
end

local EntityGetVariableNumber = function( e, tag, default )
    return tonumber( EntityGetVariableString( e, tag, default ) )
end

local print_deck = function( custom_deck )
	if custom_deck == nil then custom_deck = deck end
	local d = ""
	for k,v in pairs(custom_deck) do
		d = d .. v.id..", "
	end
	print(d)
end

--[[ Gun System Notes

-- c = {} or c = * for some reason breaks things, do not use it (push_c and pop_c added for this purpose)
---- in particular using c = {} somehow commits spread_degrees? found when trying to add isolate spell

-- register_action(c) and SetProjectileConfigs() must be called in order inside 
-- of a trigger to commit the modifiers to the cast
-- Not calling them or calling them out of order will not apply the modifiers
]]

gkbrkn = {
    hide_next_action = nil,
    extra_projectiles = 0,
    extra_projectile_depth = 0,
    in_draw_action = false,
    deck_stack = {},
    last_mana = nil,
    mana_copy = false,
    free_casts = 0,
    do_projectile_capture = 0,
    duplicating = false,
    add_projectile_capture_callback = nil,
    draw_actions_capture = nil,
    capture_next_play_as_draw = false,
    mana_multiplier = 1.0,
    peeking = 0,
    instant_resume = false,
    instant_resume_trigger = false,
    play_action_stack = {},

    _OnActionPlayed = OnActionPlayed,
    _create_shot = create_shot,
    _draw_actions = draw_actions,
    _play_action = play_action,
    _add_projectile = add_projectile,
    _move_hand_to_discarded = move_hand_to_discarded,
    _order_deck = order_deck,
    _draw_action = draw_action,
    _register_action = register_action,
    _draw_shot = draw_shot,
    __start_shot = _start_shot,
    __draw_actions_for_shot = _draw_actions_for_shot,
}

function _draw_actions_for_shot( can_reload_at_end )
    gkbrkn.__draw_actions_for_shot( can_reload_at_end )
    state_per_cast( c )
end

function _start_shot( current_mana )
    gkbrkn.__start_shot( current_mana )
    local draw_remaining = EntityGetVariableNumber( GetUpdatedEntityID(), "gkbrkn_draw_remaining", 0 )
    if draw_remaining > 0 then
        root_shot.num_of_cards_to_draw = gun.deck_capacity
    end
    local player = GetUpdatedEntityID()
    gkbrkn.extra_projectiles = EntityGetVariableNumber( player, "gkbrkn_extra_projectiles", 0 )
    gkbrkn.mana_multiplier = 1.0
    local barrage = EntityGetVariableNumber( player, "gkbrkn_barrage", 0 )
    if barrage > 0 then
        gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 0.3
    end
end

function draw_shot( shot, instant_reload_if_empty )
    gkbrkn._draw_shot( shot, instant_reload_if_empty )
    if gkbrkn.instant_resume == true then
        gkbrkn.instant_resume = false
        if gkbrkn.instant_resume_trigger == true then
            gkbrkn.instant_resume_trigger = false
            push_c()
            BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" )
            BeginTriggerDeath()
                reloading = false
                start_reload = false
                --shot.num_of_cards_to_draw = 1
                --gkbrkn._draw_shot( shot, instant_reload_if_empty )
                draw_actions( 1, instant_reload_if_empty )
                register_action(c)
                SetProjectileConfigs()
            EndTrigger()
            EndProjectile()
            pop_c()
            register_action(c)
            SetProjectileConfigs()
        else
            start_reload = false
            shot.num_of_cards_to_draw = 1
            gkbrkn._draw_shot( shot, instant_reload_if_empty )
        end
    end
    if not reflecting and gkbrkn.do_projectile_capture > 0 then
        gkbrkn.do_projectile_capture = gkbrkn.do_projectile_capture - 1
        add_projectile("mods/gkbrkn_noita/files/gkbrkn/misc/projectile_capture.xml", true)
    end
end

function register_action( state )
    local c = state
    if not reflecting then
        local player = GetUpdatedEntityID()
        
        local rapid_fire_level = EntityGetVariableNumber( player, "gkbrkn_rapid_fire", 0 )
        if rapid_fire_level > 0 then
            if #deck == 0 then
                current_reload_time = math.min( current_reload_time, current_reload_time * math.pow( 0.5, rapid_fire_level ) )
            end
            c.fire_rate_wait = math.min( c.fire_rate_wait, c.fire_rate_wait * math.pow( 0.5, rapid_fire_level ) )
            c.spread_degrees = c.spread_degrees + 8 * rapid_fire_level
        end

        local magic_focus_stacks = EntityGetVariableNumber( player, "gkbrkn_magic_focus_stacks", 0 )
        if magic_focus_stacks > 0 then
            local calibration_multiplier = get_magic_focus_multiplier( last_calibration_shot, last_calibration_percent )
            local last_calibration_shot = EntityGetVariableNumber( player, "gkbrkn_last_calibration_shot_frame", 0 )
            local last_calibration_percent = EntityGetVariableNumber( player, "gkbrkn_last_calibration_shot_percent", 0 )
            c.spread_degrees = c.spread_degrees - c.spread_degrees * magic_focus_stacks * calibration_multiplier * 0.5 - calibration_multiplier * magic_focus_stacks * 10
            c.fire_rate_wait = c.fire_rate_wait - c.fire_rate_wait * magic_focus_stacks * calibration_multiplier * 0.5 - calibration_multiplier * magic_focus_stacks * 6
            current_reload_time = current_reload_time - current_reload_time * magic_focus_stacks * calibration_multiplier * 0.5 - calibration_multiplier * magic_focus_stacks * 6
        end

        local lead_boots = EntityGetVariableNumber( player, "gkbrkn_lead_boots", 0 )
        if lead_boots > 0 then
            local character_data = EntityGetFirstComponent( player, "CharacterDataComponent" )
            if character_data ~= nil then
                if ComponentGetValue2( character_data, "is_on_ground" ) == true then
                    shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10000
                end
            end
        end

        local barrage = EntityGetVariableNumber( player, "gkbrkn_barrage", 0 )
        if barrage > 0 then
            c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/perks/barrage/projectile_extra_entity.xml,"
            add_projectile("mods/gkbrkn_noita/files/gkbrkn/misc/projectile_capture.xml")
            shot_effects.recoil_knockback = shot_effects.recoil_knockback * 0.1
            c.knockback_force = c.knockback_force * 0.1
            c.fire_rate_wait = math.min( 3, c.fire_rate_wait )
            current_reload_time = 0
        end
        
        local base_wand = WandGetActive( player )
        if base_wand ~= nil then
            local unique_appends = {
            ["gkbrkn_magic_hand"] = "mods/gkbrkn_noita/files/gkbrkn/actions/magic_hand/projectile_extra_entity.xml,",
            }
            local wand_children = EntityGetAllChildren( base_wand ) or {}
            for _,action in pairs( wand_children ) do
                for k,v in pairs(unique_appends) do
                    if EntityHasVarTag( action, k ) then
                        if not c.extra_entities:find(v) then
                            c.extra_entities = c.extra_entities .. v
                        end
                    end
                end
                if EntityHasVarTag( action, "gkbrkn_laser_sight" ) then
                    c.speed_multiplier = c.speed_multiplier + 0.5
                    c.spread_degrees = c.spread_degrees - 2
                end
            end
        end
    end

    gkbrkn._register_action( c )

    return state
end

function state_per_cast()
    if not reflecting then
        if gkbrkn.play_action_stack and #gkbrkn.play_action_stack > 0 then
            EntitySetVariableString( GetUpdatedEntityID(), "gkbrkn_last_draw", table.concat(gkbrkn.play_action_stack,",") )
            gkbrkn.play_action_stack = {}
        end
        gkbrkn.do_projectile_capture = 0
    end
end

function deck_from_actions( actions, start_index )
    local deck = {}
    if start_index == nil then start_index = 1 end
    for i=start_index,#actions,1 do
        table.insert( deck, actions[i] )
    end
    return deck
end

local _cm_last_action = nil
function calculate_mana( base_mana, action )
    local cost = base_mana
    if cost > 0 then
        cost = cost * gkbrkn.mana_multiplier
    end
    if gkbrkn.free_casts > 0 then
        gkbrkn.free_casts = gkbrkn.free_casts - 1
        cost = 0
    end
    if gkbrkn.mana_copy and gkbrkn.last_mana ~= nil then
        cost = gkbrkn.last_mana
        gkbrkn.mana_copy = false
    end
    if action.id ~= "GKBRKN_MANA_COPY" and _cm_last_action ~= action then
        gkbrkn.last_mana = cost
    end
    _cm_last_action = action
    return cost
end

function order_deck()
    gkbrkn.memoize_mana = {}
    gkbrkn.last_mana = nil
    local force_sorted = false
    local player = GetUpdatedEntityID()
    local base_wand = WandGetActive( player )
    if base_wand ~= nil then
        local wand_children = EntityGetAllChildren( base_wand ) or {}
        for _,wand_child in pairs( wand_children ) do
            if EntityHasVarTag( wand_child, "gkbrkn_order_deck" ) then
                force_sorted = true
            end
        end
    end
    if force_sorted then
        local before = gun.shuffle_deck_when_empty
        gun.shuffle_deck_when_empty = false
        gkbrkn._order_deck()
        gun.shuffle_deck_when_empty = before
    else
        gkbrkn._order_deck()
    end
    
    -- This allows me to hook into the mana access and call an arbitrary function
    for _,action in pairs(deck) do
        if action.gkbrkn == nil then
        
            local base_mana = action.mana or 0
            action.mana = nil
            local action_meta = {
                __index = function( table, key )
                    if key == "mana" then
                        return calculate_mana( base_mana, action )
                    end
                end
            }
            setmetatable( action, action_meta )

            --[[ If we end up using extended show played actions this is how it's done
            action._action = action.action
            action.action = function( recursion_level, iteration )
                table.insert( gkbrkn.play_action_stack, action )
                action._action( recursion_level, iteration )
            end]]

            if action.id == "GKBRKN_SIPHON" then
                action._uses_remaining = action.uses_remaining
                action.uses_remaining = nil
                local action_meta = {
                    __index = function( table, key )
                        if key == "uses_remaining" then
                            if gkbrkn.in_draw_action then
                                return 1
                            else
                                return table._uses_remaining
                            end
                        end
                    end,
                    __newindex = function( table, key, value )
                        if key == "uses_remaining" then
                            table._uses_remaining = value
                        end
                    end,
                }
                setmetatable( action, action_meta )
            end
            action.gkbrkn = true
        end
    end
end

function move_hand_to_discarded()
    for _,action in pairs(hand) do
        if action.id == "GKBRKN_SIPHON" then
            rawset( action, "uses_remaining", action.uses_remaining )
        end
    end
    gkbrkn._move_hand_to_discarded()
    gkbrkn.drawn_actions = {}
end

function secret_play_action( action )
    gkbrkn.hide_next_action = true
    play_action( action )
end

function OnActionPlayed( id )
    if gkbrkn.hide_next_action == true then
        gkbrkn.hide_next_action = false
        return
    end
    table.insert( gkbrkn.play_action_stack, id )
    gkbrkn._OnActionPlayed( id )
end

function play_action( action )
    if action.id == "GKBRKN_EVALUATOR" then
        table.insert( hand, action )
        gkbrkn.instant_resume = true
        reloading = true
        return
    elseif action.id == "GKBRKN_SEGMENTOR" then
        table.insert( hand, action )
        gkbrkn.instant_resume = true
        gkbrkn.instant_resume_trigger = true
        reloading = true
        return
    elseif action.id == "GKBRKN_MIMICRY" then
        gkbrkn.hide_next_action = true
    end

    -- This is set to true before draw_action so we can capture the correct draw result even after an instant reload
    if gkbrkn.capture_next_play_as_draw then
        -- We set this to ensure we don't capture play_action as a draw unless we just called draw_action
        gkbrkn.capture_next_play_as_draw = false
        if gkbrkn.draw_actions_capture then
            table.insert( gkbrkn.draw_actions_capture, action )
        end
    end

    gkbrkn._play_action( action )
end

function peek_draw_actions( how_many, instant_reload_if_empty, keep_deck )
    push_c(true)
    local _deck = {}
    local _hand = {}
    local _discarded = {}
    if keep_deck == true then
        for k,v in pairs(deck) do _deck[k] = v end
        for k,v in pairs(hand) do _hand[k] = v end
        for k,v in pairs(discarded) do _discarded[k] = v end
    end

    local peeked_actions = {}
    local _draw_actions_capture = gkbrkn.draw_actions_capture

    local _reloading = reloading
    gkbrkn.peeking = gkbrkn.peeking + 1
    gkbrkn.draw_actions_capture = peeked_actions

    local _draw_action = draw_action
    -- TODO this is probably not good for performance though it might also be negligible
    draw_action = function()
        gkbrkn.hide_next_action = true
        local _mana = mana
        _draw_action( instant_reload_if_empty )
        mana = _mana
    end
    draw_actions( how_many, instant_reload_if_empty )
    gkbrkn.hide_next_action = false
    draw_action = _draw_action

    gkbrkn.draw_actions_capture = _draw_actions_capture
    gkbrkn.peeking = gkbrkn.peeking - 1
    reloading = _reloading

    if keep_deck == true then
        for k,v in pairs(deck) do deck[k] = nil end
        for k,v in pairs(hand) do hand[k] = nil end
        for k,v in pairs(discarded) do discarded[k] = nil end
        for k,v in pairs(_deck) do deck[k] = v end
        for k,v in pairs(_hand) do hand[k] = v end
        for k,v in pairs(_discarded) do discarded[k] = v end
    end
    pop_c()
    return peeked_actions
end

function draw_actions( how_many, instant_reload_if_empty )
    local actions_to_draw = how_many
    local player = GetUpdatedEntityID()
    local extra_actions = EntityGetVariableNumber( player, "gkbrkn_draw_actions_bonus", 0 )
    if extra_actions > 0 then
        actions_to_draw = extra_actions + actions_to_draw
    end
    gkbrkn._draw_actions( actions_to_draw, instant_reload_if_empty )
end

function draw_action( instant_reload_if_empty )
    --##DEV local t = GameGetRealWorldTimeSinceStarted()

    local result = false
    local player = GetUpdatedEntityID()

    gkbrkn.in_draw_action = true
    gkbrkn.capture_next_play_as_draw = true
    result = gkbrkn._draw_action( instant_reload_if_empty )
    gkbrkn.in_draw_action = false

    -- If we failed to play the action it was discarded so capture it from there
    if result == false and gkbrkn.capture_next_play_as_draw == true then
        gkbrkn.capture_next_play_as_draw = false
        if gkbrkn.draw_actions_capture and #discarded > 0 then
            table.insert( gkbrkn.draw_actions_capture, discarded[#discarded] )
        end
    end

    --##DEV STATS.add_and_count("draw_action",(GameGetRealWorldTimeSinceStarted() - t))
    return result
end

function duplicate_draw_action( amount, repeat_n_times, instant_reload_if_empty, keep_deck )
    if gkbrkn.duplicating == true then
        draw_actions( 1, instant_reload_if_empty )
        return
    end
    gkbrkn.duplicating = true
    local captured = peek_draw_actions( amount, instant_reload_if_empty, keep_deck )
    if #captured == 0 then
        gkbrkn.duplicating = false
        return 
    end
    local to_draw = repeat_n_times
    for i=#captured,1,-1 do
        if captured[i].id == "GKBRKN_DOUBLE_CAST" then
            to_draw = to_draw * 2
            for j=i+1,#captured do
                table.insert( captured, captured[j] )
            end
            table.remove( captured, i )
        elseif captured[i].id == "GKBRKN_TRIPLE_CAST" then
            to_draw = to_draw * 3
            for j=i+1,#captured do
                table.insert( captured, captured[j] )
            end
            for j=i+1,#captured do
                table.insert( captured, captured[j] )
            end
            table.remove( captured, i )
        end
    end
    local size = #captured
    for i=1,repeat_n_times-1 do
        for j=1,size do
            table.insert( captured, captured[j] )
        end
    end
    temporary_deck( function( deck, hand, discarded )
        draw_actions( to_draw, instant_reload_if_empty )
        register_action( c )
        SetProjectileConfigs()
    end, captured )
    gkbrkn.duplicating = false
end

function add_projectile( filepath, skip_callback )
    if gkbrkn.peeking > 0 then return end
    if skip_callback ~= true and gkbrkn.add_projectile_capture_callback ~= nil then
        gkbrkn.add_projectile_capture_callback( filepath )
    else
        local force_trigger_death = EntityGetVariableNumber( player, "gkbrkn_force_trigger_death", 0 )
        if force_trigger_death ~= 1 then
            gkbrkn._add_projectile( filepath )
        else
            gkbrkn._add_projectile_trigger_death( filepath, 1 )
        end
    end
    
    if gkbrkn.extra_projectiles > 0 then
        gkbrkn.extra_projectiles = gkbrkn.extra_projectiles - 1
        add_projectile( filepath )
    end
end

function temporary_deck( callback, new_deck, new_hand, new_discarded )
    local _deck = deck
    local _hand = hand
    local _discarded = discarded
    table.insert( gkbrkn.deck_stack, {deck = deck, hand = hand, discarded = discarded } )
    deck = new_deck or {}
    hand = new_hand or {}
    discarded = new_discarded or {}
    callback( deck, hand, discarded )
    table.remove( gkbrkn.deck_stack, #gkbrkn.deck_stack )
    deck = _deck
    hand = _hand
    discarded = _discarded
end

_c_stack = {}
function push_c( keep )
    local n = {}
    for k,v in pairs(c) do
        n[k] = v
    end
    table.insert( _c_stack, n )
    if keep ~= true then
        reset_modifiers(c)
    end
    return c
end

function pop_c()
    if #_c_stack <= 0 then return end
    for k,v in pairs(_c_stack[#_c_stack]) do
        c[k] = v
    end
    table.remove( _c_stack, #_c_stack )
end

function peek_c()
    if #_c_stack <= 0 then return c end
    for k,v in pairs(_c_stack[#_c_stack]) do
        c[k] = v
    end
end