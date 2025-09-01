dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")
local e = GetUpdatedEntityID()
local x, y = EntityGetTransform(e)
if EntityHasVarTag( e, "gkbrkn_regen_cancel" ) then
    EntityRemoveVarTag( e, "gkbrkn_regen_cancel" )
    return
end

local damage_model = EntityGetFirstComponent( e, "DamageModelComponent" )
if not damage_model then return end

local max_hp = ComponentGetValue2( damage_model, "max_hp" )
local current_hp = ComponentGetValue2( damage_model, "hp" )
if current_hp >= max_hp then return end 

-- heal up to full over 30 seconds (assuming this is called once every 60 frames )
ComponentSetValue2( damage_model, "hp", math.min( max_hp, current_hp + max_hp * (1.0/30.0) ) )
local s = EntityLoad( "data/entities/particles/heal.xml", x, y )
EntityAddComponent2( s, "LifetimeComponent", {lifetime=2})
GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/create", x, y )
