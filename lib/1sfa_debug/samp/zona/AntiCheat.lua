---@diagnostic disable: cast-local-type




local mod = {}




WARN_ABUSE = function()
    timer("abuse", 6)
    if timer.exist("abuse2") then return end
    msg("����������")
    handler("player_pos", { 2903.17 })
    SendSync { pos = { 1292, 1580, 42 }, key = 2, force = true, manual = "player" }
    sampForceOnfootSync()
    timer("abuse2", 5)
end

-- timers.surf = {os.clock(), 1.2}
-- SendSync{manual = "player", surf = settings["�����"]}
local font              = renderCreateFont('Arial', 9, 13)




-- BlockSync = true

-- SendSync{surf = 1}

local is_passanger = function (car)
    for i = 0, getMaximumNumberOfPassengers(car) do
		if not isCarPassengerSeatFree(car, i) and getCharInCarPassengerSeat(car, i) == PLAYER_PED then
			return true
		end
	end
    return false
end



mod.scan = function(c)
    local store, timer, all_vehs = storeCarCharIsInNoSave, timer.exist("abuse"), getAllVehicles()

    local function isCarLightsOn(car) return (readMemory(getCarPointer(car) + 0x428, 1) > 62) end

    local veh_id = false

    

    if #all_vehs < 1 then return false, timer end


    local mycar_handle = store(PLAYER_PED)
    for _, hand in ipairs(all_vehs) do
        local res, id = sampGetVehicleIdByCarHandle(hand)
        if res and doesVehicleExist(hand) and mycar_handle ~= hand then
            veh_id = id; break
        end
    end

    if not veh_id and doesVehicleExist(mycar_handle) then
        local my_vehId = select(2, sampGetVehicleIdByCarHandle(mycar_handle) )
        if not isCarLightsOn(mycar_handle) and not is_passanger(mycar_handle) then
            SendSync{manual = "vehicle", id = veh_id, key = 512}
        end
        veh_id = my_vehId
    end

    return veh_id, timer
end


local scan_vehs = mod.scan





local mode_2 = function ()
    
    Noti('NO KIKC - ��� ����� �����, �������� ���ب� ����')
    handler("player_pos", { 2903.17 })
    SendSync { pos = { 1292, 1580, 42 }, key = 2, force = true, manual = "player" }
    timer("abuse", 6)
end


NoKick = function()
    local res_id, has_timer = scan_vehs()

    if has_timer then return end

    if res_id then
        msg('veh id')
        timer("abuse", 6)
        sampSendExitVehicle(res_id)
    else
        local surf = function (state)
            IsCharSurfing = state
            SurfingSync = state
            sampForceOnfootSync()
        end
        pL('������ �� �����')
        surf(true)
        wait(1100)
        surf(false)

    end

    
end

--NoKick()

-- f = false
-- d = 1
-- pizda = function ()
--     if not f then f = true NoKick() end

--     msg('dasdasd')
--     timer("abuse11111111 "..d, 6, function ()
--         d = d + 1
--         print(1)
--         msg('ggsasdasdasd')
--         mode_2()
--         pizda()
        
--     end)

-- end
-- pizda()

-- NoKick = function()
--     if timers.timeoutAC[1] ~= -1 then return msg("��� ������") end

--     local id = scan_vehs()
--     timers.timeoutAC = { os.clock(), 7 }
--     if type(carId) == 'number' then return sampSendExitVehicle(id) end

--     handler("player_pos", { 2903.17 })
--     SendSync { pos = { 1292, 1580, 42 }, key = 2, force = true }

--     timers.aftertp = { os.clock(), 3 }
--     --timers.timeoutAC = {os.clock(), 6}
-- end

--print(tableToString(cfg))
-- mode_2()
return mod
