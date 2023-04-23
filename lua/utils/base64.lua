local M = {}

local function system_base64(action, input)
	if action == "encode" or action == "decode" then
		local cmd = (action == "encode") and "base64" or "base64 -d"
		local output = vim.fn.system(cmd, input)

		if vim.v.shell_error ~= 0 then
			print("Error during base64 " .. action)
			return nil
		end

		return output
	else
		print("Invalid action: " .. action)
		return nil
	end
end

function M.encode(input)
	return system_base64("encode", input)
end

function M.decode(input)
	return system_base64("decode", input)
end

return M
