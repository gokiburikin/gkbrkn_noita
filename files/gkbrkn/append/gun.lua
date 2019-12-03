dofile_once( "files/gkbrkn/config.lua");
dofile_once( "files/gkbrkn/helper.lua");
dofile_once( "files/gkbrkn/lib/variables.lua");

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
    projectiles_fired = 0,
    skip_cards = 0,
    trigger_queue = {},
    draw_action_stack_size = 0,
    _draw_actions = draw_actions,
    _play_action = play_action,
    _add_projectile = add_projectile,
    _move_hand_to_discarded = move_hand_to_discarded,
    _draw_action = draw_action,
    _add_projectile_trigger_timer = add_projectile_trigger_timer,
    _add_projectile_trigger_death = add_projectile_trigger_death,
    _add_projectile_trigger_hit_world = add_projectile_trigger_hit_world,
}

function skip_cards( amount )
    if amount == nil then
        amount = #deck;
    end
    gkbrkn.skip_cards = amount;
end

local reset_per_casts = function()
    delete_cloned_actions();
    gkbrkn.projectiles_fired = 0;
    gkbrkn.stack_next_actions = 0;
    gkbrkn.stack_projectiles = "";
end

function move_hand_to_discarded()
    GlobalsSetValue( "gkbrkn_projectiles_fired", gkbrkn.projectiles_fired );
    gkbrkn._move_hand_to_discarded();
    gkbrkn.reset_on_draw = true;
end

function play_action( action )
    if gkbrkn.reset_on_draw == true then
        gkbrkn.reset_on_draw = false;
        reset_per_casts();
    end
    gkbrkn._play_action(action);
end

function draw_actions( how_many, instant_reload_if_empty )
    gkbrkn.instant_reload_if_empty = instant_reload_if_empty;
    gkbrkn._draw_actions( how_many, instant_reload_if_empty );
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
    if gkbrkn.skip_cards <= 0 then
        --for index,extra_modifier in pairs( active_extra_modifiers ) do
        --    handle_extra_modifier( extra_modifier, index, gkbrkn.draw_action_stack_size );
        --end
        result = gkbrkn._draw_action( instant_reload_if_empty );
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
    local player = GetUpdatedEntityID();
    local rapid_fire_level = EntityGetVariableNumber( player, "gkbrkn_rapid_fire", 0 );
    local extra_projectiles_level = EntityGetVariableNumber( player, "gkbrkn_extra_projectiles", 0 );
    if gkbrkn.draw_action_stack_size == 0 then
        if HasFlagPersistent( MISC.LessParticles.Enabled ) then
            if HasFlagPersistent( MISC.LessParticles.DisableEnabled ) then
                c.extra_entities = c.extra_entities.."files/gkbrkn/misc/less_particles/disable_particles.xml,";
            else
                c.extra_entities = c.extra_entities.."files/gkbrkn/misc/less_particles/less_particles.xml,";
            end
        end
        local current_protagonist_bonus = EntityGetVariableNumber( player, "gkbrkn_low_health_damage_bonus", 0.0 );
        if current_protagonist_bonus ~= 0 then
            c.extra_entities = c.extra_entities.."files/gkbrkn/perks/protagonist/projectile_extra_entity.xml,";
        end
        if #deck == 0 then
            current_reload_time = current_reload_time * math.pow( 0.5, rapid_fire_level );
        end
        c.fire_rate_wait = c.fire_rate_wait * math.pow( 0.5, rapid_fire_level );
        c.spread_degrees = c.spread_degrees + 8 * rapid_fire_level;
        c.spread_degrees = c.spread_degrees + 3 * extra_projectiles_level;
    end
    c.fire_rate_wait = c.fire_rate_wait + 8 * extra_projectiles_level;
    current_reload_time = current_reload_time + 8 * extra_projectiles_level;
    return result;
end

function add_projectile( filepath )
    local trigger_type = 0;
    local trigger_delay_frames = 0;
    local trigger_action_draw_count = 1;
    if #gkbrkn.trigger_queue > 0 then
        trigger_type = gkbrkn.trigger_queue[1].type;
        trigger_delay_frames = gkbrkn.trigger_queue[1].delay_frames;
        trigger_action_draw_count = gkbrkn.trigger_queue[1].action_draw_count;
        table.remove( gkbrkn.trigger_queue, 1 );
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
        if trigger_type == gkbrkn.TRIGGER_TYPE.Timer then
            gkbrkn._add_projectile_trigger_timer( filepath, trigger_delay_frames, trigger_action_draw_count );
        elseif trigger_type == gkbrkn.TRIGGER_TYPE.Death then
            gkbrkn._add_projectile_trigger_death( filepath, trigger_action_draw_count );
        elseif trigger_type == gkbrkn.TRIGGER_TYPE.Hit then
            gkbrkn._add_projectile_trigger_hit_world( filepath, trigger_action_draw_count );
        elseif trigger_type == gkbrkn.TRIGGER_TYPE.Instant then
            if reflecting then 
                Reflection_RegisterProjectile( filepath )
                return;
            end
        
            BeginProjectile( filepath );
                draw_shot( create_shot( trigger_action_draw_count ), true );
            EndProjectile()
        else
            gkbrkn._add_projectile( filepath );
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
function duplicate_draw_action( amount, instant_reload_if_empty )
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