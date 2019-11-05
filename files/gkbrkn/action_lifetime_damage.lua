table.insert( actions,
{
    id          = "GKBRKN_ACTION_LIFETIME_DAMAGE",
    name 		= "Damage Plus: Time",
    description = "Increases the damage done by a spell over time",
    sprite 		= "files/gkbrkn/action_lifetime_damage.png",
    sprite_unidentified = "files/gkbrkn/action_lifetime_damage.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 130,
    mana = 9,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_lifetime_damage.xml,data/entities/particles/tinyspark_yellow.xml,";
        draw_actions( 1, true );
    end,
});