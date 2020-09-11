local biome_data = {
    { filepath="data/scripts/biomes/coalmine.lua", level=1, traps=true },
    { filepath="data/scripts/biomes/coalmine_alt.lua", level=1 },
    { filepath="data/scripts/biomes/clouds.lua", level=3 },
    { filepath="data/scripts/biomes/crypt.lua", level=4 },
    { filepath="data/scripts/biomes/excavationsite.lua", level=2 },
    { filepath="data/scripts/biomes/fungicave.lua", level=2 },
    { filepath="data/scripts/biomes/magic_gate.lua", level=4 },
    { filepath="data/scripts/biomes/pyramid.lua", level=3 },
    { filepath="data/scripts/biomes/rainforest.lua", level=4 },
    { filepath="data/scripts/biomes/sandcave.lua", level=3 },
    { filepath="data/scripts/biomes/sandroom.lua", level=3 },
    { filepath="data/scripts/biomes/snowcastle.lua", level=3 },
    { filepath="data/scripts/biomes/snowcave.lua", level=3 },
    { filepath="data/scripts/biomes/the_end.lua", level=4 },
    { filepath="data/scripts/biomes/tower.lua", level=1 },
    { filepath="data/scripts/biomes/vault.lua", level=5 },
    { filepath="data/scripts/biomes/vault_frozen.lua", level=5 },
};

for _,data in pairs( biome_data ) do
    ModLuaFileAppend( data.filepath, "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/biome_append.lua" );
end