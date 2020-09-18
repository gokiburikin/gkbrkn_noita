local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
SetRandomSeed( GameGetFrameNum(), x + y + entity );
local variables = EntityGetComponent( entity, "VariableStorageComponent" ) or {};
local gold_value = 0;
for key,comp_id in pairs(variables) do 
    if ComponentGetValue2( comp_id, "name" ) == "gold_value" then
        gold_value = ComponentGetValueInt( comp_id, "value_int" );
        break;
    end
end
while gold_value > 0 do
    local how_many = math.min( gold_value, math.max( 10, math.ceil( gold_value / 10 ) ) );
    gold_value = gold_value - how_many;
    GameCreateParticle( "gold", x + Random( -2, 2 ), y + Random( -2, 2 ), how_many, Random( -10, 10 ), Random( -20, -10 ), false );
end
