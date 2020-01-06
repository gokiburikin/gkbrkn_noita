dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local keep = false;
    local shooter = tonumber( ComponentGetValue( projectile, "mWhoShot" ) ) or 0;
    local active_wand = WandGetActive( shooter );
    if active_wand ~= nil then
        local aim_angle = 0;
        local components = EntityGetAllComponents( shooter ) or {};
        for _,component in pairs( components ) do
            if ComponentGetTypeName( component ) == "ControlsComponent" then
                local ax, ay = ComponentGetValueVector2( component, "mAimingVector" );
                aim_angle = math.atan2( ay, ax );
            end
        end
        local x, y, angle = EntityGetTransform( entity );
        angle = aim_angle - angle;
        local wx, wy = EntityGetTransform( active_wand );
        local distance = math.sqrt( math.pow( wx - x, 2 ) + math.pow( wy - y, 2 ) );
        --local angle = math.atan2( y - wy, x - wx );
        EntitySetVariableNumber( entity, "gkbrkn_magic_hand_distance", distance );
        EntitySetVariableNumber( entity, "gkbrkn_magic_hand_angle", angle );
    end
end