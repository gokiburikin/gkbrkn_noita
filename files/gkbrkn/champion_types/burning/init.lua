table.insert( champion_types, {
    particle_material = nil,
    sprite_particle_sprite_file = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/burning/badge.xml",
	id = "burning",
	name = "$champion_type_name_burning",
	description = "$champion_type_desc_burning",
	author = "$ui_author_name_goki_dev",
    game_effects = {"PROTECTION_FIRE"},
    validator = function( entity ) return true end,
    apply = function( entity )
        local x,y = EntityGetTransform( entity );
        local burn = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/burning/fire.xml", x, y );
        if burn ~= nil then
            EntityAddChild( entity, burn );
        end
        EntityAddComponent( entity, "LuaComponent", {
            script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/burning/shot.lua",
        });
        TryAdjustDamageMultipliers( entity, { ice = 0.00 } );
    end
})