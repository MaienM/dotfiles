local function is_crop(vf_entry)
	return vf_entry.name == "crop" or vf_entry.name == "lavfi"
end

local function get_label_group(vf_entry)
	if vf_entry.label == nil then
		return tostring(vf_entry)
	end
	local name = vf_entry.label
	name = string.lower(name)
	if string.find(name, ' ') then
		name = string.sub(name, 1, string.find(name, ' ') - 1)
	end
	return name
end

local function do_cycle_crop(filter)
	local vf_table = mp.get_property_native("vf")
	local last_was_active = true
	local next_active_idx = nil
	if #vf_table > 0 then
		for i = #vf_table, 1, -1 do
			if is_crop(vf_table[i]) then
				if last_was_active and filter(vf_table[i]) then
					next_active_idx = i
					last_was_active = false
				end
				if vf_table[i].enabled then
					last_was_active = true
					next_active_idx = nil
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

local last_label_group = nil

local function cycle_crop()
	last_label_group = nil
	do_cycle_crop(function(vf_entry) 
		return true
	end)
end

local function cycle_crop_in_group()
	local label_group = last_label_group
	local vf_table = mp.get_property_native("vf")
	if #vf_table > 0 then
		for i = #vf_table, 1, -1 do
			if is_crop(vf_table[i]) then
				if vf_table[i].enabled then
					label_group = get_label_group(vf_table[i])
					break
				end
			end
		end
	end
	if label_group == nil then
		return
	end
	last_label_group = label_group

	do_cycle_crop(function(vf_entry)
		return get_label_group(vf_entry) == label_group
	end)
end

mp.add_key_binding(nil, "cycle-crop", cycle_crop)
mp.add_key_binding(nil, "cycle-crop-in-group", cycle_crop_in_group)
