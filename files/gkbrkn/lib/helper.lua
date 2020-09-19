local MISC = dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/options.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
--[[
#define ENUM_DAMAGE_TYPES(_)                  
    _(DAMAGE_MELEE,                  1 << 0 ) 
    _(DAMAGE_PROJECTILE,             1 << 1 ) 
    _(DAMAGE_EXPLOSION,              1 << 2 ) 
    _(DAMAGE_BITE,                   1 << 3 ) 
    _(DAMAGE_FIRE,                   1 << 4 ) 
    _(DAMAGE_MATERIAL,               1 << 5 ) 
    _(DAMAGE_FALL,                   1 << 6 ) 
    _(DAMAGE_ELECTRICITY,            1 << 7 ) 
    _(DAMAGE_DROWNING,               1 << 8 ) 
    _(DAMAGE_PHYSICS_BODY_DAMAGED,   1 << 9 ) 
    _(DAMAGE_DRILL,                  1 << 10 )
    _(DAMAGE_SLICE,                  1 << 11 )
    _(DAMAGE_ICE,                    1 << 12 )
    _(DAMAGE_HEALING,                1 << 13 )
    _(DAMAGE_PHYSICS_HIT,            1 << 14 )
    _(DAMAGE_RADIOACTIVE,            1 << 15 )
    _(DAMAGE_POISON,                 1 << 16 )
    _(DAMAGE_MATERIAL_WITH_FLASH,    1 << 17 )
    _(DAMAGE_OVEREATING,             1 << 18 )

#define ENUM_RAGDOLL_FX(_)
    _(NONE,                     0)
    _(NORMAL,                   1)
    _(BLOOD_EXPLOSION,          2)
    _(BLOOD_SPRAY,              3)
    _(FROZEN,                   4)
    _(CONVERT_TO_MATERIAL,      5)
    _(CUSTOM_RAGDOLL_ENTITY,    6)
    _(DISINTEGRATED,            7)
    _(NO_RAGDOLL_FILE,          8)
    _(PLAYER_RAGDOLL_CAMERA,    9)
]]

function load_dynamic_badge ( key, append_bool_table )
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
            ComponentSetValue2( ui_icon, "icon_sprite_file", GameTextGetTranslatedOrNot("$"..badge_image) );
            ComponentSetValue2( ui_icon, "name", GameTextGetTranslatedOrNot("$"..badge_name) );
            ComponentSetValue2( ui_icon, "description", GameTextGetTranslatedOrNot("$"..badge_description) );
        end
    end
    return badge;
end

function get_update_time( ) return tonumber( GlobalsGetValue( "gkbrkn_update_time" ) ) or 0; end
function reset_update_time( ) GlobalsSetValue( "gkbrkn_update_time", 0 ); end
function get_frame_time( ) return tonumber( GlobalsGetValue( "gkbrkn_frame_time" ) ) or 0; end
function reset_frame_time( ) GlobalsSetValue( "gkbrkn_frame_time", 0 ); end
function add_update_time( amount ) GlobalsSetValue( "gkbrkn_update_time", get_update_time() + amount ); end
function add_frame_time( amount ) GlobalsSetValue( "gkbrkn_frame_time", get_frame_time() + amount ); end

function generate_perk_entry( perk_id, key, usable_by_enemies, pickup_function, deprecated, author, stackable )
    if stackable == nil then
        stackable = true;
    end
    return {
        id                  = perk_id,
        ui_name             = "$perk_name_gkbrkn_"..key,
        ui_description      = "$perk_desc_gkbrkn_"..key,
        ui_icon             = "mods/gkbrkn_noita/files/gkbrkn/perks/"..key.."/icon_ui.png",
        perk_icon           = "mods/gkbrkn_noita/files/gkbrkn/perks/"..key.."/icon_ig.png",
        usable_by_enemies   = usable_by_enemies,
        func                = pickup_function,
        deprecated          = deprecated,
        author              = "$ui_author_name_goki_dev" or author,
        local_content       = true,
        stackable           = stackable
    };
end

function generate_action_entry( action_id, key, action_type, spawn_level, spawn_probability, price, mana, max_uses, custom_xml, action_function, deprecated, icon_path, author )
    return {
        id = action_id,
        name 		        = "$action_name_gkbrkn_"..key,
        description         = "$action_desc_gkbrkn_"..key,
        sprite 		        = icon_path or "mods/gkbrkn_noita/files/gkbrkn/actions/"..key.."/icon.png",
        sprite_unidentified = icon_path or "mods/gkbrkn_noita/files/gkbrkn/actions/"..key.."/icon.png",
        type 		        = action_type,
        spawn_level         = spawn_level,
        spawn_probability   = spawn_probability,
        price               = price,
        mana                = mana,
        max_uses            = max_uses,
        custom_xml_file     = custom_xml,
        action              = action_function,
        deprecated          = deprecated,
        author              = "$ui_author_name_goki_dev" or author,
        local_content       = true
    };
end

function spawn_gold_nuggets( gold_value, x, y, blood_money )
    local sizes = { 10000, 1000, 200, 50, 10 };
    local world_entity_id = GameGetWorldStateEntity();
    local world_state = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" );
    local is_gold_forever = false;
    if world_state ~= nil then
        is_gold_forever = ComponentGetValue2( world_state, "perk_gold_is_forever" );
    end
    for _,size in pairs(sizes) do
        while gold_value >= size do
            gold_value = gold_value - size;
            local gold_nugget = EntityLoad( "data/entities/items/pickup/goldnugget_"..size..".xml", x, y );
            if is_gold_forever then
                EntityRemoveComponent( gold_nugget, EntityGetFirstComponent( gold_nugget, "LifetimeComponent" ) );
            end
        end
    end
end

function does_entity_drop_gold( entity )
    local drops_gold = false;
    for _,component in pairs( EntityGetComponent( entity, "LuaComponent" ) or {} ) do
        if ComponentGetValue2( component, "script_death" ) == "data/scripts/items/drop_money.lua" then
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
        local shooter = ComponentGetValue2( projectile, "mWhoShot" );
        while shooter ~= nil and shooter ~= 0 do
            root_shooter = shooter;
            local shooter_projectile = EntityGetFirstComponent( shooter, "ProjectileComponent" );
            if shooter_projectile == nil then
                break;
            end
            shooter = ComponentGetValue2( shooter_projectile, "mWhoShot" );
        end
    end
    return root_shooter;
end

function make_projectile_not_damage_shooter( entity, force_shooter )
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        ComponentSetValue2( projectile, "explosion_dont_damage_shooter", true );
        ComponentSetValue2( projectile, "friendly_fire", false );
        local shooter = force_shooter or get_projectile_root_shooter( entity );
        if shooter ~= nil and shooter ~= 0 then
            ComponentObjectSetValue( projectile, "config_explosion", "dont_damage_this", tostring( shooter ) );
            EntityIterateComponentsByType( entity, "AreaDamageComponent", function(component)
                if EntityHasTag( shooter, "player_unit" ) then
                    ComponentSetValue2( component, "entities_with_tag", "enemy" );
                else
                    ComponentSetValue2( component, "entities_with_tag", "player_unit" );
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
            local current_damage = ComponentGetValue2( projectile, "damage" );
            local new_damage = projectile_damage_callback( current_damage );
            if current_damage ~= new_damage then
                ComponentSetValue2( projectile, "damage", new_damage );
            end
            if typed_damage_callback ~= nil then
                local damage_by_types = ComponentObjectGetMembers( projectile, "damage_by_type" ) or {};
                local damage_by_types_fixed = {};
                for type,_ in pairs( damage_by_types ) do
                    damage_by_types_fixed[type] = ComponentObjectGetValue2( projectile, "damage_by_type", type );
                end
                local damage_by_types_adjusted = typed_damage_callback( damage_by_types_fixed );
                for type,amount in pairs( damage_by_types_adjusted ) do
                    if amount ~= nil then
                        ComponentObjectSetValue2( projectile, "damage_by_type", type, amount or damage_by_types_fixed[type] or 0 );
                    end
                end
            end
            if explosive_damage_callback ~= nil then
                local current_damage = ComponentObjectGetValue2( projectile, "config_explosion", "damage" );
                local new_damage = explosive_damage_callback( current_damage );
                if current_damage ~= new_damage then
                    ComponentObjectSetValue2( projectile, "config_explosion", "damage", new_damage );
                end
            end
        end
        if lightning_damage_callback ~= nil then
            local lightning = EntityGetFirstComponent( entity, "LightningComponent" );
            if lightning ~= nil then
                local current_damage = tonumber( ComponentObjectGetValue2( lightning, "config_explosion", "damage" ) );
                local new_damage = lightning_damage_callback( current_damage );
                if current_damage ~= new_damage then
                    ComponentObjectSetValue2( lightning, "config_explosion", "damage", new_damage );
                end
            end
        end
        if area_damage_callback ~= nil then
            local area_damage = EntityGetFirstComponent( entity, "AreaDamageComponent" );
            if area_damage ~= nil then
                local current_damage = ComponentGetValue2( area_damage, "damage_per_frame" );
                local new_damage = area_damage_callback( current_damage );
                if current_damage ~= new_damage then
                    ComponentSetValue2( area_damage, "damage_per_frame", new_damage );
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
        never_ragdollify_on_death="1",
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
            local hp = ComponentGetValue2( damage_model, "hp" );
            local max_hp = ComponentGetValue2( damage_model, "max_hp" );
            local new_max_hp, new_hp = callback( max_hp, hp );
            ComponentSetValue2( damage_model, "hp", new_hp or hp );
            ComponentSetValue2( damage_model, "max_hp", new_max_hp or max_hp );
        end
    end
end

function entity_get_health_ratio( entity )
    local current_hp = 0;
    local current_max_hp = 0;
    local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
    for _,damage_model in pairs( damage_models ) do
        local hp = ComponentGetValue2( damage_model, "hp" );
        if hp > current_hp then
            current_hp = hp;
        end
        local max_hp = ComponentGetValue2( damage_model, "max_hp" );
        if max_hp > current_max_hp then
            current_max_hp = max_hp;
        end
    end
    local ratio = current_hp / current_max_hp;
    if ratio ~= ratio then
        return 0;
    end
    return ratio;
end

function entity_draw_health_bar( entity, frames )
    local health_ratio = entity_get_health_ratio( entity );
    if health_ratio < 1 then
        local x, y = EntityGetTransform( entity );
        local health_bar_image = 11 - math.ceil( health_ratio * 10 );
        local sprite = "mods/gkbrkn_noita/files/gkbrkn/misc/health_bars/health_bar"..health_bar_image..".png";
        GameCreateSpriteForXFrames( sprite, x, y + 8, true, 0, 0, frames );
    end
end

function string_trim( s )
   local from = s:match"^%s*()"
   return from > #s and "" or s:match(".*%S", from)
end

function string_split( s, splitter )
    local words = {};
    for word in string.gmatch( s, '([^'..splitter..']+)') do
        table.insert( words, word );
    end
    return words;
end

function reduce_particles( entity, disable )
    local particle_emitters = EntityGetComponent( entity, "ParticleEmitterComponent" ) or {};
    local sprite_particle_emitters = EntityGetComponent( entity, "SpriteParticleEmitterComponent" ) or {};
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if not disable then
        for _,emitter in pairs( particle_emitters ) do
            if ComponentGetValue2( emitter, "emit_cosmetic_particles" ) == true and ComponentGetValue2( emitter, "create_real_particles" ) == false and ComponentGetValue2( emitter, "emit_real_particles" ) == false then
                ComponentSetValue2( emitter, "count_min", 1 );
                ComponentSetValue2( emitter, "count_max", 1 );
                ComponentSetValue2( emitter, "collide_with_grid", false );
                ComponentSetValue2( emitter, "is_trail", false );
                local lifetime_min = tonumber( ComponentGetValue2( emitter, "lifetime_min" ) );
                ComponentSetValue2( emitter, "lifetime_min", math.min( lifetime_min * 0.5, 0.1 ) );
                local lifetime_max = tonumber( ComponentGetValue2( emitter, "lifetime_max" ) );
                ComponentSetValue2( emitter, "lifetime_max", math.min( lifetime_max * 0.5, 0.5 ) );
            end
        end
        for _,emitter in pairs( sprite_particle_emitters ) do
            if ComponentGetValue2( emitter, "entity_file" ) == "" then
                ComponentSetValue2( emitter, "count_max", 1 );
                ComponentSetValue2( emitter, "emission_interval_min_frames", math.ceil( ComponentGetValue2( emitter, "emission_interval_min_frames" ) * 2 ) );
                ComponentSetValue2( emitter, "emission_interval_max_frames", math.ceil( ComponentGetValue2( emitter, "emission_interval_max_frames" ) * 2 ) );
            end
        end
        if projectile ~= nil then
            ComponentObjectAdjustValues( projectile, "config_explosion", {
                sparks_count_min=function( value ) return math.min( value, 1 ); end,
                sparks_count_max=function( value ) return math.min( value, 2 ); end,
            });
        end
    else
        for _,emitter in pairs( particle_emitters ) do
            if ComponentGetValue2( emitter, "emit_cosmetic_particles" ) == true and ComponentGetValue2( emitter, "create_real_particles" ) == false and ComponentGetValue2( emitter, "emit_real_particles" ) == false then
                EntitySetComponentIsEnabled( entity, emitter, false );
            end
        end
        for _,emitter in pairs( sprite_particle_emitters ) do
            EntitySetComponentIsEnabled( entity, emitter, false );
        end
        if projectile ~= nil then
            ComponentObjectSetValues( projectile, "config_explosion", {
                sparks_count_min=0,
                sparks_count_max=0,
            });
        end
    end
end

function find_polymorphed_players()
    local nearby_polymorph = EntityGetWithTag( "polymorphed" ) or {};
    local polymorphed_players = {};
    for _,entity in pairs( nearby_polymorph ) do
        local game_stats = EntityGetFirstComponent( entity, "GameStatsComponent" );
        if game_stats ~= nil then
            if ComponentGetValue2( game_stats, "is_player" ) == true then
                --GamePrint( "entity ".. entity .. "is likely a polymorphed player" );
                table.insert( polymorphed_players, entity );
            end
        end
    end
    return polymorphed_players;
end

function ease_angle( angle, target_angle, easing )
    local dir = (angle - target_angle) / (math.pi*2);
    dir = dir - math.floor(dir + 0.5);
    dir = dir * (math.pi*2);
    return angle - dir * easing;
end

function angle_difference( target_angle, starting_angle )
    return math.atan2( math.sin( target_angle - starting_angle ), math.cos( target_angle - starting_angle ) );
end

function projectile_change_particle_colors( projectile_entity, color )
    local r = bit.band( 0xFF, color );
    local g = bit.rshift( bit.band( 0xFF00, color ), 8 );
    local b = bit.rshift( bit.band( 0xFF0000, color ), 16 );
    local particle_emitters = EntityGetComponent( projectile_entity, "ParticleEmitterComponent" ) or {};
    for _,particle_emitter in pairs( particle_emitters ) do
        ComponentSetValue2( particle_emitter, "color", color );
    end
    local sprite_particle_emitters = EntityGetComponent( projectile_entity, "SpriteParticleEmitterComponent" ) or {};
    for _,sprite_particle_emitter in pairs( sprite_particle_emitters ) do
        local color = {ComponentGetValue2( sprite_particle_emitter, "color" )};
        local color_change = {ComponentGetValue2( sprite_particle_emitter, "color_change" )};
        local ratio_r = r / 255;
        local ratio_g = g / 255;
        local ratio_b = b / 255;
        ComponentSetValue2( sprite_particle_emitter, "color", ratio_r, ratio_g, ratio_b, color[4] );
    end
end

function distance_to_entity( x, y, entity )
    local tx, ty = EntityGetFirstHitboxCenter( entity );
    if tx == nil or ty == nil then
        tx, ty = EntityGetTransform( entity );
    end
    return math.sqrt( math.pow( tx - x, 2 ) + math.pow( ty - y, 2 ) );
end

function get_protagonist_bonus( player )
    local multiplier = 1.0;
    local health_ratio = 1;
    local damage_models = EntityGetComponent( player, "DamageModelComponent" );
    if damage_models ~= nil then
        for i,damage_model in ipairs( damage_models ) do
            local current_hp = ComponentGetValue2( damage_model, "hp" );
            local max_hp = ComponentGetValue2( damage_model, "max_hp" );
            local ratio = current_hp / max_hp;
            if ratio < health_ratio then
                health_ratio = ratio;
            end
        end
    end
    if player ~= nil then
        local current_protagonist_bonus = EntityGetVariableNumber( player, "gkbrkn_low_health_damage_bonus", 0.0 );
        local adjuted_ratio = ( 1 - health_ratio ) ^ 1.5;
        multiplier = 1.0 + current_protagonist_bonus * adjuted_ratio;
    end
    return multiplier;
end

function append_translations( filepath )
    local translations = ModTextFileGetContent( "data/translations/common.csv" );
    while translations:find("\r\n\r\n") do
        translations = translations:gsub("\r\n\r\n","\r\n");
    end
    local new_translations = ModTextFileGetContent( filepath );
    translations = translations .. new_translations;
    ModTextFileSetContent( "data/translations/common.csv", translations );
end

function thousands_separator(amount)
    local formatted = amount;
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
            if (k==0) then
            break
        end
    end
    return formatted;
end

function copy_component( left, right )
    for k,v in pairs( ComponentGetMembers( left ) ) do
        ComponentSetValue2( right, k, ComponentGetValue2( left, k ) )
    end
end

function update_sprite_image( entity, sprite_component, new_image_filepath )
--[[
    if sprite_component then
        local new_sprite_component = EntityAddComponent2( entity, "SpriteComponent" );
        ComponentSetValue2( sprite, "image_file", pack_data.image_filepath );
        copy_component( sprite_component, new_sprite_component );
        EntityRemoveComponent( sprite_component );
    end
    ]]
    local new_sprite                             = EntityAddComponent2( entity, "SpriteComponent", {
        image_file                               = new_image_filepath,
        ui_is_parent                             = ComponentGetValue2(sprite_component,"ui_is_parent"),
        is_text_sprite                           = ComponentGetValue2(sprite_component,"is_text_sprite"),
        offset_x                                 = ComponentGetValue2(sprite_component,"offset_x"),
        offset_y                                 = ComponentGetValue2(sprite_component,"offset_y"),
        alpha                                    = ComponentGetValue2(sprite_component,"alpha"),
        visible                                  = ComponentGetValue2(sprite_component,"visible"),
        emissive                                 = ComponentGetValue2(sprite_component,"emissive"),
        additive                                 = ComponentGetValue2(sprite_component,"additive"),
        fog_of_war_hole                          = ComponentGetValue2(sprite_component,"fog_of_war_hole"),
        smooth_filtering                         = ComponentGetValue2(sprite_component,"smooth_filtering"),
        rect_animation                           = ComponentGetValue2(sprite_component,"rect_animation"),
        next_rect_animation                      = ComponentGetValue2(sprite_component,"next_rect_animation"),
        text                                     = ComponentGetValue2(sprite_component,"text"),
        z_index                                  = ComponentGetValue2(sprite_component,"z_index"),
        update_transform                         = ComponentGetValue2(sprite_component,"update_transform"),
        update_transform_rotation                = ComponentGetValue2(sprite_component,"update_transform_rotation"),
        kill_entity_after_finished               = ComponentGetValue2(sprite_component,"kill_entity_after_finished"),
        has_special_scale                        = ComponentGetValue2(sprite_component,"has_special_scale"),
        special_scale_x                          = ComponentGetValue2(sprite_component,"special_scale_x"),
        special_scale_y                          = ComponentGetValue2(sprite_component,"special_scale_y"),
        never_ragdollify_on_death                = ComponentGetValue2(sprite_component,"never_ragdollify_on_death")
    } );
    EntityRemoveComponent( entity, sprite_component );
end

function sort_keyed_table( keyed_table, sort_function )
    local h = {};
    for k,v in pairs( keyed_table ) do
        table.insert( h, { key=k, value=v })
    end
    table.sort( h, sort_function );
    return h;
end

function get_magic_focus_multiplier( last_calibration_shot_frame, last_calibration_percent )
    local multiplier = 1.0;
    local current_frame = GameGetFrameNum();
    local difference = current_frame - last_calibration_shot_frame;
    if difference < MISC.PerkOptions.MagicFocus.DecayFrames then
        return ( 1 - (difference / MISC.PerkOptions.MagicFocus.DecayFrames) ) * last_calibration_percent;
    else
        return math.min( 1, (difference - MISC.PerkOptions.MagicFocus.DecayFrames) / MISC.PerkOptions.MagicFocus.ChargeFrames);
    end
end