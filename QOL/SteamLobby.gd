
extends "res://ui/SteamLobby/SteamLobby.gd"

var auto_cancel = false
var btn

func _ready():
	btn = CheckButton.new()
	btn.text = "Auto Reject Match Requests"
	btn.margin_right = 152
	btn.margin_bottom = 12
	btn.rect_size = Vector2(152,12)

	btn.connect("pressed", self, "on_auto_cancel_pressed")

	$"%GameSettingsPanelContainer".get_parent().add_child(btn)
	$"%GameSettingsPanelContainer".get_parent().move_child(btn, 1)

func show():
	.show()
	if Global.VERSION.find("Ranked")!=-1:
		btn.visible = false
		auto_cancel = false
		btn.enabled = false

func on_auto_cancel_pressed():
	auto_cancel = !auto_cancel

func _on_received_challenge(steam_id):
	print("### YOU DARE TO CHALLENGE ME????")
	if auto_cancel == true:
		_on_challenge_decline_pressed()
		print("### DENIED!!!!")
	else:
		print("### ill let it this time...")
		$"%ChallengeLabel".text = Steam.getFriendPersonaName(steam_id) + " has challenged you."
		$"%ChallengeDialogScreen".show()
		if visible:
			$ChallengeSound.play()
