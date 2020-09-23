dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");

function shot( entity )
    local shooter_entity = GetUpdatedEntityID();
    local force_shooter = nil;
    if shooter_entity ~= nil then
        force_shooter = EntityGetVariableNumber( shooter_entity, "gkbrkn_shooter", nil );
    end

    local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
    if projectile ~= nil then
        make_projectile_not_damage_shooter( entity, force_shooter );
        EntityAddComponent2( entity, "LuaComponent", {
            execute_on_added=true,
            script_shot="mods/gkbrkn_noita/files/gkbrkn/actions/protective_enchantment/shot.lua"
        } );
    end
end