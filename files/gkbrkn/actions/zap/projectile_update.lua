dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local zap_frame = EntityAdjustVariableNumber( entity, "gkbrkn_zap_frames", 0.0, function(value) return tonumber(value) + 1; end ) or 0;
    local vx,vy = ComponentGetValueVector2( velocity, "mVelocity", vx, vy );
    local scale = 0.09 * zap_frame;
    local angle = math.atan2( vy, vx ) + (math.random() - 0.5) * math.pi * scale;
    local magnitude = math.sqrt( vx * vx + vy * vy );
    ComponentSetValueVector2( velocity, "mVelocity", math.cos( angle ) * magnitude, math.sin( angle ) * magnitude );
end

--GamePlaySound( "data/audio/Desktop/projectiles.snd", "player_projectiles/torch_electric", x, y );