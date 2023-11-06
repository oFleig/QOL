extends "res://SoupModOptions/ModOptions.gd"

func _ready():
	var qol_config_menu = generate_menu("QOL", "Quality Of Life")

	qol_config_menu.add_label("qol-title", "Options")
	qol_config_menu.add_label("divider-1", "")
	qol_config_menu.add_bool("mod_on", "Enable Mod", true)
	qol_config_menu.add_label("divider-2", "")
	qol_config_menu.add_bool("hp_display", "Show HP Number", true)
	qol_config_menu.add_bool("hp_color", "HP Number Color Based On HP Left", true)
	qol_config_menu.add_bool("hp_accurate", "Accurate HP", false)
	qol_config_menu.add_label("divider-3", "")
	qol_config_menu.add_bool("proration_on", "Show Proration Value On Hit", true)
	qol_config_menu.add_bool("sadness_on", "Show Sadness Value", true)
	qol_config_menu.add_bool("guts_on", "Show GUTS Reductions Over HP Bar", true)
	qol_config_menu.add_bool("beep_on", "Beep Once Per Game At 10s Timer", true)
	qol_config_menu.add_label("divider-4", "")
	qol_config_menu.add_bool("player_names", "Player Names On WIN", true)

	add_menu(qol_config_menu)
