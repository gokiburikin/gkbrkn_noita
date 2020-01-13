dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
local tracker_variable = "gkbrkn_lost_treasure_tracker";
local entity = GetUpdatedEntityID();

local players = EntityGetWithTag( "player_unit" ) or {};
for index,player in pairs( players ) do
    -- load the gold_value from VariableStorageComponent
	local variables = EntityGetComponent( entity, "VariableStorageComponent" ) or {};
    local gold_value = 0;
    for key,comp_id in pairs(variables) do 
        if ComponentGetValue( comp_id, "name" ) == "gold_value" then
            gold_value = ComponentGetValueInt( comp_id, "value_int" );
            break;
        end
    end
    EntityAdjustVariableNumber( player, tracker_variable, 0.0, function( value ) return tonumber( value ) + gold_value; end );
    --( "lost treasure is now: ".. EntityGetVariableNumber( player, tracker_variable, 0.0 ) );
end