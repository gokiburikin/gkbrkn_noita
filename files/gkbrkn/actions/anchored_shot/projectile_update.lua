dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
if velocity ~= nil then
    local x, y = EntityGetTransform( entity );
    local ax = EntityGetVariableNumber( entity, "gkbrkn_anchor_x" );
    local ay = EntityGetVariableNumber( entity, "gkbrkn_anchor_y" );
    local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
    local magnitude =  math.sqrt( vx * vx + vy * vy );
    local angle =  math.atan2( ay - y, ax - x );
    local lifetime = GameGetFrameNum() - EntityGetVariableNumber( entity, "gkbrkn_spawn_time", GameGetFrameNum() );
    local ratio = math.min( 1, lifetime / 20 );
    ComponentSetValue2( velocity, "mVelocity", vx + ( math.cos( angle ) * magnitude ) / 3 * ratio, vy + ( math.sin( angle ) * magnitude ) / 3 * ratio );
end