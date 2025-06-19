return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"j-hui/fidget.nvim",
	},
	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = {
					adapter = "qwen",
				},
				inline = {
					adapter = "qwen",
				},
				cmd = {
					adapter = "qwen",
				},
			},
			adapters = {
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						env = {
							api_key = "YOUR_ATHROPIC_API_KEY_HERE",
						},
					})
				end,
				qwen = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "qwen",
						schema = {
							model = {
								default = "qwen2.5:32b",
							},
						},
					})
				end,
			},
		})
		local progress = require("fidget.progress")
		local handles = {}
		local group = vim.api.nvim_create_augroup("CodeCompanionFidget", {})

		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeCompanionRequestStarted",
			group = group,
			callback = function(e)
				handles[e.data.id] = progress.handle.create({
					title = "CodeCompanion",
					message = "Thinking...",
					lsp_client = { name = e.data.adapter.formatted_name },
				})
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeCompanionRequestFinished",
			group = group,
			callback = function(e)
				local h = handles[e.data.id]
				if h then
					h.message = e.data.status == "success" and "Done" or "Failed"
					h:finish()
					handles[e.data.id] = nil
				end
			end,
		})
	end,
}
