local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile then ComponentSetValue2( projectile, "collide_with_tag", "" ); end
