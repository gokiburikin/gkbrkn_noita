dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

function shot( projectile_entity )
    local projectile = EntityGetFirstComponent( projectile_entity, "ProjectileComponent" );
    local player = GetUpdatedEntityID();
    local damage_multiplier =  EntityGetVariableNumber( player, "gkbrkn_damage_multiplier", 1.0 );
    ComponentAdjustValue( projectile, "damage", function( value ) return tonumber( value ) * damage_multiplier; end );
end