dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile ~= nil then
    local damage_plus_bounce_stacks = EntityGetVariableNumber( entity, "gkbrkn_damage_plus_bounce_stacks", 0 );
    if damage_plus_bounce_stacks > 0 then
        local buffable_bounces_remaining = EntityGetVariableNumber( entity, "gkbrkn_bounce_damage_remaining", 0 );
        if buffable_bounces_remaining > 0 then
            local last_bounces = EntityGetVariableNumber( entity, "gkbrkn_bounces_last" );
            local current_bounces = ComponentGetValue2( projectile, "bounces_left" );
            local bounces_done = math.min( last_bounces - current_bounces, buffable_bounces_remaining );
            if bounces_done > 0 then
                EntityAdjustVariableNumber( entity, "gkbrkn_bounce_damage_remaining", 0, function(value) return tonumber( value ) - bounces_done; end );
                EntitySetVariableNumber( entity, "gkbrkn_bounces_last", current_bounces );
                local initial_damage = EntityGetVariableNumber( entity, "gkbrkn_initial_damage" );
                local current_damage = ComponentGetValue2( projectile, "damage" );
                local new_damage = current_damage + initial_damage * 0.50 * damage_plus_bounce_stacks;
                ComponentSetValue2( projectile, "damage", new_damage );

                local active_damage_types_string = EntityGetVariableString( entity, "gkbrkn_initial_damage_types", nil );
                if active_damage_types_string ~= nil then
                    for damage_type_amount_pair in string.gmatch( active_damage_types_string, '([^,]+)' ) do
                        local iterator = string.gmatch( damage_type_amount_pair, '([^=]+)' );
                        local damage_type, initial_type_damage = iterator(), tonumber( iterator() );
                        local current_type_damage = ComponentObjectGetValue2( projectile, "damage_by_type", damage_type );
                        local new_type_damage = current_type_damage + initial_type_damage * 0.50 * damage_plus_bounce_stacks;
                        ComponentObjectSetValue2( projectile, "damage_by_type", damage_type, new_type_damage );
                    end
                end
            end
        end
    end

    local damage_plus_lifetime_stacks = EntityGetVariableNumber( entity, "gkbrkn_damage_plus_lifetime_stacks", 0 );
    local damage_plus_lifetime_limit = EntityGetVariableNumber( entity, "gkbrkn_damage_plus_lifetime_limit", 0 );
    if damage_plus_lifetime_stacks > 0 and GameGetFrameNum() < damage_plus_lifetime_limit then
        local script_rate = 1;
        local damage_rate = 30 / script_rate;
        local x, y = EntityGetTransform( entity );
        local current_damage = ComponentGetValue2( projectile, "damage" );
        local initial_damage = EntityGetVariableNumber( entity, "gkbrkn_initial_damage", 0 );
        local new_damage = current_damage + initial_damage / damage_rate * damage_plus_lifetime_stacks;
        ComponentSetValue2( projectile, "damage", new_damage );
        local active_damage_types_string = EntityGetVariableString( entity, "gkbrkn_initial_damage_types", nil );
        if active_damage_types_string ~= nil then
            for damage_type_amount_pair in string.gmatch( active_damage_types_string, '([^,]+)' ) do
                local iterator = string.gmatch( damage_type_amount_pair, '([^=]+)' );
                local damage_type, initial_type_damage = iterator(), tonumber( iterator() );
                local current_type_damage = ComponentObjectGetValue2( projectile, "damage_by_type", damage_type );
                local new_type_damage = current_type_damage + initial_type_damage / damage_rate * damage_plus_lifetime_stacks
                ComponentObjectSetValue2( projectile, "damage_by_type", damage_type, new_type_damage );
            end
        end
    end
end