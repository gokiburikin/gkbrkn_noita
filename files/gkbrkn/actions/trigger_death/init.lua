table.insert( actions,
{
    id          = "GKBRKN_TRIGGER_DEATH",
    name 		= "Trigger: Death",
    description = "Cast a spell that casts another spell when it expires",
    sprite 		= "files/gkbrkn/actions/trigger_death/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/trigger_death/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "0,1,1,1,1,1,1",
    price = 250,
    mana = 10,
    action 		= function()
        set_trigger_death( 1 );
        draw_actions( 1, true );
    end,
});