pickup{index = 2048.5, pos = {-756, 2758, 46}, name = '����� (�����)', id = 681}

return
{
    name = '�����',
    icon = 'MAGNIFYING_GLASS',
    hint = [[�����-�� �����]],
    func =
    function()
        NoKick()
        SendSync{ pos = {-756, 2758, 46}, pick = cfg['������']['2048.5'].id, force = true}
    end
}