local tracker_variable = "gkbrkn_lost_treasure_tracker";
local entity = GetUpdatedEntityID();
local tracker = EntityGetFirstComponent( entity, "VariableStorageComponent", tracker_variable );
local remove = false;
if tracker ~= nil then
    local current_lost_treasure_count = tonumber(ComponentGetValue( tracker, "value_string" ));
    if current_lost_treasure_count > 0 then
        local x,y = EntityGetTransform( entity );
        local nugget = EntityLoad( "data/entities/items/pickup/goldnugget.xml", x, y );
        ComponentSetValue( tracker, "value_string", tostring(current_lost_treasure_count-1) );
    else
        remove = true;
    end
else
    remove = true;
end
if remove == true then
    local parent = EntityGetParent( entity );
    EntityKill( entity );
    EntityRemoveChild( parent, entity );
end