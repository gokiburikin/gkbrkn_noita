table.insert( champion_types, {
    particle_material = nil,
    sprite_particle_sprite_file = "data/particles/spark_electric.xml",
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/electric/badge.xml",
	id = "electric",
	name = "$champion_type_name_electric",
	description = "$champion_type_desc_electric",
	author = "$ui_author_name_goki_dev",

    game_effects = {"PROTECTION_ELECTRICITY"},
    validator = function( entity ) return true end,
    apply = function( entity ) 
        local electric = EntityAddComponent( entity, "ElectricChargeComponent", { 
            _tags="enabled_in_world",
            charge_time_frames="15",
            electricity_emission_interval_frames="15",
            fx_velocity_max="10",
        });
        local x,y = EntityGetTransform( entity );
        local electrocution = EntityLoad( "data/entities/particles/water_electrocution.xml", x, y );
        if electrocution ~= nil then
            EntityAddChild( entity, electrocution );
        end
        local field = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/electric/electricity_field.xml", x, y );
        if field ~= nil then
            EntityAddChild( entity, field );
        end
        EntityAddComponent( entity, "LuaComponent", {
            execute_every_n_frame="60",
            execute_on_added="1",
            script_source_file="mods/gkbrkn_noita/files/gkbrkn/champion_types/electric/update.lua",
        });
        EntityAddComponent( entity, "LuaComponent", {
            script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/electric/shot.lua",
        });
        TryAdjustDamageMultipliers( entity, { electricity = 0.00 } );
    end
} )