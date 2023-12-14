    local imgui = require('mimgui')

local ffi = require('ffi')
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local extra = require('sfa.imgui.extra')

local gui = function ()
    local int =  new.float(cfg["Автовзлом"]["Функции"]["Задержка"])
    local bool = new.bool(cfg["Автовзлом"]["Статус"])

    imgui.PushItemWidth(100)


    imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - 100)

    if imgui.SliderFloat(u8'##Задержка', int, 0, 1, "%.2fs", 1) then
        cfg["Автовзлом"]["Функции"]["Задержка"] = int[0]
        cfg()
    end
    imgui.PopItemWidth()


    if imgui.Checkbox(u8"Статус", bool) then
        cfg["Автовзлом"]["Статус"] = not cfg["Автовзлом"]["Статус"]
        cfg()
    end


    extra.color_text(imgui.ImVec4(123 / 255.0, 123 / 255.0, 111 / 255.0, 1), u8("%s, ид отмычки"), tostring( cfg["Автовзлом"]["Отмычка"] ))

    extra.color_text(imgui.ImVec4(123 / 255.0, 123 / 255.0, 111 / 255.0, 1), u8"%s, ид для открытия", tostring( cfg["Автовзлом"]["Отмычка открыть"] ))
end



local blockNextTd

addEventHandler('onReceiveRpc', function(id, bs)
    if cfg["Автовзлом"]["Статус"] then

        if id == 16  then
            local soundId = raknetBitStreamReadInt32(bs)
            if soundId == 36401 and sampTextdrawIsExists(cfg["Автовзлом"]["Отмычка открыть"]) then
                blockNextTd = true
                print("АВТОВЗЛОМ использование отмычки")
                sampSendClickTextdraw(cfg["Автовзлом"]["Отмычка открыть"]) --open
            end
        elseif id == 134 then
            
            local data = {
                id = raknetBitStreamReadInt16(bs),
                flags = raknetBitStreamReadInt8(bs),
                letterWidth = raknetBitStreamReadFloat(bs),
                letterHeight = raknetBitStreamReadFloat(bs),
                letterColor = raknetBitStreamReadInt32(bs),
                lineWidth = raknetBitStreamReadFloat(bs),
                lineHeight = raknetBitStreamReadFloat(bs),
                boxColor = raknetBitStreamReadInt32(bs),
                shadow = raknetBitStreamReadInt8(bs),
                outline = raknetBitStreamReadInt8(bs),
                backgroundColor = raknetBitStreamReadInt32(bs),
                style = raknetBitStreamReadInt8(bs),
                selectable = raknetBitStreamReadInt8(bs),
                pos = {x = raknetBitStreamReadFloat(bs), y = raknetBitStreamReadFloat(bs) },
                modelId = raknetBitStreamReadInt16(bs),
                rotation = {x = raknetBitStreamReadFloat(bs), y = raknetBitStreamReadFloat(bs), z =raknetBitStreamReadFloat(bs)},
                zoom = raknetBitStreamReadFloat(bs),
                color = raknetBitStreamReadInt32(bs),
                text =  raknetBitStreamReadString(bs, raknetBitStreamReadInt16(bs))
            }



            local position_x, position_y = data.pos.x, data.pos.y
            local ez = position_x + position_y
            if ez == 201 and cfg["Автовзлом"]["Отмычка"] ~= data.id then
                cfg["Автовзлом"]["Отмычка"] = data.id -- отмычка
                print("АВТОВЗЛОМ перезапись отмычки")
                cfg()
            elseif ez == -50 and cfg["Автовзлом"]["Отмычка открыть"] ~= data.id then
                cfg["Автовзлом"]["Отмычка открыть"] = data.id -- открыть
                print("АВТОВЗЛОМ перезапись замка")
                cfg()
            end
            
            if (position_x == 16 and position_y == -20) then

                if blockNextTd then blockNextTd = nil return false end
                
                if cfg["Автовзлом"]["Функции"]["Задержка"] < 0.01 then sampSendClickTextdraw(cfg["Автовзлом"]["Отмычка"]) return end

                timer('seif', cfg["Автовзлом"]["Функции"]["Задержка"], function ()
                    sampSendClickTextdraw(cfg["Автовзлом"]["Отмычка"])
                end)

            end
        end

    end
end)

return  {"Автовзлом", "Сейчас стоит задержка ", func = gui}