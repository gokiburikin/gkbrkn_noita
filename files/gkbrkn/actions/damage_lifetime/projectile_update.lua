dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local script_rate = 5;
    local damage_rate = 30 / script_rate;
    local x, y = EntityGetTransform( entity );
    local current_damage = tonumber( ComponentGetValue( projectile, "damage" ) );
    local initial_damage = EntityGetVariableNumber( entity, "gkbrkn_lifetime_initial_damage" );
    ComponentSetValue( projectile, "damage", tostring( current_damage + initial_damage / damage_rate ) );
    local active_damage_types_string = EntityGetVariableString( entity, "gkbrkn_lifetime_initial_damage_types", nil );
    if active_damage_types_string ~= nil then
        for damage_type_amount_pair in string.gmatch(active_damage_types_string, '([^,]+)') do
            local iterator = string.gmatch(damage_type_amount_pair, '([^=]+)');
            local damage_type, amount = iterator(), tonumber(iterator());
            local current_type_damage = tonumber( ComponentObjectGetValue( projectile, "damage_by_type", damage_type ) );
            ComponentObjectSetValue( projectile, "damage_by_type", damage_type, tostring( current_type_damage + amount / damage_rate ) );
        end
    end
end
