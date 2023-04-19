local M = {}

function M.setup()
	local dap = require("dap")
	dap.adapters.firefox = {
		type = "executable",
		command = "node",
		args = { os.getenv("HOME") .. "source/vscode-firefox-debug/dist/adapter.bundle.js" },
	}
	dap.configurations.typescriptreact = {
		{
			name = "Debug with Firefox",
			type = "firefox",
			request = "launch",
			reAttach = true,
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			firefoxExecutable = "/usr/bin/firefox",
		},
	}
end

return M
