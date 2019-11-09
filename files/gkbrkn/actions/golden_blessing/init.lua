table.insert( actions,
{
    id          = "GKBRKN_GOLDEN_BLESSING",
    name 		= "Golden Blessing",
    description = "Cast a spell that makes enemies it hits bleed gold",
    sprite 		= "files/gkbrkn/actions/golden_blessing/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/golden_blessing/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "0.1,0.1,0.1,0.1,0.1,0.1,0.1",
    price = 1000,
    mana = 0,
    max_uses = 1,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/golden_blessing/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end,
});