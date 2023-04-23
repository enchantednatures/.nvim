local M = {}

function M.decode()
	local visual_selection = require("utils.visual_selection")
	local base64 = require("utils.base64")

	local selected_text = visual_selection.get()
	local decoded_text = base64.decode(selected_text)

	if not decoded_text then
		print("Error decoding base64")
		return
	end

	visual_selection.replace(decoded_text)
end

return M
