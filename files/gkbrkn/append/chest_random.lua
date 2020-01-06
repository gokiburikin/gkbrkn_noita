dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua");
dofile_once( "data/scripts/perks/perk.lua" );
dofile_once( "data/scripts/perks/perk_list.lua" );

_drop_random_reward = drop_random_reward;
function drop_random_reward( x, y, entity_id )
    SetRandomSeed( GameGetFrameNum(), x + y + entity_id );
    if HasFlagPersistent( MISC.ChestsContainPerks.Enabled ) and Random() <= MISC.ChestsContainPerks.Chance then
        local random_perk = perk_list[ Random( 1, #perk_list ) ];
        local perk = perk_spawn( x, y - 8, random_perk.id );
        if MISC.ChestsContainPerks.RemovePerkTag then
            EntityRemoveTag( perk, "perk" );
        end
        return true;
    end
    return _drop_random_reward( x, y, entity_id );
end