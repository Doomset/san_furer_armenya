
require('lib.samp.events').onSetPlayerHealth = function(health)
	if BlockSync then return false end
end