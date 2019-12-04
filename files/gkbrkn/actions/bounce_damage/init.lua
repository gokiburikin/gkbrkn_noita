table.insert( actions,
{
    id          = "GKBRKN_BOUNCE_DAMAGE",
    name 		= "Damage Plus - Bounce",
    description = "Increases the damage done by the spell with each bounce",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/bounce_damage/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/bounce_damage/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    mana = 7,
    action 		= function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/bounce_damage/projectile_extra_entity.xml,";
        c.bounces = c.bounces + 3;
        draw_actions( 1, true );
    end,
});
