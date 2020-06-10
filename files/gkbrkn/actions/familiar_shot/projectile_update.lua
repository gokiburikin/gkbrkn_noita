dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local correctionDistance = 200;
local angleEasing = 1.00;

local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
local shooter = ComponentGetValue( projectile, "mWhoShot" );
if shooter then
    local sx, sy = EntityGetTransform( shooter );
    local distanceFromShooter = math.sqrt( math.pow( sx - x, 2 ) + math.pow( sy - y, 2 )  );
    if distanceFromShooter >= correctionDistance then
        local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
        local angle = math.atan2( vy, vx );
        local targetAngle = math.atan2( sy - y, sx - x );
        local newAngle = EaseAngle( angle, targetAngle, angleEasing );
        local magnitude = math.sqrt( vx * vx + vy * vy );
        ComponentSetValueVector2( velocity, "mVelocity", math.cos( newAngle ) * magnitude, math.sin( newAngle ) * magnitude );
    end
end

