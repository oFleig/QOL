extends Node

func _init(modLoader = ModLoader):
	modLoader.installScriptExtension("res://QOL/HudLayer.gd")
	modLoader.installScriptExtension("res://QOL/SteamLobby.gd")
	
	var file = File.new()
	if file.file_exists("res://SoupModOptions/ModOptions.gd"):
		modLoader.installScriptExtension("res://QOL/Options.gd")

