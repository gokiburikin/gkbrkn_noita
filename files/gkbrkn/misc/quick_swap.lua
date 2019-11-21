local controls = EntityGetFirstComponent( player, "ControlsComponent" );
local inventory2 = EntityGetFirstComponent( player, "Inventory2Component" );
if controls ~= nil and inventory2 ~= nil then
    local active_item = ComponentGetValue( inventory2, "mActiveItem" );
    if active_item == nil or EntityHasTag( active_item, "wand" ) == true then
        local alt_fire = ComponentGetValue( controls, "mButtonDownFire2" );
        local alt_fire_frame = ComponentGetValue( controls, "mButtonFrameFire2" );
        if alt_fire == "1" and GameGetFrameNum() == tonumber(alt_fire_frame) then
            local inventory = nil;
            local swap_inventory = nil;
            for _,child in pairs(EntityGetAllChildren( player )) do
                if EntityGetName(child) == "inventory_quick" then
                    inventory = child;
                elseif EntityGetName(child) == "gkbrkn_swap_inventory" then
                    swap_inventory = child;
                end
            end
            if inventory ~= nil and swap_inventory ~= nil then
                local inventory_entities = EntityGetAllChildren( inventory ) or {};
                local swap_inventory_entities = EntityGetAllChildren( swap_inventory ) or {};
                for _,child in pairs(inventory_entities) do EntityRemoveFromParent( child ); end
                for _,child in pairs(swap_inventory_entities) do EntityRemoveFromParent( child ); end
                for _,child in pairs(inventory_entities) do EntityAddChild( swap_inventory, child ); end
                for _,child in pairs(swap_inventory_entities) do EntityAddChild( inventory, child ); end
            end
        end
    end
end