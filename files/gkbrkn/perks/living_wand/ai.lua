local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua");

local entity = GetUpdatedEntityID();
local x,y = EntityGetTransform( entity );
local parent = EntityGetWithTag( "living_wand_anchor" )[1];
local parent_x, parent_y = EntityGetTransform( parent )

local distance_to_parent = math.sqrt( math.pow( parent_x - x, 2 ) + math.pow( parent_y - y, 2 ) );
local teleport_x = parent_x - 8;
local teleport_y = parent_y - 8;
if distance_to_parent >= MISC.PerkOptions.LivingWand.TeleportDistance then
    local free_x, free_y = FindFreePositionForBody( teleport_x, teleport_y, 0, 0, 8 );
    EntitySetTransform( entity, free_x, free_y );
end

local aiComponent = EntityGetFirstComponent( entity, "AnimalAIComponent" )
if aiComponent ~= nil then
    ComponentSetValue2( aiComponent, "mHomePosition", teleport_x, teleport_y );
end