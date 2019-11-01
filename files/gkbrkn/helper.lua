dofile("data/scripts/gun/procedural/gun_action_utils.lua");

function PackString( separator, ... )
	local string = {};
	for n=1,select( '#' , ... ) do
		local j = select( n, ... );
		local text = nil;
		if type(j) == "boolean" then
			if j then
			   text = "true";
			else
				text = "false";
			end
        else
            if type(j) == "string" and #j == 0 then
                text = "\"\"";
            else
                text = tostring( j ) or "nil";
            end
        end
		string[n] = text;
	end
	return table.concat( string, separator or "" );
end

function Log( ... )
    print_error( PackString(" ", ... ) );
end

local screen_log_queue = {};
local screen_log_max = 20;
local screen_log_interval = 0.333;
function LogScreen( ... )
    table.insert( screen_log_queue, PackString( " ", ... ) );
end

function RenderLog( gui )
    local start_index = math.floor(GameGetRealWorldTimeSinceStarted()/screen_log_interval);
    for i=1,screen_log_max do
        local adjusted_index = (i + start_index) % #screen_log_queue;
        if screen_log_queue[adjusted_index] ~= nil then
            GuiText( gui, 0,0, tostring(screen_log_queue[adjusted_index]) );
        end
        GuiLayoutAddVerticalSpacing( gui );
    end
    screen_log_queue = {};
end

function LogTable( t )
    if type(t) == "table" then
        for k,v in pairs ( t ) do
            Log( k,v );
        end
    else
        Log( t );
    end
end

function LogTableCompact( t )
    if type(t) == "table" then
        local length = 0;
        local log = {};
        for k,v in pairs( t ) do
            local join = PackString( "=", k, v );
            table.insert( log, join );
            length = length + #join;
            if length > 80 then
                table.insert(log,"\n");
                length = 0;
            end
        end
        Log( unpack( log ) );
    else
        Log( t );
    end
end

function ExploreGlobals()
    local g = {};
    for k,v in pairs(_G) do
        if type(v) ~= "function" then
            g[k] = v;
        end
    end
    LogTableCompact(g);
end

function ListEntityComponents( entity )
    local components = EntityGetAllComponents( entity );
    for i, component_id in ipairs( components ) do
        Log( i, component_id );
    end
end

function ListEntityComponentObjects( entity, component_type_name, component_object_name )
    local component = EntityGetFirstComponent( entity, component_type_name );
    local members = ComponentObjectGetMembers( component, component_object_name );
    for member in pairs(members) do
        Log( member, ComponentObjectGetValue( component, component_object_name, member ) );
    end
end

function CopyEntityComponentList( component_type_name, base_entity, copy_entity, keys )
    local base_component = EntityGetFirstComponent( base_entity, component_type_name );
    local copy_component = EntityGetFirstComponent( copy_entity, component_type_name );
    if base_component ~= nil and copy_component ~= nil then
        for index,key in pairs( keys ) do
            ComponentSetValue( copy_component, key, ComponentGetValue( base_component, key ) );
        end
    end
end

function CopyComponentMembers( base_component, copy_component )
    if base_component ~= nil and copy_component ~= nil then
        for key,value in pairs( ComponentGetMembers( base_component ) ) do
            ComponentSetValue( copy_component, key, value );
        end
    end
end

function CopyListedComponentMembers( base_component, copy_component, ... )
    if base_component ~= nil and copy_component ~= nil then
        for index,key in pairs( {...} ) do
            ComponentSetValue( copy_component, key, ComponentGetValue( base_component, key ) );
        end
    end
end

function CopyComponentObjectMembers( base_component, copy_component, component_object_name )
    if base_component ~= nil and copy_component ~= nil then
        for object_key in pairs( ComponentObjectGetMembers( base_component, component_object_name ) ) do
            ComponentObjectSetValue( copy_component, component_object_name, object_key, ComponentObjectGetValue( base_component, component_object_name, object_key ) );
        end
    end
end

function CopyEntityComponent( component_type_name, base_entity, copy_entity )
    local base_component = EntityGetFirstComponent( base_entity, component_type_name );
    local copy_component = EntityGetFirstComponent( copy_entity, component_type_name );
    CopyComponentMembers( base_component, copy_component );
end

function CopyEntityComponentObject( component_type_name, component_object_name, base_entity, copy_entity )
    local base_component = EntityGetFirstComponent( base_entity, component_type_name );
    local copy_component = EntityGetFirstComponent( copy_entity, component_type_name );
    CopyComponentObjectMembers( base_component, copy_component );
end

function EnableWandAbilityComponent(wand_id)
    local components = EntityGetAllComponents( wand_id );
    for i, component_id in ipairs( components ) do
        for k, v2 in pairs( ComponentGetMembers( component_id ) ) do
            if k == "mItemRecoil" then
                EntitySetComponentIsEnabled( wand_id, component_id, true );
                break;
            end
        end
    end
end

function EntityComponentGetValue( entity_id, component_type_name, component_key, default_value )
    local component = EntityGetFirstComponent( entity_id, component_type_name );
    if component ~= nil then
        return ComponentGetValue( component, component_key );
    end
    return default_value;
end

function EntityGetNamedChild( entity_id, name )
    local children = EntityGetAllChildren( entity_id );
	if children ~= nil then
		for index,child_entity in pairs( children ) do
			local child_entity_name = EntityGetName( child_entity );
			
			if child_entity_name == name then
				return child_entity;
            end
        end
    end
end

function EntityGetChildrenWithTag( entity_id, tag )
    local valid_children = {};
    local children = EntityGetAllChildren( entity_id );
    for index, child in pairs( children ) do
        if EntityHasTag( child, tag ) then
            table.insert( valid_children, child );
        end
    end
    return valid_children;
end

function FindFirstComponentThroughTags( entity_id, ... )
    return FindComponentThroughTags( entity_id, ...)[1];
end

function FindComponentThroughTags( entity_id, ... )
    local matching_components = EntityGetAllComponents( entity_id );
    local valid_components = {};
    for _,tag in pairs( {...} ) do
        for index,component in pairs( matching_components ) do
            if ComponentGetValue( component, tag ) ~= "" and ComponentGetValue( component, tag ) ~= nil then
                table.insert( valid_components, component );
            end
        end
        matching_components = valid_components;
        valid_components = {};
    end
    return matching_components;
end

function ComponentGetValueDefault( component_id, key, default )
    local value = ComponentGetValue( component_id, key );
    if value ~= nil and #value > 0 then
        return value;
    end
    return default;
end

function GetEntityCustomVariable( entity_id, tag, key, default )
   local variable_storage = EntityGetFirstComponent( entity_id, "VariableStorage", tag );
   if variable_storage ~= nil then
        return ComponentGetValue( variable_storage, "value_string" );
   end
   return default;
end

function SetEntityCustomVariable( entity_id, tag, key, value )
    local variable_storage = EntityGetFirstComponent( entity_id, "VariableStorage", tag );
    if variable_storage == nil then
        EntityAddComponent( entity_id, "VariableStorage", {
            _tags=tag,
            name=key,
            value_string=tostring(value),
        });
    else
        ComponentSetValue( variable_storage, "value_string", tostring(value) );
    end
end

function GetWandActions( wand )
    local actions = {};
    local children = EntityGetAllChildren( wand );
    for i,v in ipairs( children ) do
        local all_comps = EntityGetAllComponents( v );
        local action_id = nil;
        local permanent = false;
        for i, c in ipairs( all_comps ) do
            action_id = ComponentGetValueDefault( c, "action_id", action_id );
            permanent = ComponentGetValueDefault( c, "permanently_attached", permanent );
        end
        if action_id ~= nil then
            table.insert( actions, {action_id=action_id, permanent=permanent} );
        end
    end
    return actions;
end

function CopyWandActions( base_wand, copy_wand )
    local actions = GetWandActions( base_wand );
    for index,action_data in pairs( actions ) do
        if action_data.permanent ~= "1" then
            AddGunAction( copy_wand, action_data.action_id );
        else
            AddGunActionPermanent( copy_wand, action_data.action_id );
        end
    end
end

function CopyWand( base_wand, copy_wand, copy_sprite, copy_actions )
    local base_ability_component = FindFirstComponentThroughTags( base_wand, "charge_wait_frames" );
    local copy_ability_component = FindFirstComponentThroughTags( copy_wand, "charge_wait_frames" );
    CopyComponentMembers( base_ability_component, copy_ability_component );
    CopyComponentObjectMembers( base_ability_component, copy_ability_component, "gun_config" );
    CopyComponentObjectMembers( base_ability_component, copy_ability_component, "gunaction_config" );
    if copy_sprite ~= false then
        CopyListedComponentMembers( FindFirstComponentThroughTags( base_wand, "z_index", "image_file" ), FindFirstComponentThroughTags( copy_wand, "z_index", "image_file" ), "image_file","offset_x","offset_y");
    end
    if copy_actions ~= false then
        CopyWandActions( base_wand, copy_wand );
    end
end

function FindEntityInInventory( inventory, entity )
    local inventory_items = EntityGetAllChildren( inventory );
		
    -- remove default items
    if inventory_items ~= nil then
        for i,item_entity in ipairs( inventory_items ) do
            Log( i, item_entity );
        end
        --    GameKillInventoryItem( player_entity, item_entity )
        --end
    end
end

function TryGivePerk( player_entity_id, ... )
    for index,perk_id in pairs( {...} ) do
        local perk_entity = perk_spawn( x, y, perk_id );
        if perk_entity ~= nil then
            perk_pickup( perk_entity, player_entity_id, EntityGetName( perk_entity ), false, false );
        end
    end
end

function TryAdjustDamageMultipliers( entity_id, resistances )
    local damage_models = EntityGetComponent( entity_id, "DamageModelComponent" );
    if damage_models ~= nil then
        for index,damage_model in pairs( damage_models ) do
            for damage_type,multiplier in pairs( resistances ) do
                local resistance = tonumber(ComponentObjectGetValue( damage_model, "damage_multipliers", damage_type ));
                resistance = resistance * multiplier;
                ComponentObjectSetValue( damage_model, "damage_multipliers", damage_type, tostring(resistance) );
            end
        end
    end
end

function GetInventoryQuickActiveItem( entity )
    if entity ~= nil then
        local component = EntityGetFirstComponent( entity, "Inventory2Component" );
        if component ~= nil then
            return ComponentGetValue( component, "mActiveItem" );
        end
    end
end