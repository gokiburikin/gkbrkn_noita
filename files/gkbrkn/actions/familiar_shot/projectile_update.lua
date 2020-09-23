dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local correctionDistance = 200;
local angleEasing = 1.00;

local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
local shooter = ComponentGetValue2( projectile, "mWhoShot" );
if shooter then
    local sx, sy = EntityGetTransform( shooter );
    local distanceFromShooter = math.sqrt( math.pow( sx - x, 2 ) + math.pow( sy - y, 2 )  );
    if distanceFromShooter >= correctionDistance then
        local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
        local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
        local angle = math.atan2( vy, vx );
        local targetAngle = math.atan2( sy - y, sx - x );
        local newAngle = EaseAngle( angle, targetAngle, angleEasing );
        local magnitude = math.sqrt( vx * vx + vy * vy );
        ComponentSetValue2( velocity, "mVelocity", math.cos( newAngle ) * magnitude, math.sin( newAngle ) * magnitude );
    end
end

