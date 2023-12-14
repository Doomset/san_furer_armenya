local init = function (name)

    local init = {
        dialogs = {
            {info = 'ожидание первого диалога', name = 'Мусоровоз',

            handler = function ()
                local id, x, y, z, hp = find_veh_and_send_pos(408)
                return id, hp
            end,
            handler_after = function (id, hp)
            
                local ta =
                {
                    {289.68539428711, 1795.6689453125, 17.640600204468},
                    {-444.64349365234, 2059.9736328125, 61.249801635742},
                    {-383.67669677734, 2709.4670410156, 62.853099822998},
                    {-1495.8022460938, 2524.4045410156, 55.7952003479},
                    {-861.00769042969, 1429.1904296875, 14.099200248718},
                    {793.18927001953, 1725.6300048828, 5.6854000091553},
                    {297.12271118164, 1410.9024658203, 9.7593002319336},
                }


                for k, v in ipairs(ta) do
					SendSync{pos = {v[1], v[2], v[3]}, manual = "vehicle", id = id, vehicleHealth = hp}
				end

            end, wait = true },

        },
        
        message = {
            {info = 'ожидание первого диалога', name = 'Вы получаете .+%$ %+ .+%$ бонус за уровень', pos = {269.54354858398, 120.4239730835, 3004.6171875}, wait = true },
        }
    }

    init_actions(init)


    reg('dialog', function (data)
        if name ~= FuncActiveName then return end
    
        if data.title:find(act.dialogs[curent_index_for_handler].name) then
    
            sampSendDialogResponse(data.id, 1, 0, '')
            -- local is_cd = data.text:match(': Осталось (%d+)')
    
            -- if is_cd then
            --     raise_error = 'В школе кд! Ещё осталось '..is_cd
            --     return false
            -- end
    
        -- last_delay = 3300
            act.dialogs[curent_index_for_handler].wait = false
           
          
            return false
        end
    end)
    
    reg('message', function (data)
        if name ~= FuncActiveName then return end

        if data.text == 'Вы устали, приходите через час!' and data.color == -1439485014 then
            raise_error = 'Вы устали сосите хуй'
        elseif data.text == 'Вы слишком устали!' and data.color == -1439485014 then
            raise_error = 'Сбрось сон <90'
        end


        --handler('onServerMessage', {text = 'Вы получаете 309$ + 100$ бонус за уровень', color = 267386880})

        -- if shortPos(data.pos.x, data.pos.y, data.pos.z) == act.check[1].name then
        --     Noti('Checkpoint')
        --     act.check[1].wait = false
        -- end
    end)
end


local body = {
    name = 'Мусоровоз',
    icon = 'TRUCK',
    hint = [[мусорвоз нефтезавод]],
    func =
    function()
      

        init('Мусоровоз')


        local parse = function (t)
            for k, v in ipairs(act[t]) do
                curent_index_for_handler = k
                NoKick()
                local id, hp = v.handler()
                if not id then return error('мусоровоз не найден рядом!') end
                if catch(t, k, v.info, v.handler_after(id, hp)) then wait(last_delay) end
            end
        end
        



        parse('dialogs')

       

        wait(300)
        BlockSync = false
        

        



    end
}

return body
