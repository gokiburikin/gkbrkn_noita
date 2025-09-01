dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua" )

local e = GetUpdatedEntityID()
if not EntityHasVarTag( e, "gkbrkn_lost_treasure" ) then return end

local tracker_variable = "gkbrkn_lost_treasure_tracker"
for index,player in pairs( EntityGetWithTag( "player_unit" ) or {} ) do
    for _,varstore in pairs( EntityGetComponent( e, "VariableStorageComponent" ) or {} ) do 
        if ComponentGetValue2( varstore, "name" ) == "gold_value" then
            EntityAdjustVariableNumber( player, tracker_variable, 0.0, function( value ) return value + ComponentGetValueInt( varstore, "value_int" ) end )
        end
    end
end