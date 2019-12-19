dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity    = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    EntitySetVariableNumber( entity, "gkbrkn_bounces_last", ComponentGetValue( projectile, "bounces_left" ) );
    EntitySetVariableNumber( entity, "gkbrkn_bounce_damage_initial", ComponentGetValue( projectile, "damage" ) );
    local damage_by_types = ComponentObjectGetMembers( projectile, "damage_by_type" ) or {};
    for type,_ in pairs(damage_by_types) do
        local amount = tonumber( ComponentObjectGetValue( projectile, "damage_by_type", type ) );
        if amount == amount and amount ~= 0 then
            EntitySetVariableNumber( entity, "gkbrkn_bounce_initial_damage_"..type, amount );
        end
    end
end