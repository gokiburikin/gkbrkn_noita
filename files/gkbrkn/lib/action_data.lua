dofile_once( "data/scripts/gun/gun_enums.lua" );
dofile_once( "data/scripts/gun/gun_actions.lua" );

return function( include_locked )
    local action_data = {};
    for k,action in pairs( actions ) do
        if ( include_locked == true or is_action_unlocked( action ) ) then
            action_data[action.id] = action;
            action_data[action.id].enabled = true;
        end
    end
    for k,action in pairs( actions_cache ) do
        if action_data[action.id] == nil then
            if ( include_locked == true or is_action_unlocked( action ) ) then
                action_data[action.id] = action;
                action_data[action.id].enabled = false;
            end
        end
    end
    return action_data;
end