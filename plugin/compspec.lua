vim.api.nvim_create_user_command("GetHostName", function()
	print(require("compspec").hashComputerName())
end, {})
