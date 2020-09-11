for _,action in pairs(actions) do
    if action.max_uses == nil or action.max_uses == -1 then
        if action.type == ACTION_TYPE_PROJECTILE then
            local max_uses = (100 / math.max(1, (action.mana or 1) ^ 0.55 ) ) ^ 1.23;
            max_uses = math.ceil( max_uses / 5 ) * 5;
            action.max_uses = max_uses;
        end
    end
end