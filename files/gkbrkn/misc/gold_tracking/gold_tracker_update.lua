local entity = GetUpdatedEntityID();
local lifetime = EntityGetFirstComponent( entity,"LifetimeComponent" );
local sprite = EntityGetFirstComponent( entity, "SpriteComponent" );
if lifetime ~= nil and sprite ~= nil then
    local start_frame = ComponentGetValue( lifetime, "creation_frame" );
    local current_frame = GameGetFrameNum();
    local end_frame = ComponentGetValue( lifetime, "kill_frame" );
    local percent = (current_frame - start_frame) / (end_frame - start_frame);
    ComponentSetValue( sprite, "alpha", tostring( math.pow( 1-percent, 0.1 ) ) );
end