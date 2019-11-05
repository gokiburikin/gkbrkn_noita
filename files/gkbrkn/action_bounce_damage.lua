dofile( "files/gkbrkn/helper.lua");
table.insert( actions,
{
    id          = "GKBRKN_ACTION_BOUNCE_DAMAGE",
    name 		= "Damage Plus: Bounce",
    description = "Increases the damage done by the spell with each bounce",
    sprite 		= "files/gkbrkn/action_bounce_damage.png",
    sprite_unidentified = "files/gkbrkn/action_bounce_damage.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 100,
    mana = 7,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_bounce_damage.xml,";
        draw_actions( 1, true );
    end,
});
