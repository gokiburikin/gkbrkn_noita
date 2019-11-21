if _ONCE == nil then
    _ONCE = true;
    dofile( "files/gkbrkn/lib/variables.lua");
end
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local projectile_component = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile_component ~= nil then
    local current_damage = tonumber( ComponentGetValue( projectile_component, "damage" ) );
    local initial_damage = EntityGetVariableNumber( entity, "gkbrkn_lifetime_damage_initial_damage" );
    ComponentSetValue( projectile_component, "damage", tostring( current_damage + initial_damage / 60 ) );
end