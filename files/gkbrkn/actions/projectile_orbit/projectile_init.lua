local entity = GetUpdatedEntityID();
EntityAddTag( entity, "gkbrkn_projectile_orbit" );
local projectile_entities = EntityGetWithTag("gkbrkn_projectile_orbit");
if #projectile_entities == tonumber( GlobalsGetValue( "gkbrkn_projectiles_fired", -1 ) ) then
    local previous_projectile = nil;
    local leader = nil;
    for i,projectile in pairs(projectile_entities) do
        EntityRemoveTag( projectile, "gkbrkn_projectile_orbit" );
        if previous_projectile ~= nil then
            if EntityGetParent( projectile ) == 0 then
                EntityAddChild( leader, projectile );
            end
            EntityAddComponent( projectile, "VariableStorageComponent", {
                _tags="gkbrkn_orbit",
                name="gkbrkn_orbit",
                value_string=tostring(#projectile_entities);
                value_int=tostring(i-1);
            } );
            EntityAddComponent( projectile, "LuaComponent", { script_source_file="files/gkbrkn/actions/projectile_orbit/projectile_update.lua", execute_on_added="1" } );
        else
            leader = projectile;
        end
        previous_projectile = projectile;
    end
end
