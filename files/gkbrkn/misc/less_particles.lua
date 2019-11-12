local nearby_entities = EntityGetInRadius( x, y, 256 );
local disable = HasFlagPersistent( MISC.LessParticles.DisableCosmeticParticles );
for _,nearby in pairs( nearby_entities ) do
    if EntityHasTag( nearby, "gkbrkn_less_particles" ) == false then
        EntityAddTag( nearby, "gkbrkn_less_particles" );
        local particle_emitters = EntityGetComponent( nearby, "ParticleEmitterComponent" ) or {};
        for _,emitter in pairs( particle_emitters ) do
            if ComponentGetValue( emitter, "create_real_particles" ) == "0" then
                if disable then
                    EntitySetComponentIsEnabled( nearby, emitter, false );
                else
                    ComponentSetValue( emitter, "count_max", "1" );
                    ComponentSetValue( emitter, "collide_with_grid", "0" );
                    ComponentSetValue( emitter, "is_trail", "0" );
                    ComponentSetValue( emitter, "lifetime_max", "0.5" );
                end
            end
        end
    end
end