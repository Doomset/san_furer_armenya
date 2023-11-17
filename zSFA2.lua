---@diagnostic disable: lowercase-global
script_properties("work-in-pause")
script_name('sfa')
local trace_log, print, _require = {}, print, require

require("moonloader")
require('sampfuncs')
local encoding =  require'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8



do local a=getmetatable("String")function a.__index:insert(b,pos)if pos==nil then return self..b end;return self:sub(1,pos)..b..self:sub(pos+1)end;function a.__index:extract(c)self=self:gsub(c,"")return self end;function a.__index:array()local d={}for e in self:gmatch(".")do d[#d+1]=e end;return d end;function a.__index:isEmpty()return self:find("%S")==nil end;function a.__index:isDigit()return self:find("%D")==nil end;function a.__index:isAlpha()return self:find("[%d%p]")==nil end;function a.__index:split(f,g)assert(not f:isEmpty(),"Empty separator")result,pos={},1;repeat local e,h=self:find(f or" ",pos,g)result[#result+1]=self:sub(pos,e and e-1)pos=h and h+1 until pos==nil;return result end;local i=string.lower;function a.__index:lower()for j=192,223 do self=self:gsub(string.char(j),string.char(j+32))end;self=self:gsub(string.char(168),string.char(184))return i(self)end;local k=string.upper;function a.__index:upper()for j=224,255 do self=self:gsub(string.char(j),string.char(j-32))end;self=self:gsub(string.char(184),string.char(168))return k(self)end;function a.__index:isSpace()return self:find("^[%s%c]+$")~=nil end;function a.__index:isUpper()return self:upper()==self end;function a.__index:isLower()return self:lower()==self end;function a.__index:isSimilar(l)return self==l end;function a.__index:isTitle()local m=self:find("[A-zА-яЁё]")local n=self:sub(m,m)return n:isSimilar(n:upper())end;function a.__index:startsWith(l)return self:sub(1,#l):isSimilar(l)end;function a.__index:endsWith(l)return self:sub(#self-#l+1,#self):isSimilar(l)end;function a.__index:capitalize()local o=self:sub(1,1):upper()self=self:gsub("^.",o)return self end;function a.__index:tabsToSpace(p)local q=(" "):rep(p or 4)self=self:gsub("\t",q)return self end;function a.__index:spaceToTabs(p)local q=(" "):rep(p or 4)self=self:gsub(q,"t")return self end;function a.__index:center(r,s)local t=r-#self;local e=string.rep(s or" ",t)return e:insert(self,math.ceil(t/2))end;function a.__index:count(u,v,w)assert(not u:isEmpty(),"Empty search")local x=self:sub(v or 1,w or#self)local p,pos=0,v or 1;repeat local e,h=x:find(u,pos,true)p=e and p+1 or p;pos=h and h+1 until pos==nil;return p end;function a.__index:trimEnd()self=self:gsub("%s*$","")return self end;function a.__index:trimStart()self=self:gsub("^%s*","")return self end;function a.__index:trim()self=self:match("^%s*(.-)%s*$")return self end;function a.__index:swapCase()local result={}for e in self:gmatch(".")do if e:isAlpha()then e=e:isLower()and e:upper()or e:lower()end;result[#result+1]=e end;return table.concat(result)end;function a.__index:splitEqually(r)assert(r>0,"Width less than zero")assert(r<=self:len(),"Width is greater than the string length")local result,j={},1;repeat if#result==0 or#result[#result]>=r then result[#result+1]=""end;result[#result]=result[#result]..self:sub(j,j)j=j+1 until j>#self;return result end;function a.__index:rFind(c,pos,g)local j=pos or#self;repeat local result={self:find(c,j,g)}if next(result)~=nil then return table.unpack(result)end;j=j-1 until j<=0;return nil end;function a.__index:wrap(r)assert(r>0,"Width less than zero")assert(r<self:len(),"Width is greater than the string length")local pos=1;self=self:gsub("(%s+)()(%S+)()",function(y,z,A,B)if B-pos>(r or 72)then pos=z;return"\n"..A end end)return self end;function a.__index:levDist(l)if#self==0 then return#l elseif#l==0 then return#self elseif self==l then return 0 end;local C=0;local D={}for j=0,#self do D[j]={}D[j][0]=j end;for j=0,#l do D[0][j]=j end;for j=1,#self,1 do for E=1,#l,1 do C=self:byte(j)==l:byte(E)and 0 or 1;D[j][E]=math.min(D[j-1][E]+1,D[j][E-1]+1,D[j-1][E-1]+C)end end;return D[#self][#l]end;function a.__index:getSimilarity(l)local F=self:levDist(l)return 1-F/math.max(#self,#l)end;function a.__index:empty()return""end;function a.__index:toCamel()local G=self:array()for j,n in ipairs(G)do G[j]=j%2==0 and n:lower()or n:upper()end;return table.concat(G)end;function a.__index:shuffle(H)math.randomseed(H or os.clock())local G,I=self:array(),{}for j=1,#G do I[j]=G[math.random(#G)]end;return table.concat(I)end end



local effil = require 'effil' -- В начало скрипта
function asyncHttpRequest(method, url, args, resolve, reject)
	local request_thread = effil.thread(function (method, url, args)
	   local requests = require 'requests'
	   local result, response = pcall(requests.request, method, url, args)
	   if result then
		  response.json, response.xml = nil, nil
		  return true, response
	   else
		  return false, response
	   end
	end)(method, url, args)
	-- Если запрос без функций обработки ответа и ошибок.
	if not resolve then resolve = function() end end
	if not reject then reject = function() end end
	-- Проверка выполнения потока
	lua_thread.create(function()
	   local runner = request_thread
	   while true do
		  local status, err = runner:status()
		  if not err then
			 if status == 'completed' then
				local result, response = runner:get()
				if result then
				   resolve(response)
				else
				   reject(response)
				end
				return
			 elseif status == 'canceled' then
				return reject(status)
			 end
		  else
			 return reject(err)
		  end
		  wait(0)
	   end
	end)
end



local function url_encode(text)
	if not text:find('[\128-\255]') then return text end
    text = string.gsub(text, "[\128-\255]", function(c) return string.format("%%%02X", string.byte(c)) end)
    return u8(text)
end



local read_file = function (file)
	local f, msg = io.open(file, 'r')
	if not f then return false end
	local file = u8:decode(f:read('*a'))
	f:close()
	local table = decodeJson(file)
	return table
end



local write_file = function (path, content)
	local loaded_file = io.open(path, 'w')
	assert(loaded_file, 'не удалось записать файл')
	loaded_file:write(content)
	loaded_file:close()
end



local directory = function (dir)
	dir = dir:gsub('/', '\\')
	if doesDirectoryExist(dir) then return false end
	local res = createDirectory(dir)
--	print('Папки не существует - создание '..dir, res and OK or ERROR)
	return true
end



local check_hash = function(name, hash, git)-- сравнение кеша из старых файлах в новых
	for _, v in ipairs(git) do
		if v.path == name and v.sha ~= hash and v.type ~= 'tree' then print('Обнаружено обновление в файле ! '..name) return true end
	end
	return false
end


local verify_directory = function (git_data)
	directory(getWorkingDirectory()..'\\sfa')
	for _, v in ipairs(git_data.tree) do
		local path = v.path:gsub('lib/1sfa_debug', '\\sfa')
		if v.type == 'tree' and directory(getWorkingDirectory()..path) then print('[update] папки не существует, создание', path) end
	end
end

local verify_files = function (new_data, old_data)
	local files = {}
	for _, v in ipairs(new_data.tree) do
		if v.type ~= 'tree' then
			local path = v.path:gsub('lib/1sfa_debug', '\\sfa')
			if not doesFileExist(getWorkingDirectory()..path) then
				table.insert(files,  {path = v.path, size = v.size, update = false})
			elseif old_data and check_hash(v.path, v.sha, old_data.tree) then
				table.insert(files,  {path = v.path, size = v.size, update = false})
			end
		end
	end
	return files
end


local process = false
local verfy = function (new_data, old_data)
	
	verify_directory(new_data)
	local files_for_download = verify_files(new_data, old_data)
	if #files_for_download > 0 then
		Noti('Будет скачано файлов: '..#files_for_download, OK)

		local downloader = function (files_for_download)
			for _i, v in ipairs(files_for_download) do
				local url = 'https://raw.githubusercontent.com/doomset/san_furer_armenya/main/'..url_encode(u8(v.path))
				local moonDir = getWorkingDirectory()
		
				local path = moonDir..(v.path:gsub('lib/1sfa_debug', '/sfa')) --v.path:find('3z3sfa2') and moonDir..'\\zsfa2.lua' or 
				print(path)
				asyncHttpRequest('GET', url, nil, function(resolve) -- нужно вызывать снаружи/crash????
					write_file(path, resolve.text)
--					progress_download.text = (v.update and 'обновлен ' or 'скачан ')..v.path
					table.remove(files_for_download)
	--						progress_download.current = progress_download.current + 1
					if #files_for_download == 0 then
					--	progress_download.text = 'ВСЕ ФАЙЛЫ СКАЧАНЫ УСПЕШНО'
					    process = false
						Noti('ВСЕ ФАЙЛЫ СКАЧАНЫ УСПЕШНО, ТРЕБУЕТСЯ ПЕРЕЗАГРУЗКА'..#files_for_download)
						thisScript():reload()
					end
				end, function(err)
					process = false
					Noti('Ошибка в закачке/обновления модуля '..v.path, ERROR)
				end)
			end
		end

		
		downloader(files_for_download)
	else
		process = false
		Noti('Обновлений не обнаружено!')
	end
end


local git_url, git_path = "https://api.github.com/repos/doomset/san_furer_armenya/git/trees/main?recursive=1", getWorkingDirectory()..'\\sfa\\data.json'
local update = function ()
	if process then Noti('Ахуел спамить?!! Предидущий запрос ещё на обработан', ERROR)return end
	process = true
	

	local hanlder = function(resolve)
		local git_text = u8:decode(resolve.text)
		local new_data = decodeJson(git_text)

		local old_data = read_file(git_path) --прочитать старый
		write_file(git_path, git_text) -- записать новый гит
		if not old_data then
			verfy(new_data)
			return
		end

		if old_data.sha ~= new_data.sha then
			Noti('Обнаружено обновление!')
			verfy(new_data, old_data)
		else
			verfy(new_data)
		end
		
	end

	
	asyncHttpRequest('GET', git_url, nil, hanlder, function(err) process = false Noti('Не удалось проверить обновления, лимит на запрсоы исчерпан или гитхаб сосет хуй') end)
end


sampRegisterChatCommand('sfa_upd', update)
sampRegisterChatCommand('sfa_debug', function () cfg.debug = not cfg.debug; cfg(); end)



getFilesInPath = function(path, ftype)
	local Files = {}
	local SearchHandle, File  = findFirstFile(getWorkingDirectory()..path .. "\\" .. ftype)
	table.insert(Files, File)
	while File do
		File = findNextFile(SearchHandle)
		table.insert(Files, File)
	end
	return Files
end



msg = function(...)
    if not isSampAvailable() then return end
	if type(...) == "table" then text = encodeJson(...) else
		local temp = {...}
		for k, v in ipairs(temp) do
			if type(v) ~= "string" then

				temp[k] =  type(v) == "table" and encodeJson(v) or (msg_debug and type(v) or "")..tostring(v)
			end
		end
		text = table.concat(temp, ", ")
	end
    sampAddChatMessage('{8952ff}[sfa]: {ffffff}'..text, 0xFF8952ff)
end



shortPos = function(x, y, z) -- функция для удобной проверки координат
	local round = function(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end
	return round(x + y + z, 2)
end




require = function(n)
	n = n:gsub('sfa', '1sfa_debug')
	if cfg and cfg.debug then
		
	end
	return _require(n)
end




cfg = require('sfa.Config')(SFA_settings,  "\\sfa\\settings.json")





require('sfa.imgui.onInitialize')

require 'sfa.samp'

require("sfa.timer")





main = function()
	while not isSampAvailable() do wait(10) end

	--update()
	--initializeModels()



	-- -- 
	
	Noti('sfa - успешно загружен!')


	--
	-- timer('update', 1, function ()
	-- 	update()
	-- end)
	wait(-1)
end















-- if cfg.debug then
-- 	local path = script.this.path
-- 	local f = io.open(path, 'r')
-- 	local sfa_content = f:read('*a')
-- 	f:close()

-- 	cfg.build = os.date("%d.%m.%Y(%H:%M:%S)")
-- 	cfg()

-- 	local f = io.open(getWorkingDirectory().. '\\lib\\1sfa\\zsfa2.lua', 'w')
-- 	f:write(sfa_content)
-- 	f:close()
-- end
















function isAnyCheckpointExist()
	local misc = sampGetMiscInfoPtr()
	if misc == 0 then return false end
	local defoult, race = mem.getint32(misc + 0x24) == 1, mem.getint32(misc + 0x49) == 1
	local pPos = defoult and (misc + 0xC) or (misc + 0x2C)
	return (defoult or race), mem.getfloat(pPos), mem.getfloat(pPos + 0x4), mem.getfloat(pPos + 0x8), defoult and 0 or 1
end








sendPos = function(data)
	local t, delay, tp, key, pick = data["t"], data["delay"], data["tp"], data["key"], data["pick"]

	for k, v in ipairs(t) do

		NoKick()

		if tp then setCharCoordinates(PLAYER_PED, v[1], v[2], v[3]) else
			if not fast then
				SendSync{pos ={v[1], v[2], v[3]}, key = key or v.key, pick = pick or v.pick, force = true, surf = 2333}
			else
				exSyncKey{pos ={v[1], v[2], v[3]}, key = key or v.key, force = true, surf = 2333}
			end

			pL(encodeJson(data))
		end

		if (delay ~= nil and k ~= #t) then
			wait(delay)
			pL('wait(delay)')
		end
	end
end



function setCharCoordinatesDontResetAnim(char, x, y, z)
	if doesCharExist(char) then
		local entityPtr = getCharPointer(char)
		if entityPtr ~= 0 then
			local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
			if matrixPtr ~= 0 then
				local posPtr = matrixPtr + 0x30
				writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) --X
				writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) --Y
				writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) --Z
			end
		end
	end
end








exSync = function(d)
	assert(type(d) == "table", "struct")
	local p, pick, key = d["pos"],  d["p"],  d["key"]
	BlockSync = true
	SendSync{pos = {p[1], p[2], p[3] - 12}, key = key, weapon = 40}; Задержка(1); SendSync{pick = pick}
	BlockSync = false
end



exSyncKey  = function(d)
	assert(type(d) == "table", "struct")
	local p, key = d["pos"],   d["key"]
	BlockSync = true
	SendSync{pos = {p[1], p[2], p[3] - 12}, surf = 2333}; Задержка(1.05); SendSync{pos = {p[1], p[2], p[3]}, key = 1024, surf = 2333}
end






-- local imgui = require('mimgui')
-- update.gui = function (self)

-- 	if imgui.Button('Download git') then
-- 		lua_thread.create(function ()
-- 			local res, d = update.download_git()
-- 			Noti(res and 'СКАЧАН ФАЙЛ' or 'НЕ УДАЛОСЬ СКАЧАТЬ', res and OK or ERROR) 
-- 		end)
-- 	end

-- 	if imgui.Button('Redownload files') then
-- 		lua_thread.create(function ()
-- 			local res = update.download_git()
			
-- 			if res then
-- 				Noti('OK'..res[#res].path, OK)

-- 				if update.download(res) then
-- 					progress_download.text = 'end'
-- 				end

-- 			else
-- 				Noti('SOsni ', ERROR)
-- 			end
-- -- =--Noti(res and 'СКАЧАН ФАЙЛ' or 'НЕ УДАЛОСЬ СКАЧАТЬ', res and OK or ERROR) 
-- 		end)


-- 	end

-- 	if imgui.Button('checkupds') then
		
-- 		upd(self)

-- 	end

-- 	imgui.Text(u8(progress_download.text))
-- 	imgui.ProgressBar(progress_download.current / progress_download.start, {100, 20})

-- end







-- -- imgui.OnFrame(function() return 1 end,
-- -- function ()
-- -- 	update:gui()
-- -- end)