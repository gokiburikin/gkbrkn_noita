dofile_once("data/scripts/lib/utilities.lua")
local e = GetUpdatedEntityID()
if e == 0 then return end

for _,p in pairs(EntityGetComponent( e, "ProjectileComponent" ) or {}) do
	ComponentSetValue2( p, "bounce_fx_file", "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_bounce/trigger_entity_spawner.xml" )
end