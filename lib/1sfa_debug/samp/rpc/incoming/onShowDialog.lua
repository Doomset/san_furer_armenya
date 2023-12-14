local dialogs = {}


require('lib.samp.events').onShowDialog = function(id, style, title, button1, button2, text)
	-- if not dialogs[id] then
	-- 	dialogs[id] = title
	-- elseif dialogs[id] then
	-- 	Noti('DIALOG EXIST !!!!! '.. title..id, INFO)
	-- end

	if title:find('Связной') then

	
	    -- ('Аптечка %(надо нарыть%)')
		-- ('Антирадин %(надо нарыть%)')
		-- ('Еда (надо нарыть)')
		-- ('Водка %(надо нарыть%)')
		-- ('Бронежилет %(надо нарыть%)')
		-- ('Автомат %(надо нарыть%)')
	end


	

	-- if id == 6 then
	-- 	list_inv = {}
	-- 	for line in text:gmatch('[^\n]+') do
	-- 		list_inv[#list_inv + 1] = line
	-- 	end

	-- 	inventar.switch()
	-- 	sampSendDialogResponse(id, 0, -1, "")
	-- 	return false
	-- end



	
	for k, v in ipairs(cfg["Диалоги"]["Список"]) do
		if v.on and title:find(v.title) then
			sampSendDialogResponse(id, v.button, v.select, v.input)
			print('settings["Диалоги"]["Список"]', "Послан ответ дииалог ", id, v.button, v.select, v.input)
			return false
		end
	end


	if Рюкзак:Парс(title, text, id) then return false end

	if title:find("Медикаменты") then
		Рюкзак.Список["Аптечки"], Рюкзак.Список["Антирадин"] = text:match("Аптечки	(%d+)"), text:match("Антирадин	(%d+)")
	elseif title:find("Продукты") then
		Рюкзак.Список["Консервы"], Рюкзак.Список["Водка"] = text:match("Консервы	(%d+)"), text:match("Водка	(%d+)")
	elseif title:find("Наркотики") then
		Рюкзак.Список["Винт"] = text:match("Винт	(%d+)")
	elseif title:find("Инструменты") then
		Рюкзак.Список["Ремнаборы"], Рюкзак.Список["Канистры"], Рюкзак.Список["Отмычки"] = text:match("Ремнаборы	(%d+)"), text:match("Канистры	(%d+)"), text:match("Отмычки	(%d+)")
	end

if handler.has("dialog", {id, title}) then return false end

	
end

