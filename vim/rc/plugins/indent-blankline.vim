if !has('nvim')
	finish
endif

au SourcePost * hi IndentBlanklineCharNormal ctermfg=252
au SourcePost * hi IndentBlanklineCharCurrent ctermfg=3

lua <<END
	require('indent_blankline').setup {
		buftype_exclude = {'terminal'},

		char = '🭱',
		char_highlight_list = {"IndentBlanklineCharNormal"},
		show_first_indent_level = false,

		show_current_context = true,
		context_highlight_list = {"IndentBlanklineCharCurrent"},
	}
END
