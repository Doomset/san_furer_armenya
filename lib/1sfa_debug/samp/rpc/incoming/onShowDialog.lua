local dialogs = {}


require('lib.samp.events').onShowDialog = function(id, style, title, button1, button2, text)
	-- if not dialogs[id] then
	-- 	dialogs[id] = title
	-- elseif dialogs[id] then
	-- 	Noti('DIALOG EXIST !!!!! '.. title..id, INFO)
	-- end

	if title:find('�������') then

	
	    -- ('������� %(���� ������%)')
		-- ('��������� %(���� ������%)')
		-- ('��� (���� ������)')
		-- ('����� %(���� ������%)')
		-- ('���������� %(���� ������%)')
		-- ('������� %(���� ������%)')
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



	
	for k, v in ipairs(cfg["�������"]["������"]) do
		if v.on and title:find(v.title) then
			sampSendDialogResponse(id, v.button, v.select, v.input)
			print('settings["�������"]["������"]', "������ ����� ������� ", id, v.button, v.select, v.input)
			return false
		end
	end


	if ������:����(title, text, id) then return false end

	if title:find("�����������") then
		������.������["�������"], ������.������["���������"] = text:match("�������	(%d+)"), text:match("���������	(%d+)")
	elseif title:find("��������") then
		������.������["��������"], ������.������["�����"] = text:match("��������	(%d+)"), text:match("�����	(%d+)")
	elseif title:find("���������") then
		������.������["����"] = text:match("����	(%d+)")
	elseif title:find("�����������") then
		������.������["���������"], ������.������["��������"], ������.������["�������"] = text:match("���������	(%d+)"), text:match("��������	(%d+)"), text:match("�������	(%d+)")
	end

if handler.has("dialog", {id, title}) then return false end

	
end

