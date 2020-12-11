dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );

local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local mortals = EntityGetInRadiusWithTag( x, y, 128, "mortal" );

function reduce_shield( target )
    local energy_shield = EntityGetFirstComponent( target, "EnergyShieldComponent" );
    if energy_shield then
        local radius = ComponentGetValue2( energy_shield, "radius" );
        local energy = ComponentGetValue2( energy_shield, "energy" );
        local energy_required_to_shield = ComponentGetValue2( energy_shield, "energy_required_to_shield" );
        ComponentSetValue2( energy_shield, "energy", math.max( 0, energy - ComponentGetValue2( energy_shield, "recharge_speed" ) * 0.02 ) );
        local tx, ty = EntityGetHitboxCenter( target );
        SetRandomSeed( tx, ty + GameGetFrameNum() );
        local angle = Random() * math.pi * 2;
        local amount = 1;
        if energy >= energy_required_to_shield then
            amount = 4;
        end
        GameCreateParticle( "plasma_fading", tx + math.cos( angle ) * radius, ty + math.sin( angle ) * radius, amount, Random( -100, 100 ), Random( -100, 100 ), false, false );
    end
    for k,v in ipairs( EntityGetAllChildren( target ) or {} ) do
        reduce_shield( v );
    end
end

for k,v in ipairs( mortals ) do
    reduce_shield( v );
end