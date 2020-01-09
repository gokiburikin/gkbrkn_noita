dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "data/scripts/lib/utilities.lua" );

local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local radius = 48;
local default_teleport_radius = 30;


local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
    local angle = 0 - math.atan2( vy, vx );
    --[[
    if vx == 0 and vy == 0 then
        local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
        local shooter = tonumber( ComponentGetValue( projectile, "mWhoShot" ) ) or 0;
        local components = EntityGetAllComponents( shooter ) or {};
        for _,component in pairs( components ) do
            if ComponentGetTypeName( component ) == "ControlsComponent" then
                local ax, ay = ComponentGetValueVector2( component, "mAimingVector" );
                angle = math.atan2( ay, ax );
                ComponentSetValueVector2( velocity, "mVelocity", math.cos( angle ) * 40, math.sin( angle ) * 40 );
                GamePrint("s");
                angle = 0 - angle;
                break;
            end
        end
    end
    ]]

    local prev_entity = EntityGetVariableNumber( entity, "prev_entity", 0 );
    local prev_prev_entity = EntityGetVariableNumber( entity, "prev_prev_entity", 0 );

    local targets = EntityGetInRadiusWithTag( x, y, radius, "homing_target" ) or {};
    local target_found = false;

    for _,target in pairs( targets ) do
        if target ~= prev_entity and target ~= prev_prev_entity and target_found == false then
            prev_prev_entity = prev_entity;
            prev_entity = target;
            target_found = true;
            
            local tx, ty = EntityGetHitboxCenter( target );
            EntitySetTransform( entity, tx, ty );
            x = tx;
            y = ty;
            
            break;
        end
    end

    if target_found == false then
        prev_prev_entity = prev_entity;
        prev_entity = 0;
        
        x = x + math.cos( angle ) * default_teleport_radius;
        y = y - math.sin( angle ) * default_teleport_radius;
        
        EntitySetTransform( entity, x, y );
    end

    EntitySetVariableNumber( entity, "prev_entity", prev_entity );
    EntitySetVariableNumber( entity, "prev_prev_entity", prev_prev_entity );
end