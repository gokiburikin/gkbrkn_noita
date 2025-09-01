dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
local e = GetUpdatedEntityID()
local projectile = EntityGetFirstComponentIncludingDisabled( e, "ProjectileComponent" )
if not projectile then return EntityKill( e ) end

local who_shot = ComponentGetValue2( projectile, "mWhoShot" )
if who_shot == 0 then return EntityKill( e ) end

local link_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_take_damage/trigger_entity.xml" )
EntityAddChild( e, link_entity )
EntitySetVariableNumber( e, "gkbrkn_soft_parent", who_shot )

local has_damage_received_script = false
for _,lua in pairs(EntityGetComponentIncludingDisabled( who_shot, "LuaComponent") or {}) do
    if ComponentGetValue2( lua, "script_damage_received" ) == "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_take_damage/damage_received.lua" then
        has_damage_received_script = true
        break
    end
end
if not has_damage_received_script then
    EntityAddComponent( who_shot, "LuaComponent", {
        script_damage_received="mods/gkbrkn_noita/files/gkbrkn/actions/trigger_take_damage/damage_received.lua"
    } )
end