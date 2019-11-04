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
    local result = gkbrkn._draw_action( instant_reload_if_empty );
    gkbrkn.draw_action_stack_size = gkbrkn.draw_action_stack_size - 1;
    gkbrkn.stack_next_actions = 0;
    gkbrkn.stack_projectiles = "";
    gkbrkn.extra_projectiles = 0;
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

function parse_deck( t )
    if t == nil then t = deck end
    local j = {}
    for k,v in pairs(t) do
        local name = "";
        if v.name == "$action_bubbleshot" then
            name = name .."b";
        else
            name = name .."m";
        end
        if v.clone == true then
            name = name.."*";
        end
        if v.cloned == true then
            name = "("..name..")";
        end
        table.insert( j, name );
    end
    return j;
end

local dda = 0;
-- TODO this should not set variables on actions and instead keep a local table of which
-- actions have been cloned and which actions are clones to avoid potential issues
function duplicate_draw_action( amount, instant_reload_if_empty )
    if #deck >= 1 then
        local drawn_before = state_cards_drawn;
        local ldda = dda;
        dda = dda + 1;
        Log("duplicate_draw_action",ldda);
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
        --[[
            this is breaking because draw actions is called multiple times before all of the 
            previous duplicates draw actions are completed
            for example

            if the first duplicate draws 2 actions and the first of those actions is another duplicate
            after that duplicate resolves it will draw another action which is resulting in drawing
            excess cards
        ]]
        local adjusted_draw_amount = 2;
        Log( "deck:", unpack(parse_deck(deck)) );
        Log( current_action.name,"will draw",adjusted_draw_amount,"from the deck" );
        draw_actions( 1, instant_reload_if_empty );
        Log( "deck after", unpack(parse_deck(deck)) );
        delete_cloned_actions();
        --[[
            m m b b b b b b
            m m* m m*
        ]]
    end
end