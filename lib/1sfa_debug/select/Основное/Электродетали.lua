
return
{
    name = '�������������',
    icon = 'ATOM',
    hint = [[��������� � ������ �����,������������� � ������ ������ � ��]],
    func =
    function()
        local coords = {
            {1358.5704345703, 1900.6823730469, 11.5390625},
            {1355.41015625, 1894.666015625, 11.536981582642},
            {1323.8121337891, 1969.7971191406, 11.46875},
            {1358.2279052734, 2007.7717285156, 11.531060218811},
            {1358.0885009766, 1993.8244628906, 11.531060218811},
            {1354.0682373047, 1996.7060546875, 11.531060218811},
            {1419.3015136719, 1920.7601318359, 11.546489715576},
            {1417.8875732422, 1929.9466552734, 11.5390625},
            {1454.9222412109, 1911.2171630859, 11.531058311462},
            {1453.9816894531, 1922.4688720703, 11.531057357788},
            {1462.9598388672, 1923.4921875, 11.538486480713},
            {1560.7392578125, 2095.748046875, 11.531060218811},
            {1548.9127197266, 2106.0183105469, 11.531060218811},
            {1589.4704589844, 2127.4213867188, 11.531060218811},
            {1584.45703125, 2123.6137695313, 11.531060218811},
            {1589.361328125, 2042.3701171875, 11.5390625},
            {1586.6451416016, 2036.8184814453, 11.537030220032},
            {1643.5001220703, 2147.7751464844, 11.382062911987},
            {1645.9027099609, 2159.7102050781, 11.382062911987},
            {1651.3559570313, 2158.0024414063, 11.382062911987},
            {1682.2220458984, 2125.5297851563, 11.531060218811},
            {1679.7093505859, 2113.8601074219, 11.531060218811},
            {1674.3305664063, 2115.50390625, 11.531060218811},
        }
        handler("onServerMessage", {text = "�����!"})
        handler("dialog", {t = "���������", s = 2})
        for k, v in ipairs(coords) do
            if k%5 ~= 0 then NoKick() end
            exSyncKey{ pos = {v[1], v[2], v[3]}, key = 1024}
        --	SendSync{key = 0}
        end
        SendSync{pos = {1858.7330322266, -2255.9135742188, 1505.9825439453}, key = 1024}
    end
}