local Config = require('noice.config')
local Format = require('noice.text.format')
local Manager = require('noice.message.manager')
local Message = require('noice.message')
local Object = require('nui.object')

---@class MyNoiceProgressMessage
---@field message NoiceMessage

local M = Object('MyNoiceProgressMessage')

---@class MyNoiceProgressMessageInitOpts
---@field id string
---@field client string
---@field title string
---@field is_done? fun():boolean

---@param opts MyNoiceProgressMessageInitOpts
function M:init(opts)
	self._done = false
	self._hide = false

	self.message = Message('lsp', 'progress')
	self.message.opts.progress = {
		id = opts.id,
		client = opts.client,
		title = opts.title,
		percentage = 0,
	}
	self.message.opts.keep = function()
		return not self._hide
	end

	do
		local timer = vim.loop.new_timer()
		timer:start(
			0,
			Config.options.lsp.progress.throttle,
			vim.schedule_wrap(function()
				if self._done then
					timer:stop()
					self.message.opts.progress.percentage = 100
					Manager.add(Format.format(self.message, Config.options.lsp.progress.format_done))

					timer:start(1000, 0, function()
						self._hide = true
					end)
				else
					Manager.add(Format.format(self.message, Config.options.lsp.progress.format))
				end
			end)
		)
	end

	if opts.is_done ~= nil then
		local timer = vim.loop.new_timer()
		timer:start(
			500,
			500,
			vim.schedule_wrap(function()
				if self._done then
					timer:stop()
					return
				end

				if opts.is_done() then
					timer:stop()
					self._done = true
				end
			end)
		)
	end
end

---@class MyNoiceProgressMessageProgressOpts
---@field percentage? number
---@field title? string
---@field message? string

---@param opts MyNoiceProgressMessageProgressOpts
---@param done boolean
function M:progress(opts, done)
	if self._done then
		return
	end

	self.message.opts.progress = vim.tbl_extend('force', self.message.opts.progress, opts)
	self._done = done
end

return M
