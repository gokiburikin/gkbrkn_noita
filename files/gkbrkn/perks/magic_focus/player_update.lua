dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua")

local entity = GetUpdatedEntityID();
local children = EntityGetAllChildren( entity );
local valid_wands = {};
local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" );
local active_item = ComponentGetValue2( inventory2, "mActiveItem" );
for key, child in pairs( children ) do
    if EntityGetName( child ) == "inventory_quick" then
        valid_wands = EntityGetChildrenWithTag( child, "wand" ) or {};
        break;
    end
end

for _,wand in pairs( valid_wands ) do
    if wand ~= active_item then
        local ability = WandGetAbilityComponent( wand, "AbilityComponent" );
        if ability ~= nil then
            local reload_frames_left = ComponentGetValue2( ability, "mReloadFramesLeft" );
            if reload_frames_left > 0 then
                ComponentSetValue2( ability, "mReloadFramesLeft", reload_frames_left - 1 );
            end
        end
    end
end