dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
local entity = GetUpdatedEntityID();
local projectile_index = tonumber( GlobalsGetValue("gkbrkn_projectile_index") );
if projectile_index == nil then
    projectile_index = 0;
    GlobalsSetValue("gkbrkn_projectile_index", "0");
end
if EntityGetVariableNumber( entity, "gkbrkn_projectile_index", 0 ) == 0 then
    EntitySetVariableNumber( entity, "gkbrkn_projectile_index", projectile_index );
    GlobalsSetValue("gkbrkn_projectile_index", tostring( projectile_index + 1 ) );
end