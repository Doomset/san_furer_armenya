local imgui = require('mimgui')

local ffi = require('ffi')
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local extra = require('sfa.imgui.extra')


local last_pass, last_nick = '', ''
local shr = cfg['����������']

local gui = function ()

   
    local b, b2 = new.bool(shr["������"]), new.bool(shr["����� ���"].on)

  


    if imgui.Checkbox("status", b) then
        shr["������"] = not shr["������"]
        cfg()
    end

    extra.Separator()

    if imgui.Checkbox(u8"����� ���", b2) then
        shr["����� ���"].on = not shr["����� ���"].on
        cfg()
    end


    imgui.SameLine()

    local pass = new.char[24](shr["����� ���"].pass)


    imgui.PushItemWidth(110)
    if imgui.InputText("##ap", pass, sizeof(pass)) then
        shr["����� ���"].pass = str(pass)
        cfg()
    end
    imgui.PopItemWidth()
    extra.Separator()

    
    imgui.PushItemWidth(110)
    local twink = new.bool(shr['�������']["�����"])
    if imgui.Checkbox(u8"���������", twink) then
        shr['�������']["�����"] = twink[0]
        cfg()
    end
    imgui.PopItemWidth()
   
    


    imgui.Text("pass, nick, state, del")
    extra.Separator()

    
    for k, v in ipairs(shr["�������"]["����"]) do

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
            table.remove(shr["�������"]["����"], k)
            cfg()
        end
        imgui.PopID()
        extra.Separator()
    end


    if imgui.Button("add", {400, 15}) then
        table.insert(shr["�������"]["����"], {pass = last_pass, nick = last_nick, on = false})
        cfg()				
    end


end



local attempt_to_login = 0

reg('dialog', function (data)
    if not shr["������"] then return end
    
    local f = data.title
    if shr["������"] and ( f:find('���� �����������') or f:find('�������� ��� ���������') or f:find('����������� ��������') or f:find('���� �����') ) then
        if attempt_to_login ~= 0 and f:find('���� �����') then Noti('�� ���������� ������, ��������� ������ �� ��������� ����') shr["������"] = false return end

        local myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))


        if shr["����� ���"].on then sampSendDialogResponse(data.id, 1, -1, f:find('����������� ��������') and " " or shr["����� ���"].pass) print("AUTOLOGIN") return false end


        
        for k, v in ipairs(shr["�������"]["����"]) do
            if v.on and (string.lower(v.nick) == string.lower(sampGetPlayerNickname(myid))) then
                print("AUTOLOGIN")
                sampSendDialogResponse(data.id, 1, -1, f:find('����������� ��������') and " " or v.pass)
                return false
            end
        end



    end


    if shr["�������"]["�����"] and f:find("������� ������������") then
        handler('dialog', {t = '���������'})
        handler('dialog', {t = '������� ���������', s = 2, i = '���������� ��������'})
        sampSendChat("/�����")
        return false
    end
end)

reg('message', function (data)
    if not shr["������"] then return end
    if data.text:find('��� ��� �������� � ����� ���') then
        attempt_to_login = attempt_to_login + 1
        Noti(attempt_to_login..' ������� �����')
    elseif data.text:find('���� �� �����, �� ������ ����!') then
        attempt_to_login = 0
    end
end)




reg('response', function (data)
    if not shr["������"] then return end
    local t = sampGetDialogCaption()

    if t:find('���� �����') or t:find('���� �����������') then
        last_pass,last_nick = data.input, sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    end
    -- lastdialogresponse = {title = t, button = button, select = listboxId, input = input, on = false}
end)





return {"����������", "����������� ����������, ��� ��������� ������� ����� ��, ��� � ������", func = gui}