table.insert( champion_types, {
    particle_material = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/hot_blooded/badge.xml",
	id = "hot_blooded",
	name = "$champion_type_name_hot_blooded",
	description = "$champion_type_desc_hot_blooded",
	author = "$ui_author_name_goki_dev",

    sprite_particle_sprite_file = nil,
    game_effects = {"PROTECTION_FIRE"},
    validator = function( entity ) return true end,
    apply = function( entity )
        local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
        for _,damage_model in pairs( damage_models ) do
            ComponentSetValue( damage_model, "blood_material", "lava" );
            ComponentSetValue( damage_model, "blood_spray_material", "lava" );
            ComponentSetValue( damage_model, "blood_multiplier", "2" );
        end
    end
} );