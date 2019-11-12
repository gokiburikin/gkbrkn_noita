local entity_id    = GetUpdatedEntityID();
local pos_x, pos_y = EntityGetTransform( entity_id );

local projectile_component = EntityGetFirstComponent( entity_id, "ProjectileComponent" );
if projectile_component ~= nil then
    local bounce_energy = tonumber( ComponentGetValue( projectile_component, "bounce_energy" ) );
    ComponentSetValue( projectile_component, tostring( bounce_energy * 1.25 ) );
    local total_bounces = ComponentGetValue( projectile_component, "bounces_left" );
    local total_damage = ComponentGetValue( projectile_component, "damage" );
    EntityAddComponent( entity_id, "VariableStorageComponent", {
        _tags="gkbrkn_bounces_last",
        name="gkbrkn_bounces_last",
        value_int=total_bounces
    });
    EntityAddComponent( entity_id, "VariableStorageComponent", {
        _tags="gkbrkn_damage_initial",
        name="gkbrkn_damage_initial",
        value_string=tostring(total_damage)
    });
end