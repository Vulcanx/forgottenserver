do
	local constants = {["true"] = true, ["false"] = false, ["nil"] = nil}

	local function autoType(val)
		if tonumber(val) then
			return tonumber(val)
		elseif constants[val] then
			return constants[val]
		end
		return val
	end

	function table.serialize(t)
		local ss = StringStream()
		ss:append("{")
		local function serialize(t, tab)
			tab = tab or 1
			local indent = ("    "):rep(tab)
			for k, v in pairs(t) do
				v = autoType(v)
				local key = type(k) == "string" and '"%s"' or "%s"
				local value = type(v) == "string" and '"%s"' or "%s"
				if type(v) == "table" then
					ss:append("%s[".. key .."] = {", indent, k)
					serialize(v, tab + 1)
					ss:append("%s},", indent)
				else
					ss:append("%s[".. key .."] = ".. value .. ",", indent, k, v)
				end
			end
		end
		serialize(t)
		ss:append('}')
		return ss:build('\n')
	end
end

do
	local patterns = {
		"id",
		"fromid",
		"toid",
		"name",
		"article",
	}

	function dumpItemsXML()
		local dump = {}
		local node = {}
		for line in io.lines("data/items/items.xml") do
			if line:match("<item") then
				for _, pattern in ipairs(patterns) do
					local value = line:match("%s".. pattern .. '="([^"]+)"')
					if value then
						node[pattern] = value
					end
				end
				if line:match("/>") then
					dump[#dump+1] = node
					node = {}
				end
			elseif line:match('<attribute') then
				local key, value = line:match('key="([^"]+)"%s*value="([^"]+)"')
				if not node.attributes then
					node.attributes = {}
				end
				node.attributes[#node.attributes+1] = {key = key, value = value}
			end

			if line:match("</item>") then
				dump[#dump+1] = node
				node = {}
			end
		end
		return dump
	end
end

function dumpToFile()
	local file = io.open('items.lua', 'w+')

	file:write(table.serialize(dumpItemsXML()))

	file:close()
end