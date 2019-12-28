dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent(entity, "ProjectileComponent");
if projectile ~= nil then
    local damage = tonumber( ComponentGetValue( projectile, "damage" ) );
    EntitySetVariableNumber( entity, "gkbrkn_lifetime_initial_damage", damage );
    local damage_by_types = ComponentObjectGetMembers( projectile, "damage_by_type" ) or {};
    local active_types = {};
    for type,_ in pairs(damage_by_types) do
        local amount = tonumber( ComponentObjectGetValue( projectile, "damage_by_type", type ) );
        if amount == amount and amount ~= 0 then
            table.insert( active_types, type.."="..amount );
            --EntitySetVariableNumber( entity, "gkbrkn_lifetime_initial_damage_"..type, amount );
        end
    end
    if #active_types > 0 then
        EntitySetVariableString( entity, "gkbrkn_lifetime_initial_damage_types", table.concat(active_types,",") );
    end
end