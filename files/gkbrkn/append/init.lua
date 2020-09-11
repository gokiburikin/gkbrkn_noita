dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );

if HasFlagPersistent( MISC.HeroMode.CarnageDifficultyFlag ) then
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