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

    local width,height = EntityGetFirstHitboxSize( entity );

    local damage_text = thousands_separator(string.format( "%.2f", total_damage * 25 ));

    local text = EntityGetFirstComponent( entity, "SpriteComponent", "gkbrkn_damage_number" );
    if text ~= nil then
        EntityRemoveComponent( entity, text );
    end

    EntityAddComponent( entity, "SpriteComponent", {
        _tags="enabled_in_world,gkbrkn_damage_number,ui,no_hitbox",
        image_file="mods/gkbrkn_noita/files/gkbrkn/font/font_small_numbers_damage.xml",
        emissive="0",
        is_text_sprite="1",
        offset_x=tostring( #damage_text * 2 - 2 ),
        offset_y=tostring( height * 2 + 12 ),
        update_transform="1" ,
        text=damage_text,
        has_special_scale="1",
        special_scale_x="0.6667",
        special_scale_y="0.6667",
        z_index="-9000",
        never_ragdollify_on_death="1"
    });
end