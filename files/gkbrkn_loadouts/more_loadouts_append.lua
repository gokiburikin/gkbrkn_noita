if loadouts_to_parse then
    for _,loadout in pairs( loadout_list ) do
        loadout.key = "moreloadouts";
        loadout.sprites = {
            player_sprite_filepath = "mods/more_loadouts/files/" .. loadout.folder .. "/player.xml",
            player_arm_sprite_filepath = "mods/more_loadouts/files/" .. loadout.folder .. "/player_arm.xml",
            player_ragdoll_filepath = "mods/more_loadouts/files/" .. loadout.folder .. "/ragdoll/filenames.txt",
        }
        loadout.author = "More Loadouts";
    end
    for _,loadout in pairs(loadout_list) do
        table.insert( loadouts_to_parse, loadout );
    end
else
    print("[goki's things] Couldn't find the loadouts table for starting_loadouts loadout management.");
end