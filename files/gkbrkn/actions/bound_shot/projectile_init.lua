dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    ComponentSetValue( projectile, "lifetime", "-1" );
    for _,bound_entity in pairs( EntityGetWithTag("gkbrkn_bound_entity") or {} ) do
        EntityKill( bound_entity );
    end
    EntityAddTag( entity, "gkbrkn_bound_entity" );
end