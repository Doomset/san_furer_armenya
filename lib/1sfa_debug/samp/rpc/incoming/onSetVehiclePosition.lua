
require('lib.samp.events').onSetVehiclePosition = function(vehicleId, pos)
	print("onSetVehiclePosition сервер установил позицию ",pos.x, pos.y, pos.z, shortPos(pos.x, pos.y, pos.z))
	if BlockSync then return false end
end