if _ONCE == nil then
    _ONCE = true;
    dofile( "files/gkbrkn/lib/variables.lua");
end
local entity = GetUpdatedEntityID();
EntityAddTag( entity, "gkbrkn_projectile_orbit" );
local projectile_entities = EntityGetWithTag("gkbrkn_projectile_orbit");
if #projectile_entities == tonumber( GlobalsGetValue( "gkbrkn_projectiles_fired", -1 ) ) then
    local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
    ComponentSetValueVector2( velocity, "mVelocity", 0, 0 );
    local velocity_x, velocity_y = ComponentGetValueVector2( velocity, "mVelocity" );
    local previous_projectile = nil;
    local leader = nil;
    for i,projectile in pairs(projectile_entities) do
        EntityRemoveTag( projectile, "gkbrkn_projectile_orbit" );
        if previous_projectile ~= nil then
            EntitySetVariableString( projectile, "gkbrkn_soft_parent", tostring(leader) );
            EntityAddComponent( projectile, "VariableStorageComponent", {
                _tags="gkbrkn_orbit",
                name="gkbrkn_orbit",
                value_string=tostring(#projectile_entities);
                value_int=tostring(i-1);
            } );
        else
            leader = projectile;
        end
        previous_projectile = projectile;
    end
end
