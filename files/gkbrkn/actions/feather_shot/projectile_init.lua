dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    ComponentAdjustValues( velocity, {
        gravity_y=function(value) return tonumber( value ) * 0.2; end,
        mass=function(value) return tonumber( value ) * 0.2; end,
        terminal_velocity=function(value) return tonumber( value ) * 0.18; end,
        apply_terminal_velocity=function(value) return "1"; end,
    } );
end

local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    ComponentAdjustValues( projectile, {
        die_on_low_velocity=function(value) return "0"; end,
        knockback_force=function(value) return tonumber( value ) * 0.2; end,
    } );
end