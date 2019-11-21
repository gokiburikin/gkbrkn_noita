table.insert( actions,
{
    id          = "GKBRKN_REVELATION",
    name 		= "Revelation",
    description = "Cast a spell that reveals the area around enemies it hits",
    sprite 		= "files/gkbrkn/actions/revelation/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/revelation/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    mana = 3,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/revelation/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end,
});