local get_abobus = function () if not isSampAvailable() then return end end

require('lib.samp.events').onVehicleStreamIn = function ()
    
end


return
{
    name = '�������',
    icon = 'BUS',
    hint = [[����� ����� ��� ������ �����,�� ������, ������]],
    func =
    function()
        sampSendInteriorChange(1)

        BlockSync = true

        local quat = {1/0, 1/0, 1/0, 1}


        local x, y, z =  getCharCoordinates(1)
        
        local mimic_pos = {x, y, z}


        local enter_buss = function(id, hp) SendSync{pos = mimic_pos, manual = "vehicle", id = id, vehicleHealth = hp, quaternion = quat} end --��������� ������ ������� � ���, ��� ��� �������� ��� ��������� �������


        local autobus = function() -- ����� �������� � ���� ������ � ���������� ������� � ����
            for i = 0, 2000 do
                local bool, veh = sampGetCarHandleBySampVehicleId(i)
                if bool and doesVehicleExist(veh) and isCarModel(veh, 431) then
                    local x, y, z = getCarCoordinates(veh)

                    local veh_health = getCarHealth(veh)
                    sampSendExitVehicle(i)

                    enter_buss(i, veh_health)

                    return i, x, y, z, veh_health, veh
                end
            end
            return false
        end


        local dialog_handler = function ()--�����_������ = nil handler('dialog', {t = '�������'}, 30)
            �����_������ = nil
            handler('dialog', {t = '�������'}, 30)
        end


        local block_messages = function () -- '������ ����� ������ ������ �������� � �����.'
            handler('onServerMessage', {text = '������ ����� ������ ������ �������� � �����.', color = 267386880}, 30)
            handler('onServerMessage', {text = '���������� �� ������, ���������������� �� ����������', color = 267386880}, 30)
            handler('onServerMessage', {text = '���� ������ %- ��������� �������� �����!', color = 267386880}, 30)
            handler('onServerMessage', {text = '�� ���������, �� ��������� ����� 1000', color = 267386880}, 30)
        end

        local timer_exit = function (veh_id, handle)
            if not timer.exist("����") then
                timer("���� ", 7, function()

                    
                    
                    if not veh_id then BlockSync = false return end

                    if not doesVehicleExist(handle) then return end


                    Noti('�����')
                    sampSendExitVehicle(veh_id)
                end)
            end
        end

        local t = decodeJson('[[327.48141479492,1347.5455322266,8.2523002624512],[73.975700378418,1200.9187011719,18.081499099731], [-259.15530395508,1198.1284179688,19.190399169922],[-410.47470092773,1015.6484985352,10.630999565125],[-587.46527099609,1100.5399169922,10.77379989624],[-760.25329589844,996.19598388672,15.920499801636],[-1087.3992919922,1445.0825195313,27.73030090332],[-1019.0875854492,1595.1086425781,34.283699035645],[-1176.4724121094,1796.8071289063,39.949401855469],[-1427.4544677734,1849.626953125,34.118900299072],[-1732.3088378906,1823.759765625,23.416999816895],[-1825.9897460938,2142.3132324219,7.1894001960754],[-2002.5010986328,2420.4921875,33.473201751709],[-1793.3894042969,2695.3647460938,57.784801483154],[-1495.1209716797,2730.0004882813,65.29280090332],[-1195.0491943359,2689.0532226563,45.464401245117],[-578.31518554688,2745.3349609375,61.134201049805],[-533.19702148438,2609.72265625,53.010398864746]]')
        local send_pos = function (veh_id, hp, handle)
            for s = 1, #t do
                if (s == #t)  then -- , quaternion = quat -- ��� ���� ����� ������
                    
                    wait(600)
                    SendSync{pos = {t[s][1], t[s][2], t[s][3]}, manual = "player", surf = 2034} -- �������� � � ���, ���� �� ������� �� �������
                    enter_buss(veh_id, hp)
                    timer_exit(veh_id, handle)
                else

                    
                    SendSync{pos = {t[s][1], t[s][2], t[s][3] - 1}, manual = "vehicle", id = veh_id, vehicleHealth = hp, quaternion = quat}

                    --enter_buss(veh_id, hp) -- my pos save from desaper
                    
                end
            end
        end

       


     

        local veh_id, x, y, z, hp, handle = autobus()

        if not veh_id then error('����� ��� ��������!', 0) return end
        

        
        local how_many = 0

        while true do


            how_many = how_many  +1
            pL(how_many)

            dialog_handler()

            block_messages()

            

            if i == 1 then enter_buss(veh_id, hp) end

            while not �����_������ do wait(0) end

            send_pos(veh_id, hp, handle)
        end
   

        pL('end....')
        wait(300)
        BlockSync = false


        
    end
}


