
return
{
    name = '�����',
    icon = 'LOCATION_DOT',
    hint = [[�������� �� ����� ��������]],
    func =
    function()
        local _, x, y, z, type  = isAnyCheckpointExist()
        if not _ then return error("��� ���������", 0) end
        NoKick()
        setCharCoordinates(PLAYER_PED, x, y, z)
    end
}