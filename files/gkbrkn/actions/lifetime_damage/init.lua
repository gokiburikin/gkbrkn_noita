table.insert( actions,
{
    id          = "GKBRKN_LIFETIME_DAMAGE",
    name 		= "Damage Plus - Time",
    description = "Increases the damage done by a spell over time",
    sprite 		= "files/gkbrkn/actions/lifetime_damage/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/lifetime_damage/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 130,
    mana = 9,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/lifetime_damage/projectile_extra_entity.xml,data/entities/particles/tinyspark_yellow.xml,";
        draw_actions( 1, true );
    end,
});