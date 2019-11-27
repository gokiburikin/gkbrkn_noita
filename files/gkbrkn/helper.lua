dofile_once("data/scripts/gun/procedural/gun_action_utils.lua");

function ShootProjectile( who_shot, entity_file, x, y, vx, vy, send_message )
    local entity = EntityLoad( entity_file, x, y );
    local genome = EntityGetFirstComponent( who_shot, "GenomeDataComponent" );
    local herd_id = ComponentGetMetaCustom( genome, "herd_id" );
    if send_message == nil then send_message = true end

	GameShootProjectile( who_shot, x, y, x+vx, y+vy, entity, send_message );

    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    ComponentSetValue( projectile, "mWhoShot", who_shot );
    ComponentSetMetacustom( projectile, "mShooterHerdId", herd_id );

    local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
    if velocity ~= nil then
	    ComponentSetValueVector2( velocity, "mVelocity", vx, vy )
    end

	return entity;
end

function WandGetActiveOrRandom( entity )
    local chosen_wand = nil;
    local wands = {};
    local children = EntityGetAllChildren( entity );
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            wands = EntityGetChildrenWithTag( child, "wand" );
            break;
        end
    end
    if #wands > 0 then
        local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" );
        local active_item = tonumber( ComponentGetValue( inventory2, "mActiveItem" ) );
        for _,wand in pairs( wands ) do
            if wand == active_item then
                chosen_wand = wand;
                break;
            end
        end
        if chosen_wand == nil then
            chosen_wand =  random_from_array( wands );
        end
        return chosen_wand;
    end
end

function benchmark( callback, iterations )
    if iterations == nil then
        iterations = 1;
    end
    local t = GameGetRealWorldTimeSinceStarted();
    for i=1,iterations do
        callback();
    end
    return GameGetRealWorldTimeSinceStarted() - t;
end

function map(func, array)
    local new_array = {};
    for i,v in ipairs(array) do
      new_array[i] = func(v);
    end
    return new_array;
  end

function DoFileEnvironment( filepath, environment )
    if environment == nil then environment = {} end
    local f = loadfile( filepath );
    local set_f = setfenv( f, setmetatable( environment, { __index = _G } ) );
    local status,result = pcall( set_f );
    if status == false then print_error( "do file environment for "..filepath..": "..result ); end
    return environment;
end

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

function LogCompact( ... )
    local length = 0;
    local log = {};
    for k,v in pairs( {...} ) do
        table.insert( log, v );
        length = length + #v;
        if length > 80 then
            table.insert(log,"\n");
            length = 0;
        end
    end
    Log( unpack( log ) );
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

function LogTableCompact( t, show_keys )
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

function WandGetAbilityComponent( wand )
    local components = EntityGetAllComponents( wand );
    for i, component in ipairs( components ) do
        for key, value in pairs( ComponentGetMembers( component ) ) do
            if key == "mItemRecoil" then
                return component;
            end
        end
    end
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

function GetEntityCustomVariable( entity_id, variable_storage_tag, key, default )
   local variable_storage = EntityGetFirstComponent( entity_id, "VariableStorage", variable_storage_tag );
   if variable_storage ~= nil then
        return ComponentGetValue( variable_storage, "value_string" );
   end
   return default;
end

function SetEntityCustomVariable( entity_id, variable_storage_tag, variable_name, value )
    local variable_storage = EntityGetFirstComponent( entity_id, "VariableStorage", variable_storage_tag );
    if variable_storage == nil then
        EntityAddComponent( entity_id, "VariableStorage", {
            _tags=tag,
            name=variable_name,
            value_string=tostring(value),
        });
    else
        ComponentSetValue( variable_storage, "value_string", tostring(value) );
    end
end

function WandExplodeRandomAction( wand )
    local x, y = EntityGetTransform( wand );
    local actions = {};
    local children = EntityGetAllChildren( wand ) or {};
    for i,v in ipairs( children ) do
        local all_comps = EntityGetAllComponents( v );
        local action_id = nil;
        local permanent = false;
        for i, c in ipairs( all_comps ) do
            if ComponentGetValue( c, "action_id") ~= "" then
                action_id = ComponentGetValue( c, "action_id");
            end
            if ComponentGetValue( c, "permanently_attached") ~= "" then
                permanent = ComponentGetValue( c, "permanently_attached" );
            end
        end
        if action_id ~= nil and permanent == "0" then
            table.insert( actions, {action_id=action_id, permanent=permanent, entity=v} );
        end
    end
    if #actions > 0 then
        local action_to_remove = actions[ math.ceil( math.random() * #actions ) ];
        local card = CreateItemActionEntity( action_to_remove.action_id, x, y );
        ComponentSetValueVector2( EntityGetFirstComponent( card, "VelocityComponent" ), "mVelocity", Random( -150, 150 ), Random( -250, -100 ) );
        EntityRemoveFromParent( action_to_remove.entity );
    end
    --for _,action_data in pairs( actions ) do
    --    local card = CreateItemActionEntity( action_data.action_id, x, y );
    --    ComponentSetValueVector2( EntityGetFirstComponent( card, "VelocityComponent" ), "mVelocity", Random( -100, 100 ), Random( -300, -100 ) );
    --end
end

function IterateWandActions( wand, callback )
    local children = EntityGetAllChildren( wand );
    for i,v in ipairs( children ) do
        local all_comps = EntityGetAllComponents( v );
        local action_id = nil;
        local permanent = false;
        for i, c in ipairs( all_comps ) do
            if ComponentGetValue( c, "action_id") ~= nil then
                callback( c );
            end
        end
        if action_id ~= nil then
            table.insert( actions, {action_id=action_id, permanent=permanent} );
        end
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
        local base_hotspot = FindFirstComponentThroughTags( base_wand, "transform_with_scale" );
        local copy_hotspot = EntityGetFirstComponent( copy_wand, "HotspotComponent", "shoot_pos" );
        CopyComponentMembers( base_hotspot, copy_hotspot );
        local base_hotspot_x, base_hotspot_y = ComponentGetValueVector2( base_hotspot, "offset" );
        ComponentSetValueVector2( copy_hotspot, "offset", base_hotspot_x, base_hotspot_y );
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

function TryAdjustDamageMultipliers( entity, resistances )
    local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
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

function TryAdjustMaxHealth( entity, callback )
    local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
    if damage_models ~= nil then
        for index,damage_model in pairs( damage_models ) do
            local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
            local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
            local new_max = callback( max_hp, current_hp );
            local regained = new_max - current_hp;
            ComponentSetValue( damage_model, "max_hp", tostring( new_max ) );
            ComponentSetValue( damage_model, "hp", tostring( current_hp + regained ) );
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

function CreateWand( x, y, ... )
    local wand = EntityLoad("files/gkbrkn/placeholder_wand.xml", x, y);
    for _,action in pairs( {...} ) do
        AddGunAction( wand, action );
    end
    return wand;
end

function adjust_material_damage( damage_model, callback )
    local materials_that_damage = ComponentGetValue( damage_model, "materials_that_damage" );
    local materials = {};
    for word in string.gmatch( materials_that_damage, '([^,]+)' ) do
        table.insert( materials, word );
    end

    local materials_how_much_damage = ComponentGetValue( damage_model, "materials_how_much_damage" );
    local materials_damage = {};
    for word in string.gmatch( materials_how_much_damage, '([^,]+)' ) do
        table.insert( materials_damage, tonumber(word) );
    end

    local new_materials, new_materials_damage = callback( materials, materials_damage );

    local new_materials_that_damage = "";
    for _,word in pairs( new_materials ) do
        new_materials_that_damage = new_materials_that_damage..word..",";
    end
    ComponentSetValue( damage_model, "materials_that_damage", new_materials_that_damage );

    local new_materials_how_much_damage = "";
    for _,word in pairs( new_materials_damage ) do
        new_materials_how_much_damage = new_materials_how_much_damage..tostring(word)..",";
    end
    ComponentSetValue( damage_model, "materials_how_much_damage", new_materials_how_much_damage );
end