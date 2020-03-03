dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    ComponentAdjustValues( velocity, { gravity_y=function(value) return 0; end } );
end