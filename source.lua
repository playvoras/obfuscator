-- continued version of https://github.com/GhostDuckyy/RBXLuaObfuscator
--[[
    Version: 1.1.0
    Last Update: 02 / 08 / 2024 | Day / Month / Year
]]--

local base64 = {
	encode = function(data)
		local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
		return ((data:gsub('.', function(x) 
			local r, b='', x:byte()
			for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
			return r;
		end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c=0
			for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
			return b:sub(c+1,c+1)
		end)..({ '', '==', '=' })[#data%3+1])
	end
}

local xor = function(a, b)
	local res = ""
	for i = 1, #a do
		local ca, cb = a:byte(i), b:byte((i - 1) % #b + 1)
		res = res .. string.char(bit32.bxor(ca, cb))
	end
	return res
end

local function customencodetotallyreal(data)
	local encoded = base64.encode(data)
	encoded = xor(encoded, "XOR_KEY")
	return base64.encode(encoded)
end

--// Source
function obfuscate(source, VarName, WaterMark)
	warn("Started obfuscate")
	local Variable = VarName or "Moonsec_V3"

	if source == nil then
		source = [[print("Hello World!")]]
	end

	local ticks = tick()

	local random_ = function(length)
		local letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		local code = ""

		for i = 1, tonumber(length) do
			code = code .. letters:sub(math.random(1, #letters), math.random(1, #letters))
		end
		return code
	end

	local encode_multiple = function(str)
		for i = 1, math.random(2, 5) do
			str = customencodetotallyreal(str)
		end
		return str
	end

	local add_fake_code = function(number, s)
		local highest = 1

		local topic = {
			"Deobfuscate?",
			"Hello World!",
			"IronBrew Fork? Nope.",
			"PSU Fork? Nope.",
			"Touch some grass",
			"New update when?",
			"GhostyDuckyy",
			"Free obfuscator!",
			"E",
			random_(math.random(50, 150)),
		}

		for i, v in pairs(topic) do
			if i > highest then
				highest = i
			end
		end

		for i = 1, tonumber(number) do
			local str = [[local ]] .. Variable .. tostring(random_(math.random(10, 12))) .. [[ = ]] .. '"' .. encode_multiple(tostring(topic[math.random(1, tonumber(highest))])) .. '"' .. "; "
			s = s .. str
		end

		return tostring(s)
	end

	local Random_Variable = {
		TableByte = random_(math.random(20, 30)),
		Table_concat = random_(math.random(20, 30)),
		Loadstring = random_(math.random(20, 30)),
		Base64_var1 = random_(math.random(20, 30)),
		Base64_var2 = random_(math.random(20, 30)),
		RandomCode1 = random_(math.random(20, 30)),
		RandomCode2 = random_(math.random(20, 30)),
		XORKey = random_(math.random(8, 16)),
	}

	local base64_code1 = customencodetotallyreal([[while true do end]])
	local base64_code2 = customencodetotallyreal([[print("yo mama")]])

	local troll_func = [[function() ]] .. add_fake_code(math.random(30, 50), "") .. [[ end]]
	local troll_var = [[local ]] .. Variable .. tostring(random_(math.random(20, 30))) .. [[ = ]] .. troll_func

	local SourceByte = ""
	for i = 1, string.len(source) do
		SourceByte = SourceByte .. '"\\' .. string.byte(source, i) .. '", '
	end
	local TableByte = [[local ]] .. Variable .. tostring(Random_Variable.TableByte) .. [[ = {]] .. SourceByte .. [[}]]
	local Loadstring = [[local ]] .. Variable .. tostring(Random_Variable.Loadstring) .. [[ = loadstring(table.concat({"\114", "\101", "\116", "\117", "\114", "\110", "\32", "\102", "\117", "\110", "\99", "\116", "\105", "\111", "\110", "\40", "\98", "\121", "\116", "\101", "\41", "\10", "\32", "\32", "\32", "\32", "\105", "\102", "\32", "\116", "\121", "\112", "\101", "\111", "\102", "\40", "\98", "\121", "\116", "\101", "\41", "\32", "\61", "\61", "\32", "\34", "\116", "\97", "\98", "\108", "\101", "\34", "\32", "\116", "\104", "\101", "\110", "\10", "\32", "\32", "\32", "\32", "\32", "\32", "\32", "\32", "\108", "\111", "\97", "\100", "\115", "\116", "\114", "\105", "\110", "\103", "\40", "\116", "\97", "\98", "\108", "\101", "\46", "\99", "\111", "\110", "\99", "\97", "\116", "\40", "\98", "\121", "\116", "\101", "\41", "\41", "\40", "\41", "\10", "\32", "\32", "\32", "\32", "\101", "\108", "\115", "\101", "\10", "\32", "\32", "\32", "\32", "\32", "\32", "\32", "\32", "\98", "\121", "\116", "\101", "\32", "\61", "\32", "\123", "\98", "\121", "\116", "\101", "\125", "\10", "\32", "\32", "\32", "\32", "\32", "\32", "\32", "\32", "\108", "\111", "\97", "\100", "\115", "\116", "\114", "\105", "\110", "\103", "\40", "\116", "\97", "\98", "\108", "\46", "\99", "\111", "\110", "\99", "\97", "\116", "\40", "\98", "\121", "\116", "\101", "\41", "\41", "\40", "\41", "\10", "\32", "\32", "\32", "\32", "\101", "\110", "\100", "\10", "\101", "\110", "\100", "\10",}))()]]

	local base64_code = [[local ]] .. Random_Variable.Base64_var1 .. [[ = "]] .. base64_code1 .. [["; local ]] .. Random_Variable.Base64_var2 .. [[ = "]] .. base64_code2 .. [["; ]]
	local random_code_snippets = {
		[[for i = 1, 10 do print(i) end]],
		[[if math.random() > 0.5 then print("Heads") else print("Tails") end]],
		[[local x = 0; while x < 5 do x = x + 1; print(x) end]],
		[[repeat print("Repeating...") until false]],
		[[function foo() return "bar" end; foo()]],
		[[local t = {1, 2, 3}; table.insert(t, 4)]],
		[[local sum = 0; for _, v in ipairs({1, 2, 3, 4}) do sum = sum + v end; print(sum)]],
		[[local a, b = 1, 2; a, b = b, a; print(a, b)]],
		[[local tbl = {a = 1, b = 2}; tbl.c = 3; for k, v in pairs(tbl) do print(k, v) end]],
		[[local function square(x) return x * x end; print(square(5))]],
		[[local str = "Hello World"; print(str:upper())]],
		[[local num = 10; print(num % 3)]],
		[[local tbl = {name = "Lua", version = 5.4}; print(tbl.name .. " " .. tbl.version)]],
		[[local function greet(name) return "Hello, " .. name end; print(greet("Alice"))]],
		[[local x = 1; while x <= 5 do print(x); x = x + 1 end]],
		[[local t = {a = 1, b = 2, c = 3}; for k, v in next, t do print(k, v) end]],
		[[print("not correct code")]],
		[[local = 1]], -- Syntax error
		[[print("unterminated string]], -- Syntax error
		[[local function foo() return 1 + end]], -- Syntax error
		[[if true then else end]], -- Syntax error
		[[local x = function( end]], -- Syntax error
	}

	local random_code_obfuscated = [[local ]] .. Random_Variable.RandomCode1 .. [[ = "]] .. encode_multiple(random_code_snippets[math.random(1, #random_code_snippets)]) .. [["; ]]
	random_code_obfuscated = random_code_obfuscated .. [[local ]] .. Random_Variable.RandomCode2 .. [[ = "]] .. encode_multiple(random_code_snippets[math.random(1, #random_code_snippets)]) .. [["; ]]

	local func = {
		[1] = Variable .. tostring(Random_Variable.Loadstring),
		[2] = Variable .. tostring(Random_Variable.TableByte),
	}

	local fake_code = function(number, r)
		local t = {}
		for i = 1, tonumber(number) do
			local create_Var = Variable .. tostring(random_(math.random(20, 30)))
			local random

			if r ~= nil then
				random = "return " .. tostring(random_(tonumber(r)))
			else
				random = "return " .. tostring(random_(math.clamp(1000, string.len(source) / 2, string.len(source))))
			end

			local byte = ""
			for x = 1, string.len(random) do
				byte = byte .. '"\\' .. string.byte(random, x) .. '", '
			end
			local fake = [[local ]] .. create_Var .. [[ = {]] .. byte .. [[}; ]] .. [[local ]] .. create_Var .. " = " .. func[1] .. "( " .. create_Var .. [[); ]]
			table.insert(t, fake)
		end

		return table.concat(t, " ")
	end

	local obfuscated = troll_var .. "; " 
		.. Loadstring .. "; " 
		.. base64_code .. " " 
		.. random_code_obfuscated 
		.. fake_code(math.random(2, 4), math.random(400, 600)) 
		.. TableByte .. "; " 
		.. [[local ]] .. Variable .. tostring(random_(math.random(20, 30))) .. " = " .. func[1] .. "(" .. func[2] .. ")" .. "; " 
		.. fake_code(math.random(2, 4), math.random(string.len(source) / 2, string.len(source) * 2))

	setclipboard(obfuscated)
	warn("Done obfuscate in " .. tostring(tick() - ticks) .. " second")
	return
end

--// Module
return function(source, CustomVarName, WaterMark)
	task.spawn(function()
		obfuscate(source, CustomVarName, WaterMark)
	end)
end
