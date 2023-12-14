local body = {
    name = 'Мусоровоз',
    icon = 'TRUCK',
    hint = [[мусорвоз нефтезавод]],
    func =
    function()
      
        sampForceOnfootSync()

        handler('dialog', {t = 'Кража ресурсов', s = 10, i = 'Продать ресурсы'})

        handler('dialog', {t = 'Кража ресурсов', s = 10, i = 'Продать ресурсы'})

        local t = decodeJson('[[-222.17869567871,2681.7131347656,62.643100738525],[-2457.5119628906,2291.1770019531,4.9843997955322]]')

        for k, v in ipairs(t) do
            SendSync{pos = {v[1], v[2], v[3]}}
        end
    


    end
}

return body
