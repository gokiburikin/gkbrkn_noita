dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local keep = false;
    local shooter = tonumber( ComponentGetValue( projectile, "mWhoShot" ) ) or 0;
    local components = EntityGetAllComponents( shooter ) or {};
    for _,component in pairs( components ) do
        if ComponentGetTypeName( component ) == "ControlsComponent" then
            if component ~= nil then
                if ComponentGetValue( component, "mButtonDownFire" ) == "1" then
                    keep = true;
                end
            end
        end
    end
    if keep == false then
        local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        if velocity ~= nil then
            local vx,vy = ComponentGetValueVector2( velocity, "mVelocity", vx, vy );
            local angle = math.atan2( vy, vx );
            local magnitude = 100;

            ComponentSetValueVector2( velocity, "mVelocity", math.cos( angle ) * magnitude, math.sin( angle ) * magnitude );
        end
        EntityKill( entity );
    end
end