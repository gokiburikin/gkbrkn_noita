dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

function shot( projectile_entity )
    local projectile = EntityGetFirstComponent( projectile_entity, "ProjectileComponent" );
    local player = GetUpdatedEntityID();
    local damage_multiplier =  EntityGetVariableNumber( player, "gkbrkn_damage_multiplier", 1.0 );
    ComponentAdjustValue( projectile, "damage", function( value ) return tonumber( value ) * damage_multiplier; end );

    local demolitionist_bonus = EntityGetVariableNumber( player, "gkbrkn_demolitionist_bonus", 0.0 ) + EntityGetVariableNumber( projectile_entity, "gkbrkn_demolitionist_bonus", 0.0 );
    if demolitionist_bonus ~= 0 then
        local explosion_multiplier = demolitionist_bonus + 1;
        ComponentObjectAdjustValues( projectile, "config_explosion", {
            knockback_force=function( value ) return tonumber( value ) * explosion_multiplier; end,
            explosion_radius=function( value ) return tonumber( value ) * explosion_multiplier; end,
            max_durability_to_destroy=function( value ) return tonumber( value ) + demolitionist_bonus; end,
            ray_energy=function( value ) return tonumber( value ) * explosion_multiplier; end,
            cell_explosion_power=function( value ) return tonumber( value ) * explosion_multiplier; end,
            cell_explosion_radius_min=function( value ) return tonumber( value ) * explosion_multiplier; end,
            cell_explosion_radius_max=function( value ) return tonumber( value ) * explosion_multiplier; end,
            cell_explosion_velocity_min=function( value ) return tonumber( value ) * explosion_multiplier; end,
            cell_explosion_damage_required=function( value ) return tonumber( value ) * explosion_multiplier; end,
            cell_explosion_probability=function( value ) return tonumber( value ) * explosion_multiplier; end,
            cell_explosion_power_ragdoll_coeff=function( value ) return tonumber( value ) * explosion_multiplier; end,
        });

        local lightning = EntityGetFirstComponent( projectile_entity, "LightningComponent" );
        if lightning ~= nil then
            ComponentObjectAdjustValues( lightning, "config_explosion", {
                knockback_force=function( value ) return tonumber( value ) * explosion_multiplier; end,
                explosion_radius=function( value ) return tonumber( value ) * explosion_multiplier; end,
                max_durability_to_destroy=function( value ) return tonumber( value ) + demolitionist_bonus; end,
                ray_energy=function( value ) return tonumber( value ) * explosion_multiplier; end,
                cell_explosion_power=function( value ) return tonumber( value ) * explosion_multiplier; end,
                cell_explosion_radius_min=function( value ) return tonumber( value ) * explosion_multiplier; end,
                cell_explosion_radius_max=function( value ) return tonumber( value ) * explosion_multiplier; end,
                cell_explosion_velocity_min=function( value ) return tonumber( value ) * explosion_multiplier; end,
                cell_explosion_damage_required=function( value ) return tonumber( value ) * explosion_multiplier; end,
                cell_explosion_probability=function( value ) return tonumber( value ) * explosion_multiplier; end,
                cell_explosion_power_ragdoll_coeff=function( value ) return tonumber( value ) * explosion_multiplier; end,
            });
        end
    end

    local hyper_casting_bonus = EntityGetVariableNumber( player, "gkbrkn_hyper_casting", 0.0 );
    if hyper_casting_bonus > 0 then
        local velocity = EntityGetFirstComponent( projectile_entity, "VelocityComponent" );
        if velocity ~= nil then
            ComponentAdjustValues( velocity, {
                air_friction=function( value ) return math.min( tonumber( value ), 0 ); end,
                gravity_y=function( value ) return 0; end,
                apply_terminal_velocity=function( value ) return 1; end,
                terminal_velocity=function( value ) return 2000; end,
            } );
        end
        if projectile ~= nil then
            ComponentAdjustValues( projectile, {
                knockback_force=function( value ) return 0; end,
                ragdoll_force_multiplier=function( value ) return 0; end,
                hit_particle_force_multiplier=function( value ) return 0; end,
                bounce_energy=function( value ) return 1.0; end,
            } );
        end
    end

    if projectile ~= nil then
        EntitySetVariableNumber( projectile_entity, "gkbrkn_bounces_last", ComponentGetValue( projectile, "bounces_left" ) );
        EntitySetVariableNumber( projectile_entity, "gkbrkn_bounce_damage_remaining", 10 );
        EntitySetVariableNumber( projectile_entity, "gkbrkn_initial_damage", ComponentGetValue( projectile, "damage" ) );
        EntitySetVariableNumber( projectile_entity, "gkbrkn_damage_plus_lifetime_limit", GameGetFrameNum() + 300 );
        local active_types = {};
        local damage_by_types = ComponentObjectGetMembers( projectile, "damage_by_type" ) or {};
        for type,_ in pairs( damage_by_types ) do
            local amount = tonumber( ComponentObjectGetValue( projectile, "damage_by_type", type ) );
            if amount == amount and amount ~= 0 then
                table.insert( active_types, type.."="..amount );
            end
        end
        if #active_types > 0 then
            EntitySetVariableString( projectile_entity, "gkbrkn_initial_damage_types", table.concat( active_types, "," ) );
        end
    end

    EntityAddComponent( projectile_entity, "LuaComponent", {
        script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/player_projectile_update.lua",
        execute_every_n_frame="1",
    } );
end