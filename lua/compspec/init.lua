local M = {}

local function hashComputerName()
	local computerName = vim.fn.substitute(vim.fn.hostname(), "\\.", "_", "g")
	local hash = vim.fn.sha256(computerName)
	local lettersOnly = hash:gsub("%d", "")
	return lettersOnly
end

local function contains(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

local function mergeAndRemoveDuplicates(table1, table2)
	local resultTable = {}
	for _, value in ipairs(table1) do
		table.insert(resultTable, value)
	end
	for _, value in ipairs(table2) do
		if not contains(resultTable, value) then
			table.insert(resultTable, value)
		end
	end

	return resultTable
end

function M.ensureTSPackages(table)
	local computerName = hashComputerName()
	local tsconfig = require("nvim-treesitter.configs")
	local mergedTable = mergeAndRemoveDuplicates(table[computerName]["treesitter"], table["DEFAULT"]["treesitter"])
	tsconfig.setup({
		ensure_installed = mergedTable,
	})
end

return M
