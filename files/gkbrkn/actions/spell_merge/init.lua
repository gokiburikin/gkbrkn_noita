dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_SPELL_MERGE", "spell_merge", ACTION_TYPE_DRAW_MANY, 
    "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 190, 14, -1,
    nil,
    function()
        local projectile_path = "mods/gkbrkn_noita/files/gkbrkn/actions/spell_merge/projectile.xml";
        if reflecting then 
            Reflection_RegisterProjectile( projectile_path );
            return;
        end
        local old_c = c;
        c = {};
        reset_modifiers( c );
        for k,v in pairs(old_c) do
            c[k] = v;
        end
        BeginProjectile( projectile_path );
            BeginTriggerDeath();
                c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/spell_merge/projectile_extra_entity.xml,";
                c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/scratch/projectile_depth_"..(gkbrkn.spell_merge_groups)..".xml,"
                gkbrkn.spell_merge_groups = gkbrkn.spell_merge_groups + 1;
                c.lifetime_add = c.lifetime_add + 1;
                draw_actions( 2, true );
                register_action( c );
                SetProjectileConfigs();
            EndTrigger();
        EndProjectile();
        c = old_c;
    end
) );