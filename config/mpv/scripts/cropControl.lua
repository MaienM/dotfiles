function cycle_crop()
	local vf_table = mp.get_property_native("vf")
	local last_was_active = true
	local next_active_idx = null
	if #vf_table > 0 then
		for i = #vf_table, 1, -1 do
			if vf_table[i].name == "crop" or vf_table[i].name == "lavfi" then
				if last_was_active then
					next_active_idx = i
					last_was_active = false
				end
				if vf_table[i].enabled then
					last_was_active = true
					next_active_idx = null
				end
				vf_table[i].enabled = false
			end
		end
	end
	if next_active_idx then
		vf_table[next_active_idx].enabled = true
	end
	mp.set_property_native("vf", vf_table)
end

mp.add_key_binding(nil, "cycle-crop", cycle_crop)
