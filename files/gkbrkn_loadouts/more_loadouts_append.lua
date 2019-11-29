for _,loadout in pairs( loadout_list ) do
    loadout.sprites = {
        player_sprite_filepath = "mods/more_loadouts/files/" .. loadout.folder .. "/player.xml",
        player_arm_sprite_filepath = "mods/more_loadouts/files/" .. loadout.folder .. "/player_arm.xml",
        player_ragdoll_filepath = "mods/more_loadouts/files/" .. loadout.folder .. "/ragdoll/filenames.txt",
    }
end