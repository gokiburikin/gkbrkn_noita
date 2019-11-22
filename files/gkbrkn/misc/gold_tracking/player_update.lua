if _GKBRKN_CONFIG == nil then dofile( "files/gkbrkn/config.lua"); end

local entity = GetUpdatedEntityID();
last_money = last_money or 0;
money_picked_total = money_picked_total or 0;
money_picked_time_last = money_picked_time_last or 0;
local update_tracker = false;

local wallet = EntityGetFirstComponent( entity, "WalletComponent" );
if wallet ~= nil then
    local money = ComponentGetValue( wallet, "money" );
    if money - last_money > 0 then
        money_picked_total = money_picked_total + money - last_money;
        money_picked_time_last = GameGetFrameNum();
        update_tracker = true;
    end
    last_money = money;
end

if money_picked_total > 0 then
    if  HasFlagPersistent(MISC.GoldPickupTracker.ShowTrackerEnabled) then
        if update_tracker then
            local gold_trackers = EntityGetWithTag( "gkbrkn_gold_tracker" ) or {};
            for _,gold_tracker in pairs( gold_trackers ) do
                EntityKill( gold_tracker );
            end
            local x,y = EntityGetTransform( entity );
            local text = EntityLoad( "files/gkbrkn/misc/gold_tracking/gold_tracker.xml", x, y );
            EntityAddChild( entity, text );
            EntityAddComponent( text, "SpriteComponent", {
                _tags="enabled_in_world",
                image_file="files/gkbrkn/font_pixel_white.xml" ,
                emissive="1",
                is_text_sprite="1",
                offset_x="8" ,
                offset_y="-4" ,
                update_transform="1" ,
                update_transform_rotation="0",
                text="$"..tostring(money_picked_total),
                has_special_scale="1",
                special_scale_x="0.6667",
                special_scale_y="0.6667",
                z_index="1.6",
            });
        end
    end
    if GameGetFrameNum() - money_picked_time_last >= MISC.GoldPickupTracker.TrackDuration then
        if HasFlagPersistent( MISC.GoldPickupTracker.ShowMessageEnabled ) then
            GamePrint( "Picked up "..money_picked_total.." Gold" );
        end
        money_picked_total = 0;
    end
end