local _spawn_hp = spawn_hp
function spawn_hp( x, y )
	_spawn_hp( x, y )
    EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/dummy_target.xml", x - 198, y + 20 )
end