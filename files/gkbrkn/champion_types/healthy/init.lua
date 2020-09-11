table.insert( champion_types, {
    particle_material = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/healthy/badge.xml",
	id = "healthy",
	name = "$champion_type_name_healthy",
	description = "$champion_type_desc_healthy",
	author = "$ui_author_name_goki_dev",

    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
        for index,damage_model in pairs( damage_models ) do
            local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
            local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
            local new_max = max_hp * 1.5;
            local regained = new_max - current_hp;
            ComponentSetValue( damage_model, "max_hp", tostring( new_max ) );
            ComponentSetValue( damage_model, "hp", tostring( current_hp + regained ) );
        end
    end
} );