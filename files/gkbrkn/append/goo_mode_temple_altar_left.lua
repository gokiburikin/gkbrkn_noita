dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" );

local _spawn_music_trigger = spawn_music_trigger;
function spawn_music_trigger( x, y )
	_spawn_music_trigger( x, y );
    if GameHasFlagRun( FLAGS.GooMode ) then
        GameCreateParticle( "creepy_liquid", x, y + 20, 5, 0, 0, false, false );
    end
    if GameHasFlagRun( FLAGS.HotGooMode ) then
        GameCreateParticle( "hot_goo", x, y + 20, 5, 0, 0, false, false );
    end
    if GameHasFlagRun( FLAGS.PolyGooMode ) then
        GameCreateParticle( "poly_goo", x, y + 20, 5, 0, 0, false, false );
    end
    if GameHasFlagRun( FLAGS.KillerGooMode ) then
        GameCreateParticle( "killer_goo", x, y + 20, 5, 0, 0, false, false );
    end
    if GameHasFlagRun( FLAGS.AltKillerGooMode ) then
        GameCreateParticle( "alt_killer_goo", x, y + 20, 5, 0, 0, false, false );
    end
end