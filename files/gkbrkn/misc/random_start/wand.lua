dofile("data/scripts/lib/utilities.lua");
dofile("data/scripts/gun/procedural/gun_enums.lua");
dofile("data/scripts/gun/procedural/gun_action_utils.lua");
dofile("data/scripts/gun/procedural/gun_procedural.lua" );
dofile("data/scripts/gun/gun_actions.lua");

function EntityComponentGetValue( entity_id, component_type_name, component_key, default_value )
    local component = EntityGetFirstComponent( entity_id, component_type_name );
    if component ~= nil then
        return ComponentGetValue( component, component_key );
    end
    return default_value;
end

function get_random_from( target )
    local rnd = Random( 1, #target );
    
	return target[rnd];
end

function get_random_between_range( target )
	local minval = target[1];
	local maxval = target[2];
	
	return Random( minval, maxval );
end

local entity_id = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity_id );

local ability_component = EntityGetFirstComponent( entity_id, "AbilityComponent" );

local time_ratio = 50;
local gun = { }
gun.name = {"Bolt Staff"}
gun.deck_capacity = {3,6};
gun.actions_per_round = {1,2,3};
gun.reload_time = { 0.1  * time_ratio, 1.5 * time_ratio };
gun.shuffle_deck_when_empty = {0,1};
gun.cast_delay = { 0.0  * time_ratio, 0.5 * time_ratio };
gun.spread_degrees = {-10,10};
gun.speed_multiplier = 1;
gun.mana_charge_speed = {10,50};
gun.mana_max = {100,350};
gun.projectile_actions = {};
gun.limited_projectile_actions = {};
gun.cost_actions = {};
gun.modifier_actions = {};
gun.utility_actions = {};

local blacklist = {
    projectile_actions = { TELEPORT_PROJECTILE=false, PIPE_BOMB_DETONATOR },
    limited_projectile_actions = { TELEPORT_PROJECTILE=false, PIPE_BOMB_DETONATOR },
    cost_actions = { },
    modifier_actions = { },
    utility_actions = { },
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
    local random_action = random_from_array( gun[pool] );
    -- TODO don't add spells we can't cast
    --local mana_use = random_action.mana;
    --if mana_use <= mana_max then
        AddGunAction( entity_id, random_action );
        action_count = action_count - 1;
    --end
end

dofile( "data/scripts/gun/procedural/wands.lua" );
local wand = random_from_array(wands);
SetWandSprite( entity_id, ability_component, wand.file, wand.grip_x, wand.grip_y, (wand.tip_x - wand.grip_x), (wand.tip_y - wand.grip_y) );