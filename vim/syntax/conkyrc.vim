" Vim syntax file
" Language:   conkyrc
" Author:     Ciaran McCreesh <ciaranm@gentoo.org>
" Version:    20060307
" Copyright:  Copyright (c) 2005 Ciaran McCreesh
" Licence:    You may redistribute this under the same terms as Vim itself
"

if exists("b:current_syntax")
	finish
endif

syn region ConkyrcComment start=/^\s*#/ end=/$/

syn keyword ConkyrcSetting alignment append_file background border_inner_margin border_outer_margin border_width color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 colorN cpu_avg_samples default_bar_size default_color default_gauge_size default_graph_size default_outline_color default_shade_color default_vbar_size disable_auto_reload diskio_avg_samples display double_buffer draw_borders draw_graph_borders draw_outline draw_shades extra_newline font format_human_readable gap_x gap_y hddtemp_host hddtemp_port http_refresh if_up_strictness imap imlib_cache_flush_interval imlib_cache_size lua_draw_hook_post lua_draw_hook_pre lua_load lua_shutdown_hook lua_startup_hook mail_spool max_port_monitor_connections max_text_width max_user_text maximum_width minimum_size mpd_host mpd_password mpd_port music_player_interval mysql_db mysql_host mysql_password mysql_port mysql_user net_avg_samples no_buffers nvidia_display out_to_console out_to_http out_to_ncurses out_to_stderr out_to_x override_utf8_locale overwrite_file own_window own_window_argb_value own_window_argb_visual own_window_class own_window_colour own_window_hints own_window_title own_window_transparent own_window_type pad_percents pop3 sensor_device short_units show_graph_range show_graph_scale stippled_borders temperature_unit template template0 template1 template2 template3 template4 template5 template6 template7 template8 template9 text text_buffer_size times_in_seconds top_cpu_separate top_name_width total_run_times update_interval update_interval_on_battery uppercase use_spacer use_xft xftalpha xftfont

syn keyword ConkyrcConstant
			\ above
			\ below
			\ bottom_left
			\ bottom_right
			\ bottom_middle
			\ desktop
			\ dock
			\ no
			\ none
			\ normal
			\ override
			\ skip_pager
			\ skip_taskbar
			\ sticky
			\ top_left
			\ top_right
			\ top_middle
			\ middle_left
			\ middle_right
			\ middle_middle
			\ undecorated
			\ yes

syn match ConkyrcNumber /\S\@<!\d\+\(\.\d\+\)\?\(\S\@!\|}\@=\)/
			\ nextgroup=ConkyrcNumber,ConkyrcColour skipwhite
syn match ConkyrcColour /\S\@<!#[a-fA-F0-9]\{6\}\(\S\@!\|}\@=\)/
			\ nextgroup=ConkyrcNumber,ConkyrcColour skipwhite

syn region ConkyrcText start=/^TEXT$/ end=/\%$/ contains=ConkyrcVar

syn region ConkyrcVar start=/\${/ end=/}/ contained contains=ConkyrcVarStuff
syn region ConkyrcVar start=/\$\w\@=/ end=/\W\@=\|$/ contained contains=ConkyrcVarName

syn match ConkyrcVarStuff /{\@<=/ms=s contained nextgroup=ConkyrcVarName

syn keyword ConkyrcVarName contained nextgroup=ConkyrcNumber,ConkyrcColour skipwhite color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 template0 template1 template2 template3 template4 template5 template6 template7 template8 template9

hi def link ConkyrcComment   Comment
hi def link ConkyrcSetting   Keyword
hi def link ConkyrcConstant  Constant
hi def link ConkyrcNumber    Number
hi def link ConkyrcColour    Special

hi def link ConkyrcText      String
hi def link ConkyrcVar       Identifier
hi def link ConkyrcVarName   Keyword

let b:current_syntax = "conkyrc"
