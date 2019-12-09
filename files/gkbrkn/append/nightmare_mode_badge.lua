_OnPlayerSpawned = OnPlayerSpawned;
function OnPlayerSpawned( player_entity )
    _OnPlayerSpawned();
    local nightmare_mode_badge = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/badges/nightmare_mode.xml" );
    if nightmare_mode_badge ~= nil then
        EntityAddChild( player_entity, nightmare_mode_badge );
    end
end