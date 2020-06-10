dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "data/scripts/lib/utilities.lua" );

local entity = GetUpdatedEntityID();
local x, y, angle = EntityGetTransform( entity );
local radius = 48;
local default_teleport_radius = 30;

angle = 0 - angle;

local prev_entity = EntityGetVariableNumber( entity, "prev_entity", 0 );
local prev_prev_entity = EntityGetVariableNumber( entity, "prev_prev_entity", 0 );

local targets = EntityGetInRadiusWithTag( x, y, radius, "homing_target" ) or {};
local target_found = false;

for _,target in pairs( targets ) do
    if target ~= prev_entity and target ~= prev_prev_entity and target_found == false then
        prev_prev_entity = prev_entity;
        prev_entity = target;
        target_found = true;
        
        local tx, ty = EntityGetFirstHitboxCenter( target );
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

shoot_projectile_from_projectile( entity, "data/entities/projectiles/deck/chain_bolt_explosion.xml", x, y, 0, 0 );