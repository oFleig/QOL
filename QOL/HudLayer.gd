extends "res://ui/HUD/HudLayer.gd"

var hp_mul = 10
var mod_on = true
var hp_on = true
var hp_color = true
var beep_on = true
var proration_on = true
var sadness_on = true
var guts_on = true
var player_names = false

var p1_health_amount
var p2_health_amount

var p1_sad_label
var p2_sad_label

var p1_proration_label
var p2_proration_label

var guts_holder
var p1_guts
var p2_guts

func init(game):
	.init(game)
	
	# Guts
	if !guts_holder == null:
		return
	guts_holder = Control.new()
	guts_holder.margin_right = 40.0
	guts_holder.margin_bottom = 40.0
	guts_holder.visible = false
	$HudLayer.add_child_below_node(get_node("/root/Main/HudLayer/HudLayer/VBoxContainer"), guts_holder)

	if !p1_guts == null:
		return
	p1_guts = TextureRect.new()
	p1_guts.texture = ModLoader.textureGet("res://QOL/images/p1_guts.png")
	p1_guts.margin_left = 341
	p1_guts.margin_top = 19
	p1_guts.margin_right = 569
	p1_guts.margin_bottom = 59
	guts_holder.add_child(p1_guts)

	if !p2_guts == null:
		return
	p2_guts = TextureRect.new()
	p2_guts.texture = ModLoader.textureGet("res://QOL/images/p2_guts.png")
	p2_guts.margin_left = 71
	p2_guts.margin_top = 19
	p2_guts.margin_right = 299
	p2_guts.margin_bottom = 59
	guts_holder.add_child(p2_guts)

	# Health Display	
	if !p1_health_amount == null:
		return
	p1_health_amount = Label.new()
	p1_health_amount.name = "P1HP"
	p1_health_amount.margin_left = 5
	$"%P1HealthBar".add_child(p1_health_amount)
	
	if !p2_health_amount == null:
		return
	p2_health_amount = Label.new()
	p2_health_amount.name = "P2HP"
	p2_health_amount.anchor_left = 1
	p2_health_amount.anchor_right = 1
	p2_health_amount.margin_right = -5
	p2_health_amount.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	$"%P2HealthBar".add_child(p2_health_amount)
	
	# Sadness Display
	if !p1_sad_label == null:
		return
	p1_sad_label = Label.new()
	p1_sad_label.name = "P1SDNSS"
	p1_sad_label.rect_position = Vector2(0, 35)
	p1_sad_label.margin_left = 0
	p1_sad_label.anchor_left = 0.5
	p1_sad_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
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
	p1_proration_label.rect_position = Vector2(0, 130)
	p1_proration_label.margin_left = 3.5
	$"%P1Portrait".add_child(p1_proration_label)
	
	if !p2_proration_label == null:
		return
	p2_proration_label = Label.new()
	p2_proration_label.name = "P2PRTION"
	p2_proration_label.rect_position = Vector2(0, 130)
	p2_proration_label.margin_right = -3.5
	p2_proration_label.ALIGN_RIGHT
	p2_proration_label.anchor_left = 1
	p2_proration_label.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	p2_proration_label.modulate = Color("#ff7a81")
	$"%P2Portrait".add_child(p2_proration_label)
	
	# Whiff Line
	$"%P1BurstMeter".add_child(load("res://QOL/P1WhiffLine.tscn").instance())
	$"%P2BurstMeter".add_child(load("res://QOL/P2WhiffLine.tscn").instance())

func on_game_won(winner):
	$"HudAnimationPlayer".play("game_won")
	$"%WinLabel".autowrap = true
	if winner == 0:
		$"%WinLabel".text = "DRAW"
	else :
		$"%WinLabel".text = (game.match_data.user_data["p"+str(winner)].to_upper() if player_names else "P"+str(winner))+" WIN"+("S" if player_names else "")
	SteamHustle.record_winner(winner)

var beeped = false
func _process(delta):
	# checks to see if we are valid to check for the beep
	if not beep_on:
		return
	if !is_instance_valid(game) or ReplayManager.playback:
		beeped = false
		return
	# if we already played the sound or if we are on singleplayer, dont play
	if beeped:
		return
		# grab the challange sound, from the lobby? refactor code later.
	if!has_node("ChallengeSound"):
		var l = load("res://ui/Lobby.tscn").instance()
		var s = l.get_node("ChallengeSound")
		l.remove_child(s)
		add_child(s)
		l.free()
		print(s)
		return
	# get our timer, see if we can check for the time
	var turn_timer = get_parent().get_node("UILayer/P"+str(1 if game.get_player(1).is_you() else 2)+"TurnTimer")
	if turn_timer.paused or turn_timer.time_left <= 0:
		return
	var sound = get_node("ChallengeSound")
	# play the sound
	if turn_timer.time_left <= 10 and sound:
		sound.play()
		beeped = true

func _physics_process(_delta):
	if is_instance_valid(game):
		var file = File.new()
		if file.file_exists("res://SoupModOptions/ModOptions.gd"):
			var modOptions = get_tree().get_root().get_node("Main/ModOptions")
			if modOptions:
					mod_on = modOptions.get_setting("QOL","mod_on")
					if(!mod_on):
						hp_on = false
						proration_on = false
						guts_on = false
						sadness_on = false
						beep_on = false
					else:
						hp_on = modOptions.get_setting("QOL","hp_display")
						hp_color = modOptions.get_setting("QOL","hp_color")
						proration_on = modOptions.get_setting("QOL","proration_on")
						guts_on = modOptions.get_setting("QOL","guts_on")
						sadness_on = modOptions.get_setting("QOL","sadness_on")
						beep_on = modOptions.get_setting("QOL","beep_on")
					if modOptions.get_setting("QOL","hp_accurate") and mod_on:
						hp_mul = 1
					else:
						hp_mul = 10
					player_names = modOptions.get_setting("QOL","player_names")
		
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
		
		p1_sad_label.visible = sadness_on
		p2_sad_label.visible = sadness_on
		p1_sad_label.text = ":( | "+str(p1.penalty)
		p2_sad_label.text = ":( | "+str(p2.penalty)
		
		p1_proration_label.visible = true if p1.combo_count == 1 and proration_on else false
		p2_proration_label.visible = true if p2.combo_count == 1 and proration_on else false
		p1_proration_label.text = "PRT | " + str(p1.combo_proration)
		p2_proration_label.text = "PRT | " + str(p2.combo_proration)

		guts_holder.visible = guts_on
