dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")

local e = GetUpdatedEntityID()
local player = EntityGetWithTag("player_unit")[1]
if not player then return end

local player_child_entities = EntityGetAllChildren( player )
if not player_child_entities then return end

local inventory = 0
for i,child_entity in ipairs( player_child_entities ) do
    local child_entity_name = EntityGetName( child_entity )
    
    if child_entity_name == "inventory_quick" then
        inventory = child_entity
        break
    end
end
if inventory == 0 then return end

local inventory_items = EntityGetAllChildren( inventory )
if not inventory_items or #inventory_items == 0 then return end

local materials = {}
for _,item_entity in ipairs( inventory_items ) do
    local potion = EntityGetFirstComponentIncludingDisabled( item_entity, "PotionComponent" )
    local material_inventory = EntityGetFirstComponentIncludingDisabled( item_entity, "MaterialInventoryComponent" )
    if potion and material_inventory then
        materials = {} -- Only get the last one
        materials[item_entity] = material_inventory
    end
end

for entity,material_inventory in pairs(materials) do
    local count_per_material_type = ComponentGetValue2( material_inventory, "count_per_material_type")
    local material_string = ""
    for k,v in pairs( count_per_material_type ) do
        if v >= 25 then
            AddMaterialInventoryMaterial( entity, CellFactory_GetName( k - 1 ), v - 25 )
            material_string = material_string..tostring(k-1)..","
        end
    end
    if #material_string > 0 then
        EntitySetVariableString( e, "gkbrkn_tranquilizer", material_string )
        EntityAddTag( e, "gkbrkn_tranquilizer" )
    end
end