return {
	"NeogitOrg/neogit",
	lazy = true,
	cmd = "Neogit",
	keys = {
		{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
	},
	opts = {
		signs = {
			hunk = { "▶", "▼" },
			item = { "▶", "▼" },
			section = { "▶", "▼" },
		},
		graph_style = "unicode",
	},
}
