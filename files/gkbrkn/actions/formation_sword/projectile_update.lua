dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local parent = EntityGetVariableNumber( entity, "gkbrkn_formation_sword_soft_parent", 0 );
if parent ~= 0 and EntityGetIsAlive(parent) then
    local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
    if projectile ~= nil then
        local shooter = ComponentGetValue2( projectile, "mWhoShot" ) or 0;
        local control = EntityGetFirstComponent( shooter,"ControlsComponent" );
        if control then
            local ax, ay = ComponentGetValue2( control, "mAimingVectorNormalized" );
            if ax ~= 0 and ay ~= 0 then
                local aim_angle = math.atan2( ay, ax );

                local active_wand = WandGetActive( shooter );
                if active_wand ~= nil then
                    local distance = EntityGetVariableNumber( entity, "gkbrkn_formation_sword_index", 0 ) * 12;
                    if distance ~= nil and aim_angle ~= nil then
                        local wx, wy = EntityGetTransform( active_wand );
                        local offset_entities = EntityGetWithTag("gkbrkn_formation_sword_shoot_pos" );
                        local found_offset = false;
                        for k,v in pairs( offset_entities ) do
                            if v and #(EntityGetComponent( v, "InheritTransformComponent" ) or {}) > 0 then
                                wx, wy = EntityGetTransform( v );
                                found_offset = true;
                                break;
                            end
                        end
                        if not found_offset then distance = distance + 12; end
                        EntityApplyTransform( entity, wx + math.cos( aim_angle ) * distance, wy + math.sin( aim_angle ) * distance );
                    end
                end

                local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
                if velocity ~= nil then
                    local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
                    if EntityGetVariableNumber( entity, "gkbrkn_formation_sword_angle_offset", 0 ) == 0 and ( vx ~= 0 or vy ~= 0 ) then
                        EntitySetVariableNumber( entity, "gkbrkn_formation_sword_angle_offset", aim_angle - math.atan2( vy, vx ) );
                    end
                    local magnitude =  math.max( 20, EntityGetVariableNumber( entity, "gkbrkn_magic_hand_magnitude", math.sqrt( vx * vx + vy * vy ) ) );
                    ComponentSetValue2( velocity, "mVelocity", math.cos( aim_angle + EntityGetVariableNumber( entity, "gkbrkn_formation_sword_angle_offset", 0 ) ) * magnitude , math.sin( aim_angle + EntityGetVariableNumber( entity, "gkbrkn_formation_sword_angle_offset", 0 ) ) * magnitude );
                end
            end
        end
    end
end