dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
function shot( projectile_entity )
    local projectile = EntityGetFirstComponent( projectile_entity, "ProjectileComponent" );
    local explosion_multiplier = 1.5;
    ComponentObjectAdjustValues( projectile, "config_explosion", {
        damage=function( value ) return tonumber( value ) * explosion_multiplier; end,
        knockback_force=function( value ) return tonumber( value ) * explosion_multiplier; end,
        explosion_radius=function( value ) return tonumber( value ) * explosion_multiplier; end,
        ray_energy=function( value ) return tonumber( value ) * explosion_multiplier; end,
        cell_explosion_power=function( value ) return tonumber( value ) * explosion_multiplier; end,
        cell_explosion_radius_min=function( value ) return tonumber( value ) * explosion_multiplier; end,
        cell_explosion_radius_max=function( value ) return tonumber( value ) * explosion_multiplier; end,
        cell_explosion_velocity_min=function( value ) return tonumber( value ) * explosion_multiplier; end,
        cell_explosion_damage_required=function( value ) return tonumber( value ) * explosion_multiplier; end,
        cell_explosion_radius_min=function( value ) return tonumber( value ) * explosion_multiplier; end,
        cell_explosion_probability=function( value ) return tonumber( value ) * explosion_multiplier; end,
        cell_explosion_power_ragdoll_coeff=function( value ) return tonumber( value ) * explosion_multiplier; end,
    });
end