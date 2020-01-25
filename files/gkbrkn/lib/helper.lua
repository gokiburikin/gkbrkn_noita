dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

function load_dynamic_badge ( key, append_bool_table, localization_table )
    local badge_image = "ui_icon_image_"..key;
    local badge_name = "ui_icon_name_"..key;
    local badge_description = "ui_icon_description_"..key;
    if append_bool_table ~= nil then
        for _,pair in ipairs(append_bool_table) do
            for append,bool in pairs(pair) do
                if bool then
                    badge_image = badge_image .. append;
                    badge_name = badge_name .. append;
                    badge_description = badge_description .. append;
                end
            end
        end
    end
    local badge = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/badges/badge.xml" );
    if badge ~= nil then
        local ui_icon = EntityGetFirstComponent( badge, "UIIconComponent" );
        if ui_icon ~= nil then
            ComponentSetValue( ui_icon, "icon_sprite_file", localization_table[badge_image] );
            ComponentSetValue( ui_icon, "name", localization_table[badge_name] );
            ComponentSetValue( ui_icon, "description", localization_table[badge_description] );
        end
    end
    return badge;
end

function get_update_time( )
    return tonumber( GlobalsGetValue( "gkbrkn_update_time" ) ) or 0;
end

function reset_update_time( )
    GlobalsSetValue( "gkbrkn_update_time", 0 );
end

function add_update_time( amount )
    GlobalsSetValue( "gkbrkn_update_time", get_update_time() + amount );
end

function generate_perk_entry( perk_id, key, usable_by_enemies, pickup_function )
    return {
        id = perk_id,
        ui_name = gkbrkn_localization["perk_name_"..key] or ("missing name "..key),
        ui_description = gkbrkn_localization["perk_description_"..key] or ("missing description "..key),
        ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/"..key.."/icon_ui.png",
        perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/"..key.."/icon_ig.png",
        usable_by_enemies = usable_by_enemies,
        func = pickup_function,
    };
end

function generate_action_entry( action_id, key, action_type, spawn_level, spawn_probability, price, mana, max_uses, custom_xml, action_function )
    return {
        id = action_id,
        name 		        = gkbrkn_localization["action_name_"..key] or ("missing name "..key),
        description         = gkbrkn_localization["action_description_"..key] or ( "missing description "..key),
        sprite 		        = "mods/gkbrkn_noita/files/gkbrkn/actions/"..key.."/icon.png",
        sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/"..key.."/icon.png",
        type 		        = action_type,
        spawn_level         = spawn_level,
        spawn_probability   = spawn_probability,
        price               = price,
        mana                = mana,
        max_uses            = max_uses,
        custom_xml_file     = custom_xml,
        action = action_function
    };
end

function spawn_gold_nuggets( gold_value, x, y )
    local sizes = { 10000, 1000, 200, 50, 10 };
    for _,size in pairs(sizes) do
        while gold_value >= size do
            gold_value = gold_value - size;
            EntityLoad( "data/entities/items/pickup/goldnugget_"..size..".xml", x, y );
        end
    end
end

function does_entity_drop_gold( entity )
    local drops_gold = false;
    for _,component in pairs( EntityGetComponent( entity, "LuaComponent" ) or {} ) do
        if ComponentGetValue( component, "script_death" ) == "data/scripts/items/drop_money.lua" then
            drops_gold = true;
            break;
        end
    end
    if drops_gold == true then
        if EntityGetFirstComponent( entity, "VariableStorageComponent", "no_drop_gold" ) ~= nil then
            drops_gold = false;
        end
    end
    return drops_gold;
end

function script_wait_frames_fixed( entity_id, frames )
	local now = GameGetFrameNum();
	local last_execution = ComponentGetValueInt( GetUpdatedComponentID(), "mLastExecutionFrame" );

	if now - last_execution < frames then return true; end
	return false;
end

function set_lost_treasure( gold_nugget_entity )
    EntityAddComponent( gold_nugget_entity, "LuaComponent", {
        execute_every_n_frame = "-1",
        script_item_picked_up = "mods/gkbrkn_noita/files/gkbrkn/perks/lost_treasure/gold_pickup.lua",
    });
    local removal_lua = EntityAddComponent( gold_nugget_entity, "LuaComponent", {
        _tags="gkbrkn_lost_treasure",
        execute_on_removed="1",
        execute_every_n_frame="-1",
        script_source_file = "mods/gkbrkn_noita/files/gkbrkn/perks/lost_treasure/gold_removed.lua",
    });
end

function clear_lost_treasure( gold_nugget_entity )
    local lost_treasure_script = EntityGetFirstComponent( gold_nugget_entity, "LuaComponent", "gkbrkn_lost_treasure" );
    if lost_treasure_script ~= nil then
        EntityRemoveComponent( gold_nugget_entity, lost_treasure_script );
    end
end

function is_lost_treasure( gold_nugget_entity )
    return EntityGetFirstComponent( gold_nugget_entity, "LuaComponent", "gkbrkn_lost_treasure" ) ~= nil;
end


function is_gold_decay( gold_nugget_entity )
    return EntityGetFirstComponent( gold_nugget_entity, "LuaComponent", "gkbrkn_gold_decay" ) ~= nil;
end

function set_gold_decay( gold_nugget_entity )
    EntityAddComponent( gold_nugget_entity, "LuaComponent", {
        execute_every_n_frame = "-1",
        remove_after_executed = "1",
        script_item_picked_up = "mods/gkbrkn_noita/files/gkbrkn/misc/gold_decay/gold_pickup.lua",
    });
    EntityAddComponent( gold_nugget_entity, "LuaComponent", {
        _tags="gkbrkn_gold_decay",
        execute_on_removed="1",
        execute_every_n_frame="-1",
        script_source_file = "mods/gkbrkn_noita/files/gkbrkn/misc/gold_decay/gold_removed.lua",
    });
end

function clear_gold_decay( gold_nugget_entity )
    local script = EntityGetFirstComponent( gold_nugget_entity, "LuaComponent", "gkbrkn_gold_decay" );
    if script ~= nil then
        EntityRemoveComponent( gold_nugget_entity, script );
    end
end

function limit_to_every_n_frames( entity, variable_name, n, callback )
    local now = GameGetFrameNum();
	if now - EntityGetVariableNumber( entity, variable_name, 0 ) >= n then
        EntitySetVariableNumber( entity, variable_name, now );
        callback();
    end
end

function trend_towards_range( value, divisor, min, max )
    return min + (max - min) * ( value / ( value + divisor ) );
end

function get_projectile_root_shooter( entity )
    local root_shooter = entity;
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        local shooter = tonumber( ComponentGetValue( projectile, "mWhoShot" ) );
        while shooter ~= nil and shooter ~= 0 do
            root_shooter = shooter;
            local shooter_projectile = EntityGetFirstComponent( shooter, "ProjectileComponent" );
            if shooter_projectile == nil then
                break;
            end
            shooter = tonumber( ComponentGetValue( shooter_projectile, "mWhoShot" ) );
        end
    end
    return root_shooter;
end

function make_projectile_not_damage_shooter( entity, force_shooter )
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        ComponentSetValue( projectile, "explosion_dont_damage_shooter", "1" );
        ComponentSetValue( projectile, "friendly_fire", "0" );
        local shooter = force_shooter or get_projectile_root_shooter( entity );
        if shooter ~= nil and shooter ~= 0 then
            ComponentObjectSetValue( projectile, "config_explosion", "dont_damage_this", tostring( shooter ) );
            EntityIterateComponentsByType( entity, "AreaDamageComponent", function(component)
                if EntityHasTag( shooter, "player_unit" ) then
                    ComponentSetValue( component, "entities_with_tag", "enemy" );
                else
                    ComponentSetValue( component, "entities_with_tag", "player_unit" );
                end
            end );

            local lightning = EntityGetFirstComponent( entity, "LightningComponent" );
            if lightning ~= nil then
                ComponentObjectSetValue( lightning, "config_explosion", "dont_damage_this", tostring( shooter ) );
            end
        end
    end
end

-- TODO this doesn't handle all damage components and doesn't handle multiple components of the same type
function adjust_entity_damage( entity, projectile_damage_callback, typed_damage_callback, explosive_damage_callback, lightning_damage_callback, area_damage_callback )
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    local lightning = EntityGetFirstComponent( entity, "LightningComponent" );

    if projectile ~= nil then
        if projectile_damage_callback ~= nil then
            local current_damage = tonumber( ComponentGetValue( projectile, "damage" ) );
            local new_damage = projectile_damage_callback( current_damage );
            if current_damage ~= new_damage then
                ComponentSetValue( projectile, "damage", tostring( new_damage ) );
            end
            if typed_damage_callback ~= nil then
                local damage_by_types = ComponentObjectGetMembers( projectile, "damage_by_type" ) or {};
                local damage_by_types_fixed = {};
                for type,_ in pairs( damage_by_types ) do
                    damage_by_types_fixed[type] = tonumber( ComponentObjectGetValue( projectile, "damage_by_type", type ) );
                end
                local damage_by_types_adjusted = typed_damage_callback( damage_by_types_fixed );
                for type,amount in pairs( damage_by_types_adjusted ) do
                    if amount ~= nil then
                        ComponentObjectSetValue( projectile, "damage_by_type", type, tonumber( amount ) or damage_by_types_fixed[type] or 0 );
                    end
                end
            end
            if explosive_damage_callback ~= nil then
                local current_damage = ComponentObjectGetValue( projectile, "config_explosion", "damage" );
                local new_damage = explosive_damage_callback( current_damage );
                if current_damage ~= new_damage then
                    ComponentObjectSetValue( projectile, "config_explosion", "damage", tostring( new_damage ) );
                end
            end
        end
        if lightning_damage_callback ~= nil then
            local lightning = EntityGetFirstComponent( entity, "LightningComponent" );
            if lightning ~= nil then
                local current_damage = tonumber( ComponentObjectGetValue( lightning, "config_explosion", "damage" ) );
                local new_damage = lightning_damage_callback( current_damage );
                if current_damage ~= new_damage then
                    ComponentObjectSetValue( lightning, "config_explosion", "damage", tostring( new_damage ) );
                end
            end
        end
        if area_damage_callback ~= nil then
            local area_damage = EntityGetFirstComponent( entity, "AreaDamageComponent" );
            if area_damage ~= nil then
                local current_damage = tonumber( ComponentGetValue( area_damage, "damage_per_frame" ) );
                local new_damage = area_damage_callback( current_damage );
                if current_damage ~= new_damage then
                    ComponentSetValue( area_damage, "damage_per_frame", tostring( new_damage ) );
                end
            end
        end
    end
end

function adjust_all_entity_damage( entity, callback )
    adjust_entity_damage( entity,
        function( current_damage ) return callback( current_damage ); end,
        function( current_damages )
            for type,current_damage in pairs( current_damages ) do
                if current_damage ~= 0 then
                    current_damages[type] = callback( current_damage );
                end
            end
            return current_damages;
        end,
        function( current_damage ) return callback( current_damage ); end,
        function( current_damage ) return callback( current_damage ); end,
        function( current_damage ) return callback( current_damage ); end
    );
end

function add_entity_mini_health_bar( entity )
    EntityAddComponent( entity, "HealthBarComponent" );
    EntityAddComponent( entity, "SpriteComponent", { 
        _tags="health_bar,ui,no_hitbox",
        alpha="1",
        has_special_scale="1",
        image_file="mods/gkbrkn_noita/files/gkbrkn/misc/health_bar.png",
        is_text_sprite="0",
        next_rect_animation="",
        offset_x="11",
        offset_y="-8",
        rect_animation="",
        special_scale_x="0.2",
        special_scale_y="0.6",
        ui_is_parent="0",
        update_transform="1",
        update_transform_rotation="0",
        visible="1",
        z_index="-9000",
    } );
end

function entity_adjust_health( entity, callback )
    local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
    if damage_models ~= nil then
        for _,damage_model in pairs( damage_models ) do
            local hp = ComponentGetValue( damage_model, "hp" );
            local max_hp = ComponentGetValue( damage_model, "max_hp" );
            local new_max_hp, new_hp = callback( max_hp, hp );
            ComponentSetValue( damage_model, "hp", new_hp or hp );
            ComponentSetValue( damage_model, "max_hp", new_max_hp or max_hp );
        end
    end
end