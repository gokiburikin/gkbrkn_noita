dofile( "files/gkbrkn/helper.lua");

gkbrkn = {
    TRIGGER_TYPE = {
        Timer=1,
        Hit=2,
        Death=3
    },
    extra_projectiles = 0,
    stack_next_actions = 0,
    stack_projectiles = "",
    trigger_data = {
        type = 0,
        action_draw_count = 1,
        delay_frames = 0,
    },
    trigger_queue = {},
    draw_action_stack_size = 0,
    _add_projectile = add_projectile,
    _move_hand_to_discarded = move_hand_to_discarded,
    _play_action = play_action,
    _draw_action = draw_action,
}

--function play_action( action )
--    gkbrkn._play_action( action );
--end

function draw_action( instant_reload_if_empty )
    gkbrkn.draw_action_stack_size = gkbrkn.draw_action_stack_size + 1;
    gkbrkn._draw_action( instant_reload_if_empty );
    gkbrkn.draw_action_stack_size = gkbrkn.draw_action_stack_size - 1;
    gkbrkn.stack_next_actions = 0;
    gkbrkn.stack_projectiles = "";
    gkbrkn.extra_projectiles = 0;
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
    local projectiles_to_add = 0;
    if #deck == 0 then
        gkbrkn.stack_next_actions = 0;
    end
    if #gkbrkn.stack_projectiles > 0 and gkbrkn.stack_next_actions == 0 then
        c.extra_entities = c.extra_entities..gkbrkn.stack_projectiles;
        gkbrkn.stack_projectiles = "";
        projectiles_to_add = projectiles_to_add + gkbrkn.extra_projectiles + 1;
        gkbrkn.extra_projectiles = 0;
    elseif gkbrkn.stack_next_actions > 0 then
        gkbrkn.stack_next_actions = gkbrkn.stack_next_actions - 1;
        gkbrkn.stack_projectiles = (gkbrkn.stack_projectiles or "") .. filepath..",";
        draw_action( 1 );
    else
        projectiles_to_add = projectiles_to_add + gkbrkn.extra_projectiles + 1;
        gkbrkn.extra_projectiles = 0;
    end
    for i=1,projectiles_to_add do
        if trigger_type == gkbrkn.TRIGGER_TYPE.Timer then
            add_projectile_trigger_timer( filepath, trigger_delay_frames, trigger_action_draw_count );
        elseif trigger_type == gkbrkn.TRIGGER_TYPE.Death then
            add_projectile_trigger_death( filepath, trigger_action_draw_count );
        elseif trigger_type == gkbrkn.TRIGGER_TYPE.Hit then
            add_projectile_trigger_hit_world( filepath, trigger_action_draw_count );
        else
            gkbrkn._add_projectile( filepath );
        end
    end
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

function retain_spell_cast( chance )
    if current_action ~= nil and current_action.uses_remaining ~= nil then
        if gkbrkn.draw_action_stack_size <= 1 and current_action.uses_remaining > 0 and math.random() <= chance then
            current_action.uses_remaining = current_action.uses_remaining + 1;
        end
    end
end

function stack_next_action( amount )
    gkbrkn.stack_next_actions = gkbrkn.stack_next_actions + amount;
end

function extra_projectiles( amount )
    gkbrkn.extra_projectiles = gkbrkn.extra_projectiles + amount;
end

--function move_hand_to_discarded()
--    gkbrkn._move_hand_to_discarded();
--    gkbrkn.stack_next_actions = 0;
--    gkbrkn.stack_projectiles = "";
--    gkbrkn.extra_projectiles = 0;
--end