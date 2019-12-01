for _,loadout in pairs( loadout_list ) do
    local folder_path = "files/K_Archetypes/loadouts/"
    loadout.sprites = {
        player_sprite_filepath = folder_path .. loadout.folder .. "/player.xml",
        player_arm_sprite_filepath = folder_path .. loadout.folder .. "/player_arm.xml",
        player_ragdoll_filepath = folder_path .. loadout.folder .. "/ragdoll/filenames.txt",
    }
end