if !has('nvim')
	finish
endif

lua require('indent_blankline').setup {
	char = '',
	buftype_exclude = {'terminal'}
}
