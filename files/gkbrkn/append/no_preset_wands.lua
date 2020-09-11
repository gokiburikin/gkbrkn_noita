local _g_items = g_items;
for _,entry in pairs( g_items ) do
    if entry ~= nil and type(entry) == "table" and entry.entity ~= nil and entry.entity ~= "" and entry.entity:match( "data/entities/items/wands/level_01/" ) ~= nil then
        entry.entity = "data/entities/items/wand_level_01.xml";
    end
end

local _spawn_trapwand = spawn_trapwand;
function spawn_trapwand(x, y)
    local options = { "wand_level_01" };
    SetRandomSeed( x, y );
    
    local rnd = Random( 1, #options );
    local wand_to_spawn = "data/entities/items/" .. options[rnd] .. ".xml";
    
    local wand_id = EntityLoad( wand_to_spawn, x, y );
    EntityAddTag( wand_id, "trap_wand" );
end