dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
local tracker_variable = "gkbrkn_lost_treasure_tracker";
local entity = GetUpdatedEntityID();
local remove = false;
local current_lost_treasure_count = EntityGetVariableNumber( entity, tracker_variable, 0.0 );
if current_lost_treasure_count > 0 then
    local x,y = EntityGetTransform( entity );

    if current_lost_treasure_count >= 10000 then
        EntityLoad( "data/entities/items/pickup/goldnugget_10000.xml", x, y );
        EntityAdjustVariableNumber( entity, tracker_variable, 0.0, function(value) return tonumber(value) - 10000; end );
    elseif current_lost_treasure_count >= 1000 then
        EntityLoad( "data/entities/items/pickup/goldnugget_1000.xml", x, y );
        EntityAdjustVariableNumber( entity, tracker_variable, 0.0, function(value) return tonumber(value) - 1000; end );
    elseif current_lost_treasure_count >= 200 then
        EntityLoad( "data/entities/items/pickup/goldnugget_200.xml", x, y );
        EntityAdjustVariableNumber( entity, tracker_variable, 0.0, function(value) return tonumber(value) - 200; end);
    elseif current_lost_treasure_count >= 50 then
        EntityLoad( "data/entities/items/pickup/goldnugget_50.xml", x, y );
        EntityAdjustVariableNumber( entity, tracker_variable, 0.0, function(value) return tonumber(value) - 50; end );
    elseif current_lost_treasure_count >= 10 then
        EntityLoad( "data/entities/items/pickup/goldnugget_10.xml", x, y );
        EntityAdjustVariableNumber( entity, tracker_variable, 0.0, function(value) return tonumber(value) - 10; end );
    end
else
    remove = true;
end
if remove == true then
    EntityRemoveFromParent( entity );
    EntityKill( entity );
end