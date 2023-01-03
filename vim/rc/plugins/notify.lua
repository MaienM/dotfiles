require('notify').setup{
	stages = "slide",
}

-- Theme {{{

function set_group_color(group, color)
	vim.cmd("highlight Notify" .. group .. "Border guifg=#" .. color)
	vim.cmd("highlight Notify" .. group .. "Icon guifg=#" .. color)
	vim.cmd("highlight Notify" .. group .. "Title guifg=#" .. color)
end

function theme_hook()
	set_group_color("ERROR", vim.g.base16_gui08)
	set_group_color("WARN", vim.g.base16_gui0A)
	set_group_color("INFO", vim.g.base16_gui0C)
	set_group_color("DEBUG", vim.g.base16_gui0D)
	set_group_color("TRACE", vim.g.base16_gui0E)
end

vim.fn.RegisterThemeHook(theme_hook)

-- }}}
