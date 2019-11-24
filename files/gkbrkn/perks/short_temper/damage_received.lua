function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local effect = GetGameEffectLoadTo( GetUpdatedEntityID(), "BERSERK", true );
    if effect ~= nil then ComponentSetValue( effect, "frames", "600" ); end
end