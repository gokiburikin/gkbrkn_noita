if _GKBRKN_HELPER == nil then dofile("files/gkbrkn/helper.lua") end

local entity = GetUpdatedEntityID();
local children = EntityGetAllChildren( entity );
local valid_wands = {};
local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" );
local active_item = ComponentGetValue( inventory2, "mActiveItem" );
for key, child in pairs( children ) do
    if EntityGetName( child ) == "inventory_quick" then
        valid_wands = EntityGetChildrenWithTag( child, "wand" ) or {};
        break;
    end
end

for _,wand in pairs(valid_wands) do
    if wand ~= active_item then
        local ability = WandGetAbilityComponent( wand, "AbilityComponent" );
        if ability ~= nil then
            local reload_frames_left = tonumber( ComponentGetValue( ability, "mReloadFramesLeft" ) );
            if reload_frames_left > 0 then
                ComponentSetValue( ability, "mReloadFramesLeft", tostring( reload_frames_left - 1  ) );
            end
        end
    end
end