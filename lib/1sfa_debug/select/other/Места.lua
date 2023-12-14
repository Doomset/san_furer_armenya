local imgui = require("mimgui")

local icon_button = require('sfa.imgui.icon').Button
local extra = require('sfa.imgui.extra')
local input = extra.input()





local places = {}
for k, v in pairs(cfg["Пикапы"]) do
    table.insert(places, {p = {v.pos[1], v.pos[2], v.pos[3]}, n = v.name, id = v.id})
end
table.sort(places, function(a,b ) return a.n < b.n end)


local tp_thread


local f = io.open(getWorkingDirectory()..'\\tpc.ini')
 
if f then
    local xxxx = decodeJson(f:read("*a"))
    for k, v in pairs(xxxx) do
        local x, y, z = tonumber(v.x), tonumber(v.y), tonumber(v.z)
        table.insert(places, {p = {x, y, z}, n = k, id = -1})
    end
    f:close()
end







local search_list = {}

local reset_search = function ()
	search_list = {}
end

reset_search()

input.is_cleared = function ()
	reset_search()
end

local gui = function ()

 
    
    imgui.PushFont(font[16])
    
    imgui.SetCursorPos{100, 3}

    if input:render({200, 15}) then
        reset_search()
        for _, v in ipairs(places) do -- sections
            if input:filt(v.n) then
                table.insert(search_list, v)
            end
        end
    end


    local buttons_size = imgui.ImVec2(input.active and 430 or 135, 15)

    
    -- if not input:active() then

    --     -- imgui.SetCursorPos{60, 3}
    --     -- if imgui.BoolText(selectMesta == 1, u8"МЕСТА") then selectMesta = 1 end

    --     -- imgui.SameLine(290)
    --     -- if imgui.BoolText(selectMesta == 2, u8"ПИКАПЫ") then selectMesta = 2 end
    -- end

    imgui.PopFont()

    
    imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(5, 0.5))

    imgui.BeginChild("Mesta")

    imgui.PushFont(font[14])	

    if tp_thread ~= nil then
        
        local w_size = imgui.GetWindowSize()
        imgui.SetCursorPos{w_size.x /2.3, w_size.y /3.5}
        CircularProgressBar(60, 25, 5)
    else 

        local list = (input.active) and search_list or places
        local clipper = imgui.ImGuiListClipper(#list);
        clipper:Begin(#list, buttons_size.y);
        while (clipper:Step()) do

            for index = clipper.DisplayStart + 1, clipper.DisplayEnd do
                local v = list[index]

                local click, hover = icon_button(u8(v.n), buttons_size)


                local f = function ()

                    input:clear()

                    NoKick()

                    if hover and imgui.IsMouseDoubleClicked(1) then
                        Noti(string.format('Отправлен пикап c фейк позицией - %s[%d]', v.n, v.id), INFO)
                        SendSync{pos = {v.p[1], v.p[2], v.p[3]}, pick = v.id, force = true}
                    else
                        setCharCoordinates(PLAYER_PED, v.p[1], v.p[2], v.p[3])
                        Noti(string.format('Телепорт на координаты - %1.f, %1.f, %1.f %s[%d]', v.p[1], v.p[2], v.p[3], v.n, v.id), OK)
                    end

                    tp_thread = nil
                end


                if click then
                    tp_thread = lua_thread.create_suspended(f)
                    tp_thread:run()
                end

                if index %3 ~= 0 and not input.active then imgui.SameLine() end

                

                if input:is_enter_realeased() then
                    Noti(v.n)
                end

            

                    -- drag(sections, index, function ()
                    -- 	b(self, { v.name, v.icon, v.hint, v.func } )
                    -- end, name_section)
                


            end

        end


        -- for k, v in ipairs(selectMesta == 1 and cfg["Места"] or t) do
        --     imgui.PushIDInt(k)
        --     if input:filt(v.n) then
        --         if input.active then imgui.SetCursorPosX(imgui.GetWindowSize().x /2 - buttons_size.x / 2) end
               

        --         if ((input.is_clicked and #input.chars > 0) and imgui.IsItemClicked(0) or (icon_button(u8(v.n), buttons_size))) then

        --             local f = function ()
        --                 input:null()
        --                 NoKick()
        --                 setCharCoordinates(PLAYER_PED, v.p[1], v.p[2], v.p[3])
        --                 Noti(string.format('Телепорт на координаты - %1.f, %1.f, %1.f %s[%d]', v.p[1], v.p[2], v.p[3], v.n, v.id), OK)
        --                 tp_thread = nil
        --             end
        --             tp_thread = lua_thread.create_suspended(f)
    
        --             tp_thread:run()
        --         elseif imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(1) then

        --             local f = function ()
        --                 input:null()
        --                 NoKick()
        --                 Noti(string.format('Отправлен пикап c фейк позицией - %s[%d]', v.n, v.id), INFO)
        --                 SendSync{pos = {v.p[1], v.p[2], v.p[3]}, pick = v.id, force = true}
        --                 tp_thread = nil
        --             end
        --             tp_thread = lua_thread.create_suspended(f)
    
        --             tp_thread:run()


                   
        --         end




        --       
        --     end
        --     imgui.PopID()
        -- end
        if imgui.Button(u8("Добавить новое +"), buttons_size) then 
            mesta_name, mesta_text = new.char[28](u8""), new.char[28](u8"")
            imgui.OpenPopup("mesta")
        end
    end

  

    if imgui.BeginPopupModal("mesta", _, imgui.WindowFlags.NoCollapse) then
        imgui.Text(u8'Назв??ние места:')
        imgui.SameLine(138)
        imgui.PushItemWidth(175)
        imgui.InputText('##mesteditor', mesta_name, sizeof(mesta_name))
        imgui.PopItemWidth()
        imgui.Text(u8'Координаты места: ')
        imgui.SameLine()
        imgui.PushItemWidth(135)
        imgui.InputText('##mesteditortext', mesta_text, sizeof(mesta_text))
        imgui.PopItemWidth()  
        imgui.SetCursorPosX( (imgui.GetWindowWidth() - 300 - imgui.GetStyle().ItemSpacing.x) / 2 )
        local myposX, myposY, myposZ = getCharCoordinates(PLAYER_PED)
        if not core["Прочее"]["Мои корды"][0] then imgui.StrCopy(mesta_text, string.format("%.0f, %.0f, %.0f, %d", myposX, myposY, myposZ, 0)) end
        imgui.SameLine(282)
        icon_checkbox(u8"##Свои координаты", core["Прочее"]["Мои корды"])
    --	imgui.Hint(u8"Свои коорды, нолик обязателен, так же желателено координаты иммено в ф??рмате x, y, z, 0, придерживаясь запятых, пример в шаблоне без галки", u8"Свои коорды, нолик обязателен, так же желателено координаты иммено в формате x, y, z, 0, придерживаясь запятых, пример в шаблоне без галки")
        if #str(mesta_name) > 0 and #str(mesta_text) > 0 then
            if imgui.Button(u8'Сохранить##mesteditor', imgui.ImVec2(150, 25)) then
                table.insert(cfg["Места"], {
                    n = u8:decode(str(mesta_name)),
                    p = {myposX, myposY, myposZ}
                })

                cfg()
                imgui.CloseCurrentPopup()
            end
        else
        --	imgui.LockedButton(u8'Сохранить', imgui.ImVec2(150, 25))
        --	imgui.Hint(u8'Введены не все параметры', u8'Введены не все параметры')
        end
        ---imgui.SameLine()
        if imgui.Button(u8'Отменить', imgui.ImVec2(200, 15)) then imgui.CloseCurrentPopup() end
    
        imgui.EndPopup()
    end
    imgui.PopFont()
    imgui.EndChild()
    
    imgui.PopStyleVar()
end












local zoom = 115.0







local vec2 = imgui.ImVec2


local convert_from_2dmap_to_global = function (coords)
    local x, y, size = getMapSize()
    local pos_map, size_map = vec2(x, y), vec2(size, size)
                        
    local x, y = -(pos_map.x - coords.x), -(pos_map.y - coords.y)

    local x, y = x / size_map.x, y / size_map.y

    local x, y =  (x * 6000)- 3000, -((y * 6000) - 3000)

    -- local x, y = (x ), -(y - 3000)
    return x, y
end


local convert_from_global3d_to_map = function (coords)
    local x, y, size = getMapSize()
    local pos_map, size_map = vec2(x, y), vec2(size, size)
                        
    local transform3DtoGlobal2D = function(x, y) return x + 3000, -y + 3000 end

    local x,y = transform3DtoGlobal2D(coords.x, coords.y)
    local x, y = x / 6000, y / 6000

    local x, y = (x * size_map.x) + pos_map.x, (y * size_map.y) + pos_map.y

    return x, y
end


local load_coordinates = function (x, y)
    requestCollision(x, y); loadScene(x, y, 520)
    local z = getGroundZFor3dCoord(x, y, 520)
    return x, y, z
end










local ffi = require('ffi');
ffi.cdef([[
    struct stGangzone
    {
        float    fPosition[4];
        uint32_t    dwColor;
        uint32_t    dwAltColor;
    };

    struct stGangzonePool
    {
        struct stGangzone    *pGangzone[1024];
        int iIsListed[1024];
    };
]]);

local function isGangZoneListed(pool, id)
    return (pool.iIsListed[id] ~= 0 and pool.pGangzone[id] ~= nil);
end



local gang_zones =
{
    list = {},
    
    get = function (self)
        local gz_pool = ffi.cast('struct stGangzonePool*', sampGetGangzonePoolPtr())
        for id = 0, 1023 do
            if (isGangZoneListed(gz_pool, id) and not self.list[zoneId]) then
                local pos = gz_pool.pGangzone[id].fPosition
                self.list[id] = {pos1 = {x = pos[0], y = pos[1]}, pos2 = {x = pos[2], y = pos[3]}, color = gz_pool.pGangzone[id].dwColor}
            end
        end
    end,

    draw = function (self)
        for k, v in pairs(self.list) do
            local sx, sy = convert_from_global3d_to_map( vec2(v.pos1.x, v.pos1.y) )
            local ex, ey = convert_from_global3d_to_map( vec2(v.pos2.x, v.pos2.y) )
            imgui.GetWindowDrawList():AddRectFilled({sx, sy}, {ex, ey}, v.color)
        end
    end
}

-- function sampev.onCreateGangZone(zoneId, squareStart, squareEnd, color)
--     self.list[zoneId] = {pos1 = {x = squareStart.x, y = squareStart.y}, pos2 = {x = squareEnd.x, y = squareEnd.y}, color = color}
-- end
gang_zones:get()



-- local draw = function (f)
--     local dl = imgui.GetWindowDrawList()
--     f(args)
-- end

local double_clicked_pos
move_data = nil
function renderMap(mode)

    local x, y, size = getMapSize()
    imgui.SetNextWindowPos({x, y}, 1, {0, 0})
    imgui.SetNextWindowSize({size, size}, 1, {0, 0})
    imgui.Begin('map', _, imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoDecoration + imgui.WindowFlags.NoScrollWithMouse)
    if not sampIsDialogActive() and not sampIsScoreboardOpen() then


        

        local isTextClicked = false


        local mouse = imgui.GetMousePos()
        local x_map_mouse, y_map_mouse = convert_from_2dmap_to_global(mouse)

        
        imgui.SetCursorPos{0, 0}

        local io = imgui.GetIO()
        local pos = imgui.GetCursorScreenPos();
        local uv_min = vec2(0.0, 0.0);                
        local uv_max = vec2(1.0, 1.0);                 
        local tint_col = use_text_color_for_tint and imgui.GetStyleColorVec4(ImGuiCol_Text) or imgui.ImVec4(1.0, 1.0, 1.0, 1.0);  
        local border_col = imgui.GetStyleColorVec4(imgui.Col.Border);

      
        imgui.Image(textures.map, {size, size}, {s})

        -- imgui.   
        -- if imgui.IsItemHovered() then
        --     imgui.BeginTooltip()
        --     local mapx, mapy = getMapSize()


        --     local region_sz = 20.0
        --     local region_x = io.MousePos.x - pos.x - region_sz * 0.5
        --     local region_y = io.MousePos.y - pos.y - region_sz * 0.5
        --     local zoom = 4.0
        --     if (region_x < 0.0) then region_x = 0.0
        --     elseif (region_x > size - region_sz) then region_x = size - region_sz end
        --     if (region_y < 0.0) then region_y = 0.0 
        --     elseif (region_y > size - region_sz) then region_y = size - region_sz;end

        --     -- imgui.Text('1')
        --     -- imgui.Text("Min: (%.2f, %.2f)", region_x, region_y);
        --     -- imgui.Text("Max: (%.2f, %.2f)", region_x + region_sz, region_y + region_sz);

        --     uv0 = vec2((region_x) / size, (region_y) / size);
        --     uv1 = vec2((region_x + region_sz) / size, (region_y + region_sz) / size);

        --     local pos = imgui.GetCursorScreenPos()

        --     local imga_size=  vec2(region_sz * zoom, region_sz * zoom)
            
        --     imgui.Image(textures.map, imga_size, uv0, uv1);

        --    -- local x, y = -(mapx - coords.x), -(pos_map.y - coords.y)
        --     imgui.SetCursorScreenPos{pos.x + imga_size.x/2, pos.y + imga_size.y/2}
        --     imgui.Text(u8('0'))
        --     imgui.EndTooltip();
        -- end
        


        gang_zones:draw()
     

        if zoom > 115 then

            for i, v in ipairs(places) do
                local sub = v.n:gsub(' %(.+%)', '')
                local text = u8(sub)
                local x, y = convert_from_global3d_to_map(vec2(v.p[1],v.p[2]))
                local t_size = imgui.CalcTextSize(text)

                local calced = {x - t_size.x/2, y - t_size.y/2}
                imgui.SetCursorScreenPos(calced)
            
                imgui.PushIDInt(i)
                imgui.PushFont(font[11])
                local is_realesed, hover, clicked = extra.BoolText(text)

                imgui.PopFont()

                if is_realesed then isTextClicked = true end

                if clicked then
                    move_data = {i}
                end
                if is_realesed then
                    msg(v.p[1], v.p[2], v.p[3])
                    double_clicked_pos = imgui.GetMousePos()
                    
                    tp_thread = lua_thread.create_suspended(function ()
                        local x, y, z = load_coordinates(x_map_mouse, y_map_mouse)
                        NoKick()
                        setCharCoordinates(1, v.p[1], v.p[2], v.p[3])
                        tp_thread = nil
                    end)

                    tp_thread:run()

                    
                end
                imgui.PopID()

            end
        end

        -- if move_data and imgui.IsMouseReleased(0) then Noti('re;aeas') move_data = nil end

        
        -- if move_data and imgui.IsMouseDragging(0, 5) then

        --     local mouse = imgui.GetMousePos()
        --     local x_map_mouse, y_map_mouse = convert_from_2dmap_to_global(mouse)

        --     local firstpos = imgui.GetMousePos()


        --     local x, y, z = load_coordinates(x_map_mouse, y_map_mouse)
        --     t[move_data[1]].p = {x, y, z}
        -- --    local x, y = calced[1] - mouse.x, calced[2] - mouse.y

        --   --  print(firstpos.x,  mouse.x)

        --     -- imgui.SetCursorScreenPos{firstpos.x - t_size.x / 2, firstpos.y - t_size.y / 2}
        --     -- imgui.Text(text)

            

            

            
        -- end


        
   --     print(move_data)
       



        if tp_thread ~= nil then
            local x, y, size = getMapSize()
            print(double_clicked_pos, imgui.GetWindowPos().x + double_clicked_pos.x )
            imgui.SetCursorScreenPos{ double_clicked_pos.x , double_clicked_pos.y}
            CircularProgressBar(60, 10, 5)
        else
            if imgui.IsWindowHovered() and not isTextClicked then
                if imgui.IsMouseDoubleClicked(0) then
                
                    double_clicked_pos = imgui.GetMousePos()

                    local f = function ()
                        NoKick()
                        local x, y, z = load_coordinates(x_map_mouse, y_map_mouse)
                        setCharCoordinates(1,  x, y, z)
                        restoreCameraJumpcut()
                        tp_thread = nil
                    end
                    tp_thread = lua_thread.create_suspended(f)

                    tp_thread:run()
                   
                elseif imgui.IsMouseReleased(1) then
                    local func = (getTargetBlipCoordinates() and removeWaypoint or placeWaypoint)
                    func(x_map_mouse, y_map_mouse, 1)
                end
            end
        end



        local blip = {getTargetBlipCoordinates()}
        if blip[1] then
            local x,y = convertCoord(blip[2],blip[3])
            imgui.SetCursorScreenPos{x-12.5,y-12.5}
            imgui.Image(textures.marker, {25, 25})
        end


        local myPos = {getCharCoordinates(playerPed)}
        local my_x,my_y = convertCoord(myPos[1],myPos[2])


        local res, x, y, z = isAnyCheckpointExist()
        if res then
            
            -- print(marker[2],marker[3], marker)
            local marker_x,marker_y = convert_from_global3d_to_map( vec2(x,y ))
            imgui.SetCursorScreenPos{marker_x - 6,marker_y -6}
           
            imgui.GetWindowDrawList():AddTriangle({marker_x - 5, marker_y - 5}, {marker_x + 10, marker_y + 10}, {10, 10}, imgui.GetColorU32Vec4(extra.con(170,0,0,255)))
            
            imgui.GetWindowDrawList():AddRect({marker_x - 6, marker_y - 6}, {marker_x + 11, marker_y + 11}, imgui.GetColorU32Vec4(extra.con(0,0,0,255)), 0, 0, 3)

            imgui.GetWindowDrawList():AddRectFilled({marker_x - 5, marker_y - 5}, {marker_x + 10, marker_y + 10}, imgui.GetColorU32Vec4(extra.con(170,0,0,255)))

            if imgui.InvisibleButton('marker', {11, 11}) then
                msg(x, y, z)
            end


            
            -- renderDrawBox(marker_x-1, marker_y-1, 12, 12, 0xFF000000)
            -- renderDrawBox(marker_x, marker_y, 10, 10, join_argb(155,250,60,60))
        end

       

      
        --my_x-7.5,my_y-7.5, 15,15, (getCharHeading(PLAYER_PED)-getCharHeading(PLAYER_PED)-360-getCharHeading(PLAYER_PED)), join_argb(255,255,255,255)

        --(getCharHeading(PLAYER_PED)-getCharHeading(PLAYER_PED)-360-getCharHeading(PLAYER_PED))
        local cursor_Size = vec2(30, 30)
        local alpha = math.floor(math.sin(imgui.GetTime() * 5 + 4) * 127 + 128) / 255
        imgui.SetCursorScreenPos{my_x- cursor_Size.x/2,my_y-cursor_Size.x/2}

        imgui.Image(textures.player, cursor_Size, nil, nil, {1, 1, 1, alpha})

    end
    imgui.End()
end


local notifications = imgui.OnFrame(function() return isKeyDown(VK_M) end,
function (self)
    zoom = zoom + imgui.GetIO().MouseWheel *200
    renderMap()
end)




function convertCoord(xx,yy)

	local function limitToMap(x, y)
		if x > 3000 then
			x = 3000
		elseif x < -3000 then
			x = -3000
		end
		if y > 3000 then
			y = 3000
		elseif y < -3000 then
			y = -3000
		end
		return x, y
	end

	local mapSize = {getMapSize()}

	local multiplier = mapSize[3] / 6000

	local bottom_y = mapSize[2] + mapSize[3]
	local bottom_x = mapSize[1] + mapSize[3]
	local wx, wy = limitToMap((xx), (yy))
	local x = mapSize[1] + (wx + 3000) * multiplier
	local y = mapSize[2] + mapSize[3] - (wy + 3000) * multiplier
	return x,y
end

function getMapSize()
	local sh, sw = getScreenResolution()
	local map_size = math.floor(sw * 0.8)
	sw = sw - (zoom*4.5)
	map_size = map_size + zoom
	local top_x = sh / 2 - map_size / 2
	local top_y = sw * 0.1

	return top_x,top_y,map_size
end


return {'Места ', 'MAP', true,  "При активации будет автоматически собирать чекпоинты ТОЛЬКО ТЕ, КОТОРЫЕ ПОЯВИЛИСЬ ПОСЛЕ ВКЛЮЧЕНИЯ ЭТОЙ ФУНКЦИИ", gui}