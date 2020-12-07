dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

function get_active_item_inventory( player_entity )
    local inventory = nil;
    local player_inventories = EntityGetAllChildren( player_entity );
    for k,v in pairs( player_inventories ) do
        if EntityGetName( v ) == "inventory_quick" then
            inventory = v;
            break;
        end
    end
    return inventory;
end

function is_item_active_item( player_entity, item )
    local inventory = EntityGetFirstComponent( player_entity, "Inventory2Component" );
    if inventory then
        if ComponentGetValue2( inventory, "mActiveItem" ) == item then return true; end
        if ComponentGetValue2( inventory, "mActualActiveItem" ) == item then return true; end
    end
    return false;
end

function get_item_inventory( player_entity, index )
    local inventory_entities = EntityGetWithTag( "gkbrkn_inventory" ) or {};
    local inventory = nil;
    for k,inventory_entity in pairs( inventory_entities ) do
        if EntityHasNamedVariable( inventory_entity, "gkbrkn_item_inventory_"..index ) then
            inventory = inventory_entity;
            break;
        end
    end
    if inventory == nil then
        local entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/serialize_entity.xml" );
        EntityAddNamedVariable( entity, "gkbrkn_item_inventory_"..index );
        EntityAddTag( entity, "gkbrkn_inventory" );
        EntityAddChild( player_entity, entity );
        inventory = entity;
    end
    return inventory;
end

function swap_item_inventories( left, right )
    local left_inventory_entities = EntityGetAllChildren( left ) or {};
    local right_inventory_entities = EntityGetAllChildren( right ) or {};
    for _,child in pairs(left_inventory_entities) do EntityRemoveFromParent( child ); end
    for _,child in pairs(right_inventory_entities) do EntityRemoveFromParent( child ); end
    for _,child in pairs(left_inventory_entities) do EntityAddChild( right, child ); end
    for _,child in pairs(right_inventory_entities) do EntityAddChild( left, child ); end
    left_inventory_entities = EntityGetAllChildren( left ) or {};
    right_inventory_entities = EntityGetAllChildren( right ) or {};
end

function change_item_inventory( player_entity, index )
    local current_item_inventory_index = tonumber( GlobalsGetValue( "gkbrkn_current_item_inventory_index", "0" ) );
    if current_item_inventory_index ~= index then
        local inventory_entities = EntityGetWithTag( "gkbrkn_inventory" ) or {};
        local current_item_inventory_entity = get_item_inventory( player_entity, current_item_inventory_index );
        local next_item_inventory_entity = get_item_inventory( player_entity, index );

        if current_item_inventory_entity and next_item_inventory_entity then
            swap_item_inventories( get_active_item_inventory( player_entity ), current_item_inventory_entity );
            for k,v in pairs( EntityGetAllChildren( current_item_inventory_entity ) or {} ) do
                if not is_item_active_item( player_entity, v ) then
                    EntitySetComponentsWithTagEnabled( v, "enabled_in_world", false );
                    EntitySetComponentsWithTagEnabled( v, "enabled_in_hand", false );
                end
            end
            swap_item_inventories( get_active_item_inventory( player_entity ), next_item_inventory_entity );
            GlobalsSetValue( "gkbrkn_current_item_inventory_index", index );
        end
    end
end

function next_item_inventory( player_entity, change )
    local current_item_inventory_index = tonumber( GlobalsGetValue( "gkbrkn_current_item_inventory_index", "0" ) );
    local next_index = math.max( 0, current_item_inventory_index + change );
    if current_item_inventory_index ~= next_index then
        local current_inventory = get_item_inventory( player_entity, current_item_inventory_index );
        local next_inventory = get_item_inventory( player_entity, next_index );
        change_item_inventory( player_entity, next_index );
        GamePrint( "Swapped to inventory "..( next_index + 1 ) );
    end
end





function get_active_spell_inventory( player_entity )
    local inventory = nil;
    local player_inventories = EntityGetAllChildren( player_entity );
    for k,v in pairs( player_inventories ) do
        if EntityGetName( v ) == "inventory_full" then
            inventory = v;
            break;
        end
    end
    return inventory;
end

function get_spell_inventory( player_entity, index )
    local inventory_entities = EntityGetWithTag( "gkbrkn_inventory" ) or {};
    local inventory = nil;
    for k,inventory_entity in pairs( inventory_entities ) do
        if EntityHasNamedVariable( inventory_entity, "gkbrkn_spell_inventory_"..index ) then
            inventory = inventory_entity;
            break;
        end
    end
    if inventory == nil then
        local entity = EntityCreateNew();
        EntityAddNamedVariable( entity, "gkbrkn_spell_inventory_"..index );
        EntityAddTag( entity, "gkbrkn_inventory" );
        EntityAddChild( player_entity, entity );
        inventory = entity;
    end
    return inventory;
end

function swap_spell_inventories( left, right )
    local left_inventory_entities = EntityGetAllChildren( left ) or {};
    local right_inventory_entities = EntityGetAllChildren( right ) or {};
    for _,child in pairs(left_inventory_entities) do EntityRemoveFromParent( child ); end
    for _,child in pairs(right_inventory_entities) do EntityRemoveFromParent( child ); end
    for _,child in pairs(left_inventory_entities) do EntityAddChild( right, child ); end
    for _,child in pairs(right_inventory_entities) do EntityAddChild( left, child ); end
    left_inventory_entities = EntityGetAllChildren( left ) or {};
    right_inventory_entities = EntityGetAllChildren( right ) or {};
end

function change_spell_inventory( player_entity, index )
    local current_spell_inventory_index = tonumber( GlobalsGetValue( "gkbrkn_current_spell_inventory_index", "0" ) );
    if current_spell_inventory_index ~= index then
        local inventory_entities = EntityGetWithTag( "gkbrkn_inventory" ) or {};
        local current_spell_inventory_entity = get_spell_inventory( player_entity, current_spell_inventory_index );
        local next_spell_inventory_entity = get_spell_inventory( player_entity, index );

        if current_spell_inventory_entity and next_spell_inventory_entity then
            swap_spell_inventories( get_active_spell_inventory( player_entity ), current_spell_inventory_entity );
            for k,v in pairs( EntityGetAllChildren( current_spell_inventory_entity ) or {} ) do
                EntitySetComponentsWithTagEnabled( v, "enabled_in_world", false );
                EntitySetComponentsWithTagEnabled( v, "enabled_in_hand", false );
            end
            swap_spell_inventories( get_active_spell_inventory( player_entity ), next_spell_inventory_entity );
            GlobalsSetValue( "gkbrkn_current_spell_inventory_index", index );
        end
    end
end

function next_spell_inventory( player_entity, change )
    local current_spell_inventory_index = tonumber( GlobalsGetValue( "gkbrkn_current_spell_inventory_index", "0" ) );
    local next_index = math.max( 0, current_spell_inventory_index + change );
    if current_spell_inventory_index ~= next_index then
        local current_inventory = get_spell_inventory( player_entity, current_spell_inventory_index );
        local next_inventory = get_spell_inventory( player_entity, next_index );
        change_spell_inventory( player_entity, next_index );
        GamePrint( "Swapped to inventory "..( next_index + 1 ) );
    end
end