local blindness = GameGetGameEffectCount( player, "BLINDNESS" );
if blindness > 0 then
    local effect = GameGetGameEffect( player, "BLINDNESS" );
    local frames = tonumber( ComponentGetValue( effect, "frames" ) );
    if frames > 600 then
        ComponentSetValue( effect, "frames", 600 );
    end
end