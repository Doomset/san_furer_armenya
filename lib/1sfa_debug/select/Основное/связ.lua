
local t = {
    {info = "����� ����", action = "NoKick() -- ������"},
    {info = "�������� ������ ������������� �����", action = "�����_�����(1)"},
    {info = "������ �������", action = "�����('31')"},
    {info = "������ �����", action = "addArmourToChar(PLAYER_PED, 100)"},
    {info = "", action = "handler('dialog', {t = '�������'})"},
    {info = "", action = "��������(1)"},
    {info = "", action = "�����_�����(1)"},
    {info = "", action = "��������(3)"},
    {info = "����� ����", action = "NoKick()"},
    {info = "", action = "handler('dialog', {t = '�������'})"},
    {info = "", action = "��������(1)"},
    {info = "����� ����", action = "NoKick()"},
    {info = "����� ����� ��������� (������)", action = "SendSync{ pos = {211.5 , 1922.875 , 17.625}, pick = cfg['������']['2152.09'].id}"},
    {info = "", action = "SendSync{ pos = {308.68273925781, -131, 1099}}"},
    {info = "", action = "SendSync{ pos = {-145, 437, 12}}"},
    {info = "", action = "��������(0)"},
    {info = "����� ����", action = "NoKick()"},
    {info = "����� ����� ������ (������)", action = "local p=cfg['������']['1012.29'] exSync{ pos = p.pos, p = p.id}"},
    {info = "����� ����� ������ (����)", action = "local p=cfg['������']['2567.37']  exSync{ pos = p.pos, p = p.id}"},
    {info = "����� ����", action = "NoKick()"},
    {info = "����� ����� ������ (�����)", action = "local p=cfg['������']['1902.39']  exSync{ pos = p.pos, p = p.id}"},
    {info = "����� ����� ������ (������)", action = "local p=cfg['������']['685.78']   exSync{ pos = p.pos, p = p.id}"},
    {info = "", action = "��������(1)"},
    {info = "", action = "SendSync{ pos = {278.30606079102, 1360.9072265625, 10.625912666321}}"},
}




local aptechka = function () �������_���_�������(true, 1); end
local antiradin = function () �������_���_�������(false, 1); end
local eda = function () ���_���_�����(true, 1) end
local vodka = function () ���_���_�����(false, 1) end






����_������ = function()
	for k, v in pairs(need_list) do
        if k then
            v[2]()
            wait(3300)
        end
    end
end




local init = function (name)

    local  init = {
        dialogs = {
            {info = "�������� ������ ������������� �����" , name = '�������', wait = true, handler = function ()
                �����_�����(1)
            end},
    
    
            {info = "������� �����" , name = '888888888', wait = true, handler = function ()
            
            end},
    
    
    
        },
        check = {
            {info = '����� �����', name = 1630.3, pos = {-349.14218139648, 1921.7875976563, 59.548782348633}, wait = true },
        }
    }
    init_actions(init)

    local find, need_list = string.find, nil
    reg('dialog', function (data)
    
    
        if name ~= FuncActiveName then return end
    
        if data.title:find(act.dialogs[curent_index_for_handler].name) then
            need_list = {
                ������� =    {find(data.text, '������� %(���� ������%)'), aptechka},
                ��������� =  {find(data.text, '��������� %(���� ������%)'), antiradin},
                ��� =        {find(data.text, '��� %(���� ������%)'), eda},
                ����� =      {find(data.text, '����� %(���� ������%)'), vodka},
            }
    
    
            sampSendDialogResponse(data.id, 0, 1, '')
    
            act.dialogs[curent_index_for_handler].wait = false
            last_delay = 3300
        
            return false
        end
    end)
    
    
    reg('check', function (data)
        if name ~= FuncActiveName then return end
    end)
end


















local body = {
    name = '����',
    icon = 'SCHOOL',
    hint = [[������ ���������, �������� �������� ������ �� 15,���������� ��� � 3.3 ������� ���� �������
    �� ����� ���������� ������� ����� ������, ������, ������
    (�� ������ � ���������� ���� � ����� ��� ����� ������ �����)]],
    func =
    function()

        init('����')

        NoKick()

        addArmourToChar(PLAYER_PED, 100)
        �����('31')


       
        local parse = function (t)
            for k, v in ipairs(act[t]) do
                curent_index_for_handler = k
                NoKick()
                if v.pos then
                    SendSync{pos = v.pos, key = 1024, force = true}
                else
                    v.handler()
                end
                if catch(t, k, v.info) then wait(last_delay) end
                msg(k)
            end
        end


        parse('dialogs')

        
    --    parse(check)
       
        -- handler("player_pos", {3389.5})
        -- for k, v in ipairs{"�����", "���������", "���������", "�������", "�����"} do
        --     handler("dialog", {t = v}, 55)
        -- end
        -- sendPos{t = coords, delay = 5000, key = 1024}
    end
}










return body
