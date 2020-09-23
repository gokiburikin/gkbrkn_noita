local entity = GetUpdatedEntityID();
local material_inventory = EntityGetFirstComponentIncludingDisabled( entity, "MaterialInventoryComponent" );
if material_inventory ~= nil then
    local count_per_material_type = ComponentGetValue2( material_inventory, "count_per_material_type");
    for k,v in pairs( count_per_material_type ) do
        if v > 0 then
            AddMaterialInventoryMaterial( entity, CellFactory_GetName( k - 1 ), v - 1 );
            --count_per_material_type[k] = v - 1;
        end
    end
    --ComponentSetValue2( material_inventory, "count_per_material_type", count_per_material_type );
end