local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" );
local _spawn_hp = spawn_hp;
function spawn_hp( x, y )
	_spawn_hp( x, y );
    if setting_get( MISC.TargetDummy.EnabledFlag ) then
        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/dummy_target_final.xml", x - 198, y + 20 );
    end
end

local _spawn_all_shopitems = spawn_all_shopitems;
function spawn_all_shopitems( x, y )
    _spawn_all_shopitems( x, y );
    if setting_get( MISC.ShopReroll.EnabledFlag ) then
        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/shop_reroll/shop_reroll.xml", x - 35, y - 12 );
    end
    if setting_get( MISC.SlotMachine.EnabledFlag ) then
        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/slot_machine/slot_machine.xml", x + 136, y );
    end
end
