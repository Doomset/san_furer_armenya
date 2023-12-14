
local t = {
    {info = "Обход кика", action = "NoKick() -- писька"},
    {info = "Получить список отсутствующих веещй", action = "Взять_Квест(1)"},
    {info = "Выдать автомат", action = "пушка('31')"},
    {info = "Выдать броню", action = "addArmourToChar(PLAYER_PED, 100)"},
    {info = "", action = "handler('dialog', {t = 'Связной'})"},
    {info = "", action = "Задержка(1)"},
    {info = "", action = "Взять_Квест(1)"},
    {info = "", action = "Задержка(3)"},
    {info = "Обход кика", action = "NoKick()"},
    {info = "", action = "handler('dialog', {t = 'Записка'})"},
    {info = "", action = "Задержка(1)"},
    {info = "Обход кика", action = "NoKick()"},
    {info = "Взять пикап Военкомат (Анклав)", action = "SendSync{ pos = {211.5 , 1922.875 , 17.625}, pick = cfg['Пикапы']['2152.09'].id}"},
    {info = "", action = "SendSync{ pos = {308.68273925781, -131, 1099}}"},
    {info = "", action = "SendSync{ pos = {-145, 437, 12}}"},
    {info = "", action = "Задержка(0)"},
    {info = "Обход кика", action = "NoKick()"},
    {info = "Взять пикап Тайник (Карсон)", action = "local p=cfg['Пикапы']['1012.29'] exSync{ pos = p.pos, p = p.id}"},
    {info = "Взять пикап Тайник (Боун)", action = "local p=cfg['Пикапы']['2567.37']  exSync{ pos = p.pos, p = p.id}"},
    {info = "Обход кика", action = "NoKick()"},
    {info = "Взять пикап Тайник (Брудж)", action = "local p=cfg['Пикапы']['1902.39']  exSync{ pos = p.pos, p = p.id}"},
    {info = "Взять пикап Тайник (Робада)", action = "local p=cfg['Пикапы']['685.78']   exSync{ pos = p.pos, p = p.id}"},
    {info = "", action = "Задержка(1)"},
    {info = "", action = "SendSync{ pos = {278.30606079102, 1360.9072265625, 10.625912666321}}"},
}




local aptechka = function () Антирад_Или_Аптечка(true, 1); end
local antiradin = function () Антирад_Или_Аптечка(false, 1); end
local eda = function () Еда_Или_Водка(true, 1) end
local vodka = function () Еда_Или_Водка(false, 1) end






Надо_Нарыть = function()
	for k, v in pairs(need_list) do
        if k then
            v[2]()
            wait(3300)
        end
    end
end




local init = function (name)

    local  init = {
        dialogs = {
            {info = "Получить список отсутствующих вещей" , name = 'Связной', wait = true, handler = function ()
                Взять_Квест(1)
            end},
    
    
            {info = "закупка хуйни" , name = '888888888', wait = true, handler = function ()
            
            end},
    
    
    
        },
        check = {
            {info = 'Взять метку', name = 1630.3, pos = {-349.14218139648, 1921.7875976563, 59.548782348633}, wait = true },
        }
    }
    init_actions(init)

    local find, need_list = string.find, nil
    reg('dialog', function (data)
    
    
        if name ~= FuncActiveName then return end
    
        if data.title:find(act.dialogs[curent_index_for_handler].name) then
            need_list = {
                аптечка =    {find(data.text, 'Аптечка %(надо нарыть%)'), aptechka},
                антирадин =  {find(data.text, 'Антирадин %(надо нарыть%)'), antiradin},
                еда =        {find(data.text, 'Еда %(надо нарыть%)'), eda},
                водка =      {find(data.text, 'Водка %(надо нарыть%)'), vodka},
            }
    
    
            sampSendDialogResponse(data.id, 0, 1, '')
    
            act.dialogs[curent_index_for_handler].wait = false
            last_delay = 3300
        
            return false
        end
    end)
    
    
    reg('check', function (data)
        if name ~= FuncActiveName then return end
    end)
end


















local body = {
    name = 'связ',
    icon = 'SCHOOL',
    hint = [[Тайник школьника, делается примерно секунд за 15,отправляет раз в 3.3 секунды фейк позицию
    на время выполнения функции можно какать, пукать, играть
    (не забудь о оповещении всем в общий чат после взятие метки)]],
    func =
    function()

        init('связ')

        NoKick()

        addArmourToChar(PLAYER_PED, 100)
        пушка('31')


       
        local parse = function (t)
            for k, v in ipairs(act[t]) do
                curent_index_for_handler = k
                NoKick()
                if v.pos then
                    SendSync{pos = v.pos, key = 1024, force = true}
                else
                    v.handler()
                end
                if catch(t, k, v.info) then wait(last_delay) end
                msg(k)
            end
        end


        parse('dialogs')

        
    --    parse(check)
       
        -- handler("player_pos", {3389.5})
        -- for k, v in ipairs{"Школа", "Компьютер", "Компьютер", "Записка", "Карта"} do
        --     handler("dialog", {t = v}, 55)
        -- end
        -- sendPos{t = coords, delay = 5000, key = 1024}
    end
}










return body
