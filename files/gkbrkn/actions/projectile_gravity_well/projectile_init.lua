local entity = GetUpdatedEntityID();
EntityAddTag( entity, "gkbrkn_projectile_gravity_well" );
local projectile_entities = EntityGetWithTag("gkbrkn_projectile_gravity_well");
if #projectile_entities == tonumber( GlobalsGetValue( "gkbrkn_projectiles_fired", -1 ) ) then
    local previous_projectile = nil;
    local leader = nil;
    for i,projectile in pairs(projectile_entities) do
        EntityRemoveTag( projectile, "gkbrkn_projectile_gravity_well" );
        if previous_projectile ~= nil then
            if EntityGetParent( projectile ) == 0 then
                EntityAddChild( leader, projectile );
            end
            EntityAddComponent( projectile, "LuaComponent", { script_source_file="files/gkbrkn/actions/wip/projectile_update.lua", execute_event_n_frame="1" } );
        else
            leader = projectile;
        end
        previous_projectile = projectile;
    end
end
