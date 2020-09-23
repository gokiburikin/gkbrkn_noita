dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile ~= nil then
    local keep = false;
    local shooter = ComponentGetValue2( projectile, "mWhoShot" ) or 0;
    local control = EntityGetFirstComponent( shooter,"ControlsComponent" );
    if control then
        local handle = true;
        --if ComponentGetValue( component, "mButtonDownFire" ) == "1" then
        --    handle = true;
        --end
        if handle then
            local ax, ay = ComponentGetValue2( control, "mAimingVectorNormalized" );
            if ax ~= 0 and ay ~= 0 then
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

                local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
                if velocity ~= nil then
                    local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
                    local magnitude =  math.max( 20, EntityGetVariableNumber( entity, "gkbrkn_magic_hand_magnitude", math.sqrt( vx * vx + vy * vy ) ) );
                    ComponentSetValue2( velocity, "mVelocity", math.cos( aim_angle + angle_offset ) * magnitude , math.sin( aim_angle + angle_offset ) * magnitude );
                end
            end
        end
    end
end