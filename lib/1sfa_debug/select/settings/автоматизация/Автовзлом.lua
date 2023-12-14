    local imgui = require('mimgui')

local ffi = require('ffi')
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local extra = require('sfa.imgui.extra')

local gui = function ()
    local int =  new.float(cfg["���������"]["�������"]["��������"])
    local bool = new.bool(cfg["���������"]["������"])

    imgui.PushItemWidth(100)


    imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - 100)

    if imgui.SliderFloat(u8'##��������', int, 0, 1, "%.2fs", 1) then
        cfg["���������"]["�������"]["��������"] = int[0]
        cfg()
    end
    imgui.PopItemWidth()


    if imgui.Checkbox(u8"������", bool) then
        cfg["���������"]["������"] = not cfg["���������"]["������"]
        cfg()
    end


    extra.color_text(imgui.ImVec4(123 / 255.0, 123 / 255.0, 111 / 255.0, 1), u8("%s, �� �������"), tostring( cfg["���������"]["�������"] ))

    extra.color_text(imgui.ImVec4(123 / 255.0, 123 / 255.0, 111 / 255.0, 1), u8"%s, �� ��� ��������", tostring( cfg["���������"]["������� �������"] ))
end



local blockNextTd

addEventHandler('onReceiveRpc', function(id, bs)
    if cfg["���������"]["������"] then

        if id == 16  then
            local soundId = raknetBitStreamReadInt32(bs)
            if soundId == 36401 and sampTextdrawIsExists(cfg["���������"]["������� �������"]) then
                blockNextTd = true
                print("��������� ������������� �������")
                sampSendClickTextdraw(cfg["���������"]["������� �������"]) --open
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
            if ez == 201 and cfg["���������"]["�������"] ~= data.id then
                cfg["���������"]["�������"] = data.id -- �������
                print("��������� ���������� �������")
                cfg()
            elseif ez == -50 and cfg["���������"]["������� �������"] ~= data.id then
                cfg["���������"]["������� �������"] = data.id -- �������
                print("��������� ���������� �����")
                cfg()
            end
            
            if (position_x == 16 and position_y == -20) then

                if blockNextTd then blockNextTd = nil return false end
                
                if cfg["���������"]["�������"]["��������"] < 0.01 then sampSendClickTextdraw(cfg["���������"]["�������"]) return end

                timer('seif', cfg["���������"]["�������"]["��������"], function ()
                    sampSendClickTextdraw(cfg["���������"]["�������"])
                end)

            end
        end

    end
end)

return  {"���������", "������ ����� �������� ", func = gui}