local entity = GetUpdatedEntityID();
local parent = EntityGetParent( entity );
if parent ~= nil then
    EntityAddComponent( parent, "LuaComponent", {
        script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/blood_tweak/projectile_damage_received.lua"
    } );
end