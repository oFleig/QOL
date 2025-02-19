extends Control

var label
var current_combo = "0"

func _ready():
	label = Label.new()
	if self.grow_horizontal == Control.GROW_DIRECTION_BEGIN:
		label.ALIGN_RIGHT
		label.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	add_child(label)

func set_combo(count : String):
	if current_combo == count:
		return
	label.text = ""
	current_combo = count
	if int(current_combo) > 0:
		for i in range(len(current_combo)):
			var digit = int(current_combo[i])
			label.text += str(digit)
		if int(current_combo) == 1:
			label.text += " hit grounded"
		elif int(current_combo) > 1 and int(current_combo) < 6:
			label.text += " hits grounded"
		elif int(current_combo) == 6:
			label.text += " hits grounded"
			# if you are someone curious looking at this code, there is this ifs and elifs here because the 6th hit had custom text too
