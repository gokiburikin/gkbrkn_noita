table.insert( champion_types, {
    particle_material = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/armored/badge.xml",
	id = "armored",
	name = "$champion_type_name_armored",
	description = "$champion_type_desc_armored",
	author = "$ui_author_name_goki_dev",
    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        local resistances = {
            ice = 0.50,
            electricity = 0.50,
            radioactive = 0.50,
            slice = 0.50,
            projectile = 0.50,
            healing = 0.50,
            physics_hit = 0.50,
            explosion = 0.50,
            poison = 0.50,
            melee = 0.00,
            drill = 0.50,
            fire = 0.50,
        };
        local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
        for index,damage_model in pairs( damage_models ) do
            for damage_type,multiplier in pairs( resistances ) do
                local resistance = tonumber( ComponentObjectGetValue( damage_model, "damage_multipliers", damage_type ) );
                resistance = resistance * multiplier;
                ComponentObjectSetValue( damage_model, "damage_multipliers", damage_type, tostring( resistance ) );
            end
            local minimum_knockback_force = tonumber( ComponentGetValue( damage_model, "minimum_knockback_force" ) );
            ComponentSetValue( damage_model, "minimum_knockback_force", "99999" );
        end
    end
} );