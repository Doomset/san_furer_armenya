local imgui = require('mimgui')

local ffi = require('ffi')
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local extra = require('sfa.imgui.extra')


local last_pass, last_nick = '', ''
local shr = cfg['Автопароль']

local gui = function ()

   
    local b, b2 = new.bool(shr["Статус"]), new.bool(shr["Любой акк"].on)

  


    if imgui.Checkbox("status", b) then
        shr["Статус"] = not shr["Статус"]
        cfg()
    end

    extra.Separator()

    if imgui.Checkbox(u8"Любой акк", b2) then
        shr["Любой акк"].on = not shr["Любой акк"].on
        cfg()
    end


    imgui.SameLine()

    local pass = new.char[24](shr["Любой акк"].pass)


    imgui.PushItemWidth(110)
    if imgui.InputText("##ap", pass, sizeof(pass)) then
        shr["Любой акк"].pass = str(pass)
        cfg()
    end
    imgui.PopItemWidth()
    extra.Separator()

    
    imgui.PushItemWidth(110)
    local twink = new.bool(shr['Функции']["Твинк"])
    if imgui.Checkbox(u8"автотвинк", twink) then
        shr['Функции']["Твинк"] = twink[0]
        cfg()
    end
    imgui.PopItemWidth()
   
    


    imgui.Text("pass, nick, state, del")
    extra.Separator()

    
    for k, v in ipairs(shr["Функции"]["Акки"]) do

        local pass = new.char[24](v.pass)
        local nick = new.char[24](v.nick)
        local on = new.bool(v.on)

        imgui.PushIDInt(k)

        imgui.PushItemWidth(170)
        if imgui.InputTextWithHint("##nick"..k, "nick" ,nick, sizeof(nick)) then
            v.nick = str(nick)
            cfg()
        end
        imgui.PopItemWidth()	

        imgui.SameLine()

        imgui.PushItemWidth(170)
        

        if imgui.InputTextWithHint("##pass"..k, "pass", pass, sizeof(pass)) then
            v.pass = str(pass)
            cfg()
        end
    
        imgui.PopItemWidth()
        imgui.SameLine()

        if imgui.Checkbox("##"..k, on) then
            v.on = not v.on
            cfg()
        end
        imgui.SameLine()

        if imgui.Button("X", {18, 18}) then
            table.remove(shr["Функции"]["Акки"], k)
            cfg()
        end
        imgui.PopID()
        extra.Separator()
    end


    if imgui.Button("add", {400, 15}) then
        table.insert(shr["Функции"]["Акки"], {pass = last_pass, nick = last_nick, on = false})
        cfg()				
    end


end



local attempt_to_login = 0

reg('dialog', function (data)
    if not shr["Статус"] then return end
    
    local f = data.title
    if shr["Статус"] and ( f:find('Окно Регистрации') or f:find('Выберите пол персонажа') or f:find('Регистрация реферала') or f:find('Окно Входа') ) then
        if attempt_to_login ~= 0 and f:find('Окно Входа') then Noti('не правильный пароль, автологин оффнут во избежании кика') shr["Статус"] = false return end

        local myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))


        if shr["Любой акк"].on then sampSendDialogResponse(data.id, 1, -1, f:find('Регистрация реферала') and " " or shr["Любой акк"].pass) print("AUTOLOGIN") return false end


        
        for k, v in ipairs(shr["Функции"]["Акки"]) do
            if v.on and (string.lower(v.nick) == string.lower(sampGetPlayerNickname(myid))) then
                print("AUTOLOGIN")
                sampSendDialogResponse(data.id, 1, -1, f:find('Регистрация реферала') and " " or v.pass)
                return false
            end
        end



    end


    if shr["Функции"]["Твинк"] and f:find("Система безопасности") then
        handler('dialog', {t = 'Сложность'})
        handler('dialog', {t = 'Уровень сложности', s = 2, i = 'Пропустить обучение'})
        sampSendChat("/твинк")
        return false
    end
end)

reg('message', function (data)
    if not shr["Статус"] then return end
    if data.text:find('Еще раз ошибёшься и будет кик') then
        attempt_to_login = attempt_to_login + 1
        Noti(attempt_to_login..' попыток входа')
    elseif data.text:find('Если не зайти, то пишите Кузе!') then
        attempt_to_login = 0
    end
end)




reg('response', function (data)
    if not shr["Статус"] then return end
    local t = sampGetDialogCaption()

    if t:find('Окно Входа') or t:find('Окно Регистрации') then
        last_pass,last_nick = data.input, sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    end
    -- lastdialogresponse = {title = t, button = button, select = listboxId, input = input, on = false}
end)





return {"Автопароль", "Примитивный автопароль, при появлении диалога введёт то, что в инпуте", func = gui}