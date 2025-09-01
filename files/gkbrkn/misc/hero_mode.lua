local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua" )

function hero_mode_process_entity( e )
    if EntityHasVarTag( e, "gkbrkn_hero_mode" ) then return end

    local x, y = EntityGetTransform( e )
    local parallel_world_x, parallel_world_y = GetParallelWorldPosition( x, y )
    local parallel_world_distance = math.abs( parallel_world_x ) + math.abs( parallel_world_y )
    local is_carnage_mode = GameHasFlagRun( MISC.HeroMode.CarnageDifficultyFlag )
    local speed_multiplier = 1.10
    local critical_damage_resistance = 0.25
    
    local places_visited = 0
    local distance_multiplier = 1
    local orb_multiplier =  1
    if GameHasFlagRun( MISC.HeroMode.OrbsDifficultyFlag ) then
        orb_multiplier =  math.pow( 1.077, GameGetOrbCountThisRun() )
    end
    
    -- Straight run is ~9 places visited
    -- Basic exploration run is ~16
    -- Extended exploration is ~21

    if GameHasFlagRun( MISC.HeroMode.DistanceDifficultyFlag ) then
        places_visited = tonumber( StatsGetValue("places_visited") or 0 ) + parallel_world_distance * 10
        -- Old formula
        --distance_multiplier = math.min( 1, math.pow( 0.85, places_visited - 1 ) )
        -- New formula
        -- distance_multiplier = math.pow( 1.075, places_visited ) + 0.25 * places_visited
        -- Harder formula
        distance_multiplier = math.pow( 1.05, places_visited ) + 0.65 * places_visited
    end

    if is_carnage_mode then
        speed_multiplier = 1.20
        critical_damage_resistance = 0.50
    end

    speed_multiplier = speed_multiplier + 0.01 * places_visited

    -- Worms seem to break if you make them fast, so skip them
    local worm = EntityGetFirstComponentIncludingDisabled( e, "WormComponent" )
    if worm then
        speed_multiplier = 1.0
    end

    EntityAddVarTag( e, "gkbrkn_hero_mode" )
    local damage_models = EntityGetComponent( e, "DamageModelComponent" ) or {}
    if #damage_models > 0 then
        local health_multiplier = 1.0
        local bonus_health = 0.0
        local general_resistances = 1.0

        if EntityHasTag( e, "boss_centipede_active" ) then
            bonus_health = 160
        end
        if is_carnage_mode then health_multiplier = health_multiplier * 2.0 end

        local resistances = {
            physics_hit = general_resistances * 0.2,
        }
        
        for _,damage_model in pairs( damage_models ) do
            for damage_type,multiplier in pairs( resistances ) do
                if multiplier ~= 1 then
                    local resistance = ComponentObjectGetValue2( damage_model, "damage_multipliers", damage_type )
                    resistance = resistance * multiplier
                    ComponentObjectSetValue2( damage_model, "damage_multipliers", damage_type, resistance )
                end
            end
            if critical_damage_resistance ~= 1.0 then
                ComponentSetValue2( damage_model, "critical_damage_resistance", ComponentGetValue2( damage_model, "critical_damage_resistance" ) * critical_damage_resistance )
            end
        end
        
        TryAdjustMaxHealth( e, function( max, current )
            return math.pow((max + bonus_health) * health_multiplier * orb_multiplier * distance_multiplier, 0.94)
        end)

        local attack_speed_divisor = 1.15 + 0.04 * places_visited
        local minimum_attack_frames = 6
        if is_carnage_mode then attack_speed_divisor = 1.25 + 0.08 * places_visited end

        local animal_ais = EntityGetComponent( e, "AnimalAIComponent" ) or {}
        if #animal_ais > 0 then
            for _,ai in pairs( animal_ais ) do
                ComponentSetValues( ai, {
                    aggressiveness_min=100,
                    aggressiveness_max=100,
                    escape_if_damaged_probability=0,
                    attack_if_damaged_probability=100,
                    hide_from_prey=false,
                    needs_food=false,
                    sense_creatures=true,
                    attack_only_if_attacked=false,
                    dont_counter_attack_own_herd=true,
                    creature_detection_angular_range_deg=180,
                })
                ComponentAdjustValues( ai, {
                    attack_melee_frames_between = function(value) return math.max( math.min( value, minimum_attack_frames ), math.ceil( tonumber( value ) / attack_speed_divisor )) end,
                    attack_dash_frames_between = function(value) return math.max( math.min( value, minimum_attack_frames ), math.ceil( tonumber( value ) / attack_speed_divisor )) end,
                    attack_ranged_frames_between = function(value) return math.max( math.min( value, minimum_attack_frames ), math.ceil( tonumber( value ) / attack_speed_divisor )) end,
                })
            end
        end
    end
    
    if speed_multiplier ~= 1 then
        local character_platforming = EntityGetFirstComponent( e, "CharacterPlatformingComponent" )
        if character_platforming ~= nil then
            ComponentAdjustValues( character_platforming, {
                fly_smooth_y            = function(value) return false end,
                accel_x                 = function(value) return value * speed_multiplier end,
                accel_x_air             = function(value) return value * speed_multiplier end,
                jump_velocity_x         = function(value) return value * speed_multiplier end,
                jump_velocity_y         = function(value) return value * speed_multiplier end,
                fly_speed_mult          = function(value) return value * speed_multiplier end,
                fly_speed_max_up        = function(value) return value * speed_multiplier end,
                fly_speed_max_down      = function(value) return value * speed_multiplier end,
                fly_speed_change_spd    = function(value) return value * speed_multiplier end,
                run_velocity            = function(value) return value * speed_multiplier end,
                fly_velocity_x          = function(value) return value * speed_multiplier end,
                velocity_min_x          = function(value) return value * speed_multiplier end,
                velocity_max_x          = function(value) return value * speed_multiplier end,
                velocity_min_y          = function(value) return value * speed_multiplier end,
                velocity_max_y          = function(value) return value * speed_multiplier end,
            })
        end
    end
end