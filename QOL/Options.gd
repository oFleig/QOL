extends "res://SoupModOptions/ModOptions.gd"

func _ready():

	# this is getting big, maybe some dropdowns to separate categories would help? idk -F
	var qol_config_menu = generate_menu("QOL", "Quality Of Life")

	qol_config_menu.add_label("qol-title", "Options")
	qol_config_menu.add_label("--warning toggle--", "Disable this to make all hud changes the vanilla", Label.ALIGN_LEFT, Color.slategray)
	qol_config_menu.add_bool("mod_on", "Enable Mod", true)
	
	qol_config_menu.add_label("divider-1", "")

	qol_config_menu.add_label("--options hp--", "HP Options", Label.ALIGN_LEFT, Color.slategray)
	qol_config_menu.add_bool("hp_display", "Show HP Number", true)
	qol_config_menu.add_bool("hp_color", "HP Number Color Based On HP Left", true)
	qol_config_menu.add_bool("hp_accurate", "Accurate HP", false)
	qol_config_menu.add_bool("hp_divider", "Separate HP by Sections With Lines", true)
	
	qol_config_menu.add_label("divider-2", "")
	
	qol_config_menu.add_label("--options sadness--", "Sadness Options", Label.ALIGN_LEFT, Color.slategray)
	qol_config_menu.add_bool("sadness_on", "Show Sadness Value", true)
	qol_config_menu.add_bool("sadness_percentage", "Sadness Value as 0-100 percentage", false)

	qol_config_menu.add_label("divider-3", "")
	
	qol_config_menu.add_label("--options misc--", "Misc Options", Label.ALIGN_LEFT, Color.slategray)
	qol_config_menu.add_bool("super_label", "Show Super Number", true)
	qol_config_menu.add_bool("proration_on", "Show Proration Value On Hit", true)
	qol_config_menu.add_bool("whiff_line_on", "Show Whiff Line on BURST bar", true)
	qol_config_menu.add_bool("launcher_on", "Show grounded hits before forced launch", false)
	qol_config_menu.add_bool("char_name_on_bar", "Show Character Name On Health Bar", false)
	qol_config_menu.add_bool("ready_and_hit_on", "Show Ready In and Hit @ Labels", true)
	
	qol_config_menu.add_label("divider-4", "")

	qol_config_menu.add_label("--options win--", "WIN Options", Label.ALIGN_LEFT, Color.slategray)	
	var names_dropdown = qol_config_menu.add_dropdown_menu("win_text", "Win Text Style")
	names_dropdown.add_item("Default")
	names_dropdown.add_item("No Text On WIN")
	names_dropdown.add_item("Character Names On WIN")
	names_dropdown.add_item("Player Names On WIN")
	names_dropdown.add_item("Custom Text On WIN")
	qol_config_menu.add_string_single("custom_win_text", "Custom Win Text (select option above)", "")

	add_menu(qol_config_menu)
