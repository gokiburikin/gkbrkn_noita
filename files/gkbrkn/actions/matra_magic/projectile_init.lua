dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");

local entity = GetUpdatedEntityID();
local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
if velocity then
    ComponentSetValue2( velocity, "air_friction", math.random() * -2 - 1.5 );
end
EntitySetVariableNumber( entity, "gkbrkn_spawn_frame", GameGetFrameNum() );