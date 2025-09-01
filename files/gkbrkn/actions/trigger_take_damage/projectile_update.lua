dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")

local e = GetUpdatedEntityID()
local p = EntityGetVariableNumber( e, "gkbrkn_soft_parent", 0 )
if p ~= 0 then
    if not EntityGetIsAlive(p) then EntityKill(e) return end
    local px, py = EntityGetFirstHitboxCenter( p )
    EntitySetTransform( e, px, py )
end

local v = EntityGetFirstComponent(e, "VelocityComponent" )
if v then
    local vx, vy = ComponentGetValue2( v, "mVelocity" )
    local angle = math.atan2( vy, vx )
    ComponentSetValue2( v, "mVelocity", math.cos(angle), math.sin(angle) )
end

if EntityHasVarTag( e, "gkbrkn_trigger" ) then
    EntityRemoveVarTag(e, "gkbrkn_trigger" )
    EntityAddVarTag( e, "gkbrkn_clear_tag" )
    if GameGetFrameNum() >= EntityGetVariableNumber( e, "gkbrkn_take_damage_next", 0 ) then
        local p = EntityGetFirstComponentIncludingDisabled( e, "ProjectileComponent" )
        ComponentSetValue2( p, "collide_with_tag", "gkbrkn_take_damage_trigger" )
        EntitySetVariableNumber( e, "gkbrkn_take_damage_next", GameGetFrameNum() + 60 )
    end
elseif EntityHasVarTag( e, "gkbrkn_clear_tag" ) then
    local p = EntityGetFirstComponentIncludingDisabled( e, "ProjectileComponent" )
    ComponentSetValue2( p, "collide_with_tag", "" )
    EntityRemoveVarTag( e, "gkbrkn_clear_tag" )
end