
return
{
    name = '����� ����',
    icon = 'MOON',
    hint = [[����������� ����� ������]],
    func =
    function()
        local _, oX, oY, oZ = getObjectCoordinatesByModelID(19299)
        if not _ then return error('��� ����', 0) end
        placeWaypoint(oX, oY, oZ)
        Noti("����� �����������", INFO)
    end
}