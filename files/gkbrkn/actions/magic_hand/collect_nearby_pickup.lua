local e = GetUpdatedEntityID()
local x, y = EntityGetTransform( e )
local player = EntityGetWithTag( "player_unit" )[1]
if not player then return end

local sign = function(v) return v < 0 and -1 or 1 end
local magnitude = function(x,y) return ( x ^ 2 + y ^ 2 ) ^ 0.5 end
local clamp = function(v,n,x) return math.min( math.max( v, n ), x ) end

local px, py = EntityGetTransform( player )

for k,v in pairs(EntityGetInRadiusWithTag( x, y, 10, "item_pickup" )) do
    EntitySetTransform( v, px, py )
end

for k,g in pairs(EntityGetInRadiusWithTag( x, y, 10, "gold_nugget" )) do
    local ex, ey = EntityGetTransform(g)
    local angle = math.atan2( py - ey, px - ex ) + ((math.random() - 0.5) * 2.0 * 0.27)
    local p = EntityGetFirstComponent( g, "PhysicsBodyComponent" )
    local mass = ComponentGetValue2( p, "mPixelCount" )
    local vx, vy = PhysicsVecToGameVec(PhysicsGetComponentVelocity( g, p ))
    local tx, ty = px - ex, py - ey
    local angle = math.atan2( ty, tx )
    local m = clamp( magnitude(tx,ty), 100, 150 ) * math.random( 0.7, 1.0 )
    tx = math.cos( angle ) * m
    ty = math.sin( angle ) * m
    PhysicsApplyForce( g, -vx, -vy )
    PhysicsApplyForce( g, GameVecToPhysicsVec(tx) * mass * 0.4, GameVecToPhysicsVec(ty) * mass * 0.4 )
end