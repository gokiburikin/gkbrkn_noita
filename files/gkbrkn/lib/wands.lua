local WAND_STAT_SETTER = {
    Direct = 1,
    Gun = 2,
    GunAction = 3
}

local WAND_STAT_SETTERS = {
    shuffle_deck_when_empty = WAND_STAT_SETTER.Gun,
    actions_per_round = WAND_STAT_SETTER.Gun,
    speed_multiplier = WAND_STAT_SETTER.GunAction,
    deck_capacity = WAND_STAT_SETTER.Gun,
    reload_time = WAND_STAT_SETTER.Gun,
    fire_rate_wait = WAND_STAT_SETTER.GunAction,
    spread_degrees = WAND_STAT_SETTER.GunAction,
    mana_charge_speed = WAND_STAT_SETTER.Direct,
    mana_max = WAND_STAT_SETTER.Direct,
    mana = WAND_STAT_SETTER.Direct,
}

function ability_component_get_stat( ability, stat, value )
    local setter = WAND_STAT_SETTERS[stat];
    if setter ~= nil then
        if setter == WAND_STAT_SETTER.Direct then
            return ComponentGetValue( ability, stat );
        elseif setter == WAND_STAT_SETTER.Gun then
            return ComponentObjectGetValue( ability, "gun_config", stat );
        elseif setter == WAND_STAT_SETTER.GunAction then
            return ComponentObjectGetValue( ability, "gunaction_config", stat );
        end
    end
end

function ability_component_set_stat( ability, stat, value )
    local setter = WAND_STAT_SETTERS[stat];
    if setter ~= nil then
        if setter == WAND_STAT_SETTER.Direct then
            ComponentSetValue( ability, stat, tostring( value ) );
        elseif setter == WAND_STAT_SETTER.Gun then
            ComponentObjectSetValue( ability, "gun_config", stat, tostring( value ) );
        elseif setter == WAND_STAT_SETTER.GunAction then
            ComponentObjectSetValue( ability, "gunaction_config", stat, tostring( value ) );
        end
    end
end

function ability_component_adjust_stat( ability, stat, callback )
    local setter = WAND_STAT_SETTERS[stat];
    if setter ~= nil then
        local current_value = nil;
        if setter == WAND_STAT_SETTER.Direct then
            current_value = ComponentGetValue( ability, stat );
        elseif setter == WAND_STAT_SETTER.Gun then
            current_value = ComponentObjectGetValue( ability, "gun_config", stat );
        elseif setter == WAND_STAT_SETTER.GunAction then
            current_value = ComponentObjectGetValue( ability, "gunaction_config", stat );
        end
        local new_value = callback( current_value );
        if setter == WAND_STAT_SETTER.Direct then
            ComponentSetValue( ability, stat, tostring( new_value ) );
        elseif setter == WAND_STAT_SETTER.Gun then
            ComponentObjectSetValue( ability, "gun_config", stat, tostring( new_value ) );
        elseif setter == WAND_STAT_SETTER.GunAction then
            ComponentObjectSetValue( ability, "gunaction_config", stat, tostring( new_value ) );
        end
    end
end

function ability_component_set_stats( ability, stat_value_table )
    for stat,value in pairs(stat_value_table) do
        ability_component_set_stat( ability, stat, value );
    end
end

function ability_component_adjust_stats( ability, stat_callback_table )
    for stat,callback in pairs(stat_callback_table) do
        ability_component_adjust_stat( ability, stat, callback );
    end
end