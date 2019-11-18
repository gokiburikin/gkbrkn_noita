if _ONCE == nil then
    _ONCE = true;
    dofile( "files/gkbrkn/lib/variables.lua");
end
local entity = GetUpdatedEntityID();
EntityAddTag( entity, "gkbrkn_projectile_gravity_well" );
local projectile_entities = EntityGetWithTag("gkbrkn_projectile_gravity_well");
if #projectile_entities == tonumber( GlobalsGetValue( "gkbrkn_projectiles_fired", -1 ) ) then
    local previous_projectile = nil;
    local leader = nil;
    for i,projectile in pairs(projectile_entities) do
        EntityRemoveTag( projectile, "gkbrkn_projectile_gravity_well" );
        if previous_projectile ~= nil then
            EntitySetVariableString( projectile, "gkbrkn_soft_parent", tostring(leader) );
        else
            leader = projectile;
        end
        previous_projectile = projectile;
    end
end
