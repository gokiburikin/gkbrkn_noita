dofile_once( "files/gkbrkn/config.lua");

local edit_callbacks = {
    REVENGE_EXPLOSION = function( perk, index )
        perk.func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_damage_received = "files/gkbrkn/misc/tweaks/perks/revenge_explosion.lua",
				execute_every_n_frame = "-1",
			} )
		end
    end,
}

local apply_tweaks = {};
for _,content_id in pairs(TWEAKS) do
    local tweak = CONTENT[content_id];
    if tweak.enabled() and tweak.options ~= nil and tweak.options.perk_id ~= nil then
        apply_tweaks[ tweak.options.perk_id ] = true
    end
end

for i=#perk_list,1,-1 do
    local perk = perk_list[i];
    if perk ~= nil and edit_callbacks[ perk.id ] ~= nil and apply_tweaks[ perk.id ] == true then
        edit_callbacks[perk.id]( perk, i );
    end
end