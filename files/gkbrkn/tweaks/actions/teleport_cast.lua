dofile_once( "data/scripts/lib/utilities.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );

local entity    = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local targets = EntityGetInRadiusWithTag( x, y, 96, "homing_target" ) or {};
SetRandomSeed( x + y, GameGetFrameNum() );

if #targets > 0 then
	local target = targets[ Random( 1, #targets ) ];
	local tx, ty = EntityGetHitboxCenter( target );
	EntitySetTransform( entity, tx, ty );
end