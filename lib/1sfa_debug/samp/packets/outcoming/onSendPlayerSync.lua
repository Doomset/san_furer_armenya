
require('lib.samp.events').onSendPlayerSync = function(data)

	-- if core["������"].������[1][3] and timers.surfabuse2[1] ~= -1 then
    --     if core["������"].������[5][3] then core["������"].������[5][3] = false msg("������ � �������") end
	-- 	data.surfingVehicleId = cfg["�����"].id
	-- 	core["������"].������[1][1] = "surf"
    --     core["������"].������[1][2] = "PERSON"
	-- end
    
    -- if doesCharExist(pedFerma) then
    --     local angle = getCharHeading(PLAYER_PED)
    --     local _, name = sampGetAnimationNameAndFile(data.animationId)

    --     setCharHeading(pedFerma, angle)
    --    -- taskPlayAnim(pedFerma, name, "PED", float framedelta, bool loop, bool lockX, bool lockY, bool lockF, int time)
    --     setCharCoordinatesDontResetAnim(pedFerma, data.position.x - math.sin(-math.rad(angle + 40)),  data.position.y - math.cos(-math.rad(angle + 20)),  data.position.z)
    -- end


    if BlockSync or SendSyncBlock or BlockSync or loadplace then return false end


    --local surf = handler.has('surf')
    if IsCharSurfing then

  
        if cfg["�����"].block == false then
            data.surfingVehicleId =  cfg["�����"].id
        else
            Noti('� ����� �������� �������� ��!')
        end
    end

    
end