" Automatically creating bindings when in a supported file.
let g:lsc_auto_map = 1

" The LSP providers to use.
" Via stdio, because NeoVim does not support TCP yet.
let g:lsc_server_commands = {
	\'javascript': 'javascript-typescript-stdio',
	\'javascript.jsx': 'javascript-typescript-stdio',
	\'typescript': 'javascript-typescript-stdio',
	\'python': {
		\'command': 'pyls',
		\'message_hooks': {
			\'initialize': {
				\'pyls.plugins.pydocstyle.enabled': v:true,
			\},
		\},
	\},
\}

