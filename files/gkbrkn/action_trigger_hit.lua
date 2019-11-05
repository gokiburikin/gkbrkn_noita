table.insert( actions,
{
    id          = "GKBRKN_TRIGGER_HIT",
    name 		= "Trigger: Hit",
    description = "Cast a spell that casts another spell upon collision",
    sprite 		= "files/gkbrkn/action_trigger_hit.png",
    sprite_unidentified = "files/gkbrkn/action_trigger_hit.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "0,1,1,1,1,1,1",
    price = 250,
    mana = 10,
    action 		= function()
        set_trigger_hit_world( 1 );
        draw_actions( 1, true );
    end,
});