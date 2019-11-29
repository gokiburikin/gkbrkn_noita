local x, y = EntityGetTransform( player_entity );

if EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_player_update" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_player_update",
        script_source_file="files/gkbrkn/misc/player_update.lua",
        execute_every_n_frame="1",
    });
end

if EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_player_damage_received" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_player_damage_received",
        script_damage_received="files/gkbrkn/misc/player_damage_received.lua",
    });
end

local init_check_flag = "gkbrkn_player_new_game";
if GameHasFlagRun( init_check_flag ) == false then
    GameAddFlagRun( init_check_flag );
    DoFileEnvironment( "files/gkbrkn/misc/loadouts/init.lua", { player_entity = player_entity } );

    DoFileEnvironment( "files/gkbrkn/misc/random_start/init.lua", { player_entity = player_entity } );

    local inventory = EntityGetNamedChild( player_entity, "inventory_quick" );
    if inventory ~= nil then
        if CONTENT[ITEMS.SpellBag].enabled() then
            EntityAddChild( inventory, EntityLoad( "files/gkbrkn/misc/spell_bag/spell_bag.xml", x, y ) );
        end
    end
end