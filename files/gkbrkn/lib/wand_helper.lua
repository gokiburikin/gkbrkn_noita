local can_player_edit_wands = function()
    local player = EntityGetWithTag("player_unit")[1]
    if not player then return false end
    if GameGetGameEffectCount( player, "EDIT_WANDS_EVERYWHERE" ) > 0 then
        return true
    end
    local workshops = EntityGetWithTag( "workshop" )
    if #workshops == 0 then return false end

    for _,hitbox in pairs(EntityGetComponent( player, "HitboxComponent" )) do
        local px, py = EntityGetTransform( player )
        local ox, oy = ComponentGetValue2( hitbox, "offset" )
        local px1, px2 = ComponentGetValue2( hitbox, "aabb_min_x" ) + ox + px, ComponentGetValue2( hitbox, "aabb_max_x" ) + ox + px
        local py1, py2 = ComponentGetValue2( hitbox, "aabb_min_y" ) + oy + py, ComponentGetValue2( hitbox, "aabb_max_y" ) + oy + py
        for _,workshop in pairs(workshops) do
            for _,workshop_hitbox in pairs(EntityGetComponent( workshop, "HitboxComponent" )) do
                local wx, wy = EntityGetTransform( workshop )
                local wox, woy = ComponentGetValue2( workshop_hitbox, "offset" )
                local wx1, wx2 = ComponentGetValue2( workshop_hitbox, "aabb_min_x" ) + wox + wx, ComponentGetValue2( workshop_hitbox, "aabb_max_x" ) + wox + wx
                local wy1, wy2 = ComponentGetValue2( workshop_hitbox, "aabb_min_y" ) + woy + wy, ComponentGetValue2( workshop_hitbox, "aabb_max_y" ) + woy + wy
                if px1 < wx2 and px2 > wx1 then
                    if py1 < wy2 and py2 > wy1 then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local entity_get_inventory2 = function( e )
    return EntityGetFirstComponent( e, "Inventory2Component" )
end

local player_get_inventory2 = function( e )
    return entity_get_inventory2( EntityGetWithTag("player_unit")[1] )
end

local entity_get_inventory_quick = function( e )
    for _,c in pairs( EntityGetAllChildren( e ) or {} ) do
        if EntityGetName( c ) == "inventory_quick" then return c end
    end
end

local entity_get_inventory_full = function( e )
    for _,c in pairs( EntityGetAllChildren( e ) or {} ) do
        if EntityGetName( c ) == "inventory_full" then return c end
    end
end

local entity_get_inventories = function( e )
    local quick = nil
    local full = nil
    for _,c in pairs( EntityGetAllChildren( e ) or {} ) do
        if EntityGetName( c ) == "inventory_full" then full = c end
        if EntityGetName( c ) == "inventory_quick" then quick = c end
        if full and quick then break end
    end
    return quick, full
end

local entity_get_wands = function( e )
    return EntityGetAllChildren( entity_get_inventory_quick( e ), "wand" ) or {}
end

local entity_get_available_slots_full = function( e )
    local i2 = entity_get_inventory2( e )
    if not i2 then return end
    
    local full = entity_get_inventory_full( e )
    if not full then return end
    
    local rows = ComponentGetValue2( i2, "full_inventory_slots_x" )
    local columns = ComponentGetValue2( i2, "full_inventory_slots_y" )
    local total_slots = rows * columns
    local children = EntityGetAllChildren( full )
    -- TODO should probably only count children with an item component? haven't tested
    if children and total_slots == #children then return end

    local taken_slots = {}
    
    if children then
        for _,c in pairs(children) do
            local item = EntityGetFirstComponentIncludingDisabled( c, "ItemComponent" )
            if item then
                local ix, iy = ComponentGetValue2( item, "inventory_slot" )
                local i = ix + iy * columns
                taken_slots[i+1] = true
            end
        end
    end

    local available_slots = {}
    for i=1,total_slots do
        if not taken_slots[i] then
            table.insert( available_slots, {i % columns, math.floor( i / columns ) } )
        end
    end
    if #available_slots == 0 then return end

    return available_slots
end

local entity_get_active_wand = function(e)
    local i2 = EntityGetFirstComponentIncludingDisabled( e, "Inventory2Component" )
    if i2 then
        local active_item = ComponentGetValue2( i2, "mActiveItem" )
        if EntityHasTag( active_item, "wand" ) then
            return active_item
        end
    end
end

local entity_force_refresh_inventory2 = function(e)
    local i2 = EntityGetFirstComponent( e, "Inventory2Component" )
    if i2 then
        ComponentSetValue2( i2, "mInitialized", false )
        ComponentSetValue2( i2, "mForceRefresh", true )
    end
end

local player_get_inventory_quick = function()
    for _,e in pairs( EntityGetAllChildren( EntityGetWithTag("player_unit")[1] ) or {} ) do
        if EntityGetName( e ) == "inventory_quick" then return e end
    end
end

local player_get_inventory_full = function()
    for _,e in pairs( EntityGetAllChildren( EntityGetWithTag("player_unit")[1] ) or {} ) do
        if EntityGetName( e ) == "inventory_full" then return e end
    end
end

local player_get_all_wands = function()
    return EntityGetChildrenWithTag( player_get_inventory_quick(), "wand" ) or {}
end

local player_get_filled_wand_slots = function()
    local slots = {}
    for _,wand in pairs(player_get_all_wands()) do
        local item = EntityGetFirstComponentIncludingDisabled( wand, "ItemComponent" )
        if item then
            local x,y = ComponentGetValue2( item, "inventory_slot" )
            table.insert( slots, x + 1 )
        end
    end
    return slots
end

local player_get_active_wand = function()
    return ComponentGetValue2( player_get_inventory2(), "mActiveItem" )
end

local player_get_all_actions = function()
    return EntityGetChildrenWithTag( player_get_inventory_full(), "card_action" ) or {}
end

local wand_get_all_actions = function( wand, include_permanently_attached )
    if include_permanently_attached == true then return EntityGetChildrenWithTag( wand, "card_action" ) or {} end
    local actions = {}
    for _,action in pairs(EntityGetChildrenWithTag( wand, "card_action" ) or {}) do
        local item = EntityGetFirstComponentIncludingDisabled( action, "ItemComponent" )
        if item then
            if ComponentGetValue2( item, "permanently_attached" ) == false then
                table.insert( actions, action )
            end
        end
    end
    return actions
end

local wand_move_actions_to_inventory = function( wand )
    local wand_actions = wand_get_all_actions( wand )
    if not wand_actions then return false end

    local player = EntityGetWithTag("player_unit")[1]
    local inventory_full = entity_get_inventory_full( player )
    local available_slots = entity_get_available_slots_full( player )
    if not available_slots then return false end

    local slot_index = 1
    for _,action in pairs(wand_get_all_actions( wand ) or {}) do
        local item = EntityGetFirstComponentIncludingDisabled( action, "ItemComponent" )
        if item then
            if ComponentGetValue2( item, "permanently_attached" ) == false then
                ComponentSetValue2( item, "inventory_slot", unpack(available_slots[slot_index]))
                EntityRemoveFromParent( action )
                EntityAddChild( inventory_full, action )
                slot_index = slot_index + 1
                if slot_index > #available_slots then break end
            end
        end
    end
    return true
end

local wand_move_inventory_to_wand = function( wand )
    for _,action in pairs(player_get_all_actions()) do
        EntityRemoveFromParent( action )
        EntityAddChild( wand, action )
    end
end

local wand_move_actions_to = function( wand, actions )
    for _,action in pairs(actions) do
        EntityRemoveFromParent( action )
        EntityAddChild( wand, action )
    end
end

local wand_move_actions_to_wand = function( from_wand, to_wand )
    wand_move_actions_to( to_wand, wand_get_all_actions( from_wand ) )
end

local wand_swap_actions = function( wand_a, wand_b )
    if wand_a == wand_b then return end
    local actions_a = wand_get_all_actions( wand_a )
    local actions_b = wand_get_all_actions( wand_b )
    for _,action in pairs(actions_a) do EntityRemoveFromParent( action ) end
    for _,action in pairs(actions_b) do EntityRemoveFromParent( action ) end
    for _,action in pairs(actions_a) do EntityAddChild( wand_b, action ) end
    for _,action in pairs(actions_b) do EntityAddChild( wand_a, action ) end
end

local push_actions = function( actions, offset )
    for _,action in pairs( actions ) do
        local item_action = EntityGetFirstComponentIncludingDisabled( action, "ItemActionComponent" )
        if item_action then
            local item = EntityGetFirstComponentIncludingDisabled( action, "ItemComponent" )
            if item then
                if ComponentGetValue2( item, "permanently_attached" ) == false then
                    local ix, iy = ComponentGetValue2( item, "inventory_slot" )
                    ComponentSetValue2( item, "inventory_slot", ix + offset, iy )
                end
            end
        end
    end
end

local wand_push_actions = function( wand, offset )
    push_actions( wand_get_all_actions(wand), offset )
end

local sort_actions_in = function( actions, entity )
    for _,a in pairs(actions) do
        EntityRemoveFromParent(a)
    end
    table.sort( actions, function( a, b )
        local item_a = EntityGetFirstComponentIncludingDisabled( a, "ItemActionComponent" )
        local item_b = EntityGetFirstComponentIncludingDisabled( b, "ItemActionComponent" )
        return ComponentGetValue2( item_a, "action_id" ) < ComponentGetValue2( item_b, "action_id" )
    end )
    local x = 0
    for _,a in pairs(actions) do
        --EntityRemoveFromParent(a)
        ComponentSetValue2( EntityGetFirstComponentIncludingDisabled( a, "ItemComponent" ), "inventory_slot", x, 0 )
        EntityAddChild( entity, a )
        x = x + 1
    end
end

local sort_actions = function( actions )
    table.sort( actions, function( a, b )
        local item_a = EntityGetFirstComponentIncludingDisabled( a, "ItemActionComponent" )
        local item_b = EntityGetFirstComponentIncludingDisabled( b, "ItemActionComponent" )
        return ComponentGetValue2( item_a, "action_id" ) < ComponentGetValue2( item_b, "action_id" )
    end )
    local x = 0
    for _,a in pairs(actions) do
        ComponentSetValue2( EntityGetFirstComponentIncludingDisabled( a, "ItemComponent" ), "inventory_slot", x, 0 )
        x = x + 1
    end
end

local wand_sort_actions = function( wand )
    sort_actions_in( wand_get_all_actions(wand), wand )
end

local inventory_add_actions = function( actions )
    local e = player_get_inventory_full()
    for _,a in pairs(actions or {}) do
        EntityAddChild( e, a )
    end
end

local inventory_remove_all_actions = function()
    local e = player_get_inventory_full()
    local actions = EntityGetAllChildren(e)
    for _,a in pairs(actions or {}) do
        EntityRemoveFromParent( a )
    end
    return actions
end

local inventory_sort_actions = function()
    --sort_actions_in( player_get_all_actions(), player_get_inventory_full() )
    local a = inventory_remove_all_actions()
    sort_actions(a)
    inventory_add_actions(a)
end

local explode_random_actions = function( actions, amount, x, y )
    for i=1,amount do
        if #actions <= 0 then return end
        local r = math.ceil( math.random() * #actions )
        local action = actions[r]
        table.remove( actions, r )
        EntityRemoveFromParent( action )
        EntitySetTransform( action, x, y, 0, 1, 1 )
        EntitySetComponentsWithTagEnabled( action, "enabled_in_world", true )
        EntitySetComponentsWithTagEnabled( action, "enabled_in_hand", false )
        EntitySetComponentsWithTagEnabled( action, "enabled_in_inventory", false )
        EntitySetComponentsWithTagEnabled( action, "item_unidentified", false )
        ComponentSetValue2( EntityGetFirstComponent( action, "VelocityComponent" ), "mVelocity", math.random( -75, 75 ), math.random( -150, -50 ) )
    end
end

local inventory_explode_random_actions = function( amount, include_permanent_actions )
    local player = EntityGetWithTag("player_unit")[1]
    if not player then return end
    explode_random_actions( player_get_all_actions(), amount, EntityGetTransform( player ) )
end

local wand_explode_random_actions = function( wand, amount, include_permanent_actions )
    explode_random_actions( wand_get_all_actions( wand, include_permanent_actions ), amount, EntityGetTransform( wand ) )
end

local wand_sprite_size = function( gui, wand )
	local ability_component = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
	local sprite = ComponentGetValue2( ability_component, "sprite_file" )
	return GuiGetImageDimensions( gui, sprite )
end

local wand_get_inventory_slot_height = function( gui, wand )
    local height = 59
    local _, sprite_height = wand_sprite_size( gui, wand )
	return height + math.max( sprite_height - 6, 0 ) * 2
end

return {
inventory_add_actions = inventory_add_actions,
inventory_remove_all_actions = inventory_remove_all_actions,
sort_actions = sort_actions,
wand_get_inventory_slot_height = wand_get_inventory_slot_height,
wand_sprite_size = wand_sprite_size,
entity_get_inventory_quick = entity_get_inventory_quick,
entity_get_wands = entity_get_wands,
entity_get_active_wand = entity_get_active_wand,
entity_force_refresh_inventory2 = entity_force_refresh_inventory2,
player_get_filled_wand_slots = player_get_filled_wand_slots,
can_player_edit_wands = can_player_edit_wands,
player_get_inventory2 = player_get_inventory2,
player_get_inventory_quick = player_get_inventory_quick,
player_get_inventory_full = player_get_inventory_full,
player_get_all_wands = player_get_all_wands,
player_get_active_wand = player_get_active_wand,
player_get_all_actions = player_get_all_actions,
wand_get_all_actions = wand_get_all_actions,
wand_move_actions_to_inventory = wand_move_actions_to_inventory,
wand_move_inventory_to_wand = wand_move_inventory_to_wand,
wand_move_actions_to = wand_move_actions_to,
wand_move_actions_to_wand = wand_move_actions_to_wand,
wand_swap_actions = wand_swap_actions,
wand_push_actions = wand_push_actions,
wand_sort_actions = wand_sort_actions,
inventory_sort_actions = inventory_sort_actions,
wand_explode_random_actions = wand_explode_random_actions,
inventory_explode_random_actions = inventory_explode_random_actions,
}
