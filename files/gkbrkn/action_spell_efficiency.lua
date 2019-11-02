dofile( "files/gkbrkn/config.lua");
dofile( "files/gkbrkn/helper.lua" );

table.insert( actions,
{
    id          = "GKBRKN_SPELL_EFFICIENCY",
    name 		= "Spell Efficiency",
    description = "Most spell casts are free",
    sprite 		= "files/gkbrkn/action_spell_efficiency.png",
    sprite_unidentified 		= "files/gkbrkn/action_spell_efficiency.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 380,
    mana = 0,
    action 		= function()
        local uses_before = nil;
        if current_action ~= nil and current_action.uses_remaining ~= nil then
            uses_before = current_action.uses_remaining;
        end
        draw_actions( 1, true );
        LogTableCompact( current_action) ;
        local roll = math.random();
        local success = roll <= ACTIONS.SpellEfficiency.RetainChance;
        if uses_before ~= nil and success then
            current_action.uses_remaining = uses_before;
        end
    end,
});