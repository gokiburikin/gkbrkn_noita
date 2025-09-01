local e = GetUpdatedEntityID()
for _,lua in pairs(EntityGetComponentIncludingDisabled( e, "LuaComponent" ) or {}) do
    if ComponentGetValue2( lua, "script_source_file" ) == "mods/gkbrkn_noita/files/gkbrkn/actions/siphon/hit_effect.lua" then
        EntityRemoveComponent( e, lua )
        EntityRemoveFromParent( e )
        break
    end
end