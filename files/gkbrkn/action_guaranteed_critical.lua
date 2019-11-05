table.insert( actions,
{
    id          = "GKBRKN_GUARANTEED_CRITICAL",
    name 		= "Perfect Critical",
    description = "Cast a spell that is guaranteed to deal critical damage",
    sprite 		= "files/gkbrkn/action_guaranteed_critical.png",
    sprite_unidentified = "files/gkbrkn/action_guaranteed_critical.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "0,1,1,1,1,1,1",
    price = 190,
    mana = 0,
    max_uses = 7,
    action 		= function()
        c.damage_critical_chance = c.damage_critical_chance + 100;
        draw_actions( 1, true );
    end,
});