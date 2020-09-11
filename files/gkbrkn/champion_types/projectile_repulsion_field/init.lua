table.insert( champion_types, {
    particle_material = nil,
    sprite_particle_sprite_file = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/projectile_repulsion_field/badge.xml",
	id = "projectile_repulsion_field",
	name = "$champion_type_name_projectile_repulsion_field",
	description = "$champion_type_desc_projectile_repulsion_field",
	author = "$ui_author_name_goki_dev",

    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        local shield = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/projectile_repulsion_field/projectile_repulsion_field.xml" );
        if shield ~= nil then EntityAddChild( entity, shield ); end
    end
} )