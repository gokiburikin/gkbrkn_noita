dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
local linked_entity = EntityGetVariableNumber( entity, "linked_entity", 0 )
if linked_entity ~= 0 then
    local lx, ly = EntityGetTransform(  linked_entity );
    local x, y = EntityGetTransform( entity );
    --EntityApplyTransform(  linked_entity, x, y );
end