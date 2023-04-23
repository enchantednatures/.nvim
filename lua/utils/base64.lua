local M = {}

function M.encode(input)
	local output, _, err = vim.fn.systemlist("echo '" .. input:gsub("'", [['"'"']]) .. "' | base64 -w 0")

	if err and err ~= "" then
		print("Error decoding base64: " .. err)
		return nil
	end
	return table.concat(output, "\n")
end

function M.decode(input)
	local output, _, err = vim.fn.systemlist("echo '" .. input:gsub("'", [['"'"']]) .. "' | base64 -d")
	if err and err ~= "" then
		print("Error decoding base64: " .. err)
		return nil
	end
	return table.concat(output, "\n")
end

return M
