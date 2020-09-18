dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
current = current or 0;
best = best or 0;
first_hit_frame = first_hit_frame or 0;
last_hit_frame = last_hit_frame or 0;
last_damage = last_damage or 0;
total_damage = total_damage or 0;
reset_frame = reset_frame or 0;
function damage_received( damage, message, entity_thats_responsible, is_fatal )
    local now = GameGetFrameNum();
    local entity = GetUpdatedEntityID();

    local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
    for _,damage_model in pairs(damage_models) do
        local max_hp = ComponentGetValue2( damage_model, "max_hp" );
        ComponentSetValue2( damage_model, "max_hp", 1 );
        ComponentSetValue2( damage_model, "hp", damage + 1 );
    end
    if entity_thats_responsible == 0 and HasFlagPersistent( MISC.TargetDummy.AllowEnvironmentalDamage ) == false then return; end
    
    if now >= reset_frame then
        total_damage = 0;
        best = 0;
        current = 0;
        first_hit_frame = now;
    end
    last_hit_frame = now;
    last_damage = damage;
    total_damage = total_damage + damage;
    reset_frame = now + 60;
    current = total_damage / math.ceil( math.max( now - first_hit_frame, 1 ) / 60 );
    if current > best then
        best = current;
    end

    local width,height = EntityGetFirstHitboxSize( entity );

    local damage_text = thousands_separator(string.format( "%.2f", current * 25 ));

    local text = EntityGetFirstComponent( entity, "SpriteComponent", "gkbrkn_dps_tracker" );
    if text ~= nil then
        EntityRemoveComponent( entity, text );
    end

    EntityAddComponent( entity, "SpriteComponent", {
        _tags="enabled_in_world,gkbrkn_dps_tracker",
        image_file="mods/gkbrkn_noita/files/gkbrkn/font/font_small_numbers.xml",
        emissive="1",
        is_text_sprite="1",
        offset_x=tostring( #damage_text * 2 - 2 ),
        offset_y=tostring( height * 2 ),
        update_transform="1" ,
        update_transform_rotation="0",
        text=damage_text,
        has_special_scale="1",
        special_scale_x="0.6667",
        special_scale_y="0.6667",
        z_index="-9000",
        never_ragdollify_on_death="1"
    });
end