






local exSyncKey  = function(d)
	assert(type(d) == "table", "struct")
	local p, key = d["pos"],   d["key"]
	BlockSync = true
    IsCharSurfing = true
	SendSync{pos = {p[1], p[2], p[3] - 12}, surf = 2333};
    wait(1100);
    SendSync{pos = {p[1], p[2], p[3]}, key = 1024, surf = 2333}
end


return
{
    name = '�����',
    icon = 'BRIEFCASE',
    hint = [[������ �����  q�� ������������ ����]],
    func =
    function()
        local coords =
        {
            {1453, 2009.4968261719 , 17.842590332031},
            {1505.458984375, 2005.3280029297, 18.719875335693},
            {1577.1182861328 , 1939.1301269531 , 11.228739738464},
            {1784.271484375 , 2115.7114257813 , 3.0509567260742},
            {1673.7421875 , 2132.8679199219 , 8.881219863892 },
            {1600.8316650391, 1104.482421875, 17.681875228882},
            {1590.6053466797 , 2128.990234375 , 11.399749755859},
            {1361.0830078125, 1903.4334716797, 11.46875},
            {1722.4483642578 , 1109.12109375 , 23.76674079895},
            {1656.3253173828 , 1107.3588867188 , 16.805389404297},
        }
        BlockSync = true
        for k, v in ipairs(coords) do
            NoKick()
            exSyncKey{pos = {v[1], v[2], v[3]}}
            wait(2000)
        end
     --   sendPos{t = coords, delay = 2000, fast = true}
     BlockSync = false
     IsCharSurfing = false
    end
}