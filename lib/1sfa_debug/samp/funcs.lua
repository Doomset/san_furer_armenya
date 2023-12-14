local lastservermsg = {color = -1, text = ""}
local ffi = require 'ffi'
local lastattached = {
}

local lastdialogresponse = {title = "", button = 1, select = 1, input = "", on = false}

local lastAudioStream = {url = "", on = false}
local lastSoundId = {id = -1, on = false}


ds = {

	[685] = {n = "rad", on = cfg.rad.Статус},
	[605] = {n = "gol", on = cfg.gol.Статус},
}

--function sampev.onShowTextDraw(id, data)



-- "2006.33":{"pos":[697.966796875,1293.2800292969,15.085300445557],"name":"Хлам (Свалка)","id":599}








-- function sampev.onSendChat(message)
-- 	if antimuteflodd() then msg("в пизду") return false end
-- end
-- function sampev.onSendCommand(command)
-- 	if antimuteflodd() then msg("в пизду") return false end
-- end




local sampfuncs = require 'sampfuncs'
local raknet = require 'samp.raknet'
require 'samp.synchronization'
local sync_traits = {
	player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
	vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
	passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
	aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
	trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
	unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
	bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
	spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
}



local samp_create_sync_data = function(sync_type, copy_from_player)
    copy_from_player = copy_from_player or true
    local sync_info = sync_traits[sync_type]
    local data_type = 'struct ' .. sync_info[1]
    local data = ffi.new(data_type, {})
    local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))
    -- copy player's sync data to the allocated memory
    if copy_from_player then
        local copy_func = sync_info[3]
        if copy_func then
            local _, player_id
            if copy_from_player == true then
                _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            else
                player_id = tonumber(copy_from_player)
            end
            copy_func(player_id, raw_data_ptr)
        end
    end
    -- function to send packet
    local func_send = function()
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, sync_info[2])
        raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
        raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
        raknetDeleteBitStream(bs)
    end
    -- metatable to access sync data and 'send' function
    local mt = {
        __index = function(t, index)
			
            return data[index]
        end,
        __newindex = function(t, index, value)
            data[index] = value
        end
    }
    return setmetatable({send = func_send}, mt)
end



local PLAYER_PED, isCharInAnyCar, storeCarCharIsInNoSave, getMaximumNumberOfPassengers, isCarPassengerSeatFree, getCharInCarPassengerSeat, getDriverOfCar, doesCharExist =
      PLAYER_PED, isCharInAnyCar, storeCarCharIsInNoSave, getMaximumNumberOfPassengers, isCarPassengerSeatFree, getCharInCarPassengerSeat, getDriverOfCar, doesCharExist

local my_state = function()
	if not isCharInAnyCar(PLAYER_PED) then return "player" end
	local car = storeCarCharIsInNoSave(PLAYER_PED)
	if doesCharExist(getDriverOfCar(car)) then
		return "vehicle"
	end
	for i = 0, getMaximumNumberOfPassengers(car) do
		if not isCarPassengerSeatFree(car, i) and getCharInCarPassengerSeat(car, i) == PLAYER_PED then
			return "passenger", i + 1
		end
	end
end

dialog_response = false

find_veh_and_send_pos = function(model, list, until_dialog) -- поиск 

	

	for i = 0, 2000 do
		local bool, veh = sampGetCarHandleBySampVehicleId(i)
		if bool and doesVehicleExist(veh) and isCarModel(veh, model) then
			BlockSync = true
			dialog_response = true
			
			local x, y, z = getCarCoordinates(veh)
			sampSendExitVehicle(i)

			


			local veh_health = getCarHealth(veh)

			SendSync{pos = {x, y, z}, manual = "vehicle", id = i, vehicleHealth = veh_health}

			


			if until_dialog then while dialog_response do wait(1) end end

	
			if list then
				for k, v in ipairs(list) do
					SendSync{pos = {v[1], v[2], v[3]}, manual = "vehicle", id = i, vehicleHealth = veh_health}
				end
			end
		

			return i, x, y, z, veh_health
		end
	end
	return false
end






local rename = function(t, data, rename)
	if t[data] then return end
	t[data] = t[rename]
	t[rename] = nil
end


local print, encodeJson = print, encodeJson

SendSync = function(t)
	local state = { my_state() }

	local s = samp_create_sync_data(t and ( (t.a or t.manual)  or state[1]) or state[1])

	-- if t and t.pos then setCharCoordinates(1, t.pos[1], t.pos[2], t.pos[3]) end

	if t then
		print("SYNC", encodeJson(t), state[1])
		rename(t, state[1] == "player" and "weapon" or "currentWeapon", "weapon")
		rename(t, "keysData", "key")
		rename(t, "specialKey", "spec")
		rename(t, "position", "pos")
		rename(t, "quaternion", "quat")
		rename(t, "surfingVehicleId", "surf")
		rename(t, "pick", "pic")
		rename(t, "vehicleId", "id")

		if IsCharSurfing or IsCharSurfing then t.surfingVehicleId = cfg["Лодка"].id Noti('SENDSYNC SURF')end
		for k, v in pairs(t) do


			if k ~= "a" and k ~= "f" and k ~= "pick" and k ~= "msg" and k~= 'force' and k ~= 'mes' and k ~= 'manual' then
				s[k] = v
			end
		end
	else
		print("FORCE SYNC", state[1])
	end

	s.send()

	if t then
		if t.pick then sampSendPickedUpPickup(t.pick) end
		if t.msg or t.mes then sampSendChat(t.msg or t.mes) end
		if t.f or t.force then SendSync() end
	end

end



-- SendSync = function(t)

-- 	local status, car_handle_auto, car_seatid = my_state()

-- 	if t and t.id then
-- 		status = 'vehicle'
-- 		local bool, car_hanlode = sampGetCarHandleBySampVehicleId(t.id)
-- 		car_handle_auto = car_hanlode

		
-- 		t.pos = {getCarCoordinates(car_hanlode)}
-- 	end


-- 	if status == 'vehicle' then
-- 		t.vehicleHealth = getCarHealth( car_handle_auto )
-- 		msg('hp ystanovleno')
-- 	end

-- 	local data = samp_create_sync_data(status)

-- 	-- if t and t.pos then setCharCoordinates(1, t.pos[1], t.pos[2], t.pos[3]) end

-- 	if t then
-- 		print("SYNC", encodeJson(t), status)
-- 		rename(t,  status == "player" and "weapon" or "currentWeapon", "weapon")
-- 		rename(t, "keysData", "key")
-- 		rename(t, "specialKey", "spec")
-- 		rename(t, "position", "pos")
-- 		rename(t, "quaternion", "quat")
-- 		rename(t, "surfingVehicleId", "surf")
-- 		rename(t, "pick", "pic")
-- 		rename(t, "vehicleId", "id")

-- 		if IsCharSurfing then t.surfingVehicleId = cfg["Лодка"].id Noti('SENDSYNC SURF')end

-- 		for k, v in pairs(t) do
-- 			if k ~= "a" and k ~= "f" and k ~= "pick" and k ~= "msg" and k~= 'force' and k ~= 'mes' and k ~= 'manual' then
-- 				data[k] = v
-- 			end
-- 		end
-- 	else
-- 		print("FORCE SYNC", status)
-- 	end

-- 	data.send()

-- 	if t then
-- 		if t.pick then sampSendPickedUpPickup(t.pick) end
-- 		if t.msg or t.mes then sampSendChat(t.msg or t.mes) end
-- 		if t.f or t.force then SendSync() end
-- 	end

-- end






-- sampRegisterChatCommand('te', function ()

-- 	lua_thread.create(function ()
		

-- 		for i = 1, 100, 1 do
-- 			NoKick()
-- 			sampForceOnfootSync()
-- 			wait(600)
-- 		end
		
		
-- 	end)

	
	

-- end)

-- SendSync{pos = {21, 12, 332}}
-- SendSync{pos = {21.3223, 12.3213, 332.2}}