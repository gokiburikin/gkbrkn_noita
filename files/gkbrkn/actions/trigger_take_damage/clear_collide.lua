local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile then ComponentSetValue2( projectile, "collide_with_tag", "" ); end
