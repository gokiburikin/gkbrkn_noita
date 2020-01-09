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
            local ax, ay = ComponentGetValueVector2( component, "mAimingVector" );
            local angle = math.atan2( ay, ax );
            local initial_angle = 0;

            local active_wand = WandGetActive( shooter );
            if active_wand ~= nil then
                local distance = EntityGetVariableNumber( entity, "gkbrkn_magic_hand_distance", nil ) + 2;
                initial_angle = EntityGetVariableNumber( entity, "gkbrkn_magic_hand_angle", 0 );
                if distance ~= nil and angle ~= nil then
                    local wx, wy = EntityGetTransform( active_wand );
                    EntitySetTransform( entity, wx + math.cos( angle ) * distance, wy + math.sin( angle ) * distance );
                end
            end
            local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
            if velocity ~= nil then
            
                local vx,vy = ComponentGetValueVector2( velocity, "mVelocity", vx, vy );
                local magnitude = math.sqrt( vx * vx + vy * vy );

                ComponentSetValueVector2( velocity, "mVelocity", math.cos( angle + initial_angle ) * magnitude, math.sin( angle + initial_angle ) * magnitude );
            end
        end
    end
end