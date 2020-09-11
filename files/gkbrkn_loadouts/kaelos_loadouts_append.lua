if loadouts_to_parse then
    for _,loadout in pairs( loadout_list ) do
        loadout.key = "kaelos";
        loadout.sprites = {
            player_sprite_filepath = "mods/Kaelos_Archetypes/files/K_Archetypes/loadouts/" .. loadout.folder .. "/player.xml",
            player_arm_sprite_filepath = "mods/Kaelos_Archetypes/files/K_Archetypes/loadouts/" .. loadout.folder .. "/player_arm.xml",
            player_ragdoll_filepath = "mods/Kaelos_Archetypes/files/K_Archetypes/loadouts/" .. loadout.folder .. "/ragdoll/filenames.txt",
        }
        loadout.author = "Kaelos";
    end
    for _,loadout in pairs(loadout_list) do
        table.insert( loadouts_to_parse, loadout );
    end
else
    print("[goki's things] Couldn't find the loadouts table for starting_loadouts loadout management.");
end