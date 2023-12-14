
require('lib.samp.events').onApplyPlayerAnimation = function(playerId, animLib, animName, frameDelta, loop, lockX, lockY, freeze, time)
	if BlockSync then return false end
end