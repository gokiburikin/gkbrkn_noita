dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    EntitySetVariableNumber( entity, "gkbrkn_shooter", ComponentGetValue2( projectile, "mWhoShot" ) );
    make_projectile_not_damage_shooter( entity );
    adjust_entity_damage( entity,
        function( current_damage ) return current_damage * 0.3; end,
        function( current_damages )
            for type,damage in pairs( current_damages ) do
                if damage ~= 0 then
                    current_damages[type] = damage * 0.3;
                end
            end
            return current_damages;
        end,
        function( current_damage ) return current_damage * 0.3; end,
        function( current_damage ) return current_damage * 0.3; end,
        function( current_damage ) return current_damage * 0.3; end
    );
    EntityAddComponent( entity, "LuaComponent", {
		script_shot="mods/gkbrkn_noita/files/gkbrkn/actions/protective_enchantment/shot.lua"
    } );
end

