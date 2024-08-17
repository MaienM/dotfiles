vim.g.mylsp.setup('bashls', {
	settings = {
		bashIde = {
			-- ExplainCMD integration. There is a docker container to run this locally, but
			-- 1) This doesn't seem to work, all requests just result in a generic error after 30 seconds.
			-- 2) Starting this isn't automated yet, which kinda sucks. Perhaps once home-manager has support for oci containers it can be managed using this.
			-- podman run --rm -d -e HOST_IP=0.0.0.0 -p 30608:5000 ghcr.io/idank/idank/explainshell:sha-0b660cf@sha256:2691b4caf68d062bcf66b0c87241bca52ec2c2bfa57049ed4678a90b2b0f417d
			-- explainshellEndpoint = 'http://localhost:30608/',

			shfmt = {
				binaryNextLine = true,
				caseIndent = true,
				spaceRedirects = true,
			},
		},
	},
})

local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.diagnostics.zsh)

-- bashls integrates shellcheck, but it doesn't offer an action to ignore an error yet.
null_ls.register(require('none-ls-shellcheck.code_actions'))
