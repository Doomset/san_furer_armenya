
return
{
    name = '����� �������',
    icon = 'MAGNIFYING_GLASS',
    hint = [[����������� ����� ������]],
    func =
    function()
        local _, oX, oY, oZ = getObjectCoordinatesByModelID(1550)
        if not _  or oX == 0 then return error('��� �������') end
        placeWaypoint(oX, oY, oZ)
        Noti("����� �����������")
    end
}