return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "golines", "gofmt" },
				typescriptreact = { "prettier" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
			},
		})
		vim.api.nvim_create_user_command("Format", function()
			require("conform").format({ async = true })
		end, { desc = "Format the current buffer with conform" })
	end,
}
