dofile_once( "data/scripts/gun/gun_enums.lua" )
dofile_once( "data/scripts/gun/gun_actions.lua" )

local is_action_unlocked = function( action )
    local valid = false
    if action then
        if action.spawn_requires_flag ~= nil then
            local flag_name = action.spawn_requires_flag
            local flag_status = HasFlagPersistent( flag_name )
            if flag_status then valid = true end
            -- Music Notes
            --if action.spawn_probability == "0" then  valid = false end
        else
            valid = true
        end
        return valid
    end
end

return function( include_locked )
    local action_data = {}
    for k,action in pairs( actions ) do
        if ( include_locked == true or is_action_unlocked( action ) ) then
            action_data[action.id] = action
            action_data[action.id].enabled = true
        end
    end
    for k,action in pairs( actions_cache ) do
        if action_data[action.id] == nil then
            if ( include_locked == true or is_action_unlocked( action ) ) then
                action_data[action.id] = action
                action_data[action.id].enabled = false
            end
        end
    end
    return action_data
end