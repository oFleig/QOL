extends "res://ui/HUD/HudLayer.gd"

var mod_on = true

var hp_mul = 10
var hp_on = true
var hp_color = true

var ready_and_hit_on = true

var beep_on = true
var proration_on = true
var launcher_on = false

var sadness_on = true
var sadness_percentage = false

var hp_divider = true
var whiff_line_on = true

var win_text = 0
var custom_win_text = ""

var char_name_on_bar = false

var super_label = true

var p1_health_holder
var p2_health_holder
var p1_health_amount
var p2_health_amount

var p1_ready_label
var p1_hit_label
var p2_ready_label
var p2_hit_label

var ready_default_text # i hate you ivy

var p1_launch_counter
var p2_launch_counter

var p1_sad_label
var p2_sad_label

var p1_proration_label
var p2_proration_label

var hp_divider_holder
var p1_lines
var p2_lines

var p1_whiff_line
var p2_whiff_line

var p1_bottom_super_label
var p1_top_super_label
var p2_bottom_super_label
var p2_top_super_label

func _ready():
	var basechar = load("res://characters/BaseChar.tscn").instance()
	ready_default_text = basechar.get_node("ActionableLabel").text
	basechar.queue_free()

func init(game):
	.init(game)
	
	# order of render: Player Name - Health - Hit and Ready - Super Label - Divider - Launch Counter - Sadness - Proration - Whiff Line

	var file = File.new()

	# Player Name On HP Bar
	var modOptions = null
	if file.file_exists("res://SoupModOptions/ModOptions.gd"):
		modOptions = get_tree().get_root().get_node("Main/ModOptions")
	if modOptions != null:
		char_name_on_bar = modOptions.get_setting("QOL","char_name_on_bar")
	if char_name_on_bar == true:
		if Network.multiplayer_active and not SteamLobby.SPECTATING:
			$"%P1Username".text = getCharacterName(1)
			$"%P2Username".text = getCharacterName(2)
		elif game.match_data.has("user_data"):
			if game.match_data.user_data.has("p1"):
				$"%P1Username".text = getCharacterName(1)
			if game.match_data.user_data.has("p2"):
				$"%P2Username".text = getCharacterName(2)
	else:
		if Network.multiplayer_active and not SteamLobby.SPECTATING:
			$"%P1Username".text = Network.pid_to_username(1)
			$"%P2Username".text = Network.pid_to_username(2)
		elif game.match_data.has("user_data"):
			if game.match_data.user_data.has("p1"):
				$"%P1Username".text = game.match_data.user_data.p1
			if game.match_data.user_data.has("p2"):
				$"%P2Username".text = game.match_data.user_data.p2


	# Health Display
	if !p1_health_holder == null:
		return
	p1_health_holder = Node2D.new()
	p1_health_holder.name = "P1HH"
	p1_health_holder.z_index = 1
	$"%P1HealthBar".add_child(p1_health_holder)

	if !p1_health_amount == null:
		return
	p1_health_amount = Label.new()
	p1_health_amount.name = "P1HP"
	p1_health_amount.margin_left = 5
	p1_health_holder.add_child(p1_health_amount)
	
	if !p2_health_holder == null:
		return
	p2_health_holder = Node2D.new()
	p2_health_holder.name = "P2HH"
	p2_health_holder.z_index = 1
	p2_health_holder.position.x = 229
	$"%P2HealthBar".add_child(p2_health_holder)

	if !p2_health_amount == null:
		return
	p2_health_amount = Label.new()
	p2_health_amount.name = "P2HP"
	p2_health_amount.anchor_left = 1
	p2_health_amount.anchor_right = 1
	p2_health_amount.margin_right = -5
	p2_health_amount.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	p2_health_holder.add_child(p2_health_amount)

	# Ready and Hit labels
	if !p1_ready_label == null:
		return
	p1_ready_label = Label.new()
	p1_ready_label.name = "P1RL"
	get_node("HudLayer/FeintDisplay/Label").add_child(p1_ready_label)
	p1_ready_label.rect_position = Vector2(0, 25)
	p1_ready_label.rect_size = Vector2(68, 11)
	p1_ready_label.align = Label.ALIGN_LEFT
	
	if !p1_hit_label == null:
		return
	p1_hit_label = Label.new()
	p1_hit_label.name = "P1HL"
	get_node("HudLayer/FeintDisplay/Label").add_child(p1_hit_label)
	p1_hit_label.rect_position = Vector2(0, 35)
	p1_hit_label.rect_size = Vector2(68, 11)
	p1_hit_label.align = Label.ALIGN_LEFT
	p1_hit_label.modulate = Color("#ff333d")
	
	if !p2_ready_label == null:
		return
	p2_ready_label = Label.new()
	p2_ready_label.name = "P2RL"
	get_node("HudLayer/FeintDisplay/Label2").add_child(p2_ready_label)
	p2_ready_label.rect_position = Vector2(0, 25)
	p2_ready_label.rect_size = Vector2(68, 11)
	p2_ready_label.align = Label.ALIGN_RIGHT
	
	if !p2_hit_label == null:
		return
	p2_hit_label = Label.new()
	p2_hit_label.name = "P1HL"
	get_node("HudLayer/FeintDisplay/Label2").add_child(p2_hit_label)
	p2_hit_label.rect_position = Vector2(0, 35)
	p2_hit_label.rect_size = Vector2(68, 11)
	p2_hit_label.align = Label.ALIGN_RIGHT
	p2_hit_label.modulate = Color("#ff333d")

	# Super Labels
	if !p1_bottom_super_label == null:
		return
	p1_bottom_super_label = Label.new()
	p1_bottom_super_label.name = "P1BSP"
	p1_bottom_super_label.margin_left = 4
	p1_bottom_super_label.margin_right = 100
	get_parent().get_node("UILayer/GameUI/BottomBar/ActionButtons/VBoxContainer/P1InfoContainer/P1SuperContainer/P1SuperMeter").add_child(p1_bottom_super_label)
	
	if !p1_top_super_label == null:
		return
	p1_top_super_label = Label.new()
	p1_top_super_label.name = "P1TSP"
	p1_top_super_label.margin_left = 4
	p1_top_super_label.margin_right = 100
	get_parent().get_node("UILayer/GameUI/ActivePlayer/ActivePlayerSuperContainer/ActiveP1SuperContainer/ActiveP1SuperMeter").add_child(p1_top_super_label)
	
	if !p2_bottom_super_label == null:
		return
	p2_bottom_super_label = Label.new()
	p2_bottom_super_label.name = "P2BSP"
	p2_bottom_super_label.margin_left = 0
	p2_bottom_super_label.margin_right = 97
	p2_bottom_super_label.align = Label.ALIGN_RIGHT
	get_parent().get_node("UILayer/GameUI/BottomBar/ActionButtons/VBoxContainer2/P2InfoContainer/P2SuperContainer/P2SuperMeter").add_child(p2_bottom_super_label)
	
	if !p2_top_super_label == null:
		return
	p2_top_super_label = Label.new()
	p2_top_super_label.name = "P2TSP"
	p2_top_super_label.margin_left = 0
	p2_top_super_label.margin_right = 97
	p2_top_super_label.align = Label.ALIGN_RIGHT
	get_parent().get_node("UILayer/GameUI/ActivePlayer/ActivePlayerSuperContainer/ActiveP2SuperContainer/ActiveP2SuperMeter").add_child(p2_top_super_label)
	
	# Divider, old guts
	if !hp_divider_holder == null:
		return
	hp_divider_holder = Control.new()
	hp_divider_holder.name = "HPD"
	hp_divider_holder.margin_right = 40.0
	hp_divider_holder.margin_bottom = 40.0
	hp_divider_holder.visible = false
	$HudLayer.add_child_below_node(get_node("/root/Main/HudLayer/HudLayer/VBoxContainer"), hp_divider_holder)

	if !p1_lines == null:
		return
	p1_lines = TextureRect.new()
	p1_lines.name = "P1LNS"
	p1_lines.texture = ModLoader.textureGet("res://QOL/images/lines_p1.png")
	p1_lines.margin_left = 341
	p1_lines.margin_top = 19
	p1_lines.margin_right = 569
	p1_lines.margin_bottom = 59
	hp_divider_holder.add_child(p1_lines)

	if !p2_lines == null:
		return
	p2_lines = TextureRect.new()
	p2_lines.name = "P2LNS"
	p2_lines.texture = ModLoader.textureGet("res://QOL/images/lines_p2.png")
	p2_lines.margin_left = 71
	p2_lines.margin_top = 19
	p2_lines.margin_right = 299
	p2_lines.margin_bottom = 59
	hp_divider_holder.add_child(p2_lines)
	
	# Launch Counter
	if !p1_launch_counter == null:
		return
	p1_launch_counter = Control.new()
	p1_launch_counter.name = "P1LNCHR"
	p1_launch_counter.rect_position.x = 65
	p1_launch_counter.rect_position.y = 50
	#p1_launch_counter.align = Label.ALIGN_LEFT
	p1_launch_counter.set_script(load("res://QOL/LaunchCounter.gd"))
	$"%P1ComboCounter".add_child(p1_launch_counter)
	
	if !p2_launch_counter == null:
		return
	p2_launch_counter = Control.new()
	p2_launch_counter.name = "P2LNCHR"
	p2_launch_counter.rect_min_size.x = 80
	p2_launch_counter.rect_position.x = -10
	p2_launch_counter.rect_position.y =	50
	p2_launch_counter.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	p2_launch_counter.set_script(load("res://QOL/LaunchCounter.gd"))
	$"%P2ComboCounter".add_child(p2_launch_counter)
	
	# Sadness Display
	if !p1_sad_label == null:
		return
	p1_sad_label = Label.new()
	p1_sad_label.name = "P1SDNSS"
	p1_sad_label.rect_position = Vector2(0, 35)
	p1_sad_label.margin_left = 0
	p1_sad_label.anchor_left = 0.5
	p1_sad_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	if file.file_exists("res://ColoredPortraits/ModMain.gd"):
		p1_sad_label.modulate = Color("#aca2ff")
	$"%P1Portrait".add_child(p1_sad_label)
	
	if !p2_sad_label == null:
		return
	p2_sad_label = Label.new()
	p2_sad_label.name = "P2SDNSS"
	p2_sad_label.rect_position = Vector2(0, 35)
	p2_sad_label.margin_right = 0
	p2_sad_label.ALIGN_RIGHT
	p2_sad_label.anchor_left = 0.5
	p2_sad_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	p2_sad_label.modulate = Color("#ff7a81")
	$"%P2Portrait".add_child(p2_sad_label)
	
	# Proration Display
	if !p1_proration_label == null:
		return
	p1_proration_label = Label.new()
	p1_proration_label.name = "P1PRTION"
	if file.file_exists("res://_DMD/ModMain.gd"):
		p1_proration_label.rect_position = Vector2(0, 140)
	else:
		p1_proration_label.rect_position = Vector2(0, 130)
	p1_proration_label.margin_left = 3.5
	$"%P1Portrait".add_child(p1_proration_label)
	
	if !p2_proration_label == null:
		return
	p2_proration_label = Label.new()
	p2_proration_label.name = "P2PRTION"
	if file.file_exists("res://_DMD/ModMain.gd"):
		p2_proration_label.rect_position = Vector2(0, 140)
	else:
		p2_proration_label.rect_position = Vector2(0, 130)
	p2_proration_label.margin_right = -3.5
	p2_proration_label.ALIGN_RIGHT
	p2_proration_label.anchor_left = 1
	p2_proration_label.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	p2_proration_label.modulate = Color("#ff7a81")
	$"%P2Portrait".add_child(p2_proration_label)
	
	# Whiff Line
	if !p1_whiff_line == null:
		return
	p1_whiff_line = TextureProgress.new()
	p1_whiff_line.nine_patch_stretch = true
	var p1_gradient = GradientTexture.new()
	p1_gradient.gradient = load("res://QOL/whiffGradient.tres")
	p1_whiff_line.texture_progress = p1_gradient
	load("res://QOL/whiffGradient.tres")
	# min = 0 - 0, max = 1 - 2027
	var whiff_pos1 = 0.75
	p1_whiff_line.texture_progress_offset.x = float(whiff_pos1 * 2027)
	p1_whiff_line.value = 1
	p1_whiff_line.margin_left = 1
	p1_whiff_line.margin_top = 1
	p1_whiff_line.margin_right = 2049
	p1_whiff_line.margin_bottom = 7
	p1_whiff_line.rect_position = Vector2(1,1)
	p1_whiff_line.rect_size = Vector2(2048,6)
	p1_whiff_line.rect_scale = Vector2(0.048,1)
	$"%P1BurstMeter".add_child(p1_whiff_line)
	
	if !p2_whiff_line == null:
		return
	p2_whiff_line = TextureProgress.new()
	p2_whiff_line.nine_patch_stretch = true
	var p2_gradient = GradientTexture.new()
	p2_gradient.gradient = load("res://QOL/whiffGradient.tres")
	p2_whiff_line.texture_progress = p2_gradient
	# min = 0 - 0, max = 1 - 2027
	var whiff_pos2 = 0.75
	p2_whiff_line.texture_progress_offset.x = -(float((whiff_pos2 * 2027) - 2027))
	p2_whiff_line.value = 1
	p2_whiff_line.margin_left = 1
	p2_whiff_line.margin_top = 1
	p2_whiff_line.margin_right = 2049
	p2_whiff_line.margin_bottom = 7
	p2_whiff_line.rect_position = Vector2(1,1)
	p2_whiff_line.rect_size = Vector2(2048,6)
	p2_whiff_line.rect_scale = Vector2(0.048,1)
	$"%P2BurstMeter".add_child(p2_whiff_line)

func on_game_won(winner):
	$"HudAnimationPlayer".play("game_won")
	$"%WinLabel".autowrap = true
	SteamHustle.record_winner(winner)
	
	var type = int(win_text)

	if winner == 0:
		if type == 1:
			$"%WinLabel".text = ""
		else:
			$"%WinLabel".text = "DRAW"
	else :
		match type:
			0:
				$"%WinLabel".text = "P"+str(winner)+" WIN"
			1:
				$"%WinLabel".text = ""
			2:
				$"%WinLabel".text = getCharacterName(winner).to_upper()+" WINS"
			3:
				$"%WinLabel".text = game.match_data.user_data["p"+str(winner)].to_upper()+" WINS"
			4:
				$"%WinLabel".text = custom_win_text
			_:
				$"%WinLabel".text = "WHAT"

func getCharacterName(var id = 1): #Returns a string with the character name.
	var name = find_parent("Main").match_data.selected_characters[id]["name"] #Grabs the character's name.
	#Modified from Bard's code to be multihustle friendly.
	#And modified again from PPT to accomodate for my stage code lmao. - Fleig
	#AND modified again for QOL jesus i need to stop. - Fleig
	#Is the same as it appears in the character select menu.

	#When mods are exported to be built in the main game, their file name changes, so the below code trims it appropriately.
	var filter = name.rfind("__") 
	
	if filter != -1:
		filter += 2
		name = name.right(filter)
	
	#====================================
	
	return name

func _input(ev):
	if (Global.current_game == null):
		return;

	if Input.is_key_pressed(KEY_KP_ADD):
		Global.current_game.zoom_in()
	if Input.is_key_pressed(KEY_KP_SUBTRACT):
		Global.current_game.zoom_out()
		

func _physics_process(_delta):
	if is_instance_valid(game):
		var file = File.new()
		if file.file_exists("res://SoupModOptions/ModOptions.gd"):
			var modOptions = get_tree().get_root().get_node("Main/ModOptions")
			if modOptions:
					mod_on = modOptions.get_setting("QOL","mod_on")
					if(!mod_on):
						hp_on = false
						hp_color = false
						proration_on = false
						hp_divider = false
						sadness_on = false
						sadness_percentage = false
						whiff_line_on = false
						launcher_on = false
						win_text = 0
						custom_win_text = ""
						char_name_on_bar = false
						ready_and_hit_on = false
						super_label = false
					else:
						hp_on = modOptions.get_setting("QOL","hp_display")
						hp_color = modOptions.get_setting("QOL","hp_color")
						proration_on = modOptions.get_setting("QOL","proration_on")
						hp_divider = modOptions.get_setting("QOL","hp_divider")
						sadness_on = modOptions.get_setting("QOL","sadness_on")
						sadness_percentage = modOptions.get_setting("QOL","sadness_percentage")
						whiff_line_on = modOptions.get_setting("QOL","whiff_line_on")
						launcher_on = modOptions.get_setting("QOL","launcher_on")
						win_text = modOptions.get_setting("QOL","win_text")
						custom_win_text = modOptions.get_setting("QOL","custom_win_text")
						char_name_on_bar = modOptions.get_setting("QOL","char_name_on_bar")
						ready_and_hit_on = modOptions.get_setting("QOL","ready_and_hit_on")
						super_label = modOptions.get_setting("QOL","super_label")
					if modOptions.get_setting("QOL","hp_accurate") and mod_on:
						hp_mul = 1
					else:
						hp_mul = 10
		
		# Just to move stuff around a bit
		if sadness_on:
			$"%P1ComboCounter".get_parent().margin_top = 80
			$"%P1ShowStyle".get_parent().rect_position.y = 68
		else:
			$"%P1ComboCounter".get_parent().margin_top = 56
			$"%P1ShowStyle".get_parent().rect_position.y = 48
		if proration_on:
			$"%P1SadnessLabel".rect_position.y = 161
			$"%P2SadnessLabel".rect_position.y = 161
		else:
			$"%P1SadnessLabel".rect_position.y = 151
			$"%P2SadnessLabel".rect_position.y = 151
		
		p1_health_amount.visible = hp_on
		p2_health_amount.visible = hp_on
		p1_health_amount.text = str(max(p1.hp, 0)*hp_mul)+" | "+str(p1.MAX_HEALTH*hp_mul)
		var normalized_p1hp = float(p1.hp) / float(p1.MAX_HEALTH)
		p1_health_amount.modulate = Color(1, normalized_p1hp, normalized_p1hp, 1) if hp_color else  Color(1, 1, 1, 1)
		p2_health_amount.text = str(max(p2.hp, 0)*hp_mul)+" | "+str(p2.MAX_HEALTH*hp_mul)
		var normalized_p2hp = float(p2.hp) / float(p2.MAX_HEALTH)
		p2_health_amount.modulate = Color(1, normalized_p2hp, normalized_p2hp, 1) if hp_color else  Color(1, 1, 1, 1)
		
		if ready_and_hit_on:
			if Global.current_game.ghost_game != null:
				p1_ready_label.text = Global.current_game.ghost_game.p1.actionable_label.text
				if p1_ready_label.text == ready_default_text:
					p1_ready_label.text = ""
				else:
					p1_ready_label.text = p1_ready_label.text.replace("\n", " ")
				
				p1_hit_label.text = Global.current_game.ghost_game.p1.hit_frame_label.text
				if p1_hit_label.text == "hit @ xf ":
					p1_hit_label.text = ""
				
				p2_ready_label.text = Global.current_game.ghost_game.p2.actionable_label.text
				if p2_ready_label.text == ready_default_text:
					p2_ready_label.text = ""
				else:
					p2_ready_label.text = p2_ready_label.text.replace("\n", " ")
				
				p2_hit_label.text = Global.current_game.ghost_game.p2.hit_frame_label.text
				if p2_hit_label.text == "hit @ xf ":
					p2_hit_label.text = ""
					
			else:
				p1_ready_label.text = ""
				p1_hit_label.text = ""
				p2_ready_label.text = ""
				p2_hit_label.text = ""
		else:
			p1_ready_label.text = ""
			p1_hit_label.text = ""
			p2_ready_label.text = ""
			p2_hit_label.text = ""
		
		if launcher_on:
			p1_launch_counter.set_combo(str(p2.grounded_hits_taken))
			p2_launch_counter.set_combo(str(p1.grounded_hits_taken))
		
		p1_sad_label.visible = sadness_on
		p2_sad_label.visible = sadness_on

		if(!sadness_percentage):
			p1_sad_label.text = ":( | "+str(p1.penalty)
			p2_sad_label.text = ":( | "+str(p2.penalty)
		else:
			var p1_penalty_normalized = (float(p1.penalty) - float(p1.MIN_PENALTY)) / (float(p1.MAX_PENALTY) - float(p1.MIN_PENALTY))
			var p2_penalty_normalized = (float(p2.penalty) - float(p2.MIN_PENALTY)) / (float(p2.MAX_PENALTY) - float(p2.MIN_PENALTY))

			p1_sad_label.text = ":( | "+str(stepify(p1_penalty_normalized * 100, 0.1))+"%"
			p2_sad_label.text = ":( | "+str(stepify(p2_penalty_normalized * 100, 0.1))+"%"
		
		p1_proration_label.visible = true if p1.combo_count == 1 and proration_on else false
		p2_proration_label.visible = true if p2.combo_count == 1 and proration_on else false
		p1_proration_label.text = "PRT | " + str(p1.combo_proration)
		p2_proration_label.text = "PRT | " + str(p2.combo_proration)

		hp_divider_holder.visible = hp_divider
		
		p1_whiff_line.visible = whiff_line_on
		p2_whiff_line.visible = whiff_line_on
		
		p1_top_super_label.visible = super_label
		p1_bottom_super_label.visible = super_label
		p2_bottom_super_label.visible = super_label
		p2_top_super_label.visible = super_label
		p1_top_super_label.text = str(p1.super_meter) + " | " + str(p1.MAX_SUPER_METER)
		p1_bottom_super_label.text = str(p1.super_meter) + " | " + str(p1.MAX_SUPER_METER)
		p2_top_super_label.text = str(p2.super_meter) + " | " + str(p2.MAX_SUPER_METER)
		p2_bottom_super_label.text = str(p2.super_meter) + " | " + str(p2.MAX_SUPER_METER)

