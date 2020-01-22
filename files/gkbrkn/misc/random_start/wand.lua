dofile_once("data/scripts/lib/utilities.lua");
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua");
dofile_once("data/scripts/gun/procedural/gun_procedural.lua" );
dofile_once("data/scripts/gun/gun_actions.lua");
dofile_once("data/scripts/gun/procedural/wands.lua" );
dofile_once("data/scripts/gun/gun_enums.lua");

function EntityComponentGetValue( entity_id, component_type_name, component_key, default_value )
    local component = EntityGetFirstComponent( entity_id, component_type_name );
    if component ~= nil then
        return ComponentGetValue( component, component_key );
    end
    return default_value;
end

function get_random_from( target )
    return tostring( Random( 1, #target ) );
end

function get_random_between_range( target )
    local min = target[1];
    local max = target[2];
    return Random( min, max );
end

local entity_id = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity_id );

local ability_component = EntityGetFirstComponent( entity_id, "AbilityComponent" );

local time_ratio = 60;
local gun = {
    name = {"Bolt Staff"},
    deck_capacity = {3,6},
    actions_per_round = {1,2,3},
    reload_time = { 0.07  * time_ratio, 0.7 * time_ratio },
    shuffle_deck_when_empty = {0,1},
    cast_delay = { 0.0  * time_ratio, 0.5 * time_ratio },
    spread_degrees = {-2,6},
    speed_multiplier = 1,
    mana_charge_speed = {10,60},
    mana_max = {100,350},
    projectile_actions = {},
    limited_projectile_actions = {},
    cost_actions = {},
    modifier_actions = {},
    utility_actions = {},
    all_actions = {},
}

local blacklist = {
    projectile_actions = { TELEPORT_PROJECTILE=false, PIPE_BOMB_DETONATOR },
    limited_projectile_actions = { TELEPORT_PROJECTILE=false, PIPE_BOMB_DETONATOR },
    cost_actions = { },
    modifier_actions = { },
    utility_actions = { },
    all_actions = { },
};

for index,action in pairs(actions) do
    if action ~= nil then
        if action.type ~= nil then
            if action.type ~= ACTION_TYPE_MODIFIER and action.type ~= ACTION_TYPE_DRAW_MANY then
                if action.max_uses ~= nil and action.max_uses > -1 then
                    if blacklist.cost_actions[action.id] == nil then
                        table.insert( gun.cost_actions, action.id );
                    end
                end
            end
            if action.type == ACTION_TYPE_PROJECTILE then
                if action.max_uses == nil or action.max_uses == -1 then
                    if blacklist.projectile_actions[action.id] == nil then
                        table.insert( gun.projectile_actions, action.id );
                    end
                else
                    if blacklist.limited_projectile_actions[action.id] == nil then
                        table.insert( gun.limited_projectile_actions, action.id );
                    end
                end
            end
            if action.type == ACTION_TYPE_MODIFIER or action.type == ACTION_TYPE_DRAW_MANY or action.type == ACTION_TYPE_PASSIVE then
                if blacklist.modifier_actions[action.id] == nil then
                    table.insert( gun.modifier_actions, action.id );
                end
            end
            if action.type == ACTION_TYPE_UTILITY then
                if blacklist.utility_actions[action.id] == nil then
                    table.insert( gun.utility_actions, action.id );
                end
            end
        end
        if blacklist.all_actions[action.id] == nil then
            table.insert( gun.all_actions, action.id );
        end
    end
end

local mana_max = get_random_between_range( gun.mana_max );
local deck_capacity = get_random_between_range( gun.deck_capacity );
local action_count = Random( 1, tonumber( deck_capacity ) );

ComponentSetValue( ability_component, "ui_name", tostring(get_random_from( gun.name )) );

ComponentObjectSetValue( ability_component, "gun_config", "reload_time", tostring(get_random_between_range( gun.reload_time )) );
ComponentObjectSetValue( ability_component, "gunaction_config", "fire_rate_wait", tostring(get_random_between_range( gun.cast_delay )) );
ComponentSetValue( ability_component, "mana_charge_speed", tostring(get_random_between_range( gun.mana_charge_speed)) );

ComponentObjectSetValue( ability_component, "gun_config", "actions_per_round", tostring(random_from_array(gun.actions_per_round)) );
ComponentObjectSetValue( ability_component, "gun_config", "deck_capacity", tostring(deck_capacity) );
ComponentObjectSetValue( ability_component, "gun_config", "shuffle_deck_when_empty", tostring(random_from_array(gun.shuffle_deck_when_empty)) );
ComponentObjectSetValue( ability_component, "gunaction_config", "spread_degrees", tostring(get_random_between_range(gun.spread_degrees)) );
ComponentObjectSetValue( ability_component, "gunaction_config", "speed_multiplier", tostring(gun.speed_multiplier) );

ComponentSetValue( ability_component, "mana_max", tostring(mana_max) );
ComponentSetValue( ability_component, "mana", tostring(mana_max) );

if math.random() > 1 / action_count then
    AddGunAction( entity_id, random_from_array( gun["modifier_actions"] ) );
    action_count = action_count - 1;
end
while action_count > 0 do
    local pool = EntityComponentGetValue( entity_id, "VariableStorageComponent", "value_string", "random_start_actions_pool" );
    if pool == "projectile_actions" and #gun[pool] == 0 then
        pool ="limited_projectile_actions";
    end
    if pool == "cost_actions" and #gun[pool] == 0 then
        pool ="all_actions";
    end
    local random_action = random_from_array( gun[pool] );
    if random_action ~= nil  and random_action ~= "" then
        -- TODO don't add spells we can't cast
        --local mana_use = random_action.mana;
        --if mana_use <= mana_max then
            AddGunAction( entity_id, random_action );
            action_count = action_count - 1;
        --end
    else
        action_count = action_count - 1;
    end
end

local wand = random_from_array(wands);
SetWandSprite( entity_id, ability_component, wand.file, wand.grip_x, wand.grip_y, (wand.tip_x - wand.grip_x), (wand.tip_y - wand.grip_y) );