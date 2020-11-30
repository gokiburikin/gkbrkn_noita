dofile_once( "data/scripts/gun/gun_enums.lua" );
dofile_once( "data/scripts/gun/gun_actions.lua" );

return function( include_locked )
    local action_data = {};
    for k,action in pairs( actions_cache or actions ) do
        action_count = (action_count or 0) + 1;
        if action.type ~= nil and ( include_locked == true or is_action_unlocked( action ) ) then
            action_data[action.id] = action;
        end
    end
    return action_data;
end