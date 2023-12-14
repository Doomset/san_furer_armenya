


function isAnyCheckpointExist()
    local mem = require('memory')
	local misc = sampGetMiscInfoPtr()
	if misc == 0 then return false end
	local defoult, race = mem.getint32(misc + 0x24) == 1, mem.getint32(misc + 0x49) == 1
	local pPos = defoult and (misc + 0xC) or (misc + 0x2C)
	return (defoult or race), mem.getfloat(pPos), mem.getfloat(pPos + 0x4), mem.getfloat(pPos + 0x8), defoult and 0 or 1
end


return
{
    name = '��������',
    icon = 'LOCATION_DOT',
    hint = [[���� ���� ����� �� ���������� ����� ������� ������ � ����(��������� �� ������ �� �����, � ������ ���)]],
    func =
    function()
        local _, x, y, z, type  = isAnyCheckpointExist()
        if not _ then return error("��� ���������",0) end
        NoKick()
        SendSync{ pos = {x, y, z}, force = true}
    end
}