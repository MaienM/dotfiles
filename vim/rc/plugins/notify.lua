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

-- NotificationWrapper {{{

local NotificationWrapper = {}

function NotificationWrapper:new(...)
	local nw = {}
	setmetatable(nw, self)
	self.__index = self
	nw:init(...)
	return nw
end

function NotificationWrapper:init(data, replaces)
	if replaces ~= nil then
		self._record = replaces._record
	end

	self._has_progress_bar = data.percentage ~= nil

	self._data = {}
	self:update(data)
end

function NotificationWrapper:update(data)
	-- Replace the previous notification created by this wrapper.
	assert(data.replace == nil, "data may not contain replace key")
	data.replace = self._record

	-- Check whether there is a body. If we need to inherit this from the previous data we want to be sure we use the
	-- original body, without the progress bar added, since otherwise we'd end up with multiple progress bars,
	if data.body == nil then
		data.body = self._data.orig_body or ""
		data.orig_body = data.body
	end

	-- Inherit properties from previous data. nvim-notify does this automatically when replacing a notification, but noice does not.
	for k, v in pairs(self._data) do
		if data[k] == nil then
			data[k] = v
		end
	end
	-- data.notify_id = nil

	-- Add progress bar to body.
	if self._has_progress_bar then
		data.body = self:render_progress_bar(data.percentage) .. (#data.body > 0 and ("\n" .. data.body) or "")
	end

	self._data = data
	self._record = vim.notify(data.body, data.level, data)
end

NotificationWrapper.SPINNER_FRAMES = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
NotificationWrapper.SPINNER_SPEED = 1000;
function NotificationWrapper:start_spinner()
	self._spinner_index = 0
	self:_tick_spinner()
end

function NotificationWrapper:stop_spinner()
	self._spinner_index = nil
end

function NotificationWrapper:_tick_spinner()
	if self._spinner_index == nil then
		return
	end

	self._spinner_index = (self._spinner_index + 1) % #self.SPINNER_FRAMES
	self:update({
		icon = self.SPINNER_FRAMES[self._spinner_index],
	})

	vim.defer_fn(function()
		self:_tick_spinner()
	end, self.SPINNER_SPEED / #self.SPINNER_FRAMES)
end

NotificationWrapper.PROGRESS_BAR_WIDTH = 20
NotificationWrapper.PROGRESS_BAR_SYMBOLS = { " ", "▏", "▎", "▍", "▌", "▋", "▊", "▉", "█" }
NotificationWrapper.PROGRESS_BAR_CAPSTONES = { "▒", "▒" }
function NotificationWrapper:render_progress_bar(percentage)
	local segment = 100 / self.PROGRESS_BAR_WIDTH
	local full = math.floor(percentage / segment)
	local empty = self.PROGRESS_BAR_WIDTH - full - 1;
	local remainder_as_fraction_of_segment = (percentage - full * segment) / segment;
	local remainder_symbol_index = math.floor(remainder_as_fraction_of_segment * #self.PROGRESS_BAR_SYMBOLS + 0.5) + 1
	return 
		self.PROGRESS_BAR_CAPSTONES[1]
		.. string.rep(self.PROGRESS_BAR_SYMBOLS[#self.PROGRESS_BAR_SYMBOLS], full)
		.. self.PROGRESS_BAR_SYMBOLS[remainder_symbol_index]
		.. string.rep(self.PROGRESS_BAR_SYMBOLS[1], empty)
		.. self.PROGRESS_BAR_CAPSTONES[2]
end

-- }}}

-- NotificationManager {{{

local NotificationManager = {}
NotificationManager._wrappers = {}
NotificationManager._previous = {}

function NotificationManager:create(key, data)
	assert(self._wrappers[key] == nil, "A notification already exists with key " .. key)
	self._wrappers[key] = NotificationWrapper:new(data, self._previous[key])

	if data.icon == nil then
		self._wrappers[key]:start_spinner()
	end
end

function NotificationManager:update(key, data)
	assert(self._wrappers[key] ~= nil, "No notification exists with key " .. key)
	self._wrappers[key]:update(data)
end

function NotificationManager:finish(key, data)
	assert(self._wrappers[key] ~= nil, "No notification exists with key " .. key)

	if data.icon == nil then
		data.icon = ""
	end
	if data.body == nil then
		data.body = "Finished"
	end
	if data.percentage == nil then
		data.percentage = 100
	end
	if data.timeout == nil then
		data.timeout = 3000
	end

	self._wrappers[key]:stop_spinner()
	self._wrappers[key]:update(data)

	self._previous[key] = self._wrappers[key]
	self._wrappers[key] = nil
end

-- }}}

-- LSP / DAP {{{
-- Based on https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes

local function format_title(title, client_id)
	local client_name = vim.lsp.get_client_by_id(client_id).name
	return client_name .. (#title > 0 and ": " .. title or "")
end

--see: https://microsoft.github.io/language-server-protocol/specifications/specification-current/#progress
vim.lsp.handlers["$/progress"] = function(_, result, ctx)
	local val = result.value
	if not val.kind then
		return
	end

	local client_id = ctx.client_id
	local key = "lsp::" .. client_id .. "::" .. result.token

	if val.kind == "begin" then
		NotificationManager:create(key, {
			title = format_title(val.title, client_id),
			body = val.message,
			percentage = val.percentage,
			level = "info",
			timeout = false,
			hide_from_history = false,
		})
	elseif val.kind == "report" then
		NotificationManager:update(key, {
			body = val.message,
			percentage = val.percentage,
		})
	elseif val.kind == "end" then
		NotificationManager:finish(key, {
			body = val.message,
		})
	end
end

local TYPE_TO_LEVEL = {
	"error", -- Error
	"warn", -- Warning
	"info", -- Info
	"debug", -- Log
}
--see: https://microsoft.github.io/language-server-protocol/specifications/specification-current/#window_showMessage
vim.lsp.handlers["window/showMessage"] = function(_, method, params, client_id)
	vim.notify(param.message, TYPE_TO_LEVEL[params.type], { title = format_title(nil, client_id) })
end

-- }}}
