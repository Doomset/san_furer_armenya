pickup{pos = {-756, 2758, 46}, name = 'Доцан (Арена)', id = 681}
return
{
    name = 'Доцан',
    icon = 'MAGNIFYING_GLASS',
    hint = [[Какая-то хуита]],
    func =
    function()
        NoKick()
        SendSync{ pos = {-756, 2758, 46}, pick = cfg['Пикапы']['2048.5'].id, force = true}
    end
}