dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
local last_damage_frame = {};
function damage_received( damage, message, entity_thats_responsible, is_fatal )
    local entity = GetUpdatedEntityID();
    
    local now = GameGetFrameNum();
    if now - ( last_damage_frame[entity] or 0 ) > 180 then
        EntitySetVariableNumber( entity, "gkbrkn_total_damage", 0 );
    end
    last_damage_frame[entity] = now;
    local total_damage = EntityGetVariableNumber( entity, "gkbrkn_total_damage", 0 ) + damage;
    EntitySetVariableNumber( entity, "gkbrkn_total_damage", total_damage );
    --local last_frame = EntityGetVariableNumber( entity, "gkbrkn_custom_damage_numbers_last_frame", 0 );

    local width,height = EntityGetFirstHitboxSize( entity );

    --if last_frame ~= now then
        EntitySetVariableNumber( entity, "gkbrkn_custom_damage_numbers_last_frame", now );
        last_frame = now;
        local damage_text = thousands_separator(string.format( "%.2f", total_damage * 25 ));

        local sprite = EntityGetFirstComponent( entity, "SpriteComponent", "gkbrkn_damage_number" );
        if sprite == nil then
            sprite = EntityAddComponent( entity, "SpriteComponent", {
                _tags="enabled_in_world,gkbrkn_damage_number,ui,no_hitbox",
                image_file="mods/gkbrkn_noita/files/gkbrkn/font/font_small_numbers_damage.xml",
                emissive="0",
                is_text_sprite="1",
                offset_x="0",
                offset_y="0",
                update_transform="1" ,
                update_transform_rotation="0",
                text="0123456789",
                has_special_scale="1",
                special_scale_x="0.6667",
                special_scale_y="0.6667",
                z_index="-9000",
                never_ragdollify_on_death="1"
            });
        end

        if sprite then
            ComponentSetValue2( sprite, "offset_x", #damage_text * 2 - 2 );
            ComponentSetValue2( sprite, "offset_y", height * 2 + 12 );
            ComponentSetValue2( sprite, "text", damage_text );
            EntityRefreshSprite( entity, sprite );
        end
    --end
end