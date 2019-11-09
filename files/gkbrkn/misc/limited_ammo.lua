if GKBRKN_LIMITED_AMMO_INIT == nil then
    GKBRKN_LIMITED_AMMO_INIT = true;
    for _,action in pairs(actions) do
        if action.max_uses == nil or action.max_uses == -1 then
            if action.type == ACTION_TYPE_PROJECTILE then
                action.max_uses = (100 / math.max(1, (action.mana or 1) ^0.5 ) ) ^ 1.5;
                -- round to next 10 
                action.max_uses = math.ceil( action.max_uses / 10 ) * 10;
            end
        end
    end
end