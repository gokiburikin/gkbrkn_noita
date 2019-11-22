local entity = GetUpdatedEntityID();
GlobalsSetValue( "gkbrkn_fired_projectiles", GlobalsGetValue( "gkbrkn_fired_projectiles", "" )..entity.."," );
EntityAddTag( entity, "gkbrkn_projectile_orbit" );
