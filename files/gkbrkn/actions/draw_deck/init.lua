table.insert( actions,
{
		id          = "GKBRKN_DRAW_DECK",
		name 		= "Draw All",
		description = "Simultaneously cast all remaining spells",
		sprite 		= "files/gkbrkn/actions/draw_deck/icon.png",
		sprite_unidentified = "files/gkbrkn/actions/draw_deck/icon.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6",
		spawn_probability                 = "0.33,0.33,0.33,0.33,0.33,0.33,0.33",
		price = 280,
		mana = 30,
        action 		= function()
			draw_actions( #deck, true );
		end,
	}
);