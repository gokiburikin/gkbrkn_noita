dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
EntityAddComponent2( entity, "LuaComponent", {
    script_source_file = "data/scripts/projectiles/disc_bullet_big_trajectory.lua",
    execute_every_n_frame = 3
});