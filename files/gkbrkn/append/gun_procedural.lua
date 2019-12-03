dofile_once( "data/scripts/gun/gun_enums.lua" );
dofile_once( "files/gkbrkn/config.lua" );
_generate_gun = _generate_gun or generate_gun;

local extended_types = {
    ACTION_TYPE_STATIC_PROJECTILE,
    ACTION_TYPE_MATERIAL,
    ACTION_TYPE_OTHER,
    ACTION_TYPE_UTILITY,
    ACTION_TYPE_PASSIVE
};
local chance_to_replace = 1;
function generate_gun( cost, level, force_unshuffle)
    _generate_gun( cost, level, force_unshuffle );
    if HasFlagPersistent( MISC.ChaoticWandGeneration.Enabled ) then
        local entity = GetUpdatedEntityID();
        local x,y = EntityGetTransform( entity );
        local local_wands = EntityGetInRadiusWithTag( x, y, 1, "wand" ) or {};
        for _,wand in pairs(local_wands) do
            local children = EntityGetAllChildren( wand );
            for _,child in ipairs( children ) do
                EntityRemoveFromParent( child );
                local child_to_return = child;
                local components = EntityGetAllComponents( child );
                for _, component in ipairs( components ) do
                    local action_id = ComponentGetValue( component, "action_id" );
                    if action_id ~= nil and action_id ~= "" then
                        -- TODO an assert will fail if the action type pool is empty
                        -- not too much that can be done about this right now, doesn't show up outside of dev
                        local action = GetRandomActionWithType( x, y, level or Random(0,6), Random(0,7), Random(0,1000)+_+x+y );
                        if action ~= nil and action ~= "" then
                            child_to_return = CreateItemActionEntity( action, x, y );
                            EntitySetComponentsWithTagEnabled( child_to_return, "enabled_in_world", false );
                        end
                    end
                end
                EntityAddChild( wand, child_to_return );
            end
        end
    elseif HasFlagPersistent( MISC.ExtendedWandGeneration.Enabled ) then
        local entity = GetUpdatedEntityID();
        local x,y = EntityGetTransform( entity );
        local local_wands = EntityGetInRadiusWithTag( x, y, 1, "wand" ) or {};
        for _,wand in pairs(local_wands) do
            local children = EntityGetAllChildren( wand );
            for _,child in ipairs( children ) do
                EntityRemoveFromParent( child );
                local child_to_return = child;
                local components = EntityGetAllComponents( child );
                for _, component in ipairs( components ) do
                    local action_id = ComponentGetValue( component, "action_id" );
                    if action_id ~= nil and action_id ~= "" and Random() <= chance_to_replace then
                        -- TODO an assert will fail if the action type pool is empty
                        -- not too much that can be done about this right now, doesn't show up outside of dev
                        local action = GetRandomActionWithType( x, y, level or 6, extended_types[Random(1,#extended_types)], Random(0,1000)+_+x+y );
                        if action ~= nil and action ~= "" then
                            child_to_return = CreateItemActionEntity( action, x, y );
                            EntitySetComponentsWithTagEnabled( child_to_return, "enabled_in_world", false );
                        end
                    end
                end
                EntityAddChild( wand, child_to_return );
            end
        end
    end
end