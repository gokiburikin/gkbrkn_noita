--add_projectile_trigger_death("data/entities/projectiles/deck/delayed_spell.xml", 3);

if reflecting then 
    Reflection_RegisterProjectile( "data/entities/projectiles/deck/delayed_spell.xml" )
    return 
end

BeginProjectile( "data/entities/projectiles/deck/delayed_spell.xml" )
BeginTriggerDeath()
    local shot = create_shot( 3 );
    local c = shot.state;
    c.trail_material = c.trail_material .. "gold,";
    c.trail_material_amount = c.trail_material_amount + 1;
    draw_shot( shot, true );
EndTrigger()
EndProjectile()