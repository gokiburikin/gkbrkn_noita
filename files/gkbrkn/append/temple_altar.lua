dofile_once("mods/gkbrkn_noita/files/gkbrkn/config.lua");
_spawn_hp = _spawn_hp or spawn_hp;
function spawn_hp( x, y )
	_spawn_hp( x, y );
    if HasFlagPersistent( MISC.TargetDummy.Enabled ) then
        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/dummy_target.xml", x, y );
    end
end