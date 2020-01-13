dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");

function shot( entity )
    local shooter_entity = GetUpdatedEntityID();
    local force_shooter = nil;
    if shooter_entity ~= nil then
        force_shooter = EntityGetVariableNumber( shooter_entity, "gkbrkn_shooter", nil );
    end

    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    if projectile ~= nil then
        make_projectile_not_damage_shooter( entity, force_shooter );
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
end