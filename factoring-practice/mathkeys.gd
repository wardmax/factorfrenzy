extends Control

var line_edit = null
@onready var keyboard = $keyscontainer

func _ready() -> void:
	line_edit = get_tree().get_first_node_in_group("textbox")
	# Connect all buttons inside the keyboard to one function
	for cont1 in keyboard.get_children():
		for cont2 in cont1.get_children():
			for key in cont2.get_children():
				if key is Button:
					key.pressed.connect(_on_key_pressed.bind(key))
					key.focus_mode = Control.FOCUS_NONE  # prevent buttons stealing focus

func _on_key_pressed(button: Button) -> void:
	var caret = line_edit.caret_column
	
	match button.name:
		"backspace":
			if caret > 0:
				line_edit.text = line_edit.text.substr(0, caret - 1) + line_edit.text.substr(caret)
				line_edit.caret_column = caret - 1
		
		"left":
			if caret > 0:
				line_edit.caret_column = caret - 1
		
		"right":
			if caret < line_edit.text.length():
				line_edit.caret_column = caret + 1
		
		_:
			# Insert at caret instead of always at the end
			line_edit.text = line_edit.text.substr(0, caret) + button.text + line_edit.text.substr(caret)
			line_edit.caret_column = caret + button.text.length()
	
	# Keep focus on the LineEdit
	line_edit.grab_focus()
	print(line_edit.caret_column)
