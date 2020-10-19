dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
last_text = last_text or "";
local entity = GetUpdatedEntityID();
local current_text = EntityGetVariableString( entity, "gkbrkn_dps_tracker_text", "" );
if last_text ~= current_text then
    last_text = current_text;
    local width,height = EntityGetFirstHitboxSize( entity );
    local sprite = EntityGetFirstComponent( entity, "SpriteComponent", "gkbrkn_dps_tracker" );
    if sprite == nil then
        EntityLoadToEntity( "mods/gkbrkn_noita/files/gkbrkn/misc/dps_tracker_text.xml", entity );
        sprite = EntityGetFirstComponent( entity, "SpriteComponent", "gkbrkn_dps_tracker" );
    end
    if sprite then
        ComponentSetValue2( sprite, "offset_x", #current_text * 2 - 2 );
        ComponentSetValue2( sprite, "offset_y", height * 2 );
        ComponentSetValue2( sprite, "text", current_text );
        EntityRefreshSprite( entity, sprite );
    end
end