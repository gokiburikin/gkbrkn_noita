local last_money = 0;
local money_picked_total = 0;
local money_picked_time_last = 0;
function GoldTrackerUpdate()
    local players = EntityGetWithTag( "player_unit" );
    if players ~= nil then
        for index,player_entity_id in pairs( players ) do
            local wallet = EntityGetFirstComponent( player_entity_id, "WalletComponent" );
            if wallet ~= nil then
                local money = ComponentGetValue( wallet, "money" );
                if money - last_money > 0 then
                    money_picked_total = money_picked_total + money - last_money;
                    money_picked_time_last = GameGetFrameNum();
                end
                last_money = money;
            end
            break;
        end
    end
    if money_picked_total > 0 and GameGetFrameNum() - money_picked_time_last >= MISC.GoldPickupTracker.TrackDuration then
        GamePrint( "Picked up "..money_picked_total.." Gold" );
        money_picked_total = 0;
    end
end