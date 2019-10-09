ffi = require("ffi")

ffi.c_str = function(str)
	local c_str = ffi.new("char[?]", str:len() + 1)
	ffi.copy(c_str, str .. '\0')
	return c_str
end

do
	local types = {'int', 'char'}
	function Array(arr_type, size, fill)
		if not table.contains(types, arr_type) then
			return nil
		end
		local array = ffi.new(("%s[%d]"):format(arr_type, size))
		if fill and type(fill) == 'number' then
			for i = 0, size - 1 do
				array[i] = fill
			end
		end
		return array
	end
end