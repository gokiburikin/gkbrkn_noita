local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
local entity = GetUpdatedEntityID();
local children = EntityGetAllChildren( entity );
if children then
    if HasFlagPersistent( MISC.ChampionEnemies.ShowIconsFlag ) then
        local offset_x = #children * 4.5 - 9;
        local offset_y = 24;
        local parent = EntityGetParent( entity );
        if parent ~= nil then
            local width,height = EntityGetFirstHitboxSize( parent );
            if height ~= nil then
                offset_y = height + 18;
            end
        end
        for index,child in pairs( children ) do
            local sprite = EntityGetFirstComponent( child, "SpriteComponent" );
            ComponentSetValue2( sprite, "visible", true );
            ComponentSetValue2( sprite, "offset_x", -offset_x + ( index - 1 ) * 9 );
            ComponentSetValue2( sprite, "offset_y", offset_y );
        end
    else
        for index,child in pairs( children ) do
            local sprite = EntityGetFirstComponent( child, "SpriteComponent" );
            ComponentSetValue2( sprite, "visible", false );
        end
    end
end