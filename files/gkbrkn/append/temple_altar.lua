dofile_once("files/gkbrkn/config.lua");
_spawn_hp = _spawn_hp or spawn_hp;
function spawn_hp( x, y )
	_spawn_hp( x, y );
    if HasFlagPersistent( MISC.TargetDummy.Enabled ) then
        EntityLoad( "data/entities/props/dummy_target.xml", x, y );
    end
end