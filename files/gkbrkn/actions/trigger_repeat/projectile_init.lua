dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
EntitySetVariableNumber( entity, "gkbrkn_spawn_time", GameGetFrameNum() );
local link_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/trigger_entity.xml" );
EntityAddChild( entity, link_entity );

local projectile_index = EntityGetVariableNumber( entity, "gkbrkn_projectile_index", 0 );
if projectile_index then
    local x, y = EntityGetTransform( entity );
    local parent = nil;
    for _,candidate in pairs(EntityGetInRadius( x, y, 10 ) or {}) do
        local candidate_projectile_index = EntityGetVariableNumber( candidate, "gkbrkn_projectile_index", 0 );
        if candidate_projectile_index == projectile_index - 1 then
            parent = candidate;
            break;
        end
    end
    if parent then EntityAddChild( parent, entity ); end

    local projectile_data = GlobalsGetValue("gkbrkn_projectile_data_"..tostring(projectile_index) );
    -- TODO this isn't a solution that can work as long as global data can't be cleared
    -- GlobalsSetValue( "gkbrkn_projectile_data_"..tostring(projectile_index), nil );
    if projectile_data then
        EntitySetVariableNumber( entity, "gkbrkn_trigger_rate", tonumber(projectile_data) );
    end
end
