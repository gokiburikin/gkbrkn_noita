local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" )
--##DEV local STATS = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/stats.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")

local do_time_compression = function( e, p )
    local tpc = EntityGetFirstComponent( e, "TeleportProjectileComponent" )
    -- Since the teleport bolt will basically be right next to the wall, increase the check radius
    if tpc then
        ComponentSetValue2( tpc, "mWhoShot", p )
        ComponentSetValue2( tpc, "min_distance", min_distance_from_wall, 8 )
    end
    -- This is here simply to mitigate too small angle issues
    local v = EntityGetFirstComponentIncludingDisabled( e, "VelocityComponent" )
    if v then
        local x, y = EntityGetTransform( e )
        local vx, vy = ComponentGetValue2( v, "mVelocity" )
        local angle = math.atan2( vy, vx )
        EntityApplyTransform( e, x + math.cos(angle) * 1, y + math.sin(angle) * 1 )
    end
    EntityKill(e)
end

local do_inner_homing = function( e, p )
    EntitySetTransform( e, EntityGetFirstHitboxCenter( p ) )
    local v = EntityGetFirstComponent( e, "VelocityComponent" )
    if v then ComponentSetValue2( v, "mVelocity", 0, 0 ) end
end

-- TODO add fallback for enemies
local do_protective_enchantment = function( e, p )
    local p = EntityGetFirstComponentIncludingDisabled( e, "ProjectileComponent" )
    if p then ComponentSetValue2( p, "never_hit_player", true ) end
end

local do_secret_shot = function( e, p )
    EntityRemoveTag( e, "projectile" )
    EntityRemoveTag( e, "projectile_player" )
end

-- Performance Notes
-- Baseline: 0.0018ms per call
-- EntityHasTag: 0.003ms per call
-- setting_get: 0.0067ms per call
-- EntityGetVariableNumber: 0.004ms per call
-- EntitySetVariableNumber: 0.013ms per call
-- get_protagonist_bonus: 0.011ms per call
-- adjust_all_entity_damage: 0.067ms per call
-- get_magic_focus_multiplier: 0.002ms per call
-- EntityAddComponent: 0.015ms per call

-- PERF BEFORE: 0.2172 {
-- PERF CHANGE BOUNCE AND LIFETIME: 0.1122 {
function shot( e )
    local player = GetUpdatedEntityID()
    if EntityHasNamedVariable( e, "gkbrkn_secret_shot" ) then do_secret_shot( e, player ) end
    if EntityHasNamedVariable( e, "gkbkrn_protective_enchantment" ) then do_protective_enchantment( e, player ) end
    if EntityHasNamedVariable( e, "gkbkrn_inner_homing" ) then do_inner_homing( e, player ) end
    local t = GameGetRealWorldTimeSinceStarted()
    local current_frame = GameGetFrameNum()
    local projectile = EntityGetFirstComponentIncludingDisabled( e, "ProjectileComponent" )
    
    local projectile_damage_multiplier =  EntityGetVariableNumber( e, "gkbrkn_damage_multiplier", 1.0 )
    if projectile_damage_multiplier ~= 1 then
        adjust_all_entity_damage( e, function( current_damage ) return current_damage * projectile_damage_multiplier end )
    end

    local current_protagonist_bonus = get_protagonist_bonus( player )
    if current_protagonist_bonus ~= 1 then
        adjust_all_entity_damage( e, function( current_damage ) return current_damage * current_protagonist_bonus end )
    end

    local empower_stacks = EntityGetVariableNumber( e, "gkbrkn_empower_stacks", 0 )
    if empower_stacks > 0 then
        adjust_all_entity_damage( e, function( current_damage ) return current_damage * empower_stacks * 5 end )
    end

    -- PERF: 0.0057 {
    local last_calibration_shot = EntityGetVariableNumber( player, "gkbrkn_last_calibration_shot_frame", 0 )
    if current_frame - last_calibration_shot >= MISC.PerkOptions.MagicFocus.DecayFrames then
        EntitySetVariableNumber( player, "gkbrkn_last_calibration_shot_percent", get_magic_focus_multiplier( last_calibration_shot ) )
        EntitySetVariableNumber( player, "gkbrkn_last_calibration_shot_frame", current_frame )
    end
    -- }

    -- PERF: 0.013 {
    local disintegrate_corpses = EntityGetVariableNumber( player, "gkbrkn_disintegrate_corpses", 0.0 )
    if disintegrate_corpses > 0 then
        ComponentSetValue2( projectile, "damage_game_effect_entities", 
            ComponentGetValue2( projectile, "damage_game_effect_entities" ) .. "data/entities/misc/effect_disintegrated.xml,"
        )
    end
    -- }
    
    -- PERF: 0.0094 {
    local demolitionist_bonus = EntityGetVariableNumber( player, "gkbrkn_demolitionist_bonus", 0.0 ) + EntityGetVariableNumber( e, "gkbrkn_demolitionist_bonus", 0.0 )
    if demolitionist_bonus ~= 0 then
        local explosion_multiplier = demolitionist_bonus + 1
        ComponentObjectAdjustValues( projectile, "config_explosion", {
            max_durability_to_destroy=function( value ) return tonumber( value ) + demolitionist_bonus end,
            knockback_force=function( value ) return tonumber( value ) * explosion_multiplier end,
            explosion_radius=function( value ) return tonumber( value ) * explosion_multiplier end,
            ray_energy=function( value ) return tonumber( value ) * explosion_multiplier end,
            cell_explosion_power=function( value ) return tonumber( value ) * explosion_multiplier end,
            cell_explosion_radius_min=function( value ) return tonumber( value ) * explosion_multiplier end,
            cell_explosion_radius_max=function( value ) return tonumber( value ) * explosion_multiplier end,
            cell_explosion_velocity_min=function( value ) return tonumber( value ) * explosion_multiplier end,
            cell_explosion_damage_required=function( value ) return tonumber( value ) * explosion_multiplier end,
            cell_explosion_probability=function( value ) return tonumber( value ) * explosion_multiplier end,
            cell_explosion_power_ragdoll_coeff=function( value ) return tonumber( value ) * explosion_multiplier end,
        })

        local lightning = EntityGetFirstComponentIncludingDisabled( e, "LightningComponent" )
        if lightning ~= nil then
            ComponentObjectAdjustValues( lightning, "config_explosion", {
                max_durability_to_destroy=function( value ) return tonumber( value ) + demolitionist_bonus end,
                knockback_force=function( value ) return tonumber( value ) * explosion_multiplier end,
                explosion_radius=function( value ) return tonumber( value ) * explosion_multiplier end,
                ray_energy=function( value ) return tonumber( value ) * explosion_multiplier end,
                cell_explosion_power=function( value ) return tonumber( value ) * explosion_multiplier end,
                cell_explosion_radius_min=function( value ) return tonumber( value ) * explosion_multiplier end,
                cell_explosion_radius_max=function( value ) return tonumber( value ) * explosion_multiplier end,
                cell_explosion_velocity_min=function( value ) return tonumber( value ) * explosion_multiplier end,
                cell_explosion_damage_required=function( value ) return tonumber( value ) * explosion_multiplier end,
                cell_explosion_probability=function( value ) return tonumber( value ) * explosion_multiplier end,
                cell_explosion_power_ragdoll_coeff=function( value ) return tonumber( value ) * explosion_multiplier end,
            })
        end
    end
    -- }

    local hyper_casting_bonus = EntityGetVariableNumber( player, "gkbrkn_hyper_casting", 0.0 )
    if hyper_casting_bonus > 0 then
        local velocity = EntityGetFirstComponentIncludingDisabled( e, "VelocityComponent" )
        if velocity ~= nil then
            ComponentAdjustValues( velocity, {
                air_friction=function( value ) return math.min( tonumber( value ), -25 ) end,
                gravity_y=function( value ) return 0 end,
                apply_terminal_velocity=function( value ) return true end,
                terminal_velocity=function( value ) return 1500 end,
            } )
        end
        if projectile ~= nil then
            ComponentAdjustValues( projectile, {
                knockback_force=function( value ) return 0 end,
                ragdoll_force_multiplier=function( value ) return 0 end,
                hit_particle_force_multiplier=function( value ) return 0 end,
                bounce_energy=function( value ) return 1.0 end,
            } )
        end
    end

    if EntityHasVarTag( e, "gkbrkn_guided_shot" ) then
        local velocity = EntityGetFirstComponentIncludingDisabled( e, "VelocityComponent" )
        if velocity ~= nil then
            local projectile = EntityGetFirstComponentIncludingDisabled( e, "ProjectileComponent" )
            if projectile ~= nil then
                local aim_angle = 0
                local components = EntityGetAllComponents( player ) or {}
                for _,component in pairs( components ) do
                    if ComponentGetTypeName( component ) == "ControlsComponent" then
                        local ax, ay = ComponentGetValue2( component, "mAimingVector" )
                        aim_angle = math.atan2( ay, ax )
                        break
                    end
                end
                local vx,vy = ComponentGetValue2( velocity, "mVelocity", vx, vy )
                local magnitude = math.sqrt( vx * vx + vy * vy )
                ComponentSetValue2( velocity, "mVelocity", math.cos( aim_angle ) * magnitude, math.sin( aim_angle ) * magnitude )
            end
        end
    end

    if EntityHasVarTag( e, "gkbrkn_carry_shot" ) then
        if projectile ~= nil then
            ComponentSetValue2( projectile, "die_on_low_velocity", false )
        end

        local initial_angle = nil
        local aim_angle = 0

        local velocity = EntityGetFirstComponentIncludingDisabled( e, "VelocityComponent" )
        if velocity ~= nil then
            local vx, vy = ComponentGetValue2( velocity, "mVelocity" )
            local magnitude = math.sqrt( vx * vx + vy * vy )
            EntitySetVariableNumber( e, "gkbrkn_carry_shot_magnitude", magnitude )
            if vx ~= 0 or vy ~= 0 then
                initial_angle = math.atan2( vy, vx )
            end
            ComponentSetValue2( velocity, "gravity_y", 0 )
        end

        local components = EntityGetAllComponents( player ) or {}
        for _,component in pairs( components ) do
            if ComponentGetTypeName( component ) == "ControlsComponent" then
                local ax, ay = ComponentGetValue2( component, "mAimingVector" )
                aim_angle = math.atan2( ay, ax )
            end
        end

        local x, y = EntityGetTransform( e )
        local active_wand = WandGetActive( player )
        if active_wand ~= nil then
            local wx, wy = EntityGetTransform( active_wand )
            local distance = math.sqrt( math.pow( wx - x, 2 ) + math.pow( wy - y, 2 ) ) + 8
            EntitySetVariableNumber( e, "gkbrkn_carry_shot_distance", distance )
        end

        if initial_angle ~= nil then
            EntitySetVariableNumber( e, "gkbrkn_carry_shot_angle_offset", initial_angle - aim_angle )
        else
            EntitySetVariableNumber( e, "gkbrkn_carry_shot_angle_offset", 0 )
        end
    end

    if setting_get( "game_modifier_gkbrkn_limit_critical_damage", false ) then
        ComponentObjectSetValue2( projectile, "damage_critical", "chance", math.min( ComponentObjectGetValue2( projectile, "damage_critical", "chance" ), 100 ) )
    end

    if setting_get( "cheat_one_hit_kills", false ) then
        set_projectile_damage( projectile, "projectile", math.huge )
    end

    if setting_get( MISC.RainbowProjectiles.EnabledFlag, false ) then
        SetRandomSeed( e, e )
        local color = 0xFF000000 + math.floor( Random() * 0xFFFFFF )
        projectile_change_particle_colors( e, color )
    end
    
    if EntityHasNamedVariable( e, "gkbkrn_time_compression" ) then do_time_compression( e, player ) end
    --##DEV STATS.add_and_count( "player_shot", GameGetRealWorldTimeSinceStarted() - t )
end
-- }