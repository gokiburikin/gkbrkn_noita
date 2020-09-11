table.insert( champion_types, 
{
    particle_material = nil,
    sprite_particle_sprite_file = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/energy_shield/badge.xml",
	id = "energy_shield",
	name = "$champion_type_name_energy_shield",
	description = "$champion_type_desc_energy_shield",
	author = "$ui_author_name_goki_dev",

    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        local x, y = EntityGetTransform( entity );
        local radius = nil;
        local width,height = EntityGetFirstHitboxSize( entity, 18, 18 );
        radius = math.max( height, width ) + 6;
        local shield = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/energy_shield/energy_shield.xml", x, y );
        local emitters = EntityGetComponent( shield, "ParticleEmitterComponent" ) or {};
        for _,emitter in pairs( emitters ) do
            ComponentSetValueValueRange( emitter, "area_circle_radius", radius, radius );
        end
        local energy_shield = EntityGetFirstComponent( shield, "EnergyShieldComponent" );
        ComponentSetValue( energy_shield, "radius", tostring( radius ) );

        local hotspot = EntityAddComponent( entity, "HotspotComponent",{
            _tags="gkbrkn_center"
        } );
        ComponentSetValueVector2( hotspot, "offset", 0, -height * 0.3 );

        if shield ~= nil then EntityAddChild( entity, shield ); end
    end
} );