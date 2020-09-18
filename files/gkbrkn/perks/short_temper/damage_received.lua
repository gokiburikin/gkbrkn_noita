function damage_received( damage, message, entity_thats_responsible, is_fatal )
    local entity = GetUpdatedEntityID();
    if GameGetGameEffectCount( entity, "BERSERK" ) == 0 then
        local effect = GetGameEffectLoadTo( entity, "BERSERK", true );
        if effect ~= nil then ComponentSetValue2( effect, "frames", 600 ); end
    end
end