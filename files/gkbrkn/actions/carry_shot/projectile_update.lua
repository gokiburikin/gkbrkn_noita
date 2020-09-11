dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local keep = false;
    local shooter = tonumber( ComponentGetValue( projectile, "mWhoShot" ) ) or 0;
    local components = EntityGetAllComponents( shooter ) or {};
    for _,component in pairs( components ) do
        if ComponentGetTypeName( component ) == "ControlsComponent" then
        local shooter = tonumber( ComponentGetValue( projectile, "mWhoShot" ) ) or 0;
            local handle = true;
            --if ComponentGetValue( component, "mButtonDownFire" ) == "1" then
            --    handle = true;
            --end
            if handle then
                local ax, ay = ComponentGetValueVector2( component, "mAimingVector" );
                local aim_angle = math.atan2( ay, ax );
                local angle_offset = EntityGetVariableNumber( entity, "gkbrkn_magic_hand_angle_offset", 0 );

                local active_wand = WandGetActive( shooter );
                if active_wand ~= nil then
                    local distance = EntityGetVariableNumber( entity, "gkbrkn_magic_hand_distance", 0 );
                    if distance ~= nil and aim_angle ~= nil then
                        local wx, wy = EntityGetTransform( active_wand );
                        EntityApplyTransform( entity, wx + math.cos( aim_angle + angle_offset ) * distance, wy + math.sin( aim_angle + angle_offset ) * distance );
                    end
                end

                local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
                if velocity ~= nil then
                    ComponentSetValueVector2( velocity, "mVelocity", math.cos( aim_angle + angle_offset ), math.sin( aim_angle + angle_offset ) );
                end
            end
        end
    end
end