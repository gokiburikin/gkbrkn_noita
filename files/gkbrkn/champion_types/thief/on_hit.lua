local entity = GetUpdatedEntityID()
local wallet = EntityGetFirstComponent( entity, "WalletComponent" )
if wallet ~= nil then
    local money = ComponentGetValue2( wallet, "money" )
    local x,y = EntityGetTransform( entity )
    SetRandomSeed( x + GameGetFrameNum(), y )
    local amount = math.min( 20, math.floor( money / 10 ) )
    local value = math.max( money / 10 / 20, 10 )
    for i=1,amount do
        local gold = EntityLoad( "data/entities/items/pickup/goldnugget_10.xml", x, y )
        if value > 10 then
            local components = EntityGetComponent( gold, "VariableStorageComponent" ) or {}
            for _,component in pairs( components ) do 
                if ComponentGetValue2( component, "name" ) == "gold_value" then
                    ComponentSetValue2( component, "value_int", value )
                end
            end
        end
        PhysicsApplyForce( gold, Random( 0, 1 ) == 0 and Random( 100, 300 ) or Random( -100, -300 ), Random( -50, -100 ) )
    end
    ComponentSetValue2( wallet, "money", money - amount * value )
end