---@diagnostic disable: param-type-mismatch, unreachable-code, missing-parameter, unbalanced-assignments
local mem        = require "memory"
local weapons    = require 'game.weapons'

local encoding   = require 'encoding'
encoding.default = 'CP1251'
u8               = encoding.UTF8


weapons.names[24] = "Deagle"
weapons.names[10] = "Dildo"

local tCars = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck",
    "Trashmaster", "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan",
    "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
    "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy",
    "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley Van",
    "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
    "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet",
    "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher",
    "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista-C", "P-Maverick", "Boxvillde", "Benson", "Mesa",
    "RC Goblin", "Hotring A", "Hotring B", "Bloodring", "Rancher", "Super GT", "Elegant", "Journey", "Bike",
    "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal",
    "Hydra", "FCR-900", "NRG-500", "HPV-1000", "Cement Truck", "Tow Truck", "Fortune", "Cadrona", "FBI Truck", "Willard",
    "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex",
    "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise",
    "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum",
    "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight Flat", "Streak", "Kart", "Mower",
    "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "News Van", "Tug",
    "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam",
    "Launch", "Police Car", "Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha", "Phoenix",
    "Glendale Shit", "Sadler Shit", "Luggage", "Luggage", "Stairs", "Boxville", "Tiller", "Utility"
}



local tSkins = {
    'cj', 'truth', 'maccer', 'andre', 'bbthin', 'bb', 'emmet', 'male01', 'janitor', 'bfori', 'bfost', 'vbfycrp', 'bfyri', 'bfyst', 'bmori', 'bmost', 'bmyap', 'bmybu', 'bmybe', 'bmydj', 'bmyri', 'bmycr', 'bmyst', 'wmybmx', 'wbdyg1', 'wbdyg2', 'wmybp', 'wmycon', 'bmydrug', 'wmydrug', 'hmydrug', 'dwfolc', 'dwmolc1', 'dwmolc2', 'dwmylc1', 'hmogar', 'wmygol1', 'wmygol2', 'hfori', 'hfost', 'hfyri', 'hfyst', 'jethro', 'hmori', 'hmost', 'hmybe', 'hmyri', 'hmycr', 'hmyst', 'omokung', 'wmymech', 'bmymoun', 'wmymoun', 'ofori', 'ofost', 'ofyri', 'ofyst', 'omori', 'omost', 'omyri', 'omyst', 'wmyplt', 'wmopj', 'bfypro', 'hfypro', 'kendl', 'bmypol1', 'bmypol2', 'wmoprea', 'sbfyst', 'wmosci', 'wmysgrd', 'swmyhp1', 'swmyhp2', 'swfopro', 'wfystew', 'swmotr1', 'wmotr1', 'bmotr1', 'vbmybox', 'vwmybox', 'vhmyelv', 'vbmyelv', 'vimyelv', 'vwfypro', 'ryder3', 'vwfyst1', 'wfori', 'wfost', 'wfyjg', 'wfyri', 'wfyro', 'wfyst', 'wmori', 'wmost', 'wmyjg', 'wmylg', 'wmyri', 'wmyro', 'wmycr', 'wmyst', 'ballas1', 'ballas2', 'ballas3', 'fam1', 'fam2', 'fam3', 'lsv1', 'lsv2', 'lsv3', 'maffa', 'maffb', 'mafboss', 'vla1', 'vla2', 'vla3', 'triada', 'triadb', 'sindaco', 'triboss', 'dnb1', 'dnb2', 'dnb3', 'vmaff1', 'vmaff2', 'vmaff3', 'vmaff4', 'dnmylc', 'dnfolc1', 'dnfolc2', 'dnfylc', 'dnmolc1', 'dnmolc2', 'sbmotr2', 'swmotr2', 'sbmytr3', 'swmotr3', 'wfybe', 'bfybe', 'hfybe', 'sofybu', 'sbmyst', 'sbmycr', 'bmycg', 'wfycrk', 'hmycm', 'wmybu', 'bfybu', 'smokev', 'wfybu', 'dwfylc1', 'wfypro', 'wmyconb', 'wmybe', 'wmypizz', 'bmobar', 'cwfyhb', 'cwmofr', 'cwmohb1', 'cwmohb2', 'cwmyfr', 'cwmyhb1', 'bmyboun', 'wmyboun', 'wmomib', 'bmymib', 'wmybell', 'bmochil', 'sofyri', 'somyst', 'vwmybjd', 'vwfycrp', 'sfr1', 'sfr2', 'sfr3', 'bmybar', 'wmybar', 'wfysex', 'wmyammo', 'bmytatt', 'vwmycr', 'vbmocd', 'vbmycr', 'vhmycr', 'sbmyri', 'somyri', 'somybu', 'swmyst', 'wmyva', 'copgrl3', 'gungrl3', 'mecgrl3', 'nurgrl3', 'crogrl3', 'gangrl3', 'cwfofr', 'cwfohb', 'cwfyfr1', 'cwfyfr2', 'cwmyhb2', 'dwfylc2', 'dwmylc2', 'omykara', 'wmykara', 'wfyburg', 'vwmycd', 'vhfypro', 'suzie', 'omonood', 'omoboat', 'wfyclot', 'vwmotr1', 'vwmotr2', 'vwfywai', 'sbfori', 'swfyri', 'wmyclot', 'sbfost', 'sbfyri', 'sbmocd', 'sbmori', 'sbmost', 'shmycr', 'sofori', 'sofost', 'sofyst', 'somobu', 'somori', 'somost', 'swmotr5', 'swfori', 'swfost', 'swfyst', 'swmocd', 'swmori', 'swmost', 'shfypro', 'sbfypro', 'swmotr4', 'swmyri', 'smyst', 'smyst2', 'sfypro', 'vbfyst2', 'vbfypro', 'vhfyst3', 'bikera', 'bikerb', 'bmypimp', 'swmycr', 'wfylg', 'wmyva2', 'bmosec', 'bikdrug', 'wmych', 'sbfystr', 'swfystr', 'heck1', 'heck2', 'bmycon', 'wmycd1', 'bmocd', 'vwfywa2', 'wmoice', 'tenpen', 'pulaski', 'hern', 'dwayne', 'smoke', 'sweet', 'ryder', 'forelli', 'tbone', 'laemt1', 'lvemt1', 'sfemt1', 'lafd1', 'lvfd1', 'sffd1', 'lapd1', 'sfpd1', 'lvpd1', 'csher', 'lapdm1', 'swat', 'fbi', 'army', 'dsher', 'zero', 'rose', 'paul', 'cesar', 'ogloc', 'wuzimu', 'torino', 'jizzy', 'maddogg', 'cat', 'claude', 'lapdna', 'sfpdna', 'lvpdna', 'lapdpc', 'lapdpd', 'lvpdpc', 'wfyclpd', 'vbfycpd', 'wfyclem', 'wfycllv', 'csherna', 'dsherna',
}






local settings = require('sfa.Config')({

    window_pos = {60, 200},

    queue = {
        "draw_id", "nick_and_stels_and_dist", "weapon", "vehicle", "skin", "score_and_ping", "hp_and_armor", "afk",
        "invisible"
    },
    fonts = {
        big = 20, up = 10, down = 13, down2 = 11,
    },

}, "\\sfa\\addons\\player.json")



--табличка с игроками в зоне стрима
local players_list = {}


local add_player = function(p_id)
    for _, v in ipairs(players_list) do
        if v.id == p_id then
            return
        end
    end
    players_list[#players_list + 1] = { id = p_id, clock = os.clock() }
    --table.sort(players_list, function(a, b) return a.id < b.id end)
end



local rebuild_players = function()
    if not isSampAvailable() then return end
    for id = 0, sampGetMaxPlayerId(true) do
        if select(1, sampGetCharHandleBySampPlayerId(id)) then
            add_player(id)
        end
    end
end



local pangit = { Dron = {}, Emi = {} }


main = function()
    rebuild_players()
    while true do
        for _, v in pairs(pangit) do
            for k, v in ipairs(v) do
                if (os.clock() - v > (60 * 5)) then
                    pangit[v][k] = nil
                end
            end
        end
        wait(0)
    end
end



----//samp hooks
local sampev = require('lib.samp.events')

function sampev.onPlayerStreamIn(playerId)
    add_player(playerId)
end

function sampev.onPlayerStreamOut(playerId)
    local remove_player = function(p_id)
        for k, v in ipairs(players_list) do
            if v.id == p_id then
                table.remove(players_list, k)
                break
            end
        end
    end
    remove_player(playerId)
end



function sampev.onPlayerChatBubble(playerId, _, _, _, message)
    local res, _, hp = message:find(".+/(%d+)")
    if res then
        msg(playerId, "Доп хп", hp)
    end
end

function sampev.onServerMessage(color, text)
    local myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))


    local res, _, player_id = text:find(".+%[(%d+)%] создаёт защитного дрона!")
    if res and myid ~= player_id then
        pangit.Dron[player_id] = os.clock()
    end

    local res, _, player_id = text:find(".+%[(%d+)%] с помощью Пангита излучает ЭМИ!")

    if res and myid ~= player_id then
        pangit.Emi[player_id] = os.clock()
    end
end

--//imgui
local imgui            = require 'mimgui'
local ffi              = require 'ffi'
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local font             = {}




local extra = require('sfa.imgui.extra')




imgui.AlignWindow = function()
    local d_size, x, y = imgui.GetIO().DisplaySize, nil, nil
    local w_pos, w_size = imgui.GetWindowPos(), imgui.GetWindowSize()
    if w_pos.x >= d_size.x - w_size.x then -- Проверка на выход за стороны (справа)
        x, y = d_size.x - w_size.x / 2 - 0.1, w_pos.y + w_size.y / 2
    elseif w_pos.x < 0 then                -- Проверка на выход за стороны (слева)
        x, y = w_size.x / 2, w_pos.y + w_size.y / 2
    elseif (w_pos.y + w_size.y) > d_size.y then
        x, y = w_pos.x + w_size.x / 2, d_size.y - w_size.y / 2
    elseif w_pos.y < 0 then
        x, y = w_pos.x + w_size.x / 2, w_size.y / 2
    end
    return x, y
end


-- queque = {
--     self.id, nick, hp, veh, weap, skin
-- }


local fonts = {
    big = -1,
    up = -1,
    down = -1,
    down2 = -1,

    pos_up = 8,
    pos2 = 9,
}


local player =
{
    col_grey = extra.con(94, 94, 94, 1),
    col_player = nil,
    dist = nil,
    id = nil,
    hand = nil, --handle
    nick = nil,
    res = false,




    draw_id = function(self, dummy)
        local p = imgui.GetCursorPos()
        imgui.PushFont(font[settings.fonts.big])
        extra.color_text(self.col_grey, "[%.0f]", dummy and 1 or self.id)
        imgui.PopFont()
        return 1, p
    end,

    afk = function(self, dummy)
        local res, p = dummy or sampIsPlayerPaused(self.id)
        if res then
            p = imgui.GetCursorPos()
            imgui.PushFont(font[settings.fonts.big])
            extra.color_text(self.col_grey, "Afk")
            imgui.PopFont()
        end
        return res, p
    end,

    vehicle = function(self, dummy)
        local res, p = dummy or (isCharInAnyCar(self.hand) or sampGetPlayerSpecialAction(self.id) == 2)
        if res then
            local store = dummy or storeCarCharIsInNoSave(self.hand)

            imgui.PushFont(font[settings.fonts.up])

            p = imgui.GetCursorPos()
            extra.color_text(self.col_grey, "VEHICLE:")
            imgui.PopFont()
            imgui.SetCursorPos { p.x, p.y + fonts.pos_up }
            local _, car_id = sampGetVehicleIdByCarHandle(store)
            imgui.PushFont(font[settings.fonts.down])
            extra.color_text(extra.con(221, 120, 13), "%s[%s]",
                (dummy and 1 or isCharInAnyCar(self.hand)) and (tCars[dummy and 1 or (getCarModel(store) - 399)]) or
                u8 "Джетпак",
                _ and tostring(car_id) or "")
            imgui.PopFont()
        end
        return res, p
    end,

    weapon = function(self, dummy)
        local res, p = dummy or (getCurrentCharWeapon(self.hand) ~= 0)
        if res then
            local w_id = dummy or getCurrentCharWeapon(self.hand)
            imgui.PushFont(font[settings.fonts.up])
            p = imgui.GetCursorPos()
            extra.color_text(self.col_grey, "WEAPON:")
            imgui.PopFont()
            imgui.SetCursorPos { p.x, p.y + fonts.pos_up }
            imgui.PushFont(font[settings.fonts.down])
            extra.color_text(extra.con(221, 120, 13), "%s[%.0f]",
                dummy and weapons.get_name(24) or weapons.get_name(w_id), dummy and 24 or w_id)
            imgui.PopFont()
        end
        return res, p
    end,

    skin = function(self, dummy)
        local skin_id = dummy and 0 or getCharModel(self.hand)
        imgui.PushFont(font[settings.fonts.up])
        local p = imgui.GetCursorPos()
        extra.color_text(self.col_grey, "SKIN:")
        imgui.PopFont()
        imgui.SetCursorPos { p.x, p.y + fonts.pos_up }
        imgui.PushFont(font[settings.fonts.down])
        extra.color_text(extra.con(221, 120, 13), "%s[%.0f]",
            dummy and tSkins[1] or tSkins[skin_id < 1 and skin_id + 1 or skin_id],
            dummy and 0 or skin_id)
        imgui.PopFont()
        return 1, p
    end,

    nick_and_stels_and_dist = function(self, dummy)
        imgui.PushFont(font[settings.fonts.big])
        local has_steals = getStructElement(mem.read(sampGetPlayerStructPtr(self.id), 4, true), 0xB3, 2, false) == 0

        local nick_stealth = string.format("%s%s", dummy and "nick" or self.nick,
            (dummy or has_steals) and "[STEALH]" or "")

            
        extra.color_text(dummy and self.col_grey or self.col_player, nick_stealth)
        imgui.PopFont()
        imgui.SameLine(nil)
        imgui.SetCursorPosX(imgui.GetCursorPosX() - 15)
        local p = imgui.GetCursorPos()
        -- imgui.PushFont(font[settings.fonts.up])
        -- local r = dummy and self.col_grey or self.col_player
        -- extra.color_text(extra.con(r.x + 60, r.y + 60, r.z + 60, 1), "[%.0f]", dummy and 100 or self.dist)
        -- imgui.PopFont()
        return 1, p
    end,

    score_and_ping = function(self, dummy)
        local p = imgui.GetCursorPos()
        imgui.PushFont(font[settings.fonts.down2])
        extra.color_text(self.col_grey, "S: %.0f", dummy and 100 or sampGetPlayerScore(self.id))
        imgui.SetCursorPos { p.x, p.y + (imgui.GetFontSize() - 2) }
        extra.color_text(self.col_grey, "P: %.0f", dummy and 100 or sampGetPlayerPing(self.id))
        imgui.PopFont()
        return 1, p
    end,

    hp_and_armor = function(self, dummy)
        imgui.PushFont(font[settings.fonts.down2])
        local p = imgui.GetCursorPos()
        extra.color_text(extra.con(225, 225, 225, 1), "A: %.0f", dummy and 100 or sampGetPlayerArmor(self.id))
        imgui.SetCursorPos { p.x, p.y + fonts.pos2 }
        extra.color_text(extra.con(180, 25, 29, 1), "H: %.0f", dummy and 100 or sampGetPlayerHealth(self.id))
        imgui.PopFont()
        return 1, p
    end,

    invisible = function(self, dummy)
        local res, p = dummy or (self.dist ~= self.dist)
        if res then
            p = imgui.GetCursorPos()
            extra.color_text(dummy and self.col_grey or self.col_player, "INVIS")
        end
        return res, p
    end,


}


local render = {
    queue = settings.queue,
    
    draw = function(self, dummy)
        for i, v in ipairs(self.queue) do
            local res, p = player[v](player, dummy)
            if dummy then
                imgui.SetCursorPos(p)
                imgui.PushStyleColor(imgui.Col.Button, { 0, 0, 0, 0 })
                imgui.PushStyleColor(imgui.Col.ButtonHovered, { 0, 0, 0, 0 })
                imgui.InvisibleButton("##" .. i, { imgui.GetItemRectSize().x, 20 })
                imgui.PopStyleColor(2)
                if imgui.BeginDragDropSource() then
                    imgui.SetDragDropPayload('##payload', ffi.new('int[1]', i), 23)
                    imgui.Begin("dick", nil,
                        imgui.WindowFlags.Tooltip + imgui.WindowFlags.NoDecoration + imgui.WindowFlags.AlwaysAutoResize)
                    player[v](player, dummy)
                    imgui.End()
                    imgui.EndDragDropSource()
                end
                if imgui.BeginDragDropTarget() then
                    local Payload = imgui.AcceptDragDropPayload()
                    if Payload ~= nil then
                        local swap = ffi.cast("int*", Payload.Data)[0]
                        self.queue[i] = self.queue[swap]
                        self.queue[swap] = v
                        settings.queue = self.queue
                    end
                    imgui.EndDragDropTarget()
                end
            end
            if res and i ~= #self.queue then
                imgui.SameLine()
                imgui.SetCursorPosY(p.y)
            end
        end
    end
}



local im_set = {
    show = false,
    is_fontsize_changed = nil,
}

-- local load_fonts = function()
--     for k, v in pairs(settings.fonts) do
--         for k2, _ in pairs(fonts) do
--             if k == k2 then
--                 break
--             end
--         end
--     end
-- end




local canDrag
local saved_pos = true
local x, y = settings.window_pos[1], settings.window_pos[2]
local _ = imgui.OnFrame(function() return isSampAvailable() and sampGetPlayerCount(true) > 0 end,
    -- function ()
    --     if im_set.is_fontsize_changed then
    --         load_fonts()
    --         imgui.InvalidateFontsTexture()
    --     end
    -- end,
    function(s)
        s.HideCursor = true
        local isDrag
        if canDrag then
            isDrag = imgui.IsMouseDragging(0)
        end

        

        local window_flags = imgui.WindowFlags.NoDecoration + imgui.WindowFlags.AlwaysAutoResize +
            imgui.WindowFlags.NoFocusOnAppearing + imgui.WindowFlags.NoNav +
            (isDrag and 0 or imgui.WindowFlags.NoBackground)
        do
            imgui.SetNextWindowPos({ x, y }, x and 1 or 2, saved_pos and imgui.ImVec2(0, 0) or imgui.ImVec2(0.5, 0.5))
            -- imgui.SetNextWindowPos({ x or 300, y or 400 }, x and 1 or 2, imgui.ImVec2(0.5, 0.5))

            imgui.Begin("pl in stream]", nil, window_flags)

            canDrag = imgui.IsWindowHovered()
          

            saved_pos = false
            x, y = imgui.AlignWindow()
            local col_grey = extra.con(94, 94, 94, 1)

            imgui.PushFont(font[settings.fonts.big])
            extra.color_text(col_grey, "%0.f", sampGetPlayerCount(true) - 1)
            imgui.PopFont()


            imgui.SameLine()

            local mX, mY, mZ = getCharCoordinates(1)
            local t = players_list
            for i = 1, #t do
                local id = t[i].id
                local bool, handle = sampGetCharHandleBySampPlayerId(id)
                if bool and doesCharExist(handle) then
                    local _, r, g, b = extra.explode_argb(sampGetPlayerColor(id))
                    local pX, pY, pZ = getCharCoordinates(handle)
                    player.id = id
                    player.hand = handle
                    player.col_player, player.nick = extra.con(r, g, b, 1), sampGetPlayerNickname(id)
                    player.dist = getDistanceBetweenCoords3d(mX, mY, mZ, pX, pY, pZ)


                    local alpha = extra.bringFloatTo(0, 1, t[i].clock, 0.2)
                    imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)
                    imgui.SetCursorPosX(alpha * 5)
                    render:draw()
                    imgui.PopStyleVar()
                end
            end
            local w_pos = imgui.GetWindowPos()
            if settings.window_pos[1] ~= w_pos.x then
                settings.window_pos = {w_pos.x , w_pos.y}
                settings()
            end
            imgui.End()
        end
    end)

local mod = {}

---@diagnostic disable-next-line: unused-local
mod.gui = function()
    local r = imgui.GetIO().DisplaySize
    imgui.SetNextWindowPos({ r.x / 2, r.y / 2 }, 2, imgui.ImVec2(0.5, 0.5))
    imgui.SetCursorPosX(20)
    imgui.Text("PREWIEV")
    imgui.Separator()
    do
        imgui.BeginChild("DICK", { 300, 100 })
        for k, v in pairs(settings.fonts) do
            local float = new.float(v)
            if imgui.SliderFloat(k, float, 10, 30) then
                im_set.is_fontsize_changed = float[0]
                settings.fonts[k] = float[0]
                settings()
            end
            imgui.Separator()
        end
        imgui.EndChild()
    end
    render:draw(true)
end


return mod
