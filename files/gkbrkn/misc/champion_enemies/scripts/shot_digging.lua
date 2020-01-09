dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
function shot( projectile_entity )
    local projectile = EntityGetFirstComponent( projectile_entity, "ProjectileComponent" );
    ComponentSetValues( projectile, {
        penetrate_entities="1",
    });
    ComponentAdjustValues( projectile, {
        ground_penetration_coeff=function( value ) return math.max( tonumber( value ), 3 ) * 2; end,
    });
    EntityAddComponent( projectile_entity, "CellEaterComponent", {
        radius="4",
        eat_probability="100",
        eat_dynamic_physics_bodies="0"
    } );
end