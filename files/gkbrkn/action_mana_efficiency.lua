dofile( "files/gkbrkn/config.lua");
dofile( "files/gkbrkn/helper.lua" );

table.insert( actions,
{
    id          = "GKBRKN_MANA_EFFICIENCY",
    name 		= "Mana Efficiency",
    description = "Projectiles drain less mana",
    sprite 		= "data/ui_gfx/gun_actions/unidentified.png",
    sprite_unidentified 		= "data/ui_gfx/gun_actions/unidentified.png",
    --sprite 		= "files/gkbrkn/action_mana_efficiency.png",
    --sprite_unidentified = "files/gkbrkn/action_mana_efficiency.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 150,
    mana = 0,
    action 		= function()
        draw_actions( 1, true );
        mana = math.floor( mana + c.action_mana_drain * 0.5 + 0.5 );
        if root_shot ~= nil then
            LogTableCompact(shot_effects);
            LogTableCompact(__globaldata);
        end
    end,
});