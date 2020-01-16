dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );

if HasFlagPersistent( MISC.HeroMode.CarnageDifficultyEnabled ) then
    local world_state = GameGetWorldStateEntity();
    ComponentSetValues( world_state, {
        fog="1",
        fog_target_extra="1",
        wind="1",
        wind_speed="50",
        lightning_count="100",
        time="0",
    } );
end