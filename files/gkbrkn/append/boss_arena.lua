local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
local _spawn_hp = spawn_hp;
function spawn_hp( x, y )
	_spawn_hp( x, y );
    if HasFlagPersistent( MISC.TargetDummy.EnabledFlag ) then
        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/dummy_target.xml", x - 180, y );
    end
end

local _spawn_all_shopitems = spawn_all_shopitems;
function spawn_all_shopitems( x, y )
    _spawn_all_shopitems( x, y );
    if HasFlagPersistent( MISC.ShopReroll.EnabledFlag ) then
        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/shop_reroll/shop_reroll.xml", x - 35, y - 12 );
    end
    if HasFlagPersistent( MISC.SlotMachine.EnabledFlag ) then
        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/slot_machine/slot_machine.xml", x + 136, y );
    end
end
