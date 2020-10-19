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
        ComponentSetValue2( damage_model, "max_hp", 4 );
        ComponentSetValue2( damage_model, "hp", math.max( 4, damage * 1.1 ) );
    end
    --local x,y = EntityGetTransform( entity );
    --local did_hit, hit_x, hit_y = RaytracePlatforms( x, y - 1, x, y );
    --if did_hit then
    --    EntityApplyTransform( entity, x, y - 5 );
    --end
    if entity_thats_responsible == 0 and HasFlagPersistent( MISC.TargetDummy.AllowEnvironmentalDamage ) == false or damage < 0 then return; end
    
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
    local damage_text = thousands_separator(string.format( "%.2f", current * 25 ));
    EntitySetVariableString( entity, "gkbrkn_dps_tracker_text", damage_text );
end