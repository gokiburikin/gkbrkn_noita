local entity = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity )
local rays = 12
local deviation_angle = 100 / 180 * math.pi

function angle_difference( target_angle, starting_angle )
    return math.atan2( math.sin( target_angle - starting_angle ), math.cos( target_angle - starting_angle ) )
end

local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" )
if not velocity then return end

local vx, vy = ComponentGetValue2( velocity, "mVelocity" )
local magnitude = math.sqrt( vx * vx + vy * vy )
local ray_length = math.sqrt( magnitude ) * 0.5
if magnitude == 0 then return end

local angle = math.atan2( vy, vx )
local normal_found, normal_x, normal_y, normal_dist = GetSurfaceNormal( x + math.cos(angle) * ray_length, y + math.sin(angle) * ray_length, ray_length, rays )
if normal_found then
    local normal_angle = math.atan2( normal_y, normal_x )
    local difference = angle_difference(angle, normal_angle)
    if math.abs( difference ) < deviation_angle then
        local sign_difference = difference / math.abs( difference )
        local target_vx = normal_y * magnitude * -sign_difference
        local target_vy = normal_x * magnitude * sign_difference
        local easing = math.max( 1, normal_dist * 0.36 )
        local new_vx = vx + (target_vx - vx) / easing
        local new_vy = vy + (target_vy - vy) / easing
        ComponentSetValue2( velocity, "mVelocity", new_vx, new_vy )
    end
end