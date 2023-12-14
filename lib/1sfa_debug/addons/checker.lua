---@diagnostic disable: need-check-nil, param-type-mismatch, duplicate-set-field


local settings = require('sfa.Config')({
    window_pos = {60, 400},
    users_list = { 
        "Kuzya",
        "Flowers",
        "Artemis",
        "quest",
        "Kesa_Falenkton",
        "kSenx",
        "Nikita",
        "Hashirama",
        "Loyso",
        "Freak",
        "NORON",
        "Nikolay",
        "JoJo_Flex",
        "HighlandeR",
        "Vlad_Hardy",
        "aton",
        "mikasa",
        "Izumrudik",
        "nil",
        "tsiklotim_lk",
        "zxcsnus",
        "sonirozu",
        "Tsiklotimik",
        "Muzan",
        "Mado",
        "Kreon",
        "Caesar",
        "Cesar",
        "John_Tiler",
        "Danya",
        "ithev",
        "Astarsos",
        "BOPOHA",
        "Melissa",
        "VelialGFX",
        "Frozen",
        "Uyr",
        "Dragon_Ryu",
        "Ryusik",
        "Ryuslan",
        "Ryu_Dragon",
        "Wonder_OF_U",
        "Gedeon",
        "DeAdShOt",
        "Kingslayer",
        "Smart_Arrow"
    },
    message_on_join_and_left = true,
},  "\\sfa\\addons\\checker.json")



local online_users = {}

local add_user = function(id, nickname)
    if not nickname then nickname = sampGetPlayerNickname(id) end
    for _, v in ipairs(settings.users_list) do
        if string.lower(v) == string.lower(nickname) then
            if settings.message_on_join_and_left then
                msg("Enter player", id, nickname)
            end
            table.insert(online_users, {
                id = id,
                nickname = v,
                clock = os.clock()
            })
            break
        end
    end
end



local quitReason = {"1", "2", "3"}
local remove_user = function(id, reason)
    for i, v in ipairs(online_users) do
        if v.id == id then
            if settings.message_on_join_and_left then
                msg("exit player", v.nickname, id, quitReason[reason + 1])
            end
            table.remove(online_users, i)
            break
        end
    end
end



local psi_list = {
    state = false,
    show = function(self)
        self.state = true
        sampSendChat("/список")
    end
}



local rebuild_users = function()
    online_users = {}
    for id = 0, 100 do
        if sampIsPlayerConnected(id) then
            add_user(id)
        end
    end
end


rebuild_users()


---////samp
local sampev           = require('lib.samp.events')

function sampev.onPlayerJoin(id, _, _, nickname)
    add_user(id, nickname)
end



function sampev.onPlayerQuit(id, reason)
    remove_user(id, reason)
end


reg('dialog', function (data)
    local id, title, text = data.id, data.title, data.text
    if title:find("Псиопсы на дежурстве") then
        for line in text:gmatch('[^\n]+') do
            local id, nick = line:match("%[(%d+)%] ([A-z]+)")
            if id then
                local find = false
                for _, v in ipairs(settings.users_list) do
                    if string.lower(v) == string.lower(nick) then
                        find = true
                        break
                    end
                end
                if not find then
                    table.insert(settings.users_list, nick)
                    settings()
                    rebuild_users()
                end
            end
        end
        msg(data.text)
        sampSendDialogResponse(id, 0, 0, "")
        return false
    end

    if psi_list.state and title:find("Список игроков онлайн") then
        psi_list.state = false
        sampSendDialogResponse(id, 1, 0, "")
        return false
    end

end)


local extra = require('sfa.imgui.extra')




function sampev.onUpdateScoresAndPings(data)
    
end


---///imgui--//imgui
local imgui = require 'mimgui'
local ffi              = require 'ffi'
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local font  = {}








function imgui.AutoAlign()
    local d_size = imgui.GetIO().DisplaySize
    local last_window_sizeX = imgui.GetWindowWidth()
    local w_pos = imgui.GetWindowPos()

    local x, y
    local w_sizeY = imgui.GetWindowSize().y


    if w_pos.x >= d_size.x - last_window_sizeX then -- Проверка на выход за стороны (справа)
        print("1")
        x = d_size.x - last_window_sizeX / 2 - 1
        y = w_pos.y + w_sizeY / 2
    elseif w_pos.x < 0 then -- Проверка на выход за стороны (слева)
        print("2")
        x = last_window_sizeX / 2 
        y = w_pos.y + w_sizeY / 2 
    elseif (w_pos.y + w_sizeY) > d_size.y then
        print("3")
        y = d_size.y - w_sizeY / 2
        x = w_pos.x + last_window_sizeX / 2
    elseif w_pos.y < 0 then
        print("4")
        x = w_pos.x + last_window_sizeX / 2
        y = w_sizeY / 2
    end

    return x, y
end





local render_users = function ()
    if imgui.BoolText("checker") then
        psi_list:show()
    end
    for _, v in ipairs(online_users) do
        local a = extra.bringFloatTo(0.0, 1.0, v.clock, 0.20)
        local _, r, g, b = extra.explode_argb(sampGetPlayerColor(v.id))
        local col_player = extra.con(r, g, b, 1)
        imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, a)
        extra.color_text(col_player, "%s[%.0f]", v.nickname, v.id)
        imgui.PopStyleVar()
    end
end




local saved_pos = true
local x, y = settings.window_pos[1], settings.window_pos[2]
local overlay = imgui.OnFrame(function() return isSampAvailable() and sampGetPlayerCount(true) > 0 end,
function(self)
   
    local isDrag = imgui.IsMouseDragging(0)
    local window_flags = imgui.WindowFlags.NoDecoration + imgui.WindowFlags.AlwaysAutoResize +
            imgui.WindowFlags.NoFocusOnAppearing + imgui.WindowFlags.NoNav --+ imgui.WindowFlags.NoBackground
    do

        imgui.SetNextWindowPos({ x, y }, x and 1 or 2, saved_pos and imgui.ImVec2(0, 0) or imgui.ImVec2(0.5, 0.5))
        imgui.Begin("checker", new.bool(1), window_flags)
        saved_pos = false
        x, y = imgui.AutoAlign()
        render_users()
        local w_pos = imgui.GetWindowPos()
        
        if settings.window_pos[1] ~= w_pos.x then
            local w_size = imgui.GetWindowSize()
            settings.window_pos = {w_pos.x , w_pos.y}
            settings()
        end
        
        imgui.End()
    end
end)

overlay.HideCursor = true


local mod = {}


local input = new.char[0xFFFF](table.concat(settings.users_list, '\n'))


mod.gui = function ()
    local res = imgui.GetIO().DisplaySize
    do
        if imgui.InputTextMultiline('##userslist', input, sizeof(input), imgui.ImVec2(150, -1)) then
            local parseText = function(text)
                local tempTable = {}
                for user in text:gmatch('([%w+%d+%[%]_@$]+)') do table.insert(tempTable, user) end
                return tempTable
            end
            settings.users_list = parseText(str(input))
            rebuild_users()
            settings()
        end
    end
end


sampRegisterChatCommand('checker', function(arg)

end)



return mod