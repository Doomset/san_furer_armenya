local init = function (name)

    local init = {
        dialogs = {
            {info = '�������� ������� �������', name = '�����', pos = {269.54354858398, 120.4239730835, 3004.6171875}, wait = true },
            {info = '������ ���������', name = '���������', pos = {277.24374389648, 110.52352142334, 3008.8203125}, wait = true },
            {info = '������ ���������', name = '���������', pos = {255, 115, 3009}, wait = true },
            {info = '�������� �����', name = '������� ������� � ������', pos = {277.83584594727, 125.22169494629, 3008.8203125}, wait = true },
            {info = '�������� �����', name = '�����', pos = {260.84017944336, 109.93097686768, 3004.6171875}, wait = true },
        },
        check = {
            {info = '����� �����', name = 1630.3, pos = {-349.14218139648, 1921.7875976563, 59.548782348633}, wait = true },
        }
    }

    init_actions(init)


    reg('dialog', function (data)
        if name ~= FuncActiveName then return end
    
        if data.title:find(act.dialogs[curent_index_for_handler].name) then
    
            sampSendDialogResponse(data.id, 1, 0, '')
            local is_cd = data.text:match(': �������� (%d+)')
    
            if is_cd then
                raise_error = '� ����� ��! ��� �������� '..is_cd
                return false
            end
    
            last_delay = 3300
            act.dialogs[curent_index_for_handler].wait = false
           
          
            return false
        end
    end)
    
    reg('check', function (data)
        if name ~= FuncActiveName then return end

        if shortPos(data.pos.x, data.pos.y, data.pos.z) == act.check[1].name then
            Noti('Checkpoint')
            act.check[1].wait = false
        end
    end)
end


local body = {
    name = '�����',
    icon = 'SCHOOL',
    hint = [[������ ���������, �������� �������� ������ �� 15,���������� ��� � 3.3 ������� ���� �������
    �� ����� ���������� ������� ����� ������, ������, ������
    (�� ������ � ���������� ���� � ����� ��� ����� ������ �����)]],
    func =
    function(self)

        init('�����')


       
        handler('player_pos', {3389.5})

        local parse = function (t)
            for k, v in ipairs(act[t]) do
                Noti('index '..k)
                curent_index_for_handler = k
                NoKick()
                SendSync{pos = v.pos, key = 1024, force = true}
                if catch(t, k, v.info) then wait(last_delay) end
            end
        end


        parse('dialogs')


        parse('check')
  
        -- handler("player_pos", {3389.5})
        -- for k, v in ipairs{"�����", "���������", "���������", "�������", "�����"} do
        --     handler("dialog", {t = v}, 55)
        -- end
        -- sendPos{t = coords, delay = 5000, key = 1024}
    end
}






return body


