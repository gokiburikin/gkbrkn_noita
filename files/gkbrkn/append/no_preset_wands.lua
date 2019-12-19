_g_items = _g_items or g_items;
for _,entry in pairs( g_items ) do
    if entry ~= nil and type(entry) == "table" and entry.entity ~= nil and entry.entity ~= "" and entry.entity:match( "data/entities/items/wands/level_01/" ) ~= nil then
        entry.entity = "data/entities/items/wand_level_01.xml";
    end
end