if _GKBRKN_CONFIG == nil then dofile( "files/gkbrkn/config.lua"); end

local entity_id = GetUpdatedEntityID();
last_money = last_money or 0;
money_picked_total = money_picked_total or 0;
money_picked_time_last = money_picked_time_last or 0;

local wallet = EntityGetFirstComponent( entity_id, "WalletComponent" );
if wallet ~= nil then
    local money = ComponentGetValue( wallet, "money" );
    if money - last_money > 0 then
        money_picked_total = money_picked_total + money - last_money;
        money_picked_time_last = GameGetFrameNum();
    end
    last_money = money;
end

if money_picked_total > 0 then
    if  HasFlagPersistent(MISC.GoldPickupTracker.ShowTrackerEnabled) then
        local gold_tracker_text = EntityGetFirstComponent( entity_id, "SpriteComponent", "gkbrkn_gold_tracker");
        if gold_tracker_text ~= nil then
            ComponentSetValue( gold_tracker_text, "text", "$"..money_picked_total );
            local fade_percent = 1 - (GameGetFrameNum() - money_picked_time_last) / MISC.GoldPickupTracker.TrackDuration;
            ComponentSetValue( gold_tracker_text, "alpha", tostring(math.pow(fade_percent,0.2)) );
        end
    end
    if GameGetFrameNum() - money_picked_time_last >= MISC.GoldPickupTracker.TrackDuration then
        if HasFlagPersistent( MISC.GoldPickupTracker.ShowMessageEnabled ) then
            GamePrint( "Picked up "..money_picked_total.." Gold" );
        end
        money_picked_total = 0;
        if gold_tracker_text ~= nil then
            ComponentSetValue( gold_tracker_text, "text", " " );
        end
    end
end