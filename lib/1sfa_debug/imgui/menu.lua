

local imgui = require("mimgui")




local res_x, res_y = getScreenResolution()

local tabs = {

	animate = {state = false, duration = 0.2},

	animate_child = {state = false, duration = 0.15},

	current = 1,

	active = {name = false, handle = false},

	size_window_child = imgui.ImVec2(550, 290),
    window_pos = imgui.ImVec2(res_x/2, res_y/2),
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
    [1] = require('sfa.imgui.i_select.������'),
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
    [2] = require('sfa.imgui.i_select.��������'),
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=
	[3] = require('sfa.imgui.i_select.���������'),
}

local extra = require('sfa.imgui.extra')

for i = 1, 3 do setmetatable(tabs[i], {__index = tabs}) end -- �������� �����
menu = tabs.animate
setmetatable(menu , extra.ui_meta)
setmetatable(tabs.animate_child, extra.ui_meta)
    

sampRegisterChatCommand('sfa', function(arg)
    menu.switch()
end)


local select_key = 1
addEventHandler("onWindowMessage", function(message, wparam)
    if menu.alpha > 0.00 and not BLOCK_BIND then
        if (message == 0x100 or message == 0x101) then
            if wparam == 0x1B then
                consumeWindowMessage(true, false)
                menu.switch()
            end
        end
    end
end)


addEventHandler('onScriptTerminate', function (s)
    if s == script.this then
        cfg.last.menu = menu.alpha > 0.00
        cfg()
    end
end)


local mem = require('memory')
local function sampGetCurrentDialogSize()
    local sampBase = getModuleHandle("samp.dll")
    if sampBase ~= nil then
        local CDialog = mem.getuint32(sampBase + 0x21A0B8)
        local CDXUTDialog = mem.getuint32(CDialog + 0x1C)
        local width = mem.read(CDXUTDialog + 0x11E, 4, true)
        local height = mem.read(CDXUTDialog + 0x122, 4, true)
        return width, height
    end
end


local function sampSetCurrentDialogSize(w, h)
    local sampBase = getModuleHandle("samp.dll")
    if sampBase ~= nil then
        local CDialog = mem.getuint32(sampBase + 0x21A0B8)
        local CDXUTDialog = mem.getuint32(CDialog + 0x1C)
        mem.write(CDXUTDialog + 0x11E, w, 4, true)
        mem.write(CDXUTDialog + 0x122, h, 4, true)
    end
end




local function setCurrentDialogPosition(x, y)
    local CDialog = mem.getuint32(getModuleHandle("samp.dll") + 0x21A0B8)
	local CDXUTDialog = mem.getuint32(CDialog + 0x1C)
    mem.write(CDialog + 0x04, x, 4, true)
    mem.write(CDialog + 0x08, y, 4, true)
    mem.write(CDXUTDialog + 0x116, x, 4, true)
    mem.write(CDXUTDialog + 0x11A, y, 4, true)
end

if not cfg.last.on then
    cfg.last.on = false
    cfg()
end

if isSampAvailable() then
    if cfg.last.on and cfg.last.menu then
        tabs.current = cfg.last.current
        tabs.animate_child.switch(1)
        menu.switch()
    else 
        tabs.current = 2; tabs.animate_child.switch(1) end
else tabs.current = 2; tabs.animate_child.switch(1) end


local icon = require('sfa.imgui.icon')

local input = extra.input()
setmetatable(tabs,
    {
        __call = function(self, text, fa, sel, size)
            imgui.PushStyleColor(imgui.Col.ChildBg, imgui.GetStyle().Colors[imgui.Col.MenuBarBg])
            imgui.SetCursorPos({ 30, 55 })

            local select_child =  { 550, 26 }
            imgui.BeginChild("selectedTab##1", { 550, 26 }, 1,
                imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)

            local buttons = function(text, fa, sel, size)
                local col = imgui.GetStyle().Colors[imgui.Col.Button]

                imgui.PushFont(font[19])
                local s, p = imgui.CalcTextSize(text), imgui.GetCursorPos()
                local pos = imgui.GetCursorScreenPos()
                local res = imgui.InvisibleButton(text, { s.x + 30, s.y })
                imgui.PushStyleColor(imgui.Col.Text,
                    (sel or imgui.IsItemHovered()) and imgui.ImVec4(col.x, col.y, col.z, col.w) or extra.con(123, 123, 111))
                imgui.PushStyleColor(imgui.Col.Button, { 0, 0, 0, 0 })
                imgui.PushStyleVarFloat(imgui.StyleVar.FrameBorderSize, 0)
                imgui.SetCursorPos(p)
                icon.Button(text, false, fa, true)
                imgui.PopFont()
                imgui.PopStyleColor(2)
                imgui.PopStyleVar() 
                local col = imgui.ImVec4(col.x, col.y, col.z, self.animate_child.alpha)
 
                if sel then imgui.GetWindowDrawList():AddLine({ pos.x, pos.y - 5 },
                        { pos.x + imgui.GetItemRectSize().x * self.animate_child.alpha, pos.y - 5 },
                        imgui.GetColorU32Vec4(col), 3) end
                return res
            end

    
            for i = 1, 3 do
                local text_size = imgui.CalcTextSize(u8(self[i][2]))
                local pos = {
                    ((select_child[1] / 4.5) - (text_size.x / 2)) - 30,
                    ((select_child[1] / 2.1) - (text_size.x / 2)) - 30,
                    ((select_child[1] / 1.31) - (text_size.x / 2)) - 32
                }
                imgui.SameLine(pos[i])

                
              
                if buttons(u8(self[i][2]), self[i][1], self.current == i, 1) then
                    input:null()

                    if self.current ~= i and not timer.exist("�����") then
                        self.animate_child.switch(1)

                        ������������_�������2 = os.clock()

                        timer("�����", self.animate_child.duration, function()
                            
                            ������������_�������2 = false
                            ������������_�������  = os.clock()

                            self.current                             = i
                         
                           
                            self.animate_child.switch(1)
                        end)
                        cfg.last.current = i
                        cfg()
                    end
                end

                if imgui.IsItemClicked(1) then
                    local form = string.format(getWorkingDirectory()..'\\lib\\1sfa_debug\\imgui\\i_select\\%s.lua', self[i][2])
                   -- if doesDirectoryExist(form) then
                        os.execute('start explorer '..form)
                        print('run '..form)
                        msg('est')
                   -- end
                end

                
            end
            imgui.EndChild()
            imgui.PopStyleColor()
        end
    })
--




tabs.begin = function(self, func, flags)
	local a = menu.alpha
	local res = imgui.GetIO().DisplaySize

	imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, a)

    local win_size = imgui.ImVec2(500 - a * -100,  300 - a * -100)
	imgui.SetNextWindowSize(win_size, 1)


	imgui.SetNextWindowPos(imgui.ImVec2(self.window_pos.x , self.window_pos.y ),  a > 0.99 and 2 or  1, imgui.ImVec2(0.5, 0.5))

    

	imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(1, 1))
	imgui.Begin("##�����", _, flags)
    imgui.PopStyleVar()


    local win_pos =imgui.GetWindowPos()

    
	self.window_pos = a > 0.99 and imgui.ImVec2(win_pos.x + win_size.x / 2, win_pos.y + win_size.y / 2) or self.window_pos


    
	local dialog_size = imgui.ImVec2(sampGetCurrentDialogSize())

	if isSampAvailable() and sampIsDialogActive() then
		setCurrentDialogPosition(win_pos.x - dialog_size.x, win_pos.y)
		--sampSetCurrentDialogSize(self.dialog_size.x / 2, self.dialog_size.y / 2)
	end
	func(self)
	imgui.End()	
	imgui.PopStyleVar()
end




math.clamp = function(value, minVal, maxVal)
    return math.min(math.max(value, minVal), maxVal)
end


local animation = { } do

    animation.type = {
        ANIMATION_TYPE_ONCE = 1,
        ANIMATION_TYPE_DEFAULT = 2,
        ANIMATION_TYPE_STEP = 3
    }

    animation.ease = function( n )
        return 1 - math.pow( 1 - n, 5 );
    end

    animation.new = function( self, duration, animation_type )
        local animation = { }
            animation.duration = duration;
            animation.type = animation_type;
            animation.weight = 0.0;

        return setmetatable( animation, {
            __index = self,
            __call = self.update
        } );
    end

    animation.update = function( self, condition )
        local condition = condition or false;

        --frametime means 1 / fps
        local clock = imgui.GetTime() / self.duration;
        if ( self.animation_type == animation.type.ANIMATION_TYPE_ONCE ) then
            self.weight = self.weight + clock;
            self.weight = math.clamp( self.weight, 0, 1 );
            return;
        end

        self.weight = self.weight + ( condition and clock or -clock );
        if ( self.animation_type == animation.type.ANIMATION_TYPE_STEP ) then
            self.weight = math.clamp( self.weight, 0, 1 ) % 1;
            return;
        end

        self.weight = math.clamp( self.weight, 0, 1 );
    end

    animation.get = function( self )
        return self.weight * self.weight * self.weight;
    end

    animation.value = function( self, from, to )
        return from + ( to - from ) * animation.ease( self:get( ) )
    end

    animation.color = function( self, from, to )
        return color(
            from.r + ( to.r - from.r ) * animation.ease( self:get( ) ),
            from.g + ( to.g - from.g ) * animation.ease( self:get( ) ),
            from.b + ( to.b - from.b ) * animation.ease( self:get( ) ),
            from.a + ( to.a - from.a ) * animation.ease( self:get( ) )
        );
    end

    animation.vector = function( self, from, to )
        return vector(
            from.x + ( to.x - from.x ) * animation.ease( self:get( ) ),
            from.y + ( to.y - from.y ) * animation.ease( self:get( ) ),
            from.z + ( to.z - from.z ) * animation.ease( self:get( ) )
        )
    end

    setmetatable( animation, {
        __call = animation.new
    } );
    
end


local a = animation( 1, animation.type.ANIMATION_TYPE_DEFAULT )



������������_������� = os.clock()

tabs.beginChild = function(self, func)

    imgui.SetCursorPosX(self.animate_child.offset)                                                -- OFFSET ANIM
    imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, imgui.GetStyle().Alpha * self.animate_child.alpha) -- ALPHA
    imgui.BeginChild('Selected_CHILD', imgui.ImVec2(self.size_window_child.x, self.size_window_child.y), false,
        imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground)
    func(self)
    imgui.EndChild()
    imgui.PopStyleVar()
end




local select = 'sfa'
local gui_sfa = function (self)
    self()        --- TABBSSSSSSS
    imgui.SetCursorPosY(88) -- ������� ������ � ��������� \/
    self:beginChild(function(d)


        
        a:update( sampIsDialogActive()  )

        print( a:get() )




        self[self.current]:menu()
    end)
end

local addons = {['sfa'] = {gui = function (self) gui_sfa(self) end}}



for addon, state in pairs(cfg.addons) do
   if state then
      local res, data = pcall(require, 'sfa.addons.'..addon)
      if res then
        addons[addon] = {gui = data.gui}
      else print(data, ERROR) end
    end
end



tabs._sfa = function()

    local hotline = function (text)
        imgui.PushFont(font[20])
       -- imgui.SetCursorPos { 33, 28 }
        local p = imgui.GetCursorPos()
        extra.color_text(imgui.ImVec4(173 / 255.0, 35 / 255.0, 179 / 255.0, 1), text)
        imgui.SetCursorPos({ p.x - 3.1, p.y - 1.2 })
        extra.color_text(imgui.ImVec4(166 / 255.0, 223 / 255.0, 252 / 255.0, 1), text)
        if imgui.IsItemHovered() then
            imgui.PushFont(font[21])
            imgui.SetCursorPos({ p.x - 3.1, p.y - 1.2 })
            extra.color_text(imgui.ImVec4(166 / 255.0, 223 / 255.0, 252 / 255.0, 1), text)
            imgui.PopFont()
        end
        imgui.PopFont()
    end

    --hotline('sfa')

    

    if  cfg.debug then
        if isKeyDown(18) and imgui.IsItemClicked(1) then
            local line = debug.getinfo(1).currentline
            msg(line)
            os.execute(string.format('code --g "%s\\lib\\1sfa_debug\\imgui\\menu.lua:201"', getWorkingDirectory()) )
        -- end
        elseif isKeyDown(18) and imgui.IsItemClicked(0) then
            local line = debug.getinfo(1).currentline
            msg(line)
            os.execute(string.format('code --g "%s\\zsfa2.lua:1"', getWorkingDirectory()) )
        end 
    end
    

   
    imgui.PushStyleColor(imgui.Col.Button, {0, 0, 0, 0})
    imgui.PushStyleVarFloat(12, 0)
    local get_addons =function ()
        for addon, _ in pairs(addons) do
            if select == addon then hotline(select:upper()) end
            if select ~= addon and imgui.Button(addon) then select = addon end;
            if cfg.debug and imgui.IsItemClicked(1) then
                os.execute(string.format('code --g "%s\\lib\\1sfa_debug\\addons\\%s.lua:1"', getWorkingDirectory(), addon) )
            end
           imgui.SameLine()
        end
    end

    imgui.SetCursorPos { 33, 28 }

    get_addons()
    if imgui.Button('+') then imgui.OpenPopup('addosn') end
    imgui.PopStyleColor()
    imgui.PopStyleVar()
   

    extra.Separator(-5, 25)

    

    local addons_manager = function ()
        if imgui.BeginPopupModal('addosn') then       
            for addon, state in pairs(cfg.addons) do
                local state = imgui.new.bool(state)
                if imgui.Checkbox(addon, state) then
                    cfg.addons[addon] = state[0]
                    cfg()
                    if not state[0] then
                        package.preload['sfa.addons.'..addon] = nil
                        addons[addon] = nil
                        select = 'sfa'
                    else
                        local res, data = pcall(require, 'sfa.addons.'..addon)
                        if res then
                            addons[addon] = {gui = data.gui}
                        end
                    end
                end
            end
            imgui.EndPopup()
        end
    end
    addons_manager()


end


local url = 'https://api.github.com/repos/doomset/san_furer_armenya/commits'
local changelog
local t1
if cfg.is_upd_to_date then
    asyncHttpRequest('GET', url, nil, function (res)
        local t1 = decodeJson(res.text)
        changelog = {
            -- files = decodeJson(res.text).tree,
            date = t1[1].commit.author.date,
            message = t1[1].commit.message,
        }
    end, function(err)  end)

    -- lua_thread.create(function ()
    --     while t1 == nil do wait(0) end

    --     asyncHttpRequest('GET', t1[1].commit.tree.url, nil, function(res)
    --         changelog = {
    --             files = decodeJson(res.text).tree,
    --             date = t1[1].commit.author.date,
    --             message = t1[1].commit.message,
    --         }
    --     end, function(err)  end)
        
    -- end)
end


local mainFrame = imgui.OnFrame(function() return menu.alpha > 0.00 end,
function(player)
    player.LockPlayer = input.active

    local dl = imgui.GetForegroundDrawList()

    dl:AddText({1,1}, -1, 'edadadsasd')

    tabs:begin(function(self)
        if ������������_������� then self.animate_child.offset = extra.bringFloatTo(-200, 30,
                ������������_�������, 0.1) end
        if ������������_�������2 then self.animate_child.offset = extra.bringFloatTo(30,
                imgui.GetWindowSize().x, ������������_�������2, 0.15) end
        self._sfa()   -- sfaAAAAAAAAA


        
        if cfg.is_upd_to_date then
            imgui.SetCursorPosY(88) -- ������� ������ � ��������� \/
            self:beginChild(function(d)
                local window_size = imgui.GetWindowSize()
                if changelog == nil then
                    local text = u8'������� ���������� � ��������� ����������...'
                    local calc_text = imgui.CalcTextSize(text)
                    imgui.SetCursorPos{window_size.x / 2 - calc_text.x / 2}
                    imgui.Text(text)
                    imgui.SetCursorPos{window_size.x / 2 - 30, 30}
            
                    CircularProgressBar(60, 25, 5)
                else
                    imgui.Text(changelog.date)
                    imgui.Text(changelog.message)
    
                    -- for index, value in ipairs(changelog.files) do
                    --     imgui.Text(value.path)
                    -- end
                end
                if imgui.Button('Poxyi + poebat') then
                    cfg.is_upd_to_date = false
                    cfg()
                end
            end)
        else
            addons[select].gui(self)
        end
       


        if cfg.debug then imgui.Text('debug') end
--        extra.Hint('ddd')
    end, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoCollapse)



end)

imgui._BeginChild = imgui.BeginChild	
imgui.BeginChild = function(...)
	local args = {...}
	if args[2] then 
		args[2] = imgui.ImVec2( args[2].x and menu.alpha * args[2].x or menu.alpha * args[2][1] , args[2].y and menu.alpha * args[2].y or menu.alpha * args[2][2])
	end	
	return imgui._BeginChild(table.unpack(args))
end
