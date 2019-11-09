table.insert( actions,
{
    id          = "GKBRKN_NGON_PATTERN",
    name 		= "N-gon Pattern",
    description = "Cast all remaining spells in a circular pattern",
    sprite 		= "files/gkbrkn/actions/ngon_pattern/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/ngon_pattern/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    action 		= function()
        c.pattern_degrees = 180;
        draw_actions( #deck, true );
    end,
});
