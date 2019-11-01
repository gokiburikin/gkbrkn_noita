dofile( "files/gkbrkn/helper.lua");

stack_next_actions = 0;
stack_projectiles = "";
_add_projectile = add_projectile;
function add_projectile( filepath )
    if #deck == 0 then
        stack_next_actions = 0;
    end
    if #stack_projectiles > 0 and stack_next_actions == 0 then
        c.extra_entities = c.extra_entities..stack_projectiles;
        stack_projectiles = "";
        _add_projectile( filepath );
    elseif stack_next_actions > 0 then
        stack_next_actions = stack_next_actions - 1;
        stack_projectiles = (stack_projectiles or "") .. filepath..",";
        draw_action( 1 );
    else
        _add_projectile( filepath );
    end
end

function stack_next_action( amount )
    stack_next_actions = stack_next_actions + amount;
end

function multi_play_action( action, amount )
    amount = amount or 1
	table.insert( hand, action )

    set_current_action( action )
    for i=1,amount do
        action.action()
    end

	local is_projectile = false

	if action.type == ACTION_TYPE_PROJECTILE then
		is_projectile = true
		got_projectiles = true
	end

	if  action.type == ACTION_TYPE_STATIC_PROJECTILE then
		is_projectile = true
		got_projectiles = true
	end

	if action.type == ACTION_TYPE_MATERIAL then
		is_projectile = true
		got_projectiles = true
	end

	if is_projectile then
		for i,modifier in ipairs(active_extra_modifiers) do
			extra_modifiers[modifier]()
		end
	end

	OnActionPlayed( action.id )
	current_reload_time = current_reload_time + ACTION_DRAW_RELOAD_TIME_INCREASE * amount
end

function multi_draw_action( amount, instant_reload_if_empty )
	local action = nil

	state_cards_drawn = state_cards_drawn + 1

	if reflecting then  return  end


	if ( #deck <= 0 ) then
		if instant_reload_if_empty then
			move_discarded_to_deck()
			order_deck()
			start_reload = true
		else
			reloading = true
			return true -- <------------------------------------------ RETURNS
		end
	end

	if #deck > 0 then
		-- draw from the start of the deck
        action = deck[ 1 ]
        LogTable(action);
        amount = amount or 1

		table.remove( deck, 1 )

		-- update mana
		local action_mana_required = action.mana
		if action.mana == nil then
			action_mana_required = ACTION_MANA_DRAIN_DEFAULT
        end
        action_mana_required = action_mana_required * amount

		if action_mana_required > mana then
			OnNotEnoughManaForAction()
			table.insert( discarded, action )
			return false -- <------------------------------------------ RETURNS
		end

		if action.uses_remaining == 0 then
			table.insert( discarded, action )
			return false -- <------------------------------------------ RETURNS
		end

		mana = mana - action_mana_required
	end

	--- add the action to hand and execute it ---
    if action ~= nil then
        multi_play_action( action, amount )
	end

	return true
end