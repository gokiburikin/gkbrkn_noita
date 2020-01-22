_spawn_music_trigger = spawn_music_trigger;
function spawn_music_trigger( x, y )
	_spawn_music_trigger( x, y );
    if GameHasFlagRun( "gkbrkn_goo_mode" ) then
        GameCreateParticle( "creepy_liquid", x, y, 1, 0, 0, false, false );
    end
end