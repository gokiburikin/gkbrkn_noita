local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
local entity = GetUpdatedEntityID();
local children = EntityGetAllChildren( entity );
local rows = 6;
local badge_width = 10;
local badge_height = 10;
local parent = EntityGetParent( entity );
if children and parent then
    local width,height = EntityGetFirstHitboxSize( parent );
    if width == nil or height == nil then
        width = 0;
        height = 0;
    end
    if setting_get( MISC.ChampionEnemies.ShowIconsFlag ) then
        local badge_index = 0;
        for y=0,math.ceil( #children / rows ) - 1 do
            local badges_remaining = #children - badge_index;
            for x=0,math.min( badges_remaining, rows ) - 1 do
                local child = children[ badge_index + 1 ];
                if child then
                    local offset_x = x * badge_width;
                    local offset_y = y * badge_height;
                    local sprite = EntityGetFirstComponent( child, "SpriteComponent" );
                    if sprite then
                        ComponentSetValue2( sprite, "visible", true );
                        ComponentSetValue2( sprite, "offset_x", -offset_x + ( math.min( badges_remaining, rows ) * badge_width ) * 0.5 );
                        ComponentSetValue2( sprite, "offset_y", height * 2 + offset_y );
                        ComponentSetValue2( sprite, "never_ragdollify_on_death", true );
                    end
                    badge_index = badge_index + 1;
                end
            end
        end
    else
        for index,child in pairs( children ) do
            local sprite = EntityGetFirstComponent( child, "SpriteComponent" );
            ComponentSetValue2( sprite, "visible", false );
        end
    end
end