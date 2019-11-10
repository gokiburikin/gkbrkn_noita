if HasFlagPersistent( "gkbrkn_loose_spell_generation_init" ) == false then
    AddFlagPersistent( "gkbrkn_loose_spell_generation_init" );
    if GKBRKN_LOOSE_SPELL_GENERATION_INIT == nil then
        GKBRKN_LOOSE_SPELL_GENERATION_INIT = true;
        for _,action in pairs(actions) do
            action.spawn_level = "0,1,2,3,4,5,6";
            action.spawn_probability = "1,1,1,1,1,1,1"; 
        end
    end
end
