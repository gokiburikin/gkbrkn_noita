local entity = GetUpdatedEntityID();
local wallet = EntityGetFirstComponent( entity, "WalletComponent" );
if wallet ~= nil then
    local money = ComponentGetValue2( wallet, "money" );
    local x,y = EntityGetTransform( entity );
    SetRandomSeed( x + GameGetFrameNum(), y );
    local cost = math.min( 10, math.floor( money / 10 ) );
    for i=1,cost do
        local gold = EntityLoad( "data/entities/items/pickup/goldnugget_10.xml", x, y );
        PhysicsApplyForce( gold, Random( 0, 1 ) == 0 and Random( 100, 300 ) or Random( -100, -300 ), Random( -50, -100 ) );
    end
    ComponentSetValue2( wallet, "money", money - cost * 10 );
end