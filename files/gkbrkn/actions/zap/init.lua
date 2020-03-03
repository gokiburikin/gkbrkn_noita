dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_ZAP", "zap", ACTION_TYPE_PROJECTILE,
    "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 170, 8, -1,
    "mods/gkbrkn_noita/files/gkbrkn/actions/zap/custom_card.xml",
    function()
        c.fire_rate_wait = c.fire_rate_wait - 5;
        current_reload_time = current_reload_time - 5;
        --add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
        
        if reflecting then 
            Reflection_RegisterProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
            return;
        end

        if GameGetFrameNum() % 3 == 0 then
            BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
            BeginTriggerDeath();
                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                BeginTriggerDeath();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    EndProjectile();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    EndProjectile();
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
                EndProjectile();
                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                BeginTriggerDeath();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    EndProjectile();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    EndProjectile();
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
                EndProjectile();
                register_action( c );
                SetProjectileConfigs();
            EndTrigger();
            EndProjectile();
        elseif GameGetFrameNum() % 3 == 1 then
            BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
            BeginTriggerDeath();
                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                BeginTriggerDeath();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    EndProjectile();
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
                EndProjectile();

                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                EndProjectile();

                 BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                BeginTriggerDeath();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    EndProjectile();
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
                EndProjectile();
                register_action( c );
                SetProjectileConfigs();
            EndTrigger();
            EndProjectile();
        else
            BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
            BeginTriggerDeath();
                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                BeginTriggerDeath();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    EndProjectile();
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
                EndProjectile();
            EndTrigger();
            EndProjectile();

            BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
            BeginTriggerDeath();
                BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                BeginTriggerDeath();
                    BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" );
                    EndProjectile();
                    register_action( c );
                    SetProjectileConfigs();
                EndTrigger();
                EndProjectile();
            EndTrigger();
            EndProjectile();
        end
    end
) );