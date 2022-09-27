local git = {}

function git.plugins(use)
	use("airblade/vim-gitgutter")
end

function git.setup()
	vim.api.nvim_create_user_command("Changes", "GitGutterQuickFix | copen", {})
end

return git
