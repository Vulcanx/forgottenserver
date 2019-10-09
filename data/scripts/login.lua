local login = CreatureEvent("xx")

function UserTable()
	return setmetatable({}, {__mode = "v"})
end

local _players = UserTable()

function clean_mem()
	local kb = collectgarbage("count")
	local size = #_players
	for i = 1, #_players do
		_players[i] = nil
	end
	collectgarbage()
	print("before", kb, size)
	print("after", collectgarbage("count"), #_players)
end

local function test_mem_usage(player, n)
	collectgarbage()
	local kb = collectgarbage("count")
	for i = 1, n do
		_players[i] = player
	end
	print('estimated usage:', collectgarbage("count") - kb, 'size', #_players)
end

function login.onLogin(player)
	test_mem_usage(player, 1000000)
	clean_mem()
	return true
end

login:type("login")
login:register()