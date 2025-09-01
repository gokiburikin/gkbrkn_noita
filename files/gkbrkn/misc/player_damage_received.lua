local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
    local entity = GetUpdatedEntityID()

    if projectile_thats_responsible ~= 0 and not EntityHasTag( projectile_thats_responsible, "projectile_player" ) then
        local projectile_file = EntityGetNamedVariable( projectile_thats_responsible, "projectile_file" )
        if projectile_file then
            projectile_file = ComponentGetValue2( projectile_file, "value_string" )
            if #projectile_file > 0 then
                EntitySetVariableString( entity, "gkbrkn_blue_magic_projectile_file", projectile_file )
            end
        end
        local p = EntityGetFirstComponent( projectile_thats_responsible, "ProjectileComponent" )
        if p then
            local damages = get_projectile_damages(p)
            local non_zero_damages = {}
            for k,v in pairs(damages) do
                if v ~= 0 then
                    table.insert( non_zero_damages, k )
                end
            end
            local damage_type = non_zero_damages[math.ceil(math.random() * #non_zero_damages)]
            local damage = get_highest_projectile_damage(p)
            EntitySetVariableString( entity, "gkbrkn_green_magic_damage_type", damage_type )
            EntitySetVariableNumber( entity, "gkbrkn_red_magic_damage", damage )
        end
    end

    if EntityHasVarTag( entity_thats_responsible, "gkbrkn_champion_neutralize" ) then
        local x, y = EntityGetTransform( entity )
        local effect_id = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/neutralize/neutralize.xml", x, y )
        EntityAddChild( entity, effect_id )
        add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/neutralized.png", "Neutralized", "Your spells have been neutralized.", false )
    end

    if EntityHasVarTag( entity_thats_responsible, "gkbrkn_champion_thief") then
        local wallet = EntityGetFirstComponent( entity, "WalletComponent" )
        if wallet ~= nil then
            local money = ComponentGetValue2( wallet, "money" )
            local x,y = EntityGetTransform( entity )
            SetRandomSeed( x + GameGetFrameNum(), y )
            local amount = math.min( 10, math.floor( money / 10 ) )
            local value = math.max( money / 10 / 10, 10 )
            for i=1,amount do
                local gold = EntityLoad( "data/entities/items/pickup/goldnugget_10.xml", x, y )
                if value > 10 then
                    local components = EntityGetComponent( gold, "VariableStorageComponent" ) or {}
                    for _,component in pairs( components ) do 
                        if ComponentGetValue2( component, "name" ) == "gold_value" then
                            ComponentSetValue2( component, "value_int", value )
                        end
                    end
                end
                local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
                if comp_worldstate then
                    if ComponentGetValue2( comp_worldstate, "perk_gold_is_forever" ) then
                        local lifetime_components = EntityGetComponent( gold, "LifetimeComponent" )
                        if lifetime_components then
                            for _,c in ipairs(lifetime_components) do
                                EntityRemoveComponent( gold, c )
                            end
                        end
                    end
                end
                PhysicsApplyForce( gold, Random( 0, 1 ) == 0 and Random( 100, 300 ) or Random( -100, -300 ), Random( -50, -100 ) )
            end
            ComponentSetValue2( wallet, "money", money - amount * value )
        end
    end

    if EntityHasVarTag( entity_thats_responsible, "gkbrkn_champion_heart_breaker" ) then
        TryAdjustMaxHealth( entity, function( max, current )
            if damage < 0 then return max end
            return max - damage * 0.5
        end, false )
    end

    local invincibility_duration = EntityGetVariableNumber( entity, "gkbrkn_invincibility_frames", 0 )
    local duration = setting_get( MISC.InvincibilityFrames.Duration, 0 )
    if duration > 0 and invincibility_duration < duration then
        invincibility_duration = duration
    end

    if invincibility_duration > 0 and damage > 0 then
        local components = EntityGetComponent( entity, "DamageModelComponent" )
        if components ~= nil and entity_thats_responsible ~= 0 then
            for _,data_component in pairs( components ) do
                local current_invincibility_frames = ComponentGetValue2( data_component, "invincibility_frames" )
                -- only add invincibility frames if we are not currently invincible
                if current_invincibility_frames <= 0 then
                    ComponentSetValue2( data_component, "invincibility_frames", invincibility_duration )
                end
            end
        end
    end

    return damage
end