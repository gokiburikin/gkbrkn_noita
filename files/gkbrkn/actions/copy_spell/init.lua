table.insert( actions,
{
    id          = "GKBRKN_COPY_SPELL",
    name 		= "Copy Spell",
    description = "Cast the next unlimited use, non-copy spell",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/copy_spell/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/copy_spell/icon.png",
    type 		= ACTION_TYPE_DRAW_MANY,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 350,
    mana = 30,
    action 		= function()
        local drawn = false;
        for index,action in pairs(deck) do
            if action.id ~= "GKBRKN_COPY_SPELL" and ( action.uses_remaining == nil or action.uses_remaining < 0 ) then
                action.action();
                drawn = true;
                break;
            end
        end
        if drawn == false then
            draw_actions( 1, true );
        end
    end,
});