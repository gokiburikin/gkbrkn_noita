dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" )
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" )
current = current or 0
current_true = current_true or 0
highest = highest or 0
first_hit_frame = first_hit_frame or 0
last_hit_frame = last_hit_frame or 0
last_damage = last_damage or 0
total_damage = total_damage or 0
reset_frame = reset_frame or 0
first_hit_time = first_hit_time or 0
do_update = do_update or false
hide_frame = hide_frame or 0

local update_text_sprite = function( which, text, offset_y )
    local e = GetUpdatedEntityID()
    local width,height = EntityGetFirstHitboxSize( e )
    local sprite = EntityGetFirstComponent( e, "SpriteComponent", which )
    if sprite then
        ComponentSetValue2( sprite, "offset_x", #tostring(text) * 2 - 2 )
        ComponentSetValue2( sprite, "offset_y", height * 2 + offset_y )
        ComponentSetValue2( sprite, "text", tostring(text) )
        EntityRefreshSprite( e, sprite )
    end
end

local hide_text_sprites = function()
    local e = GetUpdatedEntityID()
    for _,k in pairs({"gkbrkn_dps_total", "gkbrkn_dps_current", "gkbrkn_dps_highest", "gkbrkn_dps_true"}) do
        local sprite = EntityGetFirstComponent( e, "SpriteComponent", k )
        if sprite then
            ComponentSetValue2( sprite, "text", "" )
            EntityRefreshSprite( e, sprite )
        end
    end
end

local update_dps_text = function()
    local width,height = EntityGetFirstHitboxSize( current_target )
    update_text_sprite( "gkbrkn_dps_true", thousands_separator( string.format( "%.2f", current_true * 25 ) ), 30)
    update_text_sprite( "gkbrkn_dps_total", thousands_separator( string.format( "%.2f", total_damage * 25 ) ), 20 )
    update_text_sprite( "gkbrkn_dps_current", thousands_separator( string.format( "%.2f", current * 25 ) ), 10 )
    update_text_sprite( "gkbrkn_dps_highest", thousands_separator( string.format( "%.2f", highest * 25 ) ), 0 )
end

function damage_received( damage, message, entity_thats_responsible, is_fatal )
    local now = GameGetFrameNum()
    local now_true = GameGetRealWorldTimeSinceStarted()
    local entity = GetUpdatedEntityID()

    local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {}
    for _,damage_model in pairs(damage_models) do
        local max_hp = ComponentGetValue2( damage_model, "max_hp" )
        ComponentSetValue2( damage_model, "max_hp", 4 )
        ComponentSetValue2( damage_model, "hp", 4 )
    end
    if entity_thats_responsible == 0 and setting_get( MISC.TargetDummy.AllowEnvironmentalDamage, false ) == false or damage < 0 then return end
    
    if now >= reset_frame then
        total_damage = 0
        current_true = 0
        current = 0
        first_hit_frame = now
        first_hit_time = now_true
    end
    hide_frame = now + 300
    last_hit_frame = now
    last_damage = damage
    total_damage = total_damage + damage
    reset_frame = now + 60
    current = total_damage / math.ceil( math.max( now - first_hit_frame, 1 ) / 60 )
    current_true = total_damage / math.max( now_true - first_hit_time, 1 )
    if current > highest then
        highest = current
    end
    do_update = true
end

if do_update then
    do_update = false
    update_dps_text()
end
if hide_frame ~= 0 and GameGetFrameNum() > hide_frame then
    hide_frame = 0
    hide_text_sprites()
end
