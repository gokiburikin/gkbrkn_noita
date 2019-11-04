local tracker_variable = "gkbrkn_lost_treasure_tracker";
local entity = GetUpdatedEntityID();
local tracker = EntityGetFirstComponent( entity, "VariableStorageComponent", tracker_variable );
local remove = false;
GamePrint("spawner update");
if tracker ~= nil then
    local current_lost_treasure_count = tonumber(ComponentGetValue( tracker, "value_string" ));
    GamePrint("spawner"..current_lost_treasure_count);
    if current_lost_treasure_count > 0 then
        local x,y = EntityGetTransform( entity );
        local nugget = EntityLoad( "data/entities/items/pickup/goldnugget.xml", x, y );
        EntityAddTag( nugget, "gkbrkn_lost_treasure_nugget" );
        ComponentSetValue( tracker, "value_string", tostring(current_lost_treasure_count-1) );
    else
        remove = true;
    end
else
    remove = true;
end
if remove == true then
    GamePrint("remove me");
    local parent = EntityGetParent( entity );
    EntityKill( entity );
    EntityRemoveChild( parent, entity );
end