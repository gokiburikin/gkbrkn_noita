dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
function shot( projectile_entity )
    local projectile = EntityGetFirstComponent( projectile_entity, "ProjectileComponent" );
    ComponentAdjustValues( projectile, {
        ground_penetration_coeff=function( value ) return math.max( tonumber( value ), 3 ) * 2; end,
    });
end