dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/lerp.lua")
function shot( e )
    local v = EntityGetFirstComponent( e, "VelocityComponent" )
    if not v then return end
    local vx, vy = ComponentGetValue2( v, "mVelocity" )
    local magnitude = math.sqrt( vx * vx + vy * vy )
    local angle = math.atan2( vy, vx )
    local offset = 10 / 180 * math.pi
    vx = math.cos( angle + remap( math.random(), 0, 1, -offset, offset ) ) * remap( math.random(), 0, 1, magnitude * 0.9, magnitude * 1.1 )
    vy = math.sin( angle + remap( math.random(), 0, 1, -offset, offset ) ) * remap( math.random(), 0, 1, magnitude * 0.9, magnitude * 1.1 )
    ComponentSetValue2( v, "mVelocity", vx, vy )
end