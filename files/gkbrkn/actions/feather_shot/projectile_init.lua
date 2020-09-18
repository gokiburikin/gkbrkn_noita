dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    ComponentAdjustValues( velocity, {
        terminal_velocity=function(value) return tonumber( value ) * 0.18; end,
        apply_terminal_velocity=function(value) return true; end,
    } );
end

local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    ComponentAdjustValues( projectile, {
        die_on_low_velocity=function(value) return false; end,
    } );
end