table.insert( actions,
{
    id          = "GKBRKN_PIERCING_SHOT",
    name 		= "Piercing Shot",
    description = "Cast a spell that pierces entities",
    sprite 		= "files/gkbrkn/actions/piercing_shot/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/piercing_shot/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 250,
    mana = 9,
    action 		= function()
        c.damage_projectile_add = c.damage_projectile_add + 0.24;
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/piercing_shot/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end,
});
