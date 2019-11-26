dofile_once( "files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent(entity, "ProjectileComponent");
if projectile ~= nil then
    local damage = tonumber( ComponentGetValue( projectile, "damage" ) );
    EntitySetVariableNumber( entity, "gkbrkn_lifetime_damage_initial_damage", damage );
end