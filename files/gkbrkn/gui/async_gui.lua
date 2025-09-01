dofile( "data/scripts/lib/coroutines.lua" )
GUI = GUI or dofile_once( "mods/gkbrkn_noita/files/gkbrkn/gui/update.lua" )
async_loop( function()
	if GUI then GUI() end
	wait(0)
end)
