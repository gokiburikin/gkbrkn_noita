dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent(entity, "ProjectileComponent");
if projectile ~= nil then
    local damage = tonumber( ComponentGetValue( projectile, "damage" ) );
    EntitySetVariableNumber( entity, "gkbrkn_lifetime_initial_damage", damage );
    local damage_by_types = ComponentObjectGetMembers( projectile, "damage_by_type" ) or {};
    for type,_ in pairs(damage_by_types) do
        local amount = tonumber( ComponentObjectGetValue( projectile, "damage_by_type", type ) );
        if amount == amount and amount ~= 0 then
            EntitySetVariableNumber( entity, "gkbrkn_lifetime_initial_damage_"..type, amount );
        end
    end
end