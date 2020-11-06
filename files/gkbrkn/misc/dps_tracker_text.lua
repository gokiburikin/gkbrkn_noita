dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
last_text = last_text or "";
local entity = GetUpdatedEntityID();
local current_target = EntityGetParent( entity );
local current_text = EntityGetVariableString( current_target, "gkbrkn_dps_tracker_text", "" );
if current_target ~= 0 and last_text ~= current_text then
    last_text = current_text;
    local width,height = EntityGetFirstHitboxSize( current_target );
    local sprite = EntityGetFirstComponent( entity, "SpriteComponent", "gkbrkn_dps_tracker" );
    if sprite then
        ComponentSetValue2( sprite, "offset_x", #current_text * 2 - 2 );
        ComponentSetValue2( sprite, "offset_y", height * 2 );
        ComponentSetValue2( sprite, "text", current_text );
        EntityRefreshSprite( entity, sprite );
    end
end