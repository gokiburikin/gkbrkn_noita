table.insert( actions,
{
    id          = "GKBRKN_SPELL_EFFICIENCY",
    name 		= "Spell Efficiency",
    description = "Most spell casts are free",
    sprite 		= "files/gkbrkn/action_spell_efficiency.png",
    sprite_unidentified 		= "files/gkbrkn/action_spell_efficiency.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 380,
    mana = 0,
    action 		= function()
        reduce_spell_usage( 0.33 );
        draw_actions( 1, true );
    end,
});