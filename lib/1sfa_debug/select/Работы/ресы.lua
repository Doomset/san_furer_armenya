
return
{
    name = '����',
    icon = 'TRUCK_PICKUP',
    hint = [[d]],
    func =
    function()
        for i = 1, 100 do
            handler('onServerMessage', {text = '�� ������� ��� ���� �� ����������!', color = 267386880})
            handler('onServerMessage', {text = '����������� ��������� �� ������� �������!', color = 267386880})
            handler('dialog', {t = '����� ��������'})

            local t = decodeJson('[[339.78118896484,1986.2492675781,17.878799438477],[-765.43530273438,1557.2924804688,27.026699066162]]')

                   
            local enter_buss = function(id) SendSync{pos = mimic_pos, manual = "vehicle", id = id} end --��������� ������ ������� � ���, ��� ��� �������� ��� ��������� �������


            local autobus = function(model) -- ����� �������� � ���� ������ � ���������� ������� � ����
                for i = 0, 2000 do
                    local bool, veh = sampGetCarHandleBySampVehicleId(i)
                    if bool and doesVehicleExist(veh) and isCarModel(veh, model) then
                        local x, y, z = getCarCoordinates(veh)
                        sampSendExitVehicle(i)
                        enter_buss(i)

                        return i, x, y, z
                    end
                end
                return false
            end
            local id, x, y, z = autobus(448)
            SendSync{ pos = {339.78118896484,1986.2492675781,17.878799438477}, manual = "vehicle", id = id}
            SendSync{ pos = {-765.43530273438,1557.2924804688,27.026699066162}, manual = "vehicle", id = id}
            SendSync{pos = {-759, 1557, 27}, key = 1024}
            wait(30)
        end
    end
}