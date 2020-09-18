-- TODO not sure how heavy this is to run every frame. item pickup & perk pickup event callback instead? look into it
local succ_bonus = EntityGetFirstComponent( player, "VariableStorageComponent", "gkbrkn_material_compression" );
if succ_bonus ~= nil then
    local current_succ_bonus = tonumber( ComponentGetValue2( succ_bonus, "value_string" ) );
    local children = EntityGetAllChildren( player );
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            for _,item in pairs( EntityGetAllChildren( child ) ) do
                local components = EntityGetAllComponents( item ) or {};
                for _,component in pairs(components) do
                    local succ_size = ComponentGetValue2( component, "barrel_size" );
                    local item_succ_bonus = EntityGetFirstComponent( item, "VariableStorageComponent", "gkbrkn_material_compression" );
                    if item_succ_bonus == nil then
                        item_succ_bonus = EntityAddComponent( item, "VariableStorageComponent", {
                            _tags="gkbrkn_material_compression,enabled_in_hand,enabled_in_inventory,enabled_in_world",
                            value_string="0"
                        });
                    end
                    local item_current_succ_bonus = tonumber( ComponentGetValue2( item_succ_bonus, "value_string" ) );
                    local succ_bonus_difference = current_succ_bonus - item_current_succ_bonus;
                    if succ_bonus_difference > 0 then
                        ComponentSetValue2( component, "barrel_size", succ_size * math.pow( 2, succ_bonus_difference ) );
                        ComponentSetValue2( item_succ_bonus, "value_string", tostring(current_succ_bonus) );
                    end
                end
            end
            break;
        end
    end
end