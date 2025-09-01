local entity = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity )
local correction_distance = 36

dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )

local nearby_entities = EntityGetInRadiusWithTag( x, y, correction_distance, "homing_target" )
if #nearby_entities == 0 then return end

local target = nearby_entities[ math.ceil( math.random() * #nearby_entities ) ]
if target == nil then return end

local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" )
local shooter = ComponentGetValue2( projectile, "mWhoShot" )
if target == shooter then return end

local damaged_entities = {}
local damaged_entities_string = EntityGetVariableString( entity, "gkbrkn_damaged_entities","" )
for word in string.gmatch( damaged_entities_string, '([^,]+)' ) do
    damaged_entities[tostring(word)] = true
end
--[[ TODO fix this when someone figures this out
if GameGetFrameNum() % 60 == 0 then
    for _,c_type in pairs( {
        "int","string","float"
        --"unsigned int","uint","unsigned","unsigned short","unsigned short int"
    })do
        local damaged_entities = ComponentGetVector( projectile, "mDamagedEntities", c_type )
    end
end
]]
if damaged_entities[tostring(entity)] ~= true then
    local tx, ty = EntityGetFirstHitboxCenter( target )
    if tx == nil or ty == nil then
        tx, ty = EntityGetTransform( target )
    end
    local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" )
    local vx, vy = ComponentGetValue2( velocity, "mVelocity" )
    local angle = math.atan2( vy, vx )
    local target_angle = math.atan2( ty - y, tx - x )
    local magnitude = math.sqrt( vx * vx + vy * vy )
    local distance = math.sqrt( math.pow( tx - x, 2 ) + math.pow( ty - y, 2 )  )
    if distance <= 12 then
        EntitySetVariableString( entity, "gkbrkn_damaged_entities",damaged_entities_string..entity.."," )
    end
    ComponentSetValue2( velocity, "mVelocity", math.cos( target_angle ) * magnitude, math.sin( target_angle ) * magnitude )
end
