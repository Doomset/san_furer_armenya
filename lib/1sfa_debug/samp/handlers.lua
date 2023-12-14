---@diagnostic disable: lowercase-global
handler = setmetatable -- добавить таймаут
(
    {
        ["player_pos"] = {},
        ["dialog"] = {},
        ["onServerMessage"] = {},
        ["checkpoints"] = {},

        ['surf'] = {},

        remove = function(self, name_handler, index, data)
            print("\n handler", name_handler, "\n", encodeJson(name_handler), "\n", encodeJson(data))
            print(name_handler, index, 'debug')
            table.remove(self[name_handler], index)
            return true
        end
    },
    {
         __index = function(self, key, func)
            if key == "has" then
                return
                    function(name_handler, data)
                        local t2 = self[name_handler]
                        if #t2 < 1 then return end
                        for index, v in ipairs(t2) do
                            if name_handler == "dialog" then
                                local id, title = data[1], data[2]
                                if title:find(v.t) and (v.id or true) then
                                  --  msg(v.t)

                                    
                                    sampSendDialogResponse(v.id or id, v.button and 0 or 1, v.s or 0, v.i or "")

                                    ОТВЕТ_ДИЛАОГ = true
                                    dialog_response = true
                                    print(name_handler, 'hay')
                                    return self:remove(name_handler, index, data)
                                end
                            elseif name_handler == "player_pos" then
                                local pos = data[1]
                                if v[1] == shortPos(pos.x, pos.y, pos.z) then
                                    SendSync{pos = {pos.x, pos.y, pos.z}} -- антиноп??!!!
                                    print('force sync antinope')
                                    return self:remove(name_handler, index, data)
                                end
                            elseif name_handler == "onServerMessage" then
                                local color, text = data[1], data[2]
                                if text:find(v.text) and (v.color and (v.color == color) or true) then
                                    return self:remove(name_handler, index, data)
                                end
                            elseif name_handler == "checkpoints" then
                                local pos = data[1]
                                if shortPos(v.data.pos[1], v.data.pos[2], v.data.pos[3]) == shortPos(pos.x, pos.y, pos.z) then
                                    if index == #self[name_handler] then msg "END CHECK" end
                                    if v.data.id then sampSendExitVehicle(v.data.id) end
                                    SendSync(v.data)
                                    return self:remove(name_handler, index, data)
                                end
                            elseif name_handler == 'surf' then
                                return v.surfingVehicleId
                            end
                        
                        end
                        return false
                    end
            elseif key == "null" then
                return function()
                    self["player_pos"]      = {}
                    self["dialog"]          = {}
                    self["onServerMessage"] = {}
                    self["checkpoints"]     = {}
                end
            end
        end,

        __call = function(self, type, data, t)
            if not self[type] then return msg { type, " error handler" } end

            table.insert(self[type], data or { t = "" })

            timer("timeout_handlers_" .. tostring(data), t or 10, function()
                local index = #self[type]
                print(encodeJson(self[type][index]))
                self[type][index] = nil
            end)
        end
    }
)




local p_3d = function (bs)
	local x, y, z= raknetBitStreamReadFloat(bs), raknetBitStreamReadFloat(bs), raknetBitStreamReadFloat(bs)
	return {x = x,  y= y, z=z}
end

-- {'onSetCheckpoint', {position = 'vector3d'}, {radius = 'float'}}
-- {'onSetRaceCheckpoint', {type = 'uint8'}, {position = 'vector3d'}, {nextPosition = 'vector3d'}, {size = 'float'}}





local hand = {
	{'onReceiveRpc', funcs = {}},

	{'onSendRpc', funcs = {}},

}



-- addEventHandler('onReceiveRpc', function (id, bs)

-- end)




reg = function (event_name, reader, condition)
	condition = condition
	local data = {}
	local t =
	{
		{'onReceiveRpc',
			{
				'dialog', handler =
				function (id, bs)
					if id == 61 then
						data = {
							id = raknetBitStreamReadInt16(bs),
							style = raknetBitStreamReadInt8(bs),
							title = raknetBitStreamReadString(bs, raknetBitStreamReadInt8(bs)),
							btn1 = raknetBitStreamReadString(bs, raknetBitStreamReadInt8(bs)),
							btn2 = raknetBitStreamReadString(bs, raknetBitStreamReadInt8(bs)),
							text = raknetBitStreamDecodeString(bs, 4096),
						}
						return reader(data)
					end
				end
			},
			{
				'check', handler =
				function (id, bs)
					if (id == 107 or id == 38) then -- 38 race
						if id == 107 then
							data = {
								pos = p_3d(bs),
								radius = raknetBitStreamReadFloat(bs),
							}
						else
							data = {
								type = raknetBitStreamReadInt8(bs),
								x, y, z = p_3d(bs),
								nX, nY, nZ = p_3d(bs),
								size = raknetBitStreamReadFloat(bs),
							}
						end
						return reader(data)
					end
				end
			},
			{
				'message', handler =
				function (id, bs)
					if id == 93 then
						data= {
							color = raknetBitStreamReadInt32(bs),
							text = raknetBitStreamReadString(bs, raknetBitStreamReadInt32(bs))
						}
						return reader(data)
					end
				end
			},
		},
        {'onSendRpc',
            {
				'response', handler =
				function (id, bs)
					if id == 62 and sampIsDialogActive() then
						data = {
							id = raknetBitStreamReadInt16(bs),
							response = raknetBitStreamReadInt8(bs),
							item = raknetBitStreamReadInt16(bs),
							input = raknetBitStreamReadString(bs, raknetBitStreamReadInt8(bs)),
						}
						return reader(data)
					end
				end
			},	
        }
	}

	-- INCOMING_RPCS[RPC.CLIENTMESSAGE]              = {'onServerMessage', {color = 'int32'}, {text = 'string32'}}


	for index, events in ipairs(t) do
	--	print(events[1], events[2])
		for _, v in ipairs(events) do
			if event_name == v[1] then

				addEventHandler(events[1], v.handler)
				print('init new hanlder! ', events[1], v[1], v.handler)
				return
			end
		end
	end
	error(event_name)
end

act = {}

FuncActiveName = false

local _assert = assert -- перехватить фукция и отключить флаг с хуком событий.
local assert = function (...)
    if ({...})[1] == false then FuncActiveName = false end
    return _assert(...)
end



init_actions = function (t)
    raise_error = nil
	curent_index_for_handler = 1
	last_delay = 0
    act = t
end

raise_error = nil

catch = function (type, index, info, after_func)
    info = info or act[type][index].name
    pL(info)

    timer('exception', 5)

    while act[type][index].wait do
        assert(timer.exist('exception'), info..' ТАЙМАУТ', 0)

        local ping = sampGetPlayerPing(select(2, sampGetPlayerIdByCharHandle(1)))
        wait(ping)
        assert(not raise_error, raise_error, 0)
    end

    if after_func then after_func() end -- функция после поимки
    return true
end