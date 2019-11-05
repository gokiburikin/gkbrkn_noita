local tracker_variable = "gkbrkn_lost_treasure_tracker";
local entity = GetUpdatedEntityID();
local players = EntityGetWithTag( "player_unit" );
for index,player in pairs( players ) do
    local tracker = EntityGetFirstComponent( player, "VariableStorageComponent", tracker_variable );
    if tracker == nil then
        tracker = EntityAddComponent( player, "VariableStorageComponent", {
            _enabled="1",
            _tags = tracker_variable,
            name = tracker_variable,
            value_string = "0",
        });
    end
    tracker = EntityGetFirstComponent( player, "VariableStorageComponent", tracker_variable );
    local current_lost_treasure_count = tonumber(ComponentGetValue( tracker, "value_string" ));
    ComponentSetValue( tracker, "value_string", tostring(current_lost_treasure_count + 1) );
end