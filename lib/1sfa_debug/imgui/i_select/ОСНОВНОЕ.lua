
local imgui = require("mimgui")




local list =
{
	{name = "работы"},
	{name = "основное"},
	{name = "прочее"}
}



local campare = cfg.sort['основное']




local require_function = function(section, pos, section_name, name)

	local req_name = 'sfa.select.' .. section_name .. '.' .. name
	
	if not package.preload[req_name] then
		local req = require(req_name)
		-- print(pos)
		table.insert(list[section], pos, req)
		table.insert(Loaded_Icons, req.icon)
	end
end


local find = function (section, element)
	for _, v in ipairs(list[section]) do
		if v.name:lower() == element:lower() then return true end
	end
	return false
end




for i = 1, 3, 1 do -- запрос порядок функций из кфг


	for pos, name in ipairs(campare[i]) do
		if find(i, name) then table.remove(campare[i], pos) cfg() end
		require_function(i, pos, list[i].name, name)
	end

	for _, v in ipairs(getFilesInPath("\\sfa\\select\\" .. list[i].name, '*.lua')) do
		v = v:gsub('%.lua', '')
		if not find(i, v) then
			print('Не найден', v)
			require_function(i, #list[i]+ 1, list[i].name, v)
		end
	end

end


local ffi = require('ffi')

local extra = require('sfa.imgui.extra')


--msg("WWWWWWWWWWWWWWWWWW", list[1][1].name)
local hint = extra.hint








local but = require('sfa.imgui.icon').Button





local drag = function (section, index, b, pizda)
	if isKeyDown(VK_MENU) then
		local p = imgui.GetCursorPos()
		if imgui.BeginDragDropSource() then
			imgui.SetDragDropPayload('##payload', ffi.new('int[1]', index), 23)
			b()
			imgui.EndDragDropSource()
		end


		if imgui.BeginDragDropTarget() then
			local Payload = imgui.AcceptDragDropPayload()
			if Payload ~= nil then
				local OldItemPos = ffi.cast("int*",Payload.Data)[0]
				local old, new = list[section][OldItemPos], list[section][index]
				list[section][OldItemPos] = new
				list[section][index] = old

				cfg.sort.основное[section][index] = old.name
				cfg.sort.основное[section][OldItemPos] = new.name
				cfg()
				Noti(string.format('смена позиции\n%s -> %s\n%s -> %s', old.name, new.name, new.name, old.name), INFO)
			end
			imgui.EndDragDropTarget()
		end
	end
end

local icon = "WAND_MAGIC"
table.insert(Loaded_Icons, icon)
table.insert(Loaded_Icons, "CAR")
local noti = require('sfa.imgui.not')

--

local ToU32 = imgui.ColorConvertFloat4ToU32
local ToVEC = imgui.ColorConvertU32ToFloat4

CircularProgressBar = function(value, radius, thickness, format)
	local p = imgui.GetCursorScreenPos()
	local pos = imgui.GetCursorPos()
	local DL = imgui.GetWindowDrawList()

	local ts = nil

	if type(format) == 'string' then
		format = string.format(format, value)
		ts = imgui.CalcTextSize(format)
	end

	local side = imgui.ImVec2(
		radius * 2 + thickness,
		radius * 2 + thickness + (ts and (ts.y + imgui.GetStyle().ItemSpacing.y) or 0)
	)
	local centre = imgui.ImVec2(p.x + radius + (thickness / 2), p.y + radius + (thickness / 2))

    imgui.BeginGroup()
	 
		imgui.Dummy(side) 

		local corners = radius * 5
	    local col_bg = ToU32(imgui.GetStyle().Colors[imgui.Col.FrameBg])
	    local col = ToU32(imgui.GetStyle().Colors[imgui.Col.ButtonActive])
	    local a1 = 90 - (360 / 100) * (value / 2)
		local a2 = 90 + (360 / 100) * (value / 2)

	    DL:AddCircle(centre, radius, col_bg, corners, thickness / 2)
		DL:PathClear()
        DL:PathArcTo(centre, radius, math.rad(a1) + imgui.GetTime() * 12, math.rad(a2)  + imgui.GetTime() * 12, corners)
		DL:PathStroke(col, 0, thickness)
	
-- PathLineTo(ImVec2(centre.x + ImCos(a + ImGui::GetTime() * speed) * radius,
--                centre.y + ImSin(a + ImGui::GetTime() * speed) * radius));

	    if format ~= nil then
	    	imgui.SetCursorPos(
	    		imgui.ImVec2(
	    			(pos.x + (side.x - ts.x) / 2) + 1.5,
	    			(pos.y + radius * 2 + thickness + imgui.GetStyle().FramePadding.y) / 1.38
	    		)
	    	)
	    	imgui.Text(format)
	    end
	imgui.EndGroup()
end
FuncActiveName = false

local Action_SFA = {}
pL = function(...)
	table.insert(Action_SFA, ...)
end

local scan = require('sfa.samp.zona.AntiCheat').scan

local buttons_size = imgui.ImVec2(166, 18)



local restore_sync = function ()
	if not BlockSync then return end
	BlockSync = false
	SendSync() -- force
end



local searh_list = {
}


local reset_search = function ()
	searh_list = {
		{name = "работы"},
		{name = "основное"},
		{name = "прочее"}
	}
end

reset_search()


local input = extra.input()

input.is_cleared = function ()
	Noti('clear')
	reset_search()
end






local b = function(self, v)
	
	local p2 = hint.p()

	local p = imgui.GetCursorPos()	
	imgui.Dummy(buttons_size)
	imgui.PushFont(font[ (imgui.IsItemHovered() and not imgui.IsMouseDown(0)) and 17 or 15 ] )
	imgui.SetCursorPos(p)
	if but(u8(v[1]), buttons_size, not imgui.IsItemHovered() and v[2] or false) then

	    input:clear()
		
		local id = scan()
		if id and id ~= -1 then sampSendExitVehicle(id) end
		--print("ВЫЗВАНА ФУНКЦИЯ ", v[1])
--					timers.timeout = {os.clock(), 3}
		FuncActiveName = v[1]


		self.active.name = v[1]


		local fu = function ()
			local res, reason = pcall(v[4], self)

			if reason then
				Noti(reason, ERROR)
				restore_sync()
			end
			if res then Noti(string.format('%s -  OK', v[1]), OK) end
			FuncActiveName = false
			self.active.name = false
			self.active.handle = false
		end


		self.active.handle = lua_thread.create_suspended(fu)

		self.active.handle:run()



	end

	imgui.PopFont()
	hint(v[3], p2, buttons_size)

end



return
{
	icon,
	'ОСНОВНОЕ',
	state = '',
	functions = list,
	menu =
    function(self)

		
		--if isKeyDown(1) then sort() end

		imgui.PushStyleVarFloat(imgui.StyleVar.ChildRounding, 0)

		if self.active.handle == false then
			imgui.SetCursorPos{0}
			imgui.BeginChild("hotbar##", {540, 17}, 1, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse) 	
			if input:render() then

				reset_search()


				for sections, child_lists in ipairs(self.functions) do -- sections
					for _, v in ipairs(child_lists) do
						if input:filt(v.name) then
							table.insert(searh_list[sections], v)
						end
					end
				end
			end


			imgui.EndChild()
		end



		local childsize = {177.5, 268}


		if FuncActiveName then

			extra.centerText(Action_SFA[#Action_SFA] or '')
			local size = imgui.GetWindowSize()
			imgui.SetCursorPos{size.x / 2 - 30, size.y / 2 - 60}
			--свитч статусов как в радио ???



			local dva, tri = timer.exist('exception')

			if dva then
				CircularProgressBar( ((dva) / tri * 100), 25, 5)


				if imgui.IsItemClicked(0) then
					timer.remove('exception')
					msg("удален")
				end

			else
				CircularProgressBar(70, 25, 5)
			end

		

			


			local s = imgui.CalcItemWidth()


			imgui.SetCursorPos{size.x / 2 - 120 / 2, 155}
			if imgui.Button('Stop', {120, 20}) then

				FuncActiveName = false

				IsCharSurfing = false
				restore_sync()
				--BlockSync
				self.active.handle:terminate()
				self.active.handle = false
				Action_SFA = {}
			end


		else

			for sections, child_lists in ipairs(self.functions) do -- sections


				local section_name = child_lists.name
				--print(section_name)


				local childp = imgui.GetCursorPos()
				imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(-0.2, -0.2))
				imgui.BeginChild("selectedTab##"..sections, childsize, 1, imgui.WindowFlags.MenuBar + imgui.WindowFlags.NoScrollbar)
				imgui.PopStyleVar()

				if imgui.BeginMenuBar() then
					imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.SetCursorPosY(imgui.GetScrollY() - 3)
					imgui.PushFont(font[12]) imgui.Text(u8(section_name)) imgui.PopFont()
					imgui.PopStyleColor()
					imgui.EndMenuBar()
				end

				local dva, tri = timer.exist("job delay")

				if section_name == "работы" and dva then
					imgui.SetCursorPos{60, 80}
					CircularProgressBar( ((dva) / tri * 100), 25, 5, tostring(math.floor(tri  - dva)))
					
				else


				
					
					imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1, 0.4))

					-- local list = #ffi.string(search) == 0 and playersList or playersListSearch;
						local list = (input.active) and searh_list[sections] or child_lists
						local clipper = imgui.ImGuiListClipper(#list);
						clipper:Begin(#list, buttons_size.y);
						while (clipper:Step()) do

							for index = clipper.DisplayStart + 1, clipper.DisplayEnd do
								local v = list[index]
								b(self, { v.name, v.icon, v.hint, v.func } )


								

								if input:is_enter_realeased() then
									Noti(v.name)
								end

								if cfg.debug and imgui.IsItemClicked(1) then
									local form = string.format(getWorkingDirectory()..'\\lib\\1sfa_debug\\select\\%s\\%s.lua', section_name, v.name)
									os.execute('start explorer '..form)
									print('run '..form)
								end


								drag(sections, index, function ()
									b(self, { v.name, v.icon, v.hint, v.func } )
								end, name_section)
							


							end

						end

					imgui.PopStyleVar()
				end

					

					


		

				imgui.EndChild()
				imgui.SameLine(childp.x + childsize[1] + 4)
				

			end
		end
		imgui.PopStyleVar()



	





		-- -- imgui.SetCursorPosY(imgui.GetCursorPosY() - 2)
		
		-- -- 
		-- -- imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1, 0.4))

		-- -- for i=1, #self.functions do
		-- -- 	local childp = imgui.GetCursorPos()
		-- -- 	local index_section = i
		-- -- 	if IsAnyFuncActiove == false then
		-- -- 		imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(-0.2, -0.2))
		-- -- 		imgui.BeginChild("selectedTab##"..i, childsize, 1, imgui.WindowFlags.MenuBar + imgui.WindowFlags.NoScrollbar)
		-- -- 		imgui.PopStyleVar()
		-- -- 		local name_section = self.functions[i].name
		-- -- 		if imgui.BeginMenuBar() then
		-- -- 			imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
		-- -- 			imgui.SetCursorPosY(imgui.GetScrollY() - 3)
		-- -- 			imgui.PushFont(font[12])
		-- -- 			imgui.Text(u8(self.functions[i].name))
		-- -- 			imgui.PopFont()
		-- -- 			imgui.PopStyleColor()
		-- -- 			imgui.EndMenuBar()
		-- -- 		end

		-- -- 		local time, dva, tri = timer.exist("job delay")

			

		-- -- 		if u8:decode(self.functions[i].name) == "работы" and time then
		-- -- 			imgui.SetCursorPos{60, 80}
		-- -- 			CircularProgressBar( ((dva) / tri * 100), 25, 5, tostring(math.floor(tri  - dva)))
		-- -- 		else
		-- -- 			local t = self.functions[i]
					
		-- -- 			local clipper = imgui.ImGuiListClipper(#t, imgui.GetTextLineHeightWithSpacing())
		-- -- 			if input:active() then
		-- -- 				for i = 1, #t do
		-- -- 				    b { t[i].name, t[i].icon, t[i].hint, t[i].func }
		-- -- 				end	
		-- -- 			else
		-- -- 				while clipper:Step() do	
		-- -- 					for i = clipper.DisplayStart + 1, clipper.DisplayEnd do
					
				
		-- -- 						b { t[i].name, t[i].icon, t[i].hint, t[i].func }

		-- -- 						if cfg.debug and imgui.IsItemClicked(1) then
		-- -- 							local form = string.format(getWorkingDirectory()..'\\lib\\1sfa_debug\\select\\%s\\%s.lua', name_section, t[i].name)
		-- -- 							os.execute('start explorer '..form)
		-- -- 							print('run '..form)
		-- -- 						end

		-- -- 						drag(index_section, i, function ()
		-- -- 							b { t[i].name, t[i].icon, t[i].hint, t[i].func }
		-- -- 						end, name_section)



		-- -- 					end
		-- -- 				end
		-- -- 			end
		-- -- 		end
		-- -- 		imgui.EndChild()
		-- -- 		imgui.SameLine(childp.x + childsize[1] + 4)
		-- -- 	end
		-- -- end
		-- imgui.PopStyleVar(1)
		-- 
		


		
	end
}


