dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    EntitySetVariableNumber( entity, "gkbrkn_shooter", ComponentGetValue2( projectile, "mWhoShot" ) );
    make_projectile_not_damage_shooter( entity );
    EntityAddComponent( entity, "LuaComponent", {
		script_shot="mods/gkbrkn_noita/files/gkbrkn/actions/protective_enchantment/shot.lua"
    } );
end

