dofile_once( "data/scripts/lib/utilities.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

local entity = GetUpdatedEntityID();
if GameGetGameEffectCount( entity, "TELEPORTATION" ) == 0 then
    local x, y = EntityGetTransform( entity );
    SetRandomSeed( GameGetFrameNum(), x + y + entity );
    local players = EntityGetInRadiusWithTag( x, y, 320, "player_unit" ) or {};
    if #players > 0 and Random() <= 0.25 then
        GetGameEffectLoadTo( entity, "TELEPORTATION", true );
    end
end
