table.insert( actions,
{
    id          = "GKBRKN_TRIGGER_TIMER",
    name 		= "Trigger - Timer",
    description = "Cast a spell that casts another spell after a timer runs out",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_timer/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_timer/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 250,
    mana = 10,
    action 		= function()
        set_trigger_timer( 30, 1 );
        draw_actions( 1, true );
    end,
});