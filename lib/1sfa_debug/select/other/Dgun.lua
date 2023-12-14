local imgui, button = nil, nil
local weapons = require 'game.weapons'

local t = {}
    for k, v in pairs(weapons.names) do
        table.insert(t, {id = k, text = v })
    end
    table.sort(t, function(a, b) return a.id < b.id end )


local thread

local imgui = require('mimgui')
local button = require('sfa.imgui.icon').Button

if not cfg['Лодка'].delay then
    cfg['Лодка'].delay = 30
    cfg()
end

local surf_delay = imgui.new.int(cfg['Лодка'].delay)
local gui = function ()

    
    if not doesCharExist(1) then return end


    imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(5, 0.5))



    if thread ~= nil then
        local w_size = imgui.GetWindowSize()
        imgui.SetCursorPos{w_size.x /2.3, w_size.y /3}
        CircularProgressBar(60, 25, 5)
    else  
        if imgui.SliderInt(u8'задержка сюрфа('..(5*surf_delay[0])..')', surf_delay, 0, 500) then
            cfg['Лодка'].delay = surf_delay[0]
            cfg()
        end
        local res = timer.exist("abuse")
        imgui.Text( u8(res and 'быстро выдаст ган'  or 'медленнее выдаст ган(лодка)'))
        
        if imgui.Button('Go', {300, 20}) then
            local f = function ()
                NoKick()
                sampSendExitVehicle(1999)
                thread = nil
            end
            thread = lua_thread.create_suspended(f)

            thread:run()
        end

        imgui.Separator()
        for k, v in ipairs(t) do local d = false
            imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(-1, -1))
            if button(tostring(v.id), {18, 18}) then d = true end
            imgui.SameLine()
            imgui.PopStyleVar()
            if button(v.text, {138 - 18, 18}) or d then
                local f = function ()
                    NoKick()
                    local model = getWeapontypeModel(v.id)
                    requestModel(model)
                    loadAllModelsNow()
                    giveWeaponToChar(1, v.id, 99999)
                    Noti('Выдан '..v.text, OK)
                    thread = nil
                end
                thread = lua_thread.create_suspended(f)

                thread:run()

            end
            if k%3 ~= 0 then imgui.SameLine() end
        end
    end
    imgui.PopStyleVar()	
   
end

return  {'Dgun ', 'GUN',  true, "Залупа хуй говно", gui}
