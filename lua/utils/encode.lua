local M = {}

function M.encode()
	local visual_selection = require("visual_selection")
	local base64 = require("base64")

	local selected_text = visual_selection.get()
	local encoded_text = base64.encode(selected_text)

	visual_selection.replace(encoded_text)
end

return M
