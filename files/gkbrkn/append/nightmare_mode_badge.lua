dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );

local _OnPlayerSpawned = OnPlayerSpawned;
function OnPlayerSpawned( player_entity )
    _OnPlayerSpawned();
    local badge = load_dynamic_badge( "nightmare_mode", nil );
    if badge ~= nil then
        EntityAddChild( player_entity, badge );
    end
end