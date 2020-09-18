local blindness = GameGetGameEffectCount( player, "BLINDNESS" );
if blindness > 0 then
    local effect = GameGetGameEffect( player, "BLINDNESS" );
    local frames = ComponentGetValue2( effect, "frames" );
    if frames > 600 then
        ComponentSetValue2( effect, "frames", 600 );
    end
end