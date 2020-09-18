dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_NUGGET_SHOT", "nugget_shot", ACTION_TYPE_PROJECTILE,
    "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 1000, 30, -1,
    nil,
    function()
        local shooter = GetUpdatedEntityID();
        local wallet = EntityGetFirstComponent( shooter, "WalletComponent" );
        if wallet ~= nil then
            local money = ComponentGetValue2( wallet, "money" );
            local cost = 10;
            if money >= cost then
                add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/nugget_shot/projectile.xml");
                ComponentSetValue2( wallet, "money", money - cost );
            end
        end
    end
) );
