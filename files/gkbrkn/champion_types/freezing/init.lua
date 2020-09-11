table.insert( champion_types, {
    particle_material = nil,
    sprite_particle_sprite_file = "data/particles/snowflake_$[1-2].xml",
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/freezing/badge.xml",
	id = "freezing",
	name = "$champion_type_name_freezing",
	description = "$champion_type_desc_freezing",
	author = "$ui_author_name_goki_dev",
    game_effects = {"PROTECTION_FIRE"},
    validator = function( entity ) return true end,
    apply = function( entity )
        local x,y = EntityGetTransform( entity );
        local field = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/freezing/freeze_field.xml", x, y );
        if field ~= nil then
            EntityAddChild( entity, field );
        end
        EntityAddComponent( entity, "LuaComponent", {
            execute_every_n_frame="60",
            execute_on_added="1",
            script_source_file="mods/gkbrkn_noita/files/gkbrkn/champion_types/freezing/freeze.lua",
        });
        EntityAddComponent( entity, "LuaComponent", {
            script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/freezing/shot.lua",
        });
        TryAdjustDamageMultipliers( entity, { ice = 0.00 } );
    end
} )