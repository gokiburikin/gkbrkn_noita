GamePlaySound("data/audio/Desktop/animals.bank","animals/mine/beep", GameGetCameraPos())
local cx, cy = DEBUG_GetMouseWorld()
for i=1,10 do
    GameCreateSpriteForXFrames( "mods/gkbrkn_noita/files/gkbrkn/gui/hit_marker.png", cx, cy, true, 0, 0, i, true )
end