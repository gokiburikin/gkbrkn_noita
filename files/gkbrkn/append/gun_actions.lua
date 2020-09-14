action_type_sums = {};
for _,action in pairs(actions) do
    if action.type then
        action_type_sums[action.type+1] = (action_type_sums[action.type+1] or 0) + 1;
    end
end