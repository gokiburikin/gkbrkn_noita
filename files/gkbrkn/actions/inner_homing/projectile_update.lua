local e = GetUpdatedEntityID()

local v = EntityGetFirstComponentIncludingDisabled( e, "VelocityComponent")
if v then ComponentSetValue2( v, "mVelocity", 0, 0 ) end

local projectile = EntityGetFirstComponent( e, "ProjectileComponent" )
if not projectile then return end

local shooter = ComponentGetValue2( projectile, "mWhoShot" )
if not shooter or shooter == 0 or not EntityGetIsAlive( shooter ) then return end

EntityApplyTransform( e, EntityGetFirstHitboxCenter( shooter ) )