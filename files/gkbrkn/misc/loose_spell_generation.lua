for _,action in pairs(actions) do
    local spawn_levels = {};
    local spawn_probabilities = {};
    local average_probability = 0;
    for word in string.gmatch( action.spawn_level, '([^,]+)' ) do
        table.insert( spawn_levels, tonumber( word ) );
    end
    for word in string.gmatch( action.spawn_probability, '([^,]+)' ) do
        local probability = tonumber( word ) or 0;
        table.insert( spawn_probabilities, probability );
        average_probability = average_probability + probability;
    end
    average_probability = average_probability / #spawn_probabilities;
    for index,probability in ipairs(spawn_probabilities) do
        spawn_probabilities[index] = average_probability;
    end
    --action.spawn_level       = table.concat( spawn_levels, "," );
    action.spawn_level       = "0,1,2,3,4,5,6,7";
    action.spawn_probability = table.concat( spawn_probabilities, "," );
end
