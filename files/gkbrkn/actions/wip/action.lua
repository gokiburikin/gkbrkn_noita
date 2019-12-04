--add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/wip/projectile.xml" );
--add_projectile_trigger_hit_world("data/entities/projectiles/deck/light_bullet.xml", 1)
c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/wip/projectile_extra_entity.xml,"
draw_actions( 1, true );
--LogTable( current_action )
--GamePrint(parent );
--c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/wip/projectile_extra_entity.xml,"
--draw_actions( 1, true );
--add_projectile("data/entities/projectiles/deck/spiral_shot.xml")