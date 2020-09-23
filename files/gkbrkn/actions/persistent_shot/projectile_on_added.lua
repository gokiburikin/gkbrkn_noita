dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile ~= nil then
    local shooter = ComponentGetValue2( projectile, "mWhoShot" ) or 0;
    local aim_angle = 0;
    local components = EntityGetAllComponents( shooter ) or {};
    for _,component in pairs( components ) do
        if ComponentGetTypeName( component ) == "ControlsComponent" then
            local ax, ay = ComponentGetValue2( component, "mAimingVector" );
            aim_angle = math.atan2( ay, ax );
            break;
        end
    end
    EntitySetVariableNumber( entity, "gkbrkn_persistent_shot_angle", aim_angle );
end