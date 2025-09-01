local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua")

local e = GetUpdatedEntityID()
local x,y = EntityGetTransform( e )
local parent = EntityGetWithTag("player_unit")[1]
if not parent then return end
local px, py = EntityGetTransform( parent )

local pspc = EntityGetFirstComponentIncludingDisabled( e, "PlatformShooterPlayerComponent" )
if pspc then
    -- Mouse_left
    if InputIsMouseButtonDown( 1 ) then
        ComponentSetValue2( pspc, "mForceFireOnNextUpdate", true )
    end
end

local v = EntityGetFirstComponentIncludingDisabled( e, "VelocityComponent" )
if v then
    local mx, my = DEBUG_GetMouseWorld()
    local angle = math.atan2( my - py, mx - px )
    local magnitude = math.min( ((mx-px) ^ 2 + (my-py) ^ 2) ^ 0.5, 30 )
    local vx, vy = (px + math.cos(angle) * magnitude) - x, (py + math.sin(angle) * magnitude) - y
    ComponentSetValue2( v, "mVelocity", vx * 3, vy * 3 )
end

local controls = EntityGetFirstComponentIncludingDisabled( e, "ControlsComponent" )
if controls then
    local mx, my = DEBUG_GetMouseWorld()
    local angle = math.atan2( my-y, mx-x )
    ComponentSetValue2( controls, "mAimingVector", math.cos(angle), math.sin(angle) )
    ComponentSetValue2( controls, "mMousePosition", mx, my )
     
end

local distance_to_parent = math.sqrt( math.pow( px - x, 2 ) + math.pow( py - y, 2 ) )
if distance_to_parent >= MISC.PerkOptions.LivingWand.TeleportDistance then
    EntityApplyTransform( e, FindFreePositionForBody( px, py, 0, 0, 8 ) )
end

for _,c in pairs(EntityGetAllChildren(e)) do
    if EntityGetName(c) == "inventory_quick" then
        local wands = EntityGetAllChildren( c, "wand" )
        if wands and #wands > 0 then
            local mx, my = DEBUG_GetMouseWorld()
            local angle = math.atan2( my-y, mx-x )
            EntityApplyTransform( wands[1], x, y, angle )
        end
    end
end