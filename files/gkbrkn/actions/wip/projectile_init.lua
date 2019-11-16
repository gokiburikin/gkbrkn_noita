local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local shooter_herd = ComponentGetValue( projectile, "mShooterHerdId" );
    GamePrint( "shooter herd: ".. shooter_herd );
end