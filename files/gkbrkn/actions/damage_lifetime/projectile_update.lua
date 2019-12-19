dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local current_damage = tonumber( ComponentGetValue( projectile, "damage" ) );
    local initial_damage = EntityGetVariableNumber( entity, "gkbrkn_lifetime_initial_damage" );
    ComponentSetValue( projectile, "damage", tostring( current_damage + initial_damage / 30 ) );
    local damage_by_types = ComponentObjectGetMembers( projectile, "damage_by_type" ) or {};
    for type,_ in pairs( damage_by_types ) do
        local current_type_damage = tonumber( ComponentObjectGetValue( projectile, "damage_by_type", type ) );
        local initial_type_damage = EntityGetVariableNumber( entity, "gkbrkn_lifetime_initial_damage_"..type, 0.0 );
        if initial_type_damage ~= 0 then
            ComponentObjectSetValue( projectile, "damage_by_type", type, tostring( current_type_damage + initial_type_damage / 30 ) );
        end
    end
end