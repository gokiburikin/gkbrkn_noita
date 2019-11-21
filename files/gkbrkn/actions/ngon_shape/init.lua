table.insert( actions,
{
    id          = "GKBRKN_NGON_SHAPE",
    name 		= "Formation - N-gon",
    description = "Cast all remaining spells in a circular pattern",
    sprite 		= "files/gkbrkn/actions/ngon_shape/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/ngon_shape/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 120,
    mana = 24,
    action 		= function()
        c.pattern_degrees = 180;
        draw_actions( #deck, true );
    end,
});
