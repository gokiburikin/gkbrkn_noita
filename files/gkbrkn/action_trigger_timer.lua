table.insert( actions,
{
    id          = "GKBRKN_TRIGGER_TIMER",
    name 		= "Trigger: Timer",
    description = "Cast another spell upon collision",
    sprite 		= "files/gkbrkn/action_trigger_timer.png",
    sprite_unidentified = "files/gkbrkn/action_trigger_timer.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "0,1,1,1,1,1,1",
    price = 250,
    mana = 5,
    action 		= function()
        set_trigger_timer( 60, 1 );
        draw_actions( 1, true );
    end,
});